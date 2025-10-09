import csv
from pathlib import Path

from .conftest import automata_edition, if_dwds_available

test_dir = Path(__file__).parent


@if_dwds_available
def test_numeral():
    analyzer = automata_edition("dwds").analyzer()
    test_cases_file = test_dir / "numeral_test_cases.csv"
    with test_cases_file.open("rt") as f:
        for n, (pos, lemma) in enumerate(csv.reader(f)):
            if n == 0:
                continue
            assert (pos, lemma) in {
                (a.pos, a.analysis) for a in analyzer.analyze(lemma)
            }
