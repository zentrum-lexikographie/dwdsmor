% map.fst
% Version 3.1
% Andreas Nolda 2022-12-05

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

ALPHABET = [#char# #lemma-index# #paradigm-index#] \
           <>:[#entry-type# #deko-trigger# #category# #stemtype# #origin# \
               #inflection# #auxiliary# <ge>] \
           <#>:<VPART> \
           <\~>:<FB>

$MAP1$ = (. | <VPART> <V>:<> <>:<ge>? [#char#])*

$ANY$ = [#entry-type# #deko-trigger# #char# #morpheme-boundary# #lemma-index# \
         #paradigm-index# #category# #stemtype# #origin# #inflection# #auxiliary# \
         <FB><VPART><e><ge>]*

ALPHABET = [#entry-type# #deko-trigger# #char# #morpheme-boundary# #lemma-index# \
            #paradigm-index# #category# #stemtype# #origin# #inflection# #auxiliary# \
            <FB><VPART><ge>] \
           e:<e>

$E$ = e <=> <e> ([lr] [#lemma-index#]? [#paradigm-index#]? \
                 <V> [#stemtype#] [#origin#] <VVReg-el/er>)

ALPHABET = [#entry-type# #deko-trigger# #char# #category# #stemtype# #origin# #inflection# #auxiliary# \
            <FB><VPART><e><ge>] \
           [#morpheme-boundary# #lemma-index# #paradigm-index#]:<>

$MAP2$ = $ANY$ || $E$ || .*
