This file logs the changes in FST files, starting from the DSDSmor fork.

2022-11-21:

* restore original SMOR processing of category and stem-type features

2022-11-17:

* add initial support for compounding

2022-11-14:

* add `num.fst`
* add `punct.fst`
* add inflection classes `NNeut-on/en` and `NFem_0_$en`

2022-11-11:

* add inflection classes `NMasc_s_er`, `NMasc_s_$er`, and `NNeut_s_$er`

2022-11-08:

* add inflection classes `NMasc_es_es`, `NNeut_es_es`, and `NFem_0_es`

2022-09-22:

* add inflection class `AdjPos0-viel`
* rename inflection class `AdjComp0` to `AdjComp0-mehr`

2022-09-21:

* replace `<Pred>` and `<Adv>` with `<Pred/Adv>`
* add `<Attr/Subst>` to attributive categorisations of adjectives

2022-09-20:

* rename inflection class `Adj0` to `AdjPos0`
* rename inflection class `Adj0-Up` to `AdjPos0Attr-Up`,
* add predicative categorisation to `AdjPos0` and `AdjComp0`
* add inflection classes `AdjPos0Attr` and `AdjSup-aller`
* remove inflection classes `Adj&` and `AdjPosSup`

2022-09-09:

* allow for genitive e-elision after diphthongs "ai" and "ei"

2022-09-08:

* set `$LEX$` to `DWDS.lex` in `dwdsmor-minimal.fst`
* set `$LEX$` to `DWDS.lex | aux.lex` in `dwdsmor-index.fst`
* add `dwdsmor.fst` with `$LEX$` set to `DWDS.lex | DWDS-Red2.lex | aux.lex`

2022-09-06:

* rewrite umlaut rule for umlaut after vowel in unsegmented lexical entries

2022-09-05:

* add inflection classes `NMasc_0_nen`, `NNeut_0_nen`, `NMasc_s_nen`, and
  `NNeut_s_nen`
* rename inflection class `NNeut-0/ien` to `NNeut_s_ien`

2022-09-01:

* add inflection classes `NMasc_es_s` and `NNeut_es_s`
* fix inflection class `NFem-s/sse`

2022-08-31:

* replace inflection classes `PProReflFemSg`, `PProReflMascSg`,
  `PProReflNeutSg`, and `PProReflNoGendPl` with `PRefl1AccSg`, `PRefl1DatSg`,
  `PRefl2AccSg`, `PRefl2DatSg`, `PRefl1Pl`, `PRefl2Pl`, and `PRefl3`

2022-08-29:

* rename inflection classes `Card`, `Indef-jedermann`, `Indef-man`, `IndefMasc`,
  and `WPro-welch` to `Card0`, `IPro-jedermann`, `IPro-man`, `IProMasc`, and
  `W-welch`, respectively
* add inflection classes `Card-zwei`, `Card-vier`, `Card-sieben`, `Indef0`,
  `Indef-beid`, `Indef-irgendein`, `Indef-irgendwelch`, `Indef-manch`,
  `IProMascNomSg`, `IProMascAccSg`, `IProMascGenSg`, `IProMascDatSg`,
  `IProNeutNomSg`, `IProNeutAccSg`, `IProNeutDatSg`, and `IProNeutGenSg`

2022-08-24:

* add inflection classes `NMasc-as/anten`, `NMasc-as0/anten`, `NMasc-us0/i`,
  `NMasc-us0/en`, and `NNeut-us0/en`
* remove support for post-verbal clitic "'s"

2022-08-19:

* rename `smor-minimal.fst` and `smor-index.fst` to `dwdsmor-minimal.fst` and
  `dwdsmor-index.fst`, respectively
* allow for imperative forms of particle verbs in `dwdsmor-index.fst`, but not
  in `dwdsmor-minimal.fst`

2022-08-17:

* add support for auxiliary tags `<haben>` and `<sein>`

2022-08-16:

* simplify lemmatiser for indexed lemmata

2022-08-15:

* add inflection classes for "alle", "jede", "jegliche", "jedermann", "man",
  "sämtliche", "einige", and "mehrere"

2022-08-12:

* add lemmas for attributive-only adjectives
* add support for typographic apostrophe
* do not include `PRO.fst`

2022-08-11:

* add inflection classes for reflexive pronouns
* add support for clitic forms of personal pronouns
* add support for archaic genitive forms of personal pronouns and interrogative
  pronouns

2022-08-10:

* add inflection classes for personal pronouns, and interrogative pronouns
* add inflection classes for "solche" and "welche"
* add inflection classes for "jemand" and "etwas"

2022-08-03:

* add inflection class `Abk_POSS`

2022-07-08:

* add some inflection classes for articles, pronouns, and numerals

2022-07-04:

* add disjunctive feature `<SW>` where missing

2022-06-28:

* do not remove boundary between verb particle and base verb for particle verbs
  specified in the lexicon

2022-06-27:

* replace non-disjunctive feature `<St/Wk>` with disjunctive feature `<SW>`,
  which is expanded to features `<St>` and `<Wk>`
* add `smor-index.fst`, a minimal grammar for inflection with indexed lemmata
* revert phonological rule `R9A` (formerly `R11`)

2022-06-24:

* add `smor-minimal.fst`, a minimal grammar for inflection with the
  lemmatization from `morph-lemma.fst`

2022-06-21:

* add inflection classes `Name-Masc_apos`, `Name-Neut_apos`, and `Name-Fem_apos`

2022-05-17:

* add inflection class `NNeut/Sg_sses`

2022-05-11:

* add classes `AdvComp`, `AdvComp0`, and `AdvSup` for adverbs with comparative
  and superlative forms

2022-04-20:

* add inflection class `Adj~$e` for adjectives with comparative and superlative
  forms with "ß"/"ss"-alternation and umlaut
* remove support for deriving new spellings from old spellings

2022-04-19:

* re-enable support for old spellings

2022-04-11:

* add inflection class `AdjPos-Up` for positive adjectives with capitalised
  first member

2022-04-01:

* add inflection classes `VAPres1/3SgKonj` and `VAPres2SgKonj` for "sei" and
  "seist"/"seiest", respectively

2022-03-31:

* add inflection class `VPastIndIrreg` for indicative verb forms with past-tense
  endings without "-t-"
* add inflection classes `VAPastIndSg` and `VAPastIndPl` for archaic
  "ward"/"wardst" and "wurden"/"wurdest", respectively

2022-03-30:

* add inflection classes `VInf-en` and `VInf-n` for infinitives with marked
  boundaries

2022-03-28:

* substitute disjunctive feature `MFN` for `NoGend` for singular adjectival forms
* add "-en" to superlative suffix of adjectival forms of categories `Pred` and `Adv`

2022-03-22:

* add inflection classes `Name-Masc_es` and `Name-Neut_es`

2022-03-02:

* add inflection class `AdjComp0` for uninflected comparative forms

2022-02-28:

* rename helper class `NFem/Sg` to `NFem/Sg_0`
* rename helper classes `NMasc/Pl`, `NFem/Pl`, and `NNeut/Pl` to `NMasc/Pl_x`,
  `NFem/Pl_x`, and `NNeut/Pl_x`, respectively
* add helper class `NMasc/Pl_0`
* add inflection class `NMasc-us/e`

2022-02-24:

* add inflection classes `NMasc-o/en`, `NNeut-o/en`, `NMasc-o/i`, and
  `NNeut-o/i`

2022-02-23:

* replace inflection class `NNeut/Sg_en` with `NNeut-Adj/Sg` for neuter
  nominalised adjectives with singular forms only

2022-02-22:

* add inflection classes `NMasc_0_s` and `NNeut_0_s`
* add inflection class `NNeut-en/ina`

2022-02-21:

* supplement the inflection class `NMasc-Adj` for masculine nominalised
  adjectives by the inflection classes `NFem-Adj` and `NNeut-Adj` for feminine
  and neuter nominalised adjectives, respectively, in order to be able to
  include such words into the lexicon independently of their adjectival bases
* use weak nominative singular form of nominalised adjectives as their lemma
