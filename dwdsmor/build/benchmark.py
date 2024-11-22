#!/usr/bin/env python

import argparse
from collections import Counter, defaultdict
from itertools import islice

from datasets import load_dataset
from tabulate import tabulate
from tqdm import tqdm

from dwdsmor.automaton import Lemmatizer, automata


def ud_de_hdt_tokens():
    sentences = load_dataset(
        "universal_dependencies",
        "de_hdt",
        split="train",
        streaming=True,
        trust_remote_code=True,
    )
    for s in sentences:
        tokens = zip(s["tokens"], s["lemmas"], s["xpos"])
        for token in tokens:
            form, lemma, xpos = token
            if lemma in {"unknown", "NULL"}:
                continue  # remove unknown lemmata
            if "-" in form:
                continue  # remove Bindestrich-Komposita
            yield form, lemma, xpos


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

dwdsmor_pos_tags = {
    k: set((f"+{v}" for v in vs)) for k, vs in ud_to_dwdsmor_pos.items()
}

coverage_headers = [
    "POS",
    "# types",
    "# tokens",
    "% types",
    "% tokens",
    "% types covered",
    "% tokens covered",
]


def compute_coverage(automata, limit=None, show_progress=False):
    lemmatizer = Lemmatizer(automata)
    tokens = ud_de_hdt_tokens()
    if limit is not None:
        tokens = islice(tokens, max(0, limit))
    if show_progress:
        tokens = tqdm(
            tokens, unit="token", desc="Lemmatizing UD/de-hdt", total=(limit or 2700000)
        )
    matches = defaultdict(Counter)
    mismatches = defaultdict(Counter)
    for token in tokens:
        form, lemma, xpos = token
        pos_candidates = {f"+{xpos}"}.union(dwdsmor_pos_tags.get(xpos, {}))
        is_match = lemmatizer(form, pos_candidates) == lemma
        if not is_match and lemmatizer(lemma) is not None:
            # skip tokens where we can analyze the given lemma but not the form:
            # compounds are lemmatized to their basic words in German-UD/HDT
            continue
        registry = matches if is_match else mismatches
        registry[xpos][lemma] += 1

    coverage = []

    total_tokens = 0
    total_types = 0
    total_type_matches = 0
    total_token_matches = 0
    for registry in [matches, mismatches]:
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
        for registry, is_match in [(matches, True), (mismatches, False)]:
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
                tag_types / total_types,
                tag_tokens / total_tokens,
                tag_type_matches / tag_types,
                tag_token_matches / tag_tokens,
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
            total_type_matches / total_types,
            total_token_matches / total_tokens,
        ],
    )
    return coverage


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(
        prog=__package__,
        description="Benchmarks coverage of DWDSmor against German-UD/HDT.",
    )
    arg_parser.add_argument(
        "--limit",
        help="an optional limit for the # of tokens to use for the benchmark",
        type=int,
    )
    args = arg_parser.parse_args()

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

    print(
        tabulate(
            [
                format_coverage(coverage, n == 0)
                for n, coverage in enumerate(
                    compute_coverage(automata(), limit=args.limit, show_progress=True)
                )
            ],
            tablefmt="github",
            headers=coverage_headers,
            colalign=[
                "left",
                "right",
                "right",
                "right",
                "right",
                "right",
                "right",
            ],
        )
    )
