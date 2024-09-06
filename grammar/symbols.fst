% symbols.fst
% Version 8.6
% Andreas Nolda 2024-09-06

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#entry-type# = <Stem><Suffix><Prefix>

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

#symbol# = §\%‰°′″*†&\+−×÷ % ...

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

#surface-trigger# = <e><n>

#orth-trigger# = <dc><uc>

#phon-trigger# = <dbl(s)><del(e)><del(e)|ADJ><del(e)|Gen><del(e)|PRO> \
                 <del(VC)|Pl><ins(e)><uml>

#morph-trigger# = <ins(ge)><ins(zu)><rm|Imp>

#boundary-trigger# = <WB><CB><VB><HB><DB><PB><SB>

#morpheme-boundary# = <+><#><\=><\~>

#wf-process# = <COMP><DER><CONV>

#wf-means# = <concat><hyph><ident|PPast><ident|PPres><part(ab)><part(an)> \
             <part(auf)><part(aus)><part(bei)><part(durch)><part(ein)> \
             <part(gegen)><part(hinter)><part(los)><part(mit)><part(nach)> \
             <part(ueber)><part(um)><part(unter)><part(vor)><part(weg)> \
             <part(zu)><part(zurueck)><part(zwischen)><pref(un)><suff(chen)> \
             <suff(e)><suff(er)><suff(lein)>

#category# = <ADJ><ADV><ART><CARD><DEM><FRAC><INDEF><NN><NPROP><ORD><OTHER> \
             <POSS><PPRO><REL><V><WPRO>

#auxiliary# = <haben><sein>

#part-of-speech# = <+ADJ><+ADV><+ART><+CARD><+CONJ><+DEM><+FRAC><+INDEF><+INTJ> \
                   <+NPROP><+NN><+ORD><+POSS><+POSTP><+PPRO><+PREP><+PREPART> \
                   <+PROADV><+PTCL><+PUNCT><+REL><+V><+VPART><+WADV><+WPRO>

#subcat# = <Pers><Refl><Rec><Def><Indef><Neg><Coord><Sub><Compar><Adv><ProAdv> \
           <Adj><Comma><Dash><Ellip><Paren><Period><Quote><Slash>

#degree# = <Pos><Comp><Sup>

#person# = <1><2><3>

#gender# = <Masc><Fem><Neut><NoGend>

#case# = <Nom><Gen><Dat><Acc>

#number# = <Sg><Pl>

#infl# = <St><Wk><NoInfl><Invar>

#function# = <Attr><Subst><Attr/Subst><Pred/Adv>

#nonfinite# = <Inf><PPres><PPast><zu>

#mood# = <Ind><Subj><Imp>

#tense# = <Pres><Past>

#feature# = #wf-process# #wf-means# #category# #auxiliary# #part-of-speech# \
            #subcat# #degree# #person# #gender# #case# #number# #infl# #function# \
            #nonfinite# #mood# #tense#

#orthinfo# = <OLDORTH>

#metainfo# = <NonSt><Old>

#info# = #orthinfo# #metainfo#

#stem-type# = <base><comp><der>

#suff# = <-chen><-e><-er><-lein> % ...

#origin# = <native><foreign>

#lemma-index# = <IDX1><IDX2><IDX3><IDX4><IDX5>

#paradigm-index# = <PAR1><PAR2><PAR3><PAR4><PAR5>

#Abbr-inflection# = <AbbrAdj><AbbrNFem><AbbrNMasc><AbbrNNeut><AbbrNNoGend> \
                    <AbbrPoss><AbbrVImp>

#Adj-inflection# = <Adj-el_$><Adj-el_0><Adj-en_0><Adj-er_0><Adj-Lang><Adj_$> \
                   <Adj_$e><Adj_0><Adj_e><AdjComp><AdjComp0-mehr><AdjPos> \
                   <AdjPos0><AdjPos0-viel><AdjPos0Attr><AdjPos0AttrSubst> \
                   <AdjPosAttr><AdjPosAttr-er><AdjPosPred><AdjSup><AdjSup-aller> \
                   <AdjSupAttr>

#Adv-inflection# = <Adv><AdvComp><AdvComp0><AdvSup>

#Art-inflection# = <ArtDef><ArtIndef><ArtIndef-n><ArtNeg>

#Noun-inflection# = <NFem-Adj><NFem-in><NFem/Pl_x><NFem/Sg_0><NFem_0_$> \
                    <NFem_0_$e><NFem_0_$en><NFem_0_0><NFem_0_a/en><NFem_0_e> \
                    <NFem_0_e~ss><NFem_0_anx/angen><NFem_0_e/i><NFem_0_en> \
                    <NFem_0_es><NFem_0_ex/eges><NFem_0_is/en><NFem_0_is/iden> \
                    <NFem_0_ix/izen><NFem_0_ix/izes><NFem_0_n><NFem_0_s> \
                    <NFem_0_x><NMasc-Adj><NMasc/Pl_x><NMasc/Sg_0><NMasc/Sg_es> \
                    <NMasc/Sg_ns><NMasc/Sg_s><NMasc_0_$e><NMasc_0_0> \
                    <NMasc_0_as/anten><NMasc_0_e><NMasc_0_e~ss><NMasc_0_e/i> \
                    <NMasc_0_en><NMasc_0_es><NMasc_0_ex/izes><NMasc_0_nen> \
                    <NMasc_0_o/en><NMasc_0_o/i><NMasc_0_os/oden><NMasc_0_os/oen> \
                    <NMasc_0_os/oi><NMasc_0_s><NMasc_0_us/e><NMasc_0_us/een> \
                    <NMasc_0_us/en><NMasc_0_us/i><NMasc_0_us/ier> \
                    <NMasc_0_ynx/yngen><NMasc_0_x><NMasc_en_en><NMasc_es_$e> \
                    <NMasc_es_$er><NMasc_es_as/anten~ss><NMasc_es_e> \
                    <NMasc_es_e~ss><NMasc_es_en><NMasc_es_er><NMasc_es_es> \
                    <NMasc_es_ex/izes><NMasc_es_s><NMasc_es_us/een~ss> \
                    <NMasc_es_us/en~ss><NMasc_es_us/i~ss><NMasc_n_n><NMasc_ns_n> \
                    <NMasc_ns_$n><NMasc_s_$><NMasc_s_$e><NMasc_s_$er> \
                    <NMasc_s_$x><NMasc_s_0><NMasc_s_e><NMasc_s_e/i><NMasc_s_en> \
                    <NMasc_s_er><NMasc_s_es><NMasc_s_n><NMasc_s_nen> \
                    <NMasc_s_o/en><NMasc_s_o/i><NMasc_s_s><NMasc_s_x><NNeut-Adj> \
                    <NNeut-Adj/Sg><NNeut-Inner><NNeut/Pl_0><NNeut/Pl_x> \
                    <NNeut/Sg_0><NNeut/Sg_es><NNeut/Sg_es~ss><NNeut/Sg_s> \
                    <NNeut_0_0><NNeut_0_a/ata><NNeut_0_a/en><NNeut_0_ans/anzien> \
                    <NNeut_0_ans/antien><NNeut_0_e><NNeut_0_e~ss><NNeut_0_e/i> \
                    <NNeut_0_en><NNeut_0_en/ina><NNeut_0_ens/enzien><NNeut_0_es> \
                    <NNeut_0_nen><NNeut_0_o/en><NNeut_0_o/i><NNeut_0_on/a> \
                    <NNeut_0_on/en><NNeut_0_s><NNeut_0_um/a><NNeut_0_um/en> \
                    <NNeut_0_us/en><NNeut_0_us/era><NNeut_0_us/ora><NNeut_0_x> \
                    <NNeut_ens_en><NNeut_es_$e><NNeut_es_$er><NNeut_es_e> \
                    <NNeut_es_e~ss><NNeut_es_en><NNeut_es_er><NNeut_es_es> \
                    <NNeut_es_ien><NNeut_es_s><NNeut_s_$><NNeut_s_$er> \
                    <NNeut_s_0><NNeut_s_a><NNeut_s_a/ata><NNeut_s_a/en> \
                    <NNeut_s_e><NNeut_s_e/i><NNeut_s_en><NNeut_s_en/ina> \
                    <NNeut_s_ien><NNeut_s_n><NNeut_s_nen><NNeut_s_o/en> \
                    <NNeut_s_o/i><NNeut_s_on/a><NNeut_s_on/en><NNeut_s_s> \
                    <NNeut_s_um/a><NNeut_s_um/en><NNeut_s_x><NNoGend/Pl_0> \
                    <NNoGend/Pl_x>

#Name-inflection# = <Name-Fam_0><Name-Fam_s><NameFem_0><NameFem_apos><NameFem_s> \
                    <NameMasc_0><NameMasc_apos><NameMasc_es><NameMasc_s> \
                    <NameNeut_0><NameNeut_apos><NameNeut_es><NameNeut_s> \
                    <NameNoGend/Pl_0><NameNoGend/Pl_x>

#Num-inflection# = <Card0><Card-ein><Card-kein><Card-sieben><Card-vier> \
                   <Card-zwei><DigCard><DigFrac><DigOrd><Frac0><Ord><Roman>

#Pro-inflection# = <ArtDef-das+DemNeut><ArtDef-dem+DemMasc><ArtDef-dem+DemNeut> \
                   <ArtDef-den+DemMasc><ArtDef-den+DemNoGend><ArtDef-der+DemFem> \
                   <ArtDef-der+DemMasc><ArtDef-der+DemNoGend> \
                   <ArtDef-des+DemMasc><ArtDef-des+DemNeut><ArtDef-die+DemFem> \
                   <ArtDef-die+DemNoGend><Dem><Dem0><Dem-alldem><Dem-dies> \
                   <Dem-solch><DemDef><Indef0><Indef-all><Indef-beid><Indef-ein> \
                   <Indef-einig><Indef-irgendein><Indef-irgendwelch><Indef-jed> \
                   <Indef-jeglich><Indef-kein><Indef-manch><Indef-mehrer> \
                   <Indef-saemtlich><Indef-welch><IPro-jedefrau><IPro-jederfrau> \
                   <IPro-jedermann><IPro-frau><IPro-man><IPro-unsereiner> \
                   <IPro-unsereins><IProMasc><IProMascAccSg><IProMascDatSg> \
                   <IProMascGenSg><IProMascNomSg><IProNeut><IProNeutAccSg> \
                   <IProNeutDatSg><IProNeutGenSg><IProNeutNomSg><Poss><Poss-er> \
                   <Poss/Wk><Poss/Wk-er><PPro1AccPl><PPro1AccSg><PPro1DatPl> \
                   <PPro1DatSg><PPro1GenPl><PPro1GenSg><PPro1NomPl><PPro1NomSg> \
                   <PPro2AccPl><PPro2AccSg><PPro2DatPl><PPro2DatSg><PPro2GenPl> \
                   <PPro2GenSg><PPro2NomPl><PPro2NomSg><PProFemAccSg> \
                   <PProFemDatSg><PProFemGenSg><PProFemNomSg><PProMascAccSg> \
                   <PProMascDatSg><PProMascGenSg><PProMascNomSg><PProNeutAccSg> \
                   <PProNeutAccSg-s><PProNeutDatSg><PProNeutGenSg> \
                   <PProNeutNomSg><PProNeutNomSg-s><PProNoGendAccPl> \
                   <PProNoGendDatPl><PProNoGendGenPl><PProNoGendNomPl><PRecPl> \
                   <PRefl1AccSg><PRefl1DatSg><PRefl2AccSg><PRefl2DatSg> \
                   <PRefl1Pl><PRefl2Pl><PRefl3><Rel><Rel-welch><RProMascAccSg> \
                   <RProMascDatSg><RProMascGenSg><RProMascNomSg><RProNeutAccSg> \
                   <RProNeutDatSg><RProNeutGenSg><RProNeutNomSg><W-welch> \
                   <WProMascAccSg><WProMascDatSg><WProMascGenSg><WProMascNomSg> \
                   <WProNeutAccSg><WProNeutDatSg><WProNeutGenSg><WProNeutNomSg>

#Verb-inflection# = <VImp><VImp-d-t><VImp-el-er><VImp-len><VImp-m-n><VImpPl> \
                    <VImpPl-sein><VImpSg><VImpSg0><VInf><VInf-el-er><VInf-len> \
                    <VInf_n><VModPresIndSg><VModPresNonIndSg><VPastInd-d-t_t> \
                    <VPastInd-len><VPastInd-werden><VPastIndPl-werden> \
                    <VPastIndSg-ward><VPastIndStr><VPastIndStr-s><VPastIndWeak> \
                    <VPastStr><VPastStr-s><VPastSubj-haben><VPastSubj-len> \
                    <VPastSubj2-sein><VPastSubjOld><VPastSubjStr><VPastSubjWeak> \
                    <VPPast-d_t><VPPast-len><VPPast_n><VPPastStr><VPPastWeak> \
                    <VPPres><VPPres-el-er><VPPres-len><VPres><VPres-el-er> \
                    <VPres-len><VPres-m-n><VPres-s><VPres-tun> \
                    <VPresInd13Pl-sein><VPresInd1Sg-sein><VPresInd23Sg> \
                    <VPresInd23Sg-d_t><VPresInd23Sg-t_0><VPresInd2Pl-sein> \
                    <VPresInd2Sg-sein><VPresInd2Sg-werden><VPresInd3Sg-sein> \
                    <VPresInd3Sg-werden><VPresNonInd23Sg><VPresSubj-sein><VWeak> \
                    <VWeak-d-t><VWeak-el-er><VWeak-len><VWeak-m-n><VWeak-s>

#Other-inflection# = <ConjCompar><ConjCoord><ConjInf><ConjSub><Intj><PIndInvar> \
                     <Postp><Prep><Prep+Art-m><Prep+Art-n><Prep+Art-r> \
                     <Prep+Art-s><ProAdv><PtclAdj><PtclNeg><Ptcl-zu><VPart> \
                     <WAdv>

#inflection# = #Abbr-inflection# #Adj-inflection# #Adv-inflection# \
               #Art-inflection# #Noun-inflection# #Name-inflection# \
               #Num-inflection# #Pro-inflection# #Verb-inflection# \
               #Other-inflection#
