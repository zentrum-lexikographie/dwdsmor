This file logs the changes in FST files, starting from the DSDSmor fork.

2024-08-29:

* add inflection classes `VPPast-senden`, `VPres-tun`, `VPresInd23Sg-laden`,
  `VPresInd2Sg-werden`, `VPresInd3Sg-werden`, `VPastInd-haben`,
  `VPastSubj-haben`, `VImp`, `VImpSg`, `VImpSg0`, and `VImpPl`
* rename inflection classes `VInf-en`, `VInf-n`, `VVPP-t`, `VVPP-en`, `VPPast`,
  `VVReg`, `VVReg-el-er`, `VAPresSubjSg`, `VVPres`, `VVPres1`, `VVPres2`,
  `VVPres2t`, `VMPresSg`, `VMPresPl`, `VVPastStr`, `VVPastIndReg`,
  `VVPastIndStr`, `VPastIndIrreg`, `VVPastSubjReg`, `VVPastSubjStr`,
  `VVPastSubjOld`, `VAPres1SgInd`, `VAPres2SgInd`, `VAPres3SgInd`,
  `VAPres13PlInd`, `VAPres2PlInd`, `VAPres2SgSubj`, `VAPastIndSg`,
  `VAPastIndPl`, `VAPastSubj2`, and `VAImpPl` to `VInf`, `VInf_n`, `VPPastWeak`,
  `VPPastStr`, `VPPast-tun`, `VWeak`, `VWeak-el-er`, `VPresSubj-sein`, `VPres`,
  `VPresNonInd23Sg`, `VPresInd23Sg`, `VPresInd23Sg-t`, `VModPresIndSg`,
  `VModPresNonIndSg`, `VPastStr`, `VPastIndWeak`, `VPastIndStr`,
  `VPastInd-werd`, `VPastSubjWeak`, `VPastSubjStr`, `VPastSubjOld`,
  `VPresInd1Sg-sein`, `VPresInd2Sg-sein`, `VPresInd3Sg-sein`,
  `VPresInd13Pl-sein`, `VPresInd2Pl-sein`, `VAPresSubj2Sg`, `VPastIndSg-ward`,
  `VPastIndPl-werden`, `VPastSubj2-sein`, and `VImpPl-sein`, respectively
* remove inflection classes `VInf`, `VVPres1_Imp`, `VVPres2_Imp`,
  `VVPres2_Imp0`, `VVPres2t_Imp0`, `VPresSubj`, `VAPresSubj2Sg`,
  `VAPresSubjPl>`, `VPastIndReg`, `VMPast`, `VMPastSubj`, and `VAImpSg`

2024-08-22:

* add inflection classes `IPro-frau`, `IPro-jedefrau`, `IPro-jederfrau`,
  `RProMascAccSg`, `RProMascDatSg`, `RProMascGenSg`, `RProMascNomSg`,
  `RProNeutAccSg`, `RProNeutDatSg`, `RProNeutGenSg`, and `RProNeutNomSg`

2024-07-26:

* refactor processing of stem boundaries and morphophonological triggers
* rename phonological triggers `UL`, `INS-E`, `^Del`, `^Ax`, `^Px`, `^Gen`, and
  `^pl` to `uml`, `ins(e)`, `del(e)` , `del(e)|ADJ`, `del(e)|PRO`, `del(e)|Gen`,
  and `del(VC)|Pl`, respectively
* rename morphological triggers `^pp`, `^zz`, and `^imp` to `ins(ge)`,
  `ins(zu)`, and `rm|Imp`, respectively
* change inflection classes `NMasc-Adj`, `NNeut-Adj`, `NNeut-Adj/Sg`, `NFem-Adj`
  as to apply to the adjectival stem of nominalised adjectives (without final "e")
* remove unused inflection classes `VAPres13SgSubj`, `VInf_PPres`, `VVPresPl`,
  `VVPresSg`, and `VVRegFin`
* improve rule for old "ß" spelling

2024-07-25:

* add support for verbs mit double particles
* add alternate 2 Sg Ind Past suffix to `VPastIndStr` inflection class

2024-07-24:

* add inflection classes `NMasc_0_os/oen`, `NMasc_0_os/oden`, `NMasc_0_os/oi`,
  `NNeut_0_ans/antien`, and `NNeut_s_a`
* remove inflection class `NMasc_es_ten`
* restore inflection class `NNeut/Pl_x`

2024-07-23:

* restore inflection classes `NMasc/Pl_x` and `NFem/Pl_x`

2024-07-22:

* add inflection classes `NMasc_0_o/en`, `NNeut_0_a/ata`, `NNeut_0_a/en`,
  `NNeut_0_en/ina`, `NNeut_0_o/en`, `NNeut_0_on/a`, `NNeut_0_on/en`,
  `NNeut_0_um/a`, and `NNeut_0_um/en`

2024-07-19:

* add inflection class `NNeut/Pl_0`
* add inflection classes `NMasc_0_ynx/yngen`, `NNeut_0_ans/anzien`,
  `NFem_0_anx/angen`, `NFem_0_ex/eges`, and `NFem_0_ix/izes`
* rename inflection class `NNeut_0_s/zien` to `NNeut_0_ens/enzien`

2024-07-18:

* rename and reorder phonological rules

2024-07-17:

* add inflection class `NMasc_ns_$n`

2024-07-16:

* add support for more characters
* classify "y" as vowel

2024-07-15:

* remove unused inflection classes `NMasc/Pl_0`, `NMasc/Pl_x`, `NNeut/Pl_x`, and
  `NFem/Pl_x`
* add inflection classes `NMasc_es_ten` and `NFem_0_ix/izen`

2024-07-02:

* add inflection classes `NMasc_0_us/een`, `NMasc_es_us/een~ss`,
  `NMasc_0_us/ier`, `NMasc_s_es`, `NNeut_0_us/era`, `NNeut_0_us/ora`, and
  `NNeut_0_s/zien`

2024-07-01:

* rename inflection classes `NMasc-Name` and `NNeut-Herz` to `NMasc_ns_n` and
  `NNeut_ens_en`, respectively
* add inflection class `NMasc/Sg_ns`

2024-06-27:

* add inflection classes `NMasc_0_ex/izes`, `NMasc_es_ex/izes`, `NMasc_0_en`,
  `NMasc_0_es`, `NMasc_0_o/i`, `NNeut_0_en`, `NNeut_0_es`, and `NNeut_0_o/i`

2024-06-26:

* rename inflection classes `NMasc-ns`, `NMasc-as/anten`, `NMasc-as0/anten`,
  `NMasc-o/en`, `NMasc-o/i`, `NMasc-us/e`, `NMasc-us/en`, `NMasc-us/i`,
  `NMasc-us0/en`, `NMasc-us0/en`, `NMasc-us0/i`, `NNeut-a/ata`, `NNeut-a/en`,
  `NNeut-en/ina`, `NNeut-o/en`, `NNeut-o/i`, `NNeut-on/a`, `NNeut-on/en`,
  `NNeut-um/a`, `NNeut-um/en`, `NNeut-us0/en`, `NNeut-us0/en`, `NFem-a/en`,
  `NFem-is/en`, and `NFem-is/iden` to `NMasc-Name`, `NMasc_es_as/anten~ss`,
  `NMasc_0_as/anten`, `NMasc_s_o/en`, `NMasc_s_o/i`, `NMasc_0_us/e`,
  `NMasc_es_us/en~ss`, `NMasc_es_us/i~ss`, `NMasc_0_us/en`, `NMasc_0_us/en`,
  `NMasc_0_us/i`, `NNeut_s_a/ata`, `NNeut_s_a/en`, `NNeut_s_en/ina`,
  `NNeut_s_o/en`, `NNeut_s_o/i`, `NNeut_s_on/a`, `NNeut_s_on/en`,
  `NNeut_s_um/a`, `NNeut_s_um/en`, `NNeut_0_us/en`, `NNeut_0_us/en`,
  `NFem_0_a/en`, `NFem_0_is/en`, `NFem_0_is/iden`, respectively
* add inflection classes `<NMasc_0_e/i>`, `<NMasc_s_e/i>`, `<NNeut_0_e/i>`,
  `<NNeut_s_e/i>`, and `<NFem_0_e/i>`

2024-03-22:

* also generate comparative and superlative forms for converted participles

2024-03-21:

* rename inflection class `Adj-el-er_$` to `Adj-el_$`
* replace inflection class `Adj-el-er_0` with inflection classes `Adj-el_0` and
  `Adj-er_0`
* add inflection classes `Adj-en_0`, `AdjPosAttr-er`, and `AdjSupAttr`

2024-03-19:

* make rule for old "ß" spelling more general

2024-03-18:

* remove unused inflection class `Circp` (using `Postp` instead)

2024-03-15:

* replace `<FB>` (inflection boundary) by `<PB>` (inflection boundary after
  prefix) and/or `<SB>` (inflection boundary before suffix)
* restrict phonological rule `R5` ("e"-elision before "e") to `e<SB>e` instead
  of `e<FB>e`, which erroneously also triggered "e"-elision in "ge" prefixes

2024-03-13:

* add support for more symbols and punctuation marks

2023-11-30:

* add inflection class `Dem0` for demonstrative pronouns "dergleichen" and
  "derlei"
* add inflection classes `ArtDef-das+DemNeut`, `ArtDef-dem+DemMasc`,
  `ArtDef-dem+DemNeut`, `ArtDef-den+DemMasc`, `ArtDef-den+DemNoGend`,
  `ArtDef-der+DemFem`, `ArtDef-der+DemMasc`, `ArtDef-der+DemNoGend`,
  `ArtDef-des+DemMasc`, `ArtDef-des+DemNeut`, `ArtDef-die+DemFem`, and
  `ArtDef-die+DemNoGend` for demonstrative pronouns "diejenige" and "dieselbe"
* rename inflection class `Frac` to `Frac0`

2023-11-29:

* rename inflection classes `Name-Masc_0`, `Name-Masc_apos`, `Name-Masc_es`,
  `Name-Masc_s`, `Name-Neut_0`, `Name-Neut_apos`, `Name-Neut_es`, `Name-Neut_s`,
  `Name-Fem_0`, `Name-Fem_apos`, `Name-Fem_s`, `Name-Pl_x`, `Name-Pl_0`,
  `FamName_0`, and `FamName_s` to `NameMasc_0`, `NameMasc_apos`, `NameMasc_es`,
  `NameMasc_s`, `NameNeut_0`, `NameNeut_apos`, `NameNeut_es`, `NameNeut_s`,
  `NameFem_0`, `NameFem_apos`, `NameFem_s`, `NameNoGend/Pl_x`,
  `NameNoGend/Pl_0`, `Name-Fam_0`, and `Name-Fam_s`, respectively
* rename inflection classes `Adj+`, `Adj+e`, `Adj$`, `Adj$e`, `Adj-el/er`,
  `Adj$-el/er`, and `Adj+Lang` to `Adj_0`, `Adj_e`, `Adj_$`, `Adj_$e`,
  `Adj-el-er_0`, `Adj-el-er_$`, and `Adj-Lang`, respectively
* rename inflection classes `VAPres1/3PlInd`, `$VAPres1/3SgSubj$`, `VInf+PPres`,
  `VVPres1+Imp`, `VVPres2+Imp`, `VVPres2+Imp0`, `VVPres2t+Imp0`, and
  `VVReg-el/er` to `VAPres13PlInd`, `$VAPres13SgSubj$`, `VInf_PPres`,
  `VVPres1_Imp`, `VVPres2_Imp`, `VVPres2_Imp0`, `VVPres2t_Imp0`, and
  `VVReg-el-er`, respectively
* rename inflection classes `Conj-Inf`, `Conj-Coord`, `Conj-Sub`, `Conj-Compar`,
  `PInd-Invar`, `Ptcl-Adj`, `Ptcl-Neg`, and `Pref/Sep` to `ConjInf`,
  `ConjCoord`, `ConjSub`, `ConjCompar`, `PIndInvar`, `PtclAdj`, `PtclNeg`, and
  `VPart`, respectively
* rename inflection classes `Prep/Art-m`, `Prep/Art-n`, `Prep/Art-s`, and
  `Prep/Art-r` to `Prep+Art-m`, `Prep+Art-n`, `Prep+Art-s`, and `Prep+Art-r`,
  respectively
* rename inflection classes `Abbr_NMasc`, `Abbr_NNeut`, `Abbr_NFem`,
  `Abbr_NNoGend`, `Abbr_Adj`, `Abbr_Poss`, and `Abbr_VImp` to `AbbrNMasc`,
  `AbbrNNeut`, `AbbrNFem`, `AbbrNNoGend`, `AbbrAdj`, `AbbrPoss`, and `AbbrVImp`,
  respectively
* remove unused inflection classes `Adj+(e)`, `Pref/Adj`, `Pref/Adv`, `Pref/N`,
  `Pref/ProAdv`, and `Pref/V`

2023-11-28:

* allow for proper nouns as compounding bases
* allow for abbreviated final bases in hyphenated compounds

2023-11-27:

* add inflection class `Frac` for fractions
* add inflection class `Dem-alldem` for demonstrative pronouns "alldem" and
  "alledem"

2023-11-24:

* add inflection classes `IPro-unsereiner` and `IPro-unsereins` for indefinite
  pronouns "unsereiner" and "unsereins"

2023-10-20:

* add inflection class `PRecPl` for reciprocal pronoun "einander"

2023-10-16:

* add initial support for morpheme truncation, marked by `<TRUNC>` in the
  analysis string

2023-10-12:

* remove unused inflection classes `Adj$e~ss`, `Adj+e~ss`, `NFem_0_$e~ss`,
  `NFem_0_en~ss`, `NMasc/Sg_es~ss`, `NMasc_es_$e~ss`, `NNeut_es_$er~ss`,
  `VMPresPl~ss`, `VMPresSg~ss`, `VVPastIndReg~ss`, `VVPastIndStr~ss`,
  `VVPastStr~ss`, `VVPastSubjReg~ss`, `VVPP-t~ss`, `VVPres1~ss`,
  `VVPres1+Imp~ss`, `VVPres2~ss`, `VVPres2+Imp0~ss`, and `VVReg~ss`
* remove unused trigger symbol `<SSAlt>`
* simplify phonological rule for "s"/"ss"-alternation (`R4`)
* remove unused phonological rule for consonant reduction in old orthography
  (formerly `R14`)

2023-07-03:

* add support for derivation by means of "e"-suffixation with proper-name bases

2023-05-22:

* add support for conversion of verbal participles

2023-05-19:

* add initial support for the formation of particle verbs
* allow for imperative singular forms optionally ending in "-e" in inflection
  classes `VVReg`, `VVRegFin`, `VVPres`, `VVPres1+Imp`, and `VVPres2+Imp`
* rename inflection class `VVPres2+Imp0` to `VVPres2t+Imp0`
* add inflection class `Abbr_VImp`
* add inflection class `VVPres2+Imp0` for strong verbs with uninflected
  imperative singular forms
* add inflection class `NNeut_es_ien`
* remove unused inflection classes `NMasc/Sg_0~ss`, `NNeut/Sg_0~ss`,
  `NFem/Sg_0~ss`, `AdjPos~ss`, `Adv~ss`, `Conj~ss-Sub`, and `Intj~ss`
* add word list of special cases to rule for old "ß" spelling

2023-05-17:

* add rule for supporting old "ß" spelling, marked as `<OLDORTH>`

2023-05-16:

* add support for Swiss spelling, marked as `<CH>`

2023-05-11:

* pass through `<OLDORTH>` symbols from the lexicon

2023-05-10:

* rename inflection classes `Adj~+e`, `Adj~$e`, `NMasc-s/Sg`, `NMasc-s/sse`,
  `NMasc-s0/sse`, `NMasc-s/$sse`, `NNeut/Sg_sses`, `NNeut-s/sse`,
  `NNeut-s0/sse`, `NNeut-s/$sser`, `NFem-s/sse`, `NFem-s/$sse`, `NFem-s/ssen`,
  `VVReg-s`, `VVPres1-s`, `VVPres1-s+Imp-s`, `VVPres2-s`, `VVPres2-s+Imp-s`,
  `VVPastStr-s`, `VVPastIndStr-s`, `VVPastIndReg-s`, `VVPastSubjReg-s`,
  `VMPresSg-s`, and `VMPresPl-s` to `Adj+e~ss`, `Adj$e~ss`, `NMasc/Sg_es~ss`,
  `NMasc_es_e~ss`, `NMasc_0_e~ss`, `NMasc_es_$e~ss`, `NNeut/Sg_es~ss`,
  `NNeut_es_e~ss`, `NNeut_0_e~ss`, `NNeut_es_$er~ss`, `NFem_0_e~ss`,
  `NFem_0_$e~ss`, `NFem_0_en~ss`, `VVReg~ss`, `VVPres1~ss`, `VVPres1+Imp~ss`,
  `VVPres2~ss`, `VVPres2+Imp~ss`, `VVPastStr~ss`, `VVPastIndStr~ss`,
  `VVPastIndReg~ss`, `VVPastSubjReg~ss`, `VMPresSg~ss`, and `VMPresPl~ss`,
  respectively
* add inflection classes `NMasc/Sg_0~ss`, `NNeut/Sg_0~ss`, `NFem/Sg_0~ss`,
  `AdjPos~ss`, `Adv~ss`, `Conj~ss-Sub`, and `Intj~ss` for old spellings

2023-05-08:

* add inflection classes `VVPastStr-s` and `VVPastIndStr-s` for more old
  spellings of verb forms

2023-05-05:

* rename `cap.fst` to `orth.fst`
* do not clean up `<OLDORTH>`
* move `<OLDORTH>` and `<CAP>` to the end of the analysis string

2023-05-04:

* add inflection classes `VVReg-s`, `VVPres1-s`, `VVPres1-s+Imp-s`, `VVPres2-s`,
  `VVPres2-s+Imp-s`, `VVPastIndReg-s`, `VVPastSubjReg-s`, `VVPP-t-s`,
  `VMPresSg-s`, and `VMPresPl-s` for old spellings of verb
  forms

2023-05-03:

* rename inflection classes `Ptkl-Adj `, `Ptkl-Neg`, and `Ptkl-Zu` and `Ptcl-Adj
  `, `Ptcl-Neg`, and `Ptcl-zu`, respectively
* rename inflection classes `Konj-Inf`, `Konj-Kon`, `Konj-Sub`, and `Konj-Vgl`
  to `Conj-Inf`, `Conj-Coord`, `Conj-Sub`, and `Conj-Compar`, respectively
* rename inflection classes `VAPastKonj2`, `VAPres1/3SgKonj`, `VAPres2SgKonj`,
  `VAPresKonjPl`, `VAPresKonjSg`, `VMPastKonj`, `VPastKonjStr`, `VPresKonj`,
  `VVPastKonjReg`, and `VVPastKonjStr` to `VAPastSubj2`, `VAPres1/3SgSubj`,
  `VAPres2SgSubj`, `VAPresSubjPl`, `VAPresSubjSg`, `VMPastSubj`, `VPastSubjStr`,
  `VPresSubj`, `VVPastSubjReg`, and `VVPastSubjStr`, respectively
* add inflection class `VVPastSubjOld`

2023-04-26:

* rename inflection classes `N?/Pl_0` and `N?/Pl_x` to `NNoGend/Pl_0` and
  `NNoGend/Pl_x`, respectively
* rename inflection class `Abk_POSS` to `Abbr_Poss`
* add inflection classes `Abbr_NFem`, `Abbr_NMasc`, `Abbr_NNeut`, and
  `Abbr_NNoGend`

2023-04-25:

* replace inflection classes `Prep-Akk`, `Prep-Dat`, `Prep-Gen`, `Prep-GDA`,
  `Prep-DA`, `Prep-GD`, `Postp-Akk`, `Postp-Dat`, `Postp-Gen` with `Prep` and
  `Postp`

2023-03-29:

* mark derivation stems with suffix
* add support for derivation by means of "er"-suffixation with proper-name bases

2023-03-28:

* add inflection classes `NMasc_0_0`, `NMasc_0_e`, `NMasc_0_$e`, `NNeut_0_0`,
  `NNeut_0_e`, `NNeut-s0/sse`, and `NFem_0_0`

2023-03-27:

* add inflection class `Adj$-el/er`

2023-03-24:

* use phonological rules for changing letter case

2023-03-23:

* use entry types only for word-formation rules

2023-03-21:

* eliminate disjunctive categories
* generate morpheme-boundary markers from morpheme-boundary triggers
* apply selected phonological rules to analysis level

2023-03-20:

* add support for derivation by means of "chen"- and "lein"-suffixation

2023-03-13:

* refactorise `dwdsmor.fst`, `dwdsmor-finite.fst`, `dwdsmor-index.fst`,
  `dwdsmor-root.fst`, and `wf.fst`
* move code from `level.fst` and `map.fst` to `cleanup.fst`, `markers.fst`, and
  `stemtype.fst`
* remove `level.fst` and `map.fst`
* rename `<nativ>` and `<fremd>` to `<native>` and `<foreign>`, respectively

2023-03-07:

* rename `flexion.fst` to `infl.fst`

2023-01-18:

* restrict derivation by means of "un"-prefixation to non-abbreviated bases

2023-01-17:

* add support for derivation by means of "un"-prefixation

2023-01-16:

* make `markers.fst` more modular

2022-12-21:

* add features for word-formation process and means to `dwdsmor-root.fst`

2022-12-20:

* support compounding-stem entries with pairs of lemma and compounding stem
* add `dwdsmor-root.fst` for analysing word forms in terms of root lemmas

2022-12-12:

* exclude abbreviated stems in hyphenated compounds after a stem without a
  following hyphen
* add support for capitalised lowercase words

2022-12-05:

* directly generate surface lemmas for compounds
* add support for hyphenated compounds
* remove `lemma.fst` and `lemma-index.fst`
* use `<#>` as a morpheme-boundary marker between compound members, `<=>` before
  hyphens, and `<~>` before suffixes of compounding stems
* downcase non-first compound members in non-hyphenated compounds
* do not manipulate letter case via inflection classes
* remove inflection classes `AdjPos-Up`, `AdjPosAttr-Up`, and `IntjUp`
* rename inflection class `AdjPos0Attr-Up` to `AdjPos0AttrSubst`
* exclude abbreviated stems in non-hyphenated compounds
* exclude abbreviated base stems in hyphenated compounds

2022-12-02:

* replace `DWDS.lex`, `DWDS-Red2.lex`, and `aux.lex` with `dwds.lex`
* add support for non-nominal compounding stems

2022-11-21:

* rename `dwdsmor-minimal.fst` to `dwdsmor-finite.fst`, and add
  `DWDS-Red2.lex`, `aux.lex`, `punct.fst`, and `num-finite.fst` to it
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
