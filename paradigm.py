#!/usr/bin/python3
# paradigm.py -- generate paradigms
# Andreas Nolda 2022-07-08

import sys
import os
import argparse
import csv
import json
import sfst_transduce
from dwdsmor import analyse_word
from blessings import Terminal
from collections import namedtuple

version = 1.1

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-index.a")

indices     = [1, 2, 3, 4]
pos         = ["ADJ", "ART", "CARD", "DEM", "INDEF", "NN", "NPROP", "POSS", "REL", "V"]
subcats     = ["Def", "Indef", "Neg"]
degrees     = ["Pos", "Comp", "Sup"]
persons     = ["1", "2", "3"]
genders     = ["Masc", "Neut", "Fem", "NoGend"]
cases       = ["Nom", "Acc", "Dat", "Gen"]
numbers     = ["Sg", "Pl"]
inflections = ["NoInfl", "St", "Wk"]
functions   = ["Attr", "Subst", "Pred"]
nonfinites  = ["Inf", "PPres", "PPast"]
moods       = ["Ind", "Subj"]
tenses      = ["Pres", "Past"]

imperative_persons = ["2"]
imperative_numbers = numbers
imperative_moods   = ["Imp"]

lexcat = ["pos",
          "subcat",
          "gender"]
parcat = ["degree",
          "person",
          "gender",
          "case",
          "number",
          "inflection",
          "function",
          "nonfinite",
          "mood",
          "tense"]

Lexcat = namedtuple("Lexcat", lexcat, defaults=[None] * len(lexcat[1:]))
Parcat = namedtuple("Parcat", parcat, defaults=[None] * len(parcat))

Formspec  = namedtuple("Formspec",  ["index", "lexcat", "parcat"])
Lemmaspec = namedtuple("Lemmaspec", ["index", "segmented_lemma", "pos"])

def get_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    if index:
        idx = "<IDX" + index + ">"
    else:
        idx = ""
    if pos == "ADJ":
        # uninflected forms
        for degree in degrees:
            forms = transducer.generate(seg + idx + "<+" + pos     + ">" +
                                                    "<"  + degree  + ">" +
                                                    "<"  + "Invar" + ">")
            if forms:
                formdict[Formspec(index,
                                  Lexcat(pos = pos),
                                  Parcat(degree     = degree,
                                         gender     = "Invar",
                                         case       = "Invar",
                                         number     = "Invar",
                                         inflection = "Invar"))] = set(forms)
            for function in functions:
                forms = transducer.generate(seg + idx + "<+" + pos      + ">" +
                                                        "<"  + degree   + ">" +
                                                        "<"  + function + ">")
                if forms:
                    formdict[Formspec(index,
                                      Lexcat(pos = pos),
                                      Parcat(degree   = degree,
                                             function = function))] = set(forms)
        # inflected forms
        for degree in degrees:
            for gender in genders:
                for number in numbers:
                    for case in cases:
                        for inflection in inflections:
                            forms = transducer.generate(seg + idx + "<+" + pos        + ">" +
                                                                    "<"  + degree     + ">" +
                                                                    "<"  + gender     + ">" +
                                                                    "<"  + case       + ">" +
                                                                    "<"  + number     + ">" +
                                                                    "<"  + inflection + ">")
                            if forms:
                                formdict[Formspec(index,
                                                  Lexcat(pos = pos),
                                                  Parcat(degree     = degree,
                                                         gender     = gender,
                                                         case       = case,
                                                         number     = number,
                                                         inflection = inflection))] = set(forms)
    # cardinals and pronouns
    if pos == "CARD" or pos == "DEM" or pos == "INDEF" or pos == "POSS" or pos == "REL":
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for inflection in inflections:
                        for function in functions:
                            forms = transducer.generate(seg + idx + "<+" + pos        + ">" +
                                                                    "<"  + function   + ">" +
                                                                    "<"  + gender     + ">" +
                                                                    "<"  + case       + ">" +
                                                                    "<"  + number     + ">" +
                                                                    "<"  + inflection + ">")
                            if forms:
                                formdict[Formspec(index,
                                                  Lexcat(pos = pos),
                                                  Parcat(function   = function,
                                                         gender     = gender,
                                                         case       = case,
                                                         number     = number,
                                                         inflection = inflection))] = set(forms)
                            if nonstandard_forms:
                                forms = transducer.generate(seg + idx + "<+" + pos        + ">" +
                                                                        "<"  + function   + ">" +
                                                                        "<"  + gender     + ">" +
                                                                        "<"  + case       + ">" +
                                                                        "<"  + number     + ">" +
                                                                        "<"  + inflection + ">" +
                                                                        "<"  + "NonSt"    + ">")
                                if forms:
                                    if (index,
                                        Lexcat(pos    = pos),
                                        Parcat(function   = function,
                                               gender     = gender,
                                               case       = case,
                                               number     = number,
                                               inflection = inflection)) in formdict:
                                        formdict[Formspec(index,
                                                          Lexcat(pos    = pos),
                                                          Parcat(function   = function,
                                                                 gender     = gender,
                                                                 case       = case,
                                                                 number     = number,
                                                                 inflection = inflection))] |= set(forms)
                                    else:
                                        formdict[Formspec(index,
                                                          Lexcat(pos    = pos),
                                                          Parcat(function   = function,
                                                                 gender     = gender,
                                                                 case       = case,
                                                                 number     = number,
                                                                 inflection = inflection))]  = set(forms)
    # articles
    if pos == "ART":
        for subcat in subcats:
            for gender in genders:
                for number in numbers:
                    for case in cases:
                        for inflection in inflections:
                            for function in functions:
                                forms = transducer.generate(seg + idx + "<+" + pos        + ">" +
                                                                        "<"  + subcat     + ">" +
                                                                        "<"  + function   + ">" +
                                                                        "<"  + gender     + ">" +
                                                                        "<"  + case       + ">" +
                                                                        "<"  + number     + ">" +
                                                                        "<"  + inflection + ">")
                                if forms:
                                    formdict[Formspec(index,
                                                      Lexcat(pos    = pos,
                                                             subcat = subcat),
                                                      Parcat(function   = function,
                                                             gender     = gender,
                                                             case       = case,
                                                             number     = number,
                                                             inflection = inflection))] = set(forms)
                                if nonstandard_forms:
                                    forms = transducer.generate(seg + idx + "<+" + pos        + ">" +
                                                                            "<"  + subcat     + ">" +
                                                                            "<"  + function   + ">" +
                                                                            "<"  + gender     + ">" +
                                                                            "<"  + case       + ">" +
                                                                            "<"  + number     + ">" +
                                                                            "<"  + inflection + ">" +
                                                                            "<"  + "NonSt"    + ">")
                                    if forms:
                                        if (index,
                                            Lexcat(pos    = pos,
                                                   subcat = subcat),
                                            Parcat(function   = function,
                                                   gender     = gender,
                                                   case       = case,
                                                   number     = number,
                                                   inflection = inflection)) in formdict:
                                            formdict[Formspec(index,
                                                              Lexcat(pos    = pos,
                                                                     subcat = subcat),
                                                              Parcat(function   = function,
                                                                     gender     = gender,
                                                                     case       = case,
                                                                     number     = number,
                                                                     inflection = inflection))] |= set(forms)
                                        else:
                                            formdict[Formspec(index,
                                                              Lexcat(pos    = pos,
                                                                     subcat = subcat),
                                                              Parcat(function   = function,
                                                                     gender     = gender,
                                                                     case       = case,
                                                                     number     = number,
                                                                     inflection = inflection))]  = set(forms)
    # nouns
    if pos == "NN" or pos == "NPROP":
        # nominalised adjectives
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for inflection in inflections:
                        forms = transducer.generate(seg + idx + "<+" + pos        + ">" +
                                                                "<"  + gender     + ">" +
                                                                "<"  + case       + ">" +
                                                                "<"  + number     + ">" +
                                                                "<"  + inflection + ">")
                        if forms:
                            formdict[Formspec(index,
                                              Lexcat(pos    = pos,
                                                     gender = gender),
                                              Parcat(case       = case,
                                                     number     = number,
                                                     inflection = inflection))] = set(forms)
        # other nouns
        for gender in genders:
            for number in numbers:
                for case in cases:
                    forms = transducer.generate(seg + idx + "<+" + pos    + ">" +
                                                            "<"  + gender + ">" +
                                                            "<"  + case   + ">" +
                                                            "<"  + number + ">")
                    if forms:
                        formdict[Formspec(index,
                                          Lexcat(pos    = pos,
                                                 gender = gender),
                                          Parcat(case   = case,
                                                 number = number))] = set(forms)
                    if old_forms:
                        forms = transducer.generate(seg + idx + "<+" + pos    + ">" +
                                                                "<"  + gender + ">" +
                                                                "<"  + case   + ">" +
                                                                "<"  + number + ">" +
                                                                "<"  + "Old"  + ">")
                        if forms:
                            if (index,
                                Lexcat(pos    = pos,
                                       gender = gender),
                                Parcat(case   = case,
                                       number = number)) in formdict:
                                formdict[Formspec(index,
                                                  Lexcat(pos    = pos,
                                                         gender = gender),
                                                  Parcat(case   = case,
                                                         number = number))] |= set(forms)
                            else:
                                formdict[Formspec(index,
                                                  Lexcat(pos    = pos,
                                                         gender = gender),
                                                  Parcat(case   = case,
                                                         number = number))]  = set(forms)
    # verbs
    if pos == "V":
        # non-finite forms
        for nonfinite in nonfinites:
            forms = transducer.generate(seg + idx + "<+" + pos       + ">" +
                                                    "<"  + nonfinite + ">")
            if forms:
                formdict[Formspec(index,
                                  Lexcat(pos = pos),
                                  Parcat(nonfinite = nonfinite))] = set(forms)
        # indicative and subjunctive forms
        for tense in tenses:
            for mood in moods:
                for number in numbers:
                    for person in persons:
                        forms = transducer.generate(seg + idx + "<+" + pos    + ">" +
                                                                 "<"  + person + ">" +
                                                                 "<"  + number + ">" +
                                                                 "<"  + tense  + ">" +
                                                                 "<"  + mood   + ">")
                        if forms:
                            formdict[Formspec(index,
                                              Lexcat(pos = pos),
                                              Parcat(person = person,
                                                     number = number,
                                                     mood   = mood,
                                                     tense  = tense))] = set(forms)
        # imperative forms
        for mood in imperative_moods:
            for number in imperative_numbers:
                for person in imperative_persons:
                    forms = transducer.generate(seg + idx + "<+" + pos    + ">" +
                                                            "<"  + mood   + ">" +
                                                            "<"  + number + ">")
                    if forms:
                        formdict[Formspec(index,
                                          Lexcat(pos = pos),
                                          Parcat(person = person,
                                                 number = number,
                                                 mood   = mood))] = set(forms)
    return formdict

def paradigm_subset(formdict, index, lexcat):
    return [(key, value) for key, value in formdict.items() if key.index == index and key.lexcat == lexcat]

def cat_dict(cats):
    return {key: value for key, value in cats._asdict().items() if value}

def cat_list(cats):
    # remove duplicates while preserving order
    return {"categories": list(dict.fromkeys(value for value in cat_dict(cats).values()))}

def output_json(lemma, output, formdict, no_category_names=False, no_lemma=False):
    paradigms = []
    # remove duplicates while preserving order
    for index, lexcat in list(dict.fromkeys((key.index, key.lexcat) for key in formdict.keys())):
        if no_category_names:
            cat_value = cat_list
        else:
            cat_value = cat_dict
        if no_lemma:
            paradigms.append({"paradigm": [{**cat_value(key.parcat),
                                            "forms": sorted(value)}
                                           for key, value in paradigm_subset(formdict, index, lexcat)]})
        else:
            paradigms.append({"lemma": lemma,
                              "index": index,
                              **cat_value(lexcat),
                              "paradigm": [{**cat_value(key.parcat),
                                            "forms": sorted(value)}
                                           for key, value in paradigm_subset(formdict, index, lexcat)]})
    json.dump(paradigms, output, ensure_ascii=False)

def string(value):
    return str(value or "")

def output_dsv(lemma, output, formdict, no_category_names=False, no_lemma=False, header=True, force_color=False, delimiter="\t"):
    term = Terminal(force_styling=force_color)
    csv_writer = csv.writer(output, delimiter=delimiter)
    if header:
        if no_category_names and no_lemma:
            csv_writer.writerow(["Paradigm Categories",
                                 term.bold("Paradigm Forms")])
        elif no_category_names:
            csv_writer.writerow([term.bold_underline("Lemma"),
                                 term.underline("Index"),
                                 term.underline("Categories"),
                                 "Paradigm Categories",
                                 term.bold("Paradigm Forms")])
        elif no_lemma:
            csv_writer.writerow(["Degree",
                                 "Person",
                                 "Gender",
                                 "Case",
                                 "Number",
                                 "Inflection",
                                 "Function",
                                 "Nonfinite",
                                 "Mood",
                                 "Tense",
                                 term.bold("Paradigm Forms")])
        else:
            csv_writer.writerow([term.bold_underline("Lemma"),
                                 term.underline("Index"),
                                 term.underline("POS"),
                                 term.underline("Subcategory"),
                                 term.underline("Gender"),
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
                                 term.bold("Paradigm Forms")])
    for formspec in formdict:
        if no_category_names and no_lemma:
            csv_writer.writerow([" ".join(filter(None, formspec.parcat)),
                                 term.bold(", ".join(sorted(formdict[formspec])))])
        elif no_category_names:
            csv_writer.writerow([term.bold_underline(lemma),
                                 term.underline(string(formspec.index)),
                                 term.underline(" ".join(filter(None, formspec.lexcat))),
                                 " ".join(filter(None, formspec.parcat)),
                                 term.bold(", ".join(sorted(formdict[formspec])))])
        elif no_lemma:
            csv_writer.writerow([string(formspec.parcat.degree),
                                 string(formspec.parcat.person),
                                 string(formspec.parcat.gender),
                                 string(formspec.parcat.case),
                                 string(formspec.parcat.number),
                                 string(formspec.parcat.inflection),
                                 string(formspec.parcat.function),
                                 string(formspec.parcat.nonfinite),
                                 string(formspec.parcat.mood),
                                 string(formspec.parcat.tense),
                                 term.bold(", ".join(sorted(formdict[formspec])))])
        else:
            csv_writer.writerow([term.bold_underline(lemma),
                                 term.underline(string(formspec.index)),
                                 term.underline(formspec.lexcat.pos),
                                 term.underline(string(formspec.lexcat.subcat)),
                                 term.underline(string(formspec.lexcat.gender)),
                                 string(formspec.parcat.degree),
                                 string(formspec.parcat.person),
                                 string(formspec.parcat.gender),
                                 string(formspec.parcat.case),
                                 string(formspec.parcat.number),
                                 string(formspec.parcat.inflection),
                                 string(formspec.parcat.function),
                                 string(formspec.parcat.nonfinite),
                                 string(formspec.parcat.mood),
                                 string(formspec.parcat.tense),
                                 term.bold(", ".join(sorted(formdict[formspec])))])

def generate_paradigms(transducer, lemma, index=None, pos=None, old_forms=False, nonstandard_forms=False):
    analyses = analyse_word(transducer, lemma)
    lemmaspecs = sorted({Lemmaspec(analysis.index, analysis.segmented_lemma, analysis.pos)
                         for analysis in analyses if analysis.lemma == lemma})
    if index:
        lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs if lemmaspec.index == str(index)]
    if pos:
        lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs if lemmaspec.pos == pos]
    formdict = {}
    for lemmaspec in lemmaspecs:
        # Python >= v3.9
        # formdict |= get_formdict(transducer, *lemmaspec, old_forms=old_forms, nonstandard_forms=nonstandard_forms)
        formdict.update(get_formdict(transducer, *lemmaspec, old_forms=old_forms, nonstandard_forms=nonstandard_forms))
    return formdict

def output_paradigms(transducer, lemma, output, index=None, pos=None, old_forms=False, nonstandard_forms=False, no_category_names=False, no_lemma=False, header=True, force_color=False, output_format="tsv"):
    term = Terminal(force_styling=force_color)
    formdict = generate_paradigms(transducer, lemma, index, pos, old_forms, nonstandard_forms)
    if formdict:
        if output_format == "json":
            output_json(lemma, output, formdict, no_category_names, no_lemma)
        elif output_format == "csv":
            output_dsv(lemma, output, formdict, no_category_names, no_lemma, header, force_color, delimiter=",")
        else:
            output_dsv(lemma, output, formdict, no_category_names, no_lemma, header, force_color)
    else:
        if index and pos:
            print(term.bold(lemma) + ": No such lemma of index {0} and part-of-speech {1}.".format(index, pos), file=sys.stderr)
        elif index:
            print(term.bold(lemma) + ": No such lemma of index {0}.".format(index), file=sys.stderr)
        elif pos:
            print(term.bold(lemma) + ": No such lemma of part-of-speech {0}.".format(pos), file=sys.stderr)
        else:
            print(term.bold(lemma) + ": No such lemma.", file=sys.stderr)

def main():
    e = False
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("lemma",
                            help="lemma (determiners: Fem Nom Sg; nominalised adjectives: Wk)")
        parser.add_argument("output", nargs="?", type=argparse.FileType("w"), default=sys.stdout,
                            help="output file (default: stdout)")
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
        parser.add_argument("-n", "--no-category-names", action="store_true",
                            help="do not output category names")
        parser.add_argument("-N", "--no-lemma", action="store_true",
                            help="do not output lemma, index, and lexical categories")
        parser.add_argument("-o", "--old-forms", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-p", "--pos", choices=pos,
                            help="part of speech")
        parser.add_argument("-s", "--nonstandard-forms", action="store_true",
                            help="output also non-standard forms")
        parser.add_argument("-t", "--transducer", default=libfile,
                            help="transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
        parser.add_argument("-v", "--version", action="version",
                            version="{0} {1}".format(parser.prog, version))
        args = parser.parse_args()
        term = Terminal(force_styling=args.force_color)
        transducer = sfst_transduce.Transducer(args.transducer)
        if args.json:
            output_format = "json"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"
        output_paradigms(transducer, args.lemma, args.output, args.index, args.pos, args.old_forms, args.nonstandard_forms, args.no_category_names, args.no_lemma, args.no_header, args.force_color, output_format)
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
