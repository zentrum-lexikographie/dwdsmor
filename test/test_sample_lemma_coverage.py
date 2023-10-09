#!/usr/bin/env python3
# test_sample_lemma_coverage.py
# test DWDSmor lemmas against sample lexicon for coverage
# Gregor Middell and Andreas Nolda 2023-10-09

import csv
from os import path, walk, makedirs
from collections import defaultdict

from pytest import fixture

import sfst_transduce

from test.dwds_coverage import get_dwds_entries, analyse_dwds_entry


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

DATADIR = path.join(BASEDIR, "lexicon", "sample", "wb")

REPORTDIR = path.join(TESTDIR, "reports")

SUMMARYDIR = path.join(TESTDIR, "summaries")


@fixture
def transducer():
    return sfst_transduce.CompactTransducer(path.join(LIBDIR, "dwdsmor.ca"))


@fixture
def data_files():
    xml_files = [path.join(DATADIR, "dwds.xml")]
    return tuple(xml_files)


@fixture
def report_file():
    return path.join(REPORTDIR, "sample-lemma-coverage.tsv")


@fixture
def summary_file():
    return path.join(SUMMARYDIR, "sample-lemma-coverage.tsv")


def output_report(report_file, entries_with_analysis):
    output_dirname = path.dirname(report_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    with open(report_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")
        header_row = ["File",
                      "Entry Number",
                      "DWDS Lemma",
                      "DWDS Grammar",
                      "DWDS POS",
                      "DWDSmor Lemma",
                      "DWDSmor POS",
                      "Lemma Covered"]
        csv_writer.writerow(header_row)
        for analysed_entry in entries_with_analysis:
            row = [path.relpath(analysed_entry.file, DATADIR),
                   analysed_entry.entry,
                   analysed_entry.dwds_lemma,
                   analysed_entry.dwds_grammar,
                   analysed_entry.dwds_pos,
                   analysed_entry.dwdsmor_lemma,
                   analysed_entry.dwdsmor_pos,
                   analysed_entry.lemma_covered]
            csv_writer.writerow(row)


def output_summary(summary_file, entries_with_analysis):
    output_dirname = path.dirname(summary_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    stats = defaultdict(lambda: defaultdict(int))
    for analysed_entry in entries_with_analysis:
        stats[analysed_entry.dwds_pos][analysed_entry.lemma_covered] += 1

    with open(summary_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")
        header_row = ["DWDS POS",
                      "Lemmas Covered",
                      "Lemmas Not Covered",
                      "Coverage"]
        csv_writer.writerow(header_row)
        for dwds_pos, coverages in sorted(stats.items()):
            coverage_count = coverages[True]
            noncoverage_count = coverages[False]
            total = coverage_count + noncoverage_count
            coverage = coverage_count / total
            row = [dwds_pos,
                   coverage_count,
                   noncoverage_count,
                   f"{coverage:.2%}"]
            csv_writer.writerow(row)


def test_sample_lemma_coverage(transducer, data_files, report_file, summary_file):
    sample_entries = tuple(get_dwds_entries(data_files))
    entries_with_analysis = tuple(analyse_dwds_entry(transducer, dwds_entry)
                                  for dwds_entry in sample_entries)

    output_report(report_file, entries_with_analysis)
    output_summary(summary_file, entries_with_analysis)
