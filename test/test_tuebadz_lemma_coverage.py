#!/usr/bin/env python3
# test_tuebadz_lemma_coverage.py
# test DWDSmor lemmas against TüBa-D/Z for coverage
# Gregor Middell and Andreas Nolda 2023-10-09

import csv
from os import path, makedirs
from collections import defaultdict

from pytest import fixture

import sfst_transduce

from test.tuebadz_coverage import get_tuebadz_sentences, analyse_tuebadz_word


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

DATADIR = path.join(TESTDIR, "data", "tuebadz")

REPORTDIR = path.join(TESTDIR, "reports")

SUMMARYDIR = path.join(TESTDIR, "summaries")


@fixture
def transducer():
    return sfst_transduce.CompactTransducer(path.join(LIBDIR, "dwdsmor.ca"))


@fixture
def data_file():
    return path.join(DATADIR, "tuebadz-11.0-exportXML-v2.xml")


@fixture
def report_file():
    return path.join(REPORTDIR, "tuebadz-lemma-coverage.tsv")


@fixture
def summary_file():
    return path.join(SUMMARYDIR, "tuebadz-lemma-coverage.tsv")


def output_report(report_file, analysed_words):
    output_dirname = path.dirname(report_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    with open(report_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")

        header_row = ["Form",
                      "Lemma",
                      "POS",
                      "DWDSmor POS",
                      "DWDSmor Lemma",
                      "Matched"]
        csv_writer.writerow(header_row)

        for analysed_word in analysed_words:
            row = [analysed_word.word,
                   analysed_word.tuebadz_lemma,
                   analysed_word.tuebadz_pos,
                   analysed_word.dwdsmor_pos,
                   analysed_word.dwdsmor_lemma,
                   analysed_word.lemmas_match]
            csv_writer.writerow(row)


def output_summary(summary_file, analysed_words):
    output_dirname = path.dirname(summary_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    stats = defaultdict(lambda: defaultdict(int))
    for analysed_word in analysed_words:
        stats[analysed_word.tuebadz_pos][analysed_word.lemmas_match] += 1

    with open(summary_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t", lineterminator="\n")

        header_row = ["POS",
                      "Lemmas",
                      "Matched Lemmas",
                      "Percentage Matched Lemmas"]
        csv_writer.writerow(header_row)

        for tuebadz_pos, matches in sorted(stats.items()):
            lemma_count = sum(matches.values())
            matched_lemma_count = matches[True]
            matched_lemma_percentage = matched_lemma_count / lemma_count
            row = [tuebadz_pos,
                   lemma_count,
                   matched_lemma_count,
                   f"{matched_lemma_percentage:.2%}"]
            csv_writer.writerow(row)


def test_tuebadz_lemma_coverage(transducer, data_file, report_file, summary_file):
    tuebadz_sentences = tuple(get_tuebadz_sentences(data_file))
    tuebadz_words = tuple(tuebadz_word for tuebadz_sentence in tuebadz_sentences
                          for tuebadz_word in tuebadz_sentence)
    analysed_words = tuple(analyse_tuebadz_word(transducer, tuebadz_word)
                           for tuebadz_word in tuebadz_words)

    output_report(report_file, analysed_words)
    output_summary(summary_file, analysed_words)
