% dwdsmor-finite.fst
% Version 4.0
% Andreas Nolda 2022-12-20

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "dwds.lex"

#include "num-finite.fst"

$LEX$ = $LEX$ | $NUM$

#include "level.fst"

$LEX$ = ( $LEX$ || $BASELEVEL$) | \
        (^$LEX$ || $COMPLEVEL$)

#include "map.fst"

$LEX$ = $MAP1$ || $LEX$ || $MAP2$

#include "stemtype.fst"

$BaseStems$ = $LEX$ || $BASESTEMFILTER$
$CompStems$ = $LEX$ || $COMPSTEMFILTER$

$BaseStemsDC$ = $DC$ || $BaseStems$ || $BASESTEMDC$

#include "wf.fst"

$BASE$ = $BaseStems$ || $BASEFILTER$

$COMP$ = $CompStems$ ($HYPH$ $BaseStems$ | $NOHYPH$ $BaseStemsDC$) || $COMPFILTER$

$WF$ = $COMP$

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
