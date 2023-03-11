% dwdsmor-root.fst
% Version 2.0
% Andreas Nolda 2023-03-10

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
$CompStems$ = $LEX$ || $CompStemFilter$

$BaseStemsLC$ = $BaseStems$ || $BaseStemLC$
$CompStemsLC$ = $CompStems$ || $CompStemLC$

$BaseStemsDC$ = $BaseStems$ || $BaseStemDC$
$CompStemsDC$ = $CompStems$ || $CompStemDC$


% word formation

$DerBreak$ =  <+>:<>

$PrefLC-un$ = <Prefix> {}:{un}
$PrefUC-un$ = <Prefix> {}:{Un}

$DER-un$ = <DER>:<> <pref(un)>:<>

$DerBaseStems$ = $PrefLC-un$ $BaseStemsLC$ $DER-un$ | $PrefUC-un$ $BaseStemsDC$ $DER-un$ || $DerFilter$
$DerCompStems$ = $PrefLC-un$ $CompStemsLC$ $DER-un$ | $PrefUC-un$ $CompStemsDC$ $DER-un$ || $DerFilter$

$DerBaseStemsDC$ = $DerBaseStems$ || $PrefBaseStemDC$
$DerCompStemsDC$ = $DerCompStems$ || $PrefCompStemDC$

$BaseStems$ = $BaseStems$ | $DerBaseStems$
$CompStems$ = $CompStems$ | $DerCompStems$

$BaseStemsDC$ = $BaseStemsDC$ | $DerBaseStemsDC$
$CompStemsDC$ = $CompStemsDC$ | $DerCompStemsDC$

$BASE$ = $BaseStems$

$CompBreakNone$ = <+>:<^none>
$CompBreakHyph$ = <+>:<^hyph>

$concat$ = <concat>:<>
$hyph$   = <hyph>:<>

$COMP$ = <COMP>:<>

$COMP$ = $CompStems$ \
         ($CompBreakHyph$ $CompStems$ $COMP$ $hyph$ | $CompBreakNone$ $CompStemsDC$ $COMP$ $concat$)* \
         ($CompBreakHyph$ $BaseStems$ $COMP$ $hyph$ | $CompBreakNone$ $BaseStemsDC$ $COMP$ $concat$) || $CompFilter$

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
