from typing import Iterable

from spacy.language import Language
from spacy.tokens.token import Token

import dwdsmor.tag.hdt as hdt

from . import lemmatizer
from .automaton import Lemmatizer

Token.set_extension("dwdsmor", default=None)


def morph(token_morph, k):
    v = ",".join(token_morph.get(k))
    return v if v else None


def lemmatize_token(lemmatizer: Lemmatizer, token: Token):
    token_morph = token.morph
    token_criteria = hdt.criteria(
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
    token._.dwdsmor = lemmatizer(token.text, **token_criteria)
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
