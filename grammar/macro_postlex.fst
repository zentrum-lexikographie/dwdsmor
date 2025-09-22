% macro_postlex.fst
% Version 1.1
% Andreas Nolda 2025-09-22

% cleanup of level-specific symbols

$Lex$ = $CleanupInflLv2$ || $Lex$

$Lex$ = $Lex$ || $CleanupIndex$ || $CleanupOrth$ || $CleanupWeight$


% surface triggers

$Lex$ = $Lex$ || $SurfaceTriggers$
