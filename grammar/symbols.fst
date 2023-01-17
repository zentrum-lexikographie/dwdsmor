% symbols.fst
% Version 4.3
% Andreas Nolda 2023-01-17

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#entry-type# = <Stem><Suffix><Prefix>

#uppercase# = A-ZÀ-ÖØ-Þẞ % ...

#lowercase# = a-zßà-öø-ÿſ % ...

#num# = 0-9

#frac# = ½⅓⅔¼¾⅕⅖⅗⅘⅙⅚⅐⅛⅜⅝⅞⅑⅒ % ...

#symbol# = \%&*§°† % ...

#punctcomma# = \,

#punctperiod# = \.\?\!\:;

#punctellip# = … % ...

#punctquote# = \"\'„“‚‘»«›‹ % ...

#punctparen# = \(\)\[\] % ...

#punctdash# = \-– % ...

#punctslash# = / % ...

#punctother# = ’ % ...

#punct# = #punctcomma# #punctperiod# #punctellip# #punctquote# #punctparen# #punctdash# \
          #punctslash# #punctother#

#char# = #uppercase# #lowercase# #num# #frac# #symbol# #punct#

#orth-trigger# = <OLDORTH>

#ss-trigger# = <SS><SSalt>

#phon-trigger# = <INS-E><FB><WB><CB><^Ax><^Px><^Gen><^Del><^pl>

#surface-trigger# = <~n><d><e><er><n>

#deko-trigger# = <NoPref><Abbr>

#morpheme-boundary# = <\~><\=><#><+>

#wf-process# = <COMP><DER>

#wf-means# = <concat><hyph><pref(un)>

#category# = <ABBR><ADJ><ADV><ART><CARD><DEM><FRAC><INDEF><NN><NPROP><ORD><OTHER><POSS> \
             <PPRO><PRO><REL><V><WPRO>

#auxiliary# = <haben><sein>

#part-of-speech# = <+ADJ><+ADV><+ART><+CARD><+CHAR><+CIRCP><+DEM><+FRAC><+INDEF> \
                   <+INTJ><+PUNCT><+CONJ><+NPROP><+NN><+ORD><+POSS><+POSTP><+PPRO> \
                   <+PREPART><+PREP><+PROADV><+PTCL><+REL><+SYMBOL><+TRUNC><+V> \
                   <+VPART><+WADV><+WPRO>

#subcat# = <Pers><Refl><Def><Indef><Neg><Coord><Sub><Compar><Adv><ProAdv><Adj><Ant> \
           <Comma><Dash><Ellip><Paren><Period><Quote><Slash>

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

#orthinfo# = <CAP>

#metainfo# = <NonSt><Old>

#dummy# = <Lemma>

#feature# = #wf-process# #wf-means# #category# #auxiliary# #part-of-speech# #subcat# \
            #degree# #person# #gender# #case# #number# #infl# #function# #nonfinite# \
            #mood# #tense# #orthinfo# #metainfo# #dummy#

#stemtype# = <base><comp>

#origin# = <nativ><fremd><klassisch>

#lemma-index# = <IDX1><IDX2><IDX3><IDX4><IDX5>

#paradigm-index# = <PAR1><PAR2><PAR3><PAR4><PAR5>

#Abk-inflection# = <Abk_POSS>

#Adj-inflection# = <Adj$><Adj$e><Adj+><Adj+(e)><Adj+e><Adj+Lang><Adj-el/er><AdjComp> \
                   <AdjComp0-mehr><AdjPos0><AdjPos0-viel><AdjPos0Attr><AdjPos0AttrSubst> \
                   <AdjPos><AdjPosAttr><AdjPosPred><AdjSup><AdjSup-aller><Adj~$e><Adj~+e>

#Adv-inflection# = <Adv><AdvComp><AdvComp0><AdvSup>

#Art-inflection# = <ArtDef><ArtIndef><ArtIndef-n><ArtNeg>

#Noun-inflection# = <N?/Pl_0><N?/Pl_x><NFem-Adj><NFem-a/en><NFem-in><NFem-is/en> \
                    <NFem-is/iden><NFem-s/$sse><NFem-s/sse><NFem-s/ssen><NFem/Pl_x> \
                    <NFem/Sg_0><NFem_0_$><NFem_0_$e><NFem_0_$en><NFem_0_e><NFem_0_en> \
                    <NFem_0_es><NFem_0_n><NFem_0_s><NFem_0_x><NMasc-Adj><NMasc-as/anten> \
                    <NMasc-as0/anten><NMasc-ns><NMasc-o/en><NMasc-o/i><NMasc-s/$sse> \
                    <NMasc-s/Sg><NMasc-s/sse><NMasc-s0/sse><NMasc-us/e><NMasc-us/en> \
                    <NMasc-us0/en><NMasc-us/i><NMasc-us0/i><NMasc/Pl_0><NMasc/Pl_x> \
                    <NMasc/Sg_0><NMasc/Sg_es><NMasc/Sg_s><NMasc_0_nen><NMasc_0_s> \
                    <NMasc_0_x><NMasc_en_en><NMasc_es_$e><NMasc_es_$er><NMasc_es_er> \
                    <NMasc_es_e><NMasc_es_en><NMasc_es_es><NMasc_es_s><NMasc_n_n><NMasc_s_$> \
                    <NMasc_s_$x><NMasc_s_0><NMasc_s_e><NMasc_s_$e><NMasc_s_en><NMasc_s_er> \
                    <NMasc_s_$er><NMasc_s_n><NMasc_s_nen><NMasc_s_s><NMasc_s_x><NNeut-Adj> \
                    <NNeut-Adj/Sg><NNeut-Herz><NNeut-Inner><NNeut-a/ata><NNeut-a/en> \
                    <NNeut-en/ina><NNeut-o/en><NNeut-o/i><NNeut-on/a><NNeut-on/en> \
                    <NNeut-s/$sser><NNeut-s/sse><NNeut-um/a><NNeut-um/en><NNeut-us0/en> \
                    <NNeut/Pl_x><NNeut/Sg_0><NNeut/Sg_es><NNeut/Sg_s><NNeut/Sg_sses> \
                    <NNeut_0_nen><NNeut_0_s><NNeut_0_x><NNeut_es_$e><NNeut_es_$er> \
                    <NNeut_es_e><NNeut_es_en><NNeut_es_er><NNeut_es_es><NNeut_es_s> \
                    <NNeut_s_$><NNeut_s_0><NNeut_s_e><NNeut_s_en><NNeut_s_$er><NNeut_s_ien> \
                    <NNeut_s_n><NNeut_s_nen><NNeut_s_s><NNeut_s_x><NTrunc>

#Name-inflection# = <Name-Fem_0><Name-Fem_apos><Name-Fem_s><Name-Masc_0> \
                    <Name-Masc_apos><Name-Masc_es><Name-Masc_s><Name-Neut_0> \
                    <Name-Neut_apos><Name-Neut_es><Name-Neut_s><Name-Pl_0> \
                    <Name-Pl_x><FamName_0><FamName_s>

#Num-inflection# = <Card0><Card-ein><Card-kein><Card-sieben><Card-vier><Card-zwei> \
                   <DigCard><DigFrac><DigOrd><Ord><Roman>

#Pro-inflection# = <Dem><Dem-dies><Dem-solch><DemDef><Indef0><Indef-all><Indef-beid> \
                   <Indef-ein><Indef-einig><Indef-irgendein><Indef-irgendwelch> \
                   <Indef-jed><Indef-jeglich><Indef-kein><Indef-manch><Indef-mehrer> \
                   <Indef-saemtlich><Indef-welch><IPro-jedermann><IPro-man><IProMasc> \
                   <IProMascAccSg><IProMascDatSg><IProMascGenSg><IProMascNomSg><IProNeut> \
                   <IProNeutAccSg><IProNeutDatSg><IProNeutGenSg><IProNeutNomSg><Poss> \
                   <Poss-er><Poss/Wk><Poss/Wk-er><PPro1AccPl><PPro1AccSg><PPro1DatPl> \
                   <PPro1DatSg><PPro1GenPl><PPro1GenSg><PPro1NomPl><PPro1NomSg><PPro2AccPl> \
                   <PPro2AccSg><PPro2DatPl><PPro2DatSg><PPro2GenPl><PPro2GenSg><PPro2NomPl> \
                   <PPro2NomSg><PProFemAccSg><PProFemDatSg><PProFemGenSg><PProFemNomSg> \
                   <PProMascAccSg><PProMascDatSg><PProMascGenSg><PProMascNomSg> \
                   <PProNeutAccSg><PProNeutAccSg-s><PProNeutDatSg><PProNeutGenSg> \
                   <PProNeutNomSg><PProNeutNomSg-s><PProNoGendAccPl><PProNoGendDatPl> \
                   <PProNoGendGenPl><PProNoGendNomPl><PRefl1AccSg><PRefl1DatSg><PRefl2AccSg> \
                   <PRefl2DatSg><PRefl1Pl><PRefl2Pl><PRefl3><Rel><Rel-welch><W-welch> \
                   <WProMascAccSg><WProMascDatSg><WProMascGenSg><WProMascNomSg> \
                   <WProNeutAccSg><WProNeutDatSg><WProNeutGenSg><WProNeutNomSg>

#Verb-inflection# = <VAImpPl><VAImpSg><VAPastIndPl><VAPastIndSg><VAPastKonj2> \
                    <VAPres1/3PlInd><VAPres1/3SgKonj><VAPres1SgInd><VAPres2PlInd> \
                    <VAPres2SgInd><VAPres2SgKonj><VAPres3SgInd><VAPresKonjPl> \
                    <VAPresKonjSg><VInf+PPres><VInf><VInf-en><VInf-n><VMPast> \
                    <VMPastKonj><VMPresPl><VMPresSg><VPPast><VPPres><VPastIndIrreg> \
                    <VPastIndReg><VPastIndStr><VPastKonjStr><VPresKonj><VPresPlInd> \
                    <VVPP-en><VVPP-t><VVPastIndReg><VVPastIndStr><VVPastKonjReg> \
                    <VVPastKonjStr><VVPastStr><VVPres1+Imp><VVPres1><VVPres2+Imp0> \
                    <VVPres2+Imp><VVPres2><VVPres2t><VVPres><VVPresPl><VVPresSg> \
                    <VVReg-el/er><VVReg><VVRegFin>

#Other-inflection# = <Circp><Intj><Konj-Inf><Konj-Kon><Konj-Sub><Konj-Vgl><PInd-Invar> \
                     <Postp-Akk><Postp-Dat><Postp-Gen><Pref/Adj><Pref/Adv><Pref/N> \
                     <Pref/ProAdv><Pref/Sep><Pref/V><Prep-Akk><Prep-DA><Prep-Dat><Prep-GD> \
                     <Prep-GDA><Prep-Gen><Prep/Art-m><Prep/Art-n><Prep/Art-r><Prep/Art-s> \
                     <ProAdv><Ptkl-Adj><Ptkl-Ant><Ptkl-Neg><Ptkl-Zu><Trunc><WAdv>

#inflection# = #Abk-inflection# #Adj-inflection# #Adv-inflection# #Art-inflection# \
               #Noun-inflection# #Name-inflection# #Num-inflection# #Pro-inflection# \
               #Verb-inflection# #Other-inflection#
