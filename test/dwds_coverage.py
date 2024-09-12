#!/usr/bin/env python3
# dwds_coverage.py -- DWDS library for coverage tests
# Gregor Middell and Andreas Nolda 2024-09-12

from collections import namedtuple
from xml.etree.ElementTree import parse

from dwdsmor import analyse_word

from paradigm import generate_formdict


# mapping between DWDS and DWDSSmor part-of-speech categories
POS_MAP = {"Adjektiv":               ["ADJ"],
           "Adverb":                 ["ADV", "PTCL", "INTJ", "CONJ"],
           "bestimmter Artikel":     ["ART"],
           "Bruchzahl":              ["FRAC"],
           "Demonstrativpronomen":   ["DEM", "PROADV"],
           "Eigenname":              ["NPROP"],
           "Indefinitpronomen":      ["INDEF", "ART"],
           "Interjektion":           ["INTJ"],
           "Interrogativpronomen":   ["WPRO"],
           "Kardinalzahl":           ["CARD"],
           "Konjunktion":            ["CONJ", "ADV", "INTJ"],
           "Ordinalzahl":            ["ORD"],
           "Partikel":               ["PTCL", "ADV", "INTJ"],
           "partizipiales Adjektiv": ["ADJ"],
           "partizipiales Adverb":   ["ADV"],
           "Personalpronomen":       ["PPRO"],
           "Possessivpronomen":      ["POSS"],
           "Präposition":            ["PREP", "POSTP"],
           "Präposition + Artikel":  ["PREPART", "PTCL"],
           "Pronominaladverb":       ["PROADV"],
           "Reflexivpronomen":       ["PPRO"],
           "Relativpronomen":        ["REL"],
           "reziprokes Pronomen":    ["PPRO"],
           "Substantiv":             ["NN"],
           "unbestimmter Artikel":   ["ART"],
           "Verb":                   ["V"]}


def get_dwds_entries(data_files):
    ns = "{http://www.dwds.de/ns/1.0}"
    for data_file in data_files:
        with open(data_file) as file:
            root = parse(file).getroot()
            for article in root.findall(f"{ns}Artikel"):
                entry = list(root).index(article) + 1
                if article.get("Status") == "Red-f" or not article.get("Status"):
                    for formspec in article.findall(f"{ns}Formangabe"):
                        dwds_paradigm_index = int(article.findall(f"{ns}Formangabe").index(formspec) + 1) if len(article.findall(f"{ns}Formangabe")) > 1 else None

                        for grammarspec in formspec.findall(f"{ns}Grammatik"):
                            for pos in grammarspec.findall(f"{ns}Wortklasse"):
                                dwds_pos = pos.text or ""
                                dwds_pos = dwds_pos.strip()
                                if dwds_pos == "":
                                    dwds_grammar = False
                                elif dwds_pos in ["Eigenname", "Substantiv"]:
                                    if (grammarspec.findall(f"{ns}Genus") and
                                        grammarspec.findall(f"{ns}Genitiv")):
                                        dwds_grammar = True
                                    elif grammarspec.findall(f"{ns}Numeruspraeferenz[.='nur im Plural']"):
                                        dwds_grammar = True
                                    else:
                                        dwds_grammar = False
                                elif dwds_pos in ["bestimmter Artikel",
                                                  "Demonstrativpronomen",
                                                  "Possessivpronomen",
                                                  "Relativpronomen",
                                                  "unbestimmter Artikel"]:
                                    if grammarspec.findall(f"{ns}Genus"):
                                        dwds_grammar = True
                                    elif grammarspec.findall(f"{ns}indeklinabel"):
                                        dwds_grammar = True
                                    else:
                                        dwds_grammar = False
                                elif dwds_pos == "Verb":
                                    if (grammarspec.findall(f"{ns}Praesens") or
                                        grammarspec.findall(f"{ns}Praeteritum") or
                                        grammarspec.findall(f"{ns}Partizip_II") or
                                        grammarspec.findall(f"{ns}Auxiliar")):
                                        dwds_grammar = True
                                    else:
                                        dwds_grammar = False
                                else:
                                    dwds_grammar = True

                        # ignore extraneous part-of-speech categories:
                        if dwds_pos not in POS_MAP.keys():
                            continue

                        # ignore form specifications of articles, numerals, and attributive pronouns with non-feminine gender
                        # if there is a feminine form specification with feminine gender
                        if dwds_pos in ["bestimmter Artikel",
                                        "Demonstrativpronomen",
                                        "Indefinitpronomen",
                                        "Interrogativpronomen",
                                        "Kardinalzahl",
                                        "Ordinalzahl",
                                        "Possessivpronomen",
                                        "Relativpronomen",
                                        "unbestimmter Artikel"]:
                            nonfeminine_formspec = False
                            if article.findall(f"{ns}Formangabe/{ns}Grammatik/{ns}Genus[.='fem.']"):
                                if formspec.findtext(f"{ns}Grammatik/{ns}Genus") != "fem.":
                                    nonfeminine_formspec = True
                            if nonfeminine_formspec:
                                continue

                        # ignore form specifications of articles and pronouns with non-nominative case
                        if dwds_pos in ["bestimmter Artikel",
                                        "Demonstrativpronomen",
                                        "Personalpronomen",
                                        "Relativpronomen"]:  # ...
                            nonnominative_formspec = False
                            for case in formspec.findall(f"{ns}Grammatik/{ns}Kasuspraeferenz"):
                                if not case.get("Frequenz"):
                                    if case.text in ["im Akkusativ",
                                                     "im Dativ",
                                                     "im Genitiv"]:
                                        nonnominative_formspec = True
                            if nonnominative_formspec:
                                continue

                        for spelling in formspec.findall(f"{ns}Schreibung"):
                            if not spelling.get("Typ"):
                                dwds_lemma = spelling.text or ""
                                dwds_lemma = dwds_lemma.strip()
                                # ignore idioms and other syntactically complex units
                                if " " in dwds_lemma:
                                    continue
                                dwds_lemma_index = int(spelling.get("hidx")) if "hidx" in spelling.keys() else None

                                dwds_entry = {"entry": entry,
                                              "file": data_file,
                                              "dwds_lemma": dwds_lemma,
                                              "dwds_lemma_index": dwds_lemma_index,
                                              "dwds_paradigm_index": dwds_paradigm_index,
                                              "dwds_pos": dwds_pos,
                                              "dwds_grammar": dwds_grammar}
                                yield dwds_entry


EntryWithAnalysis = namedtuple("EntryWithAnalysis", ["entry",
                                                     "file",
                                                     "dwds_lemma",
                                                     "dwds_grammar",
                                                     "dwds_pos",
                                                     "dwdsmor_lemma",
                                                     "dwdsmor_pos",
                                                     "lemma_covered"])


def dwds_to_dwdsmor_pos_list(pos):
    dwdsmor_pos_list = POS_MAP[pos] if pos in POS_MAP else ""
    return dwdsmor_pos_list


def analyse_dwds_entry(transducer, dwds_entry):
    entry = dwds_entry["entry"]
    file = dwds_entry["file"]
    dwds_lemma = dwds_entry["dwds_lemma"]
    dwds_pos = dwds_entry["dwds_pos"]
    dwds_grammar = dwds_entry["dwds_grammar"]

    analyses = tuple(analyse_word(transducer, dwds_lemma))

    dwdsmor_lemma = ""
    dwdsmor_pos = ""
    lemma_covered = False
    for analysis in analyses:
        if analysis.pos in dwds_to_dwdsmor_pos_list(dwds_pos):
            lemma_covered = len(analysis.lemma) > 0
            if lemma_covered:
                dwdsmor_lemma = analysis.lemma
                dwdsmor_pos = analysis.pos
                break

    return EntryWithAnalysis(entry,
                             file,
                             dwds_lemma,
                             dwds_grammar,
                             dwds_pos,
                             dwdsmor_lemma,
                             dwdsmor_pos,
                             lemma_covered)


EntryWithParadigm = namedtuple("EntryWithParadigm", ["entry",
                                                     "file",
                                                     "dwds_lemma",
                                                     "dwds_lemma_index",
                                                     "dwds_paradigm_index",
                                                     "dwds_grammar",
                                                     "dwds_pos",
                                                     "dwdsmor_pos",
                                                     "lemma_covered"])


def generate_paradigms_for_dwds_entry(transducer, dwds_entry):
    entry = dwds_entry["entry"]
    file = dwds_entry["file"]
    dwds_lemma = dwds_entry["dwds_lemma"]
    dwds_lemma_index = dwds_entry["dwds_lemma_index"]
    dwds_paradigm_index = dwds_entry["dwds_paradigm_index"]
    dwds_pos = dwds_entry["dwds_pos"]
    dwds_grammar = dwds_entry["dwds_grammar"]

    dwdsmor_pos = ""
    lemma_covered = False
    for pos in dwds_to_dwdsmor_pos_list(dwds_pos):
        formdict = generate_formdict(transducer, dwds_lemma,
                                     lemma_index=dwds_lemma_index, paradigm_index=dwds_paradigm_index,
                                     pos=pos)
        lemma_covered = len(formdict) > 0
        if lemma_covered:
            dwdsmor_pos = pos
            break

    return EntryWithParadigm(entry,
                             file,
                             dwds_lemma,
                             dwds_lemma_index,
                             dwds_paradigm_index,
                             dwds_grammar,
                             dwds_pos,
                             dwdsmor_pos,
                             lemma_covered)
