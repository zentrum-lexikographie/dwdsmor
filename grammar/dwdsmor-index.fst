% dwdsmor-index.fst
% Version 6.0
% Andreas Nolda 2023-03-21

#include "symbols.fst"
#include "stemtype.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
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


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$

$MORPH$ = $MORPH$ || $MarkerZu$

$MORPH$ = $MORPH$ || $MarkerImpVPart$


% morpheme-boundary triggers generated from entry types

$MORPH$ = $MORPH$ || $BoundaryTriggers$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryAnalysis$ || $MORPH$


% cleanup of orthography-related symbols

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$

% cleanup of morpheme-boundary triggers

$MORPH$ = $MORPH$ || $CleanupBoundary$


% the resulting automaton

$MORPH$
