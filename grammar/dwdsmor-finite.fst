% dwdsmor-finite.fst
% Version 8.0
% Andreas Nolda 2023-03-24

#include "symbols.fst"
#include "num-finite.fst"
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


% word formation

% affixes

$Pref-un$ = <Prefix> un

$Suff-chen$ = <Suffix> chen <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> lein <NN> <base> <native> <>:<NNeut_s_x>

% means

$DC$ = <^DC>
$UC$ = <^UC>

% derived base stems

$DerStemsDim$  = $DerStems$ || $DerStemDimFilter$

$DerBaseStems$ = $UC$ $Pref-un$     <DB> $DC$ $BaseStems$ | \
                      $Pref-un$     <DB>      $BaseStems$ | \
                      $DerStemsDim$ <DB>      $Suff-chen$ | \
                      $DerStemsDim$ <DB>      $Suff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$ <DB> $DC$ $CompStems$ | \
                      $Pref-un$ <DB>      $CompStems$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = $CompStems$ (<HB><CB> $BaseStems$ | <CB> $DC$ $BaseStems$) || $CompFilter$

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


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$

$MORPHAnalysis$ = <>:<WB> (_$MORPH$) <>:<WB> || $PHONAnalysis$

$MORPH$ = (^_$MORPHAnalysis$) || $MORPH$


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryAnalysis$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundary$


% cleanup of orthography-related symbols

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$

% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexAnalysis$ || $MORPH$


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $CAP$)


% the resulting automaton

$MORPH$
