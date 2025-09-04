% macro_der-num-finite.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% derived numeral base stems with affixes

% bases in derived ordinals like "zweite"
$DerStemsCard2-st$ = $DerStems$ || $DerStemFilterCard2-st$

% bases in derived cardinals like "zwanzig"
$DerStemsCard2-zig$ = $DerStems$ || $DerStemFilterCard2-zig$

% bases in derived fractional numerals like "drittel"
$DerStemsCard3-stel$ = $DerStems$ || $DerStemFilterCard3-stel$

% bases in derived ordinals like "zehnte"
$DerStemsCard10-st$ = $DerStems$ || $DerStemFilterCard10-st$

% bases in derived fractional numerals like "zehntel"
$DerStemsCard10-stel$ = $DerStems$ || $DerStemFilterCard10-stel$

% bases in derived ordinals like "hundertste"
$DerStemsCard100-st$ = $DerStems$ || $DerStemFilterCard100-st$

% bases in derived fractional numerals like "hundertstel"
$DerStemsCard100-stel$ = $DerStems$ || $DerStemFilterCard100-stel$

% derived cardinals like "zwanzig"
$DerBaseStemsCard20$ = $DerStemsCard2-zig$ <DB> $DerSuff-zig$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsCard20$

% bases in derived ordinals like "zwanzigste"
$DerStemsCard20-st$ =  $DerBaseStemsCard20$ || $Base2DerStem-st$
$DerStemsCard20-st$ = ^$DerStemsCard20-st$

% bases in derived fractional numerals like "zwanzigstel"
$DerStemsCard20-stel$ =  $DerBaseStemsCard20$ || $Base2DerStem-stel$
$DerStemsCard20-stel$ = ^$DerStemsCard20-stel$

% derived ordinals like "zweite"
$DerBaseStemsOrd2$ = $DerStemsCard2-st$ <DB> $DerSuff-st$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsOrd2$

% derived fractional numerals like "drittel"
$DerBaseStemsFrac3$ = $DerStemsCard3-stel$ <DB> $DerSuff-stel$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsFrac3$

% derived ordinals like "zehnte"
$DerBaseStemsOrd10$ = $DerStemsCard10-st$ <DB> $DerSuff-st$ || $DerNumFilter$

% derived fractional numerals like "zehntel"
$DerBaseStemsFrac10$ = $DerStemsCard10-stel$ <DB> $DerSuff-stel$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsOrd10$ | $DerBaseStemsFrac10$

% derived ordinals like "zwanzigste"
$DerBaseStemsOrd20$ = $DerStemsCard20-st$ <DB> $DerSuff-st$ || $DerNumFilter$

% derived fractional numerals like "zwanzigstel"
$DerBaseStemsFrac20$ = $DerStemsCard20-stel$ <DB> $DerSuff-stel$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsOrd20$ | $DerBaseStemsFrac20$

% derived ordinals like "hundertste"
$DerBaseStemsOrd100$ = $DerStemsCard100-st$ <DB> $DerSuff-st$ || $DerNumFilter$

% derived fractional numerals like "hundertstel"
$DerBaseStemsFrac100$ = $DerStemsCard100-stel$ <DB> $DerSuff-stel$ || $DerNumFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsOrd100$ | $DerBaseStemsFrac100$
