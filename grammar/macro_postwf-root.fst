% macro_postwf-root.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% cleanup of word-formation-related forms and symbols

$BaseStems$ = $CleanupAffRootLv2$ || $BaseStems$

$BaseStems$ = $CleanupWFRootLv2$ || $BaseStems$

$BaseStems$ = $BaseStems$ || $CleanupWF$
