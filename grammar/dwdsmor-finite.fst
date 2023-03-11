% dwdsmor-finite.fst
% Version 5.0
% Andreas Nolda 2023-03-10

#include "symbols.fst"
#include "num-finite.fst"
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


% levels

% use surface level of compounding stem forms also for their analysis level
$LEX$ = ( $LEX$ || $BaseStemFilter$) | \
        (^$LEX$ || $CompStemFilter$)


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

$BaseStemsDC$ = $BaseStemDCAnalysis$ || $BaseStems$ || $BaseStemDC$
$CompStemsDC$ = $CompStemDCAnalysis$ || $CompStems$ || $CompStemDC$


% word formation

$DerBreak$ =  <~>:<>

$PrefLC-un$ = <Prefix> un $DerBreak$
$PrefUC-un$ = <Prefix> Un $DerBreak$

$DerBaseStems$ = $PrefLC-un$ $BaseStemsLC$ | $PrefUC-un$ $BaseStemsDC$ || $DerFilter$
$DerCompStems$ = $PrefLC-un$ $CompStemsLC$ | $PrefUC-un$ $CompStemsDC$ || $DerFilter$

$DerBaseStemsDC$ = $PrefBaseStemDCAnalysis$ || $DerBaseStems$ || $PrefBaseStemDC$
$DerCompStemsDC$ = $PrefCompStemDCAnalysis$ || $DerCompStems$ || $PrefCompStemDC$

$BaseStems$ = $BaseStems$ | $DerBaseStems$
$CompStems$ = $CompStems$ | $DerCompStems$

$BaseStemsDC$ = $BaseStemsDC$ | $DerBaseStemsDC$

$BASE$ = $BaseStems$

$CompBreakNone$ = <#>:<^none>
$CompBreakHyph$ = {<\=>\-<#>}:{<^hyph>}

$COMP$ = $CompStems$ ($CompBreakHyph$ $BaseStems$ | $CompBreakNone$ $BaseStemsDC$) || $CompFilter$

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
