def test_lemma(smor_lemma, lexicon_sample):
    "The transducer shall analyze any canonical form from the lexicon."
    for entry in lexicon_sample:
        lemma = entry['lemma']
        analysis = smor_lemma.analyse(lemma)
        assert (len(analysis) > 0), lemma
