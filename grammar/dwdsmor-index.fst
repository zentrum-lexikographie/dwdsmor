% dwdsmor-index.fst
% Version 7.1
% Andreas Nolda 2023-05-05

#include "symbols.fst"
#include "stemtype.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "orth.fst"
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

$MORPH$ = $MORPH$ || $MarkerImpVB$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryAnalysis$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundary$


% orthography

$MORPH$ = $OrthOldAnalysis$ || $MORPH$


% the resulting automaton

$MORPH$
