% wf-base.fst
% Version 1.1
% Andreas Nolda 2022-12-05

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #category# #origin# #inflection# #auxiliary# <Stem><FB><VPART><e><ge>]

$BaseStems$ = $LEX$ || <Stem> .* <base> .*

ALPHABET = [#entry-type# #deko-trigger# #char# #morpheme-boundary# #lemma-index# \
            #paradigm-index# #inflection# #auxiliary# <Stem><FB><VPART><e><ge>] \
           [#category# #origin#]:<>

$BASEFILTER$ = .* [#category#]:<><base>:<> .*

$BASE$ = $BaseStems$ || $BASEFILTER$