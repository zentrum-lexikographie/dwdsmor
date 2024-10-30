from dataclasses import dataclass
from functools import cached_property
from typing import List, Union

from parsimonious.grammar import Grammar
from parsimonious.nodes import NodeVisitor

tags = {
    "person": {"1", "2", "3", "Invar"},
    "gender": {"Fem", "Neut", "Masc", "NoGend", "Invar"},
    "case": {"Nom", "Gen", "Dat", "Acc", "Invar"},
    "number": {"Sg", "Pl", "Invar"},
    "tense": {"Pres", "Past", "Perf", "Invar"},
    "mood": {"Ind", "Subj", "Imp", "Invar"},
    "auxiliary": {"haben", "sein"},
    "degree": {"Pos", "Comp", "Sup"},
    "inflection": {"St", "Wk", "NoInfl", "Invar"},
    "nonfinite": {"Inf", "Part", "Invar"},
    "means": {"concat", "hyph", "ident", "pref", "prev", "suff"},
    "metainfo": {"Old", "NonSt"},
    "orthinfo": {"OLDORTH", "CH"},
    "ellipinfo": {"TRUNC"},
    "charinfo": {"CAP"},
    "processes": {"COMP", "DER", "CONV"},
    "function": {
        "Attr",
        "Subst",
        "Attr/Subst",
        "Pred/Adv",
        "Cl",
        "NonCl",
        "Invar",
    },
    "pos": {
        "+ADJ",
        "+ART",
        "+CARD",
        "+DEM",
        "+FRAC",
        "+INDEF",
        "+NN",
        "+NPROP",
        "+ORD",
        "+POSS",
        "+PPRO",
        "+REL",
        "+V",
        "+WPRO",
    },
    "subcat": {
        "Pers",
        "Refl",
        "Rec",
        "Def",
        "Indef",
        "Neg",
        "Coord",
        "Sub",
        "InfCl",
        "AdjPos",
        "AdjComp",
        "AdjSup",
        "Comma",
        "Period",
        "Ellip",
        "Quote",
        "Paren",
        "Dash",
        "Slash",
        "Other",
    },
}


tag_to_type = {tag: tag_type for tag_type, tagset in tags.items() for tag in tagset}

grammar = Grammar(
    """
    traversal = alignment+
    alignment = surface_only / both_layers / analysis_only / label
    surface_only = ":" label
    analysis_only = label ":"
    both_layers = label ":" label
    label = marker / colon / char
    colon = "\\:"
    char = ~r"[^<>:]"
    num = ~r"\\d"
    lemma_segment = "~"
    lemma_index = "IDX" num
    paradigm_index = "PAR" num
    empty = ""
    marker = "<" marker_tag ">"
    marker_tag = lemma_index / paradigm_index / lemma_segment / tag / empty
    tag = ~r"[^>]+"
    """
)


@dataclass
class Marker:
    type: str
    tag: str

    def __repr__(self):
        return (
            f"<{self.type}:{self.tag}>"
            if self.type is not self.tag
            else f"<{self.tag}>"
        )


@dataclass
class Alignment:
    analysis: Union[str, Marker]
    surface: Union[str, Marker]

    def __repr__(self):
        return f"{repr(self.surface or '')}={repr(self.analysis or '')}"


@dataclass
class Traversal:
    alignments: List[Union[str, Alignment]]

    @cached_property
    def lemma(self):
        lemma = ""
        for a in self.alignments:
            if type(a) is str:
                lemma += a
                continue
            if type(a.analysis) is str:
                lemma += a.analysis
        return lemma

    def marker(self, tag_type):
        return self.markers_by_type.get(tag_type)

    @cached_property
    def markers_by_type(self):
        return {
            a.analysis.type: a.analysis.tag
            for a in self.alignments
            if type(a) is Alignment
            and type(a.analysis) is Marker
            and a.analysis.type in tags
        }

    def as_dict(self):
        return {"lemma": self.lemma, **self.markers_by_type}

    def __repr__(self):
        return repr(self.alignments)


class Visitor(NodeVisitor):
    def visit_traversal(self, _node, children):
        return children

    def visit_alignment(self, _node, children):
        child, *_ = children
        return child

    def visit_both_layers(self, _node, children):
        analysis, _, surface = children
        return Alignment(analysis, surface)

    def visit_surface_only(self, _node, children):
        _, surface = children
        return Alignment(None, surface)

    def visit_analysis_only(self, _node, children):
        analysis, _ = children
        return Alignment(analysis, None)

    def visit_label(self, _node, children):
        child, *_ = children
        return child

    def visit_marker(self, _node, children):
        _, tag, _ = children
        return tag

    def visit_marker_tag(self, _node, children):
        tag, *_ = children
        k = tag.expr.name
        if k == "tag":
            tag = tag.text
            tag_type = tag_to_type.get(tag, "tag")
            if tag_type == "pos":
                tag = tag[1:]
            return Marker(tag_type, tag)
        elif k == "empty":
            return None
        elif k == "lemma_segment":
            return Marker("~", "~")
        elif k == "lemma_index" or k == "paradigm_index":
            _, n = tag.children
            return Marker(k, n.text)
        else:
            return Marker(k, tag.text)

    def visit_colon(self, _node, _children):
        return ":"

    def visit_char(self, node, _children):
        return node.text

    def generic_visit(self, node, children):
        return node


def parse(s):
    return Traversal(Visitor().visit(grammar.parse(s)))


if __name__ == "__main__":
    s = "limitier<~>:<>e:<>n:<><+V>:<><3>:<><Sg>:t<Past>:<><Subj>:e"
    # s = "limitier<~>en<+V><1><Sg><Past><Ind>"
    print(parse(s).as_dict())
    import timeit

    print(timeit.repeat(lambda: parse(s), number=1000, repeat=10))
