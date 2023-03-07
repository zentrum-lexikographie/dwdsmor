% dwdsmor.fst
% Version 4.5
% Andreas Nolda 2023-03-07

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

$BaseStemsLC$ = $BaseStems$ || $BASESTEMLC$
$CompStemsLC$ = $CompStems$ || $COMPSTEMLC$

$BaseStemsDC$ = $LC2UC$ || $BaseStems$ || $BASESTEMDC$
$CompStemsDC$ = $LC2UC$ || $CompStems$ || $COMPSTEMDC$

#include "wf.fst"

$CB$ =  <#>:<>
$DB$ =  <~>:<>
$HB$ = <\=>:<FB>

$PrefLC-un$ = <>:<Prefix> un $DB$
$PrefUC-un$ = <>:<Prefix> Un $DB$

$DerBaseStems$ = $PrefLC-un$ $BaseStemsLC$ | $PrefUC-un$ $BaseStemsDC$ || $DERFILTER$
$DerCompStems$ = $PrefLC-un$ $CompStemsLC$ | $PrefUC-un$ $CompStemsDC$ || $DERFILTER$

$DerBaseStemsDC$ = $LC2UC$ || $DerBaseStems$ || $PREFBASESTEMDC$
$DerCompStemsDC$ = $LC2UC$ || $DerCompStems$ || $PREFCOMPSTEMDC$

$BaseStems$ = $BaseStems$ | $DerBaseStems$
$CompStems$ = $CompStems$ | $DerCompStems$

$BaseStemsDC$ = $BaseStemsDC$ | $DerBaseStemsDC$
$CompStemsDC$ = $CompStemsDC$ | $DerCompStemsDC$

$BASE$ = $BaseStems$ || $BASEFILTER$

$HYPHB$   = $HB$ \-:<Hyph>   $CB$
$NOMARKB$ =      <>:<NoMark> $CB$

$COMP$ = $CompStems$ \
         ($HYPHB$ $CompStems$ | $NOMARKB$ $CompStemsDC$)* \
         ($HYPHB$ $BaseStems$ | $NOMARKB$ $BaseStemsDC$) || $COMPFILTER$

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

$MORPH$ = $CLEANUP1$ || $CLEANUP2$ || $CLEANUP3$ || $MORPH$

$MORPH$
