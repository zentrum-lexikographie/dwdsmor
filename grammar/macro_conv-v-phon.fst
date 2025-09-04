% macro_conv-v-phon.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% word-boundary markers

$BaseStemsVInfNonCl$ = <>:<WB> $BaseStemsVInfNonCl$ <>:<WB>
$BaseStemsVPartPres$ = <>:<WB> $BaseStemsVPartPres$ <>:<WB>
$BaseStemsVPartPerf$ = <>:<WB> $BaseStemsVPartPerf$ <>:<WB>

% (morpho)phonological rules

$BaseStemsVInfNonCl$ = $BaseStemsVInfNonCl$ || $Phon$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $Phon$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $Phon$
