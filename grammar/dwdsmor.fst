% dwdsmor.fst
% Version 4.3
% Andreas Nolda 2023-01-16

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$LEX$ = "dwds.lex"

#include "num.fst"

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
$CompStemsDC$ = $DC$ || $CompStems$ || $COMPSTEMDC$

#include "wf.fst"

$BASE$ = $BaseStems$ || $BASEFILTER$

$HB$ = <\=>:<FB>
$CB$ =  <#>:<>

$HYPHB$   = $HB$ \-:<Hyph>   $CB$
$NOMARKB$ =      <>:<NoMark> $CB$

$COMP$ = $CompStems$ \
         ($HYPHB$ $CompStems$ | $NOMARKB$ $CompStemsDC$)* \
         ($HYPHB$ $BaseStems$ | $NOMARKB$ $BaseStemsDC$) || $COMPFILTER$

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
