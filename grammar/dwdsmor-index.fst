% dwdsmor-index.fst
% Version 4.2
% Andreas Nolda 2023-03-07

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "dwds.lex"

#include "level.fst"

$LEX$ = ( $LEX$ || $BASELEVEL$) | \
        (^$LEX$ || $COMPLEVEL$)

#include "map.fst"

$LEX$ = $MAP1$ || $LEX$ || $MAP2$

#include "stemtype.fst"

$BaseStems$ = $LEX$ || $BASESTEMFILTER$

#include "wf.fst"

$BASE$ = $BaseStems$ || $BASEFILTER$

$LEX$ = $BASE$

#include "infl.fst"

$MORPH$ = $LEX$ $INFL$ || $INFLFILTER$

#include "markers.fst"

$MORPH$ = $MORPH$ || $GE$

$MORPH$ = $MORPH$ || $ZU$

$MORPH$ = $MORPH$ || $IMPVPART$

$MORPH$ = $MORPH$ || $BREAK$

#include "phon.fst"

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$

#include "disj.fst"

$MORPH$ = $DISJ$ || $MORPH$

#include "cleanup.fst"

$MORPH$ = $CLEANUP1$ || $CLEANUP2$ || $MORPH$

$MORPH$
