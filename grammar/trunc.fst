% trunc.fst
% Version 2.0
% Andreas Nolda 2024-11-19

#include "symbols.fst"


% truncate initial morpheme sequence

ALPHABET = [#feature# #info#]

$C$ =    [#char# #lemma-index# #paradigm-index# #boundary-trigger# \
          #wf-process# #wf-means#]
$T$ = <>:[#char# #lemma-index# #paradigm-index# <HB><SB>]

$TruncInitialLv2-CB$ = $T$* \-:<> <CB> $C$* .*

$TruncInitialLv2$ = $TruncInitialLv2-CB$

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <HB><SB>]:<>

$TruncInitial-CB$ = <WB> $T$* <>:\- <CB> $C$* <WB>

$TruncInitial$ = $TruncInitial-CB$


% truncate final morpheme sequence

ALPHABET = [#wf-process# #wf-means# #part-of-speech#] \
           <>:[#category# #auxiliary# #subcat# #degree# #person# #gender# #case# \
               #number# #infl# #function# #nonfinite# #mood# #tense# #info#]

$C$ =    [#char# #lemma-index# #paradigm-index# #boundary-trigger# \
          #wf-process# #wf-means#]
$T$ = <>:[#char# #lemma-index# #paradigm-index# <PB><SB>]

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
