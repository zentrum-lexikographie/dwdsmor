#!/usr/bin/python3
# generate-noun-paradigm.py -- generate a paradigm of noun forms
# Andreas Nolda 2022-03-24

import sys
import argparse
import sfst_transduce
from os import path

version = 1.0

parser = argparse.ArgumentParser()
parser.add_argument("lemma",
                    help="noun")
parser.add_argument("-v", "--version", action="version",
                    version="{0} {1}".format(parser.prog, version))
args = parser.parse_args()

transducer_dir  = "SMORLemma"
transducer_file = path.join(transducer_dir, "smor.a")

transducer = sfst_transduce.Transducer(transducer_file)

pos     = "NN"
genders = ["Masc", "Neut", "Fem", "NoGend"]
cases   = ["Nom", "Acc", "Dat", "Gen"]
numbers = ["Sg", "Pl"]

paradigm = {}

def get_forms(lemma):
    for gender in genders:
        for number in numbers:
            for case in cases:
                forms = transducer.generate(lemma + "<+" + pos + ">" +
                                                    "<" + gender + ">" +
                                                    "<" + case + ">" +
                                                    "<" + number + ">")
                cats = case + " " + number
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
