% cleanup.fst
% Version 4.1
% Andreas Nolda 2023-03-24

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"


% clean up inflection-related symbols on analysis level

ALPHABET = [#entry-type# #char# #lemma-index# #paradigm-index# #category# \
            #stem-type# #stem-subtype# #origin# <Abbr><FB><VB>] \
           <>:[#inflection# #auxiliary# <ge>]

$CleanupInflAnalysis$ = .*


% clean up lemma and paradigm indices

ALPHABET = [#entry-type# #char# #surface-trigger# #category# #stem-type# \
            #stem-subtype# #origin# #inflection# #auxiliary# <Abbr><FB><VB><ge>] \
           [#lemma-index# #paradigm-index#]:<>

$CleanupIndex$ = .*


% clean up word-formation-related symbols on analysis level

ALPHABET = [#char# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #wf-process# #wf-means#] \
           <>:[#entry-type# #category# #stem-type# #stem-subtype# #origin# <Abbr>]

$CleanupWFAnalysis$ = .*


% clean up word-formation-related symbols

ALPHABET = [#char# #surface-trigger# #orth-trigger# #boundary-trigger# #inflection# #auxiliary# <ge>] \
           [#entry-type# #category# #stem-type# #stem-subtype# #origin# <Abbr>]:<>

$CleanupWF$ = .*


% clean up orthography-related symbols on analysis level

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #wf-process# #wf-means# #feature# #metainfo#] \
           <>:[#orthinfo#]

$CleanupOrthAnalysis$ = .*


% clean up lemma and paradigm indices on analysis level

ALPHABET = [#char# #morpheme-boundary# #wf-process# #wf-means# #feature# #info#] \
           <>:[#lemma-index# #paradigm-index#]

$CleanupIndexAnalysis$ = .*
