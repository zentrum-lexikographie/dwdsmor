% cleanup.fst
% Version 2.1
% Andreas Nolda 2022-12-06

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"

$CLEANUP1$ = [^<Lemma>]*

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# #part-of-speech# #feature#]

$CLEANUP2$ = (. | <>:[#orth-trigger#])*

ALPHABET = [#char# #orth-trigger# #morpheme-boundary# #part-of-speech# #feature#] \

$CLEANUP3$ = (. | <>:[#lemma-index# #paradigm-index#])*
