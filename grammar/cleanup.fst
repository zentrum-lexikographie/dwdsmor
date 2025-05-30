% cleanup.fst
% Version 5.6
% Andreas Nolda 2025-05-09

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"


% clean up inflection-related symbols on analysis level

ALPHABET = [#entry-type# #char# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #stem-type# #suff# #origin# #orthinfo# <Abbr>] \
           <>:[#inflection# #auxiliary# <ge>]

$CleanupInflLv2$ = .*


% clean up lemma and paradigm indices

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #category# \
            #stem-type# #suff# #origin# #inflection# #auxiliary# #orthinfo# \
            <Abbr><ge>] \
           [#lemma-index# #paradigm-index#]:<>

$CleanupIndex$ = .*


% clean up lexical orthography markers

ALPHABET = [#entry-type# #char# #surface-trigger# #boundary-trigger# #category# \
            #stem-type# #suff# #origin# #inflection# #auxiliary# <Abbr><ge>] \
           [#orthinfo#]:<>

$CleanupOrth$ = .*


% clean up word boundaries

ALPHABET = [#char# <CB><VB><HB><DB><PB><SB>] \
           <WB>:<>

$CleanupWB$ = .*


% clean up word boundaries on analysis level

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info# \
            <CB><VB><HB><DB><PB><SB>] \
           <>:<WB>

$CleanupWBLv2$ = .*


% clean up word-formation-related symbols on analysis level

ALPHABET = [#char# #orth-trigger# #boundary-trigger# #lemma-index# \
            #paradigm-index# #wf-process# #wf-means# #orthinfo#] \
           <>:[#entry-type# #category# #stem-type# #suff# #origin# <Abbr>]

$CleanupWFLv2$ = .*


% clean up word-formation-related symbols

ALPHABET = [#char# #surface-trigger# #orth-trigger# #boundary-trigger# \
            #inflection# #auxiliary# <ge>] \
           [#entry-type# #category# #stem-type# #suff# #origin# <Abbr>]:<>

$CleanupWF$ = .*


% clean up categories on analysis level

ALPHABET = [#char# #orth-trigger# #boundary-trigger# #lemma-index# \
            #paradigm-index# #wf-process# #wf-means# #orthinfo#] \
           <>:[#part-of-speech# #nonfinite# #tense# #function# #auxiliary#]

$CleanupCatLv2$ = .*


% clean up lemma and paradigm indices on analysis level

ALPHABET = [#char# #morpheme-boundary# #feature# #info#] \
           <>:[#lemma-index# #paradigm-index#]

$CleanupIndexLv2$ = .*
