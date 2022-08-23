% map.fst
% Version 1.1
% Andreas Nolda 2022-08-23

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

ALPHABET = [#char# #lemma-index# #paradigm-index# #category# #stemtype#] \
           <>:[#entry-type# #deko-trigger# #origin# #inflection# #auxiliary# <FB>]

$MAP1$ = (. | <VPART> <V>:<><X>:<> <>:<ge>? [#char#])*

$ANY$ = [#entry-type# #deko-trigger# #char# #morpheme_boundary_marker# #lemma-index# #paradigm-index# \
         #category# #stemtype# #origin# #inflection# #auxiliary# <FB><VPART><e>]*

ALPHABET = [#entry-type# #deko-trigger# #char# #morpheme_boundary_marker# #lemma-index# #paradigm-index# \
            #category# #stemtype# #origin# #inflection# #auxiliary# <FB><VPART>] \
           e:<e>

$E$ = e <=> <e> ([lr] [#lemma-index#]? [#paradigm-index#]? <V><base><nativ><VVReg-el/er>)

ALPHABET = [#entry-type# #char# #morpheme_boundary_marker# \
            #inflection# #auxiliary# <FB><VPART><e><ge>] \
           [#lemma-index# #paradigm-index# #category# #stemtype# #origin# <NoPref>]:<>

$MAP2$ = $ANY$ || $E$ || .*
