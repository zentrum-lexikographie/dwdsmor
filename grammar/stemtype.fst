% stemtype.fst
% Version 6.4
% Andreas Nolda 2025-07-16

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #pos# #subcat# #stem-type# #suff# #origin# #inflection# #auxiliary# \
            <Abbr><ge>]

$C$ = .
$C$ = $C$-[#stem-type#]

$BaseStemFilter$ = <Stem> .* <base> $C$*
$CompStemFilter$ = <Stem> .* <comp> $C$*
$DerStemFilter$  = <Stem> .* <der>  $C$*

$DerStemFilterSuff-e$    = <Stem> .* <der> <-e>    $C$*
$DerStemFilterSuff-er$   = <Stem> .* <der> <-er>   $C$*
$DerStemFilterSuff-chen$ = <Stem> .* <der> <-chen> $C$*
$DerStemFilterSuff-lein$ = <Stem> .* <der> <-lein> $C$*
$DerStemFilterSuff-zig$  = <Stem> .* <der> <-zig>  $C$*

$BaseStemFilterV$   = (<Pref> .*)? <Stem> .* <V>   <base> $C$*
$BaseStemFilterADJ$ = (<Pref> .*)? <Stem> .* <ADJ> <base> $C$*
$BaseStemFilterORD$ =              <Stem> .* <ORD> <base> $C$*

ALPHABET = [#char# #boundary-trigger#]

$BaseStemFilterVPartPerf_t$ = <Stem> .* t
$BaseStemFilterVPartPerf_n$ = <Stem> .* n
$BaseStemFilterVPartPerf_d$ = <Stem> .* d

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #pos# #subcat# #stem-type# #suff# #origin# <Abbr><ge>] \
           [#inflection# #auxiliary#]:<>

$C$ = .
$C$ = $C$-[#stem-type#]

$Base2CompStem$ = .* <base>:<comp> $C$*

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #pos# #subcat# #wf# #stem-type# #suff# #origin# <Abbr>]

$C$ = .
$C$ = $C$-[#stem-type#]

$Base2CompStemLv2$ = .* <comp>:<base> $C$*

ALPHABET = [#char# #surface-trigger# #boundary-trigger# #index# #pos# #subcat# \
            #wf# #stem-type# #suff# #origin# #degree# #function# #auxiliary#]

$C$ = .
$C$ = $C$-[#pos#]

$BaseStemFilterVInfNonClLv2$ = (.* <Pref> .*)? <Stem> .* <V> $C$* <Inf><NonCl> $C$*
$BaseStemFilterVPartPresLv2$ = (.* <Pref> .*)? <Stem> .* <V> $C$* <Part><Pres> $C$*
$BaseStemFilterVPartPerfLv2$ = (.* <Pref> .*)? <Stem> .* <V> $C$* <Part><Perf> $C$*

$BaseStemFilterADJMascLv2$ = (.* <Pref> .*)? <Stem> .* <ADJ> $C$* <Masc><Nom><Sg><Wk> $C$*
$BaseStemFilterADJFemLv2$  = (.* <Pref> .*)? <Stem> .* <ADJ> $C$* <Fem><Nom><Sg><Wk>  $C$*
$BaseStemFilterADJNeutLv2$ = (.* <Pref> .*)? <Stem> .* <ADJ> $C$* <Neut><Nom><Sg><Wk> $C$*

$BaseStemFilterORDMascLv2$ = <Stem> .* (.* <Suff> .*)? <ORD> $C$* <Masc><Nom><Sg><Wk> $C$*
$BaseStemFilterORDFemLv2$  = <Stem> .* (.* <Suff> .*)? <ORD> $C$* <Fem><Nom><Sg><Wk>  $C$*
$BaseStemFilterORDNeutLv2$ = <Stem> .* (.* <Suff> .*)? <ORD> $C$* <Neut><Nom><Sg><Wk> $C$*
