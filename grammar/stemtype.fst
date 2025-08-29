% stemtype.fst
% Version 6.8
% Andreas Nolda 2025-08-29

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger# #index# #pos# #subcat# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>]

$C$ = .
$C$ = $C$-[#stem-type#]

$BaseStemFilter$ = .* <base> $C$*
$CompStemFilter$ = .* <comp> $C$*
$DerStemFilter$  = .* <der>  $C$*

$DerStemFilterSuff-e$    = .* <der> <-e>    $C$*
$DerStemFilterSuff-er$   = .* <der> <-er>   $C$*
$DerStemFilterSuff-chen$ = .* <der> <-chen> $C$*
$DerStemFilterSuff-lein$ = .* <der> <-lein> $C$*
$DerStemFilterSuff-bar$  = .* <der> <-bar>  $C$*
$DerStemFilterSuff-zig$  = .* <der> <-zig>  $C$*

$BaseStemFilterV$    = .* <V>    <base> $C$*
$BaseStemFilterAdj$  = .* <ADJ>  <base> $C$*
$BaseStemFilterOrd$  = .* <ORD>  <base> $C$*
$BaseStemFilterFrac$ = .* <FRAC> <base> $C$*

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger#]

$BaseStemFilterVPartPerf_t$ = .* t
$BaseStemFilterVPartPerf_n$ = .* n
$BaseStemFilterVPartPerf_d$ = .* d

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger# #index# #pos# #subcat# #stem-type# #suff# \
            #origin# <Abbr><ge>] \
           [#inflection# #auxiliary#]:<>

$C$ = .
$C$ = $C$-[#stem-type#]

$Base2CompStem$     = .* <base>:<comp>           $C$*
$Base2DerStem-st$   = .* <base>:<der> <>:<-st>   $C$*
$Base2DerStem-stel$ = .* <base>:<der> <>:<-stel> $C$*

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger# #index# #pos# #subcat# #wf# #stem-type# #suff# \
            #origin# <Abbr>]

$C$ = .
$C$ = $C$-[#stem-type#]

$Base2CompStemLv2$     = .* <comp>:<base>         $C$*
$Base2DerStem-stLv2$   = .* <der>:<base> <-st>:<> $C$*
$Base2DerStem-stelLv2$ = .* <der>:<base> <-stel>:<> $C$*

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger# #index# #pos# #subcat# #wf# #stem-type# #suff# \
            #origin# #degree# #function# #auxiliary#]

$C$ = .
$C$ = $C$-[#pos#]

$BaseStemFilterVInfNonClLv2$ = .* <V> $C$* <Inf><NonCl> $C$*
$BaseStemFilterVPartPresLv2$ = .* <V> $C$* <Part><Pres> $C$*
$BaseStemFilterVPartPerfLv2$ = .* <V> $C$* <Part><Perf> $C$*

$BaseStemFilterAdjMascLv2$ = .* <ADJ> $C$* <Attr/Subst><Masc><Nom><Sg><Wk> $C$*
$BaseStemFilterAdjFemLv2$  = .* <ADJ> $C$* <Attr/Subst><Fem><Nom><Sg><Wk>  $C$*
$BaseStemFilterAdjNeutLv2$ = .* <ADJ> $C$* <Attr/Subst><Neut><Nom><Sg><Wk> $C$*

$BaseStemFilterOrdMascLv2$ = .* <ORD> $C$* <Attr/Subst><Masc><Nom><Sg><Wk> $C$*
$BaseStemFilterOrdFemLv2$  = .* <ORD> $C$* <Attr/Subst><Fem><Nom><Sg><Wk>  $C$*
$BaseStemFilterOrdNeutLv2$ = .* <ORD> $C$* <Attr/Subst><Neut><Nom><Sg><Wk> $C$*

$BaseStemFilterFracLv2$ = .* <DER> <suff(stel)> <Suff> <s>tel <FRAC> $C$* <Subst><UnmGend><UnmCase><Pl><UnmInfl> $C$*
