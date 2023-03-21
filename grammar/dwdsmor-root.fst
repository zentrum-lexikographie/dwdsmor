% dwdsmor-root.fst
% Version 3.0
% Andreas Nolda 2023-03-21

#include "symbols.fst"
#include "num.fst"
#include "stemtype.fst"
#include "wf.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "punct.fst"
#include "cap.fst"
#include "cleanup.fst"


% lexicon

$LEX$ = "dwds.lex"


% numbers

$LEX$ = $LEX$ | $NUM$


% cleanup of level-specific symbols

$LEX$ = $CleanupInflAnalysis$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$
$DerStems$  = $LEX$ || $DerStemFilter$
$CompStems$ = $LEX$ || $CompStemFilter$

$BaseStemsDC$ = $BaseStems$ || $StemDC$
$DerStemsDC$  = $DerStems$  || $StemDC$
$CompStemsDC$ = $CompStems$ || $StemDC$


% word formation

% morpheme-boundary triggers

$CompBreakNone$ = <CB>:<^none>
$CompBreakHyph$ = <CB>:<^hyph>

% affixes

$Pref-un$   = <Prefix> {}:{un}
$PrefUC-un$ = <Prefix> {}:{Un}

$Suff-chen$ = <Suffix> {}:{chen} <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> {}:{lein} <NN> <base> <native> <>:<NNeut_s_x>

% processes and means

$Comp-concat$ = <COMP>:<> <concat>:<>
$Comp-hyph$   = <COMP>:<> <hyph>:<>

$DerPref-un$   = <DER>:<> <pref(un)>:<>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<>

% derived base stems

$DerStemsDim$  = $DerStems$ || $DerStemDimFilter$

$DerBaseStems$ = $Pref-un$   $BaseStems$   $DerPref-un$   | \
                 $PrefUC-un$ $BaseStemsDC$ $DerPref-un$   | \
                 $DerStemsDim$ $Suff-chen$ $DerSuff-chen$ | \
                 $DerStemsDim$ $Suff-lein$ $DerSuff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$DerBaseStemsDC$ = $DerBaseStems$ || $StemDC$

$BaseStemsDC$ = $BaseStemsDC$ | $DerBaseStemsDC$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $Pref-un$ $CompStems$ $DerPref-un$ | $PrefUC-un$ $CompStemsDC$ $DerPref-un$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

$DerCompStemsDC$ = $DerCompStems$ || $StemDC$

$CompStemsDC$ = $CompStemsDC$ | $DerCompStemsDC$

% compounds

$COMP$ = $CompStems$ \
         ($CompBreakHyph$ $CompStems$ $Comp-hyph$ | $CompBreakNone$ $CompStemsDC$ $Comp-concat$)* \
         ($CompBreakHyph$ $BaseStems$ $Comp-hyph$ | $CompBreakNone$ $BaseStemsDC$ $Comp-concat$) || $CompFilter$

$LEX$ = $BASE$ | $COMP$


% cleanup of word-formation-related symbols

$LEX$ = $CleanupWFAnalysis$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$

$MORPH$ = $MORPH$ || $MarkerZu$

$MORPH$ = $MORPH$ || $MarkerImp$


% morpheme-boundary triggers generated from entry types

$MORPH$ = $MORPH$ || $BoundaryTriggers$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryRootAnalysis$ || $MORPH$


% cleanup of orthography-related symbols

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$

% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexAnalysis$ || $MORPH$

% cleanup of morpheme-boundary triggers

$MORPH$ = $MORPH$ || $CleanupBoundary$


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $CAP$)


% the resulting automaton

$MORPH$
