% wf.fst
% Version 3.2
% Andreas Nolda 2022-12-21

#include "symbols.fst"

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #inflection# #auxiliary# <FB><VPART><e><ge>] \
           [#deko-trigger# #stemtype# #category# #origin#]:<>

$BASEFILTER$ = <Stem> .*

$MARK$ = [<Hyph><NoMark>]:[\-<>]

$CompRestrPOS$ = (<Stem> .* <NN>:<> .* $MARK$)  \
                 (<Stem> .* <NN>:<> .* $MARK$)* \
                 (<Stem> .* <NN>:<> .*)

$CompRestrAbbr$ = !(((<Stem>           .* $MARK$)*     \
                     (<Stem> <Abbr>:<> .* <NoMark>:<>) \ % no abbreviated non-final stem
                     (<Stem>           .* $MARK$)*     \ % without a following hyphen
                     (<Stem>           .*)) |          \
                    ((<Stem>           .* $MARK$)*     \
                     (<Stem>           .* <NoMark>:<>) \ % no abbreviated non-final stem
                     (<Stem> <Abbr>:<> .* $MARK$)      \ % after a stem without a following hyphen
                     (<Stem>           .* $MARK$)*     \
                     (<Stem>           .*)) |          \
                    ((<Stem>           .* $MARK$)*     \
                     (<Stem> <Abbr>:<> .*)))             % no abbreviated final stem

$COMPFILTER$ = $CompRestrPOS$ & $CompRestrAbbr$
