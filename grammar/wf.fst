% wf.fst
% Version 11.0
% Andreas Nolda 2025-05-12

#include "symbols.fst"

% forms

% preverbs

$Prev-ab$       = <Prefix> ab
$Prev-an$       = <Prefix> an
$Prev-auf$      = <Prefix> auf
$Prev-aus$      = <Prefix> aus
$Prev-bei$      = <Prefix> bei
$Prev-durch$    = <Prefix> durch
$Prev-ein$      = <Prefix> ein
$Prev-fort$     = <Prefix> fort
$Prev-gegen$    = <Prefix> gegen
$Prev-heim$     = <Prefix> heim
$Prev-her$      = <Prefix> her
$Prev-hin$      = <Prefix> hin
$Prev-hinter$   = <Prefix> hinter
$Prev-los$      = <Prefix> los
$Prev-mit$      = <Prefix> mit
$Prev-nach$     = <Prefix> nach
$Prev-ueber$    = <Prefix> über
$Prev-um$       = <Prefix> um
$Prev-unter$    = <Prefix> unter
$Prev-vor$      = <Prefix> vor
$Prev-weg$      = <Prefix> weg
$Prev-wieder$   = <Prefix> wieder
$Prev-zu$       = <Prefix> zu
$Prev-zurueck$  = <Prefix> zurück
$Prev-zwischen$ = <Prefix> zwischen
% ...

$PrevRoot-ab$       = <Prefix> {}:{ab}
$PrevRoot-an$       = <Prefix> {}:{an}
$PrevRoot-auf$      = <Prefix> {}:{auf}
$PrevRoot-aus$      = <Prefix> {}:{aus}
$PrevRoot-bei$      = <Prefix> {}:{bei}
$PrevRoot-durch$    = <Prefix> {}:{durch}
$PrevRoot-ein$      = <Prefix> {}:{ein}
$PrevRoot-fort$     = <Prefix> {}:{fort}
$PrevRoot-gegen$    = <Prefix> {}:{gegen}
$PrevRoot-heim$     = <Prefix> {}:{heim}
$PrevRoot-her$      = <Prefix> {}:{her}
$PrevRoot-hin$      = <Prefix> {}:{hin}
$PrevRoot-hinter$   = <Prefix> {}:{hinter}
$PrevRoot-los$      = <Prefix> {}:{los}
$PrevRoot-mit$      = <Prefix> {}:{mit}
$PrevRoot-nach$     = <Prefix> {}:{nach}
$PrevRoot-ueber$    = <Prefix> {}:{über}
$PrevRoot-um$       = <Prefix> {}:{um}
$PrevRoot-unter$    = <Prefix> {}:{unter}
$PrevRoot-vor$      = <Prefix> {}:{vor}
$PrevRoot-weg$      = <Prefix> {}:{weg}
$PrevRoot-wieder$   = <Prefix> {}:{wieder}
$PrevRoot-zu$       = <Prefix> {}:{zu}
$PrevRoot-zurueck$  = <Prefix> {}:{zurück}
$PrevRoot-zwischen$ = <Prefix> {}:{zwischen}
% ...

% affixes

$Pref-un$ = <Prefix> un
% ...

$PrefRoot-un$ = <Prefix> {}:{un}
% ...

$Suff-e$    = <Suffix> e    <NN> <base> <native> <>:<NMasc_n_n_0>
$Suff-er$   = <Suffix> er   <NN> <base> <native> <>:<NMasc_s_0_n>
$Suff-chen$ = <Suffix> chen <NN> <base> <native> <>:<NNeut_s_0_0>
$Suff-lein$ = <Suffix> lein <NN> <base> <native> <>:<NNeut_s_0_0>
% ...

$SuffRoot-e$    = <Suffix> {}:{e}    <NN> <base> <native> <>:<NMasc_n_n_0>
$SuffRoot-er$   = <Suffix> {}:{er}   <NN> <base> <native> <>:<NMasc_s_0_n>
$SuffRoot-chen$ = <Suffix> {}:{chen} <NN> <base> <native> <>:<NNeut_s_0_0>
$SuffRoot-lein$ = <Suffix> {}:{lein} <NN> <base> <native> <>:<NNeut_s_0_0>
% ...

% processes and means

$ConvPartRoot$ = <CONV>:<> <ident|Part>:<>

$DerPrevRoot-ab$       = <DER>:<> <prev(ab)>:<>
$DerPrevRoot-an$       = <DER>:<> <prev(an)>:<>
$DerPrevRoot-auf$      = <DER>:<> <prev(auf)>:<>
$DerPrevRoot-aus$      = <DER>:<> <prev(aus)>:<>
$DerPrevRoot-bei$      = <DER>:<> <prev(bei)>:<>
$DerPrevRoot-durch$    = <DER>:<> <prev(durch)>:<>
$DerPrevRoot-ein$      = <DER>:<> <prev(ein)>:<>
$DerPrevRoot-fort$     = <DER>:<> <prev(fort)>:<>
$DerPrevRoot-gegen$    = <DER>:<> <prev(gegen)>:<>
$DerPrevRoot-heim$     = <DER>:<> <prev(heim)>:<>
$DerPrevRoot-her$      = <DER>:<> <prev(her)>:<>
$DerPrevRoot-hin$      = <DER>:<> <prev(hin)>:<>
$DerPrevRoot-hinter$   = <DER>:<> <prev(hinter)>:<>
$DerPrevRoot-los$      = <DER>:<> <prev(los)>:<>
$DerPrevRoot-mit$      = <DER>:<> <prev(mit)>:<>
$DerPrevRoot-nach$     = <DER>:<> <prev(nach)>:<>
$DerPrevRoot-ueber$    = <DER>:<> <prev(ueber)>:<>
$DerPrevRoot-um$       = <DER>:<> <prev(um)>:<>
$DerPrevRoot-unter$    = <DER>:<> <prev(unter)>:<>
$DerPrevRoot-vor$      = <DER>:<> <prev(vor)>:<>
$DerPrevRoot-weg$      = <DER>:<> <prev(weg)>:<>
$DerPrevRoot-wieder$   = <DER>:<> <prev(wieder)>:<>
$DerPrevRoot-zu$       = <DER>:<> <prev(zu)>:<>
$DerPrevRoot-zurueck$  = <DER>:<> <prev(zurueck)>:<>
$DerPrevRoot-zwischen$ = <DER>:<> <prev(zwischen)>:<>
% ...

$DerPrefRoot-un$ = <DER>:<> <pref(un)>:<>
% ...

$DerSuffRoot-e$    = <DER>:<> <suff(e)>:<>
$DerSuffRoot-er$   = <DER>:<> <suff(er)>:<>
$DerSuffRoot-chen$ = <DER>:<> <suff(chen)>:<>
$DerSuffRoot-lein$ = <DER>:<> <suff(lein)>:<>
% ...

$CompRoot-concat$ = <COMP>:<> <concat>:<>
$CompRoot-hyph$   = <COMP>:<> <hyph>:<>


% restrictions

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# #boundary-trigger# #category# \
            #stem-type# #suff# #origin# #inflection# #auxiliary# <Abbr><ge>]

$C$ = .
$C$ = $C$-[#entry-type# <CB><VB><HB><DB>]

% conversion restrictions

% exclude "worden" as a conversion basis
$ConvRestr-worden$ = !(<Stem>word<SB>en <ADJ> $C$*)

$ConvFilter$ = $ConvRestr-worden$

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
$DerRestrPOSSuff-e$ = [<dc><uc>]* <Stem> $C$* <NPROP> $C$* <DB> <Suffix> e $C$*

% restrict suff(er) to proper-name bases (?)
$DerRestrPOSSuff-er$ = [<dc><uc>]* <Stem> $C$* <NPROP> $C$* <DB> <Suffix> er $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOSSuff-chen$ = [<dc><uc>]* <Stem> $C$* <NN> $C$* <DB> <Suffix> chen $C$*
$DerRestrPOSSuff-lein$ = [<dc><uc>]* <Stem> $C$* <NN> $C$* <DB> <Suffix> lein $C$*

% exclude pref(un) for abbreviated bases
$DerRestrAbbrPref-un$ = !([<dc><uc>]* <Prefix> un <DB> [<dc><uc>]* <Stem> <Abbr> ($C$* <VB>)? $C$*)

% exclude suff(e), suff(er), suff(chen), and suff(lein) for abbreviated bases (?)
$DerRestrAbbrSuff-e$    = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suffix> e    $C$*)
$DerRestrAbbrSuff-er$   = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suffix> er   $C$*)
$DerRestrAbbrSuff-chen$ = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suffix> chen $C$*)
$DerRestrAbbrSuff-lein$ = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suffix> lein $C$*)

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

% provisionally restrict nominal compounds to nominal,
% adjectival, or verbal initial or intermediate bases
$CompRestrPOS$ =  ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP><ADJ><V>] $C$* <HB>? <CB>   \
                 (([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP><ADJ><V>] $C$* <HB>? <CB>)* \
                  ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>]         $C$*

% in nominal compounds, exclude downcased initial bases
$CompRestrOrth1$ = !(            <dc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude downcased intermediate bases with a preceding hyphen
$CompRestrOrth2$ = !(                 ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>  <CB> <dc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude downcased final bases with a preceding hyphen
$CompRestrOrth3$ = !(                 ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>  <CB> <dc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, require nominal intermediate bases without a preceding hyphen to be downcased
$CompRestrOrth4$ =                  ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                   (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$* | \
                    <HB>  <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$* | \
                          <CB> <dc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)* \
                    <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*

% in nominal compounds, require nominal final bases without a preceding hyphen to be downcased
$CompRestrOrth5$ =                  ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                   (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                   (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$* | \
                    <HB>  <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$* | \
                          <CB> <dc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude upcased unprefixed nominal initial bases
$CompRestrOrth6$ = !(            <uc>                                         [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude upcased unprefixed nominal intermediate bases
$CompRestrOrth7$ = !(                 ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>? <CB> <uc>                                         [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude upcased unprefixed nominal final bases
$CompRestrOrth8$ = !(                 ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                     (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                      <HB>? <CB> <uc>                                         [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% in nominal compounds, require adjectival or verbal initial bases to be upcased
$CompRestrOrth9$ = (           <uc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$* | \
                                    ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)  \
                   (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                    <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*

% in nominal compounds, require adjectival or verbal intermediate bases with a preceding hyphen to be upcased
$CompRestrOrth10$ =                  ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                    (<HB>  <CB> <uc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$* | \
                           <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$* | \
                     <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)* \
                     <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*

% in nominal compounds, exclude upcased adjectival or verbal intermediate bases without a preceding hyphen
$CompRestrOrth11$ = !(                 ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*   \
                      (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                             <CB> <uc> ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<ADJ><V>]    $C$*   \
                      (<HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)*               $C$*)* \
                       <HB>? <CB>      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> $C$* (<DB> <Suffix> $C$*)* [<NN><NPROP>] $C$*)

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !((([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*       <CB>   \
                     (([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)*)

% exclude compounding of abbreviated non-final bases without a preceding hyphen
$CompRestrAbbr2$ = !((([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>   \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>   \
                     (([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)*)

% exclude compounding of abbreviated final bases without a preceding hyphen
$CompRestrAbbr3$ = !((([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)* <HB>? <CB>)* \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem>        $C$* (<DB> <Suffix> $C$*)*       <CB>   \
                      ([<dc><uc>]* <Prefix> $C$* [<DB><VB>])? [<dc><uc>]* <Stem> <Abbr> $C$* (<DB> <Suffix> $C$*)*)

$CompRestrOrth$ = $CompRestrOrth1$ & $CompRestrOrth2$  & $CompRestrOrth3$ & $CompRestrOrth4$ & \
                  $CompRestrOrth5$ & $CompRestrOrth6$  & $CompRestrOrth7$ & $CompRestrOrth8$ & \
                  $CompRestrOrth9$ & $CompRestrOrth10$ & $CompRestrOrth11$

$CompRestrAbbr$ = $CompRestrAbbr1$ & $CompRestrAbbr2$ & $CompRestrAbbr3$

$CompFilter$ = $CompRestrPOS$ & $CompRestrOrth$ & $CompRestrAbbr$
