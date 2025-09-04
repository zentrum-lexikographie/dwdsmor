% macro_conv-adj-phon.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% word-boundary markers

$BaseStemsAdjMasc$ = <>:<WB> $BaseStemsAdjMasc$ <>:<WB>
$BaseStemsAdjNeut$ = <>:<WB> $BaseStemsAdjNeut$ <>:<WB>
$BaseStemsAdjFem$  = <>:<WB> $BaseStemsAdjFem$  <>:<WB>
$BaseStemsOrdMasc$ = <>:<WB> $BaseStemsOrdMasc$ <>:<WB>
$BaseStemsOrdNeut$ = <>:<WB> $BaseStemsOrdNeut$ <>:<WB>
$BaseStemsOrdFem$  = <>:<WB> $BaseStemsOrdFem$  <>:<WB>
$BaseStemsFrac$    = <>:<WB> $BaseStemsFrac$    <>:<WB>

% (morpho)phonological rules

$BaseStemsAdjMasc$ = $BaseStemsAdjMasc$ || $Phon$
$BaseStemsAdjNeut$ = $BaseStemsAdjNeut$ || $Phon$
$BaseStemsAdjFem$  = $BaseStemsAdjFem$  || $Phon$
$BaseStemsOrdMasc$ = $BaseStemsOrdMasc$ || $Phon$
$BaseStemsOrdNeut$ = $BaseStemsOrdNeut$ || $Phon$
$BaseStemsOrdFem$  = $BaseStemsOrdFem$  || $Phon$
$BaseStemsFrac$    = $BaseStemsFrac$    || $Phon$
