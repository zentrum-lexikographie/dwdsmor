import csv
from pathlib import Path

from .conftest import automata_edition, if_dwds_available

test_dir = Path(__file__).parent


@if_dwds_available
def test_analysis(snapshot):
    analyzer = automata_edition("dwds").analyzer()
    data_dir = test_dir / "gesetze"
    data_files = sorted(data_dir.rglob("*.tok"))
    tokens = [t for f in data_files for t in f.read_text().splitlines()]
    result = [(t, a.spec) for t in tokens for a in analyzer.analyze(t)]
    assert snapshot == result


@if_dwds_available
def test_generation(snapshot):
    traversals = automata_edition("dwds").traversals()
    test_cases_file = test_dir / "inflection_test_cases.csv"
    result = []
    with test_cases_file.open("rt") as f:
        for n, (pos, inflection_classes, lemma) in enumerate(csv.reader(f)):
            if n == 0:
                continue
            lemma_traversals = sorted(
                ((t.spec, t.surface) for t in traversals.get(lemma, []) if t.pos == pos)
            )
            result.append((pos, inflection_classes, lemma, *lemma_traversals))
    assert result == snapshot
