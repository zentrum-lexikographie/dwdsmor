% wf.fst
% Version 4.1
% Andreas Nolda 2023-03-20

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #category# #stem-type# \
            #stem-subtype# #origin# #inflection# #auxiliary# \
            <Abbr><FB><VPART><ge><^hyph><^none>]

% context

$C$ = [^#entry-type#]

% compounding triggers

$T$ = [<^hyph><^none>]


% derivation restrictions

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOS-un$ = <Prefix> un <Stem> $C$* <ADJ> $C$*
$DerRestrPOS-Un$ = <Prefix> Un <Stem> $C$* <NN>  $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOS-chen$ = (<Stem> $C$* <NN> $C$*)+ <Suffix> chen $C$*
$DerRestrPOS-lein$ = (<Stem> $C$* <NN> $C$*)+ <Suffix> lein $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbr-un$ = !((<Prefix> un <Stem> <Abbr> $C$*) | \
                      (<Prefix> Un <Stem> <Abbr> $C$*))

% exclude suff(chen) and suff(lein) for abbreviated bases (?)
$DerRestrAbbr-chen$ = !((<Stem> $C$*)* <Stem> <Abbr> $C$* <Suffix> chen $C$*)
$DerRestrAbbr-lein$ = !((<Stem> $C$*)* <Stem> <Abbr> $C$* <Suffix> lein $C$*)

$DerRestrPOS$ = $DerRestrPOS-un$   | \
                $DerRestrPOS-Un$   | \
                $DerRestrPOS-chen$ | \
                $DerRestrPOS-lein$

$DerRestrAbbr$ = $DerRestrAbbr-un$   & \
                 $DerRestrAbbr-chen$ & \
                 $DerRestrAbbr-lein$

$DerFilter$ = $DerRestrPOS$ & $DerRestrAbbr$


% compounding restrictions

% restrict compounding to nominal bases (?)
$CompRestrPOS$ = ((<Prefix> $C$*)? <Stem> $C$* (<Suffix> $C$*)* <NN> $C$* $T$)  \
                 ((<Prefix> $C$*)? <Stem> $C$* (<Suffix> $C$*)* <NN> $C$* $T$)* \
                 ((<Prefix> $C$*)? <Stem> $C$* (<Suffix> $C$*)* <NN> $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !(((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)* $T$)*  \
                     ((<Prefix> $C$*)? <Stem> <Abbr> $C$* (<Suffix> $C$*)* <^none>) \
                     ((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)* $T$)*  \
                     ((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)*))

% exclude compounding of abbreviated bases without a preceding hyphen
$CompRestrAbbr2$ = !(((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)* $T$)*  \
                     ((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)* <^none>) \
                     ((<Prefix> $C$*)? <Stem> <Abbr> $C$* (<Suffix> $C$*)* $T$)   \
                     ((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)* $T$)*  \
                     ((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)*))

% exclude compounding of abbreviated final bases (?)
$CompRestrAbbr3$ = !(((<Prefix> $C$*)? <Stem>        $C$* (<Suffix> $C$*)* $T$)*  \
                     ((<Prefix> $C$*)? <Stem> <Abbr> $C$* (<Suffix> $C$*)*))

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$


% replace compounding triggers with appropriate morphological realisations

ALPHABET = [#entry-type# #char# #surface-trigger# #category# #stem-type# \
            #stem-subtype# #origin# #inflection# #auxiliary# \
            <Abbr><FB><VPART><ge>] \
           <^none>:<> \
           <^hyph>:\-

$CompTriggers$ = .*


$CompFilter$ = $CompRestrPOS$ & $CompRestrAbbr$ || $CompTriggers$
