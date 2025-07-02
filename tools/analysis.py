#!/usr/bin/env python3
# analysis.py - analyse word forms with DWDSmor
# Andreas Nolda 2025-06-30

import argparse
import csv
import json
import sys
from dataclasses import asdict
from pathlib import Path

from blessings import Terminal

from dwdsmor import automaton, tag

import yaml


progname = Path(__file__).name

version = 14.0


LABEL_MAP = {"word": "Wordform",
             "analyses": {"seg_word": "Segmented Wordform",
                          "spec": "Analysis",
                          "analysis": "Lemma",
                          "seg_lemma": "Segmented Lemma",
                          "lidx": "Lemma Index",
                          "pidx": "Paradigm Index",
                          "processes": "Processes",
                          "means": "Means",
                          "pos": "POS",
                          "category": "Subcategory",
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
                          "syninfo": "Syntax",
                          "ellipinfo": "Ellipsis",
                          "charinfo": "Characters"}}


def analyze_word(analyzer, word, automaton_type=None):
    if automaton_type == "root":
        return analyzer.analyze(word, visible_boundaries="+", boundary_tag=" + ", join_tags=True)
    elif automaton_type == "index":
        return analyzer.analyze(word, idx_to_int=True)
    else:
        return analyzer.analyze(word)


def analyze_words(analyzer, words, automaton_type=None):
    return tuple(analyze_word(analyzer, word, automaton_type) for word in words)


def generate_words(generator, spec):
    return tuple(traversal.spec for traversal in generator.generate(spec))


def seg_lemma(traversal):
    traversal = traversal.reparse(visible_boundaries=tag.boundary_tags)
    return traversal.analysis


def traversal_asdict(traversal):
    analysis_dict = {"seg_word": None, "seg_lemma": seg_lemma(traversal)} | asdict(traversal)
    return analysis_dict


def traversals_asdicts(traversals):
    analysis_dicts = [traversal_asdict(traversal) for traversal in traversals]
    return analysis_dicts


def remove_boundaries(seg, boundaries):
    for boundary in boundaries:
        seg = seg.replace(f"<{boundary}>", "")
    return seg


def count_boundaries(seg, boundaries):
    count = sum([seg.count(boundary) for boundary in boundaries])
    return count


def get_minimal_analyses(analyses, key, boundaries):
    minimal_analyses = []
    minimum = min([count_boundaries(analysis[key], boundaries) for analysis in analyses], default=-1)
    for analysis in analyses:
        if count_boundaries(analysis[key], boundaries) == minimum:
            minimal_analyses.append(analysis)
    return minimal_analyses


def get_maximal_analyses(analyses, key, boundaries):
    maximal_analyses = []
    maximum = max([count_boundaries(analysis[key], boundaries) for analysis in analyses], default=-1)
    for analysis in analyses:
        if count_boundaries(analysis[key], boundaries) == maximum:
            maximal_analyses.append(analysis)
    return maximal_analyses


def get_minimal_analyses_per_pos(analyses, key, boundaries):
    minimal_analyses = []
    # remove duplicates while preserving order
    for pos in list(dict.fromkeys([analysis["pos"] for analysis in analyses])):
        analyses_with_pos = [analysis for analysis in analyses if analysis["pos"] == pos]
        analyses_with_pos = get_minimal_analyses(analyses_with_pos, key, boundaries)
        minimal_analyses += analyses_with_pos
    return minimal_analyses


def get_maximal_analyses_per_pos(analyses, key, boundaries):
    maximal_analyses = []
    # remove duplicates while preserving order
    for pos in list(dict.fromkeys([analysis["pos"] for analysis in analyses])):
        analyses_with_pos = [analysis for analysis in analyses if analysis["pos"] == pos]
        analyses_with_pos = get_maximal_analyses(analyses_with_pos, key, boundaries)
        maximal_analyses += analyses_with_pos
    return maximal_analyses


def get_matching_seg_words(seg_words, word):
    matching_seg_words = []
    for seg_word in seg_words:
        if remove_boundaries(seg_word, tag.boundary_tags) == word:
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


def output_string(string):
    return string


def output_json(word_analyses, output_file):
    json.dump(word_analyses, output_file, ensure_ascii=False)


def output_yaml(word_analyses, output_file):
    yaml.dump(word_analyses, output_file, allow_unicode=True, sort_keys=False, explicit_start=True)


def output_dsv(word_analyses, output_file, keys, analyses_keys,
               header=True, plain=False, force_color=False, delimiter="\t"):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)
    plain = output_string
    csv_writer = csv.writer(output_file, delimiter=delimiter, lineterminator="\n")

    key_format = {"word": term.bold,
                  "analyses": {"seg_word": term.bright_black,
                               "spec": term.bright_black,
                               "analysis": term.bold_underline,
                               "seg_lemma": term.bright_black_underline,
                               "lidx": term.underline,
                               "pidx": term.underline,
                               "processes": term.underline,
                               "means": term.underline,
                               "pos": term.underline,
                               "category": term.underline,
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
                               "syninfo": plain,
                               "ellipinfo": plain,
                               "charinfo": plain}}

    if header:
        header_row = [key_format[key](LABEL_MAP[key]) for key in keys]
        header_row += [key_format["analyses"][key](LABEL_MAP["analyses"][key]) for key in analyses_keys]
        csv_writer.writerow(header_row)

    for word_analyses_dict in word_analyses:
        for analysis in word_analyses_dict["analyses"]:
            row = [key_format[key](get_value_of_analysis_key(key, word_analyses_dict)) for key in keys]
            row += [key_format["analyses"][key](get_value_of_analysis_key(key, analysis)) for key in analyses_keys]
            csv_writer.writerow(row)


def output_analyses(analyzer, generator, input_file, output_file, automaton_type,
                    analysis_string=False, seg_word=False, seg_lemma=False,
                    minimal=False, maximal=False, empty=False,
                    header=True, plain=False, force_color=False, output_format="tsv"):
    words = tuple(word.strip() for word in input_file.readlines() if word.strip())
    traversals_tuple = analyze_words(analyzer, words, automaton_type)

    if traversals_tuple:
        word_analyses = []
        for word, traversals in zip(words, traversals_tuple):
            analyses = traversals_asdicts(traversals)

            if minimal:
                analyses = get_minimal_analyses_per_pos(analyses, "seg_lemma", tag.wf_boundary_tags)

            for analysis in analyses:
                if maximal or seg_word:
                    words_tuple = generate_words(generator, analysis["spec"])
                    seg_words = get_matching_seg_words(words_tuple, word)
                    analysis.update({"seg_word": seg_words[0] if seg_words else word})

            if maximal:
                analyses = get_maximal_analyses_per_pos(analyses, "seg_word", tag.infl_boundary_tags)
                analyses = get_maximal_analyses_per_pos(analyses, "seg_word", tag.wf_boundary_tags)

            for analysis in analyses:
                del analysis["surface"]
                if not seg_word:
                    del analysis["seg_word"]
                if not analysis_string:
                    del analysis["spec"]
                if not seg_lemma:
                    del analysis["seg_lemma"]

                if not empty:
                    for key, value in list(analysis.items()):
                        if not value:
                            del analysis[key]

            analyses = get_unique_analyses(analyses)

            word_analyses.append({"word": word,
                                  "analyses": analyses})

        if output_format == "json":
            output_json(word_analyses, output_file)
        elif output_format == "yaml":
            output_yaml(word_analyses, output_file)
        else:
            keys = [key for key, value in LABEL_MAP.items() if isinstance(value, str)]
            analyses_keys = [key for key, value in LABEL_MAP["analyses"].items() if isinstance(value, str)]

            if not analysis_string:
                analyses_keys.remove("spec")
            if not seg_word:
                analyses_keys.remove("seg_word")
            if not seg_lemma:
                analyses_keys.remove("seg_lemma")

            if not empty:
                keys_with_values = {key for word_analyses_dict in word_analyses
                                    for key, value in word_analyses_dict.items()
                                    if isinstance(value, str)}
                analyses_keys_with_values = {key for word_analyses_dict in word_analyses
                                             for analysis in word_analyses_dict["analyses"]
                                             for key, value in analysis.items()
                                             if isinstance(value, (str, int))}
                keys = [key for key in keys if key in keys_with_values]
                analyses_keys = [key for key in analyses_keys if key in analyses_keys_with_values]

            if output_format == "csv":
                output_dsv(word_analyses, output_file, keys, analyses_keys,
                           header, plain, force_color, delimiter=",")
            else:
                output_dsv(word_analyses, output_file, keys, analyses_keys,
                           header, plain, force_color)


def main():
    try:
        automata_dir = automaton.detect_root_dir()

        parser = argparse.ArgumentParser()
        parser.add_argument("input", nargs="?", type=argparse.FileType("r"), default=sys.stdin,
                            help="input file (one word form per line; default: stdin)")
        parser.add_argument("output", nargs="?", type=argparse.FileType("w"), default=sys.stdout,
                            help="output file (default: stdout)")
        parser.add_argument("-a", "--analysis-string", action="store_true",
                            help="output also analysis string")
        parser.add_argument("-c", "--csv", action="store_true",
                            help="output CSV table")
        parser.add_argument("-C", "--force-color", action="store_true",
                            help="preserve color and formatting when piping output")
        parser.add_argument("-d", "--automata-dir",
                            help=f"automata directory (default: {automata_dir})")
        parser.add_argument("-e", "--empty", action="store_true",
                            help="show empty columns or values")
        parser.add_argument("-H", "--no-header", action="store_false",
                            help="suppress table header")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-m", "--minimal", action="store_true",
                            help="prefer lemmas with minimal number of boundaries")
        parser.add_argument("-M", "--maximal", action="store_true",
                            help="prefer word forms with maximal number of boundaries (requires secondary automaton)")
        parser.add_argument("-P", "--plain", action="store_true",
                            help="suppress color and formatting")
        parser.add_argument("-s", "--seg-lemma", action="store_true",
                            help="output also segmented lemma")
        parser.add_argument("-S", "--seg-word", action="store_true",
                            help="output also segmented word form (requires secondary automaton)")
        parser.add_argument("-t", "--automaton-type", choices=automaton.automaton_types, default="lemma",
                            help="type of primary automaton (default: lemma)")
        parser.add_argument("-T", "--automaton2-type", choices=automaton.automaton_types, default="morph",
                            help="type of secondary automaton (default: morph)")
        parser.add_argument("-v", "--version", action="version",
                            version=f"{parser.prog} {version}")
        parser.add_argument("-y", "--yaml", action="store_true",
                            help="output YAML document")
        args = parser.parse_args()

        automata = automaton.automata(args.automata_dir)
        analyzer = automata.analyzer(args.automaton_type)
        generator = automata.generator(args.automaton2_type)

        if args.json:
            output_format = "json"
        elif args.yaml:
            output_format = "yaml"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"

        output_analyses(analyzer, generator, args.input, args.output, args.automaton_type,
                        args.analysis_string, args.seg_word, args.seg_lemma,
                        args.minimal, args.maximal, args.empty,
                        args.no_header, args.plain, args.force_color, output_format)
    except automaton.AutomataDirNotFound:
        print(f"{progname}: automata directory not found", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(130)
    return 0


if __name__ == "__main__":
    sys.exit(main())
