#!/usr/bin/env python3
# test_paradigm_snapshot.py
# test DWDSmor paradigm snapshots for regression
# Andreas Nolda 2024-11-19

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
                    "klasse",    # AdjPos0-e
                    "tabu",      # AdjPosPred
                    "pleite",    # AdjPosPred-e
                    "Berliner",  # AdjPosAttrSubst0
                    "derartig",  # AdjPos
                    "hell",      # Adj_er_st
                    "bunt",      # Adj_er_est
                    "neu",       # Adj_er_st, Adj_er_est
                    "warm",      # Adj_er_$st
                    "kalt",      # Adj_er_$est
                    "leise",     # AdjPos-e, AdjComp_er, AdjSup_est
                    "dunkel",    # AdjPos-el, AdjComp-el_er, AdjSup_st
                    "bitter",    # AdjPos-er, AdjComp-er_er, AdjSup_st
                    "trocken",   # AdjPos-en, AdjComp-en_er, AdjSup_st
                    "gut",       # AdjPos, AdjComp_er, AdjSup_st
                    "viel",      # AdjPos, AdjPos0-viel, AdjComp0, AdjSup_st
                    "hoch",      # AdjPosPred, AdjPosAttr, AdjComp_er, AdjSup_st
                    "fit"]       # AdjPosPred, AdjPosAttr, AdjComp_er, AdjSup_est


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
               "Alpen"]      # NameUnmGend|Pl_0


NOUN_POS = "NN"

NOUN_LEMMAS = ["Jazz",           # NMasc|Sg_0
               "Kitsch",         # NMasc|Sg_es
               "Bau",            # NMasc|Sg_es, NMasc|Pl_0, NMasc_es_e_n
               "Adel",           # NMasc|Sg_s
               "Unglaube",       # NMasc|Sg_ns
               "Blues",          # NMasc_0_0_0
               "Gravis",         # NMasc_0_0_0, NMasc_0_is/es_0
               "Dezember",       # NMasc_0_0_n, NMasc_s_0_n
               "Januar",         # NMasc_0_e_n, NMasc_s_e_n
               "Index",          # NMasc_0_e_n, NMasc_0_ex/izes_0, NMasc_es_e_n, NMasc_es_ex/izes_0
               "Appendix",       # NMasc_0_e_n, NMasc_0_ix/izes_0, NMasc_es_e_n, NMasc_es_ix/izes_0, NFem_0_ix/izes_0 ...
               "Obelisk",        # NMasc_0_e_n, NMasc_0_en_0, NMasc_s_e_n, NMasc_s_en_0, NMasc_en_en_0
               "Sandwich",       # NMasc_0_e_n, NMasc_0_es_0, NMasc_0_s_0, NMasc_es_e_n, NMasc_es_es_0, NMasc_es_s_0, NNeut_0_e_n ...
               "Zirkus",         # NMasc_0_e_n~ss
               "Atlas",          # NMasc_0_e_n~ss, NMasc_es_e_n~ss, NMasc_0_as/anten_0, NMasc_s_as/anten_0
               "Globus",         # NMasc_0_e_n~ss, NMasc_es_e_n~ss, NMasc_0_us/en_0, NMasc_es_us/en_0~ss
               "Kaktus",         # NMasc_0_e_n~ss, NMasc_es_e_n~ss, NMasc_0_us/een_0, NMasc_es_us/een_0~ss
               "Embryo",         # NMasc_0_nen_0, NMasc_0_s_0, NMasc_s_nen_0, NMasc_s_s_0, NNeut_0_nen_0 ...
               "Intercity",      # NMasc_0_s_0
               "Signor",         # NMasc_0_i_0
               "Veda",           # NMasc_0_a/en_0, NMasc_s_a/en_0, NMasc_0_s_0, NMasc_s_s_0
               "Carabiniere",    # NMasc_0_e/i_0, NMasc_s_e/i_0
               "Dens",           # NMasc_0_ens/entes_0
               "Präses",         # NMasc_0_es/iden_0, NMasc_0_es/ides_0
               "Taxi",           # NMasc_0_i/en_0, NMasc_s_i/en_0, NMasc_0_s_0, NMasc_s_s_0, NNeut_0_i/en_0 ...
               "Espresso",       # NMasc_0_o/i_0, NMasc_0_s_0, NMasc_s_o/i_0, NMasc_s_s_0, NNeut_0_s_0 ...
               "Mythos",         # NMasc_0_os/en_0
               "Heros",          # NMasc_0_os/oen_0
               "Kustos",         # NMasc_0_os/oden_0
               "Topos",          # NMasc_0_os/oi_0
               "Virus",          # NMasc_0_us/en_0, NNeut_0_us/en_0
               "Rhythmus",       # NMasc_0_us/en_0~ss
               "Modus",          # NMasc_0_us/i_0
               "Dinosaurus",     # NMasc_0_us/ier_n
               "Larynx",         # NMasc_0_ynx/yngen_0
               "Freund",         # NMasc_es_e_n
               "Bus",            # NMasc_es_e_n~ss
               "Arzt",           # NMasc_es_$e_n
               "Block",          # NMasc_es_$e_n, NMasc_es_s_0
               "Leib",           # NMasc_es_er_n
               "Gott",           # NMasc_es_$er_n
               "Schmerz",        # NMasc_es_en_0
               "Crash",          # NMasc_es_es_0, NMasc_es_s_0
               "Tennismatch",    # NMasc_es_es_0, NMasc_es_s_0, NNeut_es_es_0 ...
               "Daumen",         # NMasc_s_0_0
               "Ski",            # NMasc_s_0_0, NMasc_s_er_n
               "Garten",         # NMasc_s_$_0
               "Engel",          # NMasc_s_0_n
               "Vize",           # NMasc_s_0_n, NMasc_s_s_n, NFem_0_0_n ...
               "Apfel",          # NMasc_s_$_n
               "Abend",          # NMasc_s_e_n
               "Unfall",         # NMasc_s_$e_n
               "Irrtum",         # NMasc_s_$er_n
               "Direktor",       # NMasc_s_en_0
               "Prototyp",       # NMasc_s_en_0, NMasc_en_en_0, NNeut_s_en_0
               "Muskel",         # NMasc_s_n_0
               "Opa",            # NMasc_s_s_0
               "Kanon",          # NMasc_s_s_0, NMasc_s_es_0
               "Versal",         # NMasc_s_ien_0
               "Pater",          # NMasc_s_er/res_0
               "Dirigent",       # NMasc_en_en_0
               "Affe",           # NMasc_n_n_0
               "Junge",          # NMasc_n_n_0, NMasc_n_ns_0, NMasc_n_e/s_0, NMasc-Adj, NNeut-Adj, NFem-Adj
               "Gedanke",        # NMasc_ns_n_0
               "Schade",         # NMasc_ns_$n_0
               "Deutsche",       # NMasc-Adj, NNeut-Adj|Sg, NFem-Adj
               "Abseits",        # NNeut|Sg_0
               "Ausland",        # NNeut|Sg_es
               "Verständnis",    # NNeut|Sg_es~ss
               "Internet",       # NNeut|Sg_s
               "Pluraletantum",  # NNeut|Sg_s, NNeut|Pl_0
               "Vieh",           # NNeut|Sg_es, NNeut|Pl_n
               "Ostern",         # NNeut_0_0_0
               "Remis",          # NNeut_0_0_0, NNeut_0_en_0
               "Zuhause",        # NNeut_0_0_n
               "Nichts",         # NNeut_0_e_n
               "Simplex",        # NNeut_0_e_n, NNeut_0_ex/izia_0, NNeut_es_e_n, NNeut_es_ex/izia_0
               "Foyer",          # NNeut_0_s_0
               "Determinans",    # NNeut_0_ans/antien_0
               "Stimulans",      # NNeut_0_ans/anzien_0
               "Ricercare",      # NNeut_0_e/i_0, NNeut_s_e/i_0
               "Akzidens",       # NNeut_0_ens/entia_0, NNeut_0_ens/entien_0, NNeut_0_ens/enzien_0
               "Intermezzo",     # NNeut_0_o/i_0, NNeut_0_s_0, NNeut_s_o/i_0, NNeut_s_s_0
               "Epos",           # NNeut_0_os/en_0
               "Genus",          # NNeut_0_us/era_0
               "Tempus",         # NNeut_0_us/ora_0
               "Spiel",          # NNeut_es_e_n
               "Tablett",        # NNeut_es_e_n, NNeut_es_s_0
               "Zeugnis",        # NNeut_es_e_n~ss
               "Floß",           # NNeut_es_$e_n
               "Lied",           # NNeut_es_er_n
               "Buch",           # NNeut_es_$er_n
               "Ohr",            # NNeut_es_en_0
               "Indiz",          # NNeut_es_ien_0
               "Zeichen",        # NNeut_s_0_0
               "Examen",         # NNeut_s_0_0, NNeut_s_en/ina_0
               "Feuer",          # NNeut_s_0_n
               "Kloster",        # NNeut_s_$_n
               "Reflexiv",       # NNeut_s_a_0
               "Signal",         # NNeut_s_e_n
               "Auge",           # NNeut_s_n_0
               "Material",       # NNeut_s_ien_0
               "Sofa",           # NNeut_s_s_0
               "Komma",          # NNeut_s_s_0, NNeut_s_a/ata_0
               "Risiko",         # NNeut_s_s_0, NNeut_s_o/en_0
               "Dogma",          # NNeut_s_a/en_0
               "Numerale",       # NNeut_s_e/ia_0, NNeut_s_e/ien_0
               "Paradoxon",      # NNeut_s_on/a_0
               "Stadion",        # NNeut_s_on/en_0
               "Maximum",        # NNeut_s_um/a_0
               "Museum",         # NNeut_s_um/en_0
               "Herz",           # NNeut_ens_en_0
               "Innere",         # NNeut-Inner
               "Ruhe",           # NFem|Sg_0
               "Anchorwoman",    # NFem|Sg_0, NFem|Pl_0
               "Jeans",          # NFem_0_0_0
               "Spezies",        # NFem_0_0_0, NFem_0_es/en_0
               "Tochter",        # NFem_0_$_n
               "Milch",          # NFem_0_e_n, NFem_0_en_0
               "Kenntnis",       # NFem_0_e_n~ss
               "Wand",           # NFem_0_$e_n
               "Frau",           # NFem_0_en_0
               "Werkstatt",      # NFem_0_$en_0
               "Hilfe",          # NFem_0_n_0
               "Minestrone",     # NFem_0_n_0, NFem_0_e/i_0
               "Oma",            # NFem_0_s_0
               "Pizza",          # NFem_0_s_0, NFem_0_a/e_0, NFem_0_a/en_0
               "Vigil",          # NFem_0_ien_0
               "Laudatio",       # NFem_0_nes_0
               "Spirans",        # NFem_0_ans/anten_0
               "Phalanx",        # NFem_0_anx/angen_0
               "Lex",            # NFem_0_ex/eges_0
               "Basis",          # NFem_0_is/en_0
               "Apsis",          # NFem_0_is/iden_0
               "Glottis",        # NFem_0_is/ides_0
               "Helix",          # NFem_0_ix/ices_0
               "Matrix",         # NFem_0_ix/izen_0
               "Radix",          # NFem_0_ix/izes_0
               "Dos",            # NFem_0_os/otes_0
               "Vox",            # NFem_0_ox/oces_0
               "Freundin",       # NFem-in
               "Kosten",         # NUnmGend|Pl_0
               "Leute"]          # NUnmGend|Pl_n


ORDINAL_POS = "ORD"

ORDINAL_LEMMAS = ["erste"]  # Ord


POSSESSIVE_PRONOUN_POS = "POSS"

POSSESSIVE_PRONOUN_LEMMAS = ["meine",    # Poss
                             "unsere",   # Poss-er
                             "Deinige",  # Poss|Wk
                             "Eurige"]   # Poss|Wk-er


PERSONAL_PRONOUN_POS = "PPRO"

PERSONAL_PRONOUN_LEMMAS = ["ich",       # PPro1NomSg, PPro1AccSg, PPro1DatSg, PPro1GenSg
                           "du",        # PPro2NomSg, PPro2AccSg, PPro2DatSg, PPro2GenSg
                           "er",        # PProMascNomSg, PProMascAccSg, PProMascDatSg, PProMascGenSg
                           "es",        # PProNeutNomSg, PProNeutAccSg, PProNeutDatSg, PProNeutGenSg, PProNeutNomSg-s, PProNeutAccSg-s

                           "wir",       # PPro1NomPl, PPro1AccPl, PPro1DatPl, PPro1GenPl
                           "ihr",       # PPro2NomPl, PPro2AccPl, PPro2DatPl, PPro2GenPl
                           "sie",       # PProFemNomSg, PProFemAccSg, PProFemDatSg, PProFemGenSg, PProUnmGendNomPl ...

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
               "recyclen",    # VWeak-le
               "liken",       # VWeak-ak-ik
               "designen",    # VWeak-signen
               "arbeiten",    # VWeak-d-t
               "atmen",       # VWeak-m-n
               "küssen",      # VWeak-s
               "heißen",      # VWeak-s, VInf, VPPres, VPPastStr, VPres-s, VPastStr-s, VImp
               "senden",      # VWeak-d-t, VInf, VPPres, VPPast-d_t, VPres, VPastInd-d-t_t, VPastSubjWeak, VImp-d-t
               "faken",       # VWeak-ak-ik, VInf, VPPres, VPPast_ed, VPres-ak-ik, VPastIndWeak, VPastSubjWeak, VImp-ak-ik
               "notwassern",  # VInf-el-er, VPPres-el-er, VPPastWeak, VPres-el-er, VPastIndWeak, VPastSubjWeak, VImp-el-er
               "downcyclen",  # VInf-le, VPPres-le, VPPast-le, VPres-le, VPastInd-le, VPastSubj-le, VImp-le
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
