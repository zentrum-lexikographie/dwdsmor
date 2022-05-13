#!/usr/bin/python3
# dwdsmor-analyze.py - analyse word forms with DWDSmor
# Gregor Middell and Andreas Nolda 2022-05-13

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

version = 2.2

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-full.ca")

parser = argparse.ArgumentParser()
parser.add_argument("input", nargs="?", type=argparse.FileType("r"), default=sys.stdin,
                    help="input file (one word form per line; default: stdin)")
parser.add_argument("output", nargs="?", type=argparse.FileType("w"), default=sys.stdout,
                    help="output file (default: stdout)")
parser.add_argument("-C", "--force-color", action="store_true",
                    help="preserve color and formatting when piping output")
parser.add_argument("-c", "--csv", action="store_true",
                    help="output CSV table")
parser.add_argument("-j", "--json", action="store_true",
                    help="output JSON object")
parser.add_argument("-l", "--both-layers", action="store_true",
                    help="output analysis and surface layer")
parser.add_argument("-t", "--transducer", default=libfile,
                    help="path to transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
parser.add_argument("-v", "--version", action="version",
                    version="{0} {1}".format(parser.prog, version))
args = parser.parse_args()

term = Terminal(force_styling=args.force_color)

Morpheme = namedtuple("Morpheme", ["word", "lemma", "tags"])

class Analysis(tuple):
    def __new__(cls, analysis, morphemes):
        inst = tuple.__new__(cls, morphemes)
        inst.analysis = analysis
        return inst

    @cached_property
    def word(self):
        return "".join(m.word for m in self)

    @cached_property
    def lemma(self):
        return "".join(m.lemma for m in self)

    @cached_property
    def tags(self):
        return [tag for m in self for tag in m.tags]

    @cached_property
    def pos(self):
        for tag in self.tags:
            if tag.startswith("+"):
                return tag[1:]

    _function_tags   = {"Pred": True, "Adv": True}
    _degree_tags     = {"Pos": True, "Comp": True, "Sup": True}
    _person_tags     = {"1": True, "2": True, "3": True}
    _gender_tags     = {"Fem": True, "Neut": True, "Masc": True, "NoGend": True, "Invar": True}
    _number_tags     = {"Sg": True, "Pl": True, "Invar": True}
    _case_tags       = {"Nom": True, "Gen": True, "Dat": True, "Acc": True, "Invar": True}
    _inflection_tags = {"St": True, "Wk": True, "Invar": True}
    _tense_tags      = {"Pres": True, "Past": True}
    _mood_tags       = {"Ind": True, "Subj": True, "Imp": True}
    _nonfinite_tags  = {"Inf": True, "PPres": True, "PPast": True}
    _metainfo_tags   = {"Old": True, "CAP": True}

    def tag_of_type(self, type_map):
        for tag in self.tags:
            if tag in type_map:
                return tag

    @cached_property
    def function(self):
        return self.tag_of_type(Analysis._function_tags)

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
    def number(self):
        return self.tag_of_type(Analysis._number_tags)

    @cached_property
    def case(self):
        return self.tag_of_type(Analysis._case_tags)

    @cached_property
    def inflection(self):
        return self.tag_of_type(Analysis._inflection_tags)

    @cached_property
    def tense(self):
        return self.tag_of_type(Analysis._tense_tags)

    @cached_property
    def mood(self):
        return self.tag_of_type(Analysis._mood_tags)

    @cached_property
    def nonfinite(self):
        return self.tag_of_type(Analysis._nonfinite_tags)

    @cached_property
    def metainfo(self):
        return self.tag_of_type(Analysis._metainfo_tags)

    @cached_property
    def dist_score(self):
        return jellyfish.levenshtein_distance(self.word.lower(), self.lemma.lower())

    def as_dict(self):
        return {"word": self.word,
                "analysis": self.analysis,
                "lemma": self.lemma,
                "pos": self.pos,
                "function": self.function,
                "degree": self.degree,
                "person": self.person,
                "gender": self.gender,
                "number": self.number,
                "case": self.case,
                "inflection": self.inflection,
                "tense": self.tense,
                "mood": self.mood,
                "nonfinite": self.nonfinite,
                "metainfo": self.metainfo,
                "morphemes": [m._asdict() for m in self]}

    _empty_component_texts = set(["", ":"])
    _curly_braces_re = re.compile(r"[{}]")

    def _decode_component_text(text):
        lemma = ""
        word = ""
        text_len = len(text)
        ti = 0
        prev = None
        while ti < text_len:
            current = text[ti]
            nti = ti + 1
            next = text[nti] if nti < text_len else None
            if current == ":":
                lemma += prev or ""
                word  += next or ""
                ti += 1
            elif next != ":":
                lemma += current
                word  += current
            ti += 1
            prev = current
        return {"lemma": lemma, "word": word}

    def _decode_analysis(analysis):
        # "QR-Code" -> "{:<>QR}:<>-<TRUNC>:<>Code<+NN>:<><Masc>:<><Acc>:<><Sg>:<>"
        analysis = Analysis._curly_braces_re.sub("", analysis)
        for m in re.finditer(r"([^<]*)(?:<([^>]*)>)?", analysis):
            text = m.group(1)
            tag = m.group(2) or ""
            component = Analysis._decode_component_text(text)
            if tag != "":
                component["tag"] = tag
            yield component

    def _join_tags(analysis):
        result = []
        current = None
        for c in analysis:
            c = c.copy()
            if current is None or c["word"] != "" or c["lemma"] != "":
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
                joined = {"lemma": "", "word": "", "tags": []}
                for c in buf:
                    joined["lemma"] += c["lemma"]
                    joined["word"]  += c["word"]
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

words = ()

def main():
    e = False
    try:
        transducer = sfst_transduce.CompactTransducer(args.transducer)
        transducer.both_layers = args.both_layers
        words = tuple(w.strip() for w in args.input.readlines() if w.strip())
        if words:
            analyses = tuple(parse(transducer.analyse(word)) for word in words)
            if args.json:
                json.dump({word: [a.as_dict() for a in analysis] for word, analysis in zip(words, analyses)},
                          sys.stdout, ensure_ascii=False)
            else:
                if args.csv:
                    csv_writer = csv.writer(args.output)
                else:
                    csv_writer = csv.writer(args.output, delimiter="\t")
                csv_writer.writerow([term.bold("Word"),
                                     term.bright_black("Analysis"),
                                     term.bold_underline("Lemma"),
                                     term.underline("POS"),
                                     "Function",
                                     "Degree",
                                     "Person",
                                     "Gender",
                                     "Number",
                                     "Case",
                                     "Inflection",
                                     "Tense",
                                     "Mood",
                                     "Nonfinite",
                                     "Metainfo"])
                for word, analysis in zip(words, analyses):
                    for a in analysis:
                        csv_writer.writerow([term.bold(word),
                                             term.bright_black(a.analysis),
                                             term.bold_underline(a.lemma),
                                             term.underline(a.pos),
                                             a.function,
                                             a.degree,
                                             a.person,
                                             a.gender,
                                             a.number,
                                             a.case,
                                             a.inflection,
                                             a.tense,
                                             a.mood,
                                             a.nonfinite,
                                             a.metainfo])
    except KeyboardInterrupt:
        sys.exit(130)
    except TypeError:
        print(term.bold_red(args.transducer) + ": No such transducer file.", file=sys.stderr)
        e = True
    except RuntimeError:
        print(term.bold_red(args.transducer) + ": No such transducer.", file=sys.stderr)
        e = True
    if e:
        exit = 2
    elif not words:
        exit = 1
    else:
        exit = 0
    return exit

if __name__ == "__main__":
    sys.exit(main())
