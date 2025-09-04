% macro_comp.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% compounds

$CompoundedStems$ = ([<dc><uc>]? $CompStems$ <IB> $Comp-hyph$   <CB> | \
                     [<dc><uc>]? $CompStems$      $Comp-concat$ <CB>)+ \
                     [<dc><uc>]? $BaseStems$ || $CompFilter$

$BaseStems$ = $BaseStems$ | $CompoundedStems$
