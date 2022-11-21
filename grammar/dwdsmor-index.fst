% dwdsmor-index.fst
% Version 2.0
% Andreas Nolda 2022-11-21

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "DWDS.lex" | "aux.lex"

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

$MORPH$ = $MORPH$ || $UPLOW$

#include "phon.fst"

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$

#include "disj.fst"

$MORPH$ = $DISJ$ || $MORPH$

#include "lemma-index.fst"

$MORPH$ = ($LEMMA1$ || $MORPH$) | \
          ($LEMMA2$ || $MORPH$)

#include "cleanup.fst"

$MORPH$ = $CLEANUP1$ || $MORPH$ || $CLEANUP2$

$MORPH$
