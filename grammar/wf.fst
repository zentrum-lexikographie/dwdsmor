% wf.fst
% Version 2.2
% Andreas Nolda 2022-12-12

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #category# #origin# #inflection# #auxiliary# <Stem><FB><VPART><e><ge>]

$BaseStems$ = $LEX$ || <Stem> .* <base> .*
$CompStems$ = $LEX$ || <Stem> .* <comp> .*

$C1$ = [a-zäöü]:[A-ZÄÖÜ] [#char#]*
$C2$ = [A-ZÄÖÜ]:[a-zäöü] [#char#]*

$BaseStemsDC$ = $C1$ .* || $BaseStems$ || <Stem> [#deko-trigger#]* $C2$ .* <base> .*
$CompStemsDC$ = $C1$ .* || $CompStems$ || <Stem> [#deko-trigger#]* $C2$ .* <comp> .*

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #inflection# #auxiliary# <FB><VPART><e><ge>] \
           [#deko-trigger# #stemtype# #category# #origin#]:<>

$BASEFILTER$ = <Stem> .*

$BASE$ = $BaseStems$ || $BASEFILTER$

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

$HB$ = <\=>:<FB>
$CB$ =  <#>:<>

$HYPH$   = $HB$ \-:<Hyph>   $CB$
$NOHYPH$ =      <>:<NoHyph> $CB$

$COMP$ = $CompStems$ \
         ($HYPH$ $CompStems$ | $NOHYPH$ $CompStemsDC$)* \
         ($HYPH$ $BaseStems$ | $NOHYPH$ $BaseStemsDC$) || $COMPFILTER$

$WF$ = $COMP$
