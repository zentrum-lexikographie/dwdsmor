% wf.fst
% Version 6.2
% Andreas Nolda 2023-03-29

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# #boundary-trigger# #category# \
            #stem-type# #suff# #origin# #inflection# #auxiliary# <Abbr><ge>]

% context

$C$ = .
$C$ = $C$-[#entry-type# <CB><DB>]

$O$ = [#orth-trigger#]


% derivation restrictions

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOS-un$ =       <Prefix> un <DB>       <Stem> $C$* <ADJ> $C$*
$DerRestrPOS-Un$ = <^UC> <Prefix> un <DB> <^DC> <Stem> $C$* <NN>  $C$*

% restrict suff(er) to proper-name bases (?)
$DerRestrPOS-er$ = $O$* <Stem> $C$* <NPROP> $C$* <DB> <Suffix> er $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOS-chen$ = $O$* <Stem> $C$* <NN> $C$* <DB> <Suffix> chen $C$*
$DerRestrPOS-lein$ = $O$* <Stem> $C$* <NN> $C$* <DB> <Suffix> lein $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbr-un$ = !($O$* <Prefix> un <DB> $O$* <Stem> <Abbr> $C$*)

% exclude suff(er), suff(chen), and suff(lein) for abbreviated bases (?)
$DerRestrAbbr-er$   = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> er   $C$*)
$DerRestrAbbr-chen$ = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> chen $C$*)
$DerRestrAbbr-lein$ = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> lein $C$*)

$DerRestrPOS$ = $DerRestrPOS-un$   | \
                $DerRestrPOS-Un$   | \
                $DerRestrPOS-er$   | \
                $DerRestrPOS-chen$ | \
                $DerRestrPOS-lein$

$DerRestrAbbr$ = $DerRestrAbbr-un$   & \
                 $DerRestrAbbr-er$   & \
                 $DerRestrAbbr-chen$ & \
                 $DerRestrAbbr-lein$

$DerFilter$ = $DerRestrPOS$ & $DerRestrAbbr$


% compounding restrictions

% restrict compounding to nominal bases (?)
$CompRestrPOS$ = (($O$* <Prefix> $C$* <DB>)? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$* <HB>? <CB>)  \
                 (($O$* <Prefix> $C$* <DB>)? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$* <HB>? <CB>)* \
                 (($O$* <Prefix> $C$* <DB>)? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !((($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated bases without a preceding hyphen
$CompRestrAbbr2$ = !((($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)  \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated final bases (?)
$CompRestrAbbr3$ = !((($O$* <Prefix> $C$* <DB>)? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* <DB>)? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*))

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$

$CompFilter$ = $CompRestrPOS$ & $CompRestrAbbr$
