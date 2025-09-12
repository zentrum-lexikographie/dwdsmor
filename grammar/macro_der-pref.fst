% macro_der-pref.fst
% Version 1.1
% Andreas Nolda 2025-09-12

% derived stems with prefixes

$DerBaseStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $BaseStems$ | \
                          $DerPref-un$ <DB>      $BaseStems$ || $DerFilter$
$DerCompStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $CompStems$ | \
                          $DerPref-un$ <DB>      $CompStems$ || $DerFilter$

$DerBaseStemsPref$ = $DerFilterLv2$ || $DerBaseStemsPref$
$DerCompStemsPref$ = $DerFilterLv2$ || $DerCompStemsPref$

$BaseStems$ = $BaseStems$ | $DerBaseStemsPref$
$CompStems$ = $CompStems$ | $DerCompStemsPref$
