% stemtype.fst
% Version 4.6
% Andreas Nolda 2024-10-02

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

ALPHABET = [#char# #boundary-trigger#]

$BaseStemFilterVPPast-t$ = <Stem> .* t
$BaseStemFilterVPPast-n$ = <Stem> .* n
$BaseStemFilterVPPast-d$ = <Stem> .* d

ALPHABET = [#char# #boundary-trigger# #lemma-index# #paradigm-index# #feature#]

$BaseStemFilterVPPresLv2$ = .* <+V> <PPres> .*
$BaseStemFilterVPPastLv2$ = .* <+V> <PPast> .*
