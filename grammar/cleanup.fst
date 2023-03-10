% cleanup.fst
% Version 3.0
% Andreas Nolda 2023-03-10

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# #part-of-speech# #feature#] \
           <>:[#orth-trigger#]

$CLEANUP1$ = .*

ALPHABET = [#char# #orth-trigger# #morpheme-boundary# #part-of-speech# #feature#] \
           <>:[#lemma-index# #paradigm-index#]

$CLEANUP2$ = .*
