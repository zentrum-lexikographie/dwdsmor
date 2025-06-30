% stemtype.fst
% Version 6.0
% Andreas Nolda 2025-06-30

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #cat# #subcat# #stem-type# #suff# #origin# #inflection# #auxiliary# \
            <Abbr><ge>]

$BaseStemFilter$ = <Stem> .* <base> [^#stem-type#]*
$CompStemFilter$ = <Stem> .* <comp> [^#stem-type#]*
$DerStemFilter$  = <Stem> .* <der>  [^#stem-type#]*

$DerStemFilterSuff-e$    = <Stem> .* <der> <-e>    [^#stem-type#]*
$DerStemFilterSuff-er$   = <Stem> .* <der> <-er>   [^#stem-type#]*
$DerStemFilterSuff-chen$ = <Stem> .* <der> <-chen> [^#stem-type#]*
$DerStemFilterSuff-lein$ = <Stem> .* <der> <-lein> [^#stem-type#]*

$BaseStemFilterV$ = (<Pref> .*)? <Stem> .* <V> <base> [^#stem-type#]*

ALPHABET = [#char# #boundary-trigger#]

$BaseStemFilterVPartPerf_t$ = <Stem> .* t
$BaseStemFilterVPartPerf_n$ = <Stem> .* n
$BaseStemFilterVPartPerf_d$ = <Stem> .* d

ALPHABET = [#char# #boundary-trigger# #index# #wf# #stem-type# #origin# \
            #auxiliary#]

$BaseStemFilterVPartPresLv2$ = (.* <Pref> .*)? <Stem> .* <V> .* <Part><Pres> .*
$BaseStemFilterVPartPerfLv2$ = (.* <Pref> .*)? <Stem> .* <V> .* <Part><Perf> .*
