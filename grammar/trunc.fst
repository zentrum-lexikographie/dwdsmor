% trunc.fst
% Version 3.0
% Andreas Nolda 2025-06-30

#include "symbols.fst"


% truncate initial morpheme sequence

ALPHABET = [#feature# #info#]

$C$ =    [#char# #index# #boundary-trigger# #wf#]
$T$ = <>:[#char# #index# <HB><SB>]
$W$ =    [#wf# #syninfo#]

$TruncInitialLv2$ = $T$* \-:<> <CB> $C$* .*

$TruncInitialRootLv2$ = $W$+ $T$* \-:<> <CB> $C$* .*

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <HB><SB>]:<>

$TruncInitial-CB$ = <WB> $T$* <>:\- <CB> $C$* <WB>

$TruncInitial$ = $TruncInitial-CB$


% truncate final morpheme sequence

ALPHABET = [#wf# #cat# #subcat#] \
           <>:[#auxiliary# #degree# #person# #gender# #case# #number# #infl# \
               #function# #nonfinite# #mood# #tense# #info#]

$C$ =    [#char# #index# #boundary-trigger# #wf# #syninfo#]
$T$ = <>:[#char# #index# <PB><SB>]

$TruncFinalLv2-CB$ = $C$* [^<HB>] <CB> \-:<> $T$* .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-HB$ = $C$* <>:<HB> <CB> \-:<> $T$* .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-VB$ = $C$* <VB> \-:<> $T$* .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2$ = $TruncFinalLv2-CB$ | \
                  $TruncFinalLv2-HB$ | \
                  $TruncFinalLv2-VB$

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <PB><SB>]:<>

$TruncFinal-CB$ = <WB> $C$* [^<HB>] <CB> <>:\- $T$* <WB>

$TruncFinal-HB$ = <WB> $C$* <HB>:<> <CB> <>:\- $T$* <WB>

$TruncFinal-VB$ = <WB> $C$* <VB> <>:\- $T$* <WB>

$TruncFinal$ = $TruncFinal-CB$ | \
               $TruncFinal-HB$ | \
               $TruncFinal-VB$
