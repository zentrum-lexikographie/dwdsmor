% dwdsmor-index.fst
% Version 5.0
% Andreas Nolda 2023-03-10

#include "symbols.fst"
#include "stemtype.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "disj.fst"
#include "cleanup.fst"


% lexicon

$LEX$ = "dwds.lex"


% cleanup of level-specific symbols

$LEX$ = $CleanupInflAnalysis$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$

$BASE$ = $BaseStems$

$LEX$ = $BASE$


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

$MORPH$ = $MORPH$ || $MarkerImpVPart$


% morpheme-boundary markers

$MORPH$ = $MORPH$ || $Boundary$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% disjunctive categories

$MORPH$ = $DisjunctiveCategoriesAnalysis$ || $MORPH$


% final cleanup

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$


% the resulting automaton

$MORPH$
