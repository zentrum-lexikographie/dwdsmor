% macro_sep-root.fst
% Version 1.0
% Andreas Nolda 2025-09-04

% preverb separation

$Words$ = $Words$ | <SEP>:<> ($SepPrev1RootLv2$ || $Words$ || $SepPrev1$) | \
                    <SEP>:<> ($SepPrev2RootLv2$ || $Words$ || $SepPrev2$)
