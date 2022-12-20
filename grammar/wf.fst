% wf.fst
% Version 3.1
% Andreas Nolda 2022-12-20

#include "symbols.fst"

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #inflection# #auxiliary# <FB><VPART><e><ge>] \
           [#deko-trigger# #stemtype# #category# #origin#]:<>

$BASEFILTER$ = <Stem> .*

$H$ = [<Hyph><NoHyph>]:[\-<>]

$CompRestrPOS$ = (<Stem> .* <NN>:<> .* $H$) \
                 (<Stem> .* <NN>:<> .* $H$)* \
                 (<Stem> .* <NN>:<> .*)

$CompRestrAbbr$ = !(((<Stem> .* $H$)* \
                     (<Stem> <Abbr>:<> .* <NoHyph>:<>) \ % no abbreviated non-final stem
                     (<Stem> .* $H$)* \                  % without a following hyphen
                     (<Stem> .*)) | \
                    ((<Stem> .* $H$)* \
                     (<Stem> .* <NoHyph>:<>) \   % no abbreviated non-final stem
                     (<Stem> <Abbr>:<> .* $H$) \ % after a stem without a following hyphen
                     (<Stem> .* $H$)* \
                     (<Stem> .*)) | \
                    ((<Stem> .* $H$)* \
                     (<Stem> <Abbr>:<> .*))) % no abbreviated final stem

$COMPFILTER$ = $CompRestrPOS$ & $CompRestrAbbr$
