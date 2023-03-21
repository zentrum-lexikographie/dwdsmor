% stemtype.fst
% Version 2.2
% Andreas Nolda 2023-03-21

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #stem-type# #stem-subtype# \
            #origin# #inflection# #auxiliary# <Abbr><FB><VPART><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stem-type#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stem-type#]*
$DerStemFilter$  = <Stem> .* <der>  [^#stem-type#]*

$DerStemDimFilter$  = <Stem> .* <der> <dim> [^#stem-type# #stem-subtype#]*

$LC2UC$ = [#lowercase#]:[#uppercase#] [#char#]*
$UC2LC$ = [#uppercase#]:[#lowercase#] [#char#]*

$StemDCAnalysis$ = [#entry-type#] <Abbr>? $LC2UC$ .*
$StemDC$         = [#entry-type#] <Abbr>? $UC2LC$ .*
