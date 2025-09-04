% macro_trunc-root.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% morpheme truncation

$Words$ = $Words$ | <TRUNC>:<> ($TruncInitialRootLv2$ || $Words$ || $TruncInitial$) | \
                    <TRUNC>:<> ($TruncFinalLv2$       || $Words$ || $TruncFinal$)
