#!/usr/bin/python3
# paradigm.py -- generate paradigms
# Andreas Nolda 2022-09-20

import sys
import os
import argparse
import csv
import json
import sfst_transduce
from dwdsmor import analyse_word
from blessings import Terminal
from collections import namedtuple

version = 5.6

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "dwdsmor-index.a")

indices     = [1, 2, 3, 4, 5]
psos        = ["ADJ", "ART", "CARD", "DEM", "INDEF", "NN", "NPROP", "ORD", "POSS", "PPRO", "REL", "V", "WPRO"]
art_subcats = ["Def", "Indef", "Neg"]
pro_subcats = ["Pers", "Refl"]
degrees     = ["Pos", "Comp", "Sup"]
persons     = ["1", "2", "3"]
genders     = ["Masc", "Neut", "Fem", "NoGend"]
cases       = ["Nom", "Acc", "Dat", "Gen"]
numbers     = ["Sg", "Pl"]
inflections = ["NoInfl", "St", "Wk"]
functions   = ["Attr", "NonAttr", "Subst"]
moods       = ["Ind", "Subj"]
tenses      = ["Pres", "Perf", "Past", "PastPerf", "Fut", "FutPerf"]
auxiliaries = ["haben", "sein"]

seg_haben  = "hab<~>en"
seg_sein   = "sei<~>n"
seg_werden = "werd<~>en"

particle_boundary = "<#>"

lemma_index_haben  = None
lemma_index_sein   = 3
lemma_index_werden = None

paradigm_index_haben  = None
paradigm_index_sein   = None
paradigm_index_werden = 1

lexcat = ["pos",
          "subcat",
          "auxiliary",
          "person",
          "gender"]
parcat = ["degree",
          "person",
          "gender",
          "case",
          "number",
          "inflection",
          "function",
          "nonfinite",
          "mood",
          "tense"]

Lexcat = namedtuple("Lexcat", lexcat, defaults=[None] * len(lexcat[1:]))
Parcat = namedtuple("Parcat", parcat, defaults=[None] * len(parcat))

Formspec  = namedtuple("Formspec",  ["lemma_index", "paradigm_index", "lexcat", "parcat"])
Lemmaspec = namedtuple("Lemmaspec", ["lemma_index", "paradigm_index", "segmented_lemma", "pos"])

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

def format_categories(categories):
    return "".join(["<" + cat + ">" for cat in categories])

def generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories):
    forms = transducer.generate(seg + format_lemma_index(lemma_index)
                                    + format_paradigm_index(paradigm_index)
                                    + format_pos(pos)
                                    + format_categories(categories))
    return forms

def generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categories):
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories + ["Old"])
    return forms

def generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories):
    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories + ["NonSt"])
    return forms

def add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formdict[Formspec(lemma_index, paradigm_index, lexcat, parcat)] = sorted(set(forms))

def add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if (lemma_index, paradigm_index, lexcat, parcat) in formdict:
        formdict[Formspec(lemma_index, paradigm_index, lexcat, parcat)].extend(sorted(set(forms)))
    else:
        formdict[Formspec(lemma_index, paradigm_index, lexcat, parcat)] = sorted(set(forms))

def add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formatted_forms = [form + " (va.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, formatted_forms)

def add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        formatted_forms = [form + " (ugs.)" for form in forms]
        add_additional_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, formatted_forms)

def add_superlative_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms):
    if forms:
        complex_forms = ["am " + form for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participle):
    if forms:
        complex_forms = [form + " " + participle for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_future_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitive):
    if forms:
        complex_forms = [form + " " + infinitive for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_future_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitive, participle):
    if forms:
        complex_forms = [form + " " + participle + " " + infinitive for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_nonfinite_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participle):
    if forms:
        complex_forms = [participle + " " + form for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [form[len(particle):] + " " + particle for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def add_imperative_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle):
    if forms:
        complex_forms = [form + " " + particle for form in forms]
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, complex_forms)

def get_noun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    # nominalised adjectives
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        for number in numbers:
            for case in cases:
                for inflection in inflections:
                    parcat = Parcat(case   = case,
                                    number = number,
                                    inflection = inflection)
                    categories = [gender,
                                  case,
                                  number,
                                  inflection]
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if old_forms:
                        # no such forms
                        pass
                    if nonstandard_forms:
                        # no such forms
                        pass
    # other nouns
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        for number in numbers:
            for case in cases:
                parcat = Parcat(case   = case,
                                number = number)
                categories = [gender,
                              case,
                              number]
                forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                if old_forms:
                    forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                if nonstandard_forms:
                    forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    return formdict

def get_adjective_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    for degree in degrees:
        # non-attributive forms of inflected forms
        parcat = Parcat(degree   = degree,
                        function = "NonAttr")
        categories = [degree, "NonAttr"]
        nonattributive_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        if degree == "Sup":
            add_superlative_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonattributive_forms)
        else:
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonattributive_forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
        # non-attributive forms of uninflected forms
        categories = [degree, "Invar"]
        nonattributive_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        if degree == "Sup":
            add_superlative_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonattributive_forms)
        else:
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, nonattributive_forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
    for degree in degrees:
        # forms inflected for degree, but uninflected for gender, case, number, and inflectional strength
        parcat = Parcat(degree     = degree,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        categories = [degree,
                      "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
        # forms inflected for degree, gender, case, number, and inflectional strength
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for inflection in inflections:
                        parcat = Parcat(degree     = degree,
                                        gender     = gender,
                                        case       = case,
                                        number     = number,
                                        inflection = inflection)
                        categories = [degree,
                                      gender,
                                      case,
                                      number,
                                      inflection]
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if old_forms:
                            # no such forms
                            pass
                        if nonstandard_forms:
                            # no such forms
                            pass
    return formdict

def get_article_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    for subcat in art_subcats:
        lexcat = Lexcat(pos    = pos,
                        subcat = subcat)
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for inflection in inflections:
                        for function in functions:
                            parcat = Parcat(function   = function,
                                            gender     = gender,
                                            case       = case,
                                            number     = number,
                                            inflection = inflection)
                            categories = [subcat,
                                          function,
                                          gender,
                                          case,
                                          number,
                                          inflection]
                            forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                            if old_forms:
                                # no such forms
                                pass
                            if nonstandard_forms:
                                forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                                add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    return formdict

def get_cardinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    for function in functions:
        parcat = Parcat(function   = function,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        categories = [function,
                      "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
    # forms inflected for function, gender, case, number, and inflectional strength
    for gender in genders:
        for number in numbers:
            for case in cases:
                for inflection in inflections:
                    for function in functions:
                        parcat = Parcat(function   = function,
                                        gender     = gender,
                                        case       = case,
                                        number     = number,
                                        inflection = inflection)
                        categories = [function,
                                      gender,
                                      case,
                                      number,
                                      inflection]
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if old_forms:
                            # no such forms
                            pass
                        if nonstandard_forms:
                            forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    return formdict

def get_ordinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    for gender in genders:
        for number in numbers:
            for case in cases:
                for inflection in inflections:
                    parcat = Parcat(gender     = gender,
                                    case       = case,
                                    number     = number,
                                    inflection = inflection)
                    categories = [gender,
                                  case,
                                  number,
                                  inflection]
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if old_forms:
                        # no such forms
                        pass
                    if nonstandard_forms:
                        # no such forms
                        pass
    return formdict

def get_adjectival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    for function in functions:
        parcat = Parcat(function   = function,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        categories = [function,
                      "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
    # forms inflected for function, gender, case, number, and inflectional strength
    for gender in genders:
        for number in numbers:
            for case in cases:
                for inflection in inflections:
                    for function in functions:
                        parcat = Parcat(function   = function,
                                        gender     = gender,
                                        case       = case,
                                        number     = number,
                                        inflection = inflection)
                        categories = [function,
                                      gender,
                                      case,
                                      number,
                                      inflection]
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if old_forms:
                            # no such forms
                            pass
                        if nonstandard_forms:
                            forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    return formdict

def get_substantival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    # forms with fixed person and inflected for subcat, case, and number
    for person in persons:
        for number in numbers:
            for case in cases:
                for subcat in pro_subcats:
                    lexcat = Lexcat(pos    = pos,
                                    subcat = subcat,
                                    person = person)
                    parcat = Parcat(case   = case,
                                    number = number)
                    categories = [subcat,
                                  person,
                                  case,
                                  number]
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if old_forms:
                        forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if nonstandard_forms:
                        forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    # forms with fixed person and gender and inflected for subcat, case, and number
    for person in persons:
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for subcat in pro_subcats:
                        lexcat = Lexcat(pos    = pos,
                                        subcat = subcat,
                                        person = person,
                                        gender = gender)
                        parcat = Parcat(case   = case,
                                        number = number)
                        categories = [subcat,
                                      person,
                                      gender,
                                      case,
                                      number]
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if old_forms:
                            forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                            add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if nonstandard_forms:
                            forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    # forms with fixed gender and inflected for subcat, case, and number
    for gender in genders:
        for number in numbers:
            for case in cases:
                for subcat in pro_subcats:
                    lexcat = Lexcat(pos    = pos,
                                    subcat = subcat,
                                    gender = gender)
                    parcat = Parcat(case   = case,
                                    number = number)
                    categories = [subcat,
                                  gender,
                                  case,
                                  number]
                    forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if old_forms:
                        forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                    if nonstandard_forms:
                        forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    return formdict

def get_other_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    # forms with fixed gender, but uninflected for case and number
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        parcat = Parcat(case       = "Invar",
                        number     = "Invar")
        categories = [gender,
                      "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
    # forms with fixed gender and inflected for case and number
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        for number in numbers:
            for case in cases:
                parcat = Parcat(case   = case,
                                number = number)
                categories = [gender,
                              case,
                              number]
                forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                if old_forms:
                    forms = generate_old_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_old_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                if nonstandard_forms:
                    forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                    add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    lexcat = Lexcat(pos = pos)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    for function in functions:
        parcat = Parcat(function   = function,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        categories = [function,
                      "Invar"]
        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
        if old_forms:
            # no such forms
            pass
        if nonstandard_forms:
            # no such forms
            pass
    # forms inflected for function, gender, case, number, and inflectional strength
    for gender in genders:
        for number in numbers:
            for case in cases:
                for inflection in inflections:
                    for function in functions:
                        parcat = Parcat(function   = function,
                                        gender     = gender,
                                        case       = case,
                                        number     = number,
                                        inflection = inflection)
                        categories = [function,
                                      gender,
                                      case,
                                      number,
                                      inflection]
                        forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                        add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                        if old_forms:
                            # no such forms
                            pass
                        if nonstandard_forms:
                            forms = generate_nonstandard_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                            add_nonstandard_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
    return formdict

def get_verb_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    if particle_boundary in seg:
        particle = seg[:seg.find(particle_boundary)]
    else:
        particle = ""
    for auxiliary in auxiliaries:
        categories = ["PPast",
                      auxiliary]
        # check whether the past participle actually selects the auxiliary
        past_participle_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
        if past_participle_forms:
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            # infinitives
            parcat = Parcat(nonfinite = "Inf",
                            tense     = "Pres")
            categories = ["Inf"]
            infinitive_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, infinitive_forms)
            if old_forms:
                # no such forms
                pass
            if nonstandard_forms:
                # no such forms
                pass
            parcat = Parcat(nonfinite = "Inf",
                            tense     = "Perf")
            for participle in past_participle_forms:
                add_nonfinite_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, [auxiliary], participle)
            if old_forms:
                # no such forms
                pass
            if nonstandard_forms:
                # no such forms
                pass
            # participles
            parcat = Parcat(nonfinite = "Part",
                            tense     = "Pres")
            categories = ["PPres"]
            present_participle_forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, present_participle_forms)
            if old_forms:
                # no such forms
                pass
            if nonstandard_forms:
                # no such forms
                pass
            parcat = Parcat(nonfinite = "Part",
                            tense     = "Perf")
            categories = ["PPast",
                          auxiliary]
            add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, past_participle_forms)
            if old_forms:
                # no such forms
                pass
            if nonstandard_forms:
                # no such forms
                pass
            # indicative and subjunctive forms
            for tense in tenses:
                for mood in moods:
                    for number in numbers:
                        for person in persons:
                            parcat = Parcat(person = person,
                                            number = number,
                                            mood   = mood,
                                            tense  = tense)
                            if tense == "Perf":
                                for participle in past_participle_forms:
                                    categories = [person,
                                                  number,
                                                  "Pres",
                                                  mood]
                                    if auxiliary == "haben":
                                        forms = generate_forms(transducer, lemma_index_haben, paradigm_index_haben, seg_haben, pos, categories)
                                    elif auxiliary == "sein":
                                        forms = generate_forms(transducer, lemma_index_sein, paradigm_index_sein, seg_sein, pos, categories)
                                    add_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participle)
                                    if old_forms:
                                        # no such forms
                                        pass
                                    if nonstandard_forms:
                                        # no such forms
                                        pass
                            if tense == "PastPerf":
                                for participle in past_participle_forms:
                                    categories = [person,
                                                  number,
                                                  "Past",
                                                  mood]
                                    if auxiliary == "haben":
                                        forms = generate_forms(transducer, lemma_index_haben, paradigm_index_haben, seg_haben, pos, categories)
                                    elif auxiliary == "sein":
                                        forms = generate_forms(transducer, lemma_index_sein, paradigm_index_sein, seg_sein, pos, categories)
                                    add_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, participle)
                                    if old_forms:
                                        # no such forms
                                        pass
                                    if nonstandard_forms:
                                        # no such forms
                                        pass
                            elif tense == "Fut":
                                for infinitive in infinitive_forms:
                                    categories = [person,
                                                  number,
                                                  "Pres",
                                                  mood]
                                    forms = generate_forms(transducer, lemma_index_werden, paradigm_index_werden, seg_werden, pos, categories)
                                    add_future_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, infinitive)

                                    if old_forms:
                                        # no such forms
                                        pass
                                    if nonstandard_forms:
                                        # no such forms
                                        pass
                            elif tense == "FutPerf":
                                for participle in past_participle_forms:
                                    categories = [person,
                                                  number,
                                                  "Pres",
                                                  mood]
                                    forms = generate_forms(transducer, lemma_index_werden, paradigm_index_werden, seg_werden, pos, categories)
                                    add_future_perfect_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, auxiliary, participle)

                                    if old_forms:
                                        # no such forms
                                        pass
                                    if nonstandard_forms:
                                        # no such forms
                                        pass
                            else:
                                categories = [person,
                                              number,
                                              tense,
                                              mood]
                                forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                                if particle:
                                    add_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle)
                                else:
                                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                                if old_forms:
                                    # no such forms
                                    pass
                                if nonstandard_forms:
                                    # no such forms
                                    pass
            # imperative forms
            for number in numbers:
                parcat = Parcat(number = number,
                                mood   = "Imp")
                categories = ["Imp",
                              number]
                forms = generate_forms(transducer, lemma_index, paradigm_index, seg, pos, categories)
                if particle:
                    add_particle_verb_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms, particle)
                else:
                    add_forms(formdict, lemma_index, paradigm_index, lexcat, parcat, forms)
                if old_forms:
                    # no such forms
                    pass
                if nonstandard_forms:
                    # no such forms
                    pass
    return formdict

def get_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms=False, nonstandard_forms=False):
    # nouns
    if pos == "NN" or pos == "NPROP":
        formdict = get_noun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    elif pos == "ADJ":
        formdict = get_adjective_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # articles
    elif pos == "ART":
        formdict = get_article_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # cardinals
    elif pos == "CARD":
        formdict = get_cardinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # cardinals
    elif pos == "ORD":
        formdict = get_ordinal_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # demonstrative and possessive pronouns
    elif pos == "DEM" or pos == "POSS":
        formdict = get_adjectival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # personal pronouns
    elif pos == "PPRO":
        formdict = get_substantival_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # other pronouns
    elif pos == "INDEF" or pos == "REL" or pos == "WPRO":
        formdict = get_other_pronoun_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
    # verbs
    elif pos == "V":
        formdict = get_verb_formdict(transducer, lemma_index, paradigm_index, seg, pos, old_forms, nonstandard_forms)
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

def generate_paradigms(transducer, lemma, lemma_index=None, paradigm_index=None, pos=None, user_specified=False, old_forms=False, nonstandard_forms=False):
    lemmaspecs = []
    if user_specified:
        if pos in psos:
            lemmaspecs = [Lemmaspec(lemma_index, paradigm_index, lemma, pos)]
    else:
        analyses = analyse_word(transducer, lemma)
        lemmaspecs = sorted({Lemmaspec(analysis.lemma_index, analysis.paradigm_index, analysis.segmented_lemma, analysis.pos)
                             for analysis in analyses if analysis.lemma == lemma and analysis.pos in psos},
                            key=lambda l: (string(l.lemma_index), string(l.paradigm_index), l.segmented_lemma, l.pos))
        if lemma_index in indices:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.lemma_index == str(lemma_index)]
        if paradigm_index in indices:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.paradigm_index == str(paradigm_index)]
        if pos in psos:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs
                          if lemmaspec.pos == pos]
    formdict = {}
    for lemmaspec in lemmaspecs:
        formdict.update(get_formdict(transducer, *lemmaspec, old_forms=old_forms, nonstandard_forms=nonstandard_forms))
    return formdict

def output_paradigms(transducer, lemma, output, lemma_index=None, paradigm_index=None, pos=None, user_specified=False, old_forms=False, nonstandard_forms=False, no_category_names=False, no_lemma=False, header=True, force_color=False, output_format="tsv"):
    term = Terminal(force_styling=force_color)
    formdict = generate_paradigms(transducer, lemma, lemma_index, paradigm_index, pos, user_specified, old_forms, nonstandard_forms)
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
        parser.add_argument("-i", "--lemma-index", type=int, choices=indices,
                            help="homographic lemma index")
        parser.add_argument("-I", "--paradigm-index", type=int, choices=indices,
                            help="paradigm index")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-n", "--no-category-names", action="store_true",
                            help="do not output category names")
        parser.add_argument("-N", "--no-lemma", action="store_true",
                            help="do not output lemma, lemma index, paradigm index, and lexical categories")
        parser.add_argument("-o", "--old-forms", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-p", "--pos", choices=psos,
                            help="part of speech")
        parser.add_argument("-s", "--nonstandard-forms", action="store_true",
                            help="output also non-standard forms")
        parser.add_argument("-t", "--transducer", default=libfile,
                            help="transducer file (default: {0})".format(os.path.relpath(libfile, os.getcwd())))
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
        output_paradigms(transducer, args.lemma, args.output, args.lemma_index, args.paradigm_index, args.pos, args.user_specified, args.old_forms, args.nonstandard_forms, args.no_category_names, args.no_lemma, args.no_header, args.force_color, output_format)
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
