% macro_postlex.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% cleanup of level-specific symbols

$Lex$ = $CleanupInflLv2$ || $Lex$

$Lex$ = $Lex$ || $CleanupIndex$ || $CleanupOrth$


% surface triggers

$Lex$ = $Lex$ || $SurfaceTriggers$
