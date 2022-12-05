% dwdsmor-index.fst
% Version 3.0
% Andreas Nolda 2022-12-05

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "dwds.lex"

#include "map.fst"

$LEX$ = $MAP1$ || $LEX$ || $MAP2$

#include "wf-base.fst"

$LEX$ = $BASE$

#include "flexion.fst"

$MORPH$ = $LEX$ $FLEXION$ || $FLEXFILTER$

#include "markers.fst"

$MORPH$ = $MORPH$ || $GE$

$MORPH$ = $MORPH$ || $ZU$

$MORPH$ = $MORPH$ || $IMPVPART$

#include "phon.fst"

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$

#include "disj.fst"

$MORPH$ = $DISJ$ || $MORPH$

#include "cleanup.fst"

$MORPH$ = $CLEANUP1$ || $CLEANUP2$ || $MORPH$

$MORPH$
