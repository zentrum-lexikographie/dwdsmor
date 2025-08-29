This file logs the changes in FST files, starting from the DSDSmor fork.

2025-08-29:

* add support for derivation by means of "bar"-suffixation

2025-07-28:

* add support for fractional derivation by means of "(s)tel"-suffixation
* add support for fractional compounding
* add support for conversion of fractional numerals

2025-07-25:

* remove inflection classes `Indef-ein` and `Indef-kein`
* add inflection classes `IPro-einer` and `IPro-eine`

2025-07-18:

* add support for ordinal compounding

2025-07-16:

* add support for conversion of ordinals

2025-07-15:

* add support for ordinal derivation by means of "(s)t"-suffixation

2025-07-10:

* add support for cardinal compounding
* rename `<hyph>` to `<intf(-)>`

2025-07-09:

* rename `<HB>` to `<IB>` (interfix boundary)
* introduce hyphen interfix explicitly like other affixes

2025-07-08:

* add support for cardinal derivation by means of "zig"-suffixation

2025-07-07:

* add support for conversion of inflected adjectives

2025-07-04:

* add support for conversion of infinitives

2025-07-02:

* add inflection class `NMascNonSt_s_en_0`

2025-06-30:

* remove `+` from part-of-speech categories
* use part-of-speech categories and subcategories also in the lexicon
* remove inflection classes `Adv`, `ConjAdjComp`, `ConjCoord`, `ConjInfCl`,
  `ConjSub`, `Intj`, `Postp`, `Prep`, `Prev`, `ProAdv`, `PtclAdjPos`,
  `PtclAdjSup`, `PtclInfCl`, `PtclNeg`, and `WAdv` for uninflected words
* rename particle subcategory `AdjPos` to `Int` (intensifier)

2025-06-19:

* exclude "sein" as a basis for preverb prefixation
* exclude abbreviated bases for preverb prefixation

2025-06-18:

* harmonize word-formation grammar across automata
* make the order of word-formation tags semantically insignificant, by
  interfixing `<COMP>` between base lemmas, prefixing or suffixing `<DER>` to
  base lemmas, and suffixing `<CONV>` to base lemmas

2025-05-26:

* add inflection class `VPastIndOld`

2025-05-12:

* add inflection class `AdjPosAttr-ler`

2025-05-09:

* optimize automata by fronting the orthography tags `<OLDORTH>`, `<CH>`, and
  `<CAP>`
* optimize automata by fronting the ellipsis tag `<TRUNC>` and the syntax tag
  `<SEP>`
* optimize automata by fronting the tags `<COMP>`, `<DER>`, and `<CONV>` for
  word-formation processes as well as the corresponding tags for word-formation
  means

2025-05-07:

* rename `dwds.lex` to `lex.txt`

2025-05-02:

* exclude "worden" as a conversion basis

2025-04-30:

* add inflection class `NMasc_0_us/er_n`
* add inflection classes `NNeut_0_em/en_0` and `NNeut_s_em/en_0`

2025-04-25:

* add inflection classes `NMasc0_s`, `NNeut0_s`, and `NFem0` for measure nouns

2025-04-24:

* add inflection class `NFem_n_n_0` for archaic weak inflection of "Gnade"
* add inflection class `NNeut_es_e_n~zz` for colloquial inflection of "Quiz"

2025-04-22:

* add support for common currency symbols

2025-04-11:

* add support for non-standard contracted adpositions

2025-04-10:

* add support for nominal compounds with adjectival or verbal initial or
  intermediate bases

2025-04-08:

* add support for the formation of particle verbs with "fort", "heim", "her",
  "hin", and "wieder"

2025-04-07:

* add support for separated parts of separable verbs, marked by `<SEP>` in the
  analysis string

2024-11-19:

* replace inflection tag `<Invar>` with `<UnmFunc>`, `<UnmGend>`, `<UnmCase>`,
  `<UnmNum>`, and/or `<UnmInfl>`
* replace inflection tags `<NoGend>` and `<NoInfl>` with `<UnmGend>` and
  `<UnmInfl>`, respectively
* rename inflection classes `<NNoGend|Pl_0>`, `<NNoGend|Pl_n>`,
  `<NameNoGend|Pl_0>`, `<NameNoGend|Pl_n>`, `<ArtDef-den+DemNoGend>`,
  `<ArtDef-der+DemNoGend>`, `<ArtDef-die+DemNoGend>`, `<PProNoGendAccPl>`,
  `<PProNoGendDatPl>`, `<PProNoGendGenPl>`, `<PProNoGendNomPl>`, and
  `<AbbrNNoGend>` to `<NUnmGend|Pl_0>`, `<NUnmGend|Pl_n>`, `<NameUnmGend|Pl_0>`,
  `<NameUnmGend|Pl_n>`, `<ArtDef-den+DemUnmGend>`, `<ArtDef-der+DemUnmGend>`,
  `<ArtDef-die+DemUnmGend>`, `<PProUnmGendAccPl>`, `<PProUnmGendDatPl>`,
  `<PProUnmGendGenPl>`, `<PProUnmGendNomPl>`, and `<AbbrNUnmGend>`, respectively

2024-11-07:

* add inflection classes `NMasc_0_ix/izes_0`, `NMasc_es_ix/izes_0`,
  `NMasc_0_os/en_0`, `NNeut_0_os/en_0`, `NNeut_0_ex/izia_0`,
  `NNeut_es_ex/izia_0`, and `NFem_0_es/en_0`

2024-11-01:

* add inflection classes `NMasc_0_i_0`, `NMasc_0_es/iden_0`,
  `NMasc_0_es/ides_0`, `NMasc_s_ien_0`, `NMasc_0_ens/entes_0`,
  `NMasc_0_is/es_0`, `NMasc_s_er/res_0`, `NNeut_0_ens/entia_0`,
  `NNeut_0_ens/entien_0`, `NFem_0_ien_0`, `NFem_0_nes_0`, `NFem_0_a/e_0`,
  `NFem_0_ans/anten_0`, `NFem_0_is/ides_0`, `NFem_0_ix/izes_0`,
  `NFem_0_os/otes_0`, and `NFem_0_ox/oces_0`

2024-10-30:

* rename inflection classes `Adj_0`, `Adj_e`, `Adj_$`, `Adj_$e`, `AdjPos0Attr`,
  `AdjPos0AttrSubst`, `AdjComp0-mehr`, `AdjComp`, `AdjComp-el`, `AdjComp-en`,
  `AdjComp-er`, `AdjSup`, `AdjSupAttr`, `AdvComp`, and `AdvSup` to `Adj_er_st`,
  `Adj_er_est`, `Adj_er_$st`, `Adj_er_$est`, `AdjPosAttr0`, `AdjPosAttrSubst0`,
  `AdjComp0`, `AdjComp_er`, `AdjComp-el_er`, `AdjComp-en_er`, `AdjComp-er_er`,
  `AdjSup_st`, `AdjSupAttr_st`, `AdvComp_er`, and `AdvSup_st` respectively
* add inflection classes `AdjPos-e`, `AdjPos0-e`, `AdjPosPred-e`, `AdjSup_est`,
  `AdjSupAttr_est`, and `AdvSup_est`
* remove unused inflection classes `Adj-Lang` and `AdjSup-aller`

2024-10-11:

* rename inflection tags `<PPres>` and `<PPast>` to `<Part><Pres>` and
  `<Part><Pref>`, respectively
* rename inflection classes `VPPres`, `VPPres-el-er`, `VPPres-le`, `VPPastWeak`,
  `VPPastStr`, `VPPast-d_t`, `VPPast-le`, `VPPast_n`, and `VPPast_ed` to
  `VPartPres`, `VPartPres-el-er`, `VPartPres-le`, `VPartPerfWeak`,
  `VPartPerfStr`, `VPartPerf-d_t`, `VPartPerf-le`, `VPartPerf_n`, and
  `VPartPerf_ed`, respectively
* rename POS tag `<+VPART>` to `<+PREV>` ('preverb')
* rename inflection class `VPart` to `Prev`
* add inflection tag `<NonCl>` ('non-clausal')
* rename inflection tag `<zu>` to `<Cl>` ('clausal')
* rename subcategory tags `<zu>` and `<Inf>` to `<InfCl>`
* rename inflection classes `Ptcl-zu` and `ConjInf` to `PtclInfCl` and `ConjInfCl`
* rename subcategory tags `<Adj>` and `<Compar>` to `<AdjPos>` and `<AdjComp>`,
  respectively
* rename inflection classes `PtclAdj` and `ConjCompar` to `PtclAdjPos` and
  `ConjAdjComp`, respectively
* add subcategory tag `<AdjSup>` and inflection class `PtclAdjSup`
* remove unused inflection class `PIndInvar`
* exclude clausal present participles with "zu" unless used as conversion bases
* use `<|>` as morpheme-boundary marker after separable preverbs

2024-10-02:

* rename inflection classes `VWeak-len`, `VInf-len`, `VPPres-len`, `VPPast-len`,
  `VPres-len`, `VPastInd-len`, `VPastSubj-len`, and `VImp-len` to `VWeak-le`,
  `VInf-le`, `VPPres-le`, `VPPast-le`, `VPres-le`, `VPastInd-le`,
  `VPastSubj-le`, and `VImp-le`, respectively
* add inflection classes `VWeak-signen`, `VWeak-ak-ik`, and `VPPast_ed`

2024-10-01:

* rename inflection classes `NMasc/Sg_0`, `NMasc/Sg_es`, `NMasc/Sg_s`,
  `NMasc/Sg_ns`, `NMasc/Pl_x`, `NMasc_0_x`, `NMasc_0_0`, `NMasc_0_e`,
  `NMasc_0_e~ss`, `NMasc_0_$e`, `NMasc_0_en`, `NMasc_0_es`, `NMasc_0_nen`,
  `NMasc_0_s`, `NMasc_0_as/anten`, `NMasc_0_e/i`, `NMasc_0_ex/izes`,
  `NMasc_0_o/en`, `NMasc_0_o/i`, `NMasc_0_os/oden`, `NMasc_0_os/oi`,
  `NMasc_0_us/e`, `NMasc_0_us/een`, `NMasc_0_us/i`, `NMasc_0_us/ier`,
  `NMasc_0_ynx/yngen`, `NMasc_es_e`, `NMasc_es_e~ss`, `NMasc_es_$e`,
  `NMasc_es_er`, `NMasc_es_$er`, `NMasc_es_en`, `NMasc_es_es`, `NMasc_es_s`,
  `NMasc_es_as/anten~ss`, `NMasc_es_ex/izes`, `NMasc_es_us/en~ss`,
  `NMasc_es_us/een~ss`, `NMasc_es_us/i~ss`, `NMasc_s_x`, `NMasc_s_$x`,
  `NMasc_s_0`, `NMasc_s_$`, `NMasc_s_e`, `NMasc_s_$e`, `NMasc_s_er`,
  `NMasc_s_$er`, `NMasc_s_en`, `NMasc_s_es`, `NMasc_s_n`, `NMasc_s_nen`,
  `NMasc_s_s`, `NMasc_s_e/i`, `NMasc_s_o/en`, `NMasc_s_o/i`, `NMasc_en_en`,
  `NMasc_n_n`, `NMasc_ns_n`, and `NMasc_ns_$n` to `NMasc|Sg_0`, `NMasc|Sg_es`,
  `NMasc|Sg_s`, `NMasc|Sg_ns`, `NMasc|Pl_0`, `NMasc_0_0_0`, `NMasc_0_0_n`,
  `NMasc_0_e_n`, `NMasc_0_e_n~ss`, `NMasc_0_$e_n`, `NMasc_0_en_0`,
  `NMasc_0_es_0`, `NMasc_0_nen_0`, `NMasc_0_s_0`, `NMasc_0_as/anten_0`,
  `NMasc_0_e/i_0`, `NMasc_0_ex/izes_0`, `NMasc_0_o/en_0`, `NMasc_0_o/i_0`,
  `NMasc_0_os/oden_0`, `NMasc_0_os/oi_0`, `NMasc_0_us/e_n`, `NMasc_0_us/een_0`,
  `NMasc_0_us/i_0`, `NMasc_0_us/ier_n`, `NMasc_0_ynx/yngen_0`, `NMasc_es_e_n`,
  `NMasc_es_e_n~ss`, `NMasc_es_$e_n`, `NMasc_es_er_n`, `NMasc_es_$er_n`,
  `NMasc_es_en_0`, `NMasc_es_es_0`, `NMasc_es_s_0`, `NMasc_es_as/anten_0~ss`,
  `NMasc_es_ex/izes_0`, `NMasc_es_us/en_0~ss`, `NMasc_es_us/een_0~ss`,
  `NMasc_es_us/i_0~ss`, `NMasc_s_0_0`, `NMasc_s_$_0`, `NMasc_s_0_n`,
  `NMasc_s_$_n`, `NMasc_s_e_n`, `NMasc_s_$e_n`, `NMasc_s_er_n`, `NMasc_s_$er_n`,
  `NMasc_s_en_0`, `NMasc_s_es_0`, `NMasc_s_n_0`, `NMasc_s_nen_0`, `NMasc_s_s_0`,
  `NMasc_s_e/i_0`, `NMasc_s_o/en_0`, `NMasc_s_o/i_0`, `NMasc_en_en_0`,
  `NMasc_n_n_0`, `NMasc_ns_n_0`, and `NMasc_ns_$n_0`, respectively
* rename inflection classes `NNeut/Sg_0`, `NNeut/Sg_es`, `NNeut/Sg_es~ss`,
  `NNeut/Sg_s`, `NNeut/Pl_x`, `NNeut/Pl_0`, `NNeut_0_x`, `NNeut_0_0`,
  `NNeut_0_e`, `NNeut_0_e~ss`, `NNeut_0_en`, `NNeut_0_es`, `NNeut_0_nen`,
  `NNeut_0_s`, `NNeut_0_a/ata`, `NNeut_0_a/en`, `NNeut_0_ans/antien`,
  `NNeut_0_ans/anzien`, `NNeut_0_e/i`, `NNeut_0_e/ia`, `NNeut_0_e/ien`,
  `NNeut_0_en/ina`, `NNeut_0_ens/enzien`, `NNeut_0_o/en`, `NNeut_0_o/i`,
  `NNeut_0_on/a`, `NNeut_0_on/en`, `NNeut_0_um/a`, `NNeut_0_um/en`,
  `NNeut_0_us/en`, `NNeut_0_us/era`, `NNeut_0_us/ora`, `NNeut_es_e`,
  `NNeut_es_e~ss`, `NNeut_es_$e`, `NNeut_es_er`, `NNeut_es_$er`, `NNeut_es_en`,
  `NNeut_es_es`, `NNeut_es_s`, `NNeut_es_ien`, `NNeut_s_x`, `NNeut_s_0`,
  `NNeut_s_$`, `NNeut_s_a`, `NNeut_s_e`, `NNeut_s_$er`, `NNeut_s_en`,
  `NNeut_s_n`, `NNeut_s_nen`, `NNeut_s_ien`, `NNeut_s_s`, `NNeut_s_a/ata`,
  `NNeut_s_a/en`, `NNeut_s_e/i`, `NNeut_s_e/ia`, `NNeut_s_e/ien`,
  `NNeut_s_en/ina`, `NNeut_s_o/en`, `NNeut_s_o/i`, `NNeut_s_on/a`,
  `NNeut_s_on/en`, `NNeut_s_um/a`, `NNeut_s_um/en`, `NNeut_ens_en`, and
  `NNeut-Adj/Sg` to `NNeut|Sg_0`, `NNeut|Sg_es`, `NNeut|Sg_es~ss`, `NNeut|Sg_s`,
  `NNeut|Pl_0`, `NNeut|Pl_n`, `NNeut_0_0_0`, `NNeut_0_0_n`, `NNeut_0_e_n`,
  `NNeut_0_e_n~ss`, `NNeut_0_en_0`, `NNeut_0_es_0`, `NNeut_0_nen_0`,
  `NNeut_0_s_0`, `NNeut_0_a/ata_0`, `NNeut_0_a/en_0`, `NNeut_0_ans/antien_0`,
  `NNeut_0_ans/anzien_0`, `NNeut_0_e/i_0`, `NNeut_0_e/ia_0`, `NNeut_0_e/ien_0`,
  `NNeut_0_en/ina_0`, `NNeut_0_ens/enzien_0`, `NNeut_0_o/en_0`, `NNeut_0_o/i_0`,
  `NNeut_0_on/a_0`, `NNeut_0_on/en_0`, `NNeut_0_um/a_0`, `NNeut_0_um/en_0`,
  `NNeut_0_us/en_0`, `NNeut_0_us/era_0`, `NNeut_0_us/ora_0`, `NNeut_es_e_n`,
  `NNeut_es_e_n~ss`, `NNeut_es_$e_n`, `NNeut_es_er_n`, `NNeut_es_$er_n`,
  `NNeut_es_en_0`, `NNeut_es_es_0`, `NNeut_es_s_0`, `NNeut_es_ien_0`,
  `NNeut_s_0_0`, `NNeut_s_0_n`, `NNeut_s_$_n`, `NNeut_s_a_0`, `NNeut_s_e_n`,
  `NNeut_s_$er_n`, `NNeut_s_en_0`, `NNeut_s_n_0`, `NNeut_s_nen_0`,
  `NNeut_s_ien_0`, `NNeut_s_s_0`, `NNeut_s_a/ata_0`, `NNeut_s_a/en_0`,
  `NNeut_s_e/i_0`, `NNeut_s_e/ia_0`, `NNeut_s_e/ien_0`, `NNeut_s_en/ina_0`,
  `NNeut_s_o/en_0`, `NNeut_s_o/i_0`, `NNeut_s_on/a_0`, `NNeut_s_on/en_0`,
  `NNeut_s_um/a_0`, `NNeut_s_um/en_0`, `NNeut_ens_en_0`, and `NNeut-Adj|Sg`
  respectively
* rename inflection classes `NFem/Sg_0`, `NFem/Pl_x`, `NFem_0_x`, `NFem_0_0`,
  `NFem_0_$`, `NFem_0_e`, `NFem_0_e~ss`, `NFem_0_$e`, `NFem_0_en`, `NFem_0_$en`,
  `NFem_0_n`, `NFem_0_es`, `NFem_0_s`, `NFem_0_a/en`, `NFem_0_anx/angen`,
  `NFem_0_e/i`, `NFem_0_ex/eges`, `NFem_0_is/en`, `NFem_0_is/iden`,
  `NFem_0_ix/izen`, and `NFem_0_ix/izes` to `NFem|Sg_0`, `NFem|Pl_0`,
  `NFem_0_0_0`, `NFem_0_0_n`, `NFem_0_$_n`, `NFem_0_e_n`, `NFem_0_e_n~ss`,
  `NFem_0_$e_n`, `NFem_0_en_0`, `NFem_0_$en_0`, `NFem_0_n_0`, `NFem_0_es_0`,
  `NFem_0_s_0`, `NFem_0_a/en_0`, `NFem_0_anx/angen_0`, `NFem_0_e/i_0`,
  `NFem_0_ex/eges_0`, `NFem_0_is/en_0`, `NFem_0_is/iden_0`, `NFem_0_ix/izen_0`,
  and `NFem_0_ix/izes_0`, respectively
* rename inflection classes `NNoGend/Pl_x` and `NNoGend/Pl_0` to `NNoGend|Pl_0`
  and `NNoGend|Pl_n`, respectively
* rename inflection classes `NameNoGend/Pl_x` and `NameNoGend/Pl_0` to
  `NameNoGend|Pl_0` and `NameNoGend|Pl_n`, respectively
* rename inflection classes `Poss/Wk` and `Poss/Wk` to `Poss|Wk` and
  `Poss/Wk-er`, respectively
* remove unused inflection classes `Name-Fam_0` and `Name-Fam_s`
* add inflection classes `NMasc_0_a/en_0`, `NMasc_s_a/en_0`, `NMasc_0_i/en_0`,
  `NMasc_s_i/en_0`, `NNeut_0_i/en_0` and `NNeut_s_i/en_0`
* add inflection classes `NMasc_n_ns_0` and `NMasc_n_e/s_0`
* add inflection class `NFem_0_e_0`

2024-09-26:

* add inflection classes `NNeut_0_e/ia`, `NNeut_s_e/ia`, `NNeut_0_e/ien`, and
  `NNeut_s_e/ien`

2024-09-24:

* replace inflection classes `Adj-el_0`, `Adj-el_$`, `Adj-er_0`, and `Adj-en_0`
  with inflection classes `AdjPos-el`, `AdjPos-er`, `AdjPos-en`, `AdjComp-el`,
  `AdjComp-er`, and `AdjComp-en`
* do not generate comparative and superlative forms for converted participles

2024-09-13:

* use `<->` as a morpheme-boundary marker after derivational prefixes and before
  derivational suffixes

2024-09-06:

* add inflection classes `VWeak-len`, `VInf-el-er`, `VInf-len`, `VPPres-el-er`,
  `VPPres-len`, `VPPast-len`, `VPres-el-er`, `VPres-len`, `VPastInd-len`,
  `VPastSubj-len`, `VImp-el-er`, and `VImp-len`

2024-09-04:

* mark forms of inflection class `VPastIndSg-ward` as `<Old>`
* add inflection classes `VWeak-m-n`, `VWeak-s`, `VPres-s`, `VPastStr-s`,
  `VPastIndStr-s`, and `VImp-m-n`
* rename inflection class `VPres-d-t` to `VPres-m-n`
* remove inflection class `VPresNonInd23Sg-d-t`

2024-09-03:

* remove `<SB>` boundary together with "st"-suffixes
* remove dangling `<SB>` boundaries in suffixless imperative forms
* add inflection classes `VPres-d-t` and `VPresNonInd23Sg-d-t`
* weaken phonological rule for "e"-elision in verb stems ending in "el"

2024-09-02:

* add `dwdsmor-morph.fst` for generating morphologically segmented word forms
* rename inflection classes `VInf-tun`, `VPPast-senden`, `VPPast-tun`,
  `VPresInd23Sg-t`, `VPresInd23Sg-laden`, and `VPastInd-haben` to `VInf_n`,
  `VPPast-d_t`, `VPPast_n`, `VPresInd23Sg-t_0`, `VPresInd23Sg-d_t`, and
  `VPastInd-d-t_t`, respectively

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
* add inflection classes `NMasc_0_e/i`, `NMasc_s_e/i`, `NNeut_0_e/i`,
  `NNeut_s_e/i`, and `NFem_0_e/i`

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
