% macro_conv-v-postphon.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% cleanup of word-boundary markers

$BaseStemsVInfNonCl$ = $BaseStemsVInfNonCl$ || $MarkerWB$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerWB$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerWB$
