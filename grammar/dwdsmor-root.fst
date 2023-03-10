% dwdsmor-root.fst
% Version 1.4
% Andreas Nolda 2023-03-10

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

$BaseStemsLC$ = $BaseStems$ || $BASESTEMLC$
$CompStemsLC$ = $CompStems$ || $COMPSTEMLC$

$BaseStemsDC$ = $BaseStems$ || $BASESTEMDC$
$CompStemsDC$ = $CompStems$ || $COMPSTEMDC$

#include "wf.fst"

$CB$ =  <+>:<>

$PrefLC-un$ = <>:<Prefix> <>:{un}
$PrefUC-un$ = <>:<Prefix> <>:{Un}

$DER-un$ = <DER>:<> <pref(un)>:<>

$DerBaseStems$ = $PrefLC-un$ $BaseStemsLC$ $DER-un$ | $PrefUC-un$ $BaseStemsDC$ $DER-un$ || $DERFILTER$
$DerCompStems$ = $PrefLC-un$ $CompStemsLC$ $DER-un$ | $PrefUC-un$ $CompStemsDC$ $DER-un$ || $DERFILTER$

$DerBaseStemsDC$ = $DerBaseStems$ || $PREFBASESTEMDC$
$DerCompStemsDC$ = $DerCompStems$ || $PREFCOMPSTEMDC$

$BaseStems$ = $BaseStems$ | $DerBaseStems$
$CompStems$ = $CompStems$ | $DerCompStems$

$BaseStemsDC$ = $BaseStemsDC$ | $DerBaseStemsDC$

$BASE$ = $BaseStems$ || $BASEFILTER$

$HYPHB$   = <>:<Hyph>   $CB$
$NOMARKB$ = <>:<NoMark> $CB$

$COMP-hyph$   = <COMP>:<>   <hyph>:<>
$COMP-concat$ = <COMP>:<> <concat>:<>

$COMP$ = $CompStems$ \
         ($HYPHB$ $CompStems$ $COMP-hyph$ | $NOMARKB$ $CompStemsDC$ $COMP-concat$)* \
         ($HYPHB$ $BaseStems$ $COMP-hyph$ | $NOMARKB$ $BaseStemsDC$ $COMP-concat$) || $COMPFILTER$

$LEX$ = $BASE$ | $COMP$

#include "infl.fst"

$MORPH$ = $LEX$ $INFL$ || $INFLFILTER$

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

$MORPH$ = $CLEANUP1$ || $CLEANUP2$ || $MORPH$

$MORPH$
