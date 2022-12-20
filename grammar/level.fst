% level.fst
% Version 1.0
% Andreas Nolda 2022-12-20

#include "symbols.fst"

ALPHABET = [#entry-type# #deko-trigger# #char# #lemma-index# #paradigm-index# \
            #category# #origin# #inflection# #auxiliary# <FB><VPART><ge>]

$BASELEVEL$ = <Stem> .* <base> .*

$COMPLEVEL$ = <Stem> .* <comp> .*
