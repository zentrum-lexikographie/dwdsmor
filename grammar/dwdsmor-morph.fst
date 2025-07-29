% dwdsmor-morph.fst
% Version 9.6
% Andreas Nolda 2025-07-28

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

$DerStemsCard20-st$   =  $DerBaseStemsCard20$ || $Base2DerStem-st$
$DerStemsCard20-stel$ =  $DerBaseStemsCard20$ || $Base2DerStem-stel$
$DerStemsCard20-st$   = ^$DerStemsCard20-st$
$DerStemsCard20-stel$ = ^$DerStemsCard20-stel$

$BaseStems$ = $BaseStems$ | $DerBaseStemsCard20$

$DerStemsCard2-st$         = $DerStems$ || $DerStemFilterCard2-st$
$DerStemsCard3-stel$       = $DerStems$ || $DerStemFilterCard3-stel$
$DerStemsCard10-st$        = $DerStems$ || $DerStemFilterCard10-st$
$DerStemsCard10-stel$      = $DerStems$ || $DerStemFilterCard10-stel$
$DerStemsCard100-st$       = $DerStems$ || $DerStemFilterCard100-st$
$DerStemsCard100-stel$     = $DerStems$ || $DerStemFilterCard100-stel$
$DerStemsCard1000-st$      = $DerStems$ || $DerStemFilterCard1000-st$
$DerStemsCard1000-stel$    = $DerStems$ || $DerStemFilterCard1000-stel$
$DerStemsCard1000000-st$   = $DerStems$ || $DerStemFilterCard1000000-st$
$DerStemsCard1000000-stel$ = $DerStems$ || $DerStemFilterCard1000000-stel$

$DerBaseStemsOrd2$     = $DerStemsCard2-st$         <DB> $DerSuff-st$   || $DerNumFilter$
$DerBaseStemsFrac3$    = $DerStemsCard3-stel$       <DB> $DerSuff-stel$ || $DerNumFilter$
$DerBaseStemsOrd10$    = $DerStemsCard10-st$        <DB> $DerSuff-st$   || $DerNumFilter$
$DerBaseStemsFrac10$   = $DerStemsCard10-stel$      <DB> $DerSuff-stel$ || $DerNumFilter$
$DerBaseStemsOrd20$    = $DerStemsCard20-st$        <DB> $DerSuff-st$   || $DerNumFilter$
$DerBaseStemsFrac20$   = $DerStemsCard20-stel$      <DB> $DerSuff-stel$ || $DerNumFilter$
$DerBaseStemsOrd100$   = $DerStemsCard100-st$       <DB> $DerSuff-st$   || $DerNumFilter$
$DerBaseStemsFrac100$  = $DerStemsCard100-stel$     <DB> $DerSuff-stel$ || $DerNumFilter$
$DerBaseStemsOrd1000$  = $DerStemsCard1000-st$      <DB> $DerSuff-st$   || $DerNumFilter$
$DerBaseStemsFrac1000$ = $DerStemsCard1000-stel$    <DB> $DerSuff-stel$ || $DerNumFilter$

$DerBaseStemsOrd1000000$  = <dc> $DerStemsCard1000000-st$   <DB> $DerSuff-st$   || $DerNumFilter$
$DerBaseStemsFrac1000000$ = <dc> $DerStemsCard1000000-stel$ <DB> $DerSuff-stel$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsOrd2$ | $DerBaseStemsFrac3$ | \
              $DerBaseStemsOrd10$      | $DerBaseStemsFrac10$   | \
              $DerBaseStemsOrd20$      | $DerBaseStemsFrac20$   | \
              $DerBaseStemsOrd100$     | $DerBaseStemsFrac100$  | \
              $DerBaseStemsOrd1000$    | $DerBaseStemsFrac1000$ | \
              $DerBaseStemsOrd1000000$ | $DerBaseStemsFrac1000000$

% numeral compounds

$BaseStemsCard1a$ = $BaseStemFilterCard1aLv2$ || $BaseStems$
$BaseStemsOrd1$   = $BaseStemFilterOrd1Lv2$   || $BaseStems$

$BaseStemsCard1b$   = $BaseStems$ || $BaseStemFilterCard1b$
$BaseStemsCard10$   = $BaseStems$ || $BaseStemFilterCard10$
$BaseStemsOrd10$    = $BaseStems$ || $BaseStemFilterOrd10$
$BaseStemsFrac10$  = $BaseStems$ || $BaseStemFilterFrac10$
$BaseStemsCard11$  = $BaseStems$ || $BaseStemFilterCard11$
$BaseStemsCard100$ = $BaseStems$ || $BaseStemFilterCard100$
$BaseStemsOrd100$  = $BaseStems$ || $BaseStemFilterOrd100$
$BaseStemsFrac100$ = $BaseStems$ || $BaseStemFilterFrac100$
$BaseStemsCard1000$ = $BaseStems$ || $BaseStemFilterCard1000$
$BaseStemsOrd1000$  = $BaseStems$ || $BaseStemFilterOrd1000$
$BaseStemsFrac1000$ = $BaseStems$ || $BaseStemFilterFrac1000$

$BaseStemsOrd1000000$  = $BaseStems$ || $BaseStemFilterOrd1000000$
$BaseStemsFrac1000000$ = $BaseStems$ || $BaseStemFilterFrac1000000$

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
$CompBaseStemsFrac13$ = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsFrac10$ || $CompNumFilter$

$CompStemsCard13$ =  $CompBaseStemsCard13$ || $Base2CompStem$
$CompStemsCard13$ = ^$CompStemsCard13$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard13$ | $CompBaseStemsOrd13$ | $CompBaseStemsFrac13$

$CompBaseStemsCard21$ = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsCard20$ || $CompNumFilter$
$CompBaseStemsOrd21$  = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsOrd20$  || $CompNumFilter$
$CompBaseStemsFrac21$ = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsFrac20$ || $CompNumFilter$

$CompStemsCard21$ =  $CompBaseStemsCard21$ || $Base2CompStem$
$CompStemsCard21$ = ^$CompStemsCard21$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard21$ | $CompBaseStemsOrd21$ | $CompBaseStemsFrac21$

$CompBaseStemsCard200$ = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompNumFilter$
$CompBaseStemsOrd200$  = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsOrd100$  || $CompNumFilter$
$CompBaseStemsFrac200$ = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsFrac100$ || $CompNumFilter$

$CompStemsCard200$ =  $CompBaseStemsCard200$ || $Base2CompStem$
$CompStemsCard200$ = ^$CompStemsCard200$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard200$ | $CompBaseStemsOrd200$ | $CompBaseStemsFrac200$

$CompBaseStemsCard1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsCard100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompNumFilter$
$CompBaseStemsOrd1100$  = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsOrd100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsOrd100$ || $CompNumFilter$
$CompBaseStemsFrac1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsFrac100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsFrac100$ || $CompNumFilter$

$CompStemsCard1100$ =  $CompBaseStemsCard1100$ || $Base2CompStem$
$CompStemsCard1100$ = ^$CompStemsCard1100$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1100$ | $CompBaseStemsOrd1100$ | $CompBaseStemsFrac1100$

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
$BaseStemsFrac3-99$ = $DerBaseStemsFrac3$   | \
                      $DerBaseStemsFrac10$  | \
                      $CompBaseStemsFrac13$ | \
                      $DerBaseStemsFrac20$  | \
                      $CompBaseStemsFrac21$

$CompBaseStemsCard101$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$
$CompBaseStemsOrd101$  = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$
$CompBaseStemsFrac103$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsFrac3-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard101$ | $CompBaseStemsOrd101$ | $CompBaseStemsFrac103$

$CompStemsCard101$ =  $CompBaseStemsCard101$ || $Base2CompStem$
$CompStemsCard101$ = ^$CompStemsCard101$

$CompBaseStemsCard201$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$
$CompBaseStemsOrd201$  = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$
$CompBaseStemsFrac203$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsFrac3-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard201$ | $CompBaseStemsOrd201$ | $CompBaseStemsFrac203$

$CompStemsCard201$ =  $CompBaseStemsCard201$ || $Base2CompStem$
$CompStemsCard201$ = ^$CompStemsCard201$

$CompBaseStemsCard1101$ = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$
$CompBaseStemsOrd1101$  = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$
$CompBaseStemsFrac1103$  = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-99$ | \
                           $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsFrac3-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1101$ | $CompBaseStemsOrd1101$ | $CompBaseStemsFrac1103$

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
$CompBaseStemsFrac2000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsFrac1000$ || $CompNumFilter$

$CompBaseStemsOrd2000000$  = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsOrd1000000$ || $CompNumFilter$
$CompBaseStemsFrac2000000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsFrac1000000$ || $CompNumFilter$

$CompStemsCard2000$ =  $CompBaseStemsCard2000$ || $Base2CompStem$
$CompStemsCard2000$ = ^$CompStemsCard2000$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard2000$ | \
              $CompBaseStemsOrd2000$ | $CompBaseStemsFrac2000$ | \
              $CompBaseStemsOrd2000000$ | $CompBaseStemsFrac2000000$

$BaseStemsCard1-999$ = $BaseStemsCard1-99$    | \
                       $CompBaseStemsCard200$ | \
                       $CompBaseStemsCard201$
$BaseStemsOrd1-999$  = $BaseStemsOrd1-99$    | \
                       $CompBaseStemsOrd200$ | \
                       $CompBaseStemsOrd201$
$BaseStemsFrac3-999$ = $BaseStemsFrac3-99$    | \
                       $CompBaseStemsFrac200$ | \
                       $CompBaseStemsFrac203$

$CompBaseStemsCard1001$ = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsCard1-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsCard1-999$ || $CompNumFilter$
$CompBaseStemsOrd1001$  = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsOrd1-999$ || $CompNumFilter$
$CompBaseStemsFrac1003$ = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsFrac3-999$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1001$ | $CompBaseStemsOrd1001$ | $CompBaseStemsFrac1003$

$CompBaseStemsCard2001$ = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsCard1-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsCard1-999$ || $CompNumFilter$
$CompBaseStemsOrd2001$  = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsOrd1-999$ || $CompNumFilter$
$CompBaseStemsFrac2003$ = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsFrac3-999$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard2001$ | $CompBaseStemsOrd2001$ | $CompBaseStemsFrac2003$

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

$BaseStemsAdj$  = $BaseStems$ || $BaseStemFilterAdj$
$BaseStemsOrd$  = $BaseStems$ || $BaseStemFilterOrd$
$BaseStemsFrac$ = $BaseStems$ || $BaseStemFilterFrac$

$BaseStemsAdj$  = $BaseStemsAdj$ || $CleanupWF$
$BaseStemsOrd$  = $BaseStemsOrd$ || $CleanupWF$
$BaseStemsFrac$ = $BaseStemsFrac$ || $CleanupWF$

$BaseStemsAdj$  = $BaseStemsAdj$ $INFL$ || $InflFilter$
$BaseStemsOrd$  = $BaseStemsOrd$ $INFL$ || $InflFilter$
$BaseStemsFrac$ = $BaseStemsFrac$ $INFL$ || $InflFilter$

$BaseStemsAdjMasc$  = $BaseStemFilterAdjMascLv2$  || $BaseStemsAdj$
$BaseStemsAdjNeut$  = $BaseStemFilterAdjNeutLv2$  || $BaseStemsAdj$
$BaseStemsAdjFem$   = $BaseStemFilterAdjFemLv2$   || $BaseStemsAdj$
$BaseStemsOrdMasc$  = $BaseStemFilterOrdMascLv2$  || $BaseStemsOrd$
$BaseStemsOrdNeut$  = $BaseStemFilterOrdNeutLv2$  || $BaseStemsOrd$
$BaseStemsOrdFem$   = $BaseStemFilterOrdFemLv2$   || $BaseStemsOrd$
$BaseStemsFrac$     = $BaseStemFilterFracLv2$     || $BaseStemsFrac$

$BaseStemsAdjMasc$  = $CleanupCatLv2$ || $BaseStemsAdjMasc$
$BaseStemsAdjNeut$  = $CleanupCatLv2$ || $BaseStemsAdjNeut$
$BaseStemsAdjFem$   = $CleanupCatLv2$ || $BaseStemsAdjFem$
$BaseStemsOrdMasc$  = $CleanupCatLv2$ || $BaseStemsOrdMasc$
$BaseStemsOrdNeut$  = $CleanupCatLv2$ || $BaseStemsOrdNeut$
$BaseStemsOrdFem$   = $CleanupCatLv2$ || $BaseStemsOrdFem$
$BaseStemsFrac$     = $CleanupCatLv2$ || $BaseStemsFrac$

$BaseStemsAdjMasc$  = <>:<WB> $BaseStemsAdjMasc$ <>:<WB>
$BaseStemsAdjNeut$  = <>:<WB> $BaseStemsAdjNeut$ <>:<WB>
$BaseStemsAdjFem$   = <>:<WB> $BaseStemsAdjFem$  <>:<WB>
$BaseStemsOrdMasc$  = <>:<WB> $BaseStemsOrdMasc$ <>:<WB>
$BaseStemsOrdNeut$  = <>:<WB> $BaseStemsOrdNeut$ <>:<WB>
$BaseStemsOrdFem$   = <>:<WB> $BaseStemsOrdFem$  <>:<WB>
$BaseStemsFrac$     = <>:<WB> $BaseStemsFrac$ <>:<WB>

$BaseStemsAdjMasc$  = $BaseStemsAdjMasc$ || $PHON$
$BaseStemsAdjNeut$  = $BaseStemsAdjNeut$ || $PHON$
$BaseStemsAdjFem$   = $BaseStemsAdjFem$  || $PHON$
$BaseStemsOrdMasc$  = $BaseStemsOrdMasc$ || $PHON$
$BaseStemsOrdNeut$  = $BaseStemsOrdNeut$ || $PHON$
$BaseStemsOrdFem$   = $BaseStemsOrdFem$  || $PHON$
$BaseStemsFrac$     = $BaseStemsFrac$    || $PHON$

$BaseStemsAdjMasc$  = $BaseStemsAdjMasc$ || $MarkerWB$
$BaseStemsAdjNeut$  = $BaseStemsAdjNeut$ || $MarkerWB$
$BaseStemsAdjFem$   = $BaseStemsAdjFem$  || $MarkerWB$
$BaseStemsOrdMasc$  = $BaseStemsOrdMasc$ || $MarkerWB$
$BaseStemsOrdNeut$  = $BaseStemsOrdNeut$ || $MarkerWB$
$BaseStemsOrdFem$   = $BaseStemsOrdFem$  || $MarkerWB$
$BaseStemsFrac$     = $BaseStemsFrac$    || $MarkerWB$

$BaseStemsAdjMasc$  = ^$BaseStemsAdjMasc$
$BaseStemsAdjNeut$  = ^$BaseStemsAdjNeut$
$BaseStemsAdjFem$   = ^$BaseStemsAdjFem$
$BaseStemsOrdMasc$  = ^$BaseStemsOrdMasc$
$BaseStemsOrdNeut$  = ^$BaseStemsOrdNeut$
$BaseStemsOrdFem$   = ^$BaseStemsOrdFem$
$BaseStemsFrac$     = ^$BaseStemsFrac$

$ConvBaseStemsAdj$  = <uc> $BaseStemsAdjMasc$ $ConvAdjMasc$ | \
                      <uc> $BaseStemsAdjNeut$ $ConvAdjNeut$ | \
                      <uc> $BaseStemsAdjFem$  $ConvAdjFem$ || $ConvFilter$
$ConvBaseStemsOrd$  = <uc> $BaseStemsOrdMasc$ $ConvAdjMasc$ | \
                      <uc> $BaseStemsOrdNeut$ $ConvAdjNeut$ | \
                      <uc> $BaseStemsOrdFem$  $ConvAdjFem$ || $ConvFilter$
$ConvBaseStemsFrac$ = <uc> $BaseStemsFrac$    $ConvFrac$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStemsAdj$ | $ConvBaseStemsOrd$ | $ConvBaseStemsFrac$

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
