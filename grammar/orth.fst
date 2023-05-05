% orth.fst
% Version 2.0
% Andreas Nolda 2023-05-05

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"


% move old-orthography markers to the end

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #wf-process# #wf-means# #feature# #metainfo#]

$OrthOldAnalysis$ = .* | \
                    .* <>:<OLDORTH> .* <OLDORTH>:<>


% generate capitalised variants

$OrthCap$ = [#lowercase#]:[#uppercase#] [#char#]*
