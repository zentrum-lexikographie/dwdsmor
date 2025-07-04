% trunc.fst
% Version 3.2
% Andreas Nolda 2025-07-04

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

ALPHABET = [#wf# #degree#] \
           <>:[#auxiliary# #person# #gender# #case# #number# #infl# #function# \
               #nonfinite# #mood# #tense# #info#]

$C$ =    [#char# #index# #boundary-trigger# #wf# #syninfo#]
$T$ = <>:[#char# #index# <PB><SB>]

$TruncFinalLv2-NN-CB$  = $C$* [^<HB>] <CB> \-:<> $T$* .* <NN>  .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-NN-HB$  = $C$* <>:<HB> <CB> \-:<> $T$* .* <NN>  .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-NN-VB$  = $C$*         <VB> \-:<> $T$* .* <NN>  .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-ADJ-VB$ = $C$*         <VB> \-:<> $T$* .* <ADJ> .* {<UnmFunc><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$TruncFinalLv2-V-VB$   = $C$*         <VB> \-:<> $T$* .* <V>   .* {<UnmPers><UnmNum><UnmTense><UnmMood>}:{}

$TruncFinalLv2$ = $TruncFinalLv2-NN-CB$  | \
                  $TruncFinalLv2-NN-HB$  | \
                  $TruncFinalLv2-NN-VB$  | \
                  $TruncFinalLv2-ADJ-VB$ | \
                  $TruncFinalLv2-V-VB$

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <PB><SB>]:<>

$TruncFinal-CB$ = <WB> $C$* [^<HB>] <CB> <>:\- $T$* <WB>

$TruncFinal-HB$ = <WB> $C$* <HB>:<> <CB> <>:\- $T$* <WB>

$TruncFinal-VB$ = <WB> $C$* <VB> <>:\- $T$* <WB>

$TruncFinal$ = $TruncFinal-CB$ | \
               $TruncFinal-HB$ | \
               $TruncFinal-VB$
