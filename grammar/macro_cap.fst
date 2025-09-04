% macro_cap.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% capitalisation

$Words$ = $Words$ | <CAP>:<> ($Words$ || $OrthCap$)
