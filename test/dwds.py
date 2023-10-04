#!/usr/bin/env python3
# dwds.py - DWDS test library
# Gregor Middell and Andreas Nolda 2023-09-29

from collections import namedtuple
from xml.etree.ElementTree import parse

from dwdsmor import analyse_word


def get_dwds_entries(input_files):
    for input_file in input_files:
        with open(input_file) as file:
            root = parse(file).getroot()
            for article in root.findall("{http://www.dwds.de/ns/1.0}Artikel"):
                entry = list(root).index(article)
                if article.get("Status") == "Red-f" or not article.get("Status"):
                    for formspec in article.findall("{http://www.dwds.de/ns/1.0}Formangabe"):
                        for grammarspec in formspec.findall("{http://www.dwds.de/ns/1.0}Grammatik"):
                            for pos in grammarspec.findall("{http://www.dwds.de/ns/1.0}Wortklasse"):
                                dwds_pos = pos.text or ""
                                if dwds_pos == "":
                                    continue
                                if dwds_pos == "Substantiv" or dwds_pos == "Eigenname":
                                    if not ((grammarspec.findall("{http://www.dwds.de/ns/1.0}Genus") and
                                             grammarspec.findall("{http://www.dwds.de/ns/1.0}Genitiv")) or
                                            grammarspec.findall("{http://www.dwds.de/ns/1.0}Numeruspraeferenz[.='nur im Plural']")):
                                        continue
                                if pos == "Verb":
                                    if not (grammarspec.findall("{http://www.dwds.de/ns/1.0}Praesens") or
                                            grammarspec.findall("{http://www.dwds.de/ns/1.0}Praeteritum") or
                                            grammarspec.findall("{http://www.dwds.de/ns/1.0}Partizip_II") or
                                            grammarspec.findall("{http://www.dwds.de/ns/1.0}Auxiliar")):
                                        continue
                        for spelling in formspec.findall("{http://www.dwds.de/ns/1.0}Schreibung"):
                            if not spelling.get("Typ"):
                                dwds_lemma = spelling.text or ""
                                if " " in dwds_lemma.strip():
                                    continue
                                dwds_entry = {"entry": entry,
                                              "file": input_file,
                                              "dwds_lemma": dwds_lemma,
                                              "dwds_pos": dwds_pos}
                                yield dwds_entry


AnalysedEntry = namedtuple("AnalysedEntry", ["entry",
                                             "file",
                                             "dwds_lemma", "dwds_pos",
                                             "dwdsmor_lemma", "dwdsmor_pos",
                                             "lemma_covered"])


def analyse_dwds_entry(transducer, dwds_entry):
    entry = dwds_entry["entry"]
    file = dwds_entry["file"]
    dwds_lemma = dwds_entry["dwds_lemma"]
    dwds_pos = dwds_entry["dwds_pos"]

    analyses = tuple(analyse_word(transducer, dwds_lemma))

    if analyses:
        dwdsmor_lemma = analyses[0].lemma
        dwdsmor_pos = analyses[0].pos
    else:
        dwdsmor_lemma = ""
        dwdsmor_pos = ""

    lemma_covered = len(dwdsmor_lemma) > 0

    return AnalysedEntry(entry,
                         file,
                         dwds_lemma, dwds_pos,
                         dwdsmor_lemma, dwdsmor_pos,
                         lemma_covered)
