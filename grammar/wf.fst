% wf.fst
% Version 9.0
% Andreas Nolda 2025-04-10

#include "symbols.fst"

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# #boundary-trigger# #category# \
            #stem-type# #suff# #origin# #inflection# #auxiliary# <Abbr><ge>]

% context

$C$ = .
$C$ = $C$-[#entry-type# <CB><VB><HB><DB>]

$O$ = [#orth-trigger#]


% derivation restrictions

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOSPref-un$ =      <Prefix> un <DB>      <Stem> ($C$* <VB>)? $C$* <ADJ> $C$*
$DerRestrPOSPref-Un$ = <uc> <Prefix> un <DB> <dc> <Stem> ($C$* <VB>)? $C$* <NN>  $C$*

% restrict prev() to verbal bases
$DerRestrPOSPrev-mit$ = <Prefix> mit <VB> <Stem> ($C$* <VB>)? $C$* <V> $C$*

% restrict prev() to verbal bases without preverb
$DerRestrPOSPrev-ab$       = <Prefix> ab       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-an$       = <Prefix> an       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-auf$      = <Prefix> auf      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-aus$      = <Prefix> aus      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-bei$      = <Prefix> bei      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-durch$    = <Prefix> durch    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-ein$      = <Prefix> ein      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-fort$     = <Prefix> fort     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-gegen$    = <Prefix> gegen    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-heim$     = <Prefix> heim     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-her$      = <Prefix> her      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-hin$      = <Prefix> hin      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-hinter$   = <Prefix> hinter   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-los$      = <Prefix> los      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-nach$     = <Prefix> nach     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-ueber$    = <Prefix> über     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-um$       = <Prefix> um       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-unter$    = <Prefix> unter    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-vor$      = <Prefix> vor      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-weg$      = <Prefix> weg      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-wieder$   = <Prefix> wieder   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zu$       = <Prefix> zu       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zurueck$  = <Prefix> zurück   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zwischen$ = <Prefix> zwischen <VB> <Stem> $C$* <V> $C$*

% restrict suff(e) to proper-name bases (?)
$DerRestrPOSSuff-e$ = $O$* <Stem> $C$* <NPROP> $C$* <DB> <Suffix> e $C$*

% restrict suff(er) to proper-name bases (?)
$DerRestrPOSSuff-er$ = $O$* <Stem> $C$* <NPROP> $C$* <DB> <Suffix> er $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOSSuff-chen$ = $O$* <Stem> $C$* <NN> $C$* <DB> <Suffix> chen $C$*
$DerRestrPOSSuff-lein$ = $O$* <Stem> $C$* <NN> $C$* <DB> <Suffix> lein $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbrPref-un$ = !($O$* <Prefix> un <DB> $O$* <Stem> <Abbr> ($C$* <VB>)? $C$*)

% exclude suff(e), suff(er), suff(chen), and suff(lein) for abbreviated bases (?)
$DerRestrAbbrSuff-e$    = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> e    $C$*)
$DerRestrAbbrSuff-er$   = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> er   $C$*)
$DerRestrAbbrSuff-chen$ = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> chen $C$*)
$DerRestrAbbrSuff-lein$ = !($O$* <Stem> <Abbr> $C$* <DB> <Suffix> lein $C$*)

$DerRestrPOS$ = $DerRestrPOSPref-un$       | \
                $DerRestrPOSPref-Un$       | \
                $DerRestrPOSPrev-ab$       | \
                $DerRestrPOSPrev-an$       | \
                $DerRestrPOSPrev-auf$      | \
                $DerRestrPOSPrev-aus$      | \
                $DerRestrPOSPrev-bei$      | \
                $DerRestrPOSPrev-durch$    | \
                $DerRestrPOSPrev-ein$      | \
                $DerRestrPOSPrev-fort$     | \
                $DerRestrPOSPrev-gegen$    | \
                $DerRestrPOSPrev-heim$     | \
                $DerRestrPOSPrev-her$      | \
                $DerRestrPOSPrev-hin$      | \
                $DerRestrPOSPrev-hinter$   | \
                $DerRestrPOSPrev-los$      | \
                $DerRestrPOSPrev-mit$      | \
                $DerRestrPOSPrev-nach$     | \
                $DerRestrPOSPrev-ueber$    | \
                $DerRestrPOSPrev-um$       | \
                $DerRestrPOSPrev-unter$    | \
                $DerRestrPOSPrev-vor$      | \
                $DerRestrPOSPrev-weg$      | \
                $DerRestrPOSPrev-wieder$   | \
                $DerRestrPOSPrev-zu$       | \
                $DerRestrPOSPrev-zurueck$  | \
                $DerRestrPOSPrev-zwischen$ | \
                $DerRestrPOSSuff-e$        | \
                $DerRestrPOSSuff-er$       | \
                $DerRestrPOSSuff-chen$     | \
                $DerRestrPOSSuff-lein$

$DerRestrAbbr$ = $DerRestrAbbrPref-un$   & \
                 $DerRestrAbbrSuff-e$    & \
                 $DerRestrAbbrSuff-er$   & \
                 $DerRestrAbbrSuff-chen$ & \
                 $DerRestrAbbrSuff-lein$

$DerFilter$ = $DerRestrPOS$ & $DerRestrAbbr$


% compounding restrictions

% provisionally restrict compounding to nominal final bases and
% nominal, adjectival, or verbal initial or intermediate bases
$CompRestrPOS$ = (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP><ADJ><V>] $C$* <HB>? <CB>)  \
                 (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP><ADJ><V>] $C$* <HB>? <CB>)* \
                 (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>]         $C$*)

% exclude downcased nominal initial bases
$CompRestrOrth1$ = !((           <dc> ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)  \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*))

% exclude downcased nominal intermediate bases with a preceding hyphen
$CompRestrOrth2$ = !((                ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)  \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                     (<HB>  <CB> <dc> ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)  \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*))

% exclude upcased unprefixed nominal initial bases
$CompRestrOrth3$ = !((           <uc>                                  $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)  \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*))

% exclude upcased unprefixed nominal intermediate bases
$CompRestrOrth4$ = !((                ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)  \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                     (<HB>? <CB> <uc>                                  $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)  \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                     (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*))

% require adjectival or verbal initial bases to be upcased
$CompRestrOrth5$ = ((          <uc> ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$*) | \
                    (               ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*))  \
                   (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)*  \
                   (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)

% require adjectival or verbal intermediate bases with a preceding hyphen to be upcased
$CompRestrOrth6$ = (                 ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)   \
                   ((<HB>  <CB> <uc> ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$*) | \
                    (      <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$*) | \
                    (<HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*))* \
                   ( <HB>? <CB>      ($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !((($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated non-final bases without a preceding hyphen
$CompRestrAbbr2$ = !((($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>)  \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)  \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*))

% exclude compounding of abbreviated final bases without a preceding hyphen
$CompRestrAbbr3$ = !((($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>) \
                     (($O$* <Prefix> $C$* [<DB><VB>])? $O$* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*))

$CompRestrOrth$ = $CompRestrOrth1$ & $CompRestrOrth2$ & $CompRestrOrth3$ & \
                  $CompRestrOrth4$ & $CompRestrOrth5$ & $CompRestrOrth6$

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$

$CompFilter$ = $CompRestrPOS$ & $CompRestrOrth$ & $CompRestrAbbr$
