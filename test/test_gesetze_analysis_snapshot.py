#!/usr/bin/env python3
# test_gesetze_analysis_snapshot.py
# test DWDSmor analysis snapshots against legal texts for regression
# Andreas Nolda 2023-10-09

import io
import csv
from os import path, listdir

from pytest import fixture

import sfst_transduce

from dwdsmor import output_analyses

from test.snapshot import tsv_snapshot_test


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")

DATADIR = path.join(TESTDIR, "data", "gesetze")


@fixture
def transducer():
    # use transducer in standard format with deterministic order of analyses
    return sfst_transduce.Transducer(path.join(LIBDIR, "dwdsmor.a"))


@fixture
def data_files():
    toc_files = [path.join(DATADIR, file) for file in listdir(DATADIR) if file.endswith(".tok")]
    return tuple(toc_files)


def get_analyses(transducer, data_files):
    output = io.StringIO()
    csv_writer = csv.writer(output, delimiter="\t", lineterminator="\n")
    header_row = ["Wordform",
                  "Lemma",
                  "Lemma Index",
                  "Paradigm Index",
                  "Process",
                  "Means",
                  "POS",
                  "Subcategory",
                  "Auxiliary",
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
                  "Metainfo",
                  "Orthinfo",
                  "Charinfo"]
    csv_writer.writerow(header_row)
    for data_file in sorted(data_files):
        with open(data_file) as file:
            output_analyses(transducer, file, output,
                            no_analysis=True, no_segmentation=True,
                            header=False, plain=True)
    return output.getvalue()


def test_gesetze_analysis_snapshot(tsv_snapshot_test, transducer, data_files):
    analyses = get_analyses(transducer, data_files)
    assert analyses == tsv_snapshot_test
