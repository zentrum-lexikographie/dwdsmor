% no-wf.fst
% Version 1.0
% Andreas Nolda 2022-11-17

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

% compounding filter

ALPHABET = [#entry-type# #char# #morpheme-boundary# #inflection# #auxiliary# \
            <FB><VPART><e><ge>]

$BASEFILTER$ = (.* <base>:<> .*)
