from collections import OrderedDict
from functools import cache

pos_map = {
    "$(": {"+PUNCT"},
    "$,": {"+PUNCT"},
    "$.": {"+PUNCT"},
    "ADJA": {"+ADJ", "+CARD", "+INDEF", "+ORD"},
    "ADJD": {"+ADJ"},
    "ADV": {"+ADV"},
    "APPO": {"+POSTP"},
    "APPR": {"+PREP"},
    "APPR_ART": {"+PREPART"},
    "APZR": {"+POSTP", "+PREP"},
    "ART": {"+ART"},
    "CARD": {"+CARD"},
    "FM": {"+FM"},  # ?
    "ITJ": {"+INTJ"},
    "KOKOM": {"+CONJ"},
    "KON": {"+CONJ"},
    "KOUI": {"+CONJ"},
    "KOUS": {"+CONJ"},
    "NE": {"+NN", "+NPROP"},
    "NN": {"+NN", "+NPROP"},
    "PDAT": {"+DEM"},
    "PDS": {"+DEM"},
    "PIAT": {"+INDEF"},
    "PIDAT": {"+INDEF"},
    "PIS": {"+INDEF"},
    "PPER": {"+PPRO"},
    "PPOSAT": {"+POSS"},
    "PPOSS": {"+POSS"},
    "PRELAT": {"+REL"},
    "PRELS": {"+REL"},
    "PRF": {"+PPRO"},
    "PROAV": {"+ADV", "+PROADV"},
    "PTKA": {"+PTCL"},
    "PTKANT": {"+INTJ", "+PTCL"},
    "PTKNEG": {"+PTCL"},
    "PTKVZ": {"+ADV", "+PREP", "+VPART"},
    "PTKZU": {"+PTCL"},
    "PWAT": {"+WPRO"},
    "PWAV": {"+ADV"},
    "PWS": {"+WPRO"},
    "TRUNC": {"+TRUNC"},  # ?
    "VAFIN": {"+V"},
    "VAIMP": {"+V"},
    "VAINF": {"+V"},
    "VAPP": {"+V"},
    "VMFIN": {"+V"},
    "VMINF": {"+V"},
    "VMPP": {"+V"},
    "VVFIN": {"+V"},
    "VVIMP": {"+V"},
    "VVINF": {"+V"},
    "VVIZU": {"+V"},
    "VVPP": {"+V"},
    "XY": {"+XY"},  # ?
}

number_map = {
    "Sing": {"Sg"},
    "Plur": {"Pl"},
}


gender_map = {
    "Masc,Neut": {"Masc", "Neut"},
    "Neut": {"Neut"},
    "Fem": {"Fem"},
    "Masc": {"Masc"},
}

case_map = {
    "Nom": {"Nom"},
    "Gen": {"Gen"},
    "Dat": {"Dat"},
    "Acc": {"Acc"},
}

person_map = {
    "1": {"1"},
    "2": {"2"},
    "3": {"3"},
}

tense_map = {
    "Past": {"Past"},
    "Pres": {"Pres"},
}


degree_map = {
    "Cmp": {"Comp"},
    "Sup": {"Sup"},
    "Pos": {"Pos"},
}

mood_map = {
    "Ind": {"Ind"},
    "Imp": {"Imp"},
}

# VerbForm
nonfinite_map = {
    "Part": {"Part"},
    "Inf": {"Inf"},
}

syninfo_map = {"SEP": {"SEP"}}


def criterion(k, v, mapping):
    return (k, mapping.get(v, {v}) if v else None)


@cache
def criteria(
    pos, number, gender, case, person, tense, degree, mood, nonfinite, syninfo
):
    return OrderedDict(
        (
            criterion("pos", pos, pos_map),
            criterion("number", number, number_map),
            criterion("gender", gender, gender_map),
            criterion("case", case, case_map),
            criterion("person", person, person_map),
            criterion("tense", tense, tense_map),
            criterion("degree", degree, degree_map),
            criterion("mood", mood, mood_map),
            criterion("nonfinite", nonfinite, nonfinite_map),
            criterion("syninfo", syninfo, syninfo_map),
        )
    )
