import spacy
from datasets import load_dataset
from pytest import fixture

import dwdsmor.spacy  # noqa


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


def test_lemmatisation(nlp, sentences, snapshot):
    sentences = sentences[:10]
    docs = nlp.pipe(sentences)
    tokens = ((t.text, t.tag_, t.lemma_, t._.dwdsmor_lemma) for d in docs for t in d)
    assert tuple(tokens) == snapshot
