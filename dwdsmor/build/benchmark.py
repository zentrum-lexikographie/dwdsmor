#!/usr/bin/env python

import argparse
import csv
import sys
from collections import Counter, defaultdict
from itertools import islice
from tabulate import tabulate
from tqdm import tqdm

from .ud import download_hdt
from .. import Lemmatizer
from ..log import configure_logging


ud_to_dwdsmor_pos = {
    "ADJA": {"ORD", "FRAC", "ADJ", "CARD", "INDEF"},
    "ADJD": {"ADJ"},
    "ADV": {"ADJ", "ADV", "PROADV"},
    "APPO": {"POSTP"},
    "APPR": {"PREP"},
    "APPRART": {"PREPART"},
    "APZR": {"ADV", "POSTP", "PREP"},
    "ART": {"ART"},
    "CARD": {"FRAC", "CARD"},
    "FM": {"NN", "ADJ", "PREP"},
    "ITJ": {"INTJ", "ADV"},
    "KOKOM": {"CONJ"},
    "KON": {"CONJ"},
    "KOUI": {"CONJ"},
    "KOUS": {"CONJ"},
    "NE": {"NPROP"},
    "NN": {"NN", "ADJ", "NPROP"},
    "PDAT": {"DEM"},
    "PDS": {"DEM"},
    "PIAT": {"ADJ", "ART", "INDEF", "DEM"},
    "PIDAT": {"ADJ", "INDEF", "DEM"},
    "PIS": {"ADJ", "INDEF", "DEM"},
    "PPER": {"PPRO"},
    "PPOSAT": {"POSS"},
    "PPOSS": {"POSS"},
    "PRELAT": {"REL"},
    "PRELS": {"REL"},
    "PRF": {"PPRO"},
    "PROAV": {"PROADV"},
    "PROP": {"ADV", "PROADV"},
    "PTKA": {"PTCL"},
    "PTKANT": {"INTJ", "PTCL"},
    "PTKNEG": {"PTCL"},
    "PTKVZ": {"ADV", "VPART", "ADJ", "PREP"},
    "PTKZU": {"PTCL"},
    "PWAT": {"WPRO"},
    "PWAV": {"ADV", "PROADV"},
    "PWS": {"WPRO"},
    "TRUNC": {"NN", "V"},
    "VAFIN": {"V"},
    "VAIMP": {"V"},
    "VAINF": {"V"},
    "VAPP": {"V"},
    "VMFIN": {"V"},
    "VMINF": {"V"},
    "VMPP": {"V"},
    "VVFIN": {"V"},
    "VVIMP": {"V"},
    "VVINF": {"V"},
    "VVIZU": {"V"},
    "VVPP": {"V"},
    "XY": {"XY", "NN"},
    "$.": {"PUNCT"},
    "$,": {"PUNCT"},
    "$(": {"PUNCT"},
}

coverage_headers = [
    "POS",
    "Types",
    "Tokens",
    "% Types",
    "% Tokens",
    "% Lemmatized Types",
    "% Lemmatized Tokens",
]


def compute_coverage(round_digits=4, limit=None, debug=False, quiet=False):
    lemmatizer = Lemmatizer()

    def hdt_tokens():
        for sentence in download_hdt():
            for token in sentence:
                lemma = token.get("lemma") or "NULL"
                if lemma in {"unknown", "NULL"}:
                    continue  # remove unknown lemmata
                form = token.get("form") or "-"
                if "-" in form:
                    continue  # remove Bindestrich-Komposita
                pos = token.get("xpos") or "XY"
                yield form, lemma, pos

    tokens = hdt_tokens()
    if limit is not None:
        tokens = islice(tokens, max(0, limit))
    if debug:
        report = csv.writer(sys.stdout)
        report.writerow(("Form", "Lemma", "POS", "Lemmatized"))
    if not debug or quiet:
        tokens = tqdm(tokens, unit="token", desc="Lemmatizing UD/de-hdt", total=limit)
    matches = defaultdict(Counter)
    mismatches = defaultdict(Counter)
    for token in tokens:
        form, lemma, xpos = token
        pos_candidates = ud_to_dwdsmor_pos.get(xpos, set())
        is_match = lemmatizer(form, pos=pos_candidates) is not None
        if not is_match and lemmatizer(lemma) is not None:
            # skip tokens where we can analyze the given lemma but not the form:
            # compounds are lemmatized to their basic words in German-UD/HDT
            continue
        if debug:
            report.writerow((form, lemma, xpos, 1 if is_match else 0))
        registry = matches if is_match else mismatches
        registry[xpos][form] += 1

    coverage = []

    total_tokens = 0
    total_types = 0
    total_type_matches = 0
    total_token_matches = 0
    for registry in (matches, mismatches):
        for _pos_tag, types in registry.items():
            for _type, token_count in types.items():
                total_types += 1
                total_tokens += token_count
    pos_tags = sorted(set(matches.keys()).union(mismatches.keys()))
    for pos_tag in pos_tags:
        tag_tokens = 0
        tag_types = 0
        tag_token_matches = 0
        tag_type_matches = 0
        for registry, is_match in ((matches, True), (mismatches, False)):
            for _type, token_count in registry.get(pos_tag, {}).items():
                tag_types += 1
                tag_tokens += token_count
                if is_match:
                    total_type_matches += 1
                    total_token_matches += token_count
                    tag_type_matches += 1
                    tag_token_matches += token_count
        coverage.append(
            [
                pos_tag,
                tag_types,
                tag_tokens,
                round(tag_types / total_types, round_digits),
                round(tag_tokens / total_tokens, round_digits),
                round(tag_type_matches / tag_types, round_digits),
                round(tag_token_matches / tag_tokens, round_digits),
            ]
        )
    coverage.insert(
        0,
        [
            "",
            total_types,
            total_tokens,
            1,
            1,
            round(total_type_matches / total_types, round_digits),
            round(total_token_matches / total_tokens, round_digits),
        ],
    )
    return coverage


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog=__package__,
        description="Benchmarks coverage of DWDSmor against German-UD/HDT.",
    )
    arg_parser.add_argument(
        "-d", "--debug", help="print coverage data to stdout", action="store_true"
    )
    arg_parser.add_argument(
        "-q", "--quiet", help="do not report progress", action="store_true"
    )
    arg_parser.add_argument(
        "--limit",
        help="number of tokens used for the benchmark (default: all)",
        type=int,
    )
    args = arg_parser.parse_args()
    configure_logging()

    colalign = ["left", "right", "right", "right", "right", "right", "right"]

    def pct(v):
        return "{:.2%}".format(v)

    def count(v):
        return "{:,d}".format(v)

    def format_coverage(pos_coverage, is_total=False):
        (
            pos,
            types_total,
            tokens_total,
            types_ratio,
            token_ratio,
            type_coverage,
            token_coverage,
        ) = pos_coverage
        return [
            "Σ" if is_total else pos,
            count(types_total),
            count(tokens_total),
            pct(types_ratio),
            pct(token_ratio),
            pct(type_coverage),
            pct(token_coverage),
        ]

    coverage = compute_coverage(
        limit=args.limit,
        debug=args.debug,
        quiet=args.quiet,
    )

    if not args.debug:
        print(
            tabulate(
                [
                    format_coverage(coverage, n == 0)
                    for n, coverage in enumerate(coverage)
                ],
                tablefmt="tsv",
                headers=coverage_headers,
                colalign=colalign,
            )
        )
