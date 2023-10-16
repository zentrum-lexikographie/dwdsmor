#!/usr/bin/env python3
# dwdsmor.py - analyse word forms with DWDSmor
# Gregor Middell and Andreas Nolda 2023-10-16
# with contributions by Adrien Barbaresi

import sys
import argparse
import re
import csv
import json
import yaml
from os import path, getcwd
from collections import namedtuple
from functools import cached_property

from blessings import Terminal

import sfst_transduce


version = 8.5


BASEDIR = path.dirname(__file__)

LIBDIR = path.join(BASEDIR, "lib")

LIBFILE = path.join(LIBDIR, "dwdsmor.ca")


PROCESSES = {"COMP", "DER", "CONV"}

MEANS = {"concat", "hyph", "ident", "part", "pref", "suff"}


Component = namedtuple("Component", ["lemma", "tags"])


class Analysis(tuple):

    def __new__(cls, analysis, components):
        inst = tuple.__new__(cls, components)
        inst.analysis = analysis
        return inst

    @cached_property
    def lemma(self):
        lemma = "".join(analysis.lemma for analysis in self)
        return lemma

    @cached_property
    def seg(self):
        analysis = self.analysis
        for process in PROCESSES:
            analysis = re.sub("<" + process + ">", "", analysis)
        for means in MEANS:
            analysis = re.sub("<" + means + r"(?:\([^>]+\))?(?:\|[^>]+)?" + ">", "", analysis)
        analysis = re.sub(r"(?:<IDX[1-5]>)?", "", analysis)
        analysis = re.sub(r"(?:<PAR[1-5]>)?", "", analysis)
        analysis = re.sub(r"<\+[^>]+>.*", "", analysis)
        if analysis == r"\:":
            analysis = ":"
        return analysis

    @cached_property
    def tags(self):
        tags = [tag for analysis in self for tag in analysis.tags]
        return tags

    @cached_property
    def lemma_index(self):
        return next((int(tag[3:]) for tag in self.tags if re.fullmatch(r"IDX[1-5]", tag)), None)

    @cached_property
    def paradigm_index(self):
        return next((int(tag[3:]) for tag in self.tags if re.fullmatch(r"PAR[1-5]", tag)), None)

    @cached_property
    def pos(self):
        return next((tag[1:] for tag in self.tags if re.match(r"\+.", tag)), None)

    @cached_property
    def process(self):
        if [tag for tag in self.tags if tag in PROCESSES]:
            return "∘".join(tag for tag in reversed(self.tags) if tag in PROCESSES)

    @cached_property
    def means(self):
        if [tag for tag in self.tags if re.sub(r"(?:\(.+\))?(?:\|.+)?", "", tag) in MEANS]:
            return "∘".join(tag for tag in reversed(self.tags) if re.sub(r"(?:\(.+\))?(?:\|.+)?", "", tag) in MEANS)

    _subcat_tags = {"Pers": True, "Refl": True, "Def": True, "Indef": True, "Neg": True,
                    "Coord": True, "Sub": True, "Compar": True, "Comma": True, "Period": True,
                    "Ellip": True, "Quote": True, "Paren": True, "Dash": True, "Slash": True}

    _auxiliary_tags = {"haben": True, "sein": True}

    _degree_tags = {"Pos": True, "Comp": True, "Sup": True}

    _person_tags = {"1": True, "2": True, "3": True, "Invar": True}

    _gender_tags = {"Fem": True, "Neut": True, "Masc": True, "NoGend": True, "Invar": True}

    _case_tags = {"Nom": True, "Gen": True, "Dat": True, "Acc": True, "Invar": True}

    _number_tags = {"Sg": True, "Pl": True, "Invar": True}

    _inflection_tags = {"St": True, "Wk": True, "NoInfl": True, "Invar": True}

    _function_tags = {"Attr": True, "Subst": True, "Attr/Subst": True, "Pred/Adv": True, "Invar": True}

    _nonfinite_tags = {"Inf": True, "PPres": True, "PPast": True, "zu": True, "Invar": True}

    _mood_tags = {"Ind": True, "Subj": True, "Imp": True, "Invar": True}

    _tense_tags = {"Pres": True, "Past": True, "Invar": True}

    _metainfo_tags = {"Old": True, "NonSt": True}

    _orthinfo_tags = {"OLDORTH": True, "CH": True}

    _ellipinfo_tags = {"TRUNC": True}

    _charinfo_tags = {"CAP": True}

    def tag_of_type(self, type_map):
        for tag in self.tags:
            if tag in type_map:
                return tag

    @cached_property
    def subcat(self):
        tag = self.tag_of_type(Analysis._subcat_tags)
        return tag

    @cached_property
    def auxiliary(self):
        tag = self.tag_of_type(Analysis._auxiliary_tags)
        return tag

    @cached_property
    def degree(self):
        tag = self.tag_of_type(Analysis._degree_tags)
        return tag

    @cached_property
    def person(self):
        tag = self.tag_of_type(Analysis._person_tags)
        return tag

    @cached_property
    def gender(self):
        tag = self.tag_of_type(Analysis._gender_tags)
        return tag

    @cached_property
    def case(self):
        tag = self.tag_of_type(Analysis._case_tags)
        return tag

    @cached_property
    def number(self):
        tag = self.tag_of_type(Analysis._number_tags)
        return tag

    @cached_property
    def inflection(self):
        tag = self.tag_of_type(Analysis._inflection_tags)
        return tag

    @cached_property
    def function(self):
        tag = self.tag_of_type(Analysis._function_tags)
        return tag

    @cached_property
    def nonfinite(self):
        tag = self.tag_of_type(Analysis._nonfinite_tags)
        return tag

    @cached_property
    def mood(self):
        tag = self.tag_of_type(Analysis._mood_tags)
        return tag

    @cached_property
    def tense(self):
        tag = self.tag_of_type(Analysis._tense_tags)
        return tag

    @cached_property
    def metainfo(self):
        tag = self.tag_of_type(Analysis._metainfo_tags)
        return tag

    @cached_property
    def orthinfo(self):
        tag = self.tag_of_type(Analysis._orthinfo_tags)
        return tag

    @cached_property
    def ellipinfo(self):
        tag = self.tag_of_type(Analysis._ellipinfo_tags)
        return tag

    @cached_property
    def charinfo(self):
        tag = self.tag_of_type(Analysis._charinfo_tags)
        return tag

    def as_dict(self, no_analysis=False, no_segmentation=False, no_index=False, no_wf=False):
        analysis = {"analysis": self.analysis,
                    "lemma": self.lemma,
                    "segmentedlemma": self.seg,
                    "lemma_index": self.lemma_index,
                    "paradigm_index": self.paradigm_index,
                    "process": self.process,
                    "means": self.means,
                    "pos": self.pos,
                    "subcat": self.subcat,
                    "auxiliary": self.auxiliary,
                    "degree": self.degree,
                    "person": self.person,
                    "gender": self.gender,
                    "case": self.case,
                    "number": self.number,
                    "inflection": self.inflection,
                    "function": self.function,
                    "nonfinite": self.nonfinite,
                    "mood": self.mood,
                    "tense": self.tense,
                    "metainfo": self.metainfo,
                    "orthinfo": self.orthinfo,
                    "ellipinfo": self.ellipinfo,
                    "charinfo": self.charinfo}
        if no_analysis:
            del analysis["analysis"]
        if no_segmentation:
            del analysis["segmentedlemma"]
        if no_index:
            del analysis["lemma_index"]
            del analysis["paradigm_index"]
        if no_wf:
            del analysis["process"]
            del analysis["means"]
        return analysis

    def _decode_component_text(text):
        lemma = ""
        text_len = len(text)
        ti = 0
        prev_char = None
        if text == r"\:":
            lemma = ":"
        else:
            while ti < text_len:
                current_char = text[ti]
                nti = ti + 1
                next_char = text[nti] if nti < text_len else None
                if current_char == ":":
                    lemma += prev_char or ""
                    ti += 1
                elif next_char != ":":
                    lemma += current_char
                    ti += 1
                    prev_char = current_char
        return {"lemma": lemma}

    def _decode_analysis(analyses):
        for analysis in re.finditer(r"([^<]*)(?:<([^>]*)>)?", analyses):
            text = analysis.group(1)
            tag = analysis.group(2) or ""
            component = Analysis._decode_component_text(text)
            if tag != "":
                component["tag"] = tag
            yield component

    def _join_tags(components):
        result = []
        current_component = None
        for component in components:
            component = component.copy()
            if current_component is None or component["lemma"] != "":
                component["tags"] = []
                result.append(component)
                current_component = component
            if "tag" in component:
                current_component["tags"].append(component["tag"])
                del component["tag"]
        return result

    def _join_untagged(components):
        result = []
        buf = []
        for component in components:
            buf.append(component)
            if len(component["tags"]) > 0:
                joined = {"lemma": "",
                          "tags": []}
                for component in buf:
                    joined["lemma"] += component["lemma"]
                    joined["tags"] += component["tags"]
                if "+" in component["tags"]:
                    joined["lemma"] += " + "
                result.append(joined)
                buf = []
        if len(buf) > 0:
            result = result + buf
        return result


def parse(analyses):
    component_list = []
    for analysis in analyses:
        components = Analysis._decode_analysis(analysis)
        components = Analysis._join_tags(components)
        components = Analysis._join_untagged(components)
        if components not in component_list:
            component_list.append(components)
            yield Analysis(analysis, [Component(**component) for component in components])


def analyse_word(transducer, word):
    return parse(transducer.analyse(word))


def analyse_words(transducer, words):
    return tuple(analyse_word(transducer, word) for word in words)


def string(value):
    return str(value or "")


def remove_duplicate_analyses(analyses):
    unique_analyses = []
    for analysis in analyses:
        if analysis not in unique_analyses:
            unique_analyses.append(analysis)
    return unique_analyses


def create_word_analyses(words, analyses_tuple,
                         no_analysis=False, no_segmentation=False, no_index=False, no_wf=False):
    word_analyses = []
    for word, analyses in zip(words, analyses_tuple):
        analyses = [analysis.as_dict(no_analysis, no_segmentation, no_index, no_wf) for analysis in analyses]
        unique_analyses = remove_duplicate_analyses(analyses)
        word_analyses.append({"word": word,
                              "analyses": unique_analyses})
    return word_analyses

def output_json(words, analyses_tuple, output_file,
                no_analysis=False, no_segmentation=False, no_index=False, no_wf=False):
    word_analyses = create_word_analyses(words, analyses_tuple,
                                         no_analysis, no_segmentation, no_index, no_wf)
    json.dump(word_analyses, output_file, ensure_ascii=False)


def output_yaml(words, analyses_tuple, output_file,
                no_analysis=False, no_segmentation=False, no_index=False, no_wf=False):
    word_analyses = create_word_analyses(words, analyses_tuple,
                                         no_analysis, no_segmentation, no_index, no_wf)
    yaml.dump(word_analyses, output_file, allow_unicode=True, sort_keys=False, explicit_start=True)


def format_row(analysis, term):
    keys_of_bright_black_values = ["analysis"]
    keys_of_bold_underline_values = ["lemma"]
    keys_of_bright_black_underline_values = ["segmentedlemma"]
    keys_of_underline_values = ["lemma_index",
                                "paradigm_index",
                                "process",
                                "means",
                                "pos",
                                "subcat"
                                "auxiliary"]
    formatted_row = [term.bright_black(string(analysis[key])) if key in keys_of_bright_black_values
                     else term.bold_underline(string(analysis[key])) if key in keys_of_bold_underline_values
                     else term.bright_black_underline(string(analysis[key])) if key in keys_of_bright_black_underline_values
                     else term.underline(string(analysis[key])) if key in keys_of_underline_values
                     else string(analysis[key]) for key in analysis.keys()]
    return formatted_row


def output_dsv(words, analyses_tuple, output_file,
               no_analysis=False, no_segmentation=False, no_index=False, no_wf=False, header=True,
               plain=False, force_color=False, delimiter="\t"):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)
    csv_writer = csv.writer(output_file, delimiter=delimiter, lineterminator="\n")

    if header:
        header_row = [term.bold("Wordform"),
                      term.bright_black("Analysis"),
                      term.bold_underline("Lemma"),
                      term.bright_black_underline("Segmentation"),
                      term.underline("Lemma Index"),
                      term.underline("Paradigm Index"),
                      term.underline("Process"),
                      term.underline("Means"),
                      term.underline("POS"),
                      term.underline("Subcategory"),
                      term.underline("Auxiliary"),
                      "Degree",
                      "Person",
                      "Gender",
                      "Case",
                      "Number",
                      "Inflection",
                      "Function",
                      "Nonfinite",
                      "Mood",
                      "Tense",
                      "Metalinguistic",
                      "Orthography",
                      "Ellipsis",
                      "Characters"]
        if no_analysis:
            header_row.remove(term.bright_black("Analysis"))
        if no_segmentation:
            header_row.remove(term.bright_black_underline("Segmentation"))
        if no_index:
            header_row.remove(term.underline("Lemma Index"))
            header_row.remove(term.underline("Paradigm Index"))
        if no_wf:
            header_row.remove(term.underline("Process"))
            header_row.remove(term.underline("Means"))
        csv_writer.writerow(header_row)

    word_analyses = create_word_analyses(words, analyses_tuple,
                                         no_analysis, no_segmentation, no_index, no_wf)
    for word_analyses_dict in word_analyses:
        for analysis in word_analyses_dict["analyses"]:
            row = [term.bold(word_analyses_dict["word"])] + format_row(analysis, term)
            csv_writer.writerow(row)


def output_analyses(transducer, input_file, output_file,
                    no_analysis=False, no_segmentation=False, no_index=False, no_wf=False, header=True,
                    plain=False, force_color=False, output_format="tsv"):
    words = tuple(word.strip() for word in input_file.readlines() if word.strip())
    analyses_tuple = analyse_words(transducer, words)
    if analyses_tuple:
        if output_format == "json":
            output_json(words, analyses_tuple, output_file,
                        no_analysis, no_segmentation, no_index, no_wf)
        elif output_format == "yaml":
            output_yaml(words, analyses_tuple, output_file,
                        no_analysis, no_segmentation, no_index, no_wf)
        elif output_format == "csv":
            output_dsv(words, analyses_tuple, output_file,
                       no_analysis, no_segmentation, no_index, no_wf, header,
                       plain, force_color, delimiter=",")
        else:
            output_dsv(words, analyses_tuple, output_file,
                       no_analysis, no_segmentation, no_index, no_wf, header,
                       plain, force_color)


def main():
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("input", nargs="?", type=argparse.FileType("r"), default=sys.stdin,
                            help="input file (one word form per line; default: stdin)")
        parser.add_argument("output", nargs="?", type=argparse.FileType("w"), default=sys.stdout,
                            help="output file (default: stdout)")
        parser.add_argument("-c", "--csv", action="store_true",
                            help="output CSV table")
        parser.add_argument("-C", "--force-color", action="store_true",
                            help="preserve color and formatting when piping output")
        parser.add_argument("-H", "--no-header", action="store_false",
                            help="suppress table header")
        parser.add_argument("-I", "--no-index", action="store_true",
                            help="do not output lemma and paradigm index")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-n", "--no-analysis", action="store_true",
                            help="do not output raw analysis")
        parser.add_argument("-N", "--no-segmentation", action="store_true",
                            help="do not output segmented lemma")
        parser.add_argument("-P", "--plain", action="store_true",
                            help="suppress color and formatting")
        parser.add_argument("-t", "--transducer", default=LIBFILE,
                            help=f"path to transducer file (default: {path.relpath(LIBFILE, getcwd())})")
        parser.add_argument("-v", "--version", action="version",
                            version=f"{parser.prog} {version}")
        parser.add_argument("-W", "--no-wf", action="store_true",
                            help="do not output word-formation process and means")
        parser.add_argument("-y", "--yaml", action="store_true",
                            help="output YAML document")
        args = parser.parse_args()

        transducer = sfst_transduce.CompactTransducer(args.transducer)
        transducer.both_layers = False

        if args.json:
            output_format = "json"
        elif args.yaml:
            output_format = "yaml"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"
        output_analyses(transducer, args.input, args.output,
                        args.no_analysis, args.no_segmentation, args.no_index, args.no_wf, args.no_header,
                        args.plain, args.force_color, output_format)
    except KeyboardInterrupt:
        sys.exit(130)
    return 0


if __name__ == "__main__":
    sys.exit(main())
