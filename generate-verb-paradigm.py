#!/usr/bin/python3
# generate-verb-paradigm.py -- generate a paradigm of verb forms
# Andreas Nolda 2022-03-24

import sys
import argparse
import re
import sfst_transduce
from os import path

version = 1.1

parser = argparse.ArgumentParser()
parser.add_argument("lemma",
                    help="verb")
parser.add_argument("-v", "--version", action="version",
                    version="{0} {1}".format(parser.prog, version))
args = parser.parse_args()

transducer_dir  = "SMORLemma"
transducer_file = path.join(transducer_dir, "smor.a")

transducer = sfst_transduce.Transducer(transducer_file)

pos     = "V"
persons = ["1", "2", "3"]
numbers = ["Sg", "Pl"]
tenses  = ["Pres", "Past"]
modes   = ["Ind", "Subj"]

imp_persons = ["2"]
imp_numbers = numbers
imp_modes   = ["Imp"]

infs = ["Inf", "PPres", "PPast"]

paradigm = {}

def get_forms(lemma):
    stem  = re.sub(r"^(.+?)e?n$", r"\1", lemma)
    affix = re.sub(r"^.+?(e?n)$", r"\1", lemma)
    for inf in infs:
        forms = transducer.generate(stem + "<~>" + affix + "<+" + pos + ">" +
                                                           "<" + inf + ">")
        cats = " ".join([inf])
        if forms:
            paradigm.update({cats: forms})
    for tense in tenses:
        for mode in modes:
            for number in numbers:
                for person in persons:
                    forms = transducer.generate(stem + "<~>" + affix + "<+" + pos + ">" +
                                                                       "<" + person + ">" +
                                                                       "<" + number + ">" +
                                                                       "<" + tense + ">" +
                                                                       "<" + mode + ">")
                    cats = " ".join([person, number, tense, mode])
                    if forms:
                        paradigm.update({cats: forms})
    for mode in imp_modes:
        for number in imp_numbers:
            for person in imp_persons:
                forms = transducer.generate(stem + "<~>" + affix + "<+" + pos + ">" +
                                                                   "<" + mode + ">" +
                                                                   "<" + number + ">")
                cats = " ".join([person, number, mode])
                if forms:
                    paradigm.update({cats: forms})

def print_forms(cats, forms):
    print(cats + "\t" + ", ".join(forms))

def print_paradigm(paradigm):
    for cats in paradigm:
        if paradigm[cats]:
            print_forms(cats, paradigm[cats])

def main():
    try:
        get_forms(args.lemma)
        print_paradigm(paradigm)
    except KeyboardInterrupt:
        sys.exit(130)
    if not paradigm:
        print(args.lemma + ": No such lemma.", file=sys.stderr)
        exit = 1
    else:
        exit = 0
    return exit

if __name__ == "__main__":
    sys.exit(main())
