#!/usr/bin/python3
# dwdsmor.py - analyse word forms with DWDSmor
# Gregor Middell and Andreas Nolda 2022-06-29

import sys
import os
import argparse
import re
import jellyfish
import sfst_transduce
import csv
import json
from blessings import Terminal
from collections import namedtuple
from functools import cached_property

version = 4.0

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-full.ca")

Morpheme = namedtuple("Morpheme", ["form", "lemma", "tags"])

class Analysis(tuple):
    def __new__(cls, full_analysis, morphemes):
        inst = tuple.__new__(cls, morphemes)
        inst.full_analysis = full_analysis
        return inst

    def analysis_layer(self):
        layer = re.sub(r"([^>]|<[^>]*>):([^<]|<[^>]*>)", r"\1", self.full_analysis)
        layer = re.sub(r"<>", "", layer)
        return layer

    @cached_property
    def analysis(self):
        return self.analysis_layer()

    @cached_property
    def form(self):
        return "".join(m.form for m in self)

    @cached_property
    def lemma(self):
        return "".join(m.lemma for m in self)

    @cached_property
    def segmented_lemma(self):
        return re.sub(r"(<IDX[^>]+>)?<\+[^>]+>.*", "", self.analysis)

    @cached_property
    def tags(self):
        return [tag for m in self for tag in m.tags]

    @cached_property
    def index(self):
        for tag in self.tags:
            if tag.startswith("IDX"):
                return tag[3:]

    @cached_property
    def pos(self):
        for tag in self.tags:
            if tag.startswith("+"):
                return tag[1:]

    _degree_tags     = {"Pos": True, "Comp": True, "Sup": True}
    _person_tags     = {"1": True, "2": True, "3": True}
    _gender_tags     = {"Fem": True, "Neut": True, "Masc": True, "NoGend": True, "Invar": True}
    _case_tags       = {"Nom": True, "Gen": True, "Dat": True, "Acc": True, "Invar": True}
    _number_tags     = {"Sg": True, "Pl": True, "Invar": True}
    _inflection_tags = {"St": True, "Wk": True, "Invar": True}
    _function_tags   = {"Pred": True, "Adv": True}
    _nonfinite_tags  = {"Inf": True, "PPres": True, "PPast": True}
    _mood_tags       = {"Ind": True, "Subj": True, "Imp": True}
    _tense_tags      = {"Pres": True, "Past": True}
    _metainfo_tags   = {"Old": True, "CAP": True}

    def tag_of_type(self, type_map):
        for tag in self.tags:
            if tag in type_map:
                return tag

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

    @cached_property
    def dist_score(self):
        return jellyfish.levenshtein_distance(self.form.lower(), self.lemma.lower())

    def as_dict(self):
        return {"form": self.form,
                "analysis": self.analysis,
                "fullanalysis": self.full_analysis,
                "lemma": self.lemma,
                "segmentedlemma": self.segmented_lemma,
                "index": self.index,
                "pos": self.pos,
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
                "distscore": self.dist_score,
                "morphemes": [m._asdict() for m in self]}

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
        for m in re.finditer(r"([^<]*)(?:<([^>]*)>)?", analysis):
            text = m.group(1)
            tag  = m.group(2) or ""
            component = Analysis._decode_component_text(text)
            if tag != "":
                component["tag"] = tag
            yield component

    def _join_tags(analysis):
        result = []
        current = None
        for c in analysis:
            c = c.copy()
            if current is None or c["form"] != "" or c["lemma"] != "":
                c["tags"] = []
                result.append(c)
                current = c
            if "tag" in c:
                current["tags"].append(c["tag"])
                del c["tag"]
        return result

    def _join_untagged(analysis):
        result = []
        buf = []
        for c in analysis:
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
    l = []
    for analysis in analyses:
        morphemes = Analysis._decode_analysis(analysis)
        morphemes = Analysis._join_tags(morphemes)
        morphemes = Analysis._join_untagged(morphemes)
        if not morphemes in l:
            l.append(morphemes)
            yield Analysis(analysis, [Morpheme(**m) for m in morphemes])

def analyse_word(transducer, word):
    return parse(transducer.analyse(word))

def analyse_words(transducer, words):
    return tuple(analyse_word(transducer, word) for word in words)

def output_json(words, analyses, output):
    word_analyses = []
    for word, analysis in zip(words, analyses):
        word_analyses.append({"word": word,
                              "analyses": [a.as_dict() for a in analysis]})
    json.dump(word_analyses, output, ensure_ascii=False)

def output_dsv(words, analyses, output, full_analysis=False, header=True, force_color=False, delimiter="\t"):
    term = Terminal(force_styling=force_color)
    csv_writer = csv.writer(output, delimiter=delimiter)
    if header:
        csv_writer.writerow([term.bold("Wordform"),
                             term.bright_black("Analysis"),
                             term.bold_underline("Lemma"),
                             term.bright_black_underline("Segmentation"),
                             term.underline("Index"),
                             term.underline("POS"),
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
            if full_analysis:
                analysis = a.full_analysis
            else:
                analysis = a.analysis
            if a.index:
                idx = a.index
            else:
                idx = ""
            csv_writer.writerow([term.bold(word),
                                 term.bright_black(analysis),
                                 term.bold_underline(a.lemma),
                                 term.bright_black_underline(a.segmented_lemma),
                                 term.underline(idx),
                                 term.underline(a.pos),
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

def output_analyses(transducer, input, output, full_analysis=False, header=True, force_color=False, output_format="tsv"):
    words = tuple(word.strip() for word in input.readlines() if word.strip())
    analyses = analyse_words(transducer, words)
    if analyses:
        if output_format == "json":
            output_json(words, analyses, output)
        elif output_format == "csv":
            output_dsv(words, analyses, output, full_analysis, header, force_color, delimiter=",")
        else:
            output_dsv(words, analyses, output, full_analysis, header, force_color)

def main():
    e = False
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("input", nargs="?", type=argparse.FileType("r"), default=sys.stdin,
                            help="input file (one word form per line; default: stdin)")
        parser.add_argument("output", nargs="?", type=argparse.FileType("w"), default=sys.stdout,
                            help="output file (default: stdout)")
        parser.add_argument("-a", "--full-analysis", action="store_true",
                            help="output full analysis with surface layer and analysis layer")
        parser.add_argument("-c", "--csv", action="store_true",
                            help="output CSV table")
        parser.add_argument("-C", "--force-color", action="store_true",
                            help="preserve color and formatting when piping output")
        parser.add_argument("-H", "--no-header", action="store_false",
                            help="suppress table header")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-t", "--transducer", default=libfile,
                            help="path to transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
        parser.add_argument("-v", "--version", action="version",
                            version="{0} {1}".format(parser.prog, version))
        args = parser.parse_args()
        term = Terminal(force_styling=args.force_color)
        transducer = sfst_transduce.CompactTransducer(args.transducer)
        transducer.both_layers = True
        if args.json:
            output_format = "json"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"
        output_analyses(transducer, args.input, args.output, args.full_analysis, args.no_header, args.force_color, output_format)
    except KeyboardInterrupt:
        sys.exit(130)
    except TypeError:
        print(term.bold_red(args.transducer) + ": No such transducer file.", file=sys.stderr)
        e = True
    except RuntimeError:
        print(term.bold_red(args.transducer) + ": No such transducer.", file=sys.stderr)
        e = True
    if e:
        exit = 1
    else:
        exit = 0
    return exit

if __name__ == "__main__":
    sys.exit(main())
