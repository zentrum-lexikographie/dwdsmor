import csv
from collections import defaultdict

import dwdsmor
from dwdsmor.build.traversal import traverse
from dwdsmor.traversal import Traversal

from .conftest import if_dwds_available, test_dir


@if_dwds_available
def test_analysis(snapshot):
    analyzer = dwdsmor.analyzer()
    data_dir = test_dir / "gesetze"
    data_files = sorted(data_dir.rglob("*.tok"))
    tokens = [t for f in data_files for t in f.read_text().splitlines()]
    result = [(t, a.spec) for t in tokens for a in analyzer.analyze(t)]
    assert snapshot == result


@if_dwds_available
def test_generation(snapshot):
    test_cases_file = test_dir / "inflection_test_cases.csv"

    traversals = defaultdict(list)
    for surface, spec in traverse(dwdsmor.default_automata_dir / "index.a"):
        t = Traversal.parse(spec)
        traversals[(t.analysis, t.pos)].append((t, surface))

    result = []

    with test_cases_file.open("rt") as f:
        for n, (pos, inflection_classes, lemma) in enumerate(csv.reader(f)):
            if n == 0:
                continue
            lemma_traversals = sorted(
                (t.spec, surface) for t, surface in traversals.get((lemma, pos), [])
            )
            result.append((pos, inflection_classes, lemma, *lemma_traversals))
    assert result == snapshot
