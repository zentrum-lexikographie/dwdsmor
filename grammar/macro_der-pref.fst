% macro_der-pref.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% derived base stems with prefixes

$DerBaseStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $BaseStems$ | \
                          $DerPref-un$ <DB>      $BaseStems$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPref$

% derived compounding stems with prefixes

$DerCompStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $CompStems$ | \
                          $DerPref-un$ <DB>      $CompStems$ || $DerFilter$

$DerCompStemsPrev$ = $DerPrev$ <VB> $CompStems$ || $DerFilter$

$DerCompStemsPrev$ = $DerFilterLv2$ || $DerCompStemsPrev$

$CompStems$ = $CompStems$ | $DerCompStemsPref$ | $DerCompStemsPrev$
