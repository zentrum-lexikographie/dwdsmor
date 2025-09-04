% macro_postwf.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% cleanup of word-formation-related symbols

$BaseStems$ = $CleanupWFLv2$ || $BaseStems$

$BaseStems$ = $BaseStems$ || $CleanupWF$
