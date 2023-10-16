% trunc.fst
% Version 1.0
% Andreas Nolda 2023-10-16

#include "symbols.fst"


% truncate initial morpheme sequence

ALPHABET = [#feature# #info#]

$C$ =    [#char# #lemma-index# #paradigm-index# #boundary-trigger# \
          #wf-process# #wf-means#]
$T$ = <>:[#char# #lemma-index# #paradigm-index# <HB><FB>]

$TruncInitialLv2-CB$ = $T$* \-:<> <CB> $C$* .*

$TruncInitialLv2$ = $TruncInitialLv2-CB$

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <HB><FB>]:<>

$TruncInitial-CB$ = <WB> $T$* <>:\- <CB> $C$* <WB>

$TruncInitial$ = $TruncInitial-CB$


% truncate final morpheme sequence

ALPHABET = [#wf-process# #wf-means# #part-of-speech#] \
           <>:[#category# #auxiliary# #subcat# #degree# #person# #gender# #case# \
               #number# #infl# #function# #nonfinite# #mood# #tense# #info#]

$C$ =    [#char# #lemma-index# #paradigm-index# #boundary-trigger# \
          #wf-process# #wf-means#]
$T$ = <>:[#char# #lemma-index# #paradigm-index# <FB>]

$TruncFinalLv2-CB$ = $C$* [^<HB>] <CB> \-:<> $T$* .* <Invar>:<>

$TruncFinalLv2-HB$ = $C$* <>:<HB> <CB> \-:<> $T$* .* <Invar>:<>

$TruncFinalLv2-VB$ = $C$* <VB> \-:<> $T$* .* <Invar>:<>

$TruncFinalLv2$ = $TruncFinalLv2-CB$ | \
                  $TruncFinalLv2-HB$ | \
                  $TruncFinalLv2-VB$

$C$ = [#char# #boundary-trigger#]
$T$ = [#char# <FB>]:<>

$TruncFinal-CB$ = <WB> $C$* [^<HB>] <CB> <>:\- $T$* <WB>

$TruncFinal-HB$ = <WB> $C$* <HB>:<> <CB> <>:\- $T$* <WB>

$TruncFinal-VB$ = <WB> $C$* <VB> <>:\- $T$* <WB>

$TruncFinal$ = $TruncFinal-CB$ | \
               $TruncFinal-HB$ | \
               $TruncFinal-VB$
