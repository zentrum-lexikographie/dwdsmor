#!/usr/bin/env python3
# test_paradigm_snapshot.py
# test DWDSmor paradigm snapshots for regression
# Andreas Nolda 2023-10-20

import io
import csv
from os import path

from pytest import fixture

import sfst_transduce

from paradigm import output_paradigms

from test.snapshot import tsv_snapshot_test


TESTDIR = path.dirname(__file__)

BASEDIR = path.dirname(TESTDIR)

LIBDIR = path.join(BASEDIR, "lib")


ADJECTIVE_POS = "ADJ"

ADJECTIVE_LEMMAS = ["lila",      # AdjPos0
                    "pleite",    # AdjPosPred
                    "Berliner",  # AdjPos0AttrSubst
                    "derartig",  # AdjPos
                    "hell",      # Adj+
                    "bunt",      # Adj+e
                    "neu",       # Adj+, Adj+e
                    "warm",      # Adj$
                    "kalt",      # Adj$e
                    "teuer",     # Adj-el/er
                    "dunkel",    # Adj-el/er, Adj$-el/er
                    "gut",       # AdjPos, AdjComp, AdjSup
                    "viel",      # AdjPos, AdjPos0-viel, AdjComp0-mehr, AdjSup
                    "hoch"]      # AdjPosPred, AdjPosAttr, AdjComp, AdjSup


ARTICLE_POS = "ART"

ARTICLE_LEMMAS = ["die",    # ArtDef
                  "eine",   # ArtIndef, ArtIndef-n
                  "keine"]  # ArtNeg


CARDINAL_POS = "CARD"

CARDINAL_LEMMAS = ["eine",    # Card-ein
                   "zwei",    # Card-zwei
                   "vier",    # Card-vier
                   "sieben",  # Card-sieben
                   "null"]    # Card0


DEMONSTRATIVE_PRONOUN_POS = "DEM"

DEMONSTRATIVE_PRONOUN_LEMMAS = ["die",     # DemDef
                                "diese",   # Dem-dies
                                "solche",  # Dem-solch
                                "jene"]    # Dem


INDEFINITE_PRONOUN_POS = "INDEF"

INDEFINITE_PRONOUN_LEMMAS = ["welche",        # Indef-welch
                             "irgendwelche",  # Indef-irgendwelch
                             "alle",          # Indef-all
                             "jede",          # Indef-jed
                             "jegliche",      # Indef-jeglich
                             "sämtliche",     # Indef-saemtlich
                             "beide",         # Indef-beid
                             "einige",        # Indef-einig
                             "manche",        # Indef-manch
                             "mehrere",       # Indef-mehrer
                             "genug",         # Indef0
                             "eine",          # Indef-ein
                             "irgendeine",    # Indef-irgendein
                             "keine",         # Indef-kein
                             "etwas",         # IPro-Neut
                             "jemand",        # IPro-Masc
                             "jedermann",     # IPro-jedermann
                             "man",           # IPro-man
                             "wer",           # IProMascNomSg, IProMascAccSg, IProMascDatSg, IProMascGenSg
                             "was"]           # IProNeutNomSg, IProNeutAccSg, IProNeutDatSg, IProNeutGenSg


INTERROGATIVE_PRONOUN_POS = "WPRO"

INTERROGATIVE_PRONOUN_LEMMAS = ["wer",     # WProMascNomSg, WProMascAccSg, WProMascDatSg, WProMascGenSg, WProNeutNomSg ...
                                "was",     # WProMascNomSg, WProMascAccSg, WProMascDatSg, WProMascGenSg, WProNeutNomSg ...
                                "welche"]  # W-welch


NAME_POS = "NPROP"

NAME_LEMMAS = ["Atlantik",   # Name-Masc_0, Name-Masc_s
               "Andreas",    # Name-Masc_apos
               "Rhein",      # Name-Masc_es
               "Opa",        # Name-Masc_s
               "Berlin",     # Name-Neut_s
               "Ostsee",     # Name-Fem_0
               "Felicitas",  # Name-Fem_apos
               "Oma",        # Name-Fem_s
               "Alpen"]      # Name-Pl_x


NOUN_POS = "NN"

NOUN_LEMMAS = ["Jazz",         # NMasc/Sg_0
               "Kitsch",       # NMasc/Sg_es
               "Adel",         # NMasc/Sg_s
               "Bau",          # NMasc/Sg_es, NMasc/Pl_x
               "Blues",        # NMasc_0_x
               "Dezember",     # NMasc_0_0, NMasc_s_0
               "Januar",       # NMasc_0_e, NMasc_s_e
               "Zirkus",       # NMasc_0_e~ss
               "Atlas",        # NMasc_0_e~ss, NMasc_es_e~ss, NMasc-as0/anten, NMasc-as/anten
               "Globus",       # NMasc_0_e~ss, NMasc_es_e~ss, NMasc-us0/en, NMasc-us/en
               "Embryo",       # NMasc_0_nen, NMasc_0_s, NMasc_s_nen, NMasc_s_s, NNeut_0_nen ...
               "Intercity",    # NMasc_0_s
               "Freund",       # NMasc_es_e
               "Bus",          # NMasc_es_e~ss
               "Arzt",         # NMasc_es_$e
               "Block",        # NMasc_es_$e, NMasc_es_s
               "Leib",         # NMasc_es_er
               "Gott",         # NMasc_es_$er
               "Schmerz",      # NMasc_es_en
               "Crash",        # NMasc_es_es, NMasc_es_s
               "Tennismatch",  # NMasc_es_es, NMasc_es_s, NNeut_es_es ...
               "Daumen",       # NMasc_s_x
               "Ski",          # NMasc_s_x, NMasc_s_er
               "Garten",       # NMasc_s_$x
               "Engel",        # NMasc_s_0
               "Vize",         # NMasc_s_0, NMasc_s_s, NFem_0_0, NFem_0_s
               "Apfel",        # NMasc_s_$
               "Abend",        # NMasc_s_e
               "Unfall",       # NMasc_s_$e
               "Irrtum",       # NMasc_s_$er
               "Direktor",     # NMasc_s_en
               "Prototyp",     # NMasc_s_en, NMasc_en_en, NNeut_s_en
               "Muskel",       # NMasc_s_n
               "Opa",          # NMasc_s_s
               "Dirigent",     # NMasc_en_en
               "Affe",         # NMasc_n_n
               "Junge",        # NMasc_n_n, NMasc-Adj, NNeut-Adj, NFem-Adj
               "Gedanke",      # NMasc-ns
               "Virus",        # NMasc-us0/en, NNeut-us0/en
               "Rhythmus",     # NMasc-us/en
               "Modus",        # NMasc-us0/i
               "Deutsche",     # NMasc-Adj, NNeut-Adj/Sg, NFem-Adj
               "Abseits",      # NNeut/Sg_0
               "Ausland",      # NNeut/Sg_es
               "Verständnis",  # NNeut/Sg_es~ss
               "Internet",     # NNeut/Sg_s
               "Ostern",       # NNeut_0_x
               "Zuhause",      # NNeut_0_0
               "Nichts",       # NNeut_0_e
               "Foyer",        # NNeut_0_s
               "Spiel",        # NNeut_es_e
               "Tablett",      # NNeut_es_e, NNeut_es_s
               "Zeugnis",      # NNeut_es_e~ss
               "Floß",         # NNeut_es_$e
               "Lied",         # NNeut_es_er
               "Buch",         # NNeut_es_$er
               "Bett",         # NNeut_es_en
               "Zeichen",      # NNeut_s_x
               "Examen",       # NNeut_s_x, NNeut-en/ina
               "Feuer",        # NNeut_s_0
               "Kloster",      # NNeut_s_$
               "Signal",       # NNeut_s_e
               "Auge",         # NNeut_s_n
               "Herz",         # NNeut-Herz
               "Indiz",        # NNeut_es_ien
               "Material",     # NNeut_s_ien
               "Sofa",         # NNeut_s_s
               "Komma",        # NNeut_s_s, NNeut-a/ata
               "Risiko",       # NNeut_s_s, NNeut-o/en
               "Cello",        # NNeut_s_s, NNeut-o/i
               "Dogma",        # NNeut-a/en
               "Paradoxon",    # NNeut-on/a
               "Stadion",      # NNeut-on/en
               "Maximum",      # NNeut-um/a
               "Museum",       # NNeut-um/en
               "Innere",       # NNeut-Inner
               "Ruhe",         # NFem/Sg_0
               "Jeans",        # NFem_0_x
               "Tochter",      # NFem_0_$
               "Milch",        # NFem_0_e, NFem_0_en
               "Kenntnis",     # NFem_0_e~ss
               "Wand",         # NFem_0_$e
               "Frau",         # NFem_0_en
               "Werkstatt",    # NFem_0_$en
               "Hilfe",        # NFem_0_n
               "Oma",          # NFem_0_s
               "Freundin",     # NFem-in
               "Firma",        # NFem-a/en
               "Basis",        # NFem-is/en
               "Kosten",       # NoGend/Pl_x
               "Leute"]        # NoGend/Pl_0


ORDINAL_POS = "ORD"

ORDINAL_LEMMAS = ["erste"]  # Ord


POSSESSIVE_PRONOUN_POS = "POSS"

POSSESSIVE_PRONOUN_LEMMAS = ["meine",    # Poss
                             "unsere",   # Poss-er
                             "Deinige",  # Poss/Wk
                             "Eurige"]   # Poss/Wk-er


PERSONAL_PRONOUN_POS = "PPRO"

PERSONAL_PRONOUN_LEMMAS = ["ich",       # PPro1NomSg, PPro1AccSg, PPro1DatSg, PPro1GenSg
                           "du",        # PPro2NomSg, PPro2AccSg, PPro2DatSg, PPro2GenSg
                           "er",        # PProMascNomSg, PProMascAccSg, PProMascDatSg, PProMascGenSg
                           "es",        # PProNeutNomSg, PProNeutAccSg, PProNeutDatSg, PProNeutGenSg, PProNeutNomSg-s, PProNeutAccSg-s

                           "wir",       # PPro1NomPl, PPro1AccPl, PPro1DatPl, PPro1GenPl
                           "ihr",       # PPro2NomPl, PPro2AccPl, PPro2DatPl, PPro2GenPl
                           "sie",       # PProFemNomSg, PProFemAccSg, PProFemDatSg, PProFemGenSg, PProNoGendNomPl ...

                           "mich",      # PRefl1AccSg, PRefl1DatSg
                           "dich",      # PRefl2AccSg, PRefl2DatSg
                           "uns",       # PRefl1Pl
                           "euch",      # PRefl2Pl
                           "sich",      # PRefl3
                           "einander"]  # PRecPl


RELATIVE_PRONOUN_POS = "REL"

RELATIVE_PRONOUN_LEMMAS = ["die",     # Rel
                           "welche"]  # Rel-welch


VERB_POS = "V"

VERB_LEMMAS = ["sagen",        # VVReg
               "versagen",     # VVReg
               "absagen",      # VVReg
               "klettern",     # VVReg-el/er
               "verwechseln",  # VVReg-el/er
               "winken",       # VVReg, VVPP-en
               "brauchen",     # VVReg, VVPastSubjReg
               "fassen",       # VVReg, VVPres1+Imp, VVPres2, VVPastIndReg, VVPastSubjReg, VVPP-t
               "fragen",       # VVReg, VVPres1+Imp, VVPres2, VVPastIndStr, VVPastSubjStr, VVPP-t
               "schrecken",    # VVReg, VVPres1, VVPres2+Imp0, VVPastIndStr, VVPastSubjStr, VVPP-t
               "rennen",       # VVPres, VVPastIndReg, VVPastSubjReg, VVPP-t
               "mahlen",       # VVPres, VVPastIndReg, VVPastSubjReg, VVPP-en
               "gehen",        # VVPres, VVPastStr, VVPP-en
               "kommen",       # VVPres, VVPastIndStr, VVPastSubjStr, VVPP-en
               "gewinnen",     # VVPres, VVPastIndStr, VVPastSubjStr, VVPastSubjOld, VVPP-en
               "backen",       # VVPres, VVPres1+Imp, VVPres2, VVPastIndReg, VVPastIndStr, VVPastSubjReg, VVPastSubjStr, VVPP-en
               "sehen",        # VVPres1, VVPres2+Imp, VVPastIndStr, VVPastSubjStr, VVPP-en
               "geben",        # VVPres1, VVPres2+Imp0, VVPastIndStr, VVPastSubjStr, VVPP-en
               "empfehlen",    # VVPres1, VVPres2+Imp0, VVPastIndStr, VVPastSubjStr, VVPastSubjOld, VVPP-en
               "treten",       # VVPres1, VVPres2t+Imp0, VVPastIndStr, VVPastSubjStr, VVPP-en
               "gelten",       # VVPres1, VVPres2t+Imp0, VVPastIndStr, VVPastSubjStr, VVPastSubjOld, VVPP-en
               "laufen",       # VVPres1+Imp, VVPres2, VVPastStr, VVPP-en
               "haben" ,       # VVPres1+Imp, VVPres2, VVPastIndReg, VVPastSubjReg, VVPP-t
               "fahren",       # VVPres1+Imp, VVPres2, VVPastIndStr, VVPastSubjStr, VVPP-en
               "verhalten",    # VVPres1+Imp, VVPres2t, VVPastStr, VVPP-en
               "wissen",       # VMPresSg, VMPresPl, VVPastIndReg, VVPastSubjReg, VVPP-t
               "können",       # VMPresSg, VMPresPl, VVPastIndReg, VVPastSubjReg, VVPP-t, VVPP-en
               "werden",       # VInf-en, VAPres1SgInd, VAPres2SgInd, VAPres3SgInd, VAPres1/3PlInd, VAPres2PlInd, VPresSubj,
                               # VAPastIndSg, VAPastIndPl, VPastIndIrreg, VPastSubjStr, VAImpSg, VAImpPl, VVPP-en
               "tun",          # VInf-n, VAPres1SgInd, VAPres2SgInd, VAPres3SgInd, VAPres1/3PlInd, VAPres2PlInd, VPresSubj,
                               # VPastIndStr, VPastSubjStr, VAImpSg, VAImpPl, VPPast
               "sein"]         # VInf-n, VAPres1SgInd, VAPres2SgInd, VAPres3SgInd, VAPres1/3PlInd, VAPres2PlInd, VAPresSubjSg,
                               # VAPres2SgSubj, VAPresSubjPl, VPastIndStr, VPastSubjStr, VAPastSubj2, VAImpSg, VAImpPl, VVPP-en

@fixture
def transducer():
    return sfst_transduce.Transducer(path.join(LIBDIR, "dwdsmor-index.a"))


def get_paradigms(transducer, lemmas, pos):
    output = io.StringIO()
    csv_writer = csv.writer(output, delimiter="\t", lineterminator="\n")

    header_row = ["Lemma",
                  "Lemma Index",
                  "Paradigm Index",
                  "Categories",
                  "Paradigm Categories",
                  "Paradigm Forms"]
    csv_writer.writerow(header_row)

    for lemma in sorted(set(lemmas)):
        output_paradigms(transducer, lemma, output, pos=pos,
                         nonst=True, old=True, oldorth=True, ch=True,
                         no_cats=True, header=False, plain=True)
    return output.getvalue()


def test_adjective_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, ADJECTIVE_LEMMAS, ADJECTIVE_POS)
    assert paradigms == tsv_snapshot_test


def test_article_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, ARTICLE_LEMMAS, ARTICLE_POS)
    assert paradigms == tsv_snapshot_test


def test_cardinal_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, CARDINAL_LEMMAS, CARDINAL_POS)
    assert paradigms == tsv_snapshot_test


def test_demonstrative_pronoun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, DEMONSTRATIVE_PRONOUN_LEMMAS, DEMONSTRATIVE_PRONOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_indefinite_pronoun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, INDEFINITE_PRONOUN_LEMMAS, INDEFINITE_PRONOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_interrogative_pronoun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, INTERROGATIVE_PRONOUN_LEMMAS, INTERROGATIVE_PRONOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_name_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, NAME_LEMMAS, NAME_POS)
    assert paradigms == tsv_snapshot_test


def test_noun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, NOUN_LEMMAS, NOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_ordinal_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, ORDINAL_LEMMAS, ORDINAL_POS)
    assert paradigms == tsv_snapshot_test


def test_possessive_pronoun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, POSSESSIVE_PRONOUN_LEMMAS, POSSESSIVE_PRONOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_personal_pronoun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, PERSONAL_PRONOUN_LEMMAS, PERSONAL_PRONOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_relative_pronoun_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, RELATIVE_PRONOUN_LEMMAS, RELATIVE_PRONOUN_POS)
    assert paradigms == tsv_snapshot_test


def test_verb_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, VERB_LEMMAS, VERB_POS)
    assert paradigms == tsv_snapshot_test
