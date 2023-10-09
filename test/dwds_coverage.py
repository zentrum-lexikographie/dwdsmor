#!/usr/bin/env python3
# dwds_coverage.py -- DWDS library for coverage tests
# Gregor Middell and Andreas Nolda 2023-10-09

from collections import namedtuple
from xml.etree.ElementTree import parse

from dwdsmor import analyse_word

from paradigm import generate_paradigms


# mapping between DWDS and DWDSSmor part-of-speech categories
POS_MAP = {"Adjektiv": "ADJ",
           "Adverb": "ADV",
           "bestimmter Artikel": "ART",
           "Demonstrativpronomen": "DEM",
           "Eigenname": "NPROP",
           "Indefinitpronomen": "INDEF",
           "Interjektion": "INTJ",
           "Interrogativpronomen": "WPRO",
           "Kardinalzahl": "CARD",
           "Konjunktion": "CONJ",
           "Ordinalzahl": "ORD",
           "Partikel": "PTCL",
           "partizipiales Adjektiv": "ADJ",
           "partizipiales Adverb": "ADV",
           "Personalpronomen": "PPRO",
           "Possessivpronomen": "POSS",
           "Pronominaladverb": "PROADV",
           "Präposition + Artikel": "PREPART",
           "Präposition": "PREP",
           "Reflexivpronomen": "PPRO",
           "Relativpronomen": "REL",
           "Substantiv": "NN",
           "unbestimmter Artikel": "ART",
           "Verb": "V"}


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

                        for spelling in formspec.findall(f"{ns}Schreibung"):
                            if not spelling.get("Typ"):
                                dwds_lemma = spelling.text or ""
                                # ignore idioms and other syntactically complex units
                                if " " in dwds_lemma.strip():
                                    continue
                                # ignore non-feminine lemmas of articles, numerals, and attributive pronouns
                                # if they also have a feminine lemma
                                if dwds_pos in ["bestimmter Artikel",
                                                "Demonstrativpronomen",
                                                "Indefinitpronomen",
                                                "Interrogativpronomen",
                                                "Kardinalzahl",
                                                "Ordinalzahl",
                                                "Possessivpronomen",
                                                "Relativpronomen",
                                                "unbestimmter Artikel"]:
                                    if article.findall(f"{ns}Formangabe/{ns}Grammatik/{ns}Genus[.='fem.']"):
                                        if formspec.findtext(f"{ns}Grammatik/{ns}Genus") != "fem.":
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


def dwds_to_dwdsmor_pos(pos):
    dwdsmor_pos = POS_MAP[pos] if pos in POS_MAP else ""
    return dwdsmor_pos


def analyse_dwds_entry(transducer, dwds_entry):
    entry = dwds_entry["entry"]
    file = dwds_entry["file"]
    dwds_lemma = dwds_entry["dwds_lemma"]
    dwds_pos = dwds_entry["dwds_pos"]
    dwds_grammar = dwds_entry["dwds_grammar"]

    analyses = tuple(analyse_word(transducer, dwds_lemma))

    dwdsmor_lemma = analyses[0].lemma if analyses else ""
    dwdsmor_pos = analyses[0].pos if analyses else ""
    lemma_covered = len(dwdsmor_lemma) > 0

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
    dwdsmor_pos = dwds_to_dwdsmor_pos(dwds_pos)

    formdict = generate_paradigms(transducer, dwds_lemma,
                                  lemma_index=dwds_lemma_index, paradigm_index=dwds_paradigm_index,
                                  pos=dwds_pos)

    lemma_covered = len(formdict) > 0

    return EntryWithParadigm(entry,
                             file,
                             dwds_lemma,
                             dwds_lemma_index,
                             dwds_paradigm_index,
                             dwds_grammar,
                             dwds_pos,
                             dwdsmor_pos,
                             lemma_covered)
