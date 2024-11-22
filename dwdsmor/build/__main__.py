#!/usr/bin/env python

import argparse
import csv
from datetime import datetime
import lzma
from pathlib import Path
import subprocess

from ..log import logger
from ..tag import all_tags
from ..traversal import Traversal


project_dir = Path(".").resolve()

xsl_dir = project_dir / "share"
grammar_dir = project_dir / "grammar"
lexicon_dir = project_dir / "lexicon"
build_dir = project_dir / "build"


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


def saxon(xsl, *args, **kwargs):
    "Run an XSLT transformation via Saxon-HE."
    return run(
        [
            "java",
            "-Xmx8g",
            "-cp",
            "/usr/share/java/Saxon-HE.jar",
            "net.sf.saxon.Transform",
            f"-xsl:{xsl.as_posix()}",
            "-it",
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


def build_lexicon(edition_dir, force=False):
    "Builds the lexicon for an automaton edition."
    edition_name = edition_dir.name

    aux_dir = edition_dir / "aux"
    src_dir = edition_dir / "wb"
    exclude_file = edition_dir / "exclude.xml"
    sources = (
        list(aux_dir.rglob("*"))
        + list(src_dir.rglob("*"))
        + list(xsl_dir.rglob("*"))
        + [exclude_file]
    )

    edition_build_dir = build_dir / edition_name
    manifest_xml = edition_build_dir / "manifest.xml"
    manifest_log = edition_build_dir / "manifest.log"
    lex_txt = edition_build_dir / "lex.txt"
    lex_log = edition_build_dir / "lex.log"

    if not force and is_current(lex_txt, sources):
        logger.debug("Skip building lexicon '%s'", edition_name)
        return False

    logger.info("Building lexicon '%s'", edition_name)
    edition_build_dir.mkdir(parents=True, exist_ok=True)
    saxon(
        xsl_dir / "dwds2manifest.xsl",
        f"dwds-dir={src_dir.as_posix()}",
        f"aux-dir={aux_dir.as_posix()}",
        f"exclude-file={exclude_file.as_posix()}",
        cwd=edition_dir,
        output_file=manifest_xml,
        log_file=manifest_log,
    )
    lexicon = saxon(
        xsl_dir / "dwds2dwdsmor.xsl",
        f"manifest-file={manifest_xml.as_posix()}",
        cwd=edition_dir,
        log_file=lex_log,
    )
    lex_txt.write_text("\n".join(sorted(set(lexicon.stdout.splitlines()))))
    return True


fst_sources = [
    fst_file
    for fst_file in grammar_dir.rglob("*.fst")
    if not fst_file.name.startswith("dwdsmor-")
]


def build_automaton(edition_dir, automaton_type, force=False):
    "Builds an automaton of the given type and edition."
    edition_name = edition_dir.name

    edition_build_dir = build_dir / edition_name

    lexicon_src = edition_build_dir / "lex.txt"
    automaton_src_tmpl = grammar_dir / f"dwdsmor-{automaton_type}.fst"
    automaton_a = edition_build_dir / f"{automaton_type}.a"
    automaton_ca = edition_build_dir / f"{automaton_type}.ca"
    automaton_compile_log = edition_build_dir / f"{automaton_type}.compile.log"

    sources = [lexicon_src, automaton_src_tmpl, *fst_sources]
    if (
        not force
        and is_current(automaton_a, sources)
        and is_current(automaton_ca, sources)
    ):
        logger.debug("Skip building automaton '%s/%s'", edition_name, automaton_type)
        return False

    logger.info("Building automaton '%s/%s'", edition_name, automaton_type)
    automaton_src = grammar_dir / f"{edition_name}-{automaton_type}.fst"
    try:
        edition_build_dir.mkdir(parents=True, exist_ok=True)
        automaton_src_txt = automaton_src_tmpl.read_text(encoding="utf-8")
        automaton_src_txt = automaton_src_txt.replace(
            '$LEX$ = "dwds.lex"', f'$LEX$ = "{lexicon_src.as_posix()}"'
        )
        automaton_src.write_text(automaton_src_txt, encoding="utf-8")

        run(
            ["fst-compiler-utf8", automaton_src.as_posix(), automaton_a.as_posix()],
            cwd=grammar_dir,
            log_file=automaton_compile_log,
        )
        run(["fst-compact", automaton_a.as_posix(), automaton_ca.as_posix()])
    finally:
        if automaton_src.is_file:
            automaton_src.unlink()
    return True


traversal_automaton_types = {"index"}


def build_traversals(edition_dir, automaton_type, force=False):
    edition_name = edition_dir.name

    edition_build_dir = build_dir / edition_name

    automaton_a = edition_build_dir / f"{automaton_type}.a"
    automaton_traversal = edition_build_dir / f"{automaton_type}.csv.lzma"

    if not force and is_current(automaton_traversal, [automaton_a]):
        logger.debug(
            "Skip building full traversal of '%s/%s'", edition_name, automaton_type
        )
        return False

    logger.info("Building full traversal of '%s/%s'", edition_name, automaton_type)
    with subprocess.Popen(
        ["fst-generate", automaton_a.as_posix()],
        encoding="utf-8",
        stdout=subprocess.PIPE,
    ) as traversals, lzma.open(automaton_traversal, "wt") as traversals_csv:
        table = csv.writer(traversals_csv)
        table.writerow(
            [
                "spec",
                "analysis",
                "surface",
                *all_tags,
            ]
        )
        for traversal_str in traversals.stdout:
            traversal = Traversal.parse(traversal_str.strip())
            table.writerow(
                [
                    traversal.spec,
                    traversal.analysis,
                    traversal.surface,
                    *(getattr(traversal, tt) for tt in all_tags),
                ]
            )
    return True


def stamp_build(edition_dir):
    edition_name = edition_dir.name
    edition_wb_dir = edition_dir / "wb"
    edition_build_dir = build_dir / edition_name

    (edition_build_dir / "GIT_REV").write_text(project_git_rev)
    (edition_build_dir / "GIT_REV_LEX").write_text(git_rev(edition_wb_dir))
    (edition_build_dir / "BUILT").write_text(datetime.utcnow().isoformat())


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog=__package__, description="Build DWDSmor automata."
    )
    arg_parser.add_argument(
        "editions", help="Editions to build (all by default)", nargs="*"
    )
    arg_parser.add_argument(
        "--automaton", help="Automaton type to build (all by default)", action="append"
    )
    arg_parser.add_argument(
        "--force", help="Force building (also current targets)", action="store_true"
    )
    args = arg_parser.parse_args()

    editions = (
        [lexicon_dir / edition for edition in args.editions]
        if len(args.editions or []) > 0
        else lexicon_dir.iterdir()
    )
    automaton_types = (
        args.automaton
        if len(args.automaton or []) > 0
        else ["finite", "index", "lemma", "morph", "root"]
    )
    for edition_dir in editions:
        assert edition_dir.is_dir()
        edition_name = edition_dir.name
        if not has_sources(edition_dir):
            logger.info("Skipping edition '%s' without sources", edition_name)
            continue
        edition_built = build_lexicon(edition_dir, force=args.force)
        for automaton_type in automaton_types:
            edition_built = (
                build_automaton(edition_dir, automaton_type, force=args.force)
                or edition_built
            )
            if automaton_type in traversal_automaton_types:
                edition_built = (
                    build_traversals(edition_dir, automaton_type, force=args.force)
                    or edition_built
                )
        if edition_built:
            stamp_build(edition_dir)
