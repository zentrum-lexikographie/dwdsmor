#!/usr/bin/python3
# generate-verb-paradigm.py -- generate a paradigm of verb forms
# Andreas Nolda 2022-03-25

import sys
import argparse
import re
import sfst_transduce
from os import path

version = 1.2

basedir = path.dirname(__file__)
libdir  = path.join(basedir, "SMORLemma")
libfile = path.join(libdir, "smor.a")

parser = argparse.ArgumentParser()
parser.add_argument("lemma",
                    help="verb")
parser.add_argument("-t", "--transducer", default=libfile,
                    help="transducer file")
parser.add_argument("-v", "--version", action="version",
                    version="{0} {1}".format(parser.prog, version))
args = parser.parse_args()

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
        for mode in modes:
            for number in numbers:
                for person in persons:
                    forms = transducer.generate(stem + "<~>" + affix + "<+" + pos    + ">" +
                                                                       "<"  + person + ">" +
                                                                       "<"  + number + ">" +
                                                                       "<"  + tense  + ">" +
                                                                       "<"  + mode   + ">")
                    cats = " ".join([person, number, tense, mode])
                    if forms:
                        paradigm.update({cats: forms})
    for mode in imp_modes:
        for number in imp_numbers:
            for person in imp_persons:
                forms = transducer.generate(stem + "<~>" + affix + "<+" + pos    + ">" +
                                                                   "<"  + mode   + ">" +
                                                                   "<"  + number + ">")
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
    e = False
    try:
        transducer = sfst_transduce.Transducer(args.transducer)
        get_forms(args.lemma, transducer)
        print_paradigm(paradigm)
        if not paradigm:
            print(args.lemma + ": No such lemma.", file=sys.stderr)
    except KeyboardInterrupt:
        sys.exit(130)
    except TypeError:
        print(args.transducer + ": No such transducer file.", file=sys.stderr)
        e = True
    except RuntimeError:
        print(args.transducer + ": No such transducer.", file=sys.stderr)
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
