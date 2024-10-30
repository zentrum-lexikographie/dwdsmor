from dataclasses import dataclass

tags = {
    "lidx": {f"IDX{i}" for i in range(1, 9)},
    "pidx": {f"PAR{i}" for i in range(1, 9)},
    "pos": {
        "+ADJ",
        "+ADV",
        "+ART",
        "+CARD",
        "+CONJ",
        "+DEM",
        "+FRAC",
        "+INDEF",
        "+INTJ",
        "+NN",
        "+NPROP",
        "+ORD",
        "+POSS",
        "+POSTP",
        "+PPRO",
        "+PREP",
        "+PREPART",
        "+PROADV",
        "+PTCL",
        "+PUNCT",
        "+REL",
        "+V",
        "+WPRO",
    },
    "gender": {"Fem", "Neut", "Masc", "NoGend", "Invar"},
    "number": {"Sg", "Pl", "Invar"},
    "case": {"Nom", "Gen", "Dat", "Acc", "Invar"},
    "degree": {"Pos", "Comp", "Sup"},
    "function": {
        "Attr",
        "Subst",
        "Attr/Subst",
        "Pred/Adv",
        "Cl",
        "NonCl",
        "Invar",
    },
    "tense": {"Pres", "Past", "Perf", "Invar"},
    "mood": {"Ind", "Subj", "Imp", "Invar"},
    "person": {"1", "2", "3", "Invar"},
    "auxiliary": {"haben", "sein"},
    "inflection": {"St", "Wk", "NoInfl", "Invar"},
    "nonfinite": {"Inf", "Part", "Invar"},
    "means": {"concat", "hyph", "ident", "pref", "prev", "suff"},
    "metainfo": {"Old", "NonSt"},
    "orthinfo": {"OLDORTH", "CH"},
    "ellipinfo": {"TRUNC"},
    "charinfo": {"CAP"},
    "processes": {"COMP", "DER", "CONV"},
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


tag_types = {v: k for k, vs in tags.items() for v in vs}

inflection_tags = "~"
word_formation_tags = "#-|"
other_boundary_tags = "="
boundary_tags = inflection_tags + word_formation_tags + other_boundary_tags


@dataclass
class Traversal:
    spec: str
    surface: str
    analysis: str
    pos: str | None = None
    gender: str | None = None
    number: str | None = None
    case: str | None = None
    degree: str | None = None
    function: str | None = None
    tense: str | None = None
    mood: str | None = None
    person: str | None = None
    auxiliary: str | None = None
    inflection: str | None = None
    nonfinite: str | None = None
    means: str | None = None
    metainfo: str | None = None
    orthinfo: str | None = None
    ellipinfo: str | None = None
    charinfo: str | None = None
    processes: str | None = None
    subcat: str | None = None
    lidx: str | None = None
    pidx: str | None = None

    def reparse(self, **args):
        return Traversal.parse(self.spec, **args)

    @staticmethod
    def parse_label(s, visible_boundaries, boundary_tag):
        c = s[0]
        if c != "<" and c != ":":
            return "", c, s[1:]
        elif c == "<":
            e = s.find(">")
            assert e > 0
            tag = s[1:e]
            s = s[e + 1 :]
            if tag == "":
                return "", "", s
            elif tag in visible_boundaries:
                return ("", boundary_tag or f"<{tag}>", s)
            elif tag in boundary_tags:
                return ("", "", s)
            else:
                return tag_types[tag], tag, s

    @staticmethod
    def parse(s, visible_boundaries="", boundary_tag=None):
        spec = s
        surface = ""
        analysis = ""
        tags = {}
        while s:
            if s.startswith(r"\:"):
                surface += ":"
                analysis += ":"
                s = s[2:]
                continue
            k, v, s = Traversal.parse_label(s, visible_boundaries, boundary_tag)
            if k:
                tags[k] = v
            else:
                analysis += v
            if s.startswith(":"):
                k, v, s = Traversal.parse_label(s[1:], visible_boundaries, boundary_tag)
                if k:
                    tags[k] = v
                else:
                    surface += v
            elif not k:
                surface += v
        return Traversal(spec, surface, analysis, **tags)
