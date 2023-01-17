% wf.fst
% Version 3.3
% Andreas Nolda 2023-01-17

#include "symbols.fst"

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #category# #stemtype# #origin# #inflection# #auxiliary# <FB><VPART><e><ge>]

$DerRestrPOS-un$ = <Prefix> un <Stem> .* <ADJ> .*
$DerRestrPOS-Un$ = <Prefix> Un <Stem> .* <NN>  .*

$DerRestrPOS$ = $DerRestrPOS-un$ | $DerRestrPOS-Un$

$DERFILTER$ = $DerRestrPOS$

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #inflection# #auxiliary# <FB><VPART><e><ge>] \
           [#deko-trigger# #category# #stemtype# #origin#]:<>

$BASEFILTER$ = (<Prefix> .*)? <Stem> .*

$MARK$ = [<Hyph><NoMark>]:[\-<>]

$CompRestrPOS$ = ((<Prefix> .*)? <Stem> .* <NN>:<> .* $MARK$)  \
                 ((<Prefix> .*)? <Stem> .* <NN>:<> .* $MARK$)* \
                 ((<Prefix> .*)? <Stem> .* <NN>:<> .*)

$CompRestrAbbr$ = !((((<Prefix> .*)? <Stem>           .* $MARK$)*     \
                     ((<Prefix> .*)? <Stem> <Abbr>:<> .* <NoMark>:<>) \ % no abbreviated non-final stem
                     ((<Prefix> .*)? <Stem>           .* $MARK$)*     \ % without a following hyphen
                     ((<Prefix> .*)? <Stem>           .*)) |          \
                    (((<Prefix> .*)? <Stem>           .* $MARK$)*     \
                     ((<Prefix> .*)? <Stem>           .* <NoMark>:<>) \ % no abbreviated non-final stem
                     ((<Prefix> .*)? <Stem> <Abbr>:<> .* $MARK$)      \ % after a stem without a following hyphen
                     ((<Prefix> .*)? <Stem>           .* $MARK$)*     \
                     ((<Prefix> .*)? <Stem>           .*)) |          \
                    (((<Prefix> .*)? <Stem>           .* $MARK$)*     \
                     ((<Prefix> .*)? <Stem> <Abbr>:<> .*)))             % no abbreviated final stem

$COMPFILTER$ = $CompRestrPOS$ & $CompRestrAbbr$
