% dwdsmor-root.fst
% Version 1.0
% Andreas Nolda 2022-12-20

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

$HYPH$   = <>:<Hyph>   $CB$
$NOHYPH$ = <>:<NoHyph> $CB$

$COMP$ = $CompStems$ \
         ($HYPH$ $CompStems$ | $NOHYPH$ $CompStemsDC$)* \
         ($HYPH$ $BaseStems$ | $NOHYPH$ $BaseStemsDC$) || $COMPFILTER$

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
