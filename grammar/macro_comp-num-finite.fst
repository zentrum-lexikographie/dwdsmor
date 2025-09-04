% macro_comp-num-finite.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% numeral compounds

% final bases in cardinal compounds like "hundertundein(e)" and "hundertein(e)"
$BaseStemsCard1a$ = $BaseStemFilterCard1aLv2$ || $BaseStems$

% final bases in ordinal compounds like "hundertunderste" and "hunderterste"
$BaseStemsOrd1$ = $BaseStemFilterOrd1Lv2$   || $BaseStems$

% final bases in cardinal compounds like "hundertundeins" and "hunderteins"
$BaseStemsCard1b$ = $BaseStems$ || $BaseStemFilterCard1b$

% final basis in (uninflected) cardinal compounds like "dreizehn"
$BaseStemsCard10$ = $BaseStems$ || $BaseStemFilterCard10$

% final basis in ordinal compounds like "dreizehnte"
$BaseStemsOrd10$ = $BaseStems$ || $BaseStemFilterOrd10$

% final basis in fractional compounds like "dreizehntel"
$BaseStemsFrac10$ = $BaseStems$ || $BaseStemFilterFrac10$

% final bases in (uninflected) cardinal compounds like "hundertundelf" and "hundertelf"
$BaseStemsCard11$ = $BaseStems$ || $BaseStemFilterCard11$

% final basis in cardinal compounds like "einhundert"
$BaseStemsCard100$ = $BaseStems$ || $BaseStemFilterCard100$

% final basis in ordinal compounds like "einhundertste"
$BaseStemsOrd100$ = $BaseStems$ || $BaseStemFilterOrd100$

% final basis in fractional compounds like "einhundertstel"
$BaseStemsFrac100$ = $BaseStems$ || $BaseStemFilterFrac100$

% initial bases in cardinal compounds like "einundzwanzig",
% ordinal compounds like "einundzwanzigste", and
% fractional compounds like "einundzwanzigstel"
$CompStemsCard1c$ = $CompStems$ || $CompStemFilterCard1c$

% initial bases in cardinal compounds like "dreizehn",
% ordinal compounds like "dreizehnte", and
% fractional compounds like "dreizehntel"
$CompStemsCard3$ = $CompStems$ || $CompStemFilterCard3$

% initial bases in cardinal compounds like "elfhundert",
% ordinal compounds like "elfhundertste", and
% fractional compounds like "elfhundertstel"
$CompStemsCard11$ =  $BaseStemsCard11$ || $Base2CompStem$
$CompStemsCard11$ = ^$CompStemsCard11$

% initial bases in cardinal compounds like "hundertundeins" and "hunderteins",
% ordinal compounds like "hundertunderste" and "hunderterste", and
% fractional compounds like "hundertunddrittel" and "hundertdrittel"
$CompStemsCard100$ = $CompStems$ || $CompStemFilterCard100$

% cardinal compounds like "dreizehn"
$CompBaseStemsCard13$ = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsCard10$ || $CompNumFilter$

% ordinal compounds like "dreizehnte"
$CompBaseStemsOrd13$ = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsOrd10$  || $CompNumFilter$

% fractional compounds like "dreizehntel"
$CompBaseStemsFrac13$ = $CompStemsCard3$ $Comp-concat$ <CB> $BaseStemsFrac10$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard13$ | $CompBaseStemsOrd13$ | $CompBaseStemsFrac13$

% initial bases in cardinal compounds like "dreizehnhundert",
% ordinal compounds like "dreizehnhundertste", and
% fractional compounds like "dreizehnhundertstel"
$CompStemsCard13$ =  $CompBaseStemsCard13$ || $Base2CompStem$
$CompStemsCard13$ = ^$CompStemsCard13$

% cardinal compounds like "einundzwanzig"
$CompBaseStemsCard21$ = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsCard20$ || $CompNumFilter$

% ordinal compounds like "einundzwanzigste"
$CompBaseStemsOrd21$ = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsOrd20$ || $CompNumFilter$

% fractional compounds like "einundzwanzigstel"
$CompBaseStemsFrac21$ = $CompStemsCard1c$ <IB> $Comp-und$ <CB> $DerBaseStemsFrac20$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard21$ | $CompBaseStemsOrd21$ | $CompBaseStemsFrac21$

% cardinal compounds like "zweihundert"
$CompBaseStemsCard200$ = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompNumFilter$

% ordinal compounds like "zweihundertste"
$CompBaseStemsOrd200$ = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsOrd100$ || $CompNumFilter$

% fractional compounds like "zweihundertstel"
$CompBaseStemsFrac200$ = $CompStemsCard1c$ $Comp-concat$ <CB> $BaseStemsFrac100$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard200$ | $CompBaseStemsOrd200$ | $CompBaseStemsFrac200$

% initial bases in cardinal compounds like "zweihundertundeins" and "zweihunderteins",
% ordinal compounds like "zweihundertunderste" and "zweihunderterste", and
% fractional compounds like "zweihundertunddrittel" and "zweihundertdrittel"
$CompStemsCard200$ =  $CompBaseStemsCard200$ || $Base2CompStem$
$CompStemsCard200$ = ^$CompStemsCard200$

% cardinal compounds like "elfhundert"
$CompBaseStemsCard1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsCard100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsCard100$ || $CompNumFilter$

% ordinal compounds like "elfhundertste"
$CompBaseStemsOrd1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsOrd100$ | \
                         $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsOrd100$ || $CompNumFilter$

% fractional compounds like "elfhundertstel"
$CompBaseStemsFrac1100$ = $CompStemsCard11$ $Comp-concat$ <CB> $BaseStemsFrac100$ | \
                          $CompStemsCard13$ $Comp-concat$ <CB> $BaseStemsFrac100$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1100$ | $CompBaseStemsOrd1100$ | $CompBaseStemsFrac1100$

% initial bases in cardinal compounds like "elfhundertundeins" and "elfhunderteins",
% ordinal compounds like "elfhundertunderste" and "elfhunderterste", and
% fractional compounds like "elfhundertunddrittel" and "elfhundertdrittel"
$CompStemsCard1100$ =  $CompBaseStemsCard1100$ || $Base2CompStem$
$CompStemsCard1100$ = ^$CompStemsCard1100$

% final bases in cardinal compounds like "hundertundeins" and "hunderteins"
$BaseStemsCard1-99$ = $BaseStemsCard1a$     | \
                      $BaseStemsCard1b$     | \
                      $BaseStemsCard10$     | \
                      $BaseStemsCard11$     | \
                      $CompBaseStemsCard13$ | \
                      $DerBaseStemsCard20$  | \
                      $CompBaseStemsCard21$

% final bases ordinal compounds like "hundertunderste" and "hunderterste"
$BaseStemsOrd1-99$ = $BaseStemsOrd1$      | \
                     $DerBaseStemsOrd2$   | \
                     $DerBaseStemsOrd10$  | \
                     $CompBaseStemsOrd13$ | \
                     $DerBaseStemsOrd20$  | \
                     $CompBaseStemsOrd21$

% final bases fractional compounds like "hundertunddrittel" and "hundertdrittel"
$BaseStemsFrac3-99$ = $DerBaseStemsFrac3$   | \
                      $DerBaseStemsFrac10$  | \
                      $CompBaseStemsFrac13$ | \
                      $DerBaseStemsFrac20$  | \
                      $CompBaseStemsFrac21$

% cardinal compounds like "hundertundeins" and "hunderteins"
$CompBaseStemsCard101$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$

% ordinal compounds like "hundertunderste" and "hunderterste"
$CompBaseStemsOrd101$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                        $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$

% fractional compounds like "hundertunddrittel" and "hundertdrittel"
$CompBaseStemsFrac103$ = $CompStemsCard100$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-99$ | \
                         $CompStemsCard100$      $Comp-concat$ <CB> $BaseStemsFrac3-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard101$ | $CompBaseStemsOrd101$ | $CompBaseStemsFrac103$

% cardinal compounds like "zweihundertundeins" and "zweihunderteins"
$CompBaseStemsCard201$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$

% ordinal compounds like "zweihundertunderste" and "zweihunderterste"
$CompBaseStemsOrd201$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                        $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$

% fractional compounds like "zweihundertunddrittel" and "zweihundertdrittel"
$CompBaseStemsFrac203$ = $CompStemsCard200$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-99$ | \
                         $CompStemsCard200$      $Comp-concat$ <CB> $BaseStemsFrac3-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard201$ | $CompBaseStemsOrd201$ | $CompBaseStemsFrac203$

% cardinal compounds like "elfhundertundeins" and "elfhunderteins"
$CompBaseStemsCard1101$ = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsCard1-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsCard1-99$ || $CompNumFilter$

% ordinal compounds like "elfhundertunderste" and "elfhunderterste"
$CompBaseStemsOrd1101$ = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-99$ | \
                         $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsOrd1-99$ || $CompNumFilter$

% fractional compounds like "elfhundertunddrittel" and "elfhundertdrittel"
$CompBaseStemsFrac1103$ = $CompStemsCard1100$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-99$ | \
                          $CompStemsCard1100$      $Comp-concat$ <CB> $BaseStemsFrac3-99$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1101$ | $CompBaseStemsOrd1101$ | $CompBaseStemsFrac1103$
