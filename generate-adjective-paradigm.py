#!/usr/bin/python3
# generate-adjective-paradigm.py -- generate a paradigm of adjective forms
# Andreas Nolda 2022-05-13

import sys
import os
import argparse
import json
import sfst_transduce
from blessings import Terminal

version = 1.2

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-full.a")

parser = argparse.ArgumentParser()
parser.add_argument("lemma",
                    help="adjective lemma")
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

pos     = "ADJ"
degrees = ["Pos", "Comp", "Sup"]
genders = ["Masc", "Neut", "Fem", "NoGend"]
cases   = ["Nom", "Acc", "Dat", "Gen"]
numbers = ["Sg", "Pl"]
infls   = ["St", "Wk", ""]

uninfls = ["Invar", "Pred"]

paradigm = {}

def get_forms(lemma, transducer):
    for degree in degrees:
        for uninfl in uninfls:
            forms = transducer.generate(lemma + "<+" + pos    + ">" +
                                                "<"  + degree + ">" +
                                                "<"  + uninfl + ">")
            cats = " ".join([degree, uninfl])
            if forms:
                paradigm.update({cats: forms})
    for degree in degrees:
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for infl in infls:
                        if infl:
                            forms = transducer.generate(lemma + "<+" + pos    + ">" +
                                                                "<"  + degree + ">" +
                                                                "<"  + gender + ">" +
                                                                "<"  + case   + ">" +
                                                                "<"  + number + ">" +
                                                                "<"  + infl   + ">")
                            cats = " ".join([degree, gender, case, number, infl])
                            if forms:
                                paradigm.update({cats: forms})
                        else:
                            forms = transducer.generate(lemma + "<+" + pos    + ">" +
                                                                "<"  + degree + ">" +
                                                                "<"  + gender + ">" +
                                                                "<"  + case   + ">" +
                                                                "<"  + number + ">")
                            cats = " ".join([degree, gender, case, number, "St"])
                            if forms:
                                paradigm.update({cats: forms})
                            cats = " ".join([degree, gender, case, number, "Wk"])
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
