#!/usr/bin/env python3
# test_sample_coverage.py - test DWDSmor coverage against sample lexicon
# Gregor Middell and Andreas Nolda 2023-09-29

import csv
from os import path, walk, makedirs

from pytest import fixture

import sfst_transduce

from tests.dwds import get_dwds_entries, analyse_dwds_entry


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

INPUTDIR = path.join(BASEDIR, "lexicon", "sample", "wb")

OUTPUTDIR = path.join(BASEDIR, "test-reports")


@fixture
def transducer():
    return sfst_transduce.CompactTransducer(path.join(LIBDIR, "dwdsmor.ca"))


@fixture
def input_files():
    xml_files = [path.join(INPUTDIR, "dwds.xml")]
    return tuple(xml_files)


@fixture
def output_file():
    return path.join(OUTPUTDIR, "sample-coverage.tsv")


def output_tsv(output_file, analysed_entries):
    output_dirname = path.dirname(output_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    with open(output_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t")
        csv_writer.writerow(["File",
                             "Entry Number",
                             "DWDS Lemma",
                             "DWDS POS",
                             "DWDSmor Lemma",
                             "DWDSmor POS",
                             "Lemma Covered"])
        for analysed_entry in analysed_entries:
            csv_writer.writerow([path.relpath(analysed_entry.file, INPUTDIR),
                                 analysed_entry.entry,
                                 analysed_entry.dwds_lemma,
                                 analysed_entry.dwds_pos,
                                 analysed_entry.dwdsmor_lemma,
                                 analysed_entry.dwdsmor_pos,
                                 analysed_entry.lemma_covered])


def test_sample_coverage(transducer, input_files, output_file):
    sample_entries = tuple(get_dwds_entries(input_files))
    analysed_entries = tuple(analyse_dwds_entry(transducer, dwds_entry)
                             for dwds_entry in sample_entries)

    output_tsv(output_file, analysed_entries)
