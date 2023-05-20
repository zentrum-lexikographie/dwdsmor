% wf.fst
% Version 7.0
% Andreas Nolda 2023-05-20

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# #boundary-trigger# #category# \
            #stem-type# #suff# #origin# #inflection# #auxiliary# <Abbr><ge>]

% context

$C$ = .
$C$ = $C$-[#entry-type# <CB><DB>]

$O$ = [#orth-trigger#]


% derivation restrictions

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOSPref-un$ =       <Prefix> un <DB>       <Stem> $C$* <ADJ> $C$*
$DerRestrPOSPref-Un$ = <^UC> <Prefix> un <DB> <^DC> <Stem> $C$* <NN>  $C$*

% restrict part(...) to verbal bases without particle
$DerRestrPOSPart-ab$       = <Prefix> ab       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-an$       = <Prefix> an       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-auf$      = <Prefix> auf      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-aus$      = <Prefix> aus      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-bei$      = <Prefix> bei      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-durch$    = <Prefix> durch    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-ein$      = <Prefix> ein      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-gegen$    = <Prefix> gegen    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-hinter$   = <Prefix> hinter   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-los$      = <Prefix> los      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-mit$      = <Prefix> mit      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-nach$     = <Prefix> nach     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-ueber$    = <Prefix> über     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-um$       = <Prefix> um       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-unter$    = <Prefix> unter    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-vor$      = <Prefix> vor      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-weg$      = <Prefix> weg      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-zu$       = <Prefix> zu       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-zurueck$  = <Prefix> zurück   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPart-zwischen$ = <Prefix> zwischen <VB> <Stem> $C$* <V> $C$*

% restrict suff(er) to proper-name bases (?)
$DerRestrPOSSuff-er$ = $O$* <Stem> $C$* <NPROP> $C$* <DB> <Suffix> er $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOSSuff-chen$ = $O$* <Stem> $C$* <NN> $C$* <DB> <Suffix> chen $C$*
$DerRestrPOSSuff-lein$ = $O$* <Stem> $C$* <NN> $C$* <DB> <Suffix> lein $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbrPref-un$ = !($O$* <Prefix> un <DB> $O$* <Stem> <Abbr> $C$*)

% exclude suff(er), suff(chen), and suff(lein) for abbreviated bases (?)
$DerRestrAbbrSuff-er$   = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> er   $C$*)
$DerRestrAbbrSuff-chen$ = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> chen $C$*)
$DerRestrAbbrSuff-lein$ = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> lein $C$*)

$DerRestrPOS$ = $DerRestrPOSPref-un$       | \
                $DerRestrPOSPref-Un$       | \
                $DerRestrPOSPart-ab$       | \
                $DerRestrPOSPart-an$       | \
                $DerRestrPOSPart-auf$      | \
                $DerRestrPOSPart-aus$      | \
                $DerRestrPOSPart-bei$      | \
                $DerRestrPOSPart-durch$    | \
                $DerRestrPOSPart-ein$      | \
                $DerRestrPOSPart-gegen$    | \
                $DerRestrPOSPart-hinter$   | \
                $DerRestrPOSPart-los$      | \
                $DerRestrPOSPart-mit$      | \
                $DerRestrPOSPart-nach$     | \
                $DerRestrPOSPart-ueber$    | \
                $DerRestrPOSPart-um$       | \
                $DerRestrPOSPart-unter$    | \
                $DerRestrPOSPart-vor$      | \
                $DerRestrPOSPart-weg$      | \
                $DerRestrPOSPart-zu$       | \
                $DerRestrPOSPart-zurueck$  | \
                $DerRestrPOSPart-zwischen$ | \
                $DerRestrPOSSuff-er$       | \
                $DerRestrPOSSuff-chen$     | \
                $DerRestrPOSSuff-lein$

$DerRestrAbbr$ = $DerRestrAbbrPref-un$   & \
                 $DerRestrAbbrSuff-er$   & \
                 $DerRestrAbbrSuff-chen$ & \
                 $DerRestrAbbrSuff-lein$

$DerFilter$ = $DerRestrPOS$ & $DerRestrAbbr$


% compounding restrictions

% restrict compounding to nominal bases (?)
$CompRestrPOS$ = (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$* <HB>? <CB>)  \
                 (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$* <HB>? <CB>)* \
                 (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* <NN> $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !((($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated bases without a preceding hyphen
$CompRestrAbbr2$ = !((($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)  \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated final bases (?)
$CompRestrAbbr3$ = !((($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*))

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$

$CompFilter$ = $CompRestrPOS$ & $CompRestrAbbr$
