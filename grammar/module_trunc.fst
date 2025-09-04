% module_trunc.fst
% Version 4.0
% Andreas Nolda 2025-07-09

% truncate initial morpheme sequence

ALPHABET = [#feature# #info#]

$C$ = [#char# #index# #boundary-trigger# #wf#]
$T$ = <>:[#char# #index# <IB><SB>]
$W$ = [#wf# #syninfo#]
$H$ = \-:<>

$TruncInitialLv2$ = $T$* $H$ <CB> $C$* .*

$TruncInitialRootLv2$ = $W$+ $T$* $H$ <CB> $C$* .*

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <IB><SB>]:<>
$H$ = <>:\-

$TruncInitial$ = <WB> $T$* $H$ <CB> $C$* <WB>


% truncate final morpheme sequence

ALPHABET = [#wf# #degree#] \
           <>:[#auxiliary# #person# #gender# #case# #number# #infl# #function# \
               #nonfinite# #mood# #tense# #info#]
$C$ = [#char# #index# #boundary-trigger# #wf# #syninfo#]
$T$ = <>:[#char# #index# <PB><SB>]
$I$ = ($C$-[<CB><IB>])* <>:<IB> $T$*
$H$ = \-:<>

$TruncFinalLv2-NN-CB$  = ($C$* <CB>)? $I$? <CB> $H$ $T$* .* <NN>  .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-NN-VB$  = $C$*              <VB> $H$ $T$* .* <NN>  .* {<UnmGend><UnmCase><UnmNum>}:{}

$TruncFinalLv2-ADJ-VB$ = $C$*              <VB> $H$ $T$* .* <ADJ> .* {<UnmFunc><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$TruncFinalLv2-V-VB$   = $C$*              <VB> $H$ $T$* .* <V>   .* {<UnmPers><UnmNum><UnmTense><UnmMood>}:{}

$TruncFinalLv2$ = $TruncFinalLv2-NN-CB$  | \
                  $TruncFinalLv2-NN-VB$  | \
                  $TruncFinalLv2-ADJ-VB$ | \
                  $TruncFinalLv2-V-VB$

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <PB><SB>]:<>
$I$ = ($C$-[<CB><IB>])* <IB>:<> $T$*
$H$ = <>:\-

$TruncFinal-CB$ = <WB> ($C$* <CB>)? $I$? <CB> $H$ $T$* <WB>

$TruncFinal-VB$ = <WB> $C$*              <VB> $H$ $T$* <WB>

$TruncFinal$ = $TruncFinal-CB$ | \
               $TruncFinal-VB$
