% dwdsmor-index.fst
% Version 8.0
% Andreas Nolda 2023-05-17

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

$LEX$ = $CleanupInflLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$ || $CleanupOrthOld$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$

$BASE$ = $BaseStems$

$LEX$ = $BASE$


% cleanup of word-formation-related symbols

$LEX$ = $CleanupWFLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$
$MORPH$ = $MORPH$ || $MarkerZu$
$MORPH$ = $MORPH$ || $MarkerImpVB$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% old spelling

$MORPH$ = $MORPH$ | ($MORPH$ || $OrthOld$) <OLDORTH>:<>

$MORPH$ = $CleanupOrthOldLv2$ || $MORPH$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryLv2$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundary$


% the resulting automaton

$MORPH$
