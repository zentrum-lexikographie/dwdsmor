% stemtype.fst
% Version 4.4
% Andreas Nolda 2023-07-03

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stem-type#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stem-type#]*
$DerStemFilter$  = <Stem> .* <der>  [^#stem-type#]*

$DerStemFilterSuff-e$    = <Stem> .* <der> <-e>    [^#stem-type#]*
$DerStemFilterSuff-er$   = <Stem> .* <der> <-er>   [^#stem-type#]*
$DerStemFilterSuff-chen$ = <Stem> .* <der> <-chen> [^#stem-type#]*
$DerStemFilterSuff-lein$ = <Stem> .* <der> <-lein> [^#stem-type#]*

$BaseStemFilterV$ = (<Prefix> .*)? <Stem> .* <V> <base> [^#stem-type#]*

ALPHABET = [#char# #boundary-trigger# #lemma-index# #paradigm-index# #feature#]

$BaseStemFilterVPPastLv2$ = .* <+V> <PPast> .*
$BaseStemFilterVPPresLv2$ = .* <+V> <PPres> .*
