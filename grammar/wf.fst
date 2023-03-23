% wf.fst
% Version 5.0
% Andreas Nolda 2023-03-23

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #boundary-trigger# #surface-trigger# #category# \
            #stem-type# #stem-subtype# #origin# #inflection# #auxiliary# <Abbr><ge>]

% context

$C$ = .
$C$ = $C$-[#entry-type# <CB><DB>]


% derivation restrictions

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOS-un$ = <Prefix> un <DB> <Stem> $C$* <ADJ> $C$*
$DerRestrPOS-Un$ = <Prefix> Un <DB> <Stem> $C$* <NN>  $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOS-chen$ = <Stem> $C$* <NN> $C$* <DB> <Suffix> chen $C$*
$DerRestrPOS-lein$ = <Stem> $C$* <NN> $C$* <DB> <Suffix> lein $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbr-un$ = !((<Prefix> un <DB> <Stem> <Abbr> $C$*) | \
                      (<Prefix> Un <DB> <Stem> <Abbr> $C$*))

% exclude suff(chen) and suff(lein) for abbreviated bases (?)
$DerRestrAbbr-chen$ = !(<Stem> <Abbr> $C$* <DB> <Suffix> chen $C$*)
$DerRestrAbbr-lein$ = !(<Stem> <Abbr> $C$* <DB> <Suffix> lein $C$*)

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
$CompRestrPOS$ = ((<Prefix> $C$* <DB>)? <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$* <HB>? <CB>)  \
                 ((<Prefix> $C$* <DB>)? <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$* <HB>? <CB>)* \
                 ((<Prefix> $C$* <DB>)? <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !(((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     ((<Prefix> $C$* <DB>)? <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     ((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     ((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated bases without a preceding hyphen
$CompRestrAbbr2$ = !(((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     ((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     ((<Prefix> $C$* <DB>)? <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)  \
                     ((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     ((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated final bases (?)
$CompRestrAbbr3$ = !(((<Prefix> $C$* <DB>)? <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     ((<Prefix> $C$* <DB>)? <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*))

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$

$CompFilter$ = $CompRestrPOS$ & $CompRestrAbbr$
