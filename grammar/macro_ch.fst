% macro_ch.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% Swiss spelling

$Words$ = $Words$ | <CH>:<> ($NoOrthOldFilterLv2$ || $Words$ || $OrthCH$)
