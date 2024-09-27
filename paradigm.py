#!/usr/bin/env python3
# paradigm.py -- generate paradigms
# Andreas Nolda 2024-09-27

import sys
import argparse
import re
import csv
import json
import yaml
from os import path, getcwd
from collections import namedtuple
from itertools import filterfalse, product

from blessings import Terminal

import sfst_transduce

from dwdsmor import analyse_word


version = 13.0


BASEDIR = path.dirname(__file__)

LIBDIR = path.join(BASEDIR, "lib")

LIBFILE = path.join(LIBDIR, "dwdsmor-index.a")


INDICES = [1, 2, 3, 4, 5, 6, 7, 8]


POS = ["ADJ", "ART", "CARD", "DEM", "FRAC", "INDEF", "NN",
       "NPROP", "ORD", "POSS", "PPRO", "REL", "V", "WPRO"]

SUBCATS = ["Def", "Indef", "Neg", "Pers", "Refl", "Rec"]

DEGREES = ["Pos", "Comp", "Sup"]

PERSONS = ["1", "2", "3"]

GENDERS = ["Masc", "Neut", "Fem", "NoGend"]

CASES = ["Nom", "Acc", "Dat", "Gen"]

NUMBERS = ["Sg", "Pl"]

INFLECTIONS = ["NoInfl", "St", "Wk"]

FUNCTIONS = ["Attr", "Subst", "Attr/Subst", "Pred/Adv"]

MOODS = ["Ind", "Subj"]

TENSES = ["Pres", "Perf", "Past", "PastPerf", "Fut", "FutPerf"]

AUXILIARIES = ["haben", "sein"]


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


LEMMA_INDEX_HABEN = None

LEMMA_INDEX_SEIN = 3

LEMMA_INDEX_WERDEN = None


PARADIGM_INDEX_HABEN = None

PARADIGM_INDEX_SEIN = None

PARADIGM_INDEX_WERDEN = 1


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
          "function",
          "nonfinite",
          "mood",
          "tense"]


LABEL_MAP = {"lemma": "Lemma",
             "lemma_index": "Lemma Index",
             "paradigm_index": "Paradigm Index",
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
                          "function": "Function",
                          "nonfinite": "Nonfinite",
                          "mood": "Mood",
                          "tense": "Tense",
                          "forms": "Paradigm Forms"}}


Lexcat = namedtuple("Lexcat", LEXCAT, defaults=[None] * len(LEXCAT[1:]))

Parcat = namedtuple("Parcat", PARCAT, defaults=[None] * len(PARCAT))


Formspec = namedtuple("Formspec", ["lemma_index", "paradigm_index",
                                   "lexcat", "parcat"])

Lemmaspec = namedtuple("Lemmaspec", ["lemma_index", "paradigm_index", "seg_lemma",
                                     "pos", "subcat", "person", "gender"])


def filter_categorisations(categorisations, pos):
    # Masc, Neut, Fem, and NoGend
    if pos in ["ADJ", "ART", "CARD", "DEM", "INDEF", "ORD", "POSS", "REL", "WPRO"]:
        # Masc, Neut, and Fem do not co-occur with Pl.
        categorisations = filterfalse(lambda cat: "Masc" in cat and "Pl" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Neut" in cat and "Pl" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Fem" in cat and "Pl" in cat,
                                      categorisations)
        # NoGend does not co-occur with Sg.
        categorisations = filterfalse(lambda cat: "NoGend" in cat and "Sg" in cat,
                                      categorisations)
    # NoInfl
    if pos in ["ADJ", "NN", "ORD"]:
        # There is no category NoInfl.
        categorisations = filterfalse(lambda cat: "NoInfl" in cat,
                                      categorisations)
    # Attr, Subst, and Pred/Adv
    if pos in ["ADJ", "ORD"]:
        # There is no category Subst.
        categorisations = filterfalse(lambda cat: "Subst" in cat,
                                      categorisations)
        # Attr co-occurs with Invar.
        categorisations = filterfalse(lambda cat: "Attr" in cat and "Invar" not in cat,
                                      categorisations)
        # Pred/Adv does not co-occur with any category.
        categorisations = filterfalse(lambda cat: "Pred/Adv" in cat and len(cat) > 1,
                                      categorisations)
    # Attr/Subst and Pred/Adv
    if pos in ["ART", "CARD", "DEM", "INDEF", "POSS", "REL", "WPRO"]:
        # There are no categories Attr/Subst or Pred/Adv.
        categorisations = filterfalse(lambda cat: "Attr/Subst" in cat,
                                      categorisations)
        categorisations = filterfalse(lambda cat: "Pred/Adv" in cat,
                                      categorisations)
    return categorisations


def string(value):
    return str(value or "")


def format_lemma_index(lemma_index):
    formatted_lemma_index = "<IDX" + string(lemma_index) + ">" if lemma_index else ""
    return formatted_lemma_index


def format_paradigm_index(paradigm_index):
    formatted_paradigm_index = "<PAR" + string(paradigm_index) + ">" if paradigm_index else ""
    return formatted_paradigm_index


def format_pos(pos):
    return "<+" + pos + ">"


def format_categorisation(categorisation):
    return "".join(["<" + string(cat) + ">"
                    for cat in categorisation])


def format_particle_verb_form(form, particle):
    return re.sub(f"^({particle})-?(.+)$", r"\2 \1", form)


def format_double_particle_verb_form(form, particle, particle_2):
    return re.sub(f"^({particle_2})-?({particle})-?(.+)$", r"\3 \1 \2", form)


def format_tags(tags):
    return "(" + ", ".join(tags) + ")"


def generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                   pos, categorisation):
    forms = transducer.generate(seg_lemma + format_lemma_index(lemma_index)
                                          + format_paradigm_index(paradigm_index)
                                          + format_pos(pos)
                                          + format_categorisation(categorisation))
    return forms


def generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                           pos, categorisation, cats):
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                           pos, categorisation + cats)
    return forms


def add_forms(formdict, lemma_index, paradigm_index,
              lexcat, parcat, forms):
    if forms:
        formdict[Formspec(lemma_index, paradigm_index,
                          lexcat, parcat)] = sorted(set(forms))


def add_additional_forms(formdict, lemma_index, paradigm_index,
                         lexcat, parcat, forms, tag=False):
    if (lemma_index, paradigm_index, lexcat, parcat) in formdict:
        formdict[Formspec(lemma_index, paradigm_index,
                          lexcat, parcat)].extend(sorted(set(forms)))
    else:
        formdict[Formspec(lemma_index, paradigm_index,
                          lexcat, parcat)] = sorted(set(forms))


def add_special_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, forms,
                      tags):
    if forms:
        formatted_forms = [form + " " + format_tags(tags)
                           for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, formatted_forms)


def add_sup_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms):
    if forms:
        complex_forms = ["am " + form
                         for form in forms]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_sup_forms(formdict, lemma_index, paradigm_index,
                          lexcat, parcat, forms,
                          tags):
    if forms:
        complex_forms = ["am " + form + " " + format_tags(tags)
                         for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_perf_forms(formdict, lemma_index, paradigm_index,
                   lexcat, parcat, forms, participles):
    if forms:
        complex_forms = [form + " " + participle
                         for form in forms
                         for participle in participles]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_perf_forms(formdict, lemma_index, paradigm_index,
                           lexcat, parcat, forms, participles,
                           tags):
    if forms:
        complex_forms = [form + " " + participle + " " + format_tags(tags)
                         for form in forms
                         for participle in participles]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_fut_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms, infinitives):
    if forms:
        complex_forms = [form + " " + infinitive
                         for form in forms
                         for infinitive in infinitives]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_fut_forms(formdict, lemma_index, paradigm_index,
                          lexcat, parcat, forms, infinitives,
                          tags):
    if forms:
        complex_forms = [form + " " + infinitive + " " + format_tags(tags)
                         for form in forms
                         for infinitive in infinitives]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_futperf_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, forms, infinitives, participles):
    if forms:
        complex_forms = [form + " " + participle + " " + infinitive
                         for form in forms
                         for participle in participles
                         for infinitive in infinitives]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_futperf_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, forms, infinitives, participles,
                              tags):
    if forms:
        complex_forms = [form + " " + participle + " " + infinitive + " " + format_tags(tags)
                         for form in forms
                         for participle in participles
                         for infinitive in infinitives]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_nonfinite_perf_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, forms, participles):
    if forms:
        complex_forms = [participle + " " + form
                         for participle in participles
                         for form in forms]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_nonfinite_perf_forms(formdict, lemma_index, paradigm_index,
                                     lexcat, parcat, forms, participles,
                                     tags):
    if forms:
        complex_forms = [participle + " " + form + " " + format_tags(tags)
                         for participle in participles
                         for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_particle_verb_forms(formdict, lemma_index, paradigm_index,
                            lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [format_particle_verb_form(form, particle)
                         for form in forms]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                    lexcat, parcat, forms, particle,
                                    tags):
    if forms:
        complex_forms = [format_particle_verb_form(form, particle) + " " + format_tags(tags)
                         for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                   lexcat, parcat, forms, particle, particle_2):
    if forms:
        complex_forms = [format_double_particle_verb_form(form, particle, particle_2)
                         for form in forms]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                           lexcat, parcat, forms, particle, particle_2,
                                           tags):
    if forms:
        complex_forms = [format_double_particle_verb_form(form, particle, particle_2) + " " + format_tags(tags)
                         for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [format_particle_verb_form(form, particle)
                         for form in forms]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                        lexcat, parcat, forms, particle,
                                        tags):
    if forms:
        complex_forms = [format_particle_verb_form(form, particle) + " " + format_tags(tags)
                         for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def add_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                       lexcat, parcat, forms, particle, particle_2):
    if forms:
        complex_forms = [format_double_particle_verb_form(form, particle, particle_2)
                         for form in forms]
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, complex_forms)


def add_special_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                               lexcat, parcat, forms, particle, particle_2,
                                               tags):
    if forms:
        complex_forms = [format_double_particle_verb_form(form, particle, particle_2) + " " + format_tags(tags)
                         for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index,
                             lexcat, parcat, complex_forms)


def get_noun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                      pos, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos,
                    gender = gender)
    # nominalised adjectives
    categorisations = product(NUMBERS, CASES, INFLECTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case, inflection in categorisations:
        parcat = Parcat(case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                   pos, categorisation, [OLDORTH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, oldorth_forms,
                              [TAG_OLDORTH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
        if ch:
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            add_special_forms(formdict, lemma_index, paradigm_index,
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
        parcat = Parcat(case = case,
                        number = number)
        categorisation = [gender,
                          case,
                          number]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                               pos, categorisation,
                                               [OLD])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, old_forms,
                              [TAG_OLD])
        if oldorth:
            oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                   pos, categorisation,
                                                   [OLDORTH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, oldorth_forms,
                              [TAG_OLDORTH])
            if nonst:
                nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                             pos, categorisation,
                                                             [NONST, OLDORTH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, nonst_oldorth_forms,
                                  [TAG_NONST, TAG_OLDORTH])
            if old:
                old_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                           pos, categorisation,
                                                           [OLD, OLDORTH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, old_oldorth_forms,
                                  [TAG_OLD, TAG_OLDORTH])
        if ch:
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                        pos, categorisation,
                                                        [NONST, CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, nonst_ch_forms,
                                  [TAG_NONST, TAG_CH])
            if old:
                old_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                      pos, categorisation,
                                                      [OLD, CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, old_ch_forms,
                                  [TAG_OLD, TAG_CH])
    return formdict


def get_adjective_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                           pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    for degree in DEGREES:
        # non-attributive forms
        parcat = Parcat(degree = degree,
                        function = "Pred/Adv")
        categorisation = [degree,
                          "Pred/Adv"]
        nonattributive_forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation)
        if degree == "Sup":
            add_sup_forms(formdict, lemma_index, paradigm_index,
                          lexcat, parcat, nonattributive_forms)
        else:
            add_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, nonattributive_forms)
        if nonst:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                   pos, categorisation,
                                                   [OLDORTH])
            if degree == "Sup":
                add_special_sup_forms(formdict, lemma_index, paradigm_index,
                                      lexcat, parcat, oldorth_forms,
                                      [TAG_OLDORTH])
            else:
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, oldorth_forms,
                                  [TAG_OLDORTH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
        if ch:
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            if degree == "Sup":
                add_special_sup_forms(formdict, lemma_index, paradigm_index,
                                      lexcat, parcat, ch_forms,
                                      [TAG_CH])
            else:
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, ch_forms,
                                  [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass

    # forms inflected for degree, but uninflected for gender, case, number,
    # and inflectional strength
    for degree in DEGREES:
        categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
        categorisations = filter_categorisations(categorisations, pos)
        for gender, number, case, inflection, function in categorisations:
            parcat = Parcat(degree = degree,
                            function = function,
                            gender = gender,
                            case = case,
                            number = number,
                            inflection = inflection)
            categorisation = [degree,
                              function,
                              "Invar"]
            forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                   pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                       pos, categorisation,
                                                       [OLDORTH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, oldorth_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                  pos, categorisation,
                                                  [CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, ch_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

        # forms inflected for degree, gender, case, number, and inflectional strength
        categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
        categorisations = filter_categorisations(categorisations, pos)
        for gender, number, case, inflection, function in categorisations:
            parcat = Parcat(degree = degree,
                            function = function,
                            gender = gender,
                            case = case,
                            number = number,
                            inflection = inflection)
            categorisation = [degree,
                              function,
                              gender,
                              case,
                              number,
                              inflection]
            forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                   pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, forms)
            if nonst:
                # no such forms
                pass
            if old:
                old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                   pos, categorisation,
                                                   [OLD])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, old_forms,
                                  [TAG_OLD])
            if oldorth:
                oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                       pos, categorisation,
                                                       [OLDORTH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, oldorth_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    old_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLD, OLDORTH])
                    add_special_forms(formdict, lemma_index, paradigm_index,
                                      lexcat, parcat, old_oldorth_forms,
                                      [TAG_OLD, TAG_OLDORTH])
            if ch:
                ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                  pos, categorisation,
                                                  [CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, ch_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    old_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                          pos, categorisation,
                                                          [OLD, CH])
                    add_special_forms(formdict, lemma_index, paradigm_index,
                                      lexcat, parcat, old_ch_forms,
                                      [TAG_OLD, TAG_CH])
    return formdict


def get_article_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                         pos, subcat, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos,
                    subcat = subcat)
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [subcat,
                          function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
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


def get_cardinal_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                          pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number,
    # and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
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
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass

    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
        if ch:
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                        pos, categorisation,
                                                        [NONST, CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, nonst_ch_forms,
                                  [TAG_NONST, TAG_CH])
            if old:
                # no such forms
                pass
    return formdict


def get_ordinal_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                         pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
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
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
    return formdict


def get_fraction_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                          pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number,
    # and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
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
            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, categorisation,
                                              [CH])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, ch_forms,
                              [TAG_CH])
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
    return formdict


def get_adjectival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                    pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number,
    # and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
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
            # no such forms
            pass

    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
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


def get_substantival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                      pos, subcat, person, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        if gender:
            lexcat = Lexcat(pos = pos,
                            subcat = subcat,
                            person = person,
                            gender = gender)
            parcat = Parcat(case = case,
                            number = number)
            categorisation = [subcat,
                              person,
                              gender,
                              case,
                              number]
        else:
            lexcat = Lexcat(pos = pos,
                            subcat = subcat,
                            person = person)
            parcat = Parcat(case = case,
                            number = number)
            categorisation = [subcat,
                              person,
                              case,
                              number]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                               pos, categorisation,
                                               [OLD])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, old_forms,
                              [TAG_OLD])
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass
    return formdict


def get_other_pronoun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    # fixed gender
    lexcat = Lexcat(pos = pos,
                    gender = gender)
    # forms with fixed gender, but uninflected for case and number
    parcat = Parcat(case = "Invar",
                    number = "Invar")
    categorisation = [gender,
                      "Invar"]
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                           pos, categorisation)
    add_forms(formdict, lemma_index, paradigm_index,
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
        # no such forms
        pass

    # forms with fixed gender and inflected for case and number
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        parcat = Parcat(case = case,
                        number = number)
        categorisation = [gender,
                          case,
                          number]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, nonst_forms,
                              [TAG_NONST])
        if old:
            old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                               pos, categorisation,
                                               [OLD])
            add_special_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, old_forms,
                              [TAG_OLD])
        if oldorth:
            # no such forms
            pass
        if ch:
            # no such forms
            pass

    # no fixed gender
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number,
    # and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
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
            # no such forms
            pass

    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function = function,
                        gender = gender,
                        case = case,
                        number = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                               pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index,
                  lexcat, parcat, forms)
        if nonst:
            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                 pos, categorisation,
                                                 [NONST])
            add_special_forms(formdict, lemma_index, paradigm_index,
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


def get_verb_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                      pos, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    seg_list = re.split("(?:<=>-)?<#>", seg_lemma)
    seg_count = len(seg_list)
    particle = seg_list[1] if seg_count == 3 else seg_list[0] if seg_count == 2 else ""
    particle_2 = seg_list[0] if seg_count == 3 else ""
    for auxiliary in AUXILIARIES:
        categorisation = ["PPast",
                          auxiliary]
        # check whether the past participle actually selects the auxiliary
        ppast_forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                     pos, categorisation)
        if oldorth:
            oldorth_ppast_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                         pos, categorisation,
                                                         [OLDORTH])
        if ch:
            ch_ppast_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                    pos, categorisation,
                                                    [CH])
        if ppast_forms:
            lexcat = Lexcat(pos = pos,
                            auxiliary = auxiliary)
            # infinitives
            parcat = Parcat(nonfinite = "Inf",
                            tense = "Pres")
            categorisation = ["Inf"]
            inf_forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                       pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, inf_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_inf_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                           pos, categorisation,
                                                           [OLDORTH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, oldorth_inf_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                ch_inf_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                      pos, categorisation,
                                                      [CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, ch_inf_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            parcat = Parcat(nonfinite = "Inf",
                            tense = "Perf")
            add_nonfinite_perf_forms(formdict, lemma_index, paradigm_index,
                                     lexcat, parcat, [auxiliary], ppast_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_special_nonfinite_perf_forms(formdict, lemma_index, paradigm_index,
                                                 lexcat, parcat, [auxiliary], oldorth_ppast_forms,
                                                 [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                add_special_nonfinite_perf_forms(formdict, lemma_index, paradigm_index,
                                                 lexcat, parcat, [auxiliary], ch_ppast_forms,
                                                 [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            # participles
            parcat = Parcat(nonfinite = "Part",
                            tense = "Pres")
            categorisation = ["PPres"]
            ppres_forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                         pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, ppres_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_ppres_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                             pos, categorisation,
                                                             [OLDORTH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, oldorth_ppres_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                ch_ppres_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                        pos, categorisation,
                                                        [CH])
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, ch_ppres_forms,
                                  [TAG_CH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass

            parcat = Parcat(nonfinite = "Part",
                            tense = "Perf")
            categorisation = ["PPast",
                              auxiliary]
            add_forms(formdict, lemma_index, paradigm_index,
                      lexcat, parcat, ppast_forms)
            if nonst:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, oldorth_ppast_forms,
                                  [TAG_OLDORTH])
                if nonst:
                    # no such forms
                    pass
                if old:
                    # no such forms
                    pass
            if ch:
                add_special_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, ch_ppast_forms,
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
                parcat = Parcat(person = person,
                                number = number,
                                mood = mood,
                                tense = tense)
                if tense == "Perf":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    if auxiliary == "haben":
                        forms = generate_forms(transducer, LEMMA_INDEX_HABEN, PARADIGM_INDEX_HABEN, SEG_HABEN,
                                               pos, categorisation)
                    elif auxiliary == "sein":
                        forms = generate_forms(transducer, LEMMA_INDEX_SEIN, PARADIGM_INDEX_SEIN, SEG_SEIN,
                                               pos, categorisation)
                    add_perf_forms(formdict, lemma_index, paradigm_index,
                                   lexcat, parcat, forms, ppast_forms)
                    if nonst:
                        if auxiliary == "haben":
                            nonst_forms = generate_special_forms(transducer, LEMMA_INDEX_HABEN, PARADIGM_INDEX_HABEN, SEG_HABEN,
                                                                 pos, categorisation,
                                                                 [NONST])
                        elif auxiliary == "sein":
                            nonst_forms = generate_special_forms(transducer, LEMMA_INDEX_SEIN, PARADIGM_INDEX_SEIN, SEG_SEIN,
                                                                 pos, categorisation,
                                                                 [NONST])
                        add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                               lexcat, parcat, nonst_forms, ppast_forms,
                                               [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                               lexcat, parcat, forms, oldorth_ppast_forms,
                                               [TAG_OLDORTH])
                        if nonst:
                            add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                                   lexcat, parcat, nonst_forms, oldorth_ppast_forms,
                                                   [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                               lexcat, parcat, forms, ch_ppast_forms,
                                               [TAG_CH])
                        if nonst:
                            add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                                   lexcat, parcat, nonst_forms, ch_ppast_forms,
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
                        forms = generate_forms(transducer, LEMMA_INDEX_HABEN, PARADIGM_INDEX_HABEN, SEG_HABEN,
                                               pos, categorisation)
                    elif auxiliary == "sein":
                        forms = generate_forms(transducer, LEMMA_INDEX_SEIN, PARADIGM_INDEX_SEIN, SEG_SEIN,
                                               pos, categorisation)
                    add_perf_forms(formdict, lemma_index, paradigm_index,
                                   lexcat, parcat, forms, ppast_forms)
                    if nonst:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                               lexcat, parcat, forms, oldorth_ppast_forms,
                                               [TAG_OLDORTH])
                        if nonst:
                            # no such forms
                            pass
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_perf_forms(formdict, lemma_index, paradigm_index,
                                               lexcat, parcat, forms, ch_ppast_forms,
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
                    forms = generate_forms(transducer, LEMMA_INDEX_WERDEN, PARADIGM_INDEX_WERDEN, SEG_WERDEN,
                                           pos, categorisation)
                    add_fut_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, forms, inf_forms)
                    if nonst:
                        nonst_forms = generate_special_forms(transducer, LEMMA_INDEX_WERDEN, PARADIGM_INDEX_WERDEN, SEG_WERDEN,
                                                             pos, categorisation,
                                                             [NONST])
                        add_special_fut_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, nonst_forms, inf_forms,
                                              [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_fut_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, forms, oldorth_inf_forms,
                                              [TAG_OLDORTH])
                        if nonst:
                            add_special_fut_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, nonst_forms, oldorth_inf_forms,
                                                  [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_fut_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, forms, ch_inf_forms,
                                              [TAG_CH])
                        if nonst:
                            add_special_fut_forms(formdict, lemma_index, paradigm_index,
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
                    forms = generate_forms(transducer, LEMMA_INDEX_WERDEN, PARADIGM_INDEX_WERDEN, SEG_WERDEN,
                                           pos, categorisation)
                    add_futperf_forms(formdict, lemma_index, paradigm_index,
                                      lexcat, parcat, forms, [auxiliary], ppast_forms)
                    if nonst:
                        nonst_forms = generate_special_forms(transducer, LEMMA_INDEX_WERDEN, PARADIGM_INDEX_WERDEN, SEG_WERDEN,
                                                             pos, categorisation,
                                                             [NONST])
                        add_special_futperf_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, nonst_forms, [auxiliary], ppast_forms,
                                                  [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_special_futperf_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, forms, [auxiliary], oldorth_ppast_forms,
                                                  [TAG_OLDORTH])
                        if nonst:
                            add_special_futperf_forms(formdict, lemma_index, paradigm_index,
                                                      lexcat, parcat, nonst_forms, [auxiliary], oldorth_ppast_forms,
                                                      [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        add_special_futperf_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, forms, [auxiliary], ch_ppast_forms,
                                                  [TAG_CH])
                        if nonst:
                            add_special_futperf_forms(formdict, lemma_index, paradigm_index,
                                                      lexcat, parcat, nonst_forms, [auxiliary], ch_ppast_forms,
                                                      [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                else:
                    categorisation = [person,
                                      number,
                                      tense,
                                      mood]
                    if particle and particle_2:
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                               pos, categorisation)
                        add_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                       lexcat, parcat, forms, particle, particle_2)
                        if nonst:
                            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                 pos, categorisation,
                                                                 [NONST])
                            add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, nonst_forms, particle, particle_2,
                                                                   [TAG_NONST])
                        if old:
                            old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLD])
                            add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, old_forms, particle, particle_2,
                                                                   [TAG_OLD])
                        if oldorth:
                            oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                   pos, categorisation,
                                                                   [OLDORTH])
                            add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, oldorth_forms, particle, particle_2,
                                                                   [TAG_OLDORTH])
                            if nonst:
                                nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                             pos, categorisation,
                                                                             [NONST, OLDORTH])
                                add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                       lexcat, parcat, nonst_oldorth_forms, particle, particle_2,
                                                                       [TAG_NONST, TAG_OLDORTH])
                            if old:
                                old_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                           pos, categorisation,
                                                                           [OLD, OLDORTH])
                                add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                       lexcat, parcat, old_oldorth_forms, particle, particle_2,
                                                                       [TAG_OLD, TAG_OLDORTH])
                        if ch:
                            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                              pos, categorisation,
                                                              [CH])
                            add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, ch_forms, particle, particle_2,
                                                                   [TAG_CH])
                            if nonst:
                                nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                        pos, categorisation,
                                                                        [NONST, CH])
                                add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                       lexcat, parcat, nonst_ch_forms, particle, particle_2,
                                                                       [TAG_NONST, TAG_CH])
                            if old:
                                old_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                      pos, categorisation,
                                                                      [OLD, CH])
                                add_special_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                       lexcat, parcat, old_ch_forms, particle, particle_2,
                                                                       [TAG_OLD, TAG_CH])

                    elif particle:
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                               pos, categorisation)
                        add_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                lexcat, parcat, forms, particle)
                        if nonst:
                            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                 pos, categorisation,
                                                                 [NONST])
                            add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, nonst_forms, particle,
                                                            [TAG_NONST])
                        if old:
                            old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLD])
                            add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, old_forms, particle,
                                                            [TAG_OLD])
                        if oldorth:
                            oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                   pos, categorisation,
                                                                   [OLDORTH])
                            add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, oldorth_forms, particle,
                                                            [TAG_OLDORTH])
                            if nonst:
                                nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                             pos, categorisation,
                                                                             [NONST, OLDORTH])
                                add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                lexcat, parcat, nonst_oldorth_forms, particle,
                                                                [TAG_NONST, TAG_OLDORTH])
                            if old:
                                old_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                           pos, categorisation,
                                                                           [OLD, OLDORTH])
                                add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                lexcat, parcat, old_oldorth_forms, particle,
                                                                [TAG_OLD, TAG_OLDORTH])
                        if ch:
                            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                              pos, categorisation,
                                                              [CH])
                            add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, ch_forms, particle,
                                                            [TAG_CH])
                            if nonst:
                                nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                        pos, categorisation,
                                                                        [NONST, CH])
                                add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                lexcat, parcat, nonst_ch_forms, particle,
                                                                [TAG_NONST, TAG_CH])
                            if old:
                                old_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                      pos, categorisation,
                                                                      [OLD, CH])
                                add_special_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                lexcat, parcat, old_ch_forms, particle,
                                                                [TAG_OLD, TAG_CH])


                    else:
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                               pos, categorisation)
                        add_forms(formdict, lemma_index, paradigm_index,
                                  lexcat, parcat, forms)
                        if nonst:
                            nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                                 [NONST])
                            add_special_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, nonst_forms,
                                              [TAG_NONST])
                        if old:
                            old_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLD])
                            add_special_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, old_forms,
                                              [TAG_OLD])
                        if oldorth:
                            oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                   pos, categorisation,
                                                                   [OLDORTH])
                            add_special_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, oldorth_forms,
                                              [TAG_OLDORTH])
                            if nonst:
                                nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                             pos, categorisation,
                                                                             [NONST, OLDORTH])
                                add_special_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, nonst_oldorth_forms,
                                                  [TAG_NONST, TAG_OLDORTH])
                            if old:
                                old_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                           pos, categorisation,
                                                                           [OLD, OLDORTH])
                                add_special_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, old_oldorth_forms,
                                                  [TAG_OLD, TAG_OLDORTH])
                        if ch:
                            ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                              pos, categorisation,
                                                              [CH])
                            add_special_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, ch_forms,
                                              [TAG_CH])
                            if nonst:
                                nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                        pos, categorisation,
                                                                        [NONST, CH])
                                add_special_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, nonst_ch_forms,
                                                  [TAG_NONST, TAG_CH])
                            if old:
                                old_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                      pos, categorisation,
                                                                      [OLD, CH])
                                add_special_forms(formdict, lemma_index, paradigm_index,
                                                  lexcat, parcat, old_ch_forms,
                                                  [TAG_OLD, TAG_CH])

            # imperative forms
            for number in NUMBERS:
                parcat = Parcat(number = number,
                                mood = "Imp")
                categorisation = ["Imp",
                                  number]
                if particle and particle_2:
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                           pos, categorisation)
                    add_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                       lexcat, parcat, forms, particle, particle_2)
                    if nonst:
                        nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                             pos, categorisation,
                                                             [NONST])
                        add_special_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, nonst_forms, particle, particle_2,
                                                                   [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLDORTH])
                        add_special_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, oldorth_forms, particle, particle_2,
                                                                   [TAG_OLDORTH])
                        if nonst:
                            nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                         pos, categorisation,
                                                                         [NONST, OLDORTH])
                            add_special_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                       lexcat, parcat, nonst_oldorth_forms, particle, particle_2,
                                                                       [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                          pos, categorisation,
                                                          [CH])
                        add_special_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                   lexcat, parcat, ch_forms, particle, particle_2,
                                                                   [TAG_CH])
                        if nonst:
                            nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                    pos, categorisation,
                                                                    [NONST, CH])
                            add_special_imp_double_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                       lexcat, parcat, nonst_ch_forms, particle, particle_2,
                                                                       [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                elif particle:
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                           pos, categorisation)
                    add_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                lexcat, parcat, forms, particle)
                    if nonst:
                        nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                             pos, categorisation,
                                                             [NONST])
                        add_special_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, nonst_forms, particle,
                                                            [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLDORTH])
                        add_special_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, oldorth_forms, particle,
                                                            [TAG_OLDORTH])
                        if nonst:
                            nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                         pos, categorisation,
                                                                         [NONST, OLDORTH])
                            add_special_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                lexcat, parcat, nonst_oldorth_forms, particle,
                                                                [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                          pos, categorisation,
                                                          [CH])
                        add_special_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                            lexcat, parcat, ch_forms, particle,
                                                            [TAG_CH])
                        if nonst:
                            nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                    pos, categorisation,
                                                                    [NONST, CH])
                            add_special_imp_particle_verb_forms(formdict, lemma_index, paradigm_index,
                                                                lexcat, parcat, nonst_ch_forms, particle,
                                                                [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass

                else:
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                           pos, categorisation)
                    add_forms(formdict, lemma_index, paradigm_index,
                              lexcat, parcat, forms)
                    if nonst:
                        nonst_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                             pos, categorisation,
                                                             [NONST])
                        add_special_forms(formdict, lemma_index, paradigm_index,
                                          lexcat, parcat, nonst_forms,
                                          [TAG_NONST])
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                               pos, categorisation,
                                                               [OLDORTH])
                        add_special_forms(formdict, lemma_index, paradigm_index,
                                          lexcat, parcat, oldorth_forms,
                                          [TAG_OLDORTH])
                        if nonst:
                            nonst_oldorth_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                         pos, categorisation,
                                                                         [NONST, OLDORTH])
                            add_special_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, nonst_oldorth_forms,
                                              [TAG_NONST, TAG_OLDORTH])
                        if old:
                            # no such forms
                            pass
                    if ch:
                        ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                          pos, categorisation,
                                                          [CH])
                        add_special_forms(formdict, lemma_index, paradigm_index,
                                          lexcat, parcat, ch_forms,
                                          [TAG_CH])
                        if nonst:
                            nonst_ch_forms = generate_special_forms(transducer, lemma_index, paradigm_index, seg_lemma,
                                                                    pos, categorisation,
                                                                    [NONST, CH])
                            add_special_forms(formdict, lemma_index, paradigm_index,
                                              lexcat, parcat, nonst_ch_forms,
                                              [TAG_NONST, TAG_CH])
                        if old:
                            # no such forms
                            pass
    return formdict


def get_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                 pos, subcat, person, gender, nonst=False, old=False, oldorth=False, ch=False):
    formdict = {}
    # nouns
    if pos in ["NN", "NPROP"]:
        formdict = get_noun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                     pos, gender, nonst, old, oldorth, ch)
    # adjectives
    elif pos == "ADJ":
        formdict = get_adjective_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                          pos, nonst, old, oldorth, ch)
    # articles
    elif pos == "ART":
        formdict = get_article_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                        pos, subcat, nonst, old, oldorth, ch)
    # cardinals
    elif pos == "CARD":
        formdict = get_cardinal_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                         pos, nonst, old, oldorth, ch)
    # ordinals
    elif pos == "ORD":
        formdict = get_ordinal_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                        pos, nonst, old, oldorth, ch)
    # fractions
    elif pos == "FRAC":
        formdict = get_fraction_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                         pos, nonst, old, oldorth, ch)
    # demonstrative and possessive pronouns
    elif pos in ["DEM", "POSS"]:
        formdict = get_adjectival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                                   pos, nonst, old, oldorth, ch)
    # personal pronouns
    elif pos == "PPRO":
        formdict = get_substantival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                                     pos, subcat, person, gender, nonst, old, oldorth, ch)
    # other pronouns
    elif pos in ["INDEF", "REL", "WPRO"]:
        formdict = get_other_pronoun_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                              pos, gender, nonst, old, oldorth, ch)
    # verbs
    elif pos == "V":
        formdict = get_verb_formdict(transducer, lemma_index, paradigm_index, seg_lemma,
                                     pos, nonst, old, oldorth, ch)
    return formdict


def sort_lemmaspec(lemmaspec):
    lemma_index = lemmaspec.lemma_index if lemmaspec.lemma_index else 0
    paradigm_index = lemmaspec.paradigm_index if lemmaspec.paradigm_index else 0
    seg_lemma = lemmaspec.seg_lemma
    pos = POS.index(lemmaspec.pos)
    subcat = SUBCATS.index(lemmaspec.subcat) if lemmaspec.subcat else None
    person = PERSONS.index(lemmaspec.person) if lemmaspec.person else None
    gender = GENDERS.index(lemmaspec.gender) if lemmaspec.gender else None
    return (lemma_index, paradigm_index, seg_lemma,
            pos, subcat, person, gender)


def generate_formdict(transducer, lemma, lemma_index=None, paradigm_index=None,
                      pos=None, user_specified=False, nonst=False, old=False, oldorth=False, ch=False):
    lemmaspecs = []
    if user_specified:
        if pos == "ART":
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index,
                                    lemma, pos, subcat, None, None)
                          for subcat in SUBCATS]
        elif pos == "PPRO":
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index,
                                    lemma, pos, subcat, person, gender)
                          for subcat in SUBCATS
                          for person in PERSONS
                          for gender in GENDERS]
        elif pos in ["INDEF", "NN", "NPROP", "REL", "WPRO"]:
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index,
                                    lemma, pos, None, None, gender)
                          for gender in GENDERS]
        else:
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index,
                                    lemma, pos, None, None, None)]
    else:
        analyses = analyse_word(transducer, lemma)
        lemmaspecs = sorted({Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.seg_lemma,
                                       analysis.pos, analysis.subcat, analysis.person, analysis.gender)
                             if analysis.pos == "PPRO"
                             else Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.seg_lemma,
                                            analysis.pos, analysis.subcat, None, None)
                             if analysis.pos == "ART"
                             else Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.seg_lemma,
                                            analysis.pos, None, None, analysis.gender)
                             if analysis.pos in ["INDEF", "NN", "NPROP", "REL", "WPRO"] and not analysis.function in FUNCTIONS
                             else Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.seg_lemma,
                                            analysis.pos, None, None, None)
                             for analysis in analyses if analysis.lemma == lemma and analysis.pos in POS},
                            key=sort_lemmaspec)
        if lemma_index in INDICES:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.lemma_index == lemma_index]
        if paradigm_index in INDICES:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.paradigm_index == paradigm_index]
        if pos in POS:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.pos == pos]
    formdict = {}
    for lemmaspec in lemmaspecs:
        formdict.update(get_formdict(transducer, *lemmaspec, nonst=nonst, old=old, oldorth=oldorth, ch=ch))
    return formdict


def paradigm_subset(formdict, lemma_index, paradigm_index, lexcat):
    return [(key, value)
            for key, value in formdict.items()
            if key.lemma_index == lemma_index and key.paradigm_index == paradigm_index and key.lexcat == lexcat]


def cat_dict(cats):
    return {key: value
            for key, value in cats._asdict().items()
            if value}


def cat_list(cats):
    # remove duplicates while preserving order
    return {"categories": list(dict.fromkeys(value for value in cat_dict(cats).values()))}


def get_paradigm_dict(lemma, formdict, lemma_index, paradigm_index, lexcat,
                      no_cats=False, no_lemma=False, empty=True):
    cat_value = cat_list if no_cats else cat_dict
    paradigm_dict = {"lemma": lemma,
                     "lemma_index": lemma_index,
                     "paradigm_index": paradigm_index,
                     **cat_value(lexcat),
                     "paradigm": [{**cat_value(key.parcat),
                                   "forms": value}
                                  for key, value in paradigm_subset(formdict, lemma_index, paradigm_index, lexcat)]}
    if no_lemma:
        for key in ["lemma", "lemma_index", "paradigm_index"]:
            del paradigm_dict[key]
        for key in list(cat_value(lexcat)):
            del paradigm_dict[key]
    if not empty:
        for key, value in list(paradigm_dict.items()):
            if not value:
                del paradigm_dict[key]
    return paradigm_dict


def get_paradigm_dicts(lemma, formdict,
                       no_cats=False, no_lemma=False, empty=True):
    paradigm_dicts = []
    # remove duplicates while preserving order
    for lemma_index, paradigm_index, lexcat in list(dict.fromkeys((key.lemma_index, key.paradigm_index, key.lexcat)
                                                                  for key in formdict.keys())):
        paradigm_dict = get_paradigm_dict(lemma, formdict, lemma_index, paradigm_index, lexcat,
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


def output_json(paradigms, output_file):
    json.dump(paradigms, output_file, ensure_ascii=False)


def output_yaml(paradigms, output_file):
    yaml.dump(paradigms, output_file, allow_unicode=True, sort_keys=False, explicit_start=True)


def output_dsv(paradigms, output_file, keys, paradigm_keys,
               header=True, plain=False, force_color=False, delimiter="\t"):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)
    plain = lambda string: string
    csv_writer = csv.writer(output_file, delimiter=delimiter, lineterminator="\n")

    key_format = {"lemma": term.bold_underline,
                  "lemma_index": term.underline,
                  "paradigm_index": term.underline,
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
                               "function": plain,
                               "nonfinite": plain,
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


def output_paradigms(transducer, lemma, output_file, lemma_index=None, paradigm_index=None,
                     pos=None, user_specified=False, nonst=False, old=False, oldorth=False, ch=False,
                     no_cats=False, no_lemma=False, empty=True,
                     header=True, plain=False, force_color=False, output_format="tsv"):
    kind = "dumb" if plain else None
    term = Terminal(kind=kind, force_styling=force_color)
    formdict = generate_formdict(transducer, lemma, lemma_index, paradigm_index,
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
        if lemma_index and paradigm_index and pos:
            print(term.bold(lemma) + ": "
                  f"No such lemma of lemma index {lemma_index}, paradigm index {paradigm_index}, "
                  f"and part-of-speech {pos}.",
                  file=sys.stderr)
        elif lemma_index and pos:
            print(term.bold(lemma) + ": "
                  f"No such lemma of lemma index {lemma_index} and part-of-speech {pos}.",
                  file=sys.stderr)
        elif paradigm_index and pos:
            print(term.bold(lemma) + ": "
                  f"No such lemma of paradigm index {paradigm_index} and part-of-speech {pos}.",
                  file=sys.stderr)
        elif lemma_index:
            print(term.bold(lemma) + ": "
                  f"No such lemma of lemma index {lemma_index}.",
                  file=sys.stderr)
        elif paradigm_index:
            print(term.bold(lemma) + ": "
                  f"No such lemma of paradigm index {paradigm_index}.",
                  file=sys.stderr)
        elif pos:
            print(term.bold(lemma) + ": "
                  f"No such lemma of part-of-speech {pos}.",
                  file=sys.stderr)
        elif user_specified:
            print(term.bold(lemma) + ": "
                  "No user-specified part of speech for lemma.",
                  file=sys.stderr)
        else:
            print(term.bold(lemma) + ": "
                  "No such lemma. (For a pseudo-lemma, use --user-specified.)",
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
        parser.add_argument("-E", "--no-empty", action="store_false",
                            help="suppress empty columns or values")
        parser.add_argument("-H", "--no-header", action="store_false",
                            help="suppress table header")
        parser.add_argument("-i", "--lemma-index", type=int, choices=INDICES,
                            help="homographic lemma index")
        parser.add_argument("-I", "--paradigm-index", type=int, choices=INDICES,
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
        parser.add_argument("-t", "--transducer", default=LIBFILE,
                            help=f"path to transducer file in standard format (default: {path.relpath(LIBFILE, getcwd())})")
        parser.add_argument("-u", "--user-specified", action="store_true",
                            help="use only user-specified information")
        parser.add_argument("-v", "--version", action="version",
                            version=f"{parser.prog} {version}")
        parser.add_argument("-y", "--yaml", action="store_true",
                            help="output YAML document")
        args = parser.parse_args()

        transducer = sfst_transduce.Transducer(args.transducer)

        if args.json:
            output_format = "json"
        elif args.yaml:
            output_format = "yaml"
        elif args.csv:
            output_format = "csv"
        else:
            output_format = "tsv"
        output_paradigms(transducer, args.lemma, args.output, args.lemma_index, args.paradigm_index,
                         args.pos, args.user_specified, args.nonst, args.old, args.oldorth, args.ch,
                         args.no_cats, args.no_lemma, args.no_empty,
                         args.no_header, args.plain, args.force_color, output_format)
    except KeyboardInterrupt:
        sys.exit(130)
    return 0


if __name__ == "__main__":
    sys.exit(main())
