#!/usr/bin/env python3
# dwdsmor.py - analyse word forms with DWDSmor
# Gregor Middell and Andreas Nolda 2024-10-11
# with contributions by Adrien Barbaresi

import argparse
import csv
import json
import re
import sys
from os import getcwd, path

import sfst_transduce
import yaml
from blessings import Terminal

from .. import analyse_words, generate_words

version = 11.0


LIBDIR = path.join("lib")

LIBFILE = path.join(LIBDIR, "dwdsmor.ca")

LIBFILE2 = path.join(LIBDIR, "dwdsmor-morph.a")


BOUNDARIES_INFL = ["<~>"]

BOUNDARIES_WF = ["<#>", "<->", "<|>"]


LABEL_MAP = {
    "word": "Wordform",
    "analyses": {
        "seg_word": "Segmented Wordform",
        "analysis": "Analysis",
        "lemma": "Lemma",
        "seg_lemma": "Segmented Lemma",
        "lemma_index": "Lemma Index",
        "paradigm_index": "Paradigm Index",
        "process": "Process",
        "means": "Means",
        "pos": "POS",
        "subcat": "Subcategory",
        "auxiliary": "Auxiliary",
        "degree": "Degree",
        "person": "Person",
        "gender": "Gender",
        "case": "Case",
        "number": "Number",
        "inflection": "Inflection",
        "nonfinite": "Nonfinite",
        "function": "Function",
        "mood": "Mood",
        "tense": "Tense",
        "metainfo": "Metalinguistic",
        "orthinfo": "Orthography",
        "ellipinfo": "Ellipsis",
        "charinfo": "Characters",
    },
}


def get_analysis_dict(analysis):
    analysis_dict = {"seg_word": None} | analysis.as_dict()
    return analysis_dict


def get_analysis_dicts(analyses):
    analysis_dicts = [get_analysis_dict(analysis) for analysis in analyses]
    return analysis_dicts


def count_boundaries(seg, boundaries):
    count = sum([seg.count(boundary) for boundary in boundaries])
    return count


def get_minimal_analyses(analyses, key, boundaries):
    minimal_analyses = []
    minimum = min(
        [count_boundaries(analysis[key], boundaries) for analysis in analyses],
        default=-1,
    )
    for analysis in analyses:
        if count_boundaries(analysis[key], boundaries) == minimum:
            minimal_analyses.append(analysis)
    return minimal_analyses


def get_maximal_analyses(analyses, key, boundaries):
    maximal_analyses = []
    maximum = max(
        [count_boundaries(analysis[key], boundaries) for analysis in analyses],
        default=-1,
    )
    for analysis in analyses:
        if count_boundaries(analysis[key], boundaries) == maximum:
            maximal_analyses.append(analysis)
    return maximal_analyses


def get_minimal_analyses_per_pos(analyses, key, boundaries):
    minimal_analyses = []
    # remove duplicates while preserving order
    for pos in list(dict.fromkeys([analysis["pos"] for analysis in analyses])):
        analyses_with_pos = [
            analysis for analysis in analyses if analysis["pos"] == pos
        ]
        analyses_with_pos = get_minimal_analyses(analyses_with_pos, key, boundaries)
        minimal_analyses += analyses_with_pos
    return minimal_analyses


def get_maximal_analyses_per_pos(analyses, key, boundaries):
    maximal_analyses = []
    # remove duplicates while preserving order
    for pos in list(dict.fromkeys([analysis["pos"] for analysis in analyses])):
        analyses_with_pos = [
            analysis for analysis in analyses if analysis["pos"] == pos
        ]
        analyses_with_pos = get_maximal_analyses(analyses_with_pos, key, boundaries)
        maximal_analyses += analyses_with_pos
    return maximal_analyses


def get_matching_seg_words(seg_words, word):
    matching_seg_words = []
    for seg_word in seg_words:
        if re.sub("<.>", "", seg_word) == word:
            matching_seg_words.append(seg_word)
    return matching_seg_words


def get_unique_analyses(analyses):
    unique_analyses = []
    for analysis in analyses:
        if analysis not in unique_analyses:
            unique_analyses.append(analysis)
    return unique_analyses


def get_value_of_analysis_key(key, analysis):
    value = analysis.get(key, "") or ""
    if isinstance(value, int):
        formatted_value = str(value)
    else:
        formatted_value = value
    return formatted_value


def output_json(word_analyses, output_file):
    json.dump(word_analyses, output_file, ensure_ascii=False)


def output_yaml(word_analyses, output_file):
    yaml.dump(
        word_analyses,
        output_file,
        allow_unicode=True,
        sort_keys=False,
        explicit_start=True,
    )


def output_dsv(
    word_analyses,
    output_file,
    keys,
    analyses_keys,
    header=True,
    plain=False,
    force_color=False,
    delimiter="\t",
):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)

    def plain(s):
        return s

    csv_writer = csv.writer(output_file, delimiter=delimiter, lineterminator="\n")

    key_format = {
        "word": term.bold,
        "analyses": {
            "seg_word": term.bright_black,
            "analysis": term.bright_black,
            "lemma": term.bold_underline,
            "seg_lemma": term.bright_black_underline,
            "lemma_index": term.underline,
            "paradigm_index": term.underline,
            "process": term.underline,
            "means": term.underline,
            "pos": term.underline,
            "subcat": term.underline,
            "auxiliary": term.underline,
            "degree": plain,
            "person": plain,
            "gender": plain,
            "case": plain,
            "number": plain,
            "inflection": plain,
            "nonfinite": plain,
            "function": plain,
            "mood": plain,
            "tense": plain,
            "metainfo": plain,
            "orthinfo": plain,
            "ellipinfo": plain,
            "charinfo": plain,
        },
    }

    if header:
        header_row = [key_format[key](LABEL_MAP[key]) for key in keys]
        header_row += [
            key_format["analyses"][key](LABEL_MAP["analyses"][key])
            for key in analyses_keys
        ]
        csv_writer.writerow(header_row)

    for word_analyses_dict in word_analyses:
        for analysis in word_analyses_dict["analyses"]:
            row = [
                key_format[key](get_value_of_analysis_key(key, word_analyses_dict))
                for key in keys
            ]
            row += [
                key_format["analyses"][key](get_value_of_analysis_key(key, analysis))
                for key in analyses_keys
            ]
            csv_writer.writerow(row)


def output_analyses(
    transducer,
    transducer2,
    input_file,
    output_file,
    analysis_string=False,
    seg_word=False,
    seg_lemma=False,
    lemma_index=False,
    paradigm_index=False,
    wf_process=False,
    wf_means=False,
    minimal=False,
    maximal=False,
    empty=True,
    header=True,
    plain=False,
    force_color=False,
    output_format="tsv",
):
    words = tuple(word.strip() for word in input_file.readlines() if word.strip())
    analyses_tuple = analyse_words(transducer, words)
    if analyses_tuple:
        word_analyses = []
        for word, analyses in zip(words, analyses_tuple):
            analyses = get_analysis_dicts(analyses)
            if minimal:
                analyses = get_minimal_analyses_per_pos(
                    analyses, "seg_lemma", BOUNDARIES_WF
                )

            for analysis in analyses:
                if maximal or seg_word:
                    words_tuple = generate_words(transducer2, analysis["analysis"])
                    seg_words = get_matching_seg_words(words_tuple, word)
                    analysis.update({"seg_word": seg_words[0] if seg_words else word})

            if maximal:
                analyses = get_maximal_analyses_per_pos(
                    analyses, "seg_word", BOUNDARIES_INFL
                )
                analyses = get_maximal_analyses_per_pos(
                    analyses, "seg_word", BOUNDARIES_WF
                )

            for analysis in analyses:
                if not seg_word:
                    del analysis["seg_word"]
                if not analysis_string:
                    del analysis["analysis"]
                if not seg_lemma:
                    del analysis["seg_lemma"]
                if not lemma_index:
                    del analysis["lemma_index"]
                if not paradigm_index:
                    del analysis["paradigm_index"]
                if not wf_process:
                    del analysis["process"]
                if not wf_means:
                    del analysis["means"]

                if not empty:
                    for key, value in list(analysis.items()):
                        if not value:
                            del analysis[key]

            analyses = get_unique_analyses(analyses)

            word_analyses.append({"word": word, "analyses": analyses})

        if output_format == "json":
            output_json(word_analyses, output_file)
        elif output_format == "yaml":
            output_yaml(word_analyses, output_file)
        else:
            keys = [key for key, value in LABEL_MAP.items() if isinstance(value, str)]
            analyses_keys = [
                key
                for key, value in LABEL_MAP["analyses"].items()
                if isinstance(value, str)
            ]

            if not analysis_string:
                analyses_keys.remove("analysis")
            if not seg_word:
                analyses_keys.remove("seg_word")
            if not seg_lemma:
                analyses_keys.remove("seg_lemma")
            if not lemma_index:
                analyses_keys.remove("lemma_index")
            if not paradigm_index:
                analyses_keys.remove("paradigm_index")
            if not wf_process:
                analyses_keys.remove("process")
            if not wf_means:
                analyses_keys.remove("means")

            if not empty:
                keys_with_values = set(
                    [
                        key
                        for word_analyses_dict in word_analyses
                        for key, value in word_analyses_dict.items()
                        if isinstance(value, str)
                    ]
                )
                analyses_keys_with_values = set(
                    [
                        key
                        for word_analyses_dict in word_analyses
                        for analysis in word_analyses_dict["analyses"]
                        for key, value in analysis.items()
                        if isinstance(value, (str, int))
                    ]
                )
                keys = [key for key in keys if key in keys_with_values]
                analyses_keys = [
                    key for key in analyses_keys if key in analyses_keys_with_values
                ]

            if output_format == "csv":
                output_dsv(
                    word_analyses,
                    output_file,
                    keys,
                    analyses_keys,
                    header,
                    plain,
                    force_color,
                    delimiter=",",
                )
            else:
                output_dsv(
                    word_analyses,
                    output_file,
                    keys,
                    analyses_keys,
                    header,
                    plain,
                    force_color,
                )


def main():
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument(
            "input",
            nargs="?",
            type=argparse.FileType("r"),
            default=sys.stdin,
            help="input file (one word form per line; default: stdin)",
        )
        parser.add_argument(
            "output",
            nargs="?",
            type=argparse.FileType("w"),
            default=sys.stdout,
            help="output file (default: stdout)",
        )
        parser.add_argument(
            "-a",
            "--analysis-string",
            action="store_true",
            help="output also analysis string",
        )
        parser.add_argument("-c", "--csv", action="store_true", help="output CSV table")
        parser.add_argument(
            "-C",
            "--force-color",
            action="store_true",
            help="preserve color and formatting when piping output",
        )
        parser.add_argument(
            "-E",
            "--no-empty",
            action="store_false",
            help="suppress empty columns or values",
        )
        parser.add_argument(
            "-H", "--no-header", action="store_false", help="suppress table header"
        )
        parser.add_argument(
            "-i",
            "--lemma-index",
            action="store_true",
            help="output also homographic lemma index",
        )
        parser.add_argument(
            "-I",
            "--paradigm-index",
            action="store_true",
            help="output also paradigm index",
        )
        parser.add_argument(
            "-j", "--json", action="store_true", help="output JSON object"
        )
        parser.add_argument(
            "-m",
            "--minimal",
            action="store_true",
            help="prefer lemmas with minimal number of boundaries",
        )
        parser.add_argument(
            "-M",
            "--maximal",
            action="store_true",
            help=(
                "prefer word forms with maximal number of boundaries "
                "(requires supplementary transducer file)"
            ),
        )
        parser.add_argument(
            "-P", "--plain", action="store_true", help="suppress color and formatting"
        )
        parser.add_argument(
            "-s", "--seg-lemma", action="store_true", help="output also segmented lemma"
        )
        parser.add_argument(
            "-S",
            "--seg-word",
            action="store_true",
            help=(
                "output also segmented word form "
                "(requires supplementary transducer file)"
            ),
        )
        parser.add_argument(
            "-t",
            "--transducer",
            default=LIBFILE,
            help=(
                "path to transducer file in compact format "
                f"(default: {path.relpath(LIBFILE, getcwd())})"
            ),
        )
        parser.add_argument(
            "-T",
            "--transducer2",
            default=LIBFILE2,
            help=(
                "path to supplementary transducer file in standard format "
                f"(default: {path.relpath(LIBFILE2, getcwd())})"
            ),
        )
        parser.add_argument(
            "-v", "--version", action="version", version=f"{parser.prog} {version}"
        )
        parser.add_argument(
            "-w",
            "--wf-process",
            action="store_true",
            help="output also word-formation process",
        )
        parser.add_argument(
            "-W",
            "--wf-means",
            action="store_true",
            help="output also word-formation means",
        )
        parser.add_argument(
            "-y", "--yaml", action="store_true", help="output YAML document"
        )
        args = parser.parse_args()

        transducer = sfst_transduce.CompactTransducer(args.transducer)
        transducer.both_layers = False

        transducer2 = sfst_transduce.Transducer(args.transducer2)

        if args.json:
            output_format = "json"
        elif args.yaml:
            output_format = "yaml"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"

        output_analyses(
            transducer,
            transducer2,
            args.input,
            args.output,
            args.analysis_string,
            args.seg_word,
            args.seg_lemma,
            args.lemma_index,
            args.paradigm_index,
            args.wf_process,
            args.wf_means,
            args.minimal,
            args.maximal,
            args.no_empty,
            args.no_header,
            args.plain,
            args.force_color,
            output_format,
        )
    except KeyboardInterrupt:
        sys.exit(130)
    return 0


if __name__ == "__main__":
    sys.exit(main())