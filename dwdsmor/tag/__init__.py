from itertools import product

stat_tags = ("weights",)
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

all_tags = (
    *stat_tags,
    *lexeme_tags,
    *inflection_tags,
    *info_tags,
    *wordformation_tags,
)

tag_values = {
    "": {
        "weights": {"W-"},
        "lidx": {f"IDX{i}" for i in range(1, 9)},
        "pidx": {f"PAR{i}" for i in range(1, 9)},
        "pos": {
            "ADJ",
            "ADV",
            "ART",
            "CARD",
            "CONJ",
            "DEM",
            "FRAC",
            "INDEF",
            "INTJ",
            "NN",
            "NPROP",
            "ORD",
            "POSS",
            "POSTP",
            "PPRO",
            "PREP",
            "PREPART",
            "PROADV",
            "PTCL",
            "PUNCT",
            "REL",
            "V",
            "WPRO",
        },
        "function": {"Attr", "Subst", "UnmFunc"},
        "gender": {"Masc", "Neut", "Fem", "UnmGend"},
        "case": {"Nom", "Acc", "Dat", "Gen", "UnmCase"},
        "number": {"Sg", "Pl", "UnmNum"},
        "inflection": {"St", "Wk", "UnmInfl"},
        "metainfo": {"Old", "NonSt"},
        "orthinfo": {"OLDORTH", "CH"},
        "charinfo": {"CAP"},
        "syninfo": {"MEAS", "SEP"},
        "ellipinfo": {"TRUNC"},
        "processes": {"COMP", "DER", "CONV"},
        "means": {
            "concat",
            "ident",
            "ident|Inf",
            "ident|Part",
            "ident|Fem",
            "ident|Masc",
            "ident|Neut",
            "intf(-)",
            "intf(und)",
            "pref(un)",
            "prev()",
            "prev(ab)",
            "prev(an)",
            "prev(auf)",
            "prev(aus)",
            "prev(bei)",
            "prev(durch)",
            "prev(ein)",
            "prev(fort)",
            "prev(gegen)",
            "prev(heim)",
            "prev(her)",
            "prev(hin)",
            "prev(hinter)",
            "prev(los)",
            "prev(mit)",
            "prev(nach)",
            "prev(ueber)",
            "prev(um)",
            "prev(unter)",
            "prev(vor)",
            "prev(weg)",
            "prev(wieder)",
            "prev(zu)",
            "prev(zurueck)",
            "prev(zwischen)",
            "suff(bar)",
            "suff(e)",
            "suff(er)",
            "suff(chen)",
            "suff(lein)",
            "suff(st)",
            "suff(stel)",
            "suff(zig)",
        },
    },
    "ADJ": {
        "degree": {"Pos", "Comp", "Sup"},
        "function": {"Attr", "Subst", "Attr/Subst", "Pred/Adv", "UnmFunc"},
    },
    "ADV": {"degree": {"Pos", "Comp", "Sup"}},
    "ART": {
        "category": {"Def", "Indef", "Neg"},
    },
    "CONJ": {"category": {"AdjComp", "Coord", "Sub", "InfCl"}},
    "ORD": {
        "function": {"Attr/Subst", "UnmFunc"},
    },
    "POSS": {
        "function": {"Attr", "Subst", "Attr/Subst"},
    },
    "PPRO": {
        "category": {"Pers", "Refl", "Rec"},
        "person": {"1", "2", "3", "UnmPers"},
    },
    "PTCL": {"category": {"AdjSup", "InfCl", "Int", "Neg"}},
    "PUNCT": {
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
    "V": {
        "nonfinite": {"Inf", "Part"},
        "function": {"NonCl", "Cl"},
        "person": {"1", "2", "3", "UnmPers"},
        "mood": {"Ind", "Subj", "Imp", "UnmMood"},
        "tense": {"Pres", "Past", "Perf", "UnmTense"},
        "auxiliary": {"haben", "sein"},
    },
}


tag_types = {
    v: tt for _pos, tvs in tag_values.items() for tt, vs in tvs.items() for v in vs
}


aff_infl_boundary = "~"
aff_der_boundary = "-"
intf_boundary = "="
concat_boundary = "#"
prev_boundary = "|"
root_boundary = "+"

infl_boundary_tags = aff_infl_boundary
wf_boundary_tags = (
    aff_der_boundary + intf_boundary + concat_boundary + prev_boundary + root_boundary
)
boundary_tags = infl_boundary_tags + wf_boundary_tags


inflection_tag_seqs = {
    "": (("function", "gender", "case", "number", "inflection"),),
    "ADJ": (("degree", "function", "gender", "case", "number", "inflection"),),
    "ADV": (("degree",),),
    "ART": (("category", "function", "gender", "case", "number", "inflection"),),
    "CONJ": (("category",),),
    "FRAC": (("function",),),
    "INTJ": ((),),
    "NN": (("gender", "case", "number", "inflection"),),
    "NPROP": (("gender", "case", "number", "inflection"),),
    "POSTP": ((),),
    "PPRO": (("category", "person", "gender", "case", "number"),),
    "PREP": ((),),
    "PREPART": (("gender", "case", "number"),),
    "PROADV": ((),),
    "PTCL": (("category"),),
    "V": (
        ("mood", "number"),
        ("nonfinite", "function"),
        ("nonfinite", "tense", "auxiliary"),
        ("person", "number", "tense", "mood"),
    ),
}


def get_taggings(pos, with_info=False):
    tag_seqs = inflection_tag_seqs.get(pos) or inflection_tag_seqs.get("")
    if with_info:
        tag_seqs(ts + info_tags for ts in tag_seqs)

    taggings = set()
    for tag_seq in tag_seqs:
        tagging_values = []
        for tag_type in tag_seq:
            tag_type_values = (
                tag_values.get(pos, dict()).get(tag_type) or tag_values[""][tag_type]
            )
            tagging_values.append(tag_type_values | {None})
        for tagging in product(*tagging_values):
            taggings.add(tuple((t for t in tagging if t is not None)))
    return taggings
