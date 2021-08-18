def test_lemma(smor_lemma, lexicon_sample):
    for entry in lexicon_sample:
        assert len(smor_lemma.analyse(entry['lemma'])) > 0
