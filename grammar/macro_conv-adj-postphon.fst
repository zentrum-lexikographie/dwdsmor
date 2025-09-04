% macro_conv-adj-postphon.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% cleanup of word-boundary markers

$BaseStemsAdjMasc$ = $BaseStemsAdjMasc$ || $MarkerWB$
$BaseStemsAdjNeut$ = $BaseStemsAdjNeut$ || $MarkerWB$
$BaseStemsAdjFem$  = $BaseStemsAdjFem$  || $MarkerWB$
$BaseStemsOrdMasc$ = $BaseStemsOrdMasc$ || $MarkerWB$
$BaseStemsOrdNeut$ = $BaseStemsOrdNeut$ || $MarkerWB$
$BaseStemsOrdFem$  = $BaseStemsOrdFem$  || $MarkerWB$
$BaseStemsFrac$    = $BaseStemsFrac$    || $MarkerWB$
