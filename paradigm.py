#!/usr/bin/python3
# paradigm.py -- generate paradigms
# Andreas Nolda 2023-05-05

import sys
import os
import argparse
import csv
import json
import sfst_transduce
from dwdsmor import analyse_word
from blessings import Terminal
from collections import namedtuple
from itertools import product, filterfalse

version = 7.0

BASEDIR = os.path.dirname(__file__)
LIBDIR  = os.path.join(BASEDIR, "lib")
LIBFILE = os.path.join(LIBDIR, "dwdsmor-index.a")

INDICES     = [1, 2, 3, 4, 5]
POS         = ["ADJ", "ART", "CARD", "DEM", "INDEF", "NN", "NPROP", "ORD", "POSS", "PPRO", "REL", "V", "WPRO"]
SUBCATS     = ["Def", "Indef", "Neg", "Pers", "Refl"]
DEGREES     = ["Pos", "Comp", "Sup"]
PERSONS     = ["1", "2", "3"]
GENDERS     = ["Masc", "Neut", "Fem", "NoGend"]
CASES       = ["Nom", "Acc", "Dat", "Gen"]
NUMBERS     = ["Sg", "Pl"]
INFLECTIONS = ["NoInfl", "St", "Wk"]
FUNCTIONS   = ["Attr", "Subst", "Attr/Subst", "Pred/Adv"]
MOODS       = ["Ind", "Subj"]
TENSES      = ["Pres", "Perf", "Past", "PastPerf", "Fut", "FutPerf"]
AUXILIARIES = ["haben", "sein"]

SEG_HABEN  = "hab<~>en"
SEG_SEIN   = "sei<~>n"
SEG_WERDEN = "werd<~>en"

PARTICLE_BOUNDARY = "<#>"

LEMMA_INDEX_HABEN  = None
LEMMA_INDEX_SEIN   = 3
LEMMA_INDEX_WERDEN = None

PARADIGM_INDEX_HABEN  = None
PARADIGM_INDEX_SEIN   = None
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

Lexcat = namedtuple("Lexcat", LEXCAT, defaults=[None] * len(LEXCAT[1:]))
Parcat = namedtuple("Parcat", PARCAT, defaults=[None] * len(PARCAT))

Formspec  = namedtuple("Formspec",  ["lemma_index", "paradigm_index", "lexcat", "parcat"])
Lemmaspec = namedtuple("Lemmaspec", ["lemma_index", "paradigm_index", "segmented_lemma", "pos", "subcat", "person", "gender"])

def filter_categorisations(categorisations, pos):
    if pos in ["ADJ", "ART", "CARD", "DEM", "INDEF", "ORD", "POSS", "REL", "WPRO"]:
        # Masc, Neut, and Fem do not co-occur with Pl.
        categorisations = filterfalse(lambda category: "Masc" in category and "Pl" in category, categorisations)
        categorisations = filterfalse(lambda category: "Neut" in category and "Pl" in category, categorisations)
        categorisations = filterfalse(lambda category: "Fem"  in category and "Pl" in category, categorisations)
        # NoGend does not co-occur with Sg.
        categorisations = filterfalse(lambda category: "NoGend" in category and "Sg" in category, categorisations)
    if pos in ["ADJ", "NN", "ORD"]:
        # There is no category NoInfl.
        categorisations = filterfalse(lambda category: "NoInfl" in category, categorisations)
    if pos in ["ADJ", "ORD"]:
        # There is no category Subst.
        categorisations = filterfalse(lambda category: "Subst" in category, categorisations)
        # Attr co-occurs with Invar.
        categorisations = filterfalse(lambda category: "Attr" in category and not "Invar" in category, categorisations)
        # Pred/Adv does not co-occur with any category.
        categorisations = filterfalse(lambda category: "Pred/Adv" in category and len(category) > 1, categorisations)
    if pos in ["ART", "CARD", "DEM", "INDEF", "POSS", "REL", "WPRO"]:
        # There are no categories Attr/Subst or Pred/Adv.
        categorisations = filterfalse(lambda category: "Attr/Subst" in category, categorisations)
        categorisations = filterfalse(lambda category: "Pred/Adv" in category, categorisations)
    return categorisations

def string(value):
    return str(value or "")

def format_lemma_index(lemma_index):
    if lemma_index:
        return "<IDX" + string(lemma_index) + ">"
    else:
        return ""

def format_paradigm_index(paradigm_index):
    if paradigm_index:
        return "<PAR" + string(paradigm_index) + ">"
    else:
        return ""

def format_pos(pos):
    return "<+" + pos + ">"

def format_categorisation(categorisation):
    return "".join(["<" + string(category) + ">" for category in categorisation])

def generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation):
    forms = transducer.generate(seg + format_lemma_index(lemma_index)
                                    + format_paradigm_index(paradigm_index)
                                    + format_pos(pos)
                                    + format_categorisation(categorisation))
    return forms

def generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation):
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation + ["NonSt"])
    return forms

def generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation):
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation + ["Old"])
    return forms

def generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation):
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation + ["OLDORTH"])
    return forms

def add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formdict[Formspec(lemma_index, paradigm_index, lexcat, parcat)] = sorted(set(forms))

def add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if (lemma_index, paradigm_index, lexcat, parcat) in formdict:
        formdict[Formspec(lemma_index, paradigm_index, lexcat, parcat)].extend(sorted(set(forms)))
    else:
        formdict[Formspec(lemma_index, paradigm_index, lexcat, parcat)] = sorted(set(forms))

def add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formatted_forms = [form + " (ugs.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, formatted_forms)

def add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formatted_forms = [form + " (va.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, formatted_forms)

def add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formatted_forms = [form + " (ung.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, formatted_forms)

def add_superlative_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        complex_forms = ["am " + form for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participles):
    if forms:
        complex_forms = [form + " " + participle for form in forms
                                                 for participle in participles]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_oldorth_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participles):
    if forms:
        complex_forms = [form + " " + participle + " (ung.)" for form in forms
                                                             for participle in participles]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_future_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitives):
    if forms:
        complex_forms = [form + " " + infinitive for form in forms
                                                 for infinitive in infinitives]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_future_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitives, participles):
    if forms:
        complex_forms = [form + " " + participle + " " + infinitive for form in forms
                                                                    for participle in participles
                                                                    for infinitive in infinitives]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_oldorth_future_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitives, participles):
    if forms:
        complex_forms = [form + " " + participle + " " + infinitive + " (ung.)" for form in forms
                                                                                for participle in participles
                                                                                for infinitive in infinitives]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_nonfinite_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participles):
    if forms:
        complex_forms = [participle + " " + form for participle in participles
                                                 for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_oldorth_nonfinite_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participles):
    if forms:
        complex_forms = [participle + " " + form + " (ung.)" for participle in participles
                                                             for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [form[len(particle):] + " " + particle for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_old_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [form[len(particle):] + " " + particle + " (va.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_oldorth_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [form[len(particle):] + " " + particle + " (ung.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_imperative_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [form + " " + particle for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def get_noun_formdict(transducer, lemma_index, paradigm_index, seg, pos, gender, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    lexcat = Lexcat(pos    = pos,
                    gender = gender)
    # nominalised adjectives
    categorisations = product(NUMBERS, CASES, INFLECTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case, inflection in categorisations:
        parcat = Parcat(case   = case,
                        number = number,
                        inflection = inflection)
        categorisation = [gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
    # other nouns
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        parcat = Parcat(case   = case,
                        number = number)
        categorisation = [gender,
                          case,
                          number]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            old_forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, old_forms)
        if oldorth:
            oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
    return formdict

def get_adjective_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    for degree in DEGREES:
        # non-attributive forms
        parcat = Parcat(degree   = degree,
                        function = "Pred/Adv")
        categorisation = [degree,
                          "Pred/Adv"]
        nonattributive_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        if degree == "Sup":
            add_superlative_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonattributive_forms)
        else:
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonattributive_forms)
        if nonstandard:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
    # forms inflected for degree, but uninflected for gender, case, number, and inflectional strength
    for degree in DEGREES:
        categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
        categorisations = filter_categorisations(categorisations, pos)
        for gender, number, case, inflection, function in categorisations:
            parcat = Parcat(degree     = degree,
                            function   = function,
                            gender     = gender,
                            case       = case,
                            number     = number,
                            inflection = inflection)
            categorisation = [degree,
                              function,
                              "Invar"]
            forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
            if nonstandard:
                # no such forms
                pass
            if old:
                # no such forms
                pass
        if oldorth:
            oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
        # forms inflected for degree, gender, case, number, and inflectional strength
        categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
        categorisations = filter_categorisations(categorisations, pos)
        for gender, number, case, inflection, function in categorisations:
            parcat = Parcat(degree     = degree,
                            function   = function,
                            gender     = gender,
                            case       = case,
                            number     = number,
                            inflection = inflection)
            categorisation = [degree,
                              function,
                              gender,
                              case,
                              number,
                              inflection]
            forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
            if nonstandard:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
    return formdict

def get_article_formdict(transducer, lemma_index, paradigm_index, seg, pos, subcat, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    lexcat = Lexcat(pos    = pos,
                    subcat = subcat)
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [subcat,
                          function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    return formdict

def get_cardinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    return formdict

def get_ordinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    return formdict

def get_adjectival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    return formdict

def get_substantival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, subcat, person, gender, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        if gender:
            lexcat = Lexcat(pos    = pos,
                            subcat = subcat,
                            person = person,
                            gender = gender)
            parcat = Parcat(case   = case,
                            number = number)
            categorisation = [subcat,
                              person,
                              gender,
                              case,
                              number]
        else:
            lexcat = Lexcat(pos    = pos,
                            subcat = subcat,
                            person = person)
            parcat = Parcat(case   = case,
                            number = number)
            categorisation = [subcat,
                              person,
                              case,
                              number]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            old_forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, old_forms)
        if oldorth:
            # no such forms
            pass
    return formdict

def get_other_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, gender, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    # fixed gender
    lexcat = Lexcat(pos    = pos,
                    gender = gender)
    # forms with fixed gender, but uninflected for case and number
    parcat = Parcat(case   = "Invar",
                    number = "Invar")
    categorisation = [gender,
                      "Invar"]
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    if nonstandard:
        # no such forms
        pass
    if old:
        # no such forms
        pass
    if oldorth:
        # no such forms
        pass
    # forms with fixed gender and inflected for case and number
    categorisations = product(NUMBERS, CASES)
    categorisations = filter_categorisations(categorisations, pos)
    for number, case in categorisations:
        parcat = Parcat(case   = case,
                        number = number)
        categorisation = [gender,
                          case,
                          number]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            old_forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, old_forms)
        if oldorth:
            # no such forms
            pass
    # no fixed gender
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    categorisations = product(["Invar"], ["Invar"], ["Invar"], ["Invar"], FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            # no such forms
            pass
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    # forms inflected for function, gender, case, number, and inflectional strength
    categorisations = product(GENDERS, NUMBERS, CASES, INFLECTIONS, FUNCTIONS)
    categorisations = filter_categorisations(categorisations, pos)
    for gender, number, case, inflection, function in categorisations:
        parcat = Parcat(function   = function,
                        gender     = gender,
                        case       = case,
                        number     = number,
                        inflection = inflection)
        categorisation = [function,
                          gender,
                          case,
                          number,
                          inflection]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if nonstandard:
            nonstandard_forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonstandard_forms)
        if old:
            # no such forms
            pass
        if oldorth:
            # no such forms
            pass
    return formdict

def get_verb_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard=False, old=False, oldorth=False):
    formdict = {}
    if PARTICLE_BOUNDARY in seg:
        particle = seg[:seg.find(PARTICLE_BOUNDARY)]
    else:
        particle = ""
    for auxiliary in AUXILIARIES:
        categorisation = ["PPast",
                          auxiliary]
        # check whether the past participle actually selects the auxiliary
        past_participle_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        if oldorth:
            oldorth_past_participle_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
        if past_participle_forms:
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            # infinitives
            parcat = Parcat(nonfinite = "Inf",
                            tense     = "Pres")
            categorisation = ["Inf"]
            infinitive_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, infinitive_forms)
            if nonstandard:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                # no such forms
                pass
            parcat = Parcat(nonfinite = "Inf",
                            tense     = "Perf")
            add_nonfinite_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, [auxiliary], past_participle_forms)
            if nonstandard:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_oldorth_nonfinite_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, [auxiliary], oldorth_past_participle_forms)
            # participles
            parcat = Parcat(nonfinite = "Part",
                            tense     = "Pres")
            categorisation = ["PPres"]
            present_participle_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, present_participle_forms)
            if nonstandard:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                # no such forms
                pass
            parcat = Parcat(nonfinite = "Part",
                            tense     = "Perf")
            categorisation = ["PPast",
                              auxiliary]
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, past_participle_forms)
            if nonstandard:
                # no such forms
                pass
            if old:
                # no such forms
                pass
            if oldorth:
                add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_past_participle_forms)
            # indicative and subjunctive forms
            categorisations = product(TENSES, MOODS, NUMBERS, PERSONS)
            categorisations = filter_categorisations(categorisations, pos)
            for tense, mood, number, person in categorisations:
                parcat = Parcat(person = person,
                                number = number,
                                mood   = mood,
                                tense  = tense)
                if tense == "Perf":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    if auxiliary == "haben":
                        forms = generate_forms(transducer, LEMMA_INDEX_HABEN, PARADIGM_INDEX_HABEN, SEG_HABEN, pos, categorisation)
                    elif auxiliary == "sein":
                        forms = generate_forms(transducer, LEMMA_INDEX_SEIN, PARADIGM_INDEX_SEIN, SEG_SEIN, pos, categorisation)
                    add_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, past_participle_forms)
                    if nonstandard:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_oldorth_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, oldorth_past_participle_forms)
                if tense == "PastPerf":
                    categorisation = [person,
                                      number,
                                      "Past",
                                      mood]
                    if auxiliary == "haben":
                        forms = generate_forms(transducer, LEMMA_INDEX_HABEN, PARADIGM_INDEX_HABEN, SEG_HABEN, pos, categorisation)
                    elif auxiliary == "sein":
                        forms = generate_forms(transducer, LEMMA_INDEX_SEIN, PARADIGM_INDEX_SEIN, SEG_SEIN, pos, categorisation)
                    add_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, past_participle_forms)
                    if nonstandard:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_oldorth_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, oldorth_past_participle_forms)
                elif tense == "Fut":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    forms = generate_forms(transducer, LEMMA_INDEX_WERDEN, PARADIGM_INDEX_WERDEN, SEG_WERDEN, pos, categorisation)
                    add_future_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitive_forms)

                    if nonstandard:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        # no such forms
                        pass
                elif tense == "FutPerf":
                    categorisation = [person,
                                      number,
                                      "Pres",
                                      mood]
                    forms = generate_forms(transducer, LEMMA_INDEX_WERDEN, PARADIGM_INDEX_WERDEN, SEG_WERDEN, pos, categorisation)
                    add_future_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, [auxiliary], past_participle_forms)
                    if nonstandard:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        add_oldorth_future_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, [auxiliary], oldorth_past_participle_forms)
                else:
                    categorisation = [person,
                                      number,
                                      tense,
                                      mood]
                    if particle:
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                        add_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle)
                        if nonstandard:
                            # no such forms
                            pass
                        if old:
                            old_forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                            add_old_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, old_forms, particle)
                        if oldorth:
                            oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                            add_oldorth_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms, particle)
                    else:
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if nonstandard:
                            # no such forms
                            pass
                        if old:
                            old_forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                            add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, old_forms)
                        if oldorth:
                            oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                            add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
            # imperative forms
            for number in NUMBERS:
                parcat = Parcat(number = number,
                                mood   = "Imp")
                categorisation = ["Imp",
                                  number]
                if particle:
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                    add_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle)
                    if nonstandard:
                        # no such forms
                        pass
                    if old:
                        old_forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                        add_old_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, old_forms, particle)
                    if oldorth:
                        oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                        add_oldorth_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms, particle)
                else:
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if nonstandard:
                        # no such forms
                        pass
                    if old:
                        # no such forms
                        pass
                    if oldorth:
                        oldorth_forms = generate_oldorth_forms(transducer, lemma_index, paradigm_index, seg, pos, categorisation)
                        add_oldorth_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, oldorth_forms)
    return formdict

def get_formdict(transducer, lemma_index, paradigm_index, seg, pos, subcat, person, gender, nonstandard=False, old=False, oldorth=False):
    # nouns
    if pos in ["NN", "NPROP"]:
        formdict = get_noun_formdict(transducer, lemma_index, paradigm_index, seg, pos, gender, nonstandard, old, oldorth)
    elif pos == "ADJ":
        formdict = get_adjective_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard, old, oldorth)
    # articles
    elif pos == "ART":
        formdict = get_article_formdict(transducer, lemma_index, paradigm_index, seg, pos, subcat, nonstandard, old, oldorth)
    # cardinals
    elif pos == "CARD":
        formdict = get_cardinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard, old, oldorth)
    # cardinals
    elif pos == "ORD":
        formdict = get_ordinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard, old, oldorth)
    # demonstrative and possessive pronouns
    elif pos in ["DEM", "POSS"]:
        formdict = get_adjectival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard, old, oldorth)
    # personal pronouns
    elif pos == "PPRO":
        formdict = get_substantival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, subcat, person, gender, nonstandard, old, oldorth)
    # other pronouns
    elif pos in ["INDEF", "REL", "WPRO"]:
        formdict = get_other_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, gender, nonstandard, old, oldorth)
    # verbs
    elif pos == "V":
        formdict = get_verb_formdict(transducer, lemma_index, paradigm_index, seg, pos, nonstandard, old, oldorth)
    return formdict

def paradigm_subset(formdict, lemma_index, paradigm_index, lexcat):
    return [(key, value) for key, value in formdict.items()
            if key.lemma_index == lemma_index and key.paradigm_index == paradigm_index and key.lexcat == lexcat]

def cat_dict(cats):
    return {key: value for key, value in cats._asdict().items()
            if value}

def cat_list(cats):
    # remove duplicates while preserving order
    return {"categories": list(dict.fromkeys(value for value in cat_dict(cats).values()))}

def output_json(lemma, output, formdict, no_category_names=False, no_lemma=False):
    paradigms = []
    # remove duplicates while preserving order
    for lemma_index, paradigm_index, lexcat in list(dict.fromkeys((key.lemma_index, key.paradigm_index, key.lexcat) for key in formdict.keys())):
        if no_category_names:
            cat_value = cat_list
        else:
            cat_value = cat_dict
        if no_lemma:
            paradigms.append({"paradigm": [{**cat_value(key.parcat),
                                            "forms": value}
                                           for key, value in paradigm_subset(formdict, lemma_index, paradigm_index, lexcat)]})
        else:
            paradigms.append({"lemma": lemma,
                              "lemma_index": lemma_index,
                              "paradigm_index": paradigm_index,
                              **cat_value(lexcat),
                              "paradigm": [{**cat_value(key.parcat),
                                            "forms": value}
                                           for key, value in paradigm_subset(formdict, lemma_index, paradigm_index, lexcat)]})
    json.dump(paradigms, output, ensure_ascii=False)

def output_dsv(lemma, output, formdict, no_category_names=False, no_lemma=False, header=True, force_color=False, delimiter="\t"):
    term = Terminal(force_styling=force_color)
    csv_writer = csv.writer(output, delimiter=delimiter)
    if header:
        if no_category_names and no_lemma:
            csv_writer.writerow(["Paradigm Categories",
                                 term.bold("Paradigm Forms")])
        elif no_category_names:
            csv_writer.writerow([term.bold_underline("Lemma"),
                                 term.underline("Lemma Index"),
                                 term.underline("Paradigm Index"),
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
                                 term.underline("Lemma Index"),
                                 term.underline("Paradigm Index"),
                                 term.underline("POS"),
                                 term.underline("Subcategory"),
                                 term.underline("Auxiliary"),
                                 term.underline("Person"),
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
                                 term.bold(", ".join(formdict[formspec]))])
        elif no_category_names:
            csv_writer.writerow([term.bold_underline(lemma),
                                 term.underline(string(formspec.lemma_index)),
                                 term.underline(string(formspec.paradigm_index)),
                                 term.underline(" ".join(filter(None, formspec.lexcat))),
                                 " ".join(filter(None, formspec.parcat)),
                                 term.bold(", ".join(formdict[formspec]))])
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
                                 term.bold(", ".join(formdict[formspec]))])
        else:
            csv_writer.writerow([term.bold_underline(lemma),
                                 term.underline(string(formspec.lemma_index)),
                                 term.underline(string(formspec.paradigm_index)),
                                 term.underline(formspec.lexcat.pos),
                                 term.underline(string(formspec.lexcat.subcat)),
                                 term.underline(string(formspec.lexcat.auxiliary)),
                                 term.underline(string(formspec.lexcat.person)),
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
                                 term.bold(", ".join(formdict[formspec]))])

def sort_lemmaspec(lemmaspec):
    lemma_index = string(lemmaspec.lemma_index)
    paradigm_index = string(lemmaspec.paradigm_index)
    seg = lemmaspec.segmented_lemma
    pos = POS.index(lemmaspec.pos)
    if lemmaspec.subcat:
        subcat = SUBCATS.index(lemmaspec.subcat)
    else:
        subcat = None
    if lemmaspec.person:
        person = PERSONS.index(lemmaspec.person)
    else:
        person = None
    if lemmaspec.gender:
        gender = GENDERS.index(lemmaspec.gender)
    else:
        gender = None
    return (lemma_index, paradigm_index, seg, pos, subcat, person, gender)

def generate_paradigms(transducer, lemma, lemma_index=None, paradigm_index=None, pos=None, user_specified=False, nonstandard=False, old=False, oldorth=False):
    lemmaspecs = []
    if user_specified:
        if pos == "ART":
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index, lemma, pos, subcat, None, None)
                          for subcat in SUBCATS]
        elif pos == "PPRO":
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index, lemma, pos, subcat, person, gender)
                          for subcat in SUBCATS
                          for person in PERSONS
                          for gender in GENDERS]
        elif pos in ["INDEF", "NN", "NPROP", "REL", "WPRO"]:
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index, lemma, pos, None, None, gender)
                          for gender in GENDERS]
        else:
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index, lemma, pos, None, None, None)]
    else:
        analyses = analyse_word(transducer, lemma)
        lemmaspecs = sorted({Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.segmented_lemma, analysis.pos, analysis.subcat, analysis.person, analysis.gender)
                             if analysis.pos == "PPRO"
                             else Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.segmented_lemma, analysis.pos, analysis.subcat, None, None)
                             if analysis.pos == "ART"
                             else Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.segmented_lemma, analysis.pos, None, None, analysis.gender)
                             if analysis.pos in ["INDEF", "NN", "NPROP", "REL", "WPRO"]
                             else Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.segmented_lemma, analysis.pos, None, None, None)
                             for analysis in analyses if analysis.lemma == lemma and analysis.pos in POS},
                            key=sort_lemmaspec)
        if lemma_index in INDICES:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.lemma_index == str(lemma_index)]
        if paradigm_index in INDICES:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.paradigm_index == str(paradigm_index)]
        if pos in POS:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.pos == pos]
    formdict = {}
    for lemmaspec in lemmaspecs:
        formdict.update(get_formdict(transducer, *lemmaspec, nonstandard=nonstandard, old=old, oldorth=oldorth))
    return formdict

def output_paradigms(transducer, lemma, output, lemma_index=None, paradigm_index=None, pos=None, user_specified=False, nonstandard=False, old=False, oldorth=False, no_category_names=False, no_lemma=False, header=True, force_color=False, output_format="tsv"):
    term = Terminal(force_styling=force_color)
    formdict = generate_paradigms(transducer, lemma, lemma_index, paradigm_index, pos, user_specified, nonstandard, old, oldorth)
    if formdict:
        if output_format == "json":
            output_json(lemma, output, formdict, no_category_names, no_lemma)
        elif output_format == "csv":
            output_dsv(lemma, output, formdict, no_category_names, no_lemma, header, force_color, delimiter=",")
        else:
            output_dsv(lemma, output, formdict, no_category_names, no_lemma, header, force_color)
    else:
        if lemma_index and paradigm_index and pos:
            print(term.bold(lemma) + ": No such lemma of lemma index {0}, paradigm index {1}, and part-of-speech {2}.".format(lemma_index, paradigm_index, pos), file=sys.stderr)
        elif lemma_index and pos:
            print(term.bold(lemma) + ": No such lemma of lemma index {0} and part-of-speech {1}.".format(lemma_index, pos), file=sys.stderr)
        elif paradigm_index and pos:
            print(term.bold(lemma) + ": No such lemma of paradigm index {0} and part-of-speech {1}.".format(paradigm_index, pos), file=sys.stderr)
        elif lemma_index:
            print(term.bold(lemma) + ": No such lemma of lemma index {0}.".format(lemma_index), file=sys.stderr)
        elif paradigm_index:
            print(term.bold(lemma) + ": No such lemma of paradigm index {0}.".format(paradigm_index), file=sys.stderr)
        elif pos:
            print(term.bold(lemma) + ": No such lemma of part-of-speech {0}.".format(pos), file=sys.stderr)
        elif user_specified:
            print(term.bold(lemma) + ": No user-specified part of speech for lemma.", file=sys.stderr)
        else:
            print(term.bold(lemma) + ": No such lemma. (For a pseudo-lemma, use --user-specified.)", file=sys.stderr)

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
        parser.add_argument("-i", "--lemma-index", type=int, choices=INDICES,
                            help="homographic lemma index")
        parser.add_argument("-I", "--paradigm-index", type=int, choices=INDICES,
                            help="paradigm index")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-n", "--no-category-names", action="store_true",
                            help="do not output category names")
        parser.add_argument("-N", "--no-lemma", action="store_true",
                            help="do not output lemma, lemma index, paradigm index, and lexical categories")
        parser.add_argument("-o", "--old", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-O", "--oldorth", action="store_true",
                            help="output also forms in old spelling")
        parser.add_argument("-p", "--pos", choices=POS,
                            help="part of speech")
        parser.add_argument("-s", "--nonstandard", action="store_true",
                            help="output also non-standard forms")
        parser.add_argument("-t", "--transducer", default=LIBFILE,
                            help="transducer file (default: {0})".format(os.path.relpath(LIBFILE, os.getcwd())))
        parser.add_argument("-u", "--user-specified", action="store_true",
                            help="use only user-specified information")
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
        output_paradigms(transducer, args.lemma, args.output, args.lemma_index, args.paradigm_index, args.pos, args.user_specified, args.nonstandard, args.old, args.oldorth, args.no_category_names, args.no_lemma, args.no_header, args.force_color, output_format)
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
