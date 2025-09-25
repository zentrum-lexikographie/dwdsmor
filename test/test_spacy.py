from subprocess import check_call

import spacy
from datasets import load_dataset
from pytest import fixture

import dwdsmor.spacy  # noqa

from .conftest import if_dwds_available

spacy_model_package = (
    "de_hdt_lg @ https://repo.zdl.org/repository/pypi/packages/"
    "de-hdt-lg/2.2.0/de_hdt_lg-2.2.0-py3-none-any.whl"
)


@fixture(scope="module")
def nlp():
    try:
        nlp = spacy.load("de_hdt_lg")
    except OSError:
        check_call(["pip", "install", "-qqq", spacy_model_package])
        nlp = spacy.load("de_hdt_lg")
    nlp.add_pipe("dwdsmor", config={"automata_location": "build/dwds"})
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


@if_dwds_available
def test_particle_lemmatization(nlp):
    sentences = [
        "Sie nimmt nicht an der Wahl teil.",
        "Wir arbeiten dennoch weiter.",
    ]
    docs = nlp.pipe(sentences)
    tokens = [[t._.dwdsmor.analysis for t in doc] for doc in docs]
    docs_without_dep = nlp.pipe(sentences, disable="parser")
    tokens_without_dep = [
        [t._.dwdsmor.analysis for t in doc] for doc in docs_without_dep
    ]
    expected = [
        ["sie", "nehmen", "nicht", "an", "die", "Wahl", "teil", "."],
        [
            "wir",
            "arbeiten",
            "dennoch",
            "weiter",
            ".",
        ],
    ]
    assert tokens == expected
    assert tokens != tokens_without_dep
