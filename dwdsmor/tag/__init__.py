lexeme_tags = ("lidx", "pidx", "pos")
inflection_tags = (
    "category",
    "degree",
    "function",
    "person",
    "gender",
    "case",
    "number",
    "nonfinite",
    "tense",
    "mood",
    "auxiliary",
    "inflection",
)
info_tags = ("metainfo", "orthinfo", "charinfo", "syninfo", "ellipinfo")
wordformation_tags = ("processes", "means")

all_tags = (*lexeme_tags, *inflection_tags, *info_tags, *wordformation_tags)

tag_values = {
    "": {
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
        "degree": {"Pos", "Comp", "Sup"},
        "function": {"Attr", "Subst", "UnmFunc"},
        "person": {"1", "2", "3", "UnmPers"},
        "gender": {"Fem", "Neut", "Masc", "UnmGend"},
        "case": {"Nom", "Gen", "Dat", "Acc", "UnmCase"},
        "number": {"Sg", "Pl", "UnmNum"},
        "nonfinite": {"Inf", "Part"},
        "tense": {"Pres", "Past", "Perf", "UnmTense"},
        "mood": {"Ind", "Subj", "Imp", "UnmMood"},
        "auxiliary": {"haben", "sein"},
        "inflection": {"St", "Wk", "UnmInfl"},
        "metainfo": {"Old", "NonSt"},
        "orthinfo": {"OLDORTH", "CH"},
        "charinfo": {"CAP"},
        "syninfo": {"SEP"},
        "ellipinfo": {"TRUNC"},
        "processes": {"COMP", "DER", "CONV"},
        "means": {"concat", "hyph", "ident", "pref", "prev", "suff"},
    },
    "+ADJ": {"function": {"Attr", "Subst", "Attr/Subst", "Pred/Adv"}},
    "+ART": {
        "category": {"Def", "Indef", "Neg"},
    },
    "+CONJ": {"category": {"AdjComp", "Coord", "Sub", "InfCl"}},
    "+ORD": {
        "function": {"Attr/Subst"},
    },
    "+POSS": {
        "function": {"Attr/Subst"},
    },
    "+PPRO": {
        "category": {"Pers", "Refl", "Rec"},
    },
    "+PTCL": {"category": {"AdjPos", "AdjSup", "InfCl", "Neg"}},
    "+PUNCT": {
        "category": {
            "Comma",
            "Period",
            "Ellip",
            "Quote",
            "Paren",
            "Dash",
            "Slash",
            "Other",
        },
    },
    "+V": {"function": {"NonCl", "Cl"}},
}


tag_types = {
    v: tt for _pos, tvs in tag_values.items() for tt, vs in tvs.items() for v in vs
}


inflection_boundary_tags = "~"
separable_verb_tag = "|"
word_formation_tags = "#-"
other_boundary_tags = "="
boundary_tags = (
    inflection_boundary_tags
    + separable_verb_tag
    + word_formation_tags
    + other_boundary_tags
)

inflection_tag_seqs = {
    "": (("function", "gender", "case", "number", "inflection"),),
    "+ADJ": (("degree", "function", "gender", "case", "number", "inflection"),),
    "+ADV": (("degree",),),
    "+ART": (("category", "function", "gender", "case", "number", "inflection"),),
    "+CONJ": (("category",),),
    "+FRAC": (("function",),),
    "+INTJ": ((),),
    "+NN": (("gender", "case", "number", "inflection"),),
    "+NPROP": (("gender", "case", "number", "inflection"),),
    "+POSTP": ((),),
    "+PPRO": (("category", "person", "gender", "case", "number"),),
    "+PREP": ((),),
    "+PREPART": (("gender", "case", "number"),),
    "+PROADV": ((),),
    "+PTCL": (("category"),),
    "+V": (
        ("mood", "number"),
        ("nonfinite", "function"),
        ("nonfinite", "tense", "auxiliary"),
        ("person", "number", "tense", "mood"),
    ),
}
