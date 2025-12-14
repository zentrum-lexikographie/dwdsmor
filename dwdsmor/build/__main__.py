#!/usr/bin/env python

import argparse
import csv
import logging
import lzma
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from shutil import rmtree

from .. import automaton_types
from ..log import configure_logging
from ..tag import all_tags
from ..traversal import Traversal
from ..util import inflected
from .benchmark import coverage_headers, compute_coverage

logger = logging.getLogger("dwdsmor")

project_dir = Path(__file__).parent.parent.parent

xsl_dir = project_dir / "share"
grammar_dir = project_dir / "grammar"
lexicon_dir = project_dir / "lexicon"


def run(cmd, output_file=None, log_file=None, **args):
    "Run a subprocess, optionally redirecting stdout/stderr to files."
    logger.debug("! %s", cmd)

    args["capture_output"] = (
        args["capture_output"]
        if "capture_output" in args
        else (output_file is not None or log_file is not None)
    )

    try:
        result = subprocess.run(
            cmd,
            **args,
            check=True,
            text=True,
            encoding="utf-8",
        )

        if output_file is not None:
            output_file.write_text(result.stdout)
        if log_file is not None:
            log_file.write_text(result.stderr)

        return result
    except subprocess.CalledProcessError as e:
        if output_file is not None and e.stdout is not None:
            output_file.write_text(e.stdout)
        if log_file is not None and e.stderr is not None:
            log_file.write_text(e.stderr)
        raise


def git_rev(git_dir):
    return run(
        ["git", "rev-parse", "--short", "HEAD"], capture_output=True, cwd=git_dir
    ).stdout.strip()


project_git_rev = git_rev(project_dir)


saxon = [
    "java",
    "-Xmx8g",
    "-cp",
    "/usr/share/java/Saxon-HE.jar",
    "net.sf.saxon.Transform",
]


def saxon_with_source_file(xml, xsl, *args, **kwargs):
    "Run an XSLT transformation of an XML source file via Saxon-HE."
    return run(
        [
            *saxon,
            f"-s:{xml.as_posix()}",
            f"-xsl:{xsl.as_posix()}",
            *args,
        ],
        **kwargs,
    )


def saxon_with_initial_template(xsl, *args, **kwargs):
    "Run an XSLT transformation with an initial template via Saxon-HE."
    return run(
        [
            *saxon,
            "-it",
            f"-xsl:{xsl.as_posix()}",
            *args,
        ],
        **kwargs,
    )


def is_current(target, sources):
    "Check whether a target file is current, given the mtime of its sources."
    if not target.exists():
        return False
    target_m_time = target.stat().st_mtime
    return not any((target_m_time < source.stat().st_mtime for source in sources))


def has_sources(edition_dir):
    "Checks whether the source directory of an edition contains XML files."
    src_dir = edition_dir / "wb"
    for _source in src_dir.rglob("*.xml"):
        return True
    return False


def build_lexicon(edition_dir, automata_dir, force=False):
    "Builds the lexicon for an automaton edition."

    aux_dir = edition_dir / "aux"
    src_dir = edition_dir / "wb"
    sources = (
        list(xsl_dir.glob("*.xsl"))
        + list(src_dir.rglob("*.xml"))
        + list(aux_dir.glob("*.xml"))
        + list(edition_dir.glob("exclude.xml"))
    )

    manifest_xml = automata_dir / "manifest.xml"
    manifest_log = automata_dir / "manifest.log"
    lexicon_xml = automata_dir / "lexicon.xml"
    lexicon_log = automata_dir / "lexicon.log"
    lex_fst = automata_dir / "lex.fst"
    lex_log = automata_dir / "lex.log"

    if not force and is_current(manifest_xml, sources):
        logger.debug("Skip building manifest 'manifest.xml'")
        return False

    if not force and is_current(lexicon_xml, sources):
        logger.debug("Skip building intermediate lexicon 'lexicon.xml'")
        return False

    if not force and is_current(lex_fst, sources):
        logger.debug("Skip building lexicon 'lex.fst'")
        return False

    logger.info("Building manifest 'manifest.xml'")
    exclude_file = edition_dir / "exclude.xml"
    xsl_params = [f"dwds-dir={src_dir.as_posix()}"]
    if aux_dir.is_dir():
        xsl_params.append(f"aux-dir={aux_dir.as_posix()}")
    if exclude_file.is_file():
        xsl_params.append(f"exclude-file={exclude_file.as_posix()}")
    saxon_with_initial_template(
        xsl_dir / "dwds2manifest.xsl",
        *xsl_params,
        cwd=edition_dir,
        output_file=manifest_xml,
        log_file=manifest_log,
    )

    logger.info("Building intermediate lexicon 'lexicon.xml'")
    saxon_with_initial_template(
        xsl_dir / "dwds2lexicon.xsl",
        f"manifest-file={manifest_xml.as_posix()}",
        cwd=edition_dir,
        output_file=lexicon_xml,
        log_file=lexicon_log,
    )

    logger.info("Building lexicon 'lex.fst'")
    lex = saxon_with_source_file(
        lexicon_xml,
        xsl_dir / "lexicon2dwdsmor.xsl",
        cwd=edition_dir,
        log_file=lex_log,
    )
    lex_fst.write_text("\n".join(sorted(set(lex.stdout.splitlines()))))
    return True


fst_modules = [fst_file for fst_file in grammar_dir.glob("module_*.fst")]
fst_macros = [fst_file for fst_file in grammar_dir.glob("macro_*.fst")]


def build_automaton(edition_dir, automata_dir, automaton_type, force=False):
    "Builds an automaton of the given type and edition."

    lexicon_src = automata_dir / "lex.fst"
    lexicon_symlink = grammar_dir / "lex.fst"
    automaton_src = grammar_dir / f"{automaton_type}.fst"
    automaton_a = automata_dir / f"{automaton_type}.a"
    automaton_ca = automata_dir / f"{automaton_type}.ca"
    automaton_compile_log = automata_dir / f"{automaton_type}.log"

    sources = [lexicon_src, automaton_src, *fst_modules, *fst_macros]
    if (
        not force
        and is_current(automaton_a, sources)
        and is_current(automaton_ca, sources)
    ):
        logger.debug("Skip building automaton '%s'", automaton_type)
        return False

    logger.info("Building automaton '%s'", automaton_type)
    try:
        automata_dir.mkdir(parents=True, exist_ok=True)
        if lexicon_symlink.is_file():
            lexicon_symlink.unlink()
        lexicon_symlink.symlink_to(lexicon_src)
        run(
            ["fst-compiler-utf8", automaton_src.as_posix(), automaton_a.as_posix()],
            cwd=grammar_dir,
            log_file=automaton_compile_log,
        )
        run(["fst-compact", automaton_a.as_posix(), automaton_ca.as_posix()])
    finally:
        if lexicon_symlink.is_symlink():
            lexicon_symlink.unlink()
    return True


def build_metrics(automata_dir, force=False, quiet=False):
    automaton_ca = automata_dir / "lemma.ca"
    metrics_csv = automata_dir / "lemma.metrics.csv"
    if not force and is_current(metrics_csv, (automaton_ca,)):
        logger.debug("Skip measuring UD/de-hdt coverage for 'lemma'")
        return False
    logger.info("Measuring UD/de-hdt coverage of 'lemma'")
    coverage = compute_coverage(quiet=quiet)
    with metrics_csv.open("wt", encoding="utf-8") as metrics_f:
        csv.writer(metrics_f).writerows((coverage_headers, *coverage))
    return True


traversal_automaton_types = ("index",)


def build_traversals(edition_dir, automata_dir, automaton_type, force=False):
    automaton_a = automata_dir / f"{automaton_type}.a"
    automaton_traversal = automata_dir / f"{automaton_type}.csv.xz"

    if not force and is_current(automaton_traversal, [automaton_a]):
        logger.debug("Skip building full traversal of '%s'", automaton_type)
        return False

    logger.info("Building full traversal of '%s'", automaton_type)
    fst_generate = subprocess.Popen(
        ["fst-generate", "-b", automaton_a.as_posix()],
        stdout=subprocess.PIPE,
    )
    with subprocess.Popen(
        ["sort", "-u"],
        encoding="utf-8",
        stdin=fst_generate.stdout,
        stdout=subprocess.PIPE,
    ) as traversals, lzma.open(automaton_traversal, "wt") as traversals_csv:
        table = csv.writer(traversals_csv)
        table.writerow(
            [
                "spec",
                "analysis",
                "surface",
                "inflected",
                *all_tags,
            ]
        )
        for traversal_str in traversals.stdout:
            surface, spec = traversal_str.split()
            traversal = Traversal.parse(spec)
            table.writerow(
                [
                    spec,
                    traversal.analysis,
                    surface,
                    inflected(spec, surface),
                    *(getattr(traversal, tt) for tt in all_tags),
                ]
            )
    return True


arg_parser = argparse.ArgumentParser(description="Build DWDSmor.")
arg_parser.add_argument(
    "-c", "--clean", help="clean automata dir before build", action="store_true"
)
arg_parser.add_argument(
    "-d",
    "--automata-dir",
    help="directory where built automata are stored",
    type=Path,
    default=str(project_dir / "dwdsmor" / "automata"),
)
arg_parser.add_argument("-e", "--edition", help="edition to build", default="open")
arg_parser.add_argument(
    "-t",
    "--automaton-type",
    choices=automaton_types,
    help="automaton type to build (default: all)",
    action="append",
)
arg_parser.add_argument(
    "-T",
    "--with-traversal",
    help="build full automaton traversal (if applicable)",
    action="store_true",
)
arg_parser.add_argument(
    "-M", "--with-metrics", help="measure UD/de-hdt coverage", action="store_true"
)
arg_parser.add_argument(
    "-f",
    "--force",
    help="force building (also current targets)",
    action="store_true",
)
arg_parser.add_argument(
    "-q", "--quiet", help="do not report progress", action="store_true"
)
args = arg_parser.parse_args()
configure_logging()

edition = args.edition
edition_dir = lexicon_dir / edition
build_automaton_types = args.automaton_type if args.automaton_type else automaton_types
assert edition_dir.is_dir()
assert has_sources(edition_dir), f"Edition {str(edition_dir)} without sources"

automata_dir = args.automata_dir.resolve()
if automata_dir.is_dir() and args.clean:
    logger.info("Cleaning build dir '%s'", automata_dir)
    rmtree(automata_dir)

logger.info("Building edition '%s' @ '%s'", edition, str(automata_dir))
automata_dir.mkdir(parents=True, exist_ok=True)

build_time = datetime.now(timezone.utc).isoformat()
edition_built = build_lexicon(edition_dir, automata_dir, force=args.force)
for automaton_type in build_automaton_types:
    edition_built = (
        build_automaton(edition_dir, automata_dir, automaton_type, force=args.force)
        or edition_built
    )
    if automaton_type in traversal_automaton_types and args.with_traversal:
        edition_built = (
            build_traversals(
                edition_dir, automata_dir, automaton_type, force=args.force
            )
            or edition_built
        )
if edition_built:
    if args.with_metrics:
        build_metrics(automata_dir, force=args.force, quiet=args.quiet)
    (automata_dir / "BUILT").write_text(build_time)
    (automata_dir / "EDITION").write_text(edition)
    (automata_dir / "GIT_REV").write_text(project_git_rev)
