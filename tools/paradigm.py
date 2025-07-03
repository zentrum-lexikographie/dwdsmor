#!/usr/bin/env python3
# paradigm.py -- generate paradigms with DWDSmor
# Andreas Nolda 2025-07-03

import argparse
import csv
import json
import sys
from collections import defaultdict, namedtuple
from itertools import filterfalse, product
from pathlib import Path

from analysis import analyze_word, generate_words, seg_lemma

from blessings import Terminal

from dwdsmor import automaton, tag

import yaml


progname = Path(__file__).name

version = 18.1


IDX = range(1, 9)


POS = ("NN", "NPROP", "ADJ", "CARD", "ORD", "FRAC", "ART",
       "DEM", "INDEF", "POSS", "PPRO", "REL", "WPRO", "V")

SUBCATS = ("Def", "Indef", "Neg", "Pers", "Refl", "Rec")

DEGREES = ("Pos", "Comp", "Sup")

PERSONS = ("1", "2", "3")

GENDERS = ("Masc", "Neut", "Fem", "UnmGend")

CASES = ("Nom", "Acc", "Dat", "Gen", "UnmCase")

NUMBERS = ("Sg", "Pl", "UnmNum")

INFLECTIONS = ("St", "Wk", "UnmInfl")

FUNCTIONS = ("Attr", "Subst", "Attr/Subst", "Pred/Adv", "UnmFunc")

MOODS = ("Ind", "Subj")

TENSES = ("Pres", "Perf", "Past", "PastPerf", "Fut", "FutPerf")

AUXILIARIES = ("haben", "sein")


NONST = "NonSt"

OLD = "Old"

OLDORTH = "OLDORTH"

CH = "CH"


TAG_NONST = "ugs."

TAG_OLD = "va."

TAG_OLDORTH = "ung."

TAG_CH = "CH"


SEG_HABEN = "hab<~>en"

SEG_SEIN = "sei<~>n"

SEG_WERDEN = "werd<~>en"


LIDX_HABEN = None

LIDX_SEIN = 3

LIDX_WERDEN = None


PIDX_HABEN = None

PIDX_SEIN = None

PIDX_WERDEN = 1


LEXCAT = ["pos",
          "subcat",
          "auxiliary",
          "person",
          "gender"]

PARCAT = ["degree",
          "person",
          "gender",
          "case",
          "number",
          "inflection",
          "nonfinite",
          "function",
          "mood",
          "tense"]


LABEL_MAP = {"lemma": "Lemma",
             "lidx": "Lemma Index",
             "pidx": "Paradigm Index",
             "categories": "Categories",
             "pos": "POS",
             "subcat": "Subcategory",
             "auxiliary": "Auxiliary",
             "person": "Person",
             "gender": "Gender",
             "paradigm": {"categories": "Paradigm Categories",
                          "degree": "Degree",
                          "person": "Person",
                          "gender": "Gender",
                          "case": "Case",
                          "number": "Number",
                          "inflection": "Inflection",
                          "nonfinite": "Nonfinite",
                          "function": "Function",
                          "mood": "Mood",
                          "tense": "Tense",
                          "forms": "Paradigm Forms"}}


Lexcat = namedtuple("Lexcat", LEXCAT, defaults=[None] * len(LEXCAT[1:]))

Parcat = namedtuple("Parcat", PARCAT, defaults=[None] * len(PARCAT))


Formspec = namedtuple("Formspec", ["lidx", "pidx",
                                   "lexcat", "parcat"])

Lemmaspec = namedtuple("Lemmaspec", ["lidx", "pidx", "seg_lemma",
                                     "pos", "subcat", "person", "gender"])


def filter_categorisations(categorisations, pos):
    if pos in ["ADJ", "ART", "CARD", "DEM", "FRAC", "INDEF", "NN",
               "NPROP", "ORD", "POSS", "PPRO", "REL", "WPRO"]:
        # Nom, Acc, Dat, and Gen do not co-occur with UnmNum.
        categorisations = filterfalse(lambda cat: "Nom" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Acc" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Dat" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Gen" in cat and "UnmNum" in cat,
                                      categorisations)
        # Nom, Acc, Dat, and Gen do not co-occur with UnmFunc.
        categorisations = filterfalse(lambda cat: "Nom" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Acc" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Dat" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Gen" in cat and "UnmFunc" in cat,
                                      categorisations)
        # Sg and Pl do not co-occur with UnmFunc.
        categorisations = filterfalse(lambda cat: "Sg" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Pl" in cat and "UnmFunc" in cat,
                                      categorisations)
    if pos in ["ADJ", "ART", "CARD", "DEM", "FRAC", "INDEF", "NN",
               "ORD", "POSS", "REL", "WPRO"]:
        # UnmGend does not co-occur with Sg.
        categorisations = filterfalse(lambda cat: "UnmGend" in cat and "Sg" in cat,
                                      categorisations)
        # Masc, Neut, and Fem do not co-occur with Pl.
        categorisations = filterfalse(lambda cat: "Masc" in cat and "Pl" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Neut" in cat and "Pl" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Fem" in cat and "Pl" in cat,
                                      categorisations)
        # Masc, Neut, and Fem do not co-occur with UnmCase.
        categorisations = filterfalse(lambda cat: "Masc" in cat and "UnmCase" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Neut" in cat and "UnmCase" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Fem" in cat and "UnmCase" in cat,
                                      categorisations)
        # Masc, Neut, and Fem do not co-occur with UnmNum.
        categorisations = filterfalse(lambda cat: "Masc" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Neut" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Fem" in cat and "UnmNum" in cat,
                                      categorisations)
        # Masc, Neut, and Fem do not co-occur with UnmFunc.
        categorisations = filterfalse(lambda cat: "Masc" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Neut" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Fem" in cat and "UnmFunc" in cat,
                                      categorisations)
        # Dat and Gen do not co-occur with UnmInfl.
        categorisations = filterfalse(lambda cat: "Dat" in cat and "UnmInfl" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Gen" in cat and "UnmInfl" in cat,
                                      categorisations)
        # St and Wk do not co-occur with UnmCase.
        categorisations = filterfalse(lambda cat: "St" in cat and "UnmCase" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Wk" in cat and "UnmCase" in cat,
                                      categorisations)
        # St and Wk do not co-occur with UnmNum.
        categorisations = filterfalse(lambda cat: "St" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Wk" in cat and "UnmNum" in cat,
                                      categorisations)
        # St and Wk do not co-occur with UnmFunc.
        categorisations = filterfalse(lambda cat: "St" in cat and "UnmFunc" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Wk" in cat and "UnmFunc" in cat,
                                      categorisations)
    if pos in ["ADJ", "DEM", "NN", "ORD", "REL", "WPRO"]:
        # Sg and Pl do not co-occur with UnmInfl.
        categorisations = filterfalse(lambda cat: "Sg" in cat and "UnmInfl" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Pl" in cat and "UnmInfl" in cat,
                                      categorisations)
    if pos in ["ART", "CARD", "DEM", "INDEF", "POSS", "REL", "WPRO"]:
        # There are no categories Attr/Subst or Pred/Adv.
        categorisations = filterfalse(lambda cat: "Attr/Subst" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Pred/Adv" in cat,
                                      categorisations)
    if pos in ["ADJ", "ORD"]:
        # There is no category Subst.
        categorisations = filterfalse(lambda cat: "Subst" in cat,
                                      categorisations)
        # Pred/Adv does not co-occur with any category.
        categorisations = filterfalse(lambda cat: "Pred/Adv" in cat and len(cat) > 1,
                                      categorisations)
    if pos == "V":
        # Ind and Subj do not co-occur with UnmNum.
        categorisations = filterfalse(lambda cat: "Ind" in cat and "UnmNum" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Subj" in cat and "UnmNum" in cat,
                                      categorisations)
    return categorisations


def format_orthinfo(orthinfo):
    return f"<{orthinfo}>" if orthinfo else ""


def format_lidx(lidx):
    return f"<IDX{lidx}>" if lidx else ""


def format_pidx(pidx):
    return f"<PAR{pidx}>" if pidx else ""


def format_pos(pos):
    return f"<{pos}>"


def format_categorisation(categorisation):
    return "".join([f"<{cat}>" for cat in categorisation])


def format_inf_cl(form):
    return "zu" + " " + form


def format_prev_verb_form(form, prev):
    return form[len(prev):] + " " + prev


def format_double_prev_verb_form(form, prev, prev2):
    return form[len(prev2 + prev):] + " " + prev2 + " " + prev


def format_tags(tags):
    return "(" + ", ".join(tags) + ")"


def generate_forms(generator, lidx, pidx, seg,
                   pos, categorisation, orthinfo=""):
    forms = generate_words(generator, format_orthinfo(orthinfo) + seg
                                                                + format_lidx(lidx)
                                                                + format_pidx(pidx)
                                                                + format_pos(pos)
                                                                + format_categorisation(categorisation))
    return forms


def add_forms(formdict, lidx, pidx,
              lexcat, parcat, forms):
    if forms:
        formdict[Formspec(lidx, pidx,
                          lexcat, parcat)].extend(set(forms))


def add_special_forms(formdict, lidx, pidx,
                      lexcat, parcat, forms,
                      tags):
    if forms:
        formatted_forms = [form + " " + format_tags(tags)
                           for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, formatted_forms)


def add_sup_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms):
    if forms:
        complex_forms = ["am " + form
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_sup_forms(formdict, lidx, pidx,
                          lexcat, parcat, forms,
                          tags):
    if forms:
        complex_forms = ["am " + form + " " + format_tags(tags)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_perf_forms(formdict, lidx, pidx,
                   lexcat, parcat, forms, parts):
    if forms:
        complex_forms = [form + " " + part
                         for form in forms
                         for part in parts]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_perf_forms(formdict, lidx, pidx,
                           lexcat, parcat, forms, parts,
                           tags):
    if forms:
        complex_forms = [form + " " + part + " " + format_tags(tags)
                         for form in forms
                         for part in parts]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_fut_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms, infs):
    if forms:
        complex_forms = [form + " " + inf
                         for form in forms
                         for inf in infs]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_fut_forms(formdict, lidx, pidx,
                          lexcat, parcat, forms, infs,
                          tags):
    if forms:
        complex_forms = [form + " " + inf + " " + format_tags(tags)
                         for form in forms
                         for inf in infs]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_futperf_forms(formdict, lidx, pidx,
                      lexcat, parcat, forms, infs, parts):
    if forms:
        complex_forms = [form + " " + part + " " + inf
                         for form in forms
                         for part in parts
                         for inf in infs]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_futperf_forms(formdict, lidx, pidx,
                              lexcat, parcat, forms, infs, parts,
                              tags):
    if forms:
        complex_forms = [form + " " + part + " " + inf + " " + format_tags(tags)
                         for form in forms
                         for part in parts
                         for inf in infs]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_nonfinite_perf_forms(formdict, lidx, pidx,
                             lexcat, parcat, forms, parts):
    if forms:
        complex_forms = [part + " " + form
                         for part in parts
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_nonfinite_perf_forms(formdict, lidx, pidx,
                                     lexcat, parcat, forms, parts,
                                     tags):
    if forms:
        complex_forms = [part + " " + form + " " + format_tags(tags)
                         for part in parts
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_prev_verb_forms(formdict, lidx, pidx,
                        lexcat, parcat, forms, prev):
    if forms:
        complex_forms = [format_prev_verb_form(form, prev)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_prev_verb_forms(formdict, lidx, pidx,
                                lexcat, parcat, forms, prev,
                                tags):
    if forms:
        complex_forms = [format_prev_verb_form(form, prev) + " " + format_tags(tags)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_double_prev_verb_forms(formdict, lidx, pidx,
                               lexcat, parcat, forms, prev, prev2):
    if forms:
        complex_forms = [format_double_prev_verb_form(form, prev, prev2)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                       lexcat, parcat, forms, prev, prev2,
                                       tags):
    if forms:
        complex_forms = [format_double_prev_verb_form(form, prev, prev2) + " " + format_tags(tags)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_imp_prev_verb_forms(formdict, lidx, pidx,
                            lexcat, parcat, forms, prev):
    if forms:
        complex_forms = [format_prev_verb_form(form, prev)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_imp_prev_verb_forms(formdict, lidx, pidx,
                                    lexcat, parcat, forms, prev,
                                    tags):
    if forms:
        complex_forms = [format_prev_verb_form(form, prev) + " " + format_tags(tags)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                   lexcat, parcat, forms, prev, prev2):
    if forms:
        complex_forms = [format_double_prev_verb_form(form, prev, prev2)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def add_special_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                           lexcat, parcat, forms, prev, prev2,
                                           tags):
    if forms:
        complex_forms = [format_double_prev_verb_form(form, prev, prev2) + " " + format_tags(tags)
                         for form in forms]
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, complex_forms)


def get_noun_formdict(generator, lidx, pidx, seg,
                      pos, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos,
                    gender=gender)
    # nominalised adjectives
    categorisations = product(NUMBERS, CASES, INFLECTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case, inflection in categorisations:
        parcat = Parcat(case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation, OLDORTH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, oldorth_forms,
                              [TAG_OLDORTH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
        if ch:
            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                      pos, categorisation, CH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass

    # other nouns
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        parcat = Parcat(case=case,
                        number=number)
        categorisation = [gender,
                          case,
                          number]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            old_forms = generate_forms(generator, lidx, pidx, seg,
                                       pos, categorisation + [OLD])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, old_forms,
                              [TAG_OLD])
        if oldorth:
            oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation, OLDORTH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, oldorth_forms,
                              [TAG_OLDORTH])
            if nonst:
                nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                     pos, categorisation + [NONST], OLDORTH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, nonst_oldorth_forms,
                                  [TAG_NONST, TAG_OLDORTH])
            if old:
                old_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                   pos, categorisation + [OLD], OLDORTH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, old_oldorth_forms,
                                  [TAG_OLD, TAG_OLDORTH])
        if ch:
            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                      pos, categorisation, CH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                pos, categorisation + [NONST], CH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, nonst_ch_forms,
                                  [TAG_NONST, TAG_CH])
            if old:
                old_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                              pos, categorisation + [OLD], CH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, old_ch_forms,
                                  [TAG_OLD, TAG_CH])
    return formdict


def get_adjective_formdict(generator, lidx, pidx, seg,
                           pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos)
    for degree in DEGREES:
        # non-attributive forms
        parcat = Parcat(degree=degree,
                        function="Pred/Adv")
        categorisation = [degree,
                          "Pred/Adv"]
        nonattributive_forms = generate_forms(generator, lidx, pidx, seg,
                                              pos, categorisation)
        if degree == "Sup":
            add_sup_forms(formdict, lidx, pidx,
                          lexcat, parcat, nonattributive_forms)
        else:
            add_forms(formdict, lidx, pidx,
                      lexcat, parcat, nonattributive_forms)
        if nonst:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation, OLDORTH)
            if degree == "Sup":
                add_special_sup_forms(formdict, lidx, pidx,
                                      lexcat, parcat, oldorth_forms,
                                      [TAG_OLDORTH])
            else:
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, oldorth_forms,
                                  [TAG_OLDORTH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
        if ch:
            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                      pos, categorisation, CH)
            if degree == "Sup":
                add_special_sup_forms(formdict, lidx, pidx,
                                      lexcat, parcat, ch_forms,
                                      [TAG_CH])
            else:
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, ch_forms,
                                  [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass

    for degree in DEGREES:
        # forms inflected for degree, gender, case, number, and inflectional strength
        categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
        categorisations = filter_categorisations(categorisations, pos)
        for gender, number, case, inflection, function in categorisations:
            parcat = Parcat(degree=degree,
                            function=function,
                            gender=gender,
                            case=case,
                            number=number,
                            inflection=inflection)
            categorisation = [degree,
                              function,
                              gender,
                              case,
                              number,
                              inflection]
            forms = generate_forms(generator, lidx, pidx, seg,
                                   pos, categorisation)
            add_forms(formdict, lidx, pidx,
                      lexcat, parcat, forms)
            if nonst:
                # no such forms
                pass
            if old:
                old_forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation + [OLD])
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, old_forms,
                                  [TAG_OLD])
            if oldorth:
                oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                               pos, categorisation, OLDORTH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, oldorth_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    old_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation + [OLD], OLDORTH)
                    add_special_forms(formdict, lidx, pidx,
                                      lexcat, parcat, old_oldorth_forms,
                                      [TAG_OLD, TAG_OLDORTH])
            if ch:
                ch_forms = generate_forms(generator, lidx, pidx, seg,
                                          pos, categorisation, CH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, ch_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    old_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                  pos, categorisation + [OLD], CH)
                    add_special_forms(formdict, lidx, pidx,
                                      lexcat, parcat, old_ch_forms,
                                      [TAG_OLD, TAG_CH])
    return formdict


def get_article_formdict(generator, lidx, pidx, seg,
                         pos, subcat, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos,
                    subcat=subcat)
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function=function,
                        gender=gender,
                        case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [subcat,
                          function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass
    return formdict


def get_cardinal_formdict(generator, lidx, pidx, seg,
                          pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos)
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function=function,
                        gender=gender,
                        case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                      pos, categorisation, CH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                pos, categorisation + [NONST], CH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, nonst_ch_forms,
                                  [TAG_NONST, TAG_CH])
            if old:
                # no such forms
                pass
    return formdict


def get_ordinal_formdict(generator, lidx, pidx, seg,
                         pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos)
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function=function,
                        gender=gender,
                        case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                      pos, categorisation, CH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
    return formdict


def get_fraction_formdict(generator, lidx, pidx, seg,
                          pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos)
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function=function,
                        gender=gender,
                        case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                      pos, categorisation, CH)
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
    return formdict


def get_adjectival_pronoun_formdict(generator, lidx, pidx, seg,
                                    pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    lexcat = Lexcat(pos=pos)
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function=function,
                        gender=gender,
                        case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass
    return formdict


def get_substantival_pronoun_formdict(generator, lidx, pidx, seg,
                                      pos, subcat, person, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        if gender:
            lexcat = Lexcat(pos=pos,
                            subcat=subcat,
                            person=person,
                            gender=gender)
            parcat = Parcat(case=case,
                            number=number)
            categorisation = [subcat,
                              person,
                              gender,
                              case,
                              number]
        else:
            lexcat = Lexcat(pos=pos,
                            subcat=subcat,
                            person=person)
            parcat = Parcat(case=case,
                            number=number)
            categorisation = [subcat,
                              person,
                              case,
                              number]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            old_forms = generate_forms(generator, lidx, pidx, seg,
                                       pos, categorisation + [OLD])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, old_forms,
                              [TAG_OLD])
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass
    return formdict


def get_other_pronoun_formdict(generator, lidx, pidx, seg,
                               pos, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    # fixed gender
    lexcat = Lexcat(pos=pos,
                    gender=gender)
    # forms with fixed gender and inflected for case and number
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        parcat = Parcat(case=case,
                        number=number)
        categorisation = [gender,
                          case,
                          number]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            old_forms = generate_forms(generator, lidx, pidx, seg,
                                       pos, categorisation + [OLD])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, old_forms,
                              [TAG_OLD])
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass

    # no fixed gender
    lexcat = Lexcat(pos=pos)
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function=function,
                        gender=gender,
                        case=case,
                        number=number,
                        inflection=inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(generator, lidx, pidx, seg,
                               pos, categorisation)
        add_forms(formdict, lidx, pidx,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation + [NONST])
            add_special_forms(formdict, lidx, pidx,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass
    return formdict


def get_verb_formdict(generator, lidx, pidx, seg,
                      pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    word_list = seg.split(f"<{tag.prev_boundary}>")
    word_count = len(word_list)
    prev = word_list[1] if word_count == 3 else word_list[0] if word_count == 2 else ""
    prev2 = word_list[0] if word_count == 3 else ""
    for auxiliary in AUXILIARIES:
        categorisation = ["Part",
                          "Perf",
                          auxiliary]
        part_perf_forms = generate_forms(generator, lidx, pidx, seg,
                                         pos, categorisation)
        if oldorth:
            oldorth_part_perf_forms = generate_forms(generator, lidx, pidx, seg,
                                                     pos, categorisation, OLDORTH)
        if ch:
            ch_part_perf_forms = generate_forms(generator, lidx, pidx, seg,
                                                pos, categorisation, CH)
        # test whether the past participle actually selects the auxiliary
        if part_perf_forms:
            lexcat = Lexcat(pos=pos,
                            auxiliary=auxiliary)
            # infinitives
            parcat = Parcat(nonfinite="Inf",
                            function="NonCl",
                            tense="Pres")
            categorisation = ["Inf",
                              "NonCl"]
            inf_forms = generate_forms(generator, lidx, pidx, seg,
                                       pos, categorisation)
            add_forms(formdict, lidx, pidx,
                      lexcat, parcat, inf_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_inf_forms = generate_forms(generator, lidx, pidx, seg,
                                                   pos, categorisation, OLDORTH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, oldorth_inf_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                ch_inf_forms = generate_forms(generator, lidx, pidx, seg,
                                              pos, categorisation, CH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, ch_inf_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            parcat = Parcat(nonfinite="Inf",
                            function="Cl",
                            tense="Pres")
            categorisation = ["Inf",
                              "Cl"]
            inf_cl_forms = generate_forms(generator, lidx, pidx, seg,
                                          pos, categorisation)
            if not inf_cl_forms:
                inf_cl_forms = [format_inf_cl(inf_form) for inf_form in inf_forms]
            add_forms(formdict, lidx, pidx,
                      lexcat, parcat, inf_cl_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_inf_cl_forms = generate_forms(generator, lidx, pidx, seg,
                                                      pos, categorisation, OLDORTH)
                if not oldorth_inf_cl_forms:
                    oldorth_inf_cl_forms = [format_inf_cl(oldorth_inf_form) for oldorth_inf_form in oldorth_inf_forms]
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, oldorth_inf_cl_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                ch_inf_cl_forms = generate_forms(generator, lidx, pidx, seg,
                                                 pos, categorisation, CH)
                if not ch_inf_cl_forms:
                    ch_inf_cl_forms = [format_inf_cl(ch_inf_form) for ch_inf_form in ch_inf_forms]
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, ch_inf_cl_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            parcat = Parcat(nonfinite="Inf",
                            function="NonCl",
                            tense="Perf")
            add_nonfinite_perf_forms(formdict, lidx, pidx,
                                     lexcat, parcat, [auxiliary], part_perf_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_special_nonfinite_perf_forms(formdict, lidx, pidx,
                                                 lexcat, parcat, [auxiliary], oldorth_part_perf_forms,
                                                 [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                add_special_nonfinite_perf_forms(formdict, lidx, pidx,
                                                 lexcat, parcat, [auxiliary], ch_part_perf_forms,
                                                 [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            parcat = Parcat(nonfinite="Inf",
                            function="Cl",
                            tense="Perf")
            add_nonfinite_perf_forms(formdict, lidx, pidx,
                                     lexcat, parcat, [format_inf_cl(auxiliary)], part_perf_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_special_nonfinite_perf_forms(formdict, lidx, pidx,
                                                 lexcat, parcat, [format_inf_cl(auxiliary)], oldorth_part_perf_forms,
                                                 [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                add_special_nonfinite_perf_forms(formdict, lidx, pidx,
                                                 lexcat, parcat, [format_inf_cl(auxiliary)], ch_part_perf_forms,
                                                 [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            # participles
            parcat = Parcat(nonfinite="Part",
                            tense="Pres")
            categorisation = ["Part",
                              "Pres"]
            part_pres_forms = generate_forms(generator, lidx, pidx, seg,
                                             pos, categorisation)
            add_forms(formdict, lidx, pidx,
                      lexcat, parcat, part_pres_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_part_pres_forms = generate_forms(generator, lidx, pidx, seg,
                                                         pos, categorisation, OLDORTH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, oldorth_part_pres_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                ch_part_pres_forms = generate_forms(generator, lidx, pidx, seg,
                                                    pos, categorisation, CH)
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, ch_part_pres_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            parcat = Parcat(nonfinite="Part",
                            tense="Perf")
            categorisation = ["Part",
                              "Perf",
                              auxiliary]
            add_forms(formdict, lidx, pidx,
                      lexcat, parcat, part_perf_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, oldorth_part_perf_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                add_special_forms(formdict, lidx, pidx,
                                  lexcat, parcat, ch_part_perf_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            # indicative and subjunctive forms
            categorisations = product(TENSES, MOODS, NUMBERS, PERSONS)
            categorisations = filter_categorisations(categorisations, pos)
            for tense, mood, number, person in categorisations:
                parcat = Parcat(person=person,
                                number=number,
                                mood=mood,
                                tense=tense)
                if tense == "Perf":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    if auxiliary == "haben":
                        forms = generate_forms(generator, LIDX_HABEN, PIDX_HABEN, SEG_HABEN,
                                               pos, categorisation)
                    elif auxiliary == "sein":
                        forms = generate_forms(generator, LIDX_SEIN, PIDX_SEIN, SEG_SEIN,
                                               pos, categorisation)
                    add_perf_forms(formdict, lidx, pidx,
                                   lexcat, parcat, forms, part_perf_forms)
                    if nonst:
                        if auxiliary == "haben":
                            nonst_forms = generate_forms(generator, LIDX_HABEN, PIDX_HABEN, SEG_HABEN,
                                                         pos, categorisation + [NONST])
                        elif auxiliary == "sein":
                            nonst_forms = generate_forms(generator, LIDX_SEIN, PIDX_SEIN, SEG_SEIN,
                                                         pos, categorisation + [NONST])
                        add_special_perf_forms(formdict, lidx, pidx,
                                               lexcat, parcat, nonst_forms, part_perf_forms,
                                               [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_perf_forms(formdict, lidx, pidx,
                                               lexcat, parcat, forms, oldorth_part_perf_forms,
                                               [TAG_OLDORTH])
                        if nonst:
                            add_special_perf_forms(formdict, lidx, pidx,
                                                   lexcat, parcat, nonst_forms, oldorth_part_perf_forms,
                                                   [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_perf_forms(formdict, lidx, pidx,
                                               lexcat, parcat, forms, ch_part_perf_forms,
                                               [TAG_CH])
                        if nonst:
                            add_special_perf_forms(formdict, lidx, pidx,
                                                   lexcat, parcat, nonst_forms, ch_part_perf_forms,
                                                   [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                if tense == "PastPerf":
                    categorisation = [person,
                                      number,
                                      "Past",
                                      mood]
                    if auxiliary == "haben":
                        forms = generate_forms(generator, LIDX_HABEN, PIDX_HABEN, SEG_HABEN,
                                               pos, categorisation)
                    elif auxiliary == "sein":
                        forms = generate_forms(generator, LIDX_SEIN, PIDX_SEIN, SEG_SEIN,
                                               pos, categorisation)
                    add_perf_forms(formdict, lidx, pidx,
                                   lexcat, parcat, forms, part_perf_forms)
                    if nonst:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_perf_forms(formdict, lidx, pidx,
                                               lexcat, parcat, forms, oldorth_part_perf_forms,
                                               [TAG_OLDORTH])
                        if nonst:
                            # no such forms
                            pass
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_perf_forms(formdict, lidx, pidx,
                                               lexcat, parcat, forms, ch_part_perf_forms,
                                               [TAG_CH])
                        if nonst:
                            # no such forms
                            pass
                        if old:
                            # no such forms
                            pass

                elif tense == "Fut":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    forms = generate_forms(generator, LIDX_WERDEN, PIDX_WERDEN, SEG_WERDEN,
                                           pos, categorisation)
                    add_fut_forms(formdict, lidx, pidx,
                                  lexcat, parcat, forms, inf_forms)
                    if nonst:
                        nonst_forms = generate_forms(generator, LIDX_WERDEN, PIDX_WERDEN, SEG_WERDEN,
                                                     pos, categorisation + [NONST])
                        add_special_fut_forms(formdict, lidx, pidx,
                                              lexcat, parcat, nonst_forms, inf_forms,
                                              [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_fut_forms(formdict, lidx, pidx,
                                              lexcat, parcat, forms, oldorth_inf_forms,
                                              [TAG_OLDORTH])
                        if nonst:
                            add_special_fut_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, nonst_forms, oldorth_inf_forms,
                                                  [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_fut_forms(formdict, lidx, pidx,
                                              lexcat, parcat, forms, ch_inf_forms,
                                              [TAG_CH])
                        if nonst:
                            add_special_fut_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, nonst_forms, ch_inf_forms,
                                                  [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                elif tense == "FutPerf":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    forms = generate_forms(generator, LIDX_WERDEN, PIDX_WERDEN, SEG_WERDEN,
                                           pos, categorisation)
                    add_futperf_forms(formdict, lidx, pidx,
                                      lexcat, parcat, forms, [auxiliary], part_perf_forms)
                    if nonst:
                        nonst_forms = generate_forms(generator, LIDX_WERDEN, PIDX_WERDEN, SEG_WERDEN,
                                                     pos, categorisation + [NONST])
                        add_special_futperf_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, nonst_forms, [auxiliary], part_perf_forms,
                                                  [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_futperf_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, forms, [auxiliary], oldorth_part_perf_forms,
                                                  [TAG_OLDORTH])
                        if nonst:
                            add_special_futperf_forms(formdict, lidx, pidx,
                                                      lexcat, parcat, nonst_forms, [auxiliary], oldorth_part_perf_forms,
                                                      [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_futperf_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, forms, [auxiliary], ch_part_perf_forms,
                                                  [TAG_CH])
                        if nonst:
                            add_special_futperf_forms(formdict, lidx, pidx,
                                                      lexcat, parcat, nonst_forms, [auxiliary], ch_part_perf_forms,
                                                      [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                else:
                    categorisation = [person,
                                      number,
                                      tense,
                                      mood]
                    if prev and prev2:
                        forms = generate_forms(generator, lidx, pidx, seg,
                                               pos, categorisation)
                        add_double_prev_verb_forms(formdict, lidx, pidx,
                                                   lexcat, parcat, forms, prev, prev2)
                        if nonst:
                            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                                         pos, categorisation + [NONST])
                            add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, nonst_forms, prev, prev2,
                                                               [TAG_NONST])
                        if old:
                            old_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation + [OLD])
                            add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, old_forms, prev, prev2,
                                                               [TAG_OLD])
                        if oldorth:
                            oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                           pos, categorisation, OLDORTH)
                            add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, oldorth_forms, prev, prev2,
                                                               [TAG_OLDORTH])
                            if nonst:
                                nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                     pos, categorisation + [NONST], OLDORTH)
                                add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                                   lexcat, parcat, nonst_oldorth_forms, prev, prev2,
                                                                   [TAG_NONST, TAG_OLDORTH])
                            if old:
                                old_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                   pos, categorisation + [OLD], OLDORTH)
                                add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                                   lexcat, parcat, old_oldorth_forms, prev, prev2,
                                                                   [TAG_OLD, TAG_OLDORTH])
                        if ch:
                            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                      pos, categorisation, CH)
                            add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, ch_forms, prev, prev2,
                                                               [TAG_CH])
                            if nonst:
                                nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                                pos, categorisation + [NONST], CH)
                                add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                                   lexcat, parcat, nonst_ch_forms, prev, prev2,
                                                                   [TAG_NONST, TAG_CH])
                            if old:
                                old_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                              pos, categorisation + [OLD], CH)
                                add_special_double_prev_verb_forms(formdict, lidx, pidx,
                                                                   lexcat, parcat, old_ch_forms, prev, prev2,
                                                                   [TAG_OLD, TAG_CH])

                    elif prev:
                        forms = generate_forms(generator, lidx, pidx, seg,
                                               pos, categorisation)
                        add_prev_verb_forms(formdict, lidx, pidx,
                                            lexcat, parcat, forms, prev)
                        if nonst:
                            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                                         pos, categorisation + [NONST])
                            add_special_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, nonst_forms, prev,
                                                        [TAG_NONST])
                        if old:
                            old_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation + [OLD])
                            add_special_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, old_forms, prev,
                                                        [TAG_OLD])
                        if oldorth:
                            oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                           pos, categorisation, OLDORTH)
                            add_special_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, oldorth_forms, prev,
                                                        [TAG_OLDORTH])
                            if nonst:
                                nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                     pos, categorisation + [NONST], OLDORTH)
                                add_special_prev_verb_forms(formdict, lidx, pidx,
                                                            lexcat, parcat, nonst_oldorth_forms, prev,
                                                            [TAG_NONST, TAG_OLDORTH])
                            if old:
                                old_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                   pos, categorisation + [OLD], OLDORTH)
                                add_special_prev_verb_forms(formdict, lidx, pidx,
                                                            lexcat, parcat, old_oldorth_forms, prev,
                                                            [TAG_OLD, TAG_OLDORTH])
                        if ch:
                            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                      pos, categorisation, CH)
                            add_special_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, ch_forms, prev,
                                                        [TAG_CH])
                            if nonst:
                                nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                                pos, categorisation + [NONST], CH)
                                add_special_prev_verb_forms(formdict, lidx, pidx,
                                                            lexcat, parcat, nonst_ch_forms, prev,
                                                            [TAG_NONST, TAG_CH])
                            if old:
                                old_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                              pos, categorisation + [OLD], CH)
                                add_special_prev_verb_forms(formdict, lidx, pidx,
                                                            lexcat, parcat, old_ch_forms, prev,
                                                            [TAG_OLD, TAG_CH])

                    else:
                        forms = generate_forms(generator, lidx, pidx, seg,
                                               pos, categorisation)
                        add_forms(formdict, lidx, pidx,
                                  lexcat, parcat, forms)
                        if nonst:
                            nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                                         pos, categorisation + [NONST])
                            add_special_forms(formdict, lidx, pidx,
                                              lexcat, parcat, nonst_forms,
                                              [TAG_NONST])
                        if old:
                            old_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation + [OLD])
                            add_special_forms(formdict, lidx, pidx,
                                              lexcat, parcat, old_forms,
                                              [TAG_OLD])
                        if oldorth:
                            oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                           pos, categorisation, OLDORTH)
                            add_special_forms(formdict, lidx, pidx,
                                              lexcat, parcat, oldorth_forms,
                                              [TAG_OLDORTH])
                            if nonst:
                                nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                     pos, categorisation + [NONST], OLDORTH)
                                add_special_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, nonst_oldorth_forms,
                                                  [TAG_NONST, TAG_OLDORTH])
                            if old:
                                old_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                   pos, categorisation + [OLD], OLDORTH)
                                add_special_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, old_oldorth_forms,
                                                  [TAG_OLD, TAG_OLDORTH])
                        if ch:
                            ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                      pos, categorisation, CH)
                            add_special_forms(formdict, lidx, pidx,
                                              lexcat, parcat, ch_forms,
                                              [TAG_CH])
                            if nonst:
                                nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                                pos, categorisation + [NONST], CH)
                                add_special_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, nonst_ch_forms,
                                                  [TAG_NONST, TAG_CH])
                            if old:
                                old_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                              pos, categorisation + [OLD], CH)
                                add_special_forms(formdict, lidx, pidx,
                                                  lexcat, parcat, old_ch_forms,
                                                  [TAG_OLD, TAG_CH])

            # imperative forms
            for number in NUMBERS:
                parcat = Parcat(number=number,
                                mood="Imp")
                categorisation = ["Imp",
                                  number]
                if prev and prev2:
                    forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation)
                    add_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                                   lexcat, parcat, forms, prev, prev2)
                    if nonst:
                        nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                                     pos, categorisation + [NONST])
                        add_special_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, nonst_forms, prev, prev2,
                                                               [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation, OLDORTH)
                        add_special_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, oldorth_forms, prev, prev2,
                                                               [TAG_OLDORTH])
                        if nonst:
                            nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                 pos, categorisation + [NONST], OLDORTH)
                            add_special_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                                                   lexcat, parcat, nonst_oldorth_forms, prev, prev2,
                                                                   [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                  pos, categorisation, CH)
                        add_special_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                                               lexcat, parcat, ch_forms, prev, prev2,
                                                               [TAG_CH])
                        if nonst:
                            nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                            pos, categorisation + [NONST], CH)
                            add_special_imp_double_prev_verb_forms(formdict, lidx, pidx,
                                                                   lexcat, parcat, nonst_ch_forms, prev, prev2,
                                                                   [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                elif prev:
                    forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation)
                    add_imp_prev_verb_forms(formdict, lidx, pidx,
                                            lexcat, parcat, forms, prev)
                    if nonst:
                        nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                                     pos, categorisation + [NONST])
                        add_special_imp_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, nonst_forms, prev,
                                                        [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation, OLDORTH)
                        add_special_imp_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, oldorth_forms, prev,
                                                        [TAG_OLDORTH])
                        if nonst:
                            nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                 pos, categorisation + [NONST], OLDORTH)
                            add_special_imp_prev_verb_forms(formdict, lidx, pidx,
                                                            lexcat, parcat, nonst_oldorth_forms, prev,
                                                            [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                  pos, categorisation, CH)
                        add_special_imp_prev_verb_forms(formdict, lidx, pidx,
                                                        lexcat, parcat, ch_forms, prev,
                                                        [TAG_CH])
                        if nonst:
                            nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                            pos, categorisation + [NONST], CH)
                            add_special_imp_prev_verb_forms(formdict, lidx, pidx,
                                                            lexcat, parcat, nonst_ch_forms, prev,
                                                            [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                else:
                    forms = generate_forms(generator, lidx, pidx, seg,
                                           pos, categorisation)
                    add_forms(formdict, lidx, pidx,
                              lexcat, parcat, forms)
                    if nonst:
                        nonst_forms = generate_forms(generator, lidx, pidx, seg,
                                                     pos, categorisation + [NONST])
                        add_special_forms(formdict, lidx, pidx,
                                          lexcat, parcat, nonst_forms,
                                          [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                       pos, categorisation, OLDORTH)
                        add_special_forms(formdict, lidx, pidx,
                                          lexcat, parcat, oldorth_forms,
                                          [TAG_OLDORTH])
                        if nonst:
                            nonst_oldorth_forms = generate_forms(generator, lidx, pidx, seg,
                                                                 pos, categorisation + [NONST], OLDORTH)
                            add_special_forms(formdict, lidx, pidx,
                                              lexcat, parcat, nonst_oldorth_forms,
                                              [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                  pos, categorisation, CH)
                        add_special_forms(formdict, lidx, pidx,
                                          lexcat, parcat, ch_forms,
                                          [TAG_CH])
                        if nonst:
                            nonst_ch_forms = generate_forms(generator, lidx, pidx, seg,
                                                            pos, categorisation + [NONST], CH)
                            add_special_forms(formdict, lidx, pidx,
                                              lexcat, parcat, nonst_ch_forms,
                                              [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass
    return formdict


def get_formdict(generator, lidx, pidx, seg,
                 pos, subcat, person, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = defaultdict(list)
    # nouns
    if pos in ["NN", "NPROP"]:
        formdict = get_noun_formdict(generator, lidx, pidx, seg,
                                     pos, gender, nonst, old, oldorth, ch)
    # adjectives
    elif pos == "ADJ":
        formdict = get_adjective_formdict(generator, lidx, pidx, seg,
                                          pos, nonst, old, oldorth, ch)
    # articles
    elif pos == "ART":
        formdict = get_article_formdict(generator, lidx, pidx, seg,
                                        pos, subcat, nonst, old, oldorth, ch)
    # cardinals
    elif pos == "CARD":
        formdict = get_cardinal_formdict(generator, lidx, pidx, seg,
                                         pos, nonst, old, oldorth, ch)
    # ordinals
    elif pos == "ORD":
        formdict = get_ordinal_formdict(generator, lidx, pidx, seg,
                                        pos, nonst, old, oldorth, ch)
    # fractions
    elif pos == "FRAC":
        formdict = get_fraction_formdict(generator, lidx, pidx, seg,
                                         pos, nonst, old, oldorth, ch)
    # demonstrative and possessive pronouns
    elif pos in ["DEM", "POSS"]:
        formdict = get_adjectival_pronoun_formdict(generator, lidx, pidx, seg,
                                                   pos, nonst, old, oldorth, ch)
    # personal pronouns
    elif pos == "PPRO":
        formdict = get_substantival_pronoun_formdict(generator, lidx, pidx, seg,
                                                     pos, subcat, person, gender, nonst, old, oldorth, ch)
    # other pronouns
    elif pos in ["INDEF", "REL", "WPRO"]:
        formdict = get_other_pronoun_formdict(generator, lidx, pidx, seg,
                                              pos, gender, nonst, old, oldorth, ch)
    # verbs
    elif pos == "V":
        formdict = get_verb_formdict(generator, lidx, pidx, seg,
                                     pos, nonst, old, oldorth, ch)
    return formdict


def sort_lemmaspec(lemmaspec):
    lidx = lemmaspec.lidx if lemmaspec.lidx else 0
    pidx = lemmaspec.pidx if lemmaspec.pidx else 0
    seg = lemmaspec.seg_lemma
    pos = POS.index(lemmaspec.pos)
    subcat = SUBCATS.index(lemmaspec.subcat) if lemmaspec.subcat else None
    person = PERSONS.index(lemmaspec.person) if lemmaspec.person else None
    gender = GENDERS.index(lemmaspec.gender) if lemmaspec.gender else None
    return (lidx, pidx, seg,
            pos, subcat, person, gender)


def sort_form(form):
    key = -1
    for index, tags in enumerate([format_tags([TAG_NONST]),
                                  format_tags([TAG_OLD]),
                                  format_tags([TAG_OLDORTH]),
                                  format_tags([TAG_NONST, TAG_OLDORTH]),
                                  format_tags([TAG_OLD, TAG_OLDORTH]),
                                  format_tags([TAG_CH]),
                                  format_tags([TAG_NONST, TAG_CH]),
                                  format_tags([TAG_OLD, TAG_CH])]):
        if form.endswith(tags):
            key = index
    return (key, form)


def create_formdict(generator, analyzer, automaton_type,
                    lemma, lidx=None, pidx=None,
                    pos=None, user_specified=False, nonst=False, old=False, oldorth=False, ch=False):
    lemmaspecs = []
    if user_specified:
        seg = lemma
        if pos == "ART":
            lemmaspecs = [Lemmaspec(lidx, pidx, seg,
                                    pos, subcat, None, None)
                          for subcat in SUBCATS]
        elif pos == "PPRO":
            lemmaspecs = [Lemmaspec(lidx, pidx, seg,
                                    pos, subcat, person, gender)
                          for subcat in SUBCATS
                          for person in PERSONS
                          for gender in GENDERS]
        elif pos in ["INDEF", "NN", "NPROP", "REL", "WPRO"]:
            lemmaspecs = [Lemmaspec(lidx, pidx, seg,
                                    pos, None, None, gender)
                          for gender in GENDERS]
        else:
            lemmaspecs = [Lemmaspec(lidx, pidx, seg,
                                    pos, None, None, None)]
    else:
        traversals = analyze_word(analyzer, lemma, automaton_type)
        lemmaspecs = sorted({Lemmaspec(traversal.lidx, traversal.pidx, seg_lemma(traversal),
                                       traversal.pos, traversal.category, None, None)
                             if traversal.pos == "ART"
                             else Lemmaspec(traversal.lidx, traversal.pidx, seg_lemma(traversal),
                                            traversal.pos, traversal.category, traversal.person, traversal.gender)
                             if traversal.pos == "PPRO"
                             else Lemmaspec(traversal.lidx, traversal.pidx, seg_lemma(traversal),
                                            traversal.pos, None, None, traversal.gender)
                             if traversal.pos in ["INDEF", "NN", "NPROP", "REL", "WPRO"] and traversal.function not in FUNCTIONS
                             else Lemmaspec(traversal.lidx, traversal.pidx, seg_lemma(traversal),
                                            traversal.pos, None, None, None)
                             for traversal in traversals if traversal.analysis == lemma and traversal.pos in POS},
                            key=sort_lemmaspec)
        if lidx in IDX:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.lidx == lidx]
        if pidx in IDX:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.pidx == pidx]
        if pos in POS:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.pos == pos]
    formdict = defaultdict(list)
    for lemmaspec in lemmaspecs:
        formdict_for_lemmaspec = get_formdict(generator, *lemmaspec, nonst=nonst, old=old, oldorth=oldorth, ch=ch)
        for key, value in formdict_for_lemmaspec.items():
            formdict[key] = sorted(set(formdict[key] + value), key=sort_form)

    return formdict


def paradigm_subset(formdict, lidx, pidx, lexcat):
    return [(key, value)
            for key, value in formdict.items()
            if key.lidx == lidx and key.pidx == pidx and key.lexcat == lexcat]


def cat_dict(cats):
    return {key: value
            for key, value in cats._asdict().items()
            if value}


def cat_list(cats):
    # remove duplicates while preserving order
    return {"categories": list(dict.fromkeys(value for value in cat_dict(cats).values()))}


def get_paradigm_dict(lemma, formdict, lidx, pidx, lexcat,
                      no_cats=False, no_lemma=False, empty=False):
    cat_value = cat_list if no_cats else cat_dict
    paradigm_dict = {"lemma": lemma,
                     "lidx": lidx,
                     "pidx": pidx,
                     **cat_value(lexcat),
                     "paradigm": [{**cat_value(key.parcat),
                                   "forms": value}
                                  for key, value in paradigm_subset(formdict, lidx, pidx, lexcat)]}
    if no_lemma:
        for key in ["lemma", "lidx", "pidx"]:
            del paradigm_dict[key]
        for key in list(cat_value(lexcat)):
            del paradigm_dict[key]
    if not empty:
        for key, value in list(paradigm_dict.items()):
            if not value:
                del paradigm_dict[key]
    return paradigm_dict


def get_paradigm_dicts(lemma, formdict,
                       no_cats=False, no_lemma=False, empty=False):
    paradigm_dicts = []
    # remove duplicates while preserving order
    for lidx, pidx, lexcat in list(dict.fromkeys((key.lidx, key.pidx, key.lexcat)
                                                 for key in formdict.keys())):
        paradigm_dict = get_paradigm_dict(lemma, formdict, lidx, pidx, lexcat,
                                          no_cats, no_lemma, empty)
        paradigm_dicts.append(paradigm_dict)
    return paradigm_dicts


def get_value_of_paradigm_key(key, paradigm):
    value = paradigm.get(key, "") or ""
    if isinstance(value, int):
        formatted_value = str(value)
    elif isinstance(value, list):
        if key == "forms":
            formatted_value = ", ".join(value)
        else:
            formatted_value = " ".join(value)
    else:
        formatted_value = value
    return formatted_value


def output_string(string):
    return string


def output_json(paradigms, output_file):
    json.dump(paradigms, output_file, ensure_ascii=False)


def output_yaml(paradigms, output_file):
    yaml.dump(paradigms, output_file, allow_unicode=True, sort_keys=False, explicit_start=True)


def output_dsv(paradigms, output_file, keys, paradigm_keys,
               header=True, plain=False, force_color=False, delimiter="\t"):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)
    plain = output_string
    csv_writer = csv.writer(output_file, delimiter=delimiter, lineterminator="\n")

    key_format = {"lemma": term.bold_underline,
                  "lidx": term.underline,
                  "pidx": term.underline,
                  "categories": term.underline,
                  "pos": term.underline,
                  "subcat": term.underline,
                  "auxiliary": term.underline,
                  "person": term.underline,
                  "gender": term.underline,
                  "paradigm": {"categories": plain,
                               "degree": plain,
                               "person": plain,
                               "gender": plain,
                               "case": plain,
                               "number": plain,
                               "inflection": plain,
                               "nonfinite": plain,
                               "function": plain,
                               "mood": plain,
                               "tense": plain,
                               "forms": term.bold}}

    if header:
        header_row = [key_format[key](LABEL_MAP[key]) for key in keys]
        header_row += [key_format["paradigm"][key](LABEL_MAP["paradigm"][key]) for key in paradigm_keys]
        csv_writer.writerow(header_row)

    for paradigm_dict in paradigms:
        for paradigm in paradigm_dict["paradigm"]:
            row = [key_format[key](get_value_of_paradigm_key(key, paradigm_dict)) for key in keys]
            row += [key_format["paradigm"][key](get_value_of_paradigm_key(key, paradigm)) for key in paradigm_keys]
            csv_writer.writerow(row)


def output_paradigms(generator, analyzer, output_file, automaton_type,
                     lemma, lidx=None, pidx=None,
                     pos=None, user_specified=False, nonst=False, old=False, oldorth=False, ch=False,
                     no_cats=False, no_lemma=False, empty=False,
                     header=True, plain=False, force_color=False, output_format="tsv"):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)
    formdict = create_formdict(generator, analyzer, automaton_type,
                               lemma, lidx, pidx,
                               pos, user_specified, nonst, old, oldorth, ch)

    if formdict:
        paradigms = get_paradigm_dicts(lemma, formdict,
                                       no_cats, no_lemma, empty)

        if output_format == "json":
            output_json(paradigms, output_file)
        elif output_format == "yaml":
            output_yaml(paradigms, output_file)
        else:
            keys = [key for key, value in LABEL_MAP.items() if isinstance(value, str)]
            paradigm_keys = [key for key, value in LABEL_MAP["paradigm"].items() if isinstance(value, str)]

            if no_cats:
                for key in LEXCAT:
                    keys.remove(key)
                for key in PARCAT:
                    paradigm_keys.remove(key)
            else:
                keys.remove("categories")
                paradigm_keys.remove("categories")

            if no_lemma:
                keys = []

            if not empty:
                keys_with_values = {key for paradigm_dict in paradigms
                                    for key, value in paradigm_dict.items()
                                    if isinstance(value, (str, int, list))}
                paradigm_keys_with_values = {key for paradigm_dict in paradigms
                                             for paradigm in paradigm_dict["paradigm"]
                                             for key, value in paradigm.items()
                                             if isinstance(value, (str, int, list))}
                keys = [key for key in keys if key in keys_with_values]
                paradigm_keys = [key for key in paradigm_keys if key in key in paradigm_keys_with_values]

            if output_format == "csv":
                output_dsv(paradigms, output_file, keys, paradigm_keys,
                           header, plain, force_color, delimiter=",")
            else:
                output_dsv(paradigms, output_file, keys, paradigm_keys,
                           header, plain, force_color)
    else:
        if lidx and pidx and pos:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of lemma index {lidx}, paradigm index {pidx}, "
                  f"and part-of-speech {pos}",
                  file=sys.stderr)
        elif lidx and pos:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of lemma index {lidx} and part-of-speech {pos}",
                  file=sys.stderr)
        elif pidx and pos:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of paradigm index {pidx} and part-of-speech {pos}",
                  file=sys.stderr)
        elif lidx and pidx:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of lemma index {lidx} and paradigm index {pidx}",
                  file=sys.stderr)
        elif lidx:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of lemma index {lidx}",
                  file=sys.stderr)
        elif pidx:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of paradigm index {pidx}",
                  file=sys.stderr)
        elif pos:
            print(f"{progname}: {term.bold(lemma)}: "
                  f"no such lemma of part-of-speech {pos}",
                  file=sys.stderr)
        elif user_specified:
            print(f"{progname}: {term.bold(lemma)}: "
                  "no user-specified part of speech for lemma",
                  file=sys.stderr)
        else:
            print(f"{progname}: {term.bold(lemma)}: "
                  "no such lemma (for a pseudo-lemma, use --user-specified)",
                  file=sys.stderr)


def main():
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
        parser.add_argument("-d", "--automata-dir",
                            help="automata directory")
        parser.add_argument("-e", "--empty", action="store_true",
                            help="show empty columns or values")
        parser.add_argument("-H", "--no-header", action="store_false",
                            help="suppress table header")
        parser.add_argument("-i", "--lemma-index", type=int, choices=IDX,
                            help="homographic lemma index")
        parser.add_argument("-I", "--paradigm-index", type=int, choices=IDX,
                            help="paradigm index")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-n", "--no-cats", action="store_true",
                            help="do not output category names")
        parser.add_argument("-N", "--no-lemma", action="store_true",
                            help="do not output lemma, lemma index, paradigm index, and lexical categories")
        parser.add_argument("-o", "--old", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-O", "--oldorth", action="store_true",
                            help="output also forms in old spelling")
        parser.add_argument("-p", "--pos", choices=POS,
                            help="part of speech")
        parser.add_argument("-P", "--plain", action="store_true",
                            help="suppress color and formatting")
        parser.add_argument("-s", "--nonst", action="store_true",
                            help="output also non-standard forms")
        parser.add_argument("-S", "--ch", action="store_true",
                            help="output also forms in Swiss spelling")
        parser.add_argument("-t", "--automaton-type", choices=automaton.automaton_types, default="index",
                            help="automaton type (default: index)")
        parser.add_argument("-u", "--user-specified", action="store_true",
                            help="use only user-specified information")
        parser.add_argument("-v", "--version", action="version",
                            version=f"{parser.prog} {version}")
        parser.add_argument("-y", "--yaml", action="store_true",
                            help="output YAML document")
        args = parser.parse_args()

        if args.automata_dir:
            if Path(args.automata_dir).is_dir():
                automata_dir = args.automata_dir
            else:
                print(f"{progname}: {args.automata_dir} is not a directory")
                sys.exit(1)
        else:
            automata_dir = automaton.detect_root_dir()

        automata = automaton.automata(automata_dir)
        analyzer = automata.analyzer(args.automaton_type)
        generator = automata.generator(args.automaton_type)

        if args.json:
            output_format = "json"
        elif args.yaml:
            output_format = "yaml"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"

        output_paradigms(generator, analyzer, args.output, args.automaton_type,
                         args.lemma, args.lemma_index, args.paradigm_index,
                         args.pos, args.user_specified, args.nonst, args.old, args.oldorth, args.ch,
                         args.no_cats, args.no_lemma, args.empty,
                         args.no_header, args.plain, args.force_color, output_format)
    except automaton.AutomataDirNotFound:
        print(f"{progname}: automata directory not found (set it with --automata-dir)", file=sys.stderr)
        sys.exit(1)
    except AssertionError as error:
        print(f"{progname}: {error}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(130)
    return 0


if __name__ == "__main__":
    sys.exit(main())
