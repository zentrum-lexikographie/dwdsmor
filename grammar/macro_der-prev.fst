% macro_der-prev.fst
% Version 1.0
% Andreas Nolda 2025-09-12

% derived stems with preverbs

$DerBaseStemsPrev$ = $DerPrev$ <VB> $BaseStems$ || $DerFilter$
$DerDerStemsPrev$  = $DerPrev$ <VB> $DerStems$  || $DerFilter$
$DerCompStemsPrev$ = $DerPrev$ <VB> $CompStems$ || $DerFilter$

$DerBaseStemsPrev$ = $DerFilterLv2$ || $DerBaseStemsPrev$
$DerDerStemsPrev$  = $DerFilterLv2$ || $DerDerStemsPrev$
$DerCompStemsPrev$ = $DerFilterLv2$ || $DerCompStemsPrev$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPrev$
$DerStems$  = $DerStems$  | $DerDerStemsPrev$
$CompStems$ = $CompStems$ | $DerCompStemsPrev$
