from pytest import fixture

import dwdsmor

from .conftest import if_dwds_available


@fixture
def lemmatizer():
    return dwdsmor.lemmatizer()


def test_lemmatizer(lemmatizer):
    assert lemmatizer("getestet", pos={"V"}).analysis == "testen"
    assert lemmatizer("getestet", pos={"ADJ"}).analysis == "getestet"


@if_dwds_available
def test_ptkvz_lemmatization(lemmatizer):
    assert lemmatizer("besser", pos={"V"}, syninfo={"SEP"}).analysis == "besser"
    assert lemmatizer("besser", pos={"ADJ"}).analysis == "gut"
