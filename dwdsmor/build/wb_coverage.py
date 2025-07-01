#!/usr/bin/env python

import argparse
import csv
import sys
from collections import Counter, defaultdict, namedtuple
from functools import cache
from pathlib import Path
from typing import Dict
from xml.etree.ElementTree import parse

from tabulate import tabulate
from tqdm import tqdm

from dwdsmor.automaton import automata, editions
from dwdsmor.log import configure_logging


# mapping between relevant DWDS and DWDSmor part-of-speech categories
pos_map = {
    "Adjektiv": {"ADJ"},
    "bestimmter Artikel": {"ART"},
    "Bruchzahl": {"FRAC"},
    "Demonstrativpronomen": {"DEM", "PROADV"},
    "Eigenname": {"NPROP"},
    "Indefinitpronomen": {"INDEF", "ART"},
    "Interrogativpronomen": {"WPRO"},
    "Kardinalzahl": {"CARD"},
    "Ordinalzahl": {"ORD"},
    "partizipiales Adjektiv": {"ADJ"},
    "Personalpronomen": {"PPRO"},
    "Possessivpronomen": {"POSS"},
    "Reflexivpronomen": {"PPRO"},
    "Relativpronomen": {"REL"},
    "reziprokes Pronomen": {"PPRO"},
    "Substantiv": {"NN", "NPROP"},
    "unbestimmter Artikel": {"ART"},
    "Verb": {"V"},
}


@cache
def qn(ln):
    return "{http://www.dwds.de/ns/1.0}" + ln


Entry = namedtuple(
    "Entry",
    ["file", "entry", "lemma", "lidx", "pos", "has_grammar"],
)


def parse_entries(wb_dir, xml_file):
    entries = []
    root = parse(xml_file).getroot()
    for entry, article in enumerate(root.findall(qn("Artikel"))):
        entry += 1
        if article.get("Status") not in {"Red-f", None}:
            continue
        for formspec in article.findall(qn("Formangabe")):
            for spelling in formspec.findall(qn("Schreibung")):
                if spelling.get("Typ") is not None:
                    continue
                lemma = spelling.text or ""
                lemma = lemma.strip()
                # ignore idioms and other syntactically complex units
                if " " in lemma:
                    continue
                lidx = spelling.get("hidx")
                lidx = f"IDX{lidx}" if lidx else ""
                for grammarspec in formspec.findall(qn("Grammatik")):
                    for pos in grammarspec.findall(qn("Wortklasse")):
                        pos = pos.text or ""
                        pos = pos.strip()
                        # ignore extraneous part-of-speech categories:
                        if pos not in pos_map:
                            continue

                        def prop(xpath, grammarspec=grammarspec):
                            for _ in grammarspec.findall(xpath):
                                return True
                            return False

                        def not_prop(xpath, grammarspec=grammarspec):
                            for _ in grammarspec.findall(xpath):
                                return False
                            return True

                        if pos in {"Eigenname", "Substantiv"}:
                            has_grammar = (
                                prop(qn("Genus")) and prop(qn("Genitiv"))
                            ) or prop(qn("Numeruspraeferenz") + "[.='nur im Plural']")
                        elif pos in {
                            "Personalpronomen",
                        }:
                            has_grammar = not_prop(
                                qn("Kasuspraeferenz") + "[.!='im Nominativ']"
                            ) and not_prop(qn("Einschraenkung"))
                        elif pos in {
                            "bestimmter Artikel",
                            "Demonstrativpronomen",
                            "Indefinitpronomen",
                            "Interrogativpronomen",
                            "Possessivpronomen",
                            "Relativpronomen",
                            "unbestimmter Artikel",
                        }:
                            has_grammar = (
                                prop(qn("Genus") + "[.='fem.']")
                                or prop(qn("indeklinabel"))
                            ) and not_prop(
                                qn("Kasuspraeferenz") + "[.!='im Nominativ']"
                            )
                        elif pos == "Verb":
                            has_grammar = (
                                prop(qn("Praesens"))
                                or prop(qn("Praeteritum"))
                                or prop(qn("Partizip_II"))
                                or prop(qn("Auxiliar"))
                            )
                        else:
                            has_grammar = True

                        entries.append(
                            Entry(
                                str(xml_file.relative_to(wb_dir)),
                                entry,
                                lemma,
                                lidx,
                                pos,
                                has_grammar,
                            )
                        )
    return sorted(set(entries))


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog=__package__,
        description="Benchmarks coverage of DWDSmor against the lexicon source.",
    )
    arg_parser.add_argument(
        "-e",
        "--edition",
        choices=editions,
        help="edition to run the benchmark against (default: dwds)",
        type=str,
        default="dwds",
    )
    arg_parser.add_argument(
        "-d", "--debug", help="print coverage data to stdout", action="store_true"
    )
    arg_parser.add_argument(
        "-q", "--quiet", help="do not report progress", action="store_true"
    )
    arg_parser.add_argument(
        "--limit",
        help="number of lexicon entries used for the benchmark (default: all)",
        type=int,
    )
    args = arg_parser.parse_args()
    configure_logging()

    project_dir = Path(".").resolve()
    edition_build_dir = project_dir / "build" / args.edition
    wb_dir = project_dir / "lexicon" / args.edition / "wb"
    wb_xml_files = tuple(sorted(wb_dir.rglob("*.xml")))

    limit = min(max(0, args.limit), len(wb_xml_files)) if args.limit else None
    if limit is not None:
        wb_xml_files = wb_xml_files[:limit]

    assert len(wb_xml_files) > 0, f"No lexicon articles found in {wb_dir}"

    edition_automata = automata(edition_build_dir)
    traversals = edition_automata.traversals()

    aggregated = not args.debug
    report = csv.writer(sys.stdout) if not aggregated else None
    report_header = False
    if report is None:
        if not args.quiet:
            wb_xml_files = tqdm(wb_xml_files, "Processing lexicon articles")

    generated_entries: Dict[str, Dict[bool, int]] = defaultdict(Counter)
    for wb_xml_file in wb_xml_files:
        for entry in parse_entries(wb_dir, wb_xml_file):
            pos_candidates = pos_map[entry.pos]
            generated = False
            for g_traversal in traversals.get(entry.lemma, []):
                if g_traversal.lidx == entry.lidx and g_traversal.pos in pos_candidates:
                    generated = True
                    break
            if entry.has_grammar:
                if aggregated:
                    # skip entries without appropriate grammatical specifications
                    generated_entries[entry.pos][generated] += 1
                if report is not None:
                    if not report_header:
                        report.writerow(
                            (
                                "File",
                                "Entry Number",
                                "Lemma",
                                "Lemma Index",
                                "POS",
                                "Generated",
                            )
                        )
                        report_header = True
                    result_cols = (
                        entry.file,
                        entry.entry,
                        entry.lemma,
                        entry.lidx,
                        entry.pos,
                        "1" if generated else "0",
                    )
                    report.writerow(result_cols)
    if aggregated:
        headers = [
            "POS",
            "Lemmas",
            "% Lemmas",
            "% Generated Lemmas",
        ]
        colalign = ["left", "right", "right", "right"]
        coverage = []

        def pct(v):
            return "{:.2%}".format(v)

        def count(v):
            return "{:,d}".format(v)

        total_entries = 0
        for pos_key in sorted(generated_entries.keys()):
            pos_generated = generated_entries[pos_key][True]
            pos_not_generated = generated_entries[pos_key][False]
            total_entries += pos_generated + pos_not_generated

        total_generated = 0
        for pos_key in sorted(generated_entries.keys()):
            pos_generated = generated_entries[pos_key][True]
            pos_not_generated = generated_entries[pos_key][False]
            pos_total = pos_generated + pos_not_generated
            coverage.append(
                [
                    pos_key,
                    count(pos_total),
                    pct(pos_total / total_entries),
                    pct(pos_generated / pos_total),
                ]
            )
            total_generated += pos_generated

        coverage.insert(
            0,
            [
                "Σ",
                count(total_entries),
                pct(1),
                pct(total_generated / total_entries),
            ],
        )

        print(tabulate(coverage, headers=headers, colalign=colalign, tablefmt="tsv"))
