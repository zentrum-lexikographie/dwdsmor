% wf.fst
% Version 2.0
% Andreas Nolda 2022-12-05

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #category# #origin# #inflection# #auxiliary# <Stem><FB><VPART><e><ge>]

$BaseStems$ = $LEX$ || <Stem> .* <base> .*
$CompStems$ = $LEX$ || <Stem> .* <comp> .*

$C1$ = [a-zäöü]:[A-ZÄÖÜ] [#char#]*
$C2$ = [A-ZÄÖÜ]:[a-zäöü] [#char#]*

$BaseStemsDC$ = $C1$ .* || $BaseStems$ || <Stem> $C2$ .* <base> .*
$CompStemsDC$ = $C1$ .* || $CompStems$ || <Stem> $C2$ .* <comp> .*

ALPHABET = [#deko-trigger# #char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #inflection# #auxiliary# <Stem><FB><VPART><e><ge>] \
           [#category# #origin#]:<>

$BASEFILTER$ = .* [#category#]:<><base>:<> .*

$BASE$ = $BaseStems$ || $BASEFILTER$

$HYPH$   = <\=>:<FB> \- <#>:<>
$NOHYPH$ =              <#>:<>

$COMPFILTER$ = (.* <NN>:<><comp>:<> .*)  \
               (.* <NN>:<><comp>:<> .*)* \
               (.* <NN>:<><base>:<> .*)

$COMP$ = $CompStems$ \
         ($HYPH$ $CompStems$ | $NOHYPH$ $CompStemsDC$)* \
         ($HYPH$ $BaseStems$ | $NOHYPH$ $BaseStemsDC$) || $COMPFILTER$

$WF$ = $COMP$
