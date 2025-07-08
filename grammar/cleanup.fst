% cleanup.fst
% Version 6.2
% Andreas Nolda 2025-07-08

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"


% clean up inflection-related symbols on analysis level

ALPHABET = [#entry-type# #char# #boundary-trigger# #index# #pos# #subcat# \
            #stem-type# #suff# #origin# #orthinfo# <Abbr>] \
           <>:[#inflection# #auxiliary# <ge>]

$CleanupInflLv2$ = .*


% clean up lemma and paradigm indices

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #pos# \
            #subcat# #stem-type# #suff# #origin# #inflection# #auxiliary# \
            #orthinfo# <Abbr><ge>] \
           [#index#]:<>

$CleanupIndex$ = .*


% clean up lexical orthography markers

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #pos# \
           #subcat# #stem-type# #suff# #origin# #inflection# #auxiliary# \
           <Abbr><ge>] \
           [#orthinfo#]:<>

$CleanupOrth$ = .*


% clean up word boundaries

ALPHABET = [#char# <CB><VB><HB><DB><PB><SB>] \
           <WB>:<>

$CleanupWB$ = .*


% clean up word boundaries on analysis level

ALPHABET = [#char# #index# #feature# #info# \
            <CB><VB><HB><DB><PB><SB>] \
           <>:<WB>

$CleanupWBLv2$ = .*


% clean up affixes in root lemmas on the analysis level

ALPHABET = [#wf# #pos# #subcat# #stem-type# #index# #suff# #origin#]

$C$ =    [#char# #surface-trigger# #boundary-trigger#]
$D$ = <>:[#char# #surface-trigger# #boundary-trigger#]
$O$ = <>:[#orth-trigger#]

$Pref$ =    $O$* .* <Pref> $D$+ <>:[<VB><DB>] $O$*
$Suff$ = <>:<DB> .* <Suff> $D$+ .*

$CleanupAffRootLv2$ = ($Pref$* .* $O$* <Stem> <Abbr>? $C$+ .* $Suff$* .* <HB>? <CB>)* \
                      ($Pref$* .* $O$* <Stem> <Abbr>? $C$+ .* $Suff$*)


% clean up word-formation-related symbols on analysis level

ALPHABET = [#char# #surface-trigger# #orth-trigger# #boundary-trigger# #index# \
            #orthinfo#] \
           <>:[#entry-type# #stem-type# #suff# #origin# #wf# <Abbr>]

$CleanupWFLv2$ = (.* <>:[#pos#] <>:[#subcat#]?)* .* [#pos#] [#subcat#]? .*

ALPHABET = [#char# #surface-trigger# #orth-trigger# #boundary-trigger# #index# \
            #wf# #orthinfo#] \
           <>:[#entry-type# #stem-type# #suff# #origin# <Abbr>]

$CleanupWFRootLv2$ = (.* <>:[#pos#] <>:[#subcat#]?)* .* [#pos#] [#subcat#]? .*


% clean up word-formation-related symbols

ALPHABET = [#char# #surface-trigger# #orth-trigger# #boundary-trigger# #phon-trigger# \
            #inflection# #auxiliary# <ge>] \
           [#entry-type# #pos# #subcat# #stem-type# #suff# #origin# #wf# <Abbr>]:<>

$CleanupWF$ = .*


% clean up categories on analysis level

ALPHABET = [#entry-type# #char# #orth-trigger# #boundary-trigger# #index# #pos# \
            #subcat# #stem-type# #origin# #wf# #orthinfo#] \
           <>:[#degree# #gender# #case# #number# #infl# #function# #nonfinite# \
               #tense# #auxiliary#]

$CleanupCatLv2$ = .*


% clean up lemma and paradigm indices on analysis level

ALPHABET = [#char# #morpheme-boundary# #wf# #feature# #info#] \
           <>:[#index#]

$CleanupIndexLv2$ = .*
