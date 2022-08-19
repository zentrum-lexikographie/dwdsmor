% symbols.fst
% Version 1.0
% Andreas Nolda 2022-08-19

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#entry-type# = <Stem><Suffix><Prefix>

#deko-trigger# = <NoPref><ge>

#char# = \ -\~¡-ÿ’

#phon-trigger# = <INS-E><FB><WB><CB><^UC><^Ax><^Px><^Gen><^Del><^pl>

#surface-trigger# = <~n><d><e><er><n>

#morpheme_boundary_marker# = <\~><#><\->

#ss-trigger# = <SS><SSalt>

#orth-trigger# = <OLDORTH>

#category#  = <ABBR><ADJ><ADV><ART><CARD><DEM><DIGCARD><INDEF><NN><NPROP> \
              <ORD><OTHER><POSS><PPRO><PRO><REL><V><WPRO>

#auxiliary# = <haben><sein>

#part-of-speech# = <+ADJ><+ADV><+ART><+CARD><+CHAR><+CIRCP><+DEM><+INDEF> \
                   <+INTJ><+PUNCT><+CONJ><+NPROP><+NN><+ORD><+POSS><+POSTP> \
                   <+PPRO><+PREPART><+PREP><+PROADV><+PTCL><+REL><+SYMBOL> \
                   <+TRUNC><+V><+VPART><+WADV><+WPRO>

#case# = <Nom><Gen><Dat><Acc>

#gender# = <Masc><Fem><Neut><NoGend>

#feature# = #orth-trigger# #category# #auxiliary# #part-of-speech# #gender# #case# \
            <1><2><3><Sg><Pl><Def><Indef><St><Wk><NoInfl><Pos><Comp><Sup><Pred> \
            <Attr><Subst><PPres><PPast><Pres><Past><Imp><Ind><Inf><Subj><Pers><Refl> \
            <Sub><Coord><Compar><^ABBR><^VPRES><^VPAST><Neg><Adj><Ant><Adv><ProAdv> \
            <Invar><Lemma><zu>

#stemtype# = <base>

#origin# = <nativ><fremd><klassisch>

#lemma-index# = <IDX1><IDX2><IDX3><IDX4>

#Abk-inflection# = <Abk_POSS>

#Adj-inflection# = <Adj$><Adj$e><Adj&><Adj+(e)><Adj+><Adj+Lang><Adj+e><Adj-el/er> \
                   <Adj0-Up><Adj0><AdjComp><AdjComp0><AdjFlexSuff><AdjNN><AdjNNSuff> \
                   <AdjPos-Up><AdjPos><AdjPosAttr-Up><AdjPosAttr><AdjPosPred> \
                   <AdjPosSup><AdjSup><Adj~$e><Adj~+e>

#Adv-inflection# = <Adv><AdvComp><AdvComp0><AdvSup>

#Art-inflection# = <ArtDef><ArtIndef><ArtIndef-n><ArtNeg>

#Noun-inflection# = <N?/Pl_0><N?/Pl_x><NFem-Adj><NFem-a/en><NFem-in><NFem-is/en> \
                    <NFem-is/iden><NFem-s/$sse><NFem-s/sse><NFem-s/ssen><NFem/Pl_x> \
                    <NFem/Sg_0><NFem_0_$><NFem_0_$e><NFem_0_e><NFem_0_en><NFem_0_n> \
                    <NFem_0_s><NFem_0_x><NMasc-Adj><NMasc-ns><NMasc-s/$sse> \
                    <NMasc-s/Sg><NMasc-s/sse><NMasc-s0/sse><NMasc-o/en><NMasc-o/i> \
                    <NMasc-us/e><NMasc-us/en><NMasc-us/i><NMasc/Pl_0><NMasc/Pl_x> \
                    <NMasc/Sg_0><NMasc/Sg_es><NMasc/Sg_s><NMasc_0_s><NMasc_0_x> \
                    <NMasc_en_en><NMasc_es_$e><NMasc_es_$er><NMasc_es_er> \
                    <NMasc_es_e><NMasc_es_en><NMasc_n_n><NMasc_s_$><NMasc_s_$x> \
                    <NMasc_s_0><NMasc_s_e><NMasc_s_$e><NMasc_s_en><NMasc_s_n> \
                    <NMasc_s_s><NMasc_s_x><NNeut-0/ien><NNeut-Adj><NNeut-Adj/Sg> \
                    <NNeut-Herz><NNeut-Inner><NNeut-a/ata><NNeut-a/en><NNeut-en/ina> \
                    <NNeut-o/en><NNeut-o/i><NNeut-on/a><NNeut-s/$sser><NNeut-s/sse> \
                    <NNeut-um/a><NNeut-um/en><NNeut/Pl_x><NNeut/Sg_0><NNeut/Sg_es> \
                    <NNeut/Sg_sses><NNeut/Sg_s><NNeut_0_s><NNeut_0_x><NNeut_es_$e> \
                    <NNeut_es_$er><NNeut_es_e><NNeut_es_en><NNeut_es_er><NNeut_s_$> \
                    <NNeut_s_0><NNeut_s_e><NNeut_s_en><NNeut_s_n><NNeut_s_s><NNeut_s_x> \
                    <NTrunc>

#Name-inflection# = <Name-Fem_0><Name-Fem_apos><Name-Fem_s><Name-Masc_0> \
                    <Name-Masc_apos><Name-Masc_es><Name-Masc_s><Name-Neut_0> \
                    <Name-Neut_apos><Name-Neut_es><Name-Neut_s><Name-Pl_0> \
                    <Name-Pl_x><FamName_0><FamName_s>

#Num-inflection# = <Card><Card-ein><Card-kein><DigOrd><Ord>

#Pro-inflection# = <Dem><Dem-dies><Dem-solch><DemDef><Indef-all><Indef-ein> \
                   <Indef-einig><Indef-jed><Indef-jedermann><Indef-jeglich> \
                   <Indef-kein><Indef-man><Indef-mehrer><Indef-saemtlich><Indef-welch> \
                   <IndefMasc><IndefNeut><Poss><Poss-er><Poss/Wk><Poss/Wk-er> \
                   <PPro1AccPl><PPro1AccSg><PPro1DatPl><PPro1DatSg><PPro1GenPl> \
                   <PPro1GenSg><PPro1NomPl><PPro1NomSg><PPro2AccPl><PPro2AccSg> \
                   <PPro2DatPl><PPro2DatSg><PPro2GenPl><PPro2GenSg><PPro2NomPl> \
                   <PPro2NomSg><PProFemAccSg><PProFemDatSg><PProFemGenSg><PProFemNomSg> \
                   <PProMascAccSg><PProMascDatSg><PProMascGenSg><PProMascNomSg> \
                   <PProNeutAccSg><PProNeutAccSg-s><PProNeutDatSg><PProNeutGenSg> \
                   <PProNeutNomSg><PProNeutNomSg-s><PProNoGendAccPl><PProNoGendDatPl> \
                   <PProNoGendGenPl><PProNoGendNomPl><PProReflFemSg><PProReflMascSg> \
                   <PProReflNeutSg><PProReflNoGendPl><Rel><Rel-welch><WPro-welch> \
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

#Other-inflection# = <Circp><Intj><IntjUp><Konj-Inf><Konj-Kon><Konj-Sub><Konj-Vgl> \
                     <PInd-Invar><Postp-Akk><Postp-Dat><Postp-Gen><Pref/Adj><Pref/Adv> \
                     <Pref/N><Pref/ProAdv><Pref/Sep><Pref/V><Prep-Akk><Prep-DA> \
                     <Prep-Dat><Prep-GD><Prep-GDA><Prep-Gen><Prep/Art-m><Prep/Art-n> \
                     <Prep/Art-r><Prep/Art-s><ProAdv><Ptkl-Adj><Ptkl-Ant><Ptkl-Neg> \
                     <Ptkl-Zu><Trunc><WAdv>

#inflection# = #Abk-inflection# #Adj-inflection# #Adv-inflection# #Art-inflection# \
               #Noun-inflection# #Name-inflection# #Num-inflection# #Pro-inflection# \
               #Verb-inflection# #Other-inflection#
