#!/usr/bin/python3
# generate-noun-paradigm.py -- generate a paradigm of noun forms
# Andreas Nolda 2022-03-25

import sys
import argparse
import sfst_transduce
from blessings import Terminal
from os import path

version = 1.3

basedir = path.dirname(__file__)
libdir  = path.join(basedir, "SMORLemma")
libfile = path.join(libdir, "smor.a")

parser = argparse.ArgumentParser()
parser.add_argument("lemma",
                    help="noun")
parser.add_argument("-c", "--force-color", action="store_true",
                    help="preserve color and formatting when piping output")
parser.add_argument("-t", "--transducer", default=libfile,
                    help="transducer file")
parser.add_argument("-v", "--version", action="version",
                    version="{0} {1}".format(parser.prog, version))
args = parser.parse_args()

term = Terminal(force_styling=args.force_color)

pos     = "NN"
genders = ["Masc", "Neut", "Fem", "NoGend"]
cases   = ["Nom", "Acc", "Dat", "Gen"]
numbers = ["Sg", "Pl"]

paradigm = {}

def get_forms(lemma, transducer):
    for gender in genders:
        for number in numbers:
            for case in cases:
                forms = transducer.generate(lemma + "<+" + pos    + ">" +
                                                    "<"  + gender + ">" +
                                                    "<"  + case   + ">" +
                                                    "<"  + number + ">")
                cats = " ".join([case, number])
                if forms:
                    paradigm.update({cats: forms})

def print_forms(cats, forms):
    print(cats + "\t" + term.bold(", ".join(forms)))

def print_paradigm(paradigm):
    for cats in paradigm:
        if paradigm[cats]:
            print_forms(cats, paradigm[cats])

def main():
    e = False
    try:
        transducer = sfst_transduce.Transducer(args.transducer)
        get_forms(args.lemma, transducer)
        print_paradigm(paradigm)
        if not paradigm:
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
