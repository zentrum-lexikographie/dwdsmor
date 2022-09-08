% dwdsmor.fst
% Version 1.0
% Andreas Nolda 2022-09-08

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX1$ = "DWDS.lex"

$LEX2$ = "DWDS-Red2.lex"

$LEX3$ = "aux.lex"

$LEX$ = $LEX1$ | \
        $LEX2$ | \
        $LEX3$

#include "map.fst"

$LEX$ = $MAP1$ || $LEX$ || $MAP2$

#include "flexion.fst"

$MORPH$ = $LEX$ <X>:<> $FLEXION$ || $FLEXFILTER$

#include "markers.fst"

$MORPH$ = $MORPH$ || $GE$

$MORPH$ = $MORPH$ || $ZU$

$MORPH$ = $MORPH$ || $IMP$

$MORPH$ = $MORPH$ || $UPLOW$

#include "phon.fst"

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$

#include "elim.fst"

$MORPH$ = $ELIM$ || $MORPH$

#include "lemma.fst"

$MORPH$ = ($LEMMA1$ || $MORPH$) | \
          ($LEMMA2$ || $MORPH$)

#include "cleanup.fst"

$MORPH$ = $CLEANUP1$ || $MORPH$ || $CLEANUP2$

$MORPH$
