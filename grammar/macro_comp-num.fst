% macro_comp-num.fst
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

% final basis in cardinal compounds like "eintausend"
$BaseStemsCard1000$ = $BaseStems$ || $BaseStemFilterCard1000$

% final basis in ordinal compounds like "eintausendste"
$BaseStemsOrd1000$ = $BaseStems$ || $BaseStemFilterOrd1000$

% final basis in ordinal compounds like "eintausendste"
$BaseStemsFrac1000$ = $BaseStems$ || $BaseStemFilterFrac1000$

% final bases in ordinal compounds like "einmillionste"
$BaseStemsOrd1000000$ = $BaseStems$ || $BaseStemFilterOrd1000000$

% final bases in fractional compounds like "einmillionstel"
$BaseStemsFrac1000000$ = $BaseStems$ || $BaseStemFilterFrac1000000$

% initial bases in cardinal compounds like "einundzwanzig",
% ordinal compounds like "einundzwanzigste", and
% fractional compounds like "einundzwanzigstel"
$CompStemsCard1c$ = $CompStems$ || $CompStemFilterCard1c$

% initial bases in cardinal compounds like "dreizehn",
% ordinal compounds like "dreizehnte", and
% fractional compounds like "dreizehntel"
$CompStemsCard3$ = $CompStems$ || $CompStemFilterCard3$

% initial bases in cardinal compounds like "zehntausend",
% ordinal compounds like "zehntausendste", and
% fractional compounds like "zehntausendstel"
$CompStemsCard10$ =  $BaseStemsCard10$ || $Base2CompStem$
$CompStemsCard10$ = ^$CompStemsCard10$

% initial bases in cardinal compounds like "elfhundert",
% ordinal compounds like "elfhundertste", and
% fractional compounds like "elfhundertstel"
$CompStemsCard11$ =  $BaseStemsCard11$ || $Base2CompStem$
$CompStemsCard11$ = ^$CompStemsCard11$

% initial bases in cardinal compounds like "hundertundeins" and "hunderteins",
% ordinal compounds like "hundertunderste" and "hunderterste", and
% fractional compounds like "hundertunddrittel" and "hundertdrittel"
$CompStemsCard100$ = $CompStems$ || $CompStemFilterCard100$

% initial bases in cardinal compounds like "tausendundeins" and "tausendeins",
% ordinal compounds like "tausendunderste" and "tausenderste", and
% fractional compounds like "tausendunddrittel" and "tausenddrittel"
$CompStemsCard1000$ = $CompStems$ || $CompStemFilterCard1000$

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

% initial bases in cardinal compounds like "einundzwanzigtausend",
% ordinal compounds like "einundzwanzigtausendste", and
% fractional compounds like "einundzwanzigtausendstel"
$CompStemsCard21$ =  $CompBaseStemsCard21$ || $Base2CompStem$
$CompStemsCard21$ = ^$CompStemsCard21$

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

% initial bases in cardinal compounds like "hundertundeinstausend" and "hunderteinstausend",
% ordinal compounds like "hundertundeinstausendste" and "hunderteinstausendste", and
% fractional compounds like "hundertundeinstausendstel" and "hunderteinstausendstel"
$CompStemsCard101$ =  $CompBaseStemsCard101$ || $Base2CompStem$
$CompStemsCard101$ = ^$CompStemsCard101$

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

% initial bases in cardinal compounds like "zweihundertundeinstausend" and "zweihunderteinstausend",
% ordinal compounds like "zweihundertundeinstausendste" and "zweihunderteinstausendste", and
% fractional compounds like "zweihundertundeinstausendstel" and "zweihunderteinstausendstel"
$CompStemsCard201$ =  $CompBaseStemsCard201$ || $Base2CompStem$
$CompStemsCard201$ = ^$CompStemsCard201$

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

% initial bases in cardinal compounds like "zweitausend",
% ordinal compounds like "zweitausendste", and
% fractional compounds like "zweitausendstel"
$CompStemsCard1-999$ = $CompStemsCard1c$  | \
                       $CompStemsCard10$  | \
                       $CompStemsCard11$  | \
                       $CompStemsCard13$  | \
                       $CompStemsCard20$  | \
                       $CompStemsCard21$  | \
                       $CompStemsCard100$ | \
                       $CompStemsCard101$ | \
                       $CompStemsCard200$ | \
                       $CompStemsCard201$

% cardinal compounds like "zweitausend"
$CompBaseStemsCard2000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsCard1000$ || $CompNumFilter$

% ordinal compounds like "zweitausendste"
$CompBaseStemsOrd2000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsOrd1000$ || $CompNumFilter$

% fractional compounds like "zweitausendstel"
$CompBaseStemsFrac2000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsFrac1000$ || $CompNumFilter$

% ordinal compounds like "zweimillionste"
$CompBaseStemsOrd2000000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsOrd1000000$ || $CompNumFilter$

% fractional compounds like "zweimillionstel"
$CompBaseStemsFrac2000000$ = $CompStemsCard1-999$ $Comp-concat$ <CB> $BaseStemsFrac1000000$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard2000$ | \
              $CompBaseStemsOrd2000$ | $CompBaseStemsFrac2000$ | \
              $CompBaseStemsOrd2000000$ | $CompBaseStemsFrac2000000$

% initial bases in cardinal compounds like "zweitausendundeins" and "zweitausendeins",
% ordinal compounds like "zweitausendunderste" and "zweitausenderste", and
% fractional compounds like "zweitausendunddrittel" and "zweitausenddrittel"
$CompStemsCard2000$ =  $CompBaseStemsCard2000$ || $Base2CompStem$
$CompStemsCard2000$ = ^$CompStemsCard2000$

% final bases in cardinal compounds like "tausendundeins" and "tausendeins"
$BaseStemsCard1-999$ = $BaseStemsCard1-99$    | \
                       $CompBaseStemsCard200$ | \
                       $CompBaseStemsCard201$

% final bases in ordinal compounds like "tausendunderste" and "tausenderste"
$BaseStemsOrd1-999$ = $BaseStemsOrd1-99$    | \
                      $CompBaseStemsOrd200$ | \
                      $CompBaseStemsOrd201$

% final bases in fractional compounds like "tausendunddrittel" and "tausenddrittel"
$BaseStemsFrac3-999$ = $BaseStemsFrac3-99$    | \
                       $CompBaseStemsFrac200$ | \
                       $CompBaseStemsFrac203$

% cardinal compounds like "tausendundeins" and "tausendeins"
$CompBaseStemsCard1001$ = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsCard1-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsCard1-999$ || $CompNumFilter$

% ordinal compounds like "tausendunderste" and "tausenderste"
$CompBaseStemsOrd1001$ = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-999$ | \
                         $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsOrd1-999$ || $CompNumFilter$

% fractional compounds like "tausendunddrittel" and "tausenddrittel"
$CompBaseStemsFrac1003$ = $CompStemsCard1000$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-999$ | \
                          $CompStemsCard1000$      $Comp-concat$ <CB> $BaseStemsFrac3-999$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard1001$ | $CompBaseStemsOrd1001$ | $CompBaseStemsFrac1003$

% cardinal compounds like "zweitausendundeins" and "zweitausendeins"
$CompBaseStemsCard2001$ = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsCard1-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsCard1-999$ || $CompNumFilter$

% ordinal compounds like "zweitausendunderste" and "zweitausenderste"
$CompBaseStemsOrd2001$ = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsOrd1-999$ | \
                         $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsOrd1-999$ || $CompNumFilter$

% fractional compounds like "zweitausendunddrittel" and "zweitausenddrittel"
$CompBaseStemsFrac2003$ = $CompStemsCard2000$ <IB> $Comp-und$    <CB> $BaseStemsFrac3-999$ | \
                          $CompStemsCard2000$      $Comp-concat$ <CB> $BaseStemsFrac3-999$ || $CompNumFilter$

$BaseStems$ = $BaseStems$ | $CompBaseStemsCard2001$ | $CompBaseStemsOrd2001$ | $CompBaseStemsFrac2003$
