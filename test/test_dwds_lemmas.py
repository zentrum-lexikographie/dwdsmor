#!/usr/bin/env python3
# test_dwds_lemmas.py - test DWDSmor lemmas against DWDS lexicon
# Gregor Middell and Andreas Nolda 2023-10-04

import csv
from os import path, walk, makedirs

from pytest import fixture

import sfst_transduce

from test.dwds import get_dwds_entries, analyse_dwds_entry


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

DATADIR = path.join(BASEDIR, "lexicon", "dwds", "wb")

REPORTDIR = path.join(TESTDIR, "reports")


@fixture
def transducer():
    return sfst_transduce.CompactTransducer(path.join(LIBDIR, "dwdsmor.ca"))


@fixture
def data_files():
    xml_files = []
    for (dir, _, files) in walk(DATADIR):
        for file in files:
            if file.endswith(".xml"):
                xml_files.append(path.join(dir, file))
    return tuple(xml_files)


@fixture
def output_file():
    return path.join(REPORTDIR, "dwds-lemmas.tsv")


def output_tsv(output_file, analysed_entries):
    output_dirname = path.dirname(output_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    with open(output_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")
        csv_writer.writerow(["File",
                             "Entry Number",
                             "DWDS Lemma",
                             "DWDS POS",
                             "DWDSmor Lemma",
                             "DWDSmor POS",
                             "Lemma Covered"])
        for analysed_entry in analysed_entries:
            csv_writer.writerow([path.relpath(analysed_entry.file, DATADIR),
                                 analysed_entry.entry,
                                 analysed_entry.dwds_lemma,
                                 analysed_entry.dwds_pos,
                                 analysed_entry.dwdsmor_lemma,
                                 analysed_entry.dwdsmor_pos,
                                 analysed_entry.lemma_covered])


def test_dwds_lemmas(transducer, data_files, output_file):
    dwds_entries = tuple(get_dwds_entries(data_files))
    analysed_entries = tuple(analyse_dwds_entry(transducer, dwds_entry)
                             for dwds_entry in dwds_entries)

    output_tsv(output_file, analysed_entries)
