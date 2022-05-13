#!/usr/bin/python3
# generate-verb-paradigm.py -- generate a paradigm of verb forms
# Andreas Nolda 2022-05-13

import sys
import os
import argparse
import re
import json
import sfst_transduce
from blessings import Terminal

version = 1.5

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-full.a")

parser = argparse.ArgumentParser()
parser.add_argument("lemma",
                    help="verb lemma")
parser.add_argument("-C", "--force-color", action="store_true",
                    help="preserve color and formatting when piping output")
parser.add_argument("-j", "--json", action="store_true",
                    help="output JSON object")
parser.add_argument("-t", "--transducer", default=libfile,
                    help="transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
parser.add_argument("-v", "--version", action="version",
                    version="{0} {1}".format(parser.prog, version))
args = parser.parse_args()

term = Terminal(force_styling=args.force_color)

pos     = "V"
persons = ["1", "2", "3"]
numbers = ["Sg", "Pl"]
tenses  = ["Pres", "Past"]
moods   = ["Ind", "Subj"]

imp_persons = ["2"]
imp_numbers = numbers
imp_moods   = ["Imp"]

infs = ["Inf", "PPres", "PPast"]

paradigm = {}

def get_forms(lemma, transducer):
    stem  = re.sub(r"^(.+?)e?n$", r"\1", lemma)
    affix = re.sub(r"^.+?(e?n)$", r"\1", lemma)
    for inf in infs:
        forms = transducer.generate(stem + "<~>" + affix + "<+" + pos + ">" +
                                                           "<"  + inf + ">")
        cats = " ".join([inf])
        if forms:
            paradigm.update({cats: forms})
    for tense in tenses:
        for mood in moods:
            for number in numbers:
                for person in persons:
                    forms = transducer.generate(stem + "<~>" + affix + "<+" + pos    + ">" +
                                                                       "<"  + person + ">" +
                                                                       "<"  + number + ">" +
                                                                       "<"  + tense  + ">" +
                                                                       "<"  + mood   + ">")
                    cats = " ".join([person, number, tense, mood])
                    if forms:
                        paradigm.update({cats: forms})
    for mood in imp_moods:
        for number in imp_numbers:
            for person in imp_persons:
                forms = transducer.generate(stem + "<~>" + affix + "<+" + pos    + ">" +
                                                                   "<"  + mood   + ">" +
                                                                   "<"  + number + ">")
                cats = " ".join([person, number, mood])
                if forms:
                    paradigm.update({cats: forms})

def print_forms(cats, forms):
    print(cats + "\t" + term.bold(", ".join(forms)))

def print_paradigm(paradigm):
    if args.json:
        print(json.dumps(paradigm, ensure_ascii=False))
    else:
        for cats in paradigm:
            if paradigm[cats]:
                print_forms(cats, paradigm[cats])

def main():
    e = False
    try:
        transducer = sfst_transduce.Transducer(args.transducer)
        get_forms(args.lemma, transducer)
        if paradigm:
            print_paradigm(paradigm)
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
    elif not paradigm:
        exit = 1
    else:
        exit = 0
    return exit

if __name__ == "__main__":
    sys.exit(main())
