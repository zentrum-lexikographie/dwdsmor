% stemtype.fst
% Version 4.0
% Andreas Nolda 2023-03-29

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stem-type#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stem-type#]*
$DerStemFilter$  = <Stem> .* <der>  [^#stem-type#]*

$DerStemChenFilter$ = <Stem> .* <der> <chen> [^#stem-type#]*
$DerStemLeinFilter$ = <Stem> .* <der> <lein> [^#stem-type#]*
