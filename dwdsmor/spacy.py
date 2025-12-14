from spacy.language import Language
from spacy.tokens.token import Token

import dwdsmor.tag.hdt as hdt

from . import lemmatizer

Token.set_extension("dwdsmor", default=None)


def morph(token_morph, k):
    v = ",".join(token_morph.get(k))
    return v if v else None


class Component:
    def __init__(self, automata_location=None):
        self.lemmatizer = lemmatizer()

    def __call__(self, doc):
        for token in doc:
            token_morph = token.morph
            token_criteria = hdt.criteria(
                token.tag_,
                morph(token_morph, "Number"),
                morph(token_morph, "Gender"),
                morph(token_morph, "Case"),
                morph(token_morph, "Person") or "UnmPers"
                if token.dep_ == "compound:prt"
                else None,
                morph(token_morph, "Tense"),
                morph(token_morph, "Degree"),
                morph(token_morph, "Mood"),
                morph(token_morph, "VerbForm"),
                "SEP" if token.dep_ == "compound:prt" else None,
            )
            token._.dwdsmor = self.lemmatizer(token.text, **token_criteria)
        return doc


@Language.factory("dwdsmor")
def create_component(nlp: Language, name: str):
    return Component()
