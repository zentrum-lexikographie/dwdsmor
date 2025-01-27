from subprocess import check_call

import spacy
from datasets import load_dataset
from pytest import fixture

import dwdsmor.spacy  # noqa

from .conftest import if_dwds_available

spacy_model_package = (
    "de_hdt_lg @ https://huggingface.co/zentrum-lexikographie/de_hdt_lg/"
    "resolve/main/de_hdt_lg-any-py3-none-any.whl"
    "#sha256=44bd0b0299865341ee1756efd60670fa148dbfd2a14d0c1d5ab99c61af08236a"
)


@fixture(scope="module")
def nlp():
    try:
        nlp = spacy.load("de_hdt_lg")
    except OSError:
        check_call(["pip", "install", "-qqq", spacy_model_package])
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
