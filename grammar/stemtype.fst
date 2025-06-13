% stemtype.fst
% Version 5.0
% Andreas Nolda 2025-06-13

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #category# #stem-type# #suff# #origin# #inflection# #auxiliary# \
            <Abbr><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stem-type#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stem-type#]*
$DerStemFilter$  = <Stem> .* <der>  [^#stem-type#]*

$DerStemFilterSuff-e$    = <Stem> .* <der> <-e>    [^#stem-type#]*
$DerStemFilterSuff-er$   = <Stem> .* <der> <-er>   [^#stem-type#]*
$DerStemFilterSuff-chen$ = <Stem> .* <der> <-chen> [^#stem-type#]*
$DerStemFilterSuff-lein$ = <Stem> .* <der> <-lein> [^#stem-type#]*

$BaseStemFilterV$ = (<Prefix> .*)? <Stem> .* <V> <base> [^#stem-type#]*

ALPHABET = [#char# #boundary-trigger#]

$BaseStemFilterVPartPerf-t$ = <Stem> .* t
$BaseStemFilterVPartPerf-n$ = <Stem> .* n
$BaseStemFilterVPartPerf-d$ = <Stem> .* d

ALPHABET = [#wf# #char# #boundary-trigger# #index# #feature#]

$BaseStemFilterVPartPresLv2$ = .* <+V> <Part><Pres> .*
$BaseStemFilterVPartPerfLv2$ = .* <+V> <Part><Perf> .*
