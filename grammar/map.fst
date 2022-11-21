% map.fst
% Version 2.0
% Andreas Nolda 2022-11-21

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

ALPHABET = [#char# #lemma-index# #paradigm-index#] \
           <>:[#entry-type# #deko-trigger# #category# #stemtype# #origin# #inflection# #auxiliary# <FB>]

$MAP1$ = (. | <VPART> <V>:<> <>:<ge>? [#char#])*

$ANY$ = [#entry-type# #deko-trigger# #char# #morpheme_boundary_marker# #lemma-index# #paradigm-index# \
         #category# #stemtype# #origin# #inflection# #auxiliary# <FB><VPART><e>]*

ALPHABET = [#entry-type# #deko-trigger# #char# #morpheme_boundary_marker# #lemma-index# #paradigm-index# \
            #category# #stemtype# #origin# #inflection# #auxiliary# <FB><VPART>] \
           e:<e>

$E$ = e <=> <e> ([lr] [#lemma-index#]? [#paradigm-index#]? <V> [#stemtype#] [#origin#] <VVReg-el/er>)

ALPHABET = [#entry-type# #char# #morpheme_boundary_marker# \
            #category# #stemtype# #origin# #inflection# #auxiliary# <FB><VPART><e><ge>] \
           [#lemma-index# #paradigm-index# <NoPref>]:<>

$MAP2$ = $ANY$ || $E$ || .*
