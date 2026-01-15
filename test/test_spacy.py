from itertools import islice

import spacy
from pytest import fixture

import dwdsmor.spacy  # noqa
from dwdsmor.build.ud import download_gsd

from .conftest import if_dwds_available


@fixture(scope="module")
def nlp():
    nlp = spacy.load("de_zdl_lg")
    nlp.add_pipe("dwdsmor")
    return nlp


@fixture(scope="module")
def sentences():
    sentences = (s.metadata["text"] for s in download_gsd())
    return tuple(islice(sentences, 10))


@if_dwds_available
def test_lemmatisation(nlp, sentences, snapshot):
    docs = nlp.pipe(sentences)
    tokens = (
        (t.text, t.tag_, t.lemma_, t._.dwdsmor.analysis)
        for d in docs
        for t in d
        if t._.dwdsmor and t.lemma_ != t._.dwdsmor.analysis
    )
    assert tuple(tokens) == snapshot


@if_dwds_available
def test_particle_lemmatization(nlp):
    sentences = [
        "Sie nimmt nicht an der Wahl teil.",
        "Wir arbeiten beständig weiter.",
    ]
    docs = nlp.pipe(sentences)
    tokens = [[t._.dwdsmor.analysis for t in doc] for doc in docs]
    expected = [
        ["sie", "nehmen", "nicht", "an", "die", "Wahl", "teil", "."],
        ["wir", "arbeiten", "beständig", "weiter", "."],
    ]
    assert tokens == expected
