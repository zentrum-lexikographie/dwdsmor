% macro_der-prev.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% derived base stems and derivation stems with preverbs

$DerBaseStemsPrev$ = $DerPrev$ <VB> $BaseStems$ || $DerFilter$
$DerDerStemsPrev$  = $DerPrev$ <VB> $DerStems$  || $DerFilter$

$DerBaseStemsPrev$ = $DerFilterLv2$ || $DerBaseStemsPrev$
$DerDerStemsPrev$  = $DerFilterLv2$ || $DerDerStemsPrev$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPrev$
$DerStems$  = $DerStems$  | $DerDerStemsPrev$
