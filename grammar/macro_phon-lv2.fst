% macro_phon-lv2.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% word-boundary markers on analysis level

$WordsLv2$ = <>:<WB> (_$Words$) <>:<WB>

% (morpho)phonological rules, applied to analysis level

$WordsLv2$ = $WordsLv2$ || $PhonLv2$

$Words$ = (^_$WordsLv2$) || $Words$

% cleanup of word-boundary markers on analysis level

$Words$ = $CleanupWBLv2$ || $Words$
