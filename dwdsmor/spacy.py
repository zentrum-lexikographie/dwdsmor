from collections import OrderedDict
from functools import cache
from typing import Iterable

from spacy.language import Language
from spacy.tokens.token import Token

import dwdsmor.tag.hdt as hdt

from . import lemmatizer
from .automaton import Lemmatizer

Token.set_extension("dwdsmor_lemma", default=None)


def criterion(k, v, mapping):
    return (k, mapping.get(v, {v}) if v else None)


@cache
def criteria(pos, number, gender, case, person, tense, degree, mood, nonfinite):
    return OrderedDict(
        (
            criterion("pos", pos, hdt.pos_map),
            criterion("number", number, hdt.number_map),
            criterion("gender", gender, hdt.gender_map),
            criterion("case", case, hdt.case_map),
            criterion("person", person, hdt.person_map),
            criterion("tense", tense, hdt.tense_map),
            criterion("degree", degree, hdt.degree_map),
            criterion("mood", mood, hdt.mood_map),
            criterion("nonfinite", nonfinite, hdt.nonfinite_map),
        )
    )


def morph(token_morph, k):
    v = ",".join(token_morph.get(k))
    return v if v else None


def lemmatize_token(lemmatizer: Lemmatizer, token: Token):
    token_morph = token.morph
    token_criteria = criteria(
        token.tag_,
        morph(token_morph, "Number"),
        morph(token_morph, "Gender"),
        morph(token_morph, "Case"),
        morph(token_morph, "Person"),
        morph(token_morph, "Tense"),
        morph(token_morph, "Degree"),
        morph(token_morph, "Mood"),
        morph(token_morph, "VerbForm"),
    )
    token._.dwdsmor_lemma = lemmatizer(token.text, **token_criteria)
    return token


def lemmatize(lemmatizer: Lemmatizer, tokens: Iterable[Token]):
    for token in tokens:
        lemmatize_token(lemmatizer, token)
    return tokens


class Component:
    def __init__(self, automata_location=None):
        self.lemmatizer = lemmatizer(automata_location)

    def __call__(self, doc):
        lemmatize(self.lemmatizer, doc)
        return doc


@Language.factory("dwdsmor", default_config={"automata_location": None})
def create_component(nlp: Language, name: str, automata_location: str | None):
    return Component(automata_location)
