% dwdsmor-finite.fst
% Version 18.1
% Andreas Nolda 2025-07-10

#include "symbols.fst"
#include "num-finite.fst"
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

% derived cardinal base stems with affixes

$DerStemsCard2$ = $DerStems$ || $DerStemFilterCard2$

$DerBaseStemsCard20$ = $DerStemsCard2$ <DB> $DerSuff-zig$ || $DerCardFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsCard20$

% cardinal compounds

$BaseStemsCard1a$   = $BaseStems$ || $BaseStemFilterCard1a$
$BaseStemsCard10$   = $BaseStems$ || $BaseStemFilterCard10$
$BaseStemsCard11$   = $BaseStems$ || $BaseStemFilterCard11$
$BaseStemsCard100$  = $BaseStems$ || $BaseStemFilterCard100$

$CompStemsCard1b$   = $CompStems$ || $CompStemFilterCard1b$
$CompStemsCard3$    = $CompStems$ || $CompStemFilterCard3$
$CompStemsCard100$  = $CompStems$ || $CompStemFilterCard100$

$CompStemsCard11$ =  $BaseStemsCard11$ || $Base2CompStem$
$CompStemsCard11$ = ^$CompStemsCard11$

$CompBaseStemsCard13$ = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsCard10$ || $CompCardFilter$

$CompStemsCard13$ =  $CompBaseStemsCard13$ || $Base2CompStem$
$CompStemsCard13$ = ^$CompStemsCard13$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard13$

$CompBaseStemsCard21$ = $CompStemsCard1b$ <IB> $Comp-und$ <CB> $DerBaseStemsCard20$ || $CompCardFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard21$

$CompBaseStemsCard200$ = $CompStemsCard1b$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompCardFilter$

$CompStemsCard200$ =  $CompBaseStemsCard200$ || $Base2CompStem$
$CompStemsCard200$ = ^$CompStemsCard200$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard200$

$CompBaseStemsCard1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsCard100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompCardFilter$

$CompStemsCard1100$ =  $CompBaseStemsCard1100$ || $Base2CompStem$
$CompStemsCard1100$ = ^$CompStemsCard1100$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1100$

$BaseStemsCard1-99$ = $BaseStemsCard1a$     | \
                      $BaseStemsCard10$     | \
                      $BaseStemsCard11$     | \
                      $CompBaseStemsCard13$ | \
                      $DerBaseStemsCard20$  | \
                      $CompBaseStemsCard21$

$CompBaseStemsCard101$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompCardFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard101$

$CompBaseStemsCard201$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompCardFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard201$

$CompBaseStemsCard1101$ = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompCardFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1101$

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

$BaseStemsADJ$ = $BaseStemsADJ$ || $CleanupWF$

$BaseStemsADJ$ = $BaseStemsADJ$ $INFL$ || $InflFilter$

$BaseStemsADJMasc$ = $BaseStemFilterADJMascLv2$ || $BaseStemsADJ$
$BaseStemsADJNeut$ = $BaseStemFilterADJNeutLv2$ || $BaseStemsADJ$
$BaseStemsADJFem$  = $BaseStemFilterADJFemLv2$  || $BaseStemsADJ$

$BaseStemsADJMasc$ = $CleanupCatLv2$ || $BaseStemsADJMasc$
$BaseStemsADJNeut$ = $CleanupCatLv2$ || $BaseStemsADJNeut$
$BaseStemsADJFem$  = $CleanupCatLv2$ || $BaseStemsADJFem$

$BaseStemsADJMasc$ = <>:<WB> $BaseStemsADJMasc$ <>:<WB>
$BaseStemsADJNeut$ = <>:<WB> $BaseStemsADJNeut$ <>:<WB>
$BaseStemsADJFem$  = <>:<WB> $BaseStemsADJFem$  <>:<WB>

$BaseStemsADJMasc$ = $BaseStemsADJMasc$ || $PHON$
$BaseStemsADJNeut$ = $BaseStemsADJNeut$ || $PHON$
$BaseStemsADJFem$  = $BaseStemsADJFem$  || $PHON$

$BaseStemsADJMasc$ = $BaseStemsADJMasc$ || $MarkerWB$
$BaseStemsADJNeut$ = $BaseStemsADJNeut$ || $MarkerWB$
$BaseStemsADJFem$  = $BaseStemsADJFem$  || $MarkerWB$

$BaseStemsADJMasc$ = ^$BaseStemsADJMasc$
$BaseStemsADJNeut$ = ^$BaseStemsADJNeut$
$BaseStemsADJFem$  = ^$BaseStemsADJFem$

$ConvBaseStemsADJ$ = <uc> $BaseStemsADJMasc$ $ConvADJMasc$ | \
                     <uc> $BaseStemsADJNeut$ $ConvADJNeut$ | \
                     <uc> $BaseStemsADJFem$  $ConvADJFem$  || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStemsADJ$

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
          [<dc><uc>]? $CompStems$      $Comp-concat$ <CB>) \
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

$MORPH$ = $MORPH$ || $MarkerBoundary$


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
