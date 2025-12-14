#!/usr/bin/env python3
# snapshot.py -- snapshot library for regression tests
# Andreas Nolda 2023-10-09

from pathlib import Path

from pytest import mark

from dwdsmor import edition

test_dir = Path(__file__).parent

if_dwds_available = mark.skipif(
    edition != "dwds",
    reason="Automata edition 'dwds' not available",
)
