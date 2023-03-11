% wf.fst
% Version 4.0
% Andreas Nolda 2023-03-10

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #category# \
            #stemtype# #origin# #inflection# #auxiliary# \
            <Abbr><FB><VPART><ge><^hyph><^none>]

% context

$C$ = [^#entry-type#]

% compounding triggers

$T$ = [<^hyph><^none>]


% derivation restrictions

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOS-un$ = <Prefix> un <Stem> $C$* <ADJ> $C$*
$DerRestrPOS-Un$ = <Prefix> Un <Stem> $C$* <NN>  $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbr-un$ = !((<Prefix> un <Stem> <Abbr> $C$*) | \
                      (<Prefix> Un <Stem> <Abbr> $C$*))

$DerRestrPOS$ = $DerRestrPOS-un$ | $DerRestrPOS-Un$

$DerRestrAbbr$ = $DerRestrAbbr-un$

$DerFilter$ = $DerRestrPOS$ & $DerRestrAbbr$


% compounding restrictions

% restrict compounding to nominal bases (?)
$CompRestrPOS$ = ((<Prefix> $C$*)? <Stem> $C$* <NN> $C$* $T$)  \
                 ((<Prefix> $C$*)? <Stem> $C$* <NN> $C$* $T$)* \
                 ((<Prefix> $C$*)? <Stem> $C$* <NN> $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !(((<Prefix> $C$*)? <Stem>        $C$* $T$)*  \
                     ((<Prefix> $C$*)? <Stem> <Abbr> $C$* <^none>) \
                     ((<Prefix> $C$*)? <Stem>        $C$* $T$)*  \
                     ((<Prefix> $C$*)? <Stem>        $C$*))

% exclude compounding of abbreviated bases without a preceding hyphen
$CompRestrAbbr2$ = !(((<Prefix> $C$*)? <Stem>        $C$* $T$)*  \
                     ((<Prefix> $C$*)? <Stem>        $C$* <^none>) \
                     ((<Prefix> $C$*)? <Stem> <Abbr> $C$* $T$)   \
                     ((<Prefix> $C$*)? <Stem>        $C$* $T$)*  \
                     ((<Prefix> $C$*)? <Stem>        $C$*))

% exclude compounding of abbreviated final bases (?)
$CompRestrAbbr3$ = !(((<Prefix> $C$*)? <Stem>        $C$* $T$)*  \
                     ((<Prefix> $C$*)? <Stem> <Abbr> $C$*))

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$


% replace compounding triggers with appropriate morphological realisations

ALPHABET = [#entry-type# #char# #surface-trigger# #category# \
            #stemtype# #origin# #inflection# #auxiliary# \
            <Abbr><FB><VPART><ge>] \
           <^none>:<> \
           <^hyph>:\-

$CompTriggers$ = .*


$CompFilter$ = $CompRestrPOS$ & $CompRestrAbbr$ || $CompTriggers$
