% stemtype.fst
% Version 6.6
% Andreas Nolda 2025-07-28

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

$BaseStemFilterV$   = (<Pref> .*)? <Stem> .* <V>    <base> $C$*
$BaseStemFilterAdj$ = (<Pref> .*)? <Stem> .* <ADJ>  <base> $C$*
$BaseStemFilterOrd$ =              <Stem> .* <ORD>  <base> $C$*
$BaseStemFilterFrac$ =             <Stem> .* <FRAC> <base> $C$*

ALPHABET = [#char# #boundary-trigger#]

$BaseStemFilterVPartPerf_t$ = <Stem> .* t
$BaseStemFilterVPartPerf_n$ = <Stem> .* n
$BaseStemFilterVPartPerf_d$ = <Stem> .* d

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #pos# #subcat# #stem-type# #suff# #origin# <Abbr><ge>] \
           [#inflection# #auxiliary#]:<>

$C$ = .
$C$ = $C$-[#stem-type#]

$Base2CompStem$     = .* <base>:<comp>           $C$*
$Base2DerStem-st$   = .* <base>:<der> <>:<-st>   $C$*
$Base2DerStem-stel$ = .* <base>:<der> <>:<-stel> $C$*

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #index# \
            #pos# #subcat# #wf# #stem-type# #suff# #origin# <Abbr>]

$C$ = .
$C$ = $C$-[#stem-type#]

$Base2CompStemLv2$     = .* <comp>:<base>         $C$*
$Base2DerStem-stLv2$   = .* <der>:<base> <-st>:<> $C$*
$Base2DerStem-stelLv2$ = .* <der>:<base> <-stel>:<> $C$*

ALPHABET = [#char# #surface-trigger# #boundary-trigger# #index# #pos# #subcat# \
            #wf# #stem-type# #suff# #origin# #degree# #function# #auxiliary#]

$C$ = .
$C$ = $C$-[#pos#]

$BaseStemFilterVInfNonClLv2$ = (.* <Pref> .*)? <Stem> .* <V> $C$* <Inf><NonCl> $C$*
$BaseStemFilterVPartPresLv2$ = (.* <Pref> .*)? <Stem> .* <V> $C$* <Part><Pres> $C$*
$BaseStemFilterVPartPerfLv2$ = (.* <Pref> .*)? <Stem> .* <V> $C$* <Part><Perf> $C$*

$BaseStemFilterAdjMascLv2$ = (.* <Pref> .*)? <Stem> .* <ADJ> $C$* <Attr/Subst><Masc><Nom><Sg><Wk> $C$*
$BaseStemFilterAdjFemLv2$  = (.* <Pref> .*)? <Stem> .* <ADJ> $C$* <Attr/Subst><Fem><Nom><Sg><Wk>  $C$*
$BaseStemFilterAdjNeutLv2$ = (.* <Pref> .*)? <Stem> .* <ADJ> $C$* <Attr/Subst><Neut><Nom><Sg><Wk> $C$*

$BaseStemFilterOrdMascLv2$ = (<Stem> .* (<Suff> .*)? (<Intf> .*)?)* <Stem> .* (<Suff> .*)* <ORD> $C$* <Attr/Subst><Masc><Nom><Sg><Wk> $C$*
$BaseStemFilterOrdFemLv2$  = (<Stem> .* (<Suff> .*)? (<Intf> .*)?)* <Stem> .* (<Suff> .*)* <ORD> $C$* <Attr/Subst><Fem><Nom><Sg><Wk>  $C$*
$BaseStemFilterOrdNeutLv2$ = (<Stem> .* (<Suff> .*)? (<Intf> .*)?)* <Stem> .* (<Suff> .*)* <ORD> $C$* <Attr/Subst><Neut><Nom><Sg><Wk> $C$*

$BaseStemFilterFracLv2$ = (<Stem> .* (<Suff> .*)? (<Intf> .*)?)* <Stem> .* (<Suff> .*)* <DER> <suff(stel)> <Suff> <s>tel <FRAC> $C$* <Subst><UnmGend><UnmCase><Pl><UnmInfl> $C$*
