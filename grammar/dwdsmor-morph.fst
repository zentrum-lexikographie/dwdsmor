% dwdsmor-morph.fst
% Version 9.4
% Andreas Nolda 2025-07-18

#include "symbols.fst"
#include "num.fst"
#include "stemtype.fst"
#include "wf.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "sep.fst"
#include "trunc.fst"
#include "orth.fst"
#include "punct.fst"
#include "cleanup.fst"


% lexicon

$LEX$ = "lex.txt"


% numbers

$LEX$ = $LEX$ | $NUM$


% levels

% use surface level of derivation stems and compounding stems
% also for their analysis level
$LEX$ = ( $LEX$ || $BaseStemFilter$) | \
        (^$LEX$ || $DerStemFilter$)  | \
        (^$LEX$ || $CompStemFilter$)


% cleanup of level-specific symbols

$LEX$ = $CleanupInflLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$ || $CleanupOrth$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$
$DerStems$  = $LEX$ || $DerStemFilter$
$CompStems$ = $LEX$ || $CompStemFilter$


% word formation

% derived numeral base stems with affixes

$DerStemsCard2-zig$ = $DerStems$ || $DerStemFilterCard2-zig$

$DerBaseStemsCard20$ = $DerStemsCard2-zig$ <DB> $DerSuff-zig$ || $DerNumFilter$

$CompStemsCard20$ =  $DerBaseStemsCard20$ || $Base2CompStem$
$CompStemsCard20$ = ^$CompStemsCard20$

$DerStemsCard20-st$ =  $DerBaseStemsCard20$ || $Base2DerStem-st$
$DerStemsCard20-st$ = ^$DerStemsCard20-st$

$BaseStems$ = $BaseStems$ | $DerBaseStemsCard20$

$DerStemsCard2-st$    = $DerStems$ || $DerStemFilterCard2-st$
$DerStemsCard10-st$   = $DerStems$ || $DerStemFilterCard10-st$
$DerStemsCard100-st$  = $DerStems$ || $DerStemFilterCard100-st$
$DerStemsCard1000-st$ = $DerStems$ || $DerStemFilterCard1000-st$

$DerBaseStemsOrd2$    = $DerStemsCard2-st$    <DB> $DerSuff-st$ || $DerNumFilter$
$DerBaseStemsOrd10$   = $DerStemsCard10-st$   <DB> $DerSuff-st$ || $DerNumFilter$
$DerBaseStemsOrd20$   = $DerStemsCard20-st$   <DB> $DerSuff-st$ || $DerNumFilter$
$DerBaseStemsOrd100$  = $DerStemsCard100-st$  <DB> $DerSuff-st$ || $DerNumFilter$
$DerBaseStemsOrd1000$ = $DerStemsCard1000-st$ <DB> $DerSuff-st$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsOrd2$ | $DerBaseStemsOrd10$ | $DerBaseStemsOrd20$ | $DerBaseStemsOrd100$ | $DerBaseStemsOrd1000$

% numeral compounds

$BaseStemsCard1a$ = $BaseStemFilterCard1aLv2$ || $BaseStems$
$BaseStemsOrd1$   = $BaseStemFilterOrd1Lv2$   || $BaseStems$

$BaseStemsCard1b$   = $BaseStems$ || $BaseStemFilterCard1b$
$BaseStemsCard10$   = $BaseStems$ || $BaseStemFilterCard10$
$BaseStemsOrd10$    = $BaseStems$ || $BaseStemFilterOrd10$
$BaseStemsCard11$   = $BaseStems$ || $BaseStemFilterCard11$
$BaseStemsCard100$  = $BaseStems$ || $BaseStemFilterCard100$
$BaseStemsOrd100$   = $BaseStems$ || $BaseStemFilterOrd100$
$BaseStemsCard1000$ = $BaseStems$ || $BaseStemFilterCard1000$
$BaseStemsOrd1000$  = $BaseStems$ || $BaseStemFilterOrd1000$

$CompStemsCard1c$   = $CompStems$ || $CompStemFilterCard1c$
$CompStemsCard3$    = $CompStems$ || $CompStemFilterCard3$
$CompStemsCard100$  = $CompStems$ || $CompStemFilterCard100$
$CompStemsCard1000$ = $CompStems$ || $CompStemFilterCard1000$

$CompStemsCard10$ =  $BaseStemsCard10$ || $Base2CompStem$
$CompStemsCard11$ =  $BaseStemsCard11$ || $Base2CompStem$
$CompStemsCard10$ = ^$CompStemsCard10$
$CompStemsCard11$ = ^$CompStemsCard11$

$CompBaseStemsCard13$ = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsCard10$ || $CompNumFilter$
$CompBaseStemsOrd13$  = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsOrd10$  || $CompNumFilter$

$CompStemsCard13$ =  $CompBaseStemsCard13$ || $Base2CompStem$
$CompStemsCard13$ = ^$CompStemsCard13$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard13$ | $CompBaseStemsOrd13$

$CompBaseStemsCard21$ = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsCard20$ || $CompNumFilter$
$CompBaseStemsOrd21$  = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsOrd20$  || $CompNumFilter$

$CompStemsCard21$ =  $CompBaseStemsCard21$ || $Base2CompStem$
$CompStemsCard21$ = ^$CompStemsCard21$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard21$ | $CompBaseStemsOrd21$

$CompBaseStemsCard200$ = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompNumFilter$
$CompBaseStemsOrd200$  = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsOrd100$  || $CompNumFilter$

$CompStemsCard200$ =  $CompBaseStemsCard200$ || $Base2CompStem$
$CompStemsCard200$ = ^$CompStemsCard200$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard200$ | $CompBaseStemsOrd200$

$CompBaseStemsCard1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsCard100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompNumFilter$
$CompBaseStemsOrd1100$  = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsOrd100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsOrd100$ || $CompNumFilter$

$CompStemsCard1100$ =  $CompBaseStemsCard1100$ || $Base2CompStem$
$CompStemsCard1100$ = ^$CompStemsCard1100$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1100$ | $CompBaseStemsOrd1100$

$BaseStemsCard1-99$ = $BaseStemsCard1a$     | \
                      $BaseStemsCard1b$     | \
                      $BaseStemsCard10$     | \
                      $BaseStemsCard11$     | \
                      $CompBaseStemsCard13$ | \
                      $DerBaseStemsCard20$  | \
                      $CompBaseStemsCard21$
$BaseStemsOrd1-99$  = $BaseStemsOrd1$      | \
                      $DerBaseStemsOrd2$   | \
                      $DerBaseStemsOrd10$  | \
                      $CompBaseStemsOrd13$ | \
                      $DerBaseStemsOrd20$  | \
                      $CompBaseStemsOrd21$

$CompBaseStemsCard101$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$
$CompBaseStemsOrd101$  = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard101$ | $CompBaseStemsOrd101$

$CompStemsCard101$ =  $CompBaseStemsCard101$ || $Base2CompStem$
$CompStemsCard101$ = ^$CompStemsCard101$

$CompBaseStemsCard201$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$
$CompBaseStemsOrd201$  = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard201$ | $CompBaseStemsOrd201$

$CompStemsCard201$ =  $CompBaseStemsCard201$ || $Base2CompStem$
$CompStemsCard201$ = ^$CompStemsCard201$

$CompBaseStemsCard1101$ = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$
$CompBaseStemsOrd1101$  = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1101$ | $CompBaseStemsOrd1101$

$CompStemsCard1-999$ = $CompStemsCard1c$  | \
                       $CompStemsCard10$  | \
                       $CompStemsCard11$  | \
                       $CompStemsCard13$  | \
                       $CompStemsCard20$  | \
                       $CompStemsCard21$  | \
                       $CompStemsCard100$ | \
                       $CompStemsCard101$ | \
                       $CompStemsCard200$ | \
                       $CompStemsCard201$

$CompBaseStemsCard2000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsCard1000$ || $CompNumFilter$
$CompBaseStemsOrd2000$  = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsOrd1000$ || $CompNumFilter$

$CompStemsCard2000$ =  $CompBaseStemsCard2000$ || $Base2CompStem$
$CompStemsCard2000$ = ^$CompStemsCard2000$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard2000$ | $CompBaseStemsOrd2000$

$BaseStemsCard1-999$ = $BaseStemsCard1-99$    | \
                       $CompBaseStemsCard200$ | \
                       $CompBaseStemsCard201$
$BaseStemsOrd1-999$  = $BaseStemsOrd1-99$    | \
                       $CompBaseStemsOrd200$ | \
                       $CompBaseStemsOrd201$

$CompBaseStemsCard1001$ = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsCard1-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsCard1-999$ || $CompNumFilter$
$CompBaseStemsOrd1001$  = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsOrd1-999$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1001$ | $CompBaseStemsOrd1001$

$CompBaseStemsCard2001$ = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsCard1-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsCard1-999$ || $CompNumFilter$
$CompBaseStemsOrd2001$  = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsOrd1-999$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard2001$ | $CompBaseStemsOrd2001$

% derived base stems with preverbs

$DerBaseStemsPrev$ = $DerPrev$ <VB> $BaseStems$ || $DerFilter$

$DerBaseStemsPrev$ = $DerFilterLv2$ || $DerBaseStemsPrev$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPrev$

% converted base stems

$BaseStemsV$ = $BaseStems$ || $BaseStemFilterV$

$BaseStemsV$ = $BaseStemsV$ || $CleanupWF$

$BaseStemsV$ = $BaseStemsV$ $INFL$ || $InflFilter$

$BaseStemsVInfNonCl$ = $BaseStemFilterVInfNonClLv2$ || $BaseStemsV$
$BaseStemsVPartPres$ = $BaseStemFilterVPartPresLv2$ || $BaseStemsV$
$BaseStemsVPartPerf$ = $BaseStemFilterVPartPerfLv2$ || $BaseStemsV$

$BaseStemsVInfNonCl$ = $CleanupCatLv2$ || $BaseStemsVInfNonCl$
$BaseStemsVPartPres$ = $CleanupCatLv2$ || $BaseStemsVPartPres$
$BaseStemsVPartPerf$ = $CleanupCatLv2$ || $BaseStemsVPartPerf$

$BaseStemsVInfNonCl$ = $BaseStemsVInfNonCl$ || $MarkerGe$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerGe$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerGe$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerZu$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerPartConv$

$BaseStemsVInfNonCl$ = <>:<WB> $BaseStemsVInfNonCl$ <>:<WB>
$BaseStemsVPartPres$ = <>:<WB> $BaseStemsVPartPres$ <>:<WB>
$BaseStemsVPartPerf$ = <>:<WB> $BaseStemsVPartPerf$ <>:<WB>

$BaseStemsVInfNonCl$ = $BaseStemsVInfNonCl$ || $PHON$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $PHON$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $PHON$

$BaseStemsVInfNonCl$ = $BaseStemsVInfNonCl$ || $MarkerWB$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerWB$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerWB$

$BaseStemsVInfNonCl$ = ^$BaseStemsVInfNonCl$
$BaseStemsVPartPres$ = ^$BaseStemsVPartPres$
$BaseStemsVPartPerf$ = ^$BaseStemsVPartPerf$

$BaseStemsVPartPerf_t$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf_t$
$BaseStemsVPartPerf_n$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf_n$
$BaseStemsVPartPerf_d$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf_d$

$ConvBaseStemsV$ = <uc> $BaseStemsVInfNonCl$   $ConvInfNonCl$   | \
                        $BaseStemsVPartPres$   $ConvPartPres$   | \
                        $BaseStemsVPartPerf_t$ $ConvPartPerf_t$ | \
                        $BaseStemsVPartPerf_n$ $ConvPartPerf_n$ | \
                        $BaseStemsVPartPerf_d$ $ConvPartPerf_d$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStemsV$

$BaseStemsADJ$ = $BaseStems$ || $BaseStemFilterADJ$
$BaseStemsORD$ = $BaseStems$ || $BaseStemFilterORD$

$BaseStemsADJ$ = $BaseStemsADJ$ || $CleanupWF$
$BaseStemsORD$ = $BaseStemsORD$ || $CleanupWF$

$BaseStemsADJ$ = $BaseStemsADJ$ $INFL$ || $InflFilter$
$BaseStemsORD$ = $BaseStemsORD$ $INFL$ || $InflFilter$

$BaseStemsADJMasc$ = $BaseStemFilterADJMascLv2$ || $BaseStemsADJ$
$BaseStemsADJNeut$ = $BaseStemFilterADJNeutLv2$ || $BaseStemsADJ$
$BaseStemsADJFem$  = $BaseStemFilterADJFemLv2$  || $BaseStemsADJ$
$BaseStemsORDMasc$ = $BaseStemFilterORDMascLv2$ || $BaseStemsORD$
$BaseStemsORDNeut$ = $BaseStemFilterORDNeutLv2$ || $BaseStemsORD$
$BaseStemsORDFem$  = $BaseStemFilterORDFemLv2$  || $BaseStemsORD$

$BaseStemsADJMasc$ = $CleanupCatLv2$ || $BaseStemsADJMasc$
$BaseStemsADJNeut$ = $CleanupCatLv2$ || $BaseStemsADJNeut$
$BaseStemsADJFem$  = $CleanupCatLv2$ || $BaseStemsADJFem$
$BaseStemsORDMasc$ = $CleanupCatLv2$ || $BaseStemsORDMasc$
$BaseStemsORDNeut$ = $CleanupCatLv2$ || $BaseStemsORDNeut$
$BaseStemsORDFem$  = $CleanupCatLv2$ || $BaseStemsORDFem$

$BaseStemsADJMasc$ = <>:<WB> $BaseStemsADJMasc$ <>:<WB>
$BaseStemsADJNeut$ = <>:<WB> $BaseStemsADJNeut$ <>:<WB>
$BaseStemsADJFem$  = <>:<WB> $BaseStemsADJFem$  <>:<WB>
$BaseStemsORDMasc$ = <>:<WB> $BaseStemsORDMasc$ <>:<WB>
$BaseStemsORDNeut$ = <>:<WB> $BaseStemsORDNeut$ <>:<WB>
$BaseStemsORDFem$  = <>:<WB> $BaseStemsORDFem$  <>:<WB>

$BaseStemsADJMasc$ = $BaseStemsADJMasc$ || $PHON$
$BaseStemsADJNeut$ = $BaseStemsADJNeut$ || $PHON$
$BaseStemsADJFem$  = $BaseStemsADJFem$  || $PHON$
$BaseStemsORDMasc$ = $BaseStemsORDMasc$ || $PHON$
$BaseStemsORDNeut$ = $BaseStemsORDNeut$ || $PHON$
$BaseStemsORDFem$  = $BaseStemsORDFem$  || $PHON$

$BaseStemsADJMasc$ = $BaseStemsADJMasc$ || $MarkerWB$
$BaseStemsADJNeut$ = $BaseStemsADJNeut$ || $MarkerWB$
$BaseStemsADJFem$  = $BaseStemsADJFem$  || $MarkerWB$
$BaseStemsORDMasc$ = $BaseStemsORDMasc$ || $MarkerWB$
$BaseStemsORDNeut$ = $BaseStemsORDNeut$ || $MarkerWB$
$BaseStemsORDFem$  = $BaseStemsORDFem$  || $MarkerWB$

$BaseStemsADJMasc$ = ^$BaseStemsADJMasc$
$BaseStemsADJNeut$ = ^$BaseStemsADJNeut$
$BaseStemsADJFem$  = ^$BaseStemsADJFem$
$BaseStemsORDMasc$ = ^$BaseStemsORDMasc$
$BaseStemsORDNeut$ = ^$BaseStemsORDNeut$
$BaseStemsORDFem$  = ^$BaseStemsORDFem$

$ConvBaseStemsADJ$ = <uc> $BaseStemsADJMasc$ $ConvMasc$ | \
                     <uc> $BaseStemsADJNeut$ $ConvNeut$ | \
                     <uc> $BaseStemsADJFem$  $ConvFem$  || $ConvFilter$
$ConvBaseStemsORD$ = <uc> $BaseStemsORDMasc$ $ConvMasc$ | \
                     <uc> $BaseStemsORDNeut$ $ConvNeut$ | \
                     <uc> $BaseStemsORDFem$  $ConvFem$  || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStemsADJ$ | $ConvBaseStemsORD$

% derived base stems with affixes

$DerBaseStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $BaseStems$ | \
                          $DerPref-un$ <DB>      $BaseStems$ || $DerFilter$

$DerStemsSuff-e$    = $DerStems$ || $DerStemFilterSuff-e$
$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStemsSuff$ = $DerStemsSuff-e$    <DB> $DerSuff-e$    | \
                     $DerStemsSuff-er$   <DB> $DerSuff-er$   | \
                     $DerStemsSuff-chen$ <DB> $DerSuff-chen$ | \
                     $DerStemsSuff-lein$ <DB> $DerSuff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPref$ | $DerBaseStemsSuff$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $CompStems$ | \
                          $DerPref-un$ <DB>      $CompStems$ || $DerFilter$

$DerCompStemsPrev$ = $DerPrev$ <VB> $CompStems$ || $DerFilter$

$DerCompStemsPrev$ = $DerFilterLv2$ || $DerCompStemsPrev$

$CompStems$ = $CompStems$ | $DerCompStemsPref$ | $DerCompStemsPrev$

% compounds

$COMP$ = ([<dc><uc>]? $CompStems$ <IB> $Comp-hyph$   <CB> | \
          [<dc><uc>]? $CompStems$      $Comp-concat$ <CB>)+ \
          [<dc><uc>]? $BaseStems$ || $CompFilter$

$LEX$ = $BASE$ | $COMP$


% cleanup of word-formation-related symbols

$LEX$ = $CleanupWFLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = ($LEX$ $INFL$ || $InflFilter$) | \
          ($LEX$        || $NoInflFilter$)


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$
$MORPH$ = $MORPH$ || $MarkerZu$
$MORPH$ = $MORPH$ || $MarkerPart$
$MORPH$ = $MORPH$ || $MarkerImp$


% word-boundary markers

$MORPH$    = <>:<WB>   $MORPH$  <>:<WB>
$MORPHLv2$ = <>:<WB> (_$MORPH$) <>:<WB>


% (morpho)phonology

$MORPH$    = $MORPH$    || $PHON$
$MORPHLv2$ = $MORPHLv2$ || $PHONLv2$

$MORPH$ = (^_$MORPHLv2$) || $MORPH$


% cleanup of word-boundary markers on analysis level

$MORPH$ = $CleanupWBLv2$ || $MORPH$


% preverb separation

$MORPH$ = $MORPH$ | <SEP>:<> ($SepPrev1Lv2$ || $MORPH$ || $SepPrev1$) | \
                    <SEP>:<> ($SepPrev2Lv2$ || $MORPH$ || $SepPrev2$)


% morpheme truncation

$MORPH$ = $MORPH$ | <TRUNC>:<> ($TruncInitialLv2$ || $MORPH$ || $TruncInitial$) | \
                    <TRUNC>:<> ($TruncFinalLv2$   || $MORPH$ || $TruncFinal$)


% old spelling

$MORPH$ = $MORPH$ | <OLDORTH>:<> ($MORPH$ || $OrthOld$)


% cleanup of word-boundary markers

$MORPH$ = $MORPH$ || $CleanupWB$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryLv2$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundaryMorph$


% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexLv2$ || $MORPH$


% Swiss spelling

$MORPH$ = $MORPH$ | <CH>:<> ($NoOrthOldFilterLv2$ || $MORPH$ || $OrthCH$)


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $OrthCap$)


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% the resulting automaton

$MORPH$
