% macro_conv-adj-root.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% converted base adjective and numeral stems

$BaseStemsAdj$  = $BaseStems$ || $BaseStemFilterAdj$
$BaseStemsOrd$  = $BaseStems$ || $BaseStemFilterOrd$
$BaseStemsFrac$ = $BaseStems$ || $BaseStemFilterFrac$

#include "macro_conv-adj-postwf.fst"

$BaseStemsAdj$  = $BaseStemsAdj$ $Infl$ || $InflFilter$
$BaseStemsOrd$  = $BaseStemsOrd$ $Infl$ || $InflFilter$
$BaseStemsFrac$ = $BaseStemsFrac$ $Infl$ || $InflFilter$

$BaseStemsAdjMasc$ = $BaseStemFilterAdjMascLv2$ || $BaseStemsAdj$
$BaseStemsAdjNeut$ = $BaseStemFilterAdjNeutLv2$ || $BaseStemsAdj$
$BaseStemsAdjFem$  = $BaseStemFilterAdjFemLv2$  || $BaseStemsAdj$
$BaseStemsOrdMasc$ = $BaseStemFilterOrdMascLv2$ || $BaseStemsOrd$
$BaseStemsOrdNeut$ = $BaseStemFilterOrdNeutLv2$ || $BaseStemsOrd$
$BaseStemsOrdFem$  = $BaseStemFilterOrdFemLv2$  || $BaseStemsOrd$
$BaseStemsFrac$    = $BaseStemFilterFracLv2$    || $BaseStemsFrac$

#include "macro_conv-adj-postinfl.fst"

#include "macro_conv-adj-phon.fst"

#include "macro_conv-adj-postphon.fst"

$ConvBaseStemsAdj$  = <uc> $BaseStemsAdjMasc$ $ConvAdjMasc$ | \
                      <uc> $BaseStemsAdjNeut$ $ConvAdjNeut$ | \
                      <uc> $BaseStemsAdjFem$  $ConvAdjFem$ || $ConvFilter$
$ConvBaseStemsOrd$  = <uc> $BaseStemsOrdMasc$ $ConvAdjMasc$ | \
                      <uc> $BaseStemsOrdNeut$ $ConvAdjNeut$ | \
                      <uc> $BaseStemsOrdFem$  $ConvAdjFem$ || $ConvFilter$
$ConvBaseStemsFrac$ = <uc> $BaseStemsFrac$    $ConvFrac$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStemsAdj$ | $ConvBaseStemsOrd$ | $ConvBaseStemsFrac$
