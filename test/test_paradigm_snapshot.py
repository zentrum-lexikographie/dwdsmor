#!/usr/bin/env python3
# test_paradigm_snapshot.py
# test DWDSmor paradigm snapshots for regression
# Andreas Nolda 2024-09-24

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
                    "hell",      # Adj_0
                    "bunt",      # Adj_e
                    "neu",       # Adj_0, Adj_e
                    "warm",      # Adj_$
                    "kalt",      # Adj_$e
                    "dunkel",    # AdjPos-el, AdjComp-el, AdjSup
                    "bitter",    # AdjPos-er, AdjComp-er, AdjSup
                    "trocken",   # AdjPos-en, AdjComp-en, AdjSup
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

DEMONSTRATIVE_PRONOUN_LEMMAS = ["die",          # DemDef
                                "diese",        # Dem-dies
                                "solche",       # Dem-solch
                                "alldem",       # Dem-alldem
                                "jene",         # Dem
                                "dergleichen",  # Dem0
                                "diejenige"]    # ArtDef-der+DemMasc, ArtDef-den+DemMasc ...


FRACTION_POS = "FRAC"

FRACTION_LEMMAS = ["anderthalb"]  # Frac0


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
                             "etwas",         # IProNeut
                             "jemand",        # IProMasc
                             "jedermann",     # IPro-jedermann
                             "jedefrau",      # IPro-jedefrau
                             "man",           # IPro-man
                             "frau",          # IPro-frau
                             "unsereiner",    # IPro-unsereiner
                             "unsereins",     # IPro-unsereins
                             "wer",           # IProMascNomSg, IProMascAccSg, IProMascDatSg, IProMascGenSg
                             "was"]           # IProNeutNomSg, IProNeutAccSg, IProNeutDatSg, IProNeutGenSg


INTERROGATIVE_PRONOUN_POS = "WPRO"

INTERROGATIVE_PRONOUN_LEMMAS = ["wer",     # WProMascNomSg, WProMascAccSg, WProMascDatSg, WProMascGenSg, WProNeutNomSg ...
                                "was",     # WProMascNomSg, WProMascAccSg, WProMascDatSg, WProMascGenSg, WProNeutNomSg ...
                                "welche"]  # W-welch


NAME_POS = "NPROP"

NAME_LEMMAS = ["Atlantik",   # NameMasc_0, NameMasc_s
               "Andreas",    # NameMasc_apos
               "Rhein",      # NameMasc_es
               "Opa",        # NameMasc_s
               "Berlin",     # NameNeut_s
               "Ostsee",     # NameFem_0
               "Felicitas",  # NameFem_apos
               "Oma",        # NameFem_s
               "Alpen"]      # NameNoGend/Pl_x


NOUN_POS = "NN"

NOUN_LEMMAS = ["Jazz",           # NMasc/Sg_0
               "Kitsch",         # NMasc/Sg_es
               "Bau",            # NMasc/Sg_es, NMasc/Pl_x, NMasc_es_e
               "Adel",           # NMasc/Sg_s
               "Unglaube",       # NMasc/Sg_ns
               "Blues",          # NMasc_0_x
               "Dezember",       # NMasc_0_0, NMasc_s_0
               "Januar",         # NMasc_0_e, NMasc_s_e
               "Index",          # NMasc_0_e, NMasc_0_ex/izes, NMasc_es_e, NMasc_es_ex/izes
               "Obelisk",        # NMasc_0_e, NMasc_0_en, NMasc_s_e, NMasc_s_en, NMasc_en_en
               "Sandwich",       # NMasc_0_e, NMasc_0_es, NMasc_0_s, NMasc_es_e, NMasc_es_es, NMasc_es_s, NNeut_0_e, NNeut_0_es, NNeut_0_s, NNeut_es_e, NNeut_es_es, NNeut_es_s
               "Zirkus",         # NMasc_0_e~ss
               "Atlas",          # NMasc_0_e~ss, NMasc_es_e~ss, NMasc_0_as/anten, NMasc_s_as/anten
               "Globus",         # NMasc_0_e~ss, NMasc_es_e~ss, NMasc_0_us/en, NMasc_es_us/en~ss
               "Kaktus",         # NMasc_0_e~ss, NMasc_es_e~ss, NMasc_0_us/een, NMasc_es_us/een~ss
               "Embryo",         # NMasc_0_nen, NMasc_0_s, NMasc_s_nen, NMasc_s_s, NNeut_0_nen ...
               "Intercity",      # NMasc_0_s
               "Carabiniere",    # NMasc_0_e/i, NMasc_s_e/i
               "Espresso",       # NMasc_0_o/i, NMasc_0_s, NMasc_s_o/i, NMasc_s_s, NNeut_0_s, NNeut_s_x
               "Heros",          # NMasc_0_os/oen
               "Kustos",         # NMasc_0_os/oden
               "Topos",          # NMasc_0_os/oi
               "Virus",          # NMasc_0_us/en, NNeut_0_us/en
               "Rhythmus",       # NMasc_0_us/en~ss
               "Modus",          # NMasc_0_us/i
               "Dinosaurus",     # NMasc_0_us/ier
               "Larynx",         # NMasc_0_ynx/yngen
               "Freund",         # NMasc_es_e
               "Bus",            # NMasc_es_e~ss
               "Arzt",           # NMasc_es_$e
               "Block",          # NMasc_es_$e, NMasc_es_s
               "Leib",           # NMasc_es_er
               "Gott",           # NMasc_es_$er
               "Schmerz",        # NMasc_es_en
               "Crash",          # NMasc_es_es, NMasc_es_s
               "Tennismatch",    # NMasc_es_es, NMasc_es_s, NNeut_es_es ...
               "Daumen",         # NMasc_s_x
               "Ski",            # NMasc_s_x, NMasc_s_er
               "Garten",         # NMasc_s_$x
               "Engel",          # NMasc_s_0
               "Vize",           # NMasc_s_0, NMasc_s_s, NFem_0_0, NFem_0_s
               "Apfel",          # NMasc_s_$
               "Abend",          # NMasc_s_e
               "Unfall",         # NMasc_s_$e
               "Irrtum",         # NMasc_s_$er
               "Direktor",       # NMasc_s_en
               "Prototyp",       # NMasc_s_en, NMasc_en_en, NNeut_s_en
               "Muskel",         # NMasc_s_n
               "Opa",            # NMasc_s_s
               "Kanon",          # NMasc_s_s, NMasc_s_es
               "Dirigent",       # NMasc_en_en
               "Affe",           # NMasc_n_n
               "Junge",          # NMasc_n_n, NMasc-Adj, NNeut-Adj, NFem-Adj
               "Gedanke",        # NMasc_ns_n
               "Schade",         # NMasc_ns_$n
               "Deutsche",       # NMasc-Adj, NNeut-Adj/Sg, NFem-Adj
               "Abseits",        # NNeut/Sg_0
               "Ausland",        # NNeut/Sg_es
               "Verständnis",    # NNeut/Sg_es~ss
               "Internet",       # NNeut/Sg_s
               "Pluraletantum",  # NNeut/Sg_s, NNeut/Pl_x
               "Vieh",           # NNeut/Sg_es, NNeut/Pl_0
               "Ostern",         # NNeut_0_x
               "Remis",          # NNeut_0_x, NNeut_0_en
               "Zuhause",        # NNeut_0_0
               "Nichts",         # NNeut_0_e
               "Foyer",          # NNeut_0_s
               "Determinans",    # NNeut_0_ans/antien
               "Stimulans",      # NNeut_0_ans/anzien
               "Ricercare",      # NNeut_0_e/i, NNeut_s_e/i
               "Reagens",        # NNeut_0_ens/enzien
               "Intermezzo",     # NNeut_0_o/i, NNeut_0_s, NNeut_s_o/i, NNeut_s_s
               "Genus",          # NNeut_0_us/era
               "Tempus",         # NNeut_0_us/ora
               "Spiel",          # NNeut_es_e
               "Tablett",        # NNeut_es_e, NNeut_es_s
               "Zeugnis",        # NNeut_es_e~ss
               "Floß",           # NNeut_es_$e
               "Lied",           # NNeut_es_er
               "Buch",           # NNeut_es_$er
               "Ohr",            # NNeut_es_en
               "Indiz",          # NNeut_es_ien
               "Zeichen",        # NNeut_s_x
               "Examen",         # NNeut_s_x, NNeut_s_en/ina
               "Feuer",          # NNeut_s_0
               "Kloster",        # NNeut_s_$
               "Reflexiv",       # NNeut_s_a
               "Signal",         # NNeut_s_e
               "Auge",           # NNeut_s_n
               "Material",       # NNeut_s_ien
               "Sofa",           # NNeut_s_s
               "Komma",          # NNeut_s_s, NNeut_s_a/ata
               "Risiko",         # NNeut_s_s, NNeut_s_o/en
               "Dogma",          # NNeut_s_a/en
               "Paradoxon",      # NNeut_s_on/a
               "Stadion",        # NNeut_s_on/en
               "Maximum",        # NNeut_s_um/a
               "Museum",         # NNeut_s_um/en
               "Herz",           # NNeut_ens_en
               "Innere",         # NNeut-Inner
               "Ruhe",           # NFem/Sg_0
               "Anchorwoman",    # NFem/Sg_0, NFem/Pl_x
               "Jeans",          # NFem_0_x
               "Tochter",        # NFem_0_$
               "Milch",          # NFem_0_e, NFem_0_en
               "Kenntnis",       # NFem_0_e~ss
               "Wand",           # NFem_0_$e
               "Frau",           # NFem_0_en
               "Werkstatt",      # NFem_0_$en
               "Hilfe",          # NFem_0_n
               "Minestrone",     # NFem_0_n, NFem_0_e/i
               "Oma",            # NFem_0_s
               "Firma",          # NFem_0_a/en
               "Phalanx",        # NFem_0_anx/angen
               "Lex",            # NFem_0_ex/eges
               "Basis",          # NFem_0_is/en
               "Matrix",         # NFem_0_ix/izen
               "Radix",          # NFem_0_ix/izes
               "Freundin",       # NFem-in
               "Kosten",         # NNoGend/Pl_x
               "Leute"]          # NNoGend/Pl_0


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
                           "wer",     # RProMascNomSg, RProMascAccSg, RProMascDatSg, RProMascGenSg, RProNeutNomSg ...
                           "was",     # RProMascNomSg, RProMascAccSg, RProMascDatSg, RProMascGenSg, RProNeutNomSg ...
                           "welche"]  # Rel-welch


VERB_POS = "V"

VERB_LEMMAS = ["spielen",     # VWeak
               "segeln",      # VWeak-el-er
               "recyclen",    # VWeak-len
               "arbeiten",    # VWeak-d-t
               "atmen",       # VWeak-m-n
               "küssen",      # VWeak-s
               "heißen",      # VWeak-s, VInf, VPPres, VPPastStr, VPres-s, VPastStr-s, VImp
               "senden",      # VWeak-d-t, VInf, VPPres, VPPast-d_t, VPres, VPastInd-d-t_t, VPastSubjWeak, VImp-d-t
               "notwassern",  # VInf-el-er, VPPres-el-er, VPPastWeak, VPres-el-er, VPastIndWeak, VPastSubjWeak, VImp-el-er
               "downcyclen",  # VInf-len, VPPres-len, VPPast-len, VPres-len, VPastInd-len, VPastSubj-len, VImp-len
               "denken",      # VInf, VPPres, VPPastWeak, VPres, VPastIndWeak, VPastSubjWeak, VImp
               "haben",       # VInf, VPPres, VPPastWeak, VPresInd23Sg, VPresNonInd23Sg, VPastInd-d-t_t, VPastSubj-haben, VImp
               "wissen",      # VInf, VPPres, VPPastWeak, VModPresIndSg, VModPresNonIndSg, VPastIndWeak, VPastSubjWeak
               "können",      # VInf, VPPres, VPPastWeak, VPPastStr, VModPresIndSg, VModPresNonIndSg, VPastIndWeak, VPastSubjWeak
               "gehen",       # VInf, VPPres, VPPastStr, VPres, VPastStr, VImp
               "schwimmen",   # VInf, VPPres, VPPastStr, VPres, VPastIndStr, VPastSubjStr, VPastSubjOld, VImp
               "laden",       # VInf, VPPres, VPPastStr, VPres, VPresInd23Sg-d_t, VPresNonInd23Sg, VPastIndStr, VPastSubjStr, VImp, VImp-d-t
               "laufen",      # VInf, VPPres, VPPastStr, VPresInd23Sg, VPresNonInd23Sg, VPastStr, VImp
               "halten",      # VInf, VPPres, VPPastStr, VPresInd23Sg-t_0, VPresNonInd23Sg, VPastStr, VImp-d-t
               "sehen",       # VInf, VPPres, VPPastStr, VPresInd23Sg, VPresNonInd23Sg, VPastIndStr, VPastSubjStr, VImpSg, VImpPl
               "lesen",       # VInf, VPPres, VPPastStr, VPresInd23Sg, VPresNonInd23Sg, VPastIndStr-s, VPastSubjStr, VImpSg0, VImpPl
               "tun",         # VInf_n, VPPres, VPPast_n, VPres-tun, VPastIndStr, VPastSubjStr, VImpSg0, VImpPl
               "werden",      # VInf, VPPres, VPPastStr, VPresInd2Sg-werden, VPresInd3Sg-werden, VPresNonInd23Sg, VPastInd-werden,
                              # VPastIndSg-ward, VPastIndPl-werden, VPastSubjStr, VImp-d-t
               "sein"]        # VInf_n, VPPres, VPPastStr, VPresInd1Sg-sein, VPresInd2Sg-sein, VPresInd3Sg-sein, VPresInd13Pl-sein,
                              # VPresInd2Pl-sein, VPresSubj-sein, VPastIndStr, VPastSubjStr, VPastSubj2-sein, VImpSg0, VImpPl-sein

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


def test_fraction_paradigm_snapshot(tsv_snapshot_test, transducer):
    paradigms = get_paradigms(transducer, FRACTION_LEMMAS, FRACTION_POS)
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
