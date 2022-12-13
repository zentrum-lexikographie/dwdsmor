% dwdsmor.fst
% Version 3.1
% Andreas Nolda 2022-12-12

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "dwds.lex"

#include "num.fst"

$LEX$ = $LEX$ | $NUM$

#include "map.fst"

$LEX$ = $MAP1$ || $LEX$ || $MAP2$

#include "wf.fst"

$LEX$ = $BASE$ | $WF$

#include "flexion.fst"

$MORPH$ = $LEX$ $FLEXION$ || $FLEXFILTER$

#include "markers.fst"

$MORPH$ = $MORPH$ || $GE$

$MORPH$ = $MORPH$ || $ZU$

$MORPH$ = $MORPH$ || $IMP$

#include "phon.fst"

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$

#include "disj.fst"

$MORPH$ = $DISJ$ || $MORPH$

#include "punct.fst"

$MORPH$ = $MORPH$ | $PUNCT$

#include "cap.fst"

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $CAP$)

#include "cleanup.fst"

$MORPH$ = $CLEANUP1$ || $CLEANUP2$ || $CLEANUP3$ || $MORPH$

$MORPH$
