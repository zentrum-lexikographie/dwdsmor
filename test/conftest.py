#!/usr/bin/env python3
# snapshot.py -- snapshot library for regression tests
# Andreas Nolda 2023-10-09

from pathlib import Path

from pytest import mark

from dwdsmor import automata

project_dir = Path(__file__).parent.parent
build_dir = project_dir / "build"


def is_edition_available(edition):
    return (build_dir / edition).is_dir()


def automata_edition(edition):
    assert is_edition_available(edition)
    return automata(build_dir / edition)


if_dwds_available = mark.skipif(
    not is_edition_available("dwds"),
    reason="Automata edition 'dwds' not available",
)
