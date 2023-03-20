% dwdsmor-root.fst
% Version 2.1
% Andreas Nolda 2023-03-20

#include "symbols.fst"
#include "num.fst"
#include "stemtype.fst"
#include "wf.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "disj.fst"
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

% morpheme-boundary markers

$CompBreakNone$ = <+>:<^none>
$CompBreakHyph$ = <+>:<^hyph>

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


% morpheme-boundary markers on analysis level

$LEX$ = $BoundaryAnalysis$ || $LEX$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$

$MORPH$ = $MORPH$ || $MarkerZu$

$MORPH$ = $MORPH$ || $MarkerImp$


% morpheme-boundary markers

$MORPH$ = $MORPH$ || $Boundary$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% disjunctive categories

$MORPH$ = $DisjunctiveCategoriesAnalysis$ || $MORPH$


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $CAP$)


% final cleanup

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$

$MORPH$ = $CleanupIndexAnalysis$ || $MORPH$


% the resulting automaton

$MORPH$
