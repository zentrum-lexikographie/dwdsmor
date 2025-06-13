% sep.fst
% Version 1.2
% Andreas Nolda 2025-06-13

#include "symbols.fst"


% separate preverb

ALPHABET = <>:[#auxiliary# #subcat# #degree# #person# #gender# #case# \
               #number# #infl# #function# #nonfinite# #mood# #tense# #info#]

$C$ =    [#char# #index#]
$T$ = <>:[#char# #index# #boundary-trigger#]
$W$ =    [#wf#]

$SepPrev1Lv2$ = $C$* <>:<VB> $T$* <+V> .* {<UnmPers><UnmNum><UnmTense><UnmMood>}:{}

$SepPrev1RootLv2$ = $W$+ $T$* <+V> .* {<UnmPers><UnmNum><UnmTense><UnmMood>}:{} | \
                    $SepPrev1Lv2$

$C$ = [#char# #boundary-trigger#]:<>
$T$ = [#char#]

$SepPrev1$ = <WB> $T$* <VB>:<> $C$* <WB>


% separate finite verb

ALPHABET = [#wf# #feature# #info#]-[#nonfinite#]

$C$ =    [#char# #index# #wf# <PB><SB>]
$T$ = <>:[#char# #index# <VB>]
$W$ =    [#wf-process#] <prev()>:[#wf-means#]

$SepPrev2Lv2$ = $T$* <>:<VB> $C$* <+V> .*

$SepPrev2RootLv2$ = $W$+ $C$* <+V> .* | \
                    $SepPrev2Lv2$

$C$ = [#char# <PB><SB>]
$T$ = [#char#]:<>

$SepPrev2$ = <WB> $T$* <VB>:<> $C$* <WB>
