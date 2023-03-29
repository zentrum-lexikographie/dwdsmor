% stemtype.fst
% Version 4.1
% Andreas Nolda 2023-03-29

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stem-type#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stem-type#]*
$DerStemFilter$  = <Stem> .* <der>  [^#stem-type#]*

$DerStemFilter-er$   = <Stem> .* <der> <er>   [^#stem-type#]*
$DerStemFilter-chen$ = <Stem> .* <der> <chen> [^#stem-type#]*
$DerStemFilter-lein$ = <Stem> .* <der> <lein> [^#stem-type#]*
