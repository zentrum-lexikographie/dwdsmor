#!/usr/bin/env python3
# test_dwds_paradigm_coverage.py
# test DWDSmor paradigms against DWDS lexicon for coverage
# Andreas Nolda 2023-10-09

import csv
from os import path, walk, makedirs
from collections import defaultdict

from pytest import fixture

import sfst_transduce

from test.dwds_coverage import get_dwds_entries, generate_paradigms_for_dwds_entry


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

DATADIR = path.join(BASEDIR, "lexicon", "dwds", "wb")

REPORTDIR = path.join(TESTDIR, "reports")

SUMMARYDIR = path.join(TESTDIR, "summaries")


@fixture
def transducer():
    return sfst_transduce.Transducer(path.join(LIBDIR, "dwdsmor-index.a"))


@fixture
def data_files():
    xml_files = []
    for (dir, _, files) in walk(DATADIR):
        for file in files:
            if file.endswith(".xml"):
                xml_files.append(path.join(dir, file))
    return tuple(xml_files)


@fixture
def report_file():
    return path.join(REPORTDIR, "dwds-paradigm-coverage.tsv")


@fixture
def summary_file():
    return path.join(SUMMARYDIR, "dwds-paradigm-coverage.tsv")


def output_report(report_file, entries_with_paradigms):
    output_dirname = path.dirname(report_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    with open(report_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")
        header_row = ["File",
                      "Entry Number",
                      "Lemma",
                      "Lemma Index",
                      "Paradigm Index",
                      "With Grammar",
                      "POS",
                      "DWDSmor POS",
                      "Covered"]
        csv_writer.writerow(header_row)
        for analysed_entry in entries_with_paradigms:
            row = [path.relpath(analysed_entry.file, DATADIR),
                   analysed_entry.entry,
                   analysed_entry.dwds_lemma,
                   analysed_entry.dwds_lemma_index,
                   analysed_entry.dwds_paradigm_index,
                   analysed_entry.dwds_grammar,
                   analysed_entry.dwds_pos,
                   analysed_entry.dwdsmor_pos,
                   analysed_entry.lemma_covered]
            csv_writer.writerow(row)


def output_summary(summary_file, entries_with_paradigms):
    output_dirname = path.dirname(summary_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    stats = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    for analysed_entry in entries_with_paradigms:
        stats[analysed_entry.dwds_pos][analysed_entry.dwds_grammar][analysed_entry.lemma_covered] += 1

    with open(summary_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")

        header_row = ["POS",
                      "Lemmas",
                      "Covered Lemmas",
                      "Percentage Covered Lemmas",
                      "Lemmas with Grammar",
                      "Percentage Lemmas with Grammar",
                      "Covered Lemmas with Grammar",
                      "Percentage Covered Lemmas with Grammar"]
        csv_writer.writerow(header_row)

        for dwds_pos, grammar_coverage in sorted(stats.items()):
            lemma_count = 0
            covered_lemma_count = 0
            for dwds_grammar, coverage in sorted(grammar_coverage.items()):
                grammar_count = sum(coverage.values())
                lemma_count += grammar_count
                covered_grammar_count = coverage[True]
                covered_lemma_count += covered_grammar_count
                grammar_percentage = grammar_count / lemma_count
                covered_lemma_percentage = covered_lemma_count / lemma_count
                covered_grammar_percentage = covered_grammar_count / grammar_count
                if dwds_grammar == True:
                    row = [dwds_pos,
                           lemma_count,
                           covered_lemma_count,
                           f"{covered_lemma_percentage:.2%}",
                           grammar_count,
                           f"{grammar_percentage:.2%}",
                           covered_grammar_count,
                           f"{covered_grammar_percentage:.2%}"]
                    csv_writer.writerow(row)


def test_dwds_paradigm_coverage(transducer, data_files, report_file, summary_file):
    dwds_entries = tuple(get_dwds_entries(data_files))
    entries_with_paradigms = tuple(generate_paradigms_for_dwds_entry(transducer, dwds_entry)
                                   for dwds_entry in dwds_entries)

    output_report(report_file, entries_with_paradigms)
    output_summary(summary_file, entries_with_paradigms)
