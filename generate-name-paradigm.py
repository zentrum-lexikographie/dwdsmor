#!/usr/bin/python3
# generate-name-paradigm.py -- generate a paradigm of proper-name forms
# Andreas Nolda 2022-06-21

import sys
import os
import argparse
import json
import sfst_transduce
from blessings import Terminal

version = 1.0

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "smor-full.a")

pos     = "NPROP"
genders = ["Masc", "Neut", "Fem", "NoGend"]
cases   = ["Nom", "Acc", "Dat", "Gen"]
numbers = ["Sg", "Pl"]

paradigm = {}

def get_forms(lemma, transducer, old_forms=False):
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
                if old_forms:
                    forms = transducer.generate(lemma + "<+" + pos    + ">" +
                                                        "<"  + gender + ">" +
                                                        "<"  + case   + ">" +
                                                        "<"  + number + ">" +
                                                        "<"  + "Old"  + ">")
                    cats = " ".join([case, number])
                    if forms:
                        if paradigm[cats]:
                            paradigm[cats].extend(forms)
                        else:
                            paradigm.update({cats: forms})

def print_forms(cats, forms, force_color=False):
    term = Terminal(force_styling=force_color)
    print(cats + "\t" + term.bold(", ".join(forms)))

def print_paradigm(paradigm, force_color=False, output_format="tsv"):
    if output_format == "json":
        print(json.dumps(paradigm, ensure_ascii=False))
    else:
        for cats in paradigm:
            if paradigm[cats]:
                print_forms(cats, paradigm[cats], force_color)

def main():
    e = False
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("lemma",
                            help="proper-name lemma")
        parser.add_argument("-C", "--force-color", action="store_true",
                            help="preserve color and formatting when piping output")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-o", "--old-forms", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-t", "--transducer", default=libfile,
                            help="transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
        parser.add_argument("-v", "--version", action="version",
                            version="{0} {1}".format(parser.prog, version))
        args = parser.parse_args()
        term = Terminal(force_styling=args.force_color)
        transducer = sfst_transduce.Transducer(args.transducer)
        get_forms(args.lemma, transducer, old_forms=args.old_forms)
        if paradigm:
            if args.json:
                output_format = "json"
            else:
                output_format = "tsv"
            print_paradigm(paradigm, args.force_color, output_format)
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