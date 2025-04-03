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

import dwdsmor
from dwdsmor.log import configure_logging

# mapping between DWDS and DWDSSmor part-of-speech categories
pos_map = {
    "Adjektiv": {"+ADJ"},
    "Adverb": {"+ADV", "+PTCL", "+INTJ", "+CONJ"},
    "bestimmter Artikel": {"+ART"},
    "Bruchzahl": {"+FRAC"},
    "Demonstrativpronomen": {"+DEM", "+PROADV"},
    "Eigenname": {"+NPROP"},
    "Indefinitpronomen": {"+INDEF", "+ART"},
    "Interjektion": {"+INTJ"},
    "Interrogativpronomen": {"+WPRO"},
    "Kardinalzahl": {"+CARD"},
    "Konjunktion": {"+CONJ", "+ADV", "+INTJ"},
    "Ordinalzahl": {"+ORD"},
    "Partikel": {"+PTCL", "+ADV", "+INTJ"},
    "partizipiales Adjektiv": {"+ADJ"},
    "partizipiales Adverb": {"+ADV"},
    "Personalpronomen": {"+PPRO"},
    "Possessivpronomen": {"+POSS"},
    "Präposition": {"+PREP", "+POSTP"},
    "Präposition + Artikel": {"+PREPART", "+PTCL"},
    "Pronominaladverb": {"+PROADV"},
    "Reflexivpronomen": {"+PPRO"},
    "Relativpronomen": {"+REL"},
    "reziprokes Pronomen": {"+PPRO"},
    "Substantiv": {"+NN"},
    "unbestimmter Artikel": {"+ART"},
    "Verb": {"+V"},
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

                        if pos in {"Eigenname", "Substantiv"}:
                            has_grammar = (
                                prop(qn("Genus")) and prop(qn("Genitiv"))
                            ) or prop(qn("Numeruspraeferenz") + "[.='nur im Plural']")
                        elif pos in {
                            "bestimmter Artikel",
                            "Demonstrativpronomen",
                            "Possessivpronomen",
                            "Relativpronomen",
                            "unbestimmter Artikel",
                        }:
                            has_grammar = prop(qn("Genus")) or prop(qn("indeklinabel"))
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
        "--edition",
        help="the edition to run the benchmark against",
        type=str,
        default="open",
    )
    arg_parser.add_argument(
        "--limit",
        help="an optional limit for the # of entries to use for the benchmark",
        type=int,
    )
    arg_parser.add_argument("--summary", help="Summarize coverage", action="store_true")
    args = arg_parser.parse_args()
    configure_logging()
    project_dir = Path(".").resolve()
    automata_dir = project_dir / "build" / args.edition
    wb_dir = project_dir / "lexicon" / args.edition / "wb"
    wb_xml_files = tuple(sorted(wb_dir.rglob("*.xml")))

    limit = min(max(0, args.limit), len(wb_xml_files)) if args.limit else None
    if limit is not None:
        wb_xml_files = wb_xml_files[:limit]

    assert len(wb_xml_files) > 0, f"No lexicon articles found in {wb_dir}"

    automata = dwdsmor.automata(automata_dir)
    analyzer = automata.analyzer()
    traversals = automata.traversals()

    aggregated = args.summary
    report = csv.writer(sys.stdout) if not aggregated else None
    report_header = False
    if report is None:
        wb_xml_files = tqdm(wb_xml_files, "Process lexicon articles")

    grammar_entries: Dict[str, Dict[bool, int]] = defaultdict(Counter)
    analyzed_entries: Dict[str, Dict[bool, int]] = defaultdict(Counter)
    generated_entries: Dict[str, Dict[bool, int]] = defaultdict(Counter)
    for wb_xml_file in wb_xml_files:
        for entry in parse_entries(wb_dir, wb_xml_file):
            pos_candidates = pos_map[entry.pos]
            analyzed = False
            generated = False
            mismatches = []
            for a_traversal in analyzer.analyze(entry.lemma):
                if a_traversal.analysis == entry.lemma:
                    if a_traversal.pos in pos_candidates:
                        analyzed = True
                        break
                mismatches.append((a_traversal.analysis, a_traversal.pos))
            for g_traversal in traversals.get(entry.lemma, []):
                if g_traversal.lidx == entry.lidx and g_traversal.pos in pos_candidates:
                    generated = True
                    break
            if aggregated:
                grammar_entries[entry.pos][entry.has_grammar] += 1
                analyzed_entries[entry.pos][analyzed] += 1
                generated_entries[entry.pos][generated] += 1
            if (
                report is not None
                and entry.has_grammar
                and (not analyzed or not generated)
            ):
                if not report_header:
                    report.writerow(
                        (
                            "File",
                            "File Entry #",
                            "Lemma",
                            "Lemma #",
                            "POS",
                            "Analyzed",
                            "Generated",
                            "Mismatched Analysis…",
                        )
                    )
                    report_header = True
                result_cols = (
                    entry.file,
                    entry.entry,
                    entry.lemma,
                    entry.lidx,
                    entry.pos,
                    "1" if analyzed else "0",
                    "1" if generated else "0",
                )
                mismatch_cols = tuple(
                    (
                        s
                        for mismatch in sorted(set(mismatches))
                        if not analyzed
                        for s in mismatch
                    )
                )
                report.writerow(result_cols + mismatch_cols)
    if aggregated:
        headers = [
            "POS",
            "# entries",
            "% entries",
            "% with grammar",
            "% analyzed",
            "% generated",
        ]
        colalign = ["left", "right", "right", "right", "right", "right"]
        coverage = []

        def pct(v):
            return "{:.2%}".format(v)

        def count(v):
            return "{:,d}".format(v)

        def bold(s):
            return f"**{s}**"

        total_entries = 0
        total_with_grammar = 0
        for pos_key in sorted(grammar_entries.keys()):
            pos_with_grammar = grammar_entries[pos_key][True]
            pos_without_grammar = grammar_entries[pos_key][False]
            total_entries += pos_with_grammar + pos_without_grammar
            total_with_grammar += pos_with_grammar

        total_analyzed = 0
        total_generated = 0
        for pos_key in sorted(grammar_entries.keys()):
            pos_with_grammar = grammar_entries[pos_key][True]
            pos_without_grammar = grammar_entries[pos_key][False]
            pos_total = pos_with_grammar + pos_without_grammar
            pos_analyzed = analyzed_entries[pos_key][True]
            pos_generated = generated_entries[pos_key][True]
            coverage.append(
                [
                    pos_key,
                    count(pos_total),
                    pct(pos_total / total_entries),
                    pct(pos_with_grammar / pos_total),
                    pct(pos_analyzed / pos_total),
                    pct(pos_generated / pos_total),
                ]
            )
            total_analyzed += pos_analyzed
            total_generated += pos_generated
        coverage.insert(
            0,
            [
                "Σ",
                count(total_entries),
                pct(1),
                bold(pct(total_with_grammar / total_entries)),
                bold(pct(total_analyzed / total_entries)),
                bold(pct(total_generated / total_entries)),
            ],
        )
        print(tabulate(coverage, headers=headers, colalign=colalign, tablefmt="github"))
