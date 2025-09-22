% module_sep.fst
% Version 2.1
% Andreas Nolda 2025-09-22

% separate preverb

ALPHABET = <>:[#auxiliary# #degree# #person# #gender# #case# #number# #infl# \
               #function# #nonfinite# #mood# #tense# #info#]

$C$ = [#weight# #char# #index#]
$T$ = <>:[#weight# #char# #index# #boundary-trigger#]
$F$ = [#wf#]

$SepPrev1Lv2$ = $C$* <>:<VB> $T$* <V> .* {<UnmPers><UnmNum><UnmTense><UnmMood>}:{}

$SepPrev1RootLv2$ = $F$+ $T$* <V> .* {<UnmPers><UnmNum><UnmTense><UnmMood>}:{} | \
                    $SepPrev1Lv2$

$C$ = [#char#]
$T$ = [#char# #boundary-trigger#]:<>

$SepPrev1$ = <WB> $C$* <VB>:<> $T$* <WB>


% separate finite verb

ALPHABET = [#wf# #feature# #info#]-[#nonfinite#]

$C$ = [#weight# #char# #index# #wf# <PB><SB>]
$T$ = <>:[#weight# #char# #index# <VB>]
$F$ = [#wf-process#] <prev()>:[#wf-means#]

$SepPrev2Lv2$ = $T$* <>:<VB> $C$* <V> .*

$SepPrev2RootLv2$ = $F$+ $C$* <V> .* | \
                    $SepPrev2Lv2$

$C$ = [#char# <PB><SB>]
$T$ = [#char#]:<>

$SepPrev2$ = <WB> $T$* <VB>:<> $C$* <WB>
