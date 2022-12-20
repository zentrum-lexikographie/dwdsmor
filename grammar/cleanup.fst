% cleanup.fst
% Version 2.2
% Andreas Nolda 2022-12-20

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"

$CLEANUP1$ = [^<Lemma>]*

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# #part-of-speech# #feature#] \
           <>:[#orth-trigger#]

$CLEANUP2$ = .*

ALPHABET = [#char# #orth-trigger# #morpheme-boundary# #part-of-speech# #feature#] \
           <>:[#lemma-index# #paradigm-index#]

$CLEANUP3$ = .*
