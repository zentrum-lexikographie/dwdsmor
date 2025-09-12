% macro_der-suff.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% derived stems with suffixes

$DerStemsSuff-e$    = $DerStems$ || $DerStemFilterSuff-e$
$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$
$DerStemsSuff-bar$  = $DerStems$ || $DerStemFilterSuff-bar$

$DerBaseStemsSuff$ = $DerStemsSuff-e$    <DB> $DerSuff-e$    | \
                     $DerStemsSuff-er$   <DB> $DerSuff-er$   | \
                     $DerStemsSuff-chen$ <DB> $DerSuff-chen$ | \
                     $DerStemsSuff-lein$ <DB> $DerSuff-lein$ | \
                     $DerStemsSuff-bar$  <DB> $DerSuff-bar$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStemsSuff$
