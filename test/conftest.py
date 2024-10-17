#!/usr/bin/env python3
# snapshot.py -- snapshot library for regression tests
# Andreas Nolda 2023-10-09

from os import path

from pytest import fixture
from syrupy.extensions.single_file import SingleFileSnapshotExtension, WriteMode

TESTDIR = path.dirname(__file__)

REPORTDIR = path.join(TESTDIR, "reports")


class TSVSnapshotExtension(SingleFileSnapshotExtension):
    _write_mode = WriteMode.TEXT
    _file_extension = "tsv"

    @classmethod
    def get_snapshot_name(cls, *, test_location, index):
        snapshot_name = SingleFileSnapshotExtension.get_snapshot_name(
            test_location=test_location, index=index
        )
        if snapshot_name.startswith("test_"):
            snapshot_name = snapshot_name[5:]
        snapshot_name = snapshot_name.replace("_", "-")
        return snapshot_name

    @classmethod
    def dirname(cls, *, test_location):
        return REPORTDIR


@fixture
def tsv_snapshot_test(snapshot):
    return snapshot.use_extension(TSVSnapshotExtension)
