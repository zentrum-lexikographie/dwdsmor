% dwdsmor-root.fst
% Version 1.1
% Andreas Nolda 2023-01-16

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "dwds.lex"

#include "num.fst"

$LEX$ = $LEX$ | $NUM$

#include "map.fst"

$LEX$ = $MAP1$ || $LEX$ || $MAP2$

#include "stemtype.fst"

$BaseStems$ = $LEX$ || $BASESTEMFILTER$
$CompStems$ = $LEX$ || $COMPSTEMFILTER$

$BaseStemsDC$ = $BaseStems$ || $BASESTEMDC$
$CompStemsDC$ = $CompStems$ || $COMPSTEMDC$

#include "wf.fst"

$BASE$ = $BaseStems$ || $BASEFILTER$

$CB$ =  <+>:<>

$HYPHB$   = <>:<Hyph>   $CB$
$NOMARKB$ = <>:<NoMark> $CB$

$COMP-hyph$   = <COMP>:<>   <hyph>:<>
$COMP-concat$ = <COMP>:<> <concat>:<>

$COMP$ = $CompStems$ \
         ($HYPHB$ $CompStems$ $COMP-hyph$ | $NOMARKB$ $CompStemsDC$ $COMP-concat$)* \
         ($HYPHB$ $BaseStems$ $COMP-hyph$ | $NOMARKB$ $BaseStemsDC$ $COMP-concat$) || $COMPFILTER$

$WF$ = $COMP$

$LEX$ = $BASE$ | $WF$

#include "flexion.fst"

$MORPH$ = $LEX$ $FLEXION$ || $FLEXFILTER$

#include "markers.fst"

$MORPH$ = $MORPH$ || $GE$

$MORPH$ = $MORPH$ || $ZU$

$MORPH$ = $MORPH$ || $IMP$

$MORPH$ = $MORPH$ || $BREAK$

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
