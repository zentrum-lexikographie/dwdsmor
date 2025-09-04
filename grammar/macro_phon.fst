% macro_phon.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% word-boundary markers

$Words$ = <>:<WB> $Words$ <>:<WB>

% (morpho)phonological rules

$Words$ = $Words$ || $Phon$
