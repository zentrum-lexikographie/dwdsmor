#!/usr/bin/env python3
# test_gesetze_analysis_snapshot.py
# test DWDSmor analysis snapshots against legal texts for regression
# Andreas Nolda 2024-09-12

import csv
from pathlib import Path

from .conftest import automata, if_dwds_available

test_dir = Path(__file__).parent


@if_dwds_available
def test_analysis(snapshot):
    analyzer = automata("dwds").analyzer()
    data_dir = test_dir / "gesetze"
    tokens = {t for f in data_dir.rglob("*.tok") for t in f.read_text().splitlines()}
    result = sorted(((t, a.spec) for t in tokens for a in analyzer.analyze(t)))
    assert snapshot == result


@if_dwds_available
def test_generation(snapshot):
    traversals = automata("dwds").traversals()
    test_cases_file = test_dir / "inflection_test_cases.csv"
    result = []
    with test_cases_file.open("rt") as f:
        for n, (pos, inflection_classes, lemma) in enumerate(csv.reader(f)):
            if n == 0:
                continue
            lemma_traversals = sorted(
                (t.spec for t in traversals.get(lemma, []) if t.pos == f"+{pos}")
            )
            result.append((pos, inflection_classes, lemma, *lemma_traversals))
    assert result == snapshot
