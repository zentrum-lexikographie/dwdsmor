% stemtype.fst
% Version 1.1
% Andreas Nolda 2023-01-17

#include "symbols.fst"

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #category# #origin# #inflection# #auxiliary# <Stem><FB><VPART><e><ge>]

$BASESTEMFILTER$ = <Stem> .* <base> .*
$COMPSTEMFILTER$ = <Stem> .* <comp> .*

$C1$ = [#lowercase#]               [#char#]*
$C2$ = [#lowercase#]:[#uppercase#] [#char#]*
$C3$ = [#uppercase#]:[#lowercase#] [#char#]*

$LC$    = $C1$ .*
$LC2UC$ = $C2$ .*
$UC2LC$ = $C3$ .*

$BASESTEMLC$ = <Stem> [#deko-trigger#]* $LC$ <base> .*
$COMPSTEMLC$ = <Stem> [#deko-trigger#]* $LC$ <comp> .*

$BASESTEMDC$ = <Stem> [#deko-trigger#]* $UC2LC$ <base> .*
$COMPSTEMDC$ = <Stem> [#deko-trigger#]* $UC2LC$ <comp> .*

$PREFBASESTEMDC$ = <Prefix> $UC2LC$ <Stem> [#deko-trigger#]* .* <base> .*
$PREFCOMPSTEMDC$ = <Prefix> $UC2LC$ <Stem> [#deko-trigger#]* .* <comp> .*
