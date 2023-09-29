#!/usr/bin/env python3
# test_tuebadz_coverage.py - test DWDSmor coverage against TüBa-D/Z
# Gregor Middell and Andreas Nolda 2023-09-29

import csv
from os import path, makedirs
from collections import defaultdict

from pytest import fixture

import sfst_transduce

from tests.tuebadz import get_tuebadz_sentences, analyse_tuebadz_word


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

INPUTDIR = path.join(BASEDIR, "test-data", "tuebadz")

OUTPUTDIR = path.join(BASEDIR, "test-reports")


@fixture
def transducer():
    return sfst_transduce.CompactTransducer(path.join(LIBDIR, "dwdsmor.ca"))


@fixture
def input_file():
    return path.join(INPUTDIR, "tuebadz-11.0-exportXML-v2.xml")


@fixture
def output_file():
    return path.join(OUTPUTDIR, "tuebadz-coverage.tsv")


def output_tsv(output_file, analysed_words):
    output_dirname = path.dirname(output_file)
    if not path.exists(output_dirname):
        makedirs(output_dirname, exist_ok=True)

    stats = defaultdict(lambda: defaultdict(int))
    for analysed_word in analysed_words:
        stats[analysed_word.tuebadz_pos][analysed_word.lemmas_match] += 1

    with open(output_file, "w") as file:
        csv_writer = csv.writer(file, delimiter="\t")
        csv_writer.writerow(["POS",
                             "Lemmas Matched",
                             "Lemmas Not Matched"])
        for tuebadz_pos, matches in sorted(stats.items()):
            csv_writer.writerow([tuebadz_pos,
                                 str(matches[True]),
                                 str(matches[False])])


def test_tuebadz_coverage(transducer, input_file, output_file):
    tuebadz_sentences = tuple(get_tuebadz_sentences(input_file))
    tuebadz_words = tuple(tuebadz_word for tuebadz_sentence in tuebadz_sentences
                          for tuebadz_word in tuebadz_sentence)
    analysed_words = tuple(analyse_tuebadz_word(transducer, tuebadz_word)
                           for tuebadz_word in tuebadz_words)

    output_tsv(output_file, analysed_words)
