#!/usr/bin/python3
# paradigm.py -- generate paradigms
# Andreas Nolda 2022-08-18

import sys
import os
import argparse
import csv
import json
import sfst_transduce
from dwdsmor import analyse_word
from blessings import Terminal
from collections import namedtuple

version = 4.2

basedir = os.path.dirname(__file__)
libdir  = os.path.join(basedir, "lib")
libfile = os.path.join(libdir, "dwdsmor-index.a")

indices     = [1, 2, 3, 4]
pos         = ["ADJ", "ART", "CARD", "DEM", "INDEF", "NN", "NPROP", "POSS", "PPRO", "REL", "V", "WPRO"]
art_subcats = ["Def", "Indef", "Neg"]
pro_subcats = ["Pers", "Refl"]
degrees     = ["Pos", "Comp", "Sup"]
persons     = ["1", "2", "3"]
genders     = ["Masc", "Neut", "Fem", "NoGend"]
cases       = ["Nom", "Acc", "Dat", "Gen"]
numbers     = ["Sg", "Pl"]
inflections = ["NoInfl", "St", "Wk"]
functions   = ["Attr", "Subst", "Pred"]
nonfinites  = ["Inf", "PPres", "PPast"]
moods       = ["Ind", "Subj"]
tenses      = ["Pres", "PresPerf", "Past", "PastPerf", "Fut", "FutPerf"]
auxiliaries = ["haben", "sein"]

seg_haben  = "hab<~>en"
seg_sein   = "sei<~>n"
seg_werden = "werd<~>en"

particle_boundary = "<#>"

index_haben  = None
index_sein   = 3
index_werden = None

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

Formspec  = namedtuple("Formspec",  ["index", "lexcat", "parcat"])
Lemmaspec = namedtuple("Lemmaspec", ["index", "segmented_lemma", "pos"])

def string(value):
    return str(value or "")

def format_index(index):
    if index:
        return "<IDX" + string(index) + ">"
    else:
        return ""

def format_pos(pos):
    return "<+" + pos + ">"

def format_categories(categories):
    return "".join(["<" + cat + ">" for cat in categories])

def generate_forms(transducer, index, seg, pos, categories):
    forms = transducer.generate(seg + format_index(index)
                                    + format_pos(pos)
                                    + format_categories(categories))
    return forms

def add_forms(formdict, index, lexcat, parcat, forms):
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(forms))

def add_old_forms(formdict, index, lexcat, parcat, forms):
    formatted_forms = [form + " (va.)" for form in forms]
    if (index, lexcat, parcat) in formdict:
        formdict[Formspec(index, lexcat, parcat)].extend(sorted(set(formatted_forms)))
    else:
        formdict[Formspec(index, lexcat, parcat)] = sorted(set(formatted_forms))

def add_nonstandard_forms(formdict, index, lexcat, parcat, forms):
    formatted_forms = [form + " (ugs.)" for form in forms]
    if (index, lexcat, parcat) in formdict:
        formdict[Formspec(index, lexcat, parcat)].extend(sorted(set(formatted_forms)))
    else:
        formdict[Formspec(index, lexcat, parcat)] = sorted(set(formatted_forms))

def add_superlative_adjective_forms(formdict, index, lexcat, parcat, forms):
    complex_forms = ["am " + form for form in forms]
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(complex_forms))

def add_perfect_verb_forms(formdict, index, lexcat, parcat, forms, participle):
    complex_forms = [form + " " + participle for form in forms]
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(complex_forms))

def add_future_verb_forms(formdict, index, lexcat, parcat, forms, infinitive):
    complex_forms = [form + " " + infinitive for form in forms]
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(complex_forms))

def add_future_perfect_verb_forms(formdict, index, lexcat, parcat, forms, infinitive, participle):
    complex_forms = [form + " " + participle + " " + infinitive for form in forms]
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(complex_forms))

def add_particle_verb_forms(formdict, index, lexcat, parcat, forms, particle):
    complex_forms = [form[len(particle):] + " " + particle for form in forms]
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(complex_forms))

def add_imperative_particle_verb_forms(formdict, index, lexcat, parcat, forms, particle):
    complex_forms = [form + " " + particle for form in forms]
    formdict[Formspec(index, lexcat, parcat)] = sorted(set(complex_forms))

def get_noun_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False):
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
                    forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                         case,
                                                                         number,
                                                                         inflection])
                    if forms:
                        add_forms(formdict, index, lexcat, parcat, forms)
    # other nouns
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        for number in numbers:
            for case in cases:
                parcat = Parcat(case   = case,
                                number = number)
                forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                     case,
                                                                     number])
                if forms:
                    add_forms(formdict, index, lexcat, parcat, forms)
                if old_forms:
                    forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                         case,
                                                                         number,
                                                                         "Old"])
                    if forms:
                        add_old_forms(formdict, index, lexcat, parcat, forms)
                if nonstandard_forms:
                    forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                         case,
                                                                         number,
                                                                         "NonSt"])
                    if forms:
                        add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_adjective_formdict(transducer, index, seg, pos):
    formdict = {}
    # predicative forms
    lexcat = Lexcat(pos = pos)
    for degree in degrees:
        parcat = Parcat(degree   = degree,
                        function = "Pred")
        forms = generate_forms(transducer, index, seg, pos, [degree, "Pred"])
        if forms:
            if degree == "Sup":
                add_superlative_adjective_forms(formdict, index, lexcat, parcat, forms)
            else:
                add_forms(formdict, index, lexcat, parcat, forms)
    # forms inflected for degree, but uninflected for gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
    for degree in degrees:
        parcat = Parcat(degree     = degree,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        forms = generate_forms(transducer, index, seg, pos, [degree,
                                                             "Invar"])
        if forms:
            add_forms(formdict, index, lexcat, parcat, forms)
    # forms inflected for degree, gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
    for degree in degrees:
        for gender in genders:
            for number in numbers:
                for case in cases:
                    for inflection in inflections:
                        parcat = Parcat(degree     = degree,
                                        gender     = gender,
                                        case       = case,
                                        number     = number,
                                        inflection = inflection)
                        forms = generate_forms(transducer, index, seg, pos, [degree,
                                                                             gender,
                                                                             case,
                                                                             number,
                                                                             inflection])
                        if forms:
                            add_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_article_formdict(transducer, index, seg, pos, nonstandard_forms=False):
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
                            forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                                 function,
                                                                                 gender,
                                                                                 case,
                                                                                 number,
                                                                                 inflection])
                            if forms:
                                add_forms(formdict, index, lexcat, parcat, forms)
                            if nonstandard_forms:
                                forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                                     function,
                                                                                     gender,
                                                                                     case,
                                                                                     number,
                                                                                     inflection,
                                                                                     "NonSt"])
                                if forms:
                                    add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_cardinal_formdict(transducer, index, seg, pos):
    formdict = {}
    # forms inflected for function, gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
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
                        forms = generate_forms(transducer, index, seg, pos, [function,
                                                                             gender,
                                                                             case,
                                                                             number,
                                                                             inflection])
                        if forms:
                            add_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_adjectival_pronoun_formdict(transducer, index, seg, pos, nonstandard_forms=False):
    formdict = {}
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
    for function in functions:
        parcat = Parcat(function   = function,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        forms = generate_forms(transducer, index, seg, pos, [function,
                                                             "Invar"])
        if forms:
            add_forms(formdict, index, lexcat, parcat, forms)
    # forms inflected for function, gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
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
                        forms = generate_forms(transducer, index, seg, pos, [function,
                                                                             gender,
                                                                             case,
                                                                             number,
                                                                             inflection])
                        if forms:
                            add_forms(formdict, index, lexcat, parcat, forms)
                        if nonstandard_forms:
                            forms = generate_forms(transducer, index, seg, pos, [function,
                                                                                 gender,
                                                                                 case,
                                                                                 number,
                                                                                 inflection,
                                                                                 "NonSt"])
                            if forms:
                                add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_substantival_pronoun_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False):
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
                    forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                         person,
                                                                         case,
                                                                         number])
                    if forms:
                        add_forms(formdict, index, lexcat, parcat, forms)
                    if old_forms:
                        forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                             person,
                                                                             case,
                                                                             number,
                                                                             "Old"])
                        if forms:
                            add_old_forms(formdict, index, lexcat, parcat, forms)
                    if nonstandard_forms:
                        forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                             person,
                                                                             case,
                                                                             number,
                                                                             "NonSt"])
                        if forms:
                            add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
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
                    forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                         gender,
                                                                         case,
                                                                         number])
                    if forms:
                        add_forms(formdict, index, lexcat, parcat, forms)
                    if old_forms:
                        forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                             gender,
                                                                             case,
                                                                             number,
                                                                             "Old"])
                        if forms:
                            add_old_forms(formdict, index, lexcat, parcat, forms)
                    if nonstandard_forms:
                        forms = generate_forms(transducer, index, seg, pos, [subcat,
                                                                             gender,
                                                                             case,
                                                                             number,
                                                                             "NonSt"])
                        if forms:
                            add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_other_pronoun_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False):
    formdict = {}
    # forms with fixed gender, but uninflected for case and number
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        parcat = Parcat(case       = "Invar",
                        number     = "Invar")
        forms = generate_forms(transducer, index, seg, pos, [gender,
                                                             "Invar"])
        if forms:
            add_forms(formdict, index, lexcat, parcat, forms)
    # forms with fixed gender and inflected for case and number
    for gender in genders:
        lexcat = Lexcat(pos    = pos,
                        gender = gender)
        for number in numbers:
            for case in cases:
                parcat = Parcat(case   = case,
                                number = number)
                forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                     case,
                                                                     number])
                if forms:
                    add_forms(formdict, index, lexcat, parcat, forms)
                if old_forms:
                    forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                         case,
                                                                         number,
                                                                         "Old"])
                    if forms:
                        add_old_forms(formdict, index, lexcat, parcat, forms)
                if nonstandard_forms:
                    forms = generate_forms(transducer, index, seg, pos, [gender,
                                                                         case,
                                                                         number,
                                                                         "NonSt"])
                    if forms:
                        add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
    # forms inflected for function, but uninflected for gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
    for function in functions:
        parcat = Parcat(function   = function,
                        gender     = "Invar",
                        case       = "Invar",
                        number     = "Invar",
                        inflection = "Invar")
        forms = generate_forms(transducer, index, seg, pos, [function,
                                                             "Invar"])
        if forms:
            add_forms(formdict, index, lexcat, parcat, forms)
    # forms inflected for function, gender, case, number, and inflectional strength
    lexcat = Lexcat(pos = pos)
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
                        forms = generate_forms(transducer, index, seg, pos, [function,
                                                                             gender,
                                                                             case,
                                                                             number,
                                                                             inflection])
                        if forms:
                            add_forms(formdict, index, lexcat, parcat, forms)
                        if nonstandard_forms:
                            forms = generate_forms(transducer, index, seg, pos, [function,
                                                                                 gender,
                                                                                 case,
                                                                                 number,
                                                                                 inflection,
                                                                                 "NonSt"])
                            if forms:
                                add_nonstandard_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_verb_formdict(transducer, index, seg, pos):
    formdict = {}
    if particle_boundary in seg:
        particle = seg[:seg.find(particle_boundary)]
    else:
        particle = ""
    for auxiliary in auxiliaries:
        participle_forms = generate_forms(transducer, index, seg, pos, ["PPast",
                                                                        auxiliary])
        if participle_forms:
            # infinitive
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            parcat = Parcat(nonfinite = "Inf")
            forms = generate_forms(transducer, index, seg, pos, ["Inf"])
            if forms:
                add_forms(formdict, index, lexcat, parcat, forms)
            # present participle
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            parcat = Parcat(nonfinite = "PPres")
            forms = generate_forms(transducer, index, seg, pos, ["PPres"])
            if forms:
                add_forms(formdict, index, lexcat, parcat, forms)
            # past participle
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            parcat = Parcat(nonfinite = "PPast")
            forms = generate_forms(transducer, index, seg, pos, ["PPast",
                                                                 auxiliary])
            if forms:
                add_forms(formdict, index, lexcat, parcat, forms)
            # indicative and subjunctive forms
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            for tense in tenses:
                for mood in moods:
                    for number in numbers:
                        for person in persons:
                            parcat = Parcat(person = person,
                                            number = number,
                                            mood   = mood,
                                            tense  = tense)
                            if tense == "PresPerf" or tense == "PastPerf":
                                for participles in [forms for [formspec, forms] in formdict.items()
                                                    if formspec.lexcat == lexcat and
                                                       formspec.parcat.nonfinite == "PPast"]:
                                    for participle in participles:
                                        if auxiliary == "haben":
                                            forms = generate_forms(transducer, index_haben, seg_haben, pos, [person,
                                                                                                             number,
                                                                                                             tense[:-4],
                                                                                                             mood])
                                        elif auxiliary == "sein":
                                            forms = generate_forms(transducer, index_sein, seg_sein, pos, [person,
                                                                                                           number,
                                                                                                           tense[:-4],
                                                                                                           mood])
                                        if forms:
                                            add_perfect_verb_forms(formdict, index, lexcat, parcat, forms, participle)
                            elif tense == "Fut":
                                for infinitives in [forms for [formspec, forms] in formdict.items()
                                                    if formspec.lexcat == lexcat and
                                                       formspec.parcat.nonfinite == "Inf"]:
                                    for infinitive in infinitives:
                                        forms = generate_forms(transducer, index_werden, seg_werden, pos, [person,
                                                                                                           number,
                                                                                                           "Pres",
                                                                                                           mood])
                                        if forms:
                                            add_future_verb_forms(formdict, index, lexcat, parcat, forms, infinitive)
                            elif tense == "FutPerf":
                                for participles in [forms for [formspec, forms] in formdict.items()
                                                    if formspec.lexcat == lexcat and
                                                       formspec.parcat.nonfinite == "PPast"]:
                                    for participle in participles:
                                        forms = generate_forms(transducer, index_werden, seg_werden, pos, [person,
                                                                                                           number,
                                                                                                           "Pres",
                                                                                                           mood])
                                        if forms:
                                            add_future_perfect_verb_forms(formdict, index, lexcat, parcat, forms, auxiliary, participle)
                            else:
                                forms = generate_forms(transducer, index, seg, pos, [person,
                                                                                     number,
                                                                                     tense,
                                                                                     mood])
                                if forms:
                                    if particle:
                                        add_particle_verb_forms(formdict, index, lexcat, parcat, forms, particle)
                                    else:
                                        add_forms(formdict, index, lexcat, parcat, forms)
            # imperative forms
            lexcat = Lexcat(pos       = pos,
                            auxiliary = auxiliary)
            for number in numbers:
                parcat = Parcat(number = number,
                                mood   = "Imp")
                forms = generate_forms(transducer, index, seg, pos, ["Imp",
                                                                     number])
                if forms:
                    if particle:
                        add_particle_verb_forms(formdict, index, lexcat, parcat, forms, particle)
                    else:
                        add_forms(formdict, index, lexcat, parcat, forms)
    return formdict

def get_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False):
    # nouns
    if pos == "NN" or pos == "NPROP":
        formdict = get_noun_formdict(transducer, index, seg, pos, old_forms=False)
    elif pos == "ADJ":
        formdict = get_adjective_formdict(transducer, index, seg, pos)
    # articles
    elif pos == "ART":
        formdict = get_article_formdict(transducer, index, seg, pos, nonstandard_forms=False)
    # cardinals
    elif pos == "CARD":
        formdict = get_cardinal_formdict(transducer, index, seg, pos)
    # demonstrative and possessive pronouns
    elif pos == "DEM" or pos == "POSS":
        formdict = get_adjectival_pronoun_formdict(transducer, index, seg, pos, nonstandard_forms=False)
    # personal pronouns
    elif pos == "PPRO":
        formdict = get_substantival_pronoun_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False)
    # other pronouns
    elif pos == "INDEF" or pos == "REL" or pos == "WPRO":
        formdict = get_other_pronoun_formdict(transducer, index, seg, pos, old_forms=False, nonstandard_forms=False)
    # verbs
    elif pos == "V":
        formdict = get_verb_formdict(transducer, index, seg, pos)
    return formdict

def paradigm_subset(formdict, index, lexcat):
    return [(key, value) for key, value in formdict.items() if key.index == index and key.lexcat == lexcat]

def cat_dict(cats):
    return {key: value for key, value in cats._asdict().items() if value}

def cat_list(cats):
    # remove duplicates while preserving order
    return {"categories": list(dict.fromkeys(value for value in cat_dict(cats).values()))}

def output_json(lemma, output, formdict, no_category_names=False, no_lemma=False):
    paradigms = []
    # remove duplicates while preserving order
    for index, lexcat in list(dict.fromkeys((key.index, key.lexcat) for key in formdict.keys())):
        if no_category_names:
            cat_value = cat_list
        else:
            cat_value = cat_dict
        if no_lemma:
            paradigms.append({"paradigm": [{**cat_value(key.parcat),
                                            "forms": value}
                                           for key, value in paradigm_subset(formdict, index, lexcat)]})
        else:
            paradigms.append({"lemma": lemma,
                              "index": index,
                              **cat_value(lexcat),
                              "paradigm": [{**cat_value(key.parcat),
                                            "forms": value}
                                           for key, value in paradigm_subset(formdict, index, lexcat)]})
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
                                 term.underline("Index"),
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
                                 term.underline("Index"),
                                 term.underline("POS"),
                                 term.underline("Subcategory"),
                                 term.underline("Auxiliary"),
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
                                 term.underline(string(formspec.index)),
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
                                 term.underline(string(formspec.index)),
                                 term.underline(formspec.lexcat.pos),
                                 term.underline(string(formspec.lexcat.subcat)),
                                 term.underline(string(formspec.lexcat.auxiliary)),
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

def generate_paradigms(transducer, lemma, index=None, pos=None, user_specified=False, old_forms=False, nonstandard_forms=False):
    lemmaspecs = []
    if user_specified:
        if pos:
            if index:
                lemmaspecs = [Lemmaspec(index, lemma, pos)]
            else:
                lemmaspecs = [Lemmaspec(None, lemma, pos)]
    else:
        analyses = analyse_word(transducer, lemma)
        lemmaspecs = sorted({Lemmaspec(analysis.index, analysis.segmented_lemma, analysis.pos)
                             for analysis in analyses if analysis.lemma == lemma},
                            key=lambda l: (l.index or "", l.segmented_lemma, l.pos))
        if index:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs if lemmaspec.index == index]
        if pos:
            lemmaspecs = [lemmaspec for lemmaspec in lemmaspecs if lemmaspec.pos == pos]
    formdict = {}
    for lemmaspec in lemmaspecs:
        formdict.update(get_formdict(transducer, *lemmaspec, old_forms=old_forms, nonstandard_forms=nonstandard_forms))
    return formdict

def output_paradigms(transducer, lemma, output, index=None, pos=None, user_specified=False, old_forms=False, nonstandard_forms=False, no_category_names=False, no_lemma=False, header=True, force_color=False, output_format="tsv"):
    term = Terminal(force_styling=force_color)
    formdict = generate_paradigms(transducer, lemma, index, pos, user_specified, old_forms, nonstandard_forms)
    if formdict:
        if output_format == "json":
            output_json(lemma, output, formdict, no_category_names, no_lemma)
        elif output_format == "csv":
            output_dsv(lemma, output, formdict, no_category_names, no_lemma, header, force_color, delimiter=",")
        else:
            output_dsv(lemma, output, formdict, no_category_names, no_lemma, header, force_color)
    else:
        if index and pos:
            print(term.bold(lemma) + ": No such lemma of index {0} and part-of-speech {1}.".format(index, pos), file=sys.stderr)
        elif index:
            print(term.bold(lemma) + ": No such lemma of index {0}.".format(index), file=sys.stderr)
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
        parser.add_argument("-i", "--index", type=int, choices=indices,
                            help="homographic lemma index")
        parser.add_argument("-j", "--json", action="store_true",
                            help="output JSON object")
        parser.add_argument("-n", "--no-category-names", action="store_true",
                            help="do not output category names")
        parser.add_argument("-N", "--no-lemma", action="store_true",
                            help="do not output lemma, index, and lexical categories")
        parser.add_argument("-o", "--old-forms", action="store_true",
                            help="output also archaic forms")
        parser.add_argument("-p", "--pos", choices=pos,
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
        output_paradigms(transducer, args.lemma, args.output, args.index, args.pos, args.user_specified, args.old_forms, args.nonstandard_forms, args.no_category_names, args.no_lemma, args.no_header, args.force_color, output_format)
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
