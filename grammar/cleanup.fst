% cleanup.fst
% Version 1.0
% Andreas Nolda 2022-08-19

% based on code from SMORLemma by Rico Sennrich

#include "symbols.fst"

$CLEANUP1$ = [^<Lemma>]*

$CLEANUP2$ = ([#char#]* [#morpheme_boundary_marker#]:<>*)*
