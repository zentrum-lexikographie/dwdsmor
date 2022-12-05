% cleanup.fst
% Version 2.0
% Andreas Nolda 2022-12-05

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"

$CLEANUP1$ = [^<Lemma>]*

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# #part-of-speech# #feature#]

$CLEANUP2$ = (. | <>:[#orth-trigger#])*

ALPHABET = [#char# #morpheme-boundary# #part-of-speech# #feature#]

$CLEANUP3$ = (. | <>:[#lemma-index# #paradigm-index#])*
