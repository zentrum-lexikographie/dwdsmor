import pytest

import dwdsmor.analysis


@pytest.mark.skip(reason='Moved away from XML format providing samples')
def test_lemma(dwdsmor_transducer, lexicon_sample):
    "The transducer shall analyze any canonical form from the lexicon."
    for entry in lexicon_sample:
        lemma = entry['lemma']
        analysis = dwdsmor_transducer.analyse(lemma)
        assert (len(analysis) > 0), lemma


def test_men_women(dwdsmor_transducer, men_women):
    "Tests analysis of derivations of „Mann” and „Frau”"
    for lemma in men_women:
        analyses = dwdsmor.analysis.parse(dwdsmor_transducer.analyse(lemma))
        assert (len(tuple(analyses)) > 0), lemma
