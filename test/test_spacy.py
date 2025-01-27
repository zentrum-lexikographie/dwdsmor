import spacy
from datasets import load_dataset
from pytest import fixture

import dwdsmor.spacy  # noqa

from .conftest import if_dwds_available


@fixture(scope="module")
def nlp():
    nlp = spacy.load("de_hdt_lg")
    nlp.add_pipe("dwdsmor")
    return nlp


@fixture(scope="module")
def sentences():
    ds = load_dataset(
        "universal_dependencies",
        "de_gsd",
        split="train",
        trust_remote_code=True,
    )
    return tuple(s["text"] for s in ds.select(range(100)))


@if_dwds_available
def test_lemmatisation(nlp, sentences, snapshot):
    sentences = sentences[:10]
    docs = nlp.pipe(sentences)
    tokens = (
        (t.text, t.tag_, t.lemma_, t._.dwdsmor.analysis)
        for d in docs
        for t in d
        if t._.dwdsmor and t.lemma_ != t._.dwdsmor.analysis
    )
    assert tuple(tokens) == snapshot
