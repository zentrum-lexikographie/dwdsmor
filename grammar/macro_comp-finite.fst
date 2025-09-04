% macro_comp-finite.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% derived compounding stems

$DerCompStemsPref$ = <uc> $DerPref-un$ <DB> <dc> $CompStems$ | \
                          $DerPref-un$ <DB>      $CompStems$ || $DerFilter$

$DerCompStemsPrev$ = $DerPrev$ <VB> $CompStems$ || $DerFilter$

$DerCompStemsPrev$ = $DerFilterLv2$ || $DerCompStemsPrev$

$CompStems$ = $CompStems$ | $DerCompStemsPref$ | $DerCompStemsPrev$

% compounds

$CompoundedStems$ = ([<dc><uc>]? $CompStems$ <IB> $Comp-hyph$   <CB> | \
                     [<dc><uc>]? $CompStems$      $Comp-concat$ <CB>) \
                     [<dc><uc>]? $BaseStems$ || $CompFilter$

$BaseStems$ = $BaseStems$ | $CompoundedStems$
