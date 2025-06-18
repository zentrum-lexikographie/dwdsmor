% dwdsmor-root.fst
% Version 11.0
% Andreas Nolda 2025-06-18

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

% derived base stems with preverbs

$DerBaseStemsPrev$ = $DerPrev$ <VB> $BaseStems$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPrev$

% converted base stems

$BaseStemsV$ = $BaseStems$ || $BaseStemFilterV$

$BaseStemsV$ = $BaseStemsV$ || $CleanupWF$

$BaseStemsV$ = $BaseStemsV$ $INFL$ || $InflFilter$

$BaseStemsVPartPres$ = $BaseStemFilterVPartPresLv2$ || $BaseStemsV$
$BaseStemsVPartPerf$ = $BaseStemFilterVPartPerfLv2$ || $BaseStemsV$

$BaseStemsVPartPres$ = $CleanupCatLv2$ || $BaseStemsVPartPres$
$BaseStemsVPartPerf$ = $CleanupCatLv2$ || $BaseStemsVPartPerf$

$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerGe$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerGe$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerZu$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerPartConv$

$BaseStemsVPartPres$ = <>:<WB> $BaseStemsVPartPres$ <>:<WB>
$BaseStemsVPartPerf$ = <>:<WB> $BaseStemsVPartPerf$ <>:<WB>

$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $PHON$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $PHON$

$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerWB$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerWB$

$BaseStemsVPartPerf_t$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf_t$
$BaseStemsVPartPerf_n$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf_n$
$BaseStemsVPartPerf_d$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf_d$

$ConvBaseStems$ = $BaseStemsVPartPres$   $ConvPartPres$   | \
                  $BaseStemsVPartPerf_t$ $ConvPartPerf_t$ | \
                  $BaseStemsVPartPerf_n$ $ConvPartPerf_n$ | \
                  $BaseStemsVPartPerf_d$ $ConvPartPerf_d$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStems$

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

$CompStems$ = $CompStems$ | $DerCompStemsPref$ | $DerCompStemsPrev$

% compounds

$COMP$ = ([<dc><uc>]? $CompStems$ $Comp-concat$   <CB> | \
          [<dc><uc>]? $CompStems$ $Comp-hyph$ <HB><CB>)+ \
          [<dc><uc>]? $BaseStems$ || $CompFilter$

$LEX$ = $BASE$ | $COMP$


% cleanup of word-formation-related forms and symbols

$LEX$ = $CleanupAffRootLv2$ || $LEX$

$LEX$ = $CleanupWFRootLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$
$MORPH$ = $MORPH$ || $MarkerZu$
$MORPH$ = $MORPH$ || $MarkerPart$
$MORPH$ = $MORPH$ || $MarkerImp$


% word-boundary markers

$MORPH$ = <>:<WB> $MORPH$ <>:<WB>


% (morpho)phonology

$MORPH$ = $MORPH$ || $PHON$


% preverb separation

$MORPH$ = $MORPH$ | <SEP>:<> ($SepPrev1RootLv2$ || $MORPH$ || $SepPrev1$) | \
                    <SEP>:<> ($SepPrev2RootLv2$ || $MORPH$ || $SepPrev2$)


% morpheme truncation

$MORPH$ = $MORPH$ | <TRUNC>:<> ($TruncInitialRootLv2$ || $MORPH$ || $TruncInitial$) | \
                    <TRUNC>:<> ($TruncFinalLv2$       || $MORPH$ || $TruncFinal$)


% old spelling

$MORPH$ = $MORPH$ | <OLDORTH>:<> ($MORPH$ || $OrthOld$)


% cleanup of word-boundary markers

$MORPH$ = $MORPH$ || $CleanupWB$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryRootLv2$ || $MORPH$

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
