% module_symbols.fst
% Version 14.0
% Andreas Nolda 2026-01-08

% must be loaded first

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#entry-type# = <Stem><Pref><Intf><Suff>

#uppercase-vowel# = AEIOUÀ-ÆĀĂĄÈ-ËĒĔĖĘĚÌ-ÏĨĪĬĮİĲÒ-ÖŒØŌŎŐŒÙ-ÜŨŪŬŮŰŲYÝ % ...

#lowercase-vowel# = aeiouà-æāăąè-ëēĕėęěì-ïĩīĭįıĳò-öœøōŏőœù-üũūŭůűųyý % ...

#uppercase-consonant# = BCDFGHJKLMNPQRSTVWXZẞÇĆĈĊČÐĎĐĜĞĠĢĤĦĴĶĹĻĽĿŁÑŃŅŊŔŖŘŚŜŞŠÞŢŤŦŴŶŹŻŽ % ...

#lowercase-consonant# = bcdfghjklmnpqrstvwxzßçćĉċčðďđĝğġģĥħĵķĺļľŀłñńņŋŕŗřśŝşšþţťŧŵŷźżž % ...

#vowel# = #uppercase-vowel# #lowercase-vowel#

#consonant# = #uppercase-consonant# #lowercase-consonant#

#uppercase# = #uppercase-vowel# #uppercase-consonant#

#lowercase# = #lowercase-vowel# #lowercase-consonant#

#greek# = αβγδεζηθικλμνξοπρςστυφχψω

#num# = 0-9

#sup# = ⁰¹²³⁴⁵⁶⁷⁸⁹

#sub# = ₀₁₂₃₄₅₆₇₈₉

#frac# = ½⅓⅔¼¾⅕⅖⅗⅘⅙⅚⅐⅛⅜⅝⅞⅑⅒ % ...

#symbol# = §\%‰°′″*†&\+−×÷€£$¥ % ...

#punctcomma# = \,

#punctperiod# = \.\?\!\:;

#punctellip# = … % ...

#punctquote# = \"\'„“‚‘»«›‹ % ...

#punctparen# = \(\)\[\] % ...

#punctdash# = \-– % ...

#punctslash# = / % ...

#punctother# = ’·• % ...

#punct# = #punctcomma# #punctperiod# #punctellip# #punctquote# #punctparen# \
          #punctdash# #punctslash# #punctother#

#char# = #uppercase# #lowercase# #greek# #num# #sup# #sub# #frac# #symbol# \
         #punct#

#surface-trigger# = <e><s><z>

#orth-trigger# = <dc><uc>

#phon-trigger# = <dbl(s)><dbl(z)><del(e)><del(e)|ADJ><del(e)|Gen><del(e)|PRO> \
                 <del(-e)><del(VC)|Pl><ins(e)><uml>

#morph-trigger# = <ins(ge)><ins(zu)><rm|Part><rm|Imp>

#boundary-trigger# = <WB><CB><VB><DB><IB><PB><SB>

#morpheme-boundary# = <+><|><#><\=><-><\~>

#wf-process# = <COMP><DER><CONV>

#wf-means# = <concat><ident><ident|Fem><ident|Inf><ident|Masc><ident|Neut> \
             <ident|Part><intf(-)><intf(und)><pref(un)><prev()><prev(ab)> \
             <prev(an)><prev(auf)><prev(aus)><prev(bei)><prev(durch)><prev(ein)> \
             <prev(fort)><prev(gegen)><prev(heim)><prev(her)><prev(hin)> \
             <prev(hinter)><prev(los)><prev(mit)><prev(nach)><prev(ueber)> \
             <prev(um)><prev(unter)><prev(vor)><prev(weg)><prev(wieder)> \
             <prev(zu)><prev(zurueck)><prev(zwischen)><suff(bar)><suff(chen)> \
             <suff(e)><suff(er)><suff(lein)><suff(st)><suff(stel)><suff(zig)>

#wf# = #wf-process# #wf-means#

#weight# = <W->

#pos# = <ADJ><ADV><ART><CARD><CONJ><DEM><FRAC><INDEF><INTJ><NN><NPROP><ORD> \
        <POSS><POSTP><PPRO><PREP><PREPART><PREV><PROADV><PTCL><PUNCT><REL><V> \
        <WADV><WPRO>

#subcat# = <Pers><Refl><Rec><Def><Indef><Neg><Coord><Sub><Int><InfCl><AdjComp> \
           <AdjSup><Comma><Period><Ellip><Quote><Paren><Dash><Slash><Other>

#degree# = <Pos><Comp><Sup>

#person# = <1><2><3><UnmPers>

#gender# = <Masc><Fem><Neut><UnmGend>

#case# = <Nom><Gen><Dat><Acc><UnmCase>

#number# = <Sg><Pl><UnmNum>

#infl# = <St><Wk><UnmInfl>

#function# = <Attr><Subst><Attr/Subst><Pred/Adv><Cl><NonCl><UnmFunc>

#nonfinite# = <Inf><Part>

#mood# = <Ind><Subj><Imp><UnmMood>

#tense# = <Pres><Past><Perf><UnmTense>

#auxiliary# = <haben><sein>

#feature# = #pos# #subcat# #degree# #person# #gender# #case# #number# #infl# \
            #function# #nonfinite# #mood# #tense# #auxiliary#

#metainfo# = <NonSt><Old>

#orthinfo# = <CH><OLDORTH>

#syninfo# = <MEAS><SEP>

#ellipinfo# = <TRUNC>

#info# = #metainfo# #orthinfo# #syninfo# #ellipinfo#

#stem-type# = <base><comp><der>

#suff# = <-bar><-chen><-e><-er><-lein><-st><-stel><-zig> % ...

#origin# = <native><foreign>

#lemma-index# = <IDX1><IDX2><IDX3><IDX4><IDX5><IDX6><IDX7><IDX8>

#paradigm-index# = <PAR1><PAR2><PAR3><PAR4><PAR5><PAR6><PAR7><PAR8>

#index# = #lemma-index# #paradigm-index#

#abbr-inflection# = <AbbrAdj><AbbrNFem><AbbrNMasc><AbbrNNeut><AbbrNUnmGend> \
                    <AbbrPoss><AbbrVImp>

#adj-inflection# = <Adj_er_$est><Adj_er_$st><Adj_er_est><Adj_er_st> \
                   <AdjComp-el_er><AdjComp-en_er><AdjComp-er_er><AdjComp0> \
                   <AdjComp_er><AdjPos><AdjPos-e><AdjPos-el><AdjPos-en> \
                   <AdjPos-er><AdjPos0><AdjPos0-e><AdjPos0-viel><AdjPosAttr> \
                   <AdjPosAttr-er><AdjPosAttr-ler><AdjPosAttr0> \
                   <AdjPosAttrSubst0><AdjPosPred><AdjPosPred-e><AdjSup_est> \
                   <AdjSup_st><AdjSupAttr_est><AdjSupAttr_st>

#adv-inflection# = <AdvComp_er><AdvComp0><AdvSup_est><AdvSup_st>

#art-inflection# = <ArtDef><ArtIndef><ArtIndef-n><ArtNeg>

#noun-inflection# = <NFem-Adj><NFem-in><NFem-Meas><NFem|Pl_0><NFem|Sg_0> \
                    <NFem_0_$_n><NFem_0_$e_n><NFem_0_$en_0><NFem_0_0_0> \
                    <NFem_0_0_n><NFem_0_a/e_0><NFem_0_a/en_0><NFem_0_e_0> \
                    <NFem_0_e_n><NFem_0_e_n~ss><NFem_0_ans/anten_0> \
                    <NFem_0_anx/angen_0><NFem_0_e/i_0><NFem_0_en_0><NFem_0_es_0> \
                    <NFem_0_es/en_0><NFem_0_ex/eges_0><NFem_0_is/en_0> \
                    <NFem_0_is/iden_0><NFem_0_is/ides_0><NFem_0_ix/ices_0> \
                    <NFem_0_ix/izen_0><NFem_0_ix/izes_0><NFem_0_n_0> \
                    <NFem_0_ien_0><NFem_0_nes_0><NFem_0_os/otes_0> \
                    <NFem_0_ox/oces_0><NFem_0_s_0><NFemOld_n_n_0><NMasc-Adj> \
                    <NMasc-Meas_es><NMasc-Meas_s><NMasc|Pl_0><NMasc|Sg_0> \
                    <NMasc|Sg_es><NMasc|Sg_ns><NMasc|Sg_s><NMasc_0_$e_n> \
                    <NMasc_0_0_0><NMasc_0_0_n><NMasc_0_a/en_0> \
                    <NMasc_0_as/anten_0><NMasc_0_e_n><NMasc_0_e_n~ss> \
                    <NMasc_0_e/i_0><NMasc_0_en_0><NMasc_0_ens/entes_0> \
                    <NMasc_0_es/iden_0><NMasc_0_es/ides_0><NMasc_0_es_0> \
                    <NMasc_0_ex/izes_0><NMasc_0_ix/izes_0><NMasc_0_i/en_0> \
                    <NMasc_0_i_0><NMasc_0_is/es_0><NMasc_0_nen_0> \
                    <NMasc_0_o/en_0><NMasc_0_o/i_0><NMasc_0_os/en_0> \
                    <NMasc_0_os/oden_0><NMasc_0_os/oen_0><NMasc_0_os/oi_0> \
                    <NMasc_0_s_0><NMasc_0_us/e_n><NMasc_0_us/een_0> \
                    <NMasc_0_us/en_0><NMasc_0_us/er_n><NMasc_0_us/i_0> \
                    <NMasc_0_us/ier_n><NMasc_0_ynx/yngen_0><NMasc_en_en_0> \
                    <NMasc_es_$e_n><NMasc_es_$er_n><NMasc_es_as/anten_0~ss> \
                    <NMasc_es_e_n><NMasc_es_e_n~ss><NMasc_es_en_0> \
                    <NMasc_es_er_n><NMasc_es_es_0><NMasc_es_ex/izes_0> \
                    <NMasc_es_ix/izes_0><NMasc_es_s_0><NMasc_es_us/een_0~ss> \
                    <NMasc_es_us/en_0~ss><NMasc_es_us/i_0~ss><NMasc_n_n_0> \
                    <NMasc_ns_n_0><NMasc_ns_$n_0><NMasc_s_$_n><NMasc_s_$e_n> \
                    <NMasc_s_$er_n><NMasc_s_$_0><NMasc_s_0_0><NMasc_s_0_n> \
                    <NMasc_s_a/en_0><NMasc_s_e_n><NMasc_s_e/i_0> \
                    <NMasc_s_er/res_0><NMasc_s_en_0><NMasc_s_er_n><NMasc_s_es_0> \
                    <NMasc_s_i/en_0><NMasc_s_/en_0><NMasc_s_n_0><NMasc_s_ien_0> \
                    <NMasc_s_nen_0><NMasc_s_o/en_0><NMasc_s_o/i_0><NMasc_s_s_0> \
                    <NMascNonSt_0_e_n~ss><NMascNonSt_es_$er_n> \
                    <NMascNonSt_es_e_n~ss><NMascNonSt_n_e/s_0> \
                    <NMascNonSt_n_ns_0><NMascNonSt_s_en_0><NNeut-Meas_es> \
                    <NNeut-Meas_s><NNeut-Adj><NNeut-Adj|Sg><NNeut-Inner> \
                    <NNeut|Pl_0><NNeut|PlNonSt_n><NNeut|Sg_0><NNeut|Sg_es> \
                    <NNeut|Sg_es~ss><NNeut|Sg_s><NNeut_0_0_0><NNeut_0_0_n> \
                    <NNeut_0_a/ata_0><NNeut_0_a/en_0><NNeut_0_ans/antien_0> \
                    <NNeut_0_ans/anzien_0><NNeut_0_e_n><NNeut_0_e_n~ss> \
                    <NNeut_0_e/i_0><NNeut_0_e/ia_0><NNeut_0_e/ien_0> \
                    <NNeut_0_em/en_0><NNeut_0_en_0><NNeut_0_en/ina_0> \
                    <NNeut_0_ens/entia_0><NNeut_0_ens/entien_0> \
                    <NNeut_0_ens/enzien_0><NNeut_0_es_0><NNeut_0_ex/izia_0> \
                    <NNeut_0_i/en_0><NNeut_0_nen_0><NNeut_0_o/en_0> \
                    <NNeut_0_o/i_0><NNeut_0_on/a_0><NNeut_0_on/en_0> \
                    <NNeut_0_os/en_0><NNeut_0_s_0><NNeut_0_um/a_0> \
                    <NNeut_0_um/en_0><NNeut_0_us/en_0><NNeut_0_us/era_0> \
                    <NNeut_0_us/ora_0><NNeut_ens_en_0><NNeut_es_$e_n> \
                    <NNeut_es_$er_n><NNeut_es_e_n><NNeut_es_e_n~ss> \
                    <NNeutNonSt_es_e_n~zz><NNeut_es_en_0><NNeut_es_er_n> \
                    <NNeut_es_es_0><NNeut_es_ex/izia_0><NNeut_es_ien_0> \
                    <NNeut_es_s_0><NNeut_s_$_n><NNeut_s_$er_n><NNeut_s_0_n> \
                    <NNeut_s_a_0><NNeut_s_a/ata_0><NNeut_s_a/en_0><NNeut_s_e_n> \
                    <NNeut_s_e/i_0><NNeut_s_e/ia_0><NNeut_s_e/ien_0> \
                    <NNeut_s_em/en_0><NNeut_s_en_0><NNeut_s_en/ina_0> \
                    <NNeut_s_i/en_0><NNeut_s_ien_0><NNeut_s_n_0><NNeut_s_nen_0> \
                    <NNeut_s_o/en_0><NNeut_s_o/i_0><NNeut_s_on/a_0> \
                    <NNeut_s_on/en_0><NNeut_s_s_0><NNeut_s_um/a_0> \
                    <NNeut_s_um/en_0><NNeut_s_0_0><NNeutNonSt_es_$er_n> \
                    <NNeutNonSt_es_er_n><NUnmGend|Pl_0><NUnmGend|Pl_n>

#name-inflection# = <NameFem_0><NameFem_apos><NameFem_s><NameMasc_0> \
                    <NameMasc_apos><NameMasc_es><NameMasc_s><NameNeut_0> \
                    <NameNeut_apos><NameNeut_es><NameNeut_s><NameUnmGend|Pl_0> \
                    <NameUnmGend|Pl_n>

#num-inflection# = <Card0><Card-ein><Card-kein><Card-sieben><Card-vier> \
                   <Card-zwei><DigCard><DigFrac><DigOrd><Frac0><Ord><Roman>

#prep-inflection# = <Prep+Art-m><Prep+Art-m-NonSt><Prep+Art-n-NonSt><Prep+Art-r> \
                    <Prep+Art-s>

#pro-inflection# = <ArtDef-das+DemNeut><ArtDef-dem+DemMasc><ArtDef-dem+DemNeut> \
                   <ArtDef-den+DemMasc><ArtDef-den+DemUnmGend> \
                   <ArtDef-der+DemFem><ArtDef-der+DemMasc> \
                   <ArtDef-der+DemUnmGend><ArtDef-des+DemMasc> \
                   <ArtDef-des+DemNeut><ArtDef-die+DemFem> \
                   <ArtDef-die+DemUnmGend><Dem><Dem0><Dem-alldem><Dem-dies> \
                   <Dem-solch><DemDef><Indef0><Indef-all><Indef-beid> \
                   <Indef-einig><Indef-irgendein><Indef-irgendwelch><Indef-jed> \
                   <Indef-jeglich><Indef-manch><Indef-mehrer><Indef-saemtlich> \
                   <Indef-welch><IPro-eine><IPro-einer><IPro-frau><IPro-jedefrau> \
                   <IPro-jederfrau><IPro-jedermann><IPro-man><IPro-unsereiner> \
                   <IPro-unsereins><IProMasc><IProMascAccSg><IProMascDatSg> \
                   <IProMascGenSg><IProMascNomSg><IProNeut><IProNeutAccSg> \
                   <IProNeutDatSg><IProNeutGenSg><IProNeutNomSg><Poss><Poss-er> \
                   <Poss|Wk><Poss|Wk-er><PPro1AccPl><PPro1AccSg><PPro1DatPl> \
                   <PPro1DatSg><PPro1GenPl><PPro1GenSg><PPro1NomPl><PPro1NomSg> \
                   <PPro2AccPl><PPro2AccSg><PPro2DatPl><PPro2DatSg><PPro2GenPl> \
                   <PPro2GenSg><PPro2NomPl><PPro2NomSg><PProFemAccSg> \
                   <PProFemDatSg><PProFemGenSg><PProFemNomSg><PProMascAccSg> \
                   <PProMascDatSg><PProMascGenSg><PProMascNomSg><PProNeutAccSg> \
                   <PProNeutAccSg-s><PProNeutDatSg><PProNeutGenSg> \
                   <PProNeutNomSg><PProNeutNomSg-s><PProUnmGendAccPl> \
                   <PProUnmGendDatPl><PProUnmGendGenPl><PProUnmGendNomPl> \
                   <PRecPl><PRefl1AccSg><PRefl1DatSg><PRefl2AccSg><PRefl2DatSg> \
                   <PRefl1Pl><PRefl2Pl><PRefl3><Rel><Rel-welch><RProMascAccSg> \
                   <RProMascDatSg><RProMascGenSg><RProMascNomSg><RProNeutAccSg> \
                   <RProNeutDatSg><RProNeutGenSg><RProNeutNomSg><W-welch> \
                   <WProMascAccSg><WProMascDatSg><WProMascGenSg><WProMascNomSg> \
                   <WProNeutAccSg><WProNeutDatSg><WProNeutGenSg><WProNeutNomSg>

#verb-inflection# = <VImp><VImp-ak-ik><VImp-d-t><VImp-el-er><VImp-le><VImp-m-n> \
                    <VImpPl><VImpPl-sein><VImpSg><VImpSg0><VInf><VInf-el-er> \
                    <VInf-le><VInf_n><VModPresIndSg><VModPresNonIndSg> \
                    <VPartPerf-d_t><VPartPerf-le><VPartPerf_ed><VPartPerf_n> \
                    <VPartPerfStr><VPartPerfWeak><VPartPres><VPartPres-el-er> \
                    <VPartPres-le><VPastInd-d-t_t><VPastInd-le><VPastInd-werden> \
                    <VPastIndPl-werden><VPastIndSg-ward><VPastIndOld> \
                    <VPastIndStr><VPastIndStr-s><VPastIndWeak><VPastStr> \
                    <VPastStr-s><VPastSubj-haben><VPastSubj-le><VPastSubj2-sein> \
                    <VPastSubjOld><VPastSubjStr><VPastSubjWeak><VPres> \
                    <VPres-ak-ik><VPres-el-er><VPres-le><VPres-m-n><VPres-s> \
                    <VPres-tun><VPresInd13Pl-sein><VPresInd1Sg-sein> \
                    <VPresInd23Sg><VPresInd23Sg-d_t><VPresInd23Sg-t_0> \
                    <VPresInd2Pl-sein><VPresInd2Sg-sein><VPresInd2Sg-werden> \
                    <VPresInd3Sg-sein><VPresInd3Sg-werden><VPresNonInd23Sg> \
                    <VPresSubj-sein><VWeak><VWeak-ak-ik><VWeak-d-t><VWeak-el-er> \
                    <VWeak-le><VWeak-m-n><VWeak-s><VWeak-signen>

#inflection# = #abbr-inflection# #adj-inflection# #adv-inflection# \
               #art-inflection# #noun-inflection# #name-inflection# \
               #num-inflection# #prep-inflection# #pro-inflection# \
               #verb-inflection#
