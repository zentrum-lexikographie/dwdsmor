#!/usr/bin/python3
# dwdsmor.py - analyse word forms with DWDSmor
# Gregor Middell and Andreas Nolda 2022-09-21

import sys
import os
import argparse
import re
import sfst_transduce
import csv
import json
from blessings import Terminal
from collections import namedtuple
from functools import cached_property

version = 6.1

BASEDIR = os.path.dirname(__file__)
LIBDIR  = os.path.join(BASEDIR, "lib")
LIBFILE = os.path.join(LIBDIR, "dwdsmor.ca")

Component = namedtuple("Component", ["form", "lemma", "tags"])

class Analysis(tuple):
    def __new__(cls, analysis, components):
        inst = tuple.__new__(cls, components)
        inst.analysis = analysis
        return inst

    @cached_property
    def form(self):
        return "".join(a.form for a in self)

    @cached_property
    def lemma(self):
        return "".join(a.lemma for a in self)

    @cached_property
    def segmented_lemma(self):
        return re.sub(r"(<IDX[^>]+>)?(<PAR[^>]+>)?<\+[^>]+>.*", "", self.analysis)

    @cached_property
    def tags(self):
        return [tag for a in self for tag in a.tags]

    @cached_property
    def lemma_index(self):
        for tag in self.tags:
            if tag.startswith("IDX"):
                return tag[3:]

    @cached_property
    def paradigm_index(self):
        for tag in self.tags:
            if tag.startswith("PAR"):
                return tag[3:]

    @cached_property
    def pos(self):
        for tag in self.tags:
            if tag.startswith("+"):
                return tag[1:]

    _subcat_tags       = {"Pers": True, "Refl": True, "Def": True, "Indef": True, "Neg": True, "Coord": True, "Sub": True, "Compar": True}
    _auxiliary_tags    = {"haben": True, "sein": True}
    _degree_tags       = {"Pos": True, "Comp": True, "Sup": True}
    _person_tags       = {"1": True, "2": True, "3": True}
    _gender_tags       = {"Fem": True, "Neut": True, "Masc": True, "NoGend": True, "Invar": True}
    _case_tags         = {"Nom": True, "Gen": True, "Dat": True, "Acc": True, "Invar": True}
    _number_tags       = {"Sg": True, "Pl": True, "Invar": True}
    _inflection_tags   = {"St": True, "Wk": True, "NoInfl": True, "Invar": True}
    _function_tags     = {"Attr": True, "Subst": True, "Attr/Subst": True, "Pred/Adv": True}
    _nonfinite_tags    = {"Inf": True, "PPres": True, "PPast": True, "zu": True}
    _mood_tags         = {"Ind": True, "Subj": True, "Imp": True}
    _tense_tags        = {"Pres": True, "Past": True}
    _metainfo_tags     = {"Old": True, "NonSt": True, "CAP": True}

    def tag_of_type(self, type_map):
        for tag in self.tags:
            if tag in type_map:
                return tag

    @cached_property
    def subcat(self):
        return self.tag_of_type(Analysis._subcat_tags)

    @cached_property
    def auxiliary(self):
        return self.tag_of_type(Analysis._auxiliary_tags)

    @cached_property
    def degree(self):
        return self.tag_of_type(Analysis._degree_tags)

    @cached_property
    def person(self):
        return self.tag_of_type(Analysis._person_tags)

    @cached_property
    def gender(self):
        return self.tag_of_type(Analysis._gender_tags)

    @cached_property
    def case(self):
        return self.tag_of_type(Analysis._case_tags)

    @cached_property
    def number(self):
        return self.tag_of_type(Analysis._number_tags)

    @cached_property
    def inflection(self):
        return self.tag_of_type(Analysis._inflection_tags)

    @cached_property
    def function(self):
        return self.tag_of_type(Analysis._function_tags)

    @cached_property
    def nonfinite(self):
        return self.tag_of_type(Analysis._nonfinite_tags)

    @cached_property
    def mood(self):
        return self.tag_of_type(Analysis._mood_tags)

    @cached_property
    def tense(self):
        return self.tag_of_type(Analysis._tense_tags)

    @cached_property
    def metainfo(self):
        return self.tag_of_type(Analysis._metainfo_tags)

    def as_dict(self):
        return {"form": self.form,
                "analysis": self.analysis,
                "lemma": self.lemma,
                "segmentedlemma": self.segmented_lemma,
                "lemma_index": self.lemma_index,
                "paradigm_index": self.paradigm_index,
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
                "metainfo": self.metainfo}

    _empty_component_texts = set(["", ":"])
    _curly_braces_re = re.compile(r"[{}]")

    def _decode_component_text(text):
        lemma = ""
        form  = ""
        text_len = len(text)
        ti = 0
        prev = None
        while ti < text_len:
            current = text[ti]
            nti = ti + 1
            next = text[nti] if nti < text_len else None
            if current == ":":
                lemma += prev or ""
                form  += next or ""
                ti += 1
            elif next != ":":
                lemma += current
                form  += current
            ti += 1
            prev = current
        return {"lemma": lemma, "form": form}

    def _decode_analysis(analysis):
        # "QR-Code" -> "{:<>QR}:<>-<TRUNC>:<>Code<+NN>:<><Masc>:<><Acc>:<><Sg>:<>"
        analysis = Analysis._curly_braces_re.sub("", analysis)
        for a in re.finditer(r"([^<]*)(?:<([^>]*)>)?", analysis):
            text = a.group(1)
            tag  = a.group(2) or ""
            component = Analysis._decode_component_text(text)
            if tag != "":
                component["tag"] = tag
            yield component

    def _join_tags(components):
        result = []
        current = None
        for c in components:
            c = c.copy()
            if current is None or c["form"] != "" or c["lemma"] != "":
                c["tags"] = []
                result.append(c)
                current = c
            if "tag" in c:
                current["tags"].append(c["tag"])
                del c["tag"]
        return result

    def _join_untagged(components):
        result = []
        buf = []
        for c in components:
            buf.append(c)
            if len(c["tags"]) > 0:
                joined = {"lemma": "", "form": "", "tags": []}
                for c in buf:
                    joined["lemma"] += c["lemma"]
                    joined["form"]  += c["form"]
                    joined["tags"]  += c["tags"]
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
        if not components in component_list:
            component_list.append(components)
            yield Analysis(analysis, [Component(**c) for c in components])

def analyse_word(transducer, word):
    return parse(transducer.analyse(word))

def analyse_words(transducer, words):
    return tuple(analyse_word(transducer, word) for word in words)

def string(value):
    return str(value or "")

def output_json(words, analyses, output):
    word_analyses = []
    for word, analysis in zip(words, analyses):
        word_analyses.append({"word": word,
                              "analyses": [a.as_dict() for a in analysis]})
    json.dump(word_analyses, output, ensure_ascii=False)

def output_dsv(words, analyses, output, header=True, force_color=False, delimiter="\t"):
    term = Terminal(force_styling=force_color)
    csv_writer = csv.writer(output, delimiter=delimiter)
    if header:
        csv_writer.writerow([term.bold("Wordform"),
                             term.bright_black("Analysis"),
                             term.bold_underline("Lemma"),
                             term.bright_black_underline("Segmentation"),
                             term.underline("Lemma Index"),
                             term.underline("Paradigm Index"),
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
                             "Metainfo"])
    for word, analysis in zip(words, analyses):
        for a in analysis:
            csv_writer.writerow([term.bold(word),
                                 term.bright_black(a.analysis),
                                 term.bold_underline(a.lemma),
                                 term.bright_black_underline(a.segmented_lemma),
                                 term.underline(string(a.lemma_index)),
                                 term.underline(string(a.paradigm_index)),
                                 term.underline(string(a.pos)),
                                 term.underline(string(a.subcat)),
                                 term.underline(string(a.auxiliary)),
                                 a.degree,
                                 a.person,
                                 a.gender,
                                 a.case,
                                 a.number,
                                 a.inflection,
                                 a.function,
                                 a.nonfinite,
                                 a.mood,
                                 a.tense,
                                 a.metainfo])

def output_analyses(transducer, input, output, header=True, force_color=False, output_format="tsv"):
    words = tuple(word.strip() for word in input.readlines() if word.strip())
    analyses = analyse_words(transducer, words)
    if analyses:
        if output_format == "json":
            output_json(words, analyses, output)
        elif output_format == "csv":
            output_dsv(words, analyses, output, header, force_color, delimiter=",")
        else:
            output_dsv(words, analyses, output, header, force_color)

def main():
    e = False
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
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-t", "--transducer", default=LIBFILE,
                            help="path to transducer file (default: {0})".format(os.path.relpath(LIBFILE, os.getcwd())))
        parser.add_argument("-v", "--version", action="version",
                            version="{0} {1}".format(parser.prog, version))
        args = parser.parse_args()
        term = Terminal(force_styling=args.force_color)
        transducer = sfst_transduce.CompactTransducer(args.transducer)
        transducer.both_layers = False
        if args.json:
            output_format = "json"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"
        output_analyses(transducer, args.input, args.output, args.no_header, args.force_color, output_format)
    except KeyboardInterrupt:
        sys.exit(130)
    # except TypeError:
    #     print(term.bold_red(args.transducer) + ": No such transducer file.", file=sys.stderr)
    #     e = True
    # except RuntimeError:
    #     print(term.bold_red(args.transducer) + ": No such transducer.", file=sys.stderr)
    #     e = True
    if e:
        exit = 1
    else:
        exit = 0
    return exit

if __name__ == "__main__":
    sys.exit(main())
