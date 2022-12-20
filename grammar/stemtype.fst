% stemtype.fst
% Version 1.0
% Andreas Nolda 2022-12-20

#include "symbols.fst"

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #category# #origin# #inflection# #auxiliary# <Stem><FB><VPART><e><ge>]

$BASESTEMFILTER$ = <Stem> .* <base> .*
$COMPSTEMFILTER$ = <Stem> .* <comp> .*

$C1$ = [#lowercase#]:[#uppercase#] [#char#]*
$C2$ = [#uppercase#]:[#lowercase#] [#char#]*

$DC$ = $C1$ .*

$BASESTEMDC$ = <Stem> [#deko-trigger#]* $C2$ .* <base> .*
$COMPSTEMDC$ = <Stem> [#deko-trigger#]* $C2$ .* <comp> .*
