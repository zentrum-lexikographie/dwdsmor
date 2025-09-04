% macro_trunc.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% morpheme truncation

$Words$ = $Words$ | <TRUNC>:<> ($TruncInitialLv2$ || $Words$ || $TruncInitial$) | \
                    <TRUNC>:<> ($TruncFinalLv2$   || $Words$ || $TruncFinal$)
