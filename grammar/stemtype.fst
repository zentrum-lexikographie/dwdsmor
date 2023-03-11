% stemtype.fst
% Version 2.0
% Andreas Nolda 2023-03-10

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #morpheme-boundary# \
            #lemma-index# #paradigm-index# #category# #stemtype# #origin# \
            #inflection# #auxiliary# <Abbr><FB><VPART><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stemtype#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stemtype#]*

$LC$    = [#lowercase#]               [#char#]*
$LC2UC$ = [#lowercase#]:[#uppercase#] [#char#]*
$UC2LC$ = [#uppercase#]:[#lowercase#] [#char#]*

$BaseStemLC$ = <Stem> <Abbr>? $LC$ .* <base> [^#stemtype#]*
$CompStemLC$ = <Stem> <Abbr>? $LC$ .* <comp> [^#stemtype#]*

$BaseStemDCAnalysis$ = <Stem> <Abbr>? $LC2UC$ .* <base> [^#stemtype#]*
$CompStemDCAnalysis$ = <Stem> <Abbr>? $LC2UC$ .* <comp> [^#stemtype#]*

$BaseStemDC$ = <Stem> <Abbr>? $UC2LC$ .* <base> [^#stemtype#]*
$CompStemDC$ = <Stem> <Abbr>? $UC2LC$ .* <comp> [^#stemtype#]*

$PrefBaseStemDCAnalysis$ = <Prefix> $LC2UC$ .* <Stem> <Abbr>? .* <base> [^#stemtype#]*
$PrefCompStemDCAnalysis$ = <Prefix> $LC2UC$ .* <Stem> <Abbr>? .* <comp> [^#stemtype#]*

$PrefBaseStemDC$ = <Prefix> $UC2LC$ .* <Stem> <Abbr>? .* <base> [^#stemtype#]*
$PrefCompStemDC$ = <Prefix> $UC2LC$ .* <Stem> <Abbr>? .* <comp> [^#stemtype#]*
