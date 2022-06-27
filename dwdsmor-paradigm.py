#!/usr/bin/python3
# dwdsmor-paradigm.py -- generate paradigms
# Andreas Nolda 2022-06-27

import sys
import os
import argparse
import re
import csv
import json
import sfst_transduce
from dwdsmor import parse
from blessings import Terminal

version = 1.0

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-index.a")

indices = [1, 2, 3, 4]
pos     = ["ADJ", "NN", "NPROP", "V"]
degrees = ["Pos", "Comp", "Sup"]
persons = ["1", "2", "3"]
genders = ["Masc", "Neut", "Fem", "NoGend"]
cases   = ["Nom", "Acc", "Dat", "Gen"]
numbers = ["Sg", "Pl"]
infls   = ["St", "Wk"]
tenses  = ["Pres", "Past"]
moods   = ["Ind", "Subj"]
uninfls = ["Invar", "Pred"]

imperative_persons = ["2"]
imperative_numbers = numbers
imperative_moods   = ["Imp"]

nonfinites = ["Inf", "PPres", "PPast"]

# a dictionary with category tuples as keys and form sets as values
form_specs = {}

def format_index(index):
    if index == None:
        return ""
    else:
        return "<IDX" + str(index) + ">"

def analyse(lemma, transducer):
    analyses = [analysis for analysis in tuple(parse(transducer.analyse(lemma)))]
    return analyses

def generate(lemma, index, pos, transducer, old_forms=False):
    if pos is None or index is None:
        analyses = analyse(lemma, transducer)
    if pos is None:
        pos_list = sorted({analysis.pos for analysis in analyses})
    else:
        pos_list = [pos]
    if index is None:
        index_list = sorted({analysis.index for analysis in analyses if analysis.pos in pos_list})
    else:
        index_list = [index]
    for index in index_list:
        idx = format_index(index)
        for pos in pos_list:
            # adjectives
            if pos == "ADJ":
                # uninflected forms
                for degree in degrees:
                    for uninfl in uninfls:
                        forms = transducer.generate(lemma + idx + "<+" + pos    + ">" +
                                                                  "<"  + degree + ">" +
                                                                  "<"  + uninfl + ">")
                        if forms:
                            form_specs[index, (pos,), (degree, uninfl)] = set(forms)
                # inflected forms
                for degree in degrees:
                    for gender in genders:
                        for number in numbers:
                            for case in cases:
                                for infl in infls:
                                    forms = transducer.generate(lemma + idx + "<+" + pos    + ">" +
                                                                              "<"  + degree + ">" +
                                                                              "<"  + gender + ">" +
                                                                              "<"  + case   + ">" +
                                                                              "<"  + number + ">" +
                                                                              "<"  + infl   + ">")
                                    if forms:
                                        form_specs[index, (pos,), (degree, gender, case, number, infl)] = set(forms)
            # nouns
            if pos == "NN" or pos == "NPROP":
                # nominalised adjectives
                for gender in genders:
                    for number in numbers:
                        for case in cases:
                            for infl in infls:
                                forms = transducer.generate(lemma + idx + "<+" + pos    + ">" +
                                                                          "<"  + gender + ">" +
                                                                          "<"  + case   + ">" +
                                                                          "<"  + number + ">" +
                                                                          "<"  + infl   + ">")
                                if forms:
                                    form_specs[index, (pos, gender), (case, number, infl)] = set(forms)
                # other nouns
                for gender in genders:
                    for number in numbers:
                        for case in cases:
                            forms = transducer.generate(lemma + idx + "<+" + pos    + ">" +
                                                                      "<"  + gender + ">" +
                                                                      "<"  + case   + ">" +
                                                                      "<"  + number + ">")
                            if forms:
                                form_specs[index, (pos, gender), (case, number)] = set(forms)
                            if old_forms:
                                forms = transducer.generate(lemma + idx + "<+" + pos    + ">" +
                                                                          "<"  + gender + ">" +
                                                                          "<"  + case   + ">" +
                                                                          "<"  + number + ">" +
                                                                          "<"  + "Old"  + ">")
                                if forms:
                                    if (index, gender, case, number) in form_specs:
                                        form_specs[index, (pos, gender), (case, number)] |= set(forms)
                                    else:
                                            form_specs[index, (pos, gender), (case, number)]  = set(forms)
            # verbs
            if pos == "V":
                stem  = re.sub(r"^(.+?)e?n$", r"\1", lemma)
                affix = re.sub(r"^.+?(e?n)$", r"\1", lemma)
                # non-finite forms
                for nonfinite in nonfinites:
                    forms = transducer.generate(stem + "<~>" + affix + idx + "<+" + pos       + ">" +
                                                                             "<"  + nonfinite + ">")
                    if forms:
                        form_specs[index, (pos,), (nonfinite,)] = set(forms)
                # indicative and subjunctive forms
                for tense in tenses:
                    for mood in moods:
                        for number in numbers:
                            for person in persons:
                                forms = transducer.generate(stem + "<~>" + affix + idx + "<+" + pos    + ">" +
                                                                                         "<"  + person + ">" +
                                                                                         "<"  + number + ">" +
                                                                                         "<"  + tense  + ">" +
                                                                                         "<"  + mood   + ">")
                                if forms:
                                    form_specs[index, (pos,), (person, number, tense, mood)] = set(forms)
                # imperative forms
                for mood in imperative_moods:
                    for number in imperative_numbers:
                        for person in imperative_persons:
                            forms = transducer.generate(stem + "<~>" + affix + idx + "<+" + pos    + ">" +
                                                                                     "<"  + mood   + ">" +
                                                                                     "<"  + number + ">")
                            if forms:
                                form_specs[index, (pos,), (person, number, mood)] = set(forms)

def output_dsv(form_specs, lemma, output, brief=False, header=True, force_color=False, delimiter="\t"):
    term = Terminal(force_styling=force_color)
    csv_writer = csv.writer(output, delimiter=delimiter)
    if header:
        if brief:
            csv_writer.writerow(["Paradigm Categories",
                                 term.bold("Paradigm Forms")])
        else:
            csv_writer.writerow([term.bold_underline("Lemma"),
                                 term.underline("Index"),
                                 term.underline("Categories"),
                                 "Paradigm Categories",
                                 term.bold("Paradigm Forms")])
    for form_spec in form_specs:
        if brief:
            csv_writer.writerow([" ".join(form_spec[2]),
                                 term.bold(", ".join(sorted(form_specs[form_spec])))])
        else:
            if form_spec[0]:
                idx = str(form_spec[0])
            else:
                idx = ""
            csv_writer.writerow([term.bold_underline(lemma),
                                 term.underline(idx),
                                 term.underline(" ".join(form_spec[1])),
                                 " ".join(form_spec[2]),
                                 term.bold(", ".join(sorted(form_specs[form_spec])))])

def paradigm_subset(form_specs, index, lexcat):
    return [(key, value) for key, value in form_specs.items() if key[0] == index and key[1] == lexcat]

def output_json(form_specs, lemma, output, brief=False):
    paradigm_specs = []
    for index in list(dict.fromkeys(key[0] for key in form_specs.keys())):
        for lexcat in list(dict.fromkeys(key[1] for key in form_specs.keys() if key[0] == index)):
            if brief:
                paradigm_specs.append({"paradigm": [{"categories": list(key[2]),
                                                     "forms": sorted(value)}
                                                    for key, value in paradigm_subset(form_specs, index, lexcat)]})
            else:
                paradigm_specs.append({"lemma": lemma,
                                       "index": index,
                                       "categories": list(lexcat),
                                       "paradigm": [{"categories": list(key[2]),
                                                     "forms": sorted(value)}
                                                    for key, value in paradigm_subset(form_specs, index, lexcat)]})
    json.dump(paradigm_specs, output, ensure_ascii=False)

def output_paradigms(form_specs, lemma, index, pos, output, header=True, brief=False, force_color=False, output_format="tsv"):
    if output_format == "json":
        output_json(form_specs, lemma, output, brief)
    elif output_format == "csv":
        output_dsv(form_specs, lemma, output, brief, header, force_color, delimiter=",")
    else:
        output_dsv(form_specs, lemma, output, brief, header, force_color)

def main():
    e = False
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("lemma",
                            help="lemma")
        parser.add_argument("output", nargs="?", type=argparse.FileType("w"), default=sys.stdout,
                            help="output file (default: stdout)")
        parser.add_argument("-b", "--brief", action="store_true",
                            help="output brief version without lemma and lexical categories")
        parser.add_argument("-c", "--csv", action="store_true",
                            help="output CSV table")
        parser.add_argument("-C", "--force-color", action="store_true",
                            help="preserve color and formatting when piping output")
        parser.add_argument("-H", "--no-header", action="store_false",
                            help="suppress table header")
        parser.add_argument("-i", "--index", type=int, choices=indices,
                            help="homographic lemma index")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-o", "--old-forms", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-p", "--pos", choices=pos,
                            help="part of speech")
        parser.add_argument("-t", "--transducer", default=libfile,
                            help="transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
        parser.add_argument("-v", "--version", action="version",
                            version="{0} {1}".format(parser.prog, version))
        args = parser.parse_args()
        term = Terminal(force_styling=args.force_color)
        transducer = sfst_transduce.Transducer(args.transducer)
        generate(args.lemma, args.index, args.pos, transducer, old_forms=args.old_forms)
        if args.json:
            output_format = "json"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"
        if form_specs:
            output_paradigms(form_specs, args.lemma, args.index, args.pos, args.output, args.no_header, args.brief, args.force_color, output_format)
        else:
            if args.pos:
                print(term.bold(args.lemma) + ": No such lemma of part-of-speech {0}.".format(args.pos), file=sys.stderr)
            else:
                print(term.bold(args.lemma) + ": No such lemma.", file=sys.stderr)
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
    elif not form_specs:
        exit = 1
    else:
        exit = 0
    return exit

if __name__ == "__main__":
    sys.exit(main())
