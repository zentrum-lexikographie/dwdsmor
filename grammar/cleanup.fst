% cleanup.fst
% Version 3.1
% Andreas Nolda 2023-03-20

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"


% clean up inflection-related symbols on analysis level

ALPHABET = [#entry-type# #char# #lemma-index# #paradigm-index# #category# \
            #stem-type# #stem-subtype# #origin# <Abbr><FB><VPART>] \
           <>:[#inflection# #auxiliary# <ge>]

$CleanupInflAnalysis$ = .*


% clean up lemma and paradigm indices

ALPHABET = [#entry-type# #char# #surface-trigger# #category# #stem-type# \
            #stem-subtype# #origin# #inflection# #auxiliary# <Abbr><FB><VPART><ge>] \
           [#lemma-index# #paradigm-index#]:<>

$CleanupIndex$ = .*


% clean up word-formation-related symbols on analysis level

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #wf-process# #wf-means# <FB><VPART>] \
           <>:[#entry-type# #category# #stem-type# #stem-subtype# #origin# <Abbr>]

$CleanupWFAnalysis$ = .*


% clean up word-formation-related symbols

ALPHABET = [#entry-type# #char# #surface-trigger# #inflection# #auxiliary# \
            #wf-trigger# <FB><VPART><ge>] \
           [#category# #stem-type# #stem-subtype# #origin# <Abbr>]:<>

$CleanupWF$ = .*


% clean up orthography-related symbols on analysis level

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #wf-process# #wf-means# #part-of-speech# #feature#] \
           <>:[#orth-trigger#]

$CleanupOrthAnalysis$ = .*


% clean up lemma and paradigm indices on analysis level

ALPHABET = [#char# #morpheme-boundary# #wf-process# #wf-means# \
            #part-of-speech# #feature#] \
           <>:[#lemma-index# #paradigm-index#]

$CleanupIndexAnalysis$ = .*
