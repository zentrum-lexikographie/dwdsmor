% macro_surface.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% use surface level of derivation stems and compounding stems
% also for their analysis level
$Lex$ = ( $Lex$ || $BaseStemFilter$) | \
        (^$Lex$ || $DerStemFilter$)  | \
        (^$Lex$ || $CompStemFilter$)
