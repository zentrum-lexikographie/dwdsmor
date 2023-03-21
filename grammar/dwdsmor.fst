% dwdsmor.fst
% Version 5.2
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


% levels

% use surface level of derivation stems and compounding stems
% also for their analysis level
$LEX$ = ( $LEX$ || $BaseStemFilter$) | \
        (^$LEX$ || $DerStemFilter$)  | \
        (^$LEX$ || $CompStemFilter$)


% cleanup of level-specific symbols

$LEX$ = $CleanupInflAnalysis$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$
$DerStems$  = $LEX$ || $DerStemFilter$
$CompStems$ = $LEX$ || $CompStemFilter$

$BaseStemsDC$ = $StemDCAnalysis$ || $BaseStems$ || $StemDC$
$DerStemsDC$  = $StemDCAnalysis$ || $DerStems$  || $StemDC$
$CompStemsDC$ = $StemDCAnalysis$ || $CompStems$ || $StemDC$


% word formation

% morpheme-boundary markers

$CompBreakNone$ = <#>:<^none>
$CompBreakHyph$ = {<\=>\-<#>}:{<^hyph>}

$DerBreak$ =  <~>:<>

% affixes

$Pref-un$   = <Prefix> un $DerBreak$
$PrefUC-un$ = <Prefix> Un $DerBreak$

$Suff-chen$ = <~>:<Suffix> chen <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <~>:<Suffix> lein <NN> <base> <native> <>:<NNeut_s_x>

% derived base stems

$DerStemsDim$  = $DerStems$ || $DerStemDimFilter$

$DerBaseStems$ = $Pref-un$   $BaseStems$   | \
                 $PrefUC-un$ $BaseStemsDC$ | \
                 $DerStemsDim$ $Suff-chen$ | \
                 $DerStemsDim$ $Suff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$DerBaseStemsDC$ = $StemDCAnalysis$ || $DerBaseStems$ || $StemDC$

$BaseStemsDC$ = $BaseStemsDC$ | $DerBaseStemsDC$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $Pref-un$ $CompStems$ | $PrefUC-un$ $CompStemsDC$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

$DerCompStemsDC$ = $StemDCAnalysis$ || $DerCompStems$ || $StemDC$

$CompStemsDC$ = $CompStemsDC$ | $DerCompStemsDC$

% compounds

$COMP$ = $CompStems$ \
         ($CompBreakHyph$ $CompStems$ | $CompBreakNone$ $CompStemsDC$)* \
         ($CompBreakHyph$ $BaseStems$ | $CompBreakNone$ $BaseStemsDC$) || $CompFilter$

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


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $CAP$)


% final cleanup

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$

$MORPH$ = $CleanupIndexAnalysis$ || $MORPH$


% the resulting automaton

$MORPH$
