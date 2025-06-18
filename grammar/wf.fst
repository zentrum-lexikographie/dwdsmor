% wf.fst
% Version 12.0
% Andreas Nolda 2025-06-18

#include "symbols.fst"

% processes and means

$ConvPartPres$   = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPosAttr> % cf. Duden-Grammatik (2016: § 481, § 508, § 829)
$ConvPartPerf_t$ = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPos>     % cf. Duden-Grammatik (2016: § 508)
$ConvPartPerf_n$ = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPos-en>  % cf. Duden-Grammatik (2016: § 508)
$ConvPartPerf_d$ = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPosPred>
% ...

$DerSuff-e$    = <DER>:<> <suff(e)>:<>    <Suff> e    <NN> <base> <native> <>:<NMasc_n_n_0>
$DerSuff-er$   = <DER>:<> <suff(er)>:<>   <Suff> er   <NN> <base> <native> <>:<NMasc_s_0_n>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<> <Suff> chen <NN> <base> <native> <>:<NNeut_s_0_0>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<> <Suff> lein <NN> <base> <native> <>:<NNeut_s_0_0>
% ...

$DerPref-un$ = <DER>:<> <pref(un)>:<> <Pref> un
% ...

$DerPrev-ab$       = <DER>:<> <prev(ab)>:<>       <Pref> ab
$DerPrev-an$       = <DER>:<> <prev(an)>:<>       <Pref> an
$DerPrev-auf$      = <DER>:<> <prev(auf)>:<>      <Pref> auf
$DerPrev-aus$      = <DER>:<> <prev(aus)>:<>      <Pref> aus
$DerPrev-bei$      = <DER>:<> <prev(bei)>:<>      <Pref> bei
$DerPrev-durch$    = <DER>:<> <prev(durch)>:<>    <Pref> durch
$DerPrev-ein$      = <DER>:<> <prev(ein)>:<>      <Pref> ein
$DerPrev-fort$     = <DER>:<> <prev(fort)>:<>     <Pref> fort
$DerPrev-gegen$    = <DER>:<> <prev(gegen)>:<>    <Pref> gegen
$DerPrev-heim$     = <DER>:<> <prev(heim)>:<>     <Pref> heim
$DerPrev-her$      = <DER>:<> <prev(her)>:<>      <Pref> her
$DerPrev-hin$      = <DER>:<> <prev(hin)>:<>      <Pref> hin
$DerPrev-hinter$   = <DER>:<> <prev(hinter)>:<>   <Pref> hinter
$DerPrev-los$      = <DER>:<> <prev(los)>:<>      <Pref> los
$DerPrev-mit$      = <DER>:<> <prev(mit)>:<>      <Pref> mit
$DerPrev-nach$     = <DER>:<> <prev(nach)>:<>     <Pref> nach
$DerPrev-ueber$    = <DER>:<> <prev(ueber)>:<>    <Pref> über
$DerPrev-um$       = <DER>:<> <prev(um)>:<>       <Pref> um
$DerPrev-unter$    = <DER>:<> <prev(unter)>:<>    <Pref> unter
$DerPrev-vor$      = <DER>:<> <prev(vor)>:<>      <Pref> vor
$DerPrev-weg$      = <DER>:<> <prev(weg)>:<>      <Pref> weg
$DerPrev-wieder$   = <DER>:<> <prev(wieder)>:<>   <Pref> wieder
$DerPrev-zu$       = <DER>:<> <prev(zu)>:<>       <Pref> zu
$DerPrev-zurueck$  = <DER>:<> <prev(zurueck)>:<>  <Pref> zurück
$DerPrev-zwischen$ = <DER>:<> <prev(zwischen)>:<> <Pref> zwischen
% ...

$DerPrev$ = $DerPrev-ab$      | \
            $DerPrev-an$      | \
            $DerPrev-auf$     | \
            $DerPrev-aus$     | \
            $DerPrev-bei$     | \
            $DerPrev-durch$   | \
            $DerPrev-ein$     | \
            $DerPrev-fort$    | \
            $DerPrev-gegen$   | \
            $DerPrev-heim$    | \
            $DerPrev-her$     | \
            $DerPrev-hin$     | \
            $DerPrev-hinter$  | \
            $DerPrev-los$     | \
            $DerPrev-mit$     | \
            $DerPrev-nach$    | \
            $DerPrev-ueber$   | \
            $DerPrev-um$      | \
            $DerPrev-unter$   | \
            $DerPrev-vor$     | \
            $DerPrev-weg$     | \
            $DerPrev-wieder$  | \
            $DerPrev-zu$      | \
            $DerPrev-zurueck$ | \
            $DerPrev-zwischen$
            % ...

$Comp-concat$ = <COMP>:<> <concat>:<>
$Comp-hyph$   = <COMP>:<> <hyph>:<>


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

% restrict suff(e) to proper-name bases (?)
$DerRestrPOSSuff-e$ = [<dc><uc>]* <Stem> $C$* <NPROP> $C$* <DB> <Suff> e $C$*

% restrict suff(er) to proper-name bases (?)
$DerRestrPOSSuff-er$ = [<dc><uc>]* <Stem> $C$* <NPROP> $C$* <DB> <Suff> er $C$*

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOSSuff-chen$ = [<dc><uc>]* <Stem> $C$* <NN> $C$* <DB> <Suff> chen $C$*
$DerRestrPOSSuff-lein$ = [<dc><uc>]* <Stem> $C$* <NN> $C$* <DB> <Suff> lein $C$*

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOSPref-un$ =      <Pref> un <DB>      <Stem> ($C$* <VB>)? $C$* <ADJ> $C$*
$DerRestrPOSPref-Un$ = <uc> <Pref> un <DB> <dc> <Stem> ($C$* <VB>)? $C$* <NN>  $C$*

% restrict prev() to verbal bases
$DerRestrPOSPrev-mit$ = <Pref> mit <VB> <Stem> ($C$* <VB>)? $C$* <V> $C$*

% restrict prev() to verbal bases without preverb
$DerRestrPOSPrev-ab$       = <Pref> ab       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-an$       = <Pref> an       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-auf$      = <Pref> auf      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-aus$      = <Pref> aus      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-bei$      = <Pref> bei      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-durch$    = <Pref> durch    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-ein$      = <Pref> ein      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-fort$     = <Pref> fort     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-gegen$    = <Pref> gegen    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-heim$     = <Pref> heim     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-her$      = <Pref> her      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-hin$      = <Pref> hin      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-hinter$   = <Pref> hinter   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-los$      = <Pref> los      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-nach$     = <Pref> nach     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-ueber$    = <Pref> über     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-um$       = <Pref> um       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-unter$    = <Pref> unter    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-vor$      = <Pref> vor      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-weg$      = <Pref> weg      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-wieder$   = <Pref> wieder   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zu$       = <Pref> zu       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zurueck$  = <Pref> zurück   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zwischen$ = <Pref> zwischen <VB> <Stem> $C$* <V> $C$*

$DerRestrPOS$ = $DerRestrPOSSuff-e$        | \
                $DerRestrPOSSuff-er$       | \
                $DerRestrPOSSuff-chen$     | \
                $DerRestrPOSSuff-lein$     | \
                $DerRestrPOSPref-un$       | \
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
                $DerRestrPOSPrev-zwischen$

% exclude suff(e), suff(er), suff(chen), and suff(lein) for abbreviated bases (?)
$DerRestrAbbrSuff-e$    = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suff> e    $C$*)
$DerRestrAbbrSuff-er$   = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suff> er   $C$*)
$DerRestrAbbrSuff-chen$ = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suff> chen $C$*)
$DerRestrAbbrSuff-lein$ = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> <Suff> lein $C$*)

% exclude pref(un) for abbreviated bases
$DerRestrAbbrPref-un$ = !([<dc><uc>]* <Pref> un <DB> [<dc><uc>]* <Stem> <Abbr> ($C$* <VB>)? $C$*)

$DerRestrAbbr$ = $DerRestrAbbrSuff-e$    & \
                 $DerRestrAbbrSuff-er$   & \
                 $DerRestrAbbrSuff-chen$ & \
                 $DerRestrAbbrSuff-lein$ & \
                 $DerRestrAbbrPref-un$

$DerFilter$ = $DerRestrPOS$ & $DerRestrAbbr$

% compounding restrictions

$Pref$ = [<dc><uc>]* <Pref> $C$* [<DB><VB>]
$Suff$ =        <DB> <Suff> $C$*

% provisionally restrict nominal compounds to nominal,
% adjectival, or verbal initial or intermediate bases
$CompRestrPOS$ =  $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP><ADJ><V>] $C$* <HB>? <CB>   \
                 ($Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP><ADJ><V>] $C$* <HB>? <CB>)* \
                  $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>]         $C$*

% in nominal compounds, exclude downcased initial bases
$CompRestrOrth1$ = !(            <dc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude downcased intermediate bases with a preceding hyphen
$CompRestrOrth2$ = !(                 $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>  <CB> <dc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude downcased final bases with a preceding hyphen
$CompRestrOrth3$ = !(                 $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>  <CB> <dc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, require nominal intermediate bases without a preceding hyphen to be downcased
$CompRestrOrth4$ =                  $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                   (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<ADJ><V>]    $C$* | \
                    <HB>  <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$* | \
                          <CB> <dc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)* \
                    <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*

% in nominal compounds, require nominal final bases without a preceding hyphen to be downcased
$CompRestrOrth5$ =                  $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                   (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                   (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<ADJ><V>]    $C$* | \
                    <HB>  <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$* | \
                          <CB> <dc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude upcased unprefixed nominal initial bases
$CompRestrOrth6$ = !(            <uc>         [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude upcased unprefixed nominal intermediate bases
$CompRestrOrth7$ = !(                 $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>? <CB> <uc>         [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, exclude upcased unprefixed nominal final bases
$CompRestrOrth8$ = !(                 $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                     (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                      <HB>? <CB> <uc>         [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

% in nominal compounds, require adjectival or verbal initial bases to be upcased
$CompRestrOrth9$ = (           <uc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<ADJ><V>]    $C$* | \
                                    $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)  \
                   (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                    <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*

% in nominal compounds, require adjectival or verbal intermediate bases with a preceding hyphen to be upcased
$CompRestrOrth10$ =                  $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                    (<HB>  <CB> <uc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<ADJ><V>]    $C$* | \
                           <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<ADJ><V>]    $C$* | \
                     <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)* \
                     <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*

% in nominal compounds, exclude upcased adjectival or verbal intermediate bases without a preceding hyphen
$CompRestrOrth11$ = !(                 $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*   \
                      (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                             <CB> <uc> $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<ADJ><V>]    $C$*   \
                      (<HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$*               $C$*)* \
                       <HB>? <CB>      $Pref$? [<dc><uc>]* <Stem> $C$* $Suff$* [<NN><NPROP>] $C$*)

$CompRestrOrth$ = $CompRestrOrth1$  & \
                  $CompRestrOrth2$  & \
                  $CompRestrOrth3$  & \
                  $CompRestrOrth4$  & \
                  $CompRestrOrth5$  & \
                  $CompRestrOrth6$  & \
                  $CompRestrOrth7$  & \
                  $CompRestrOrth8$  & \
                  $CompRestrOrth9$  & \
                  $CompRestrOrth10$ & \
                  $CompRestrOrth11$

% exclude compounding of abbreviated non-final bases without a following hyphen
$CompRestrAbbr1$ = !(($Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$* <HB>? <CB>)* \
                      $Pref$? [<dc><uc>]* <Stem> <Abbr> $C$* $Suff$*       <CB>   \
                     ($Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$* <HB>? <CB>)* \
                      $Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$*)

% exclude compounding of abbreviated non-final bases without a preceding hyphen
$CompRestrAbbr2$ = !(($Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$* <HB>? <CB>)* \
                      $Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$*       <CB>   \
                      $Pref$? [<dc><uc>]* <Stem> <Abbr> $C$* $Suff$* <HB>? <CB>   \
                     ($Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$* <HB>? <CB>)* \
                      $Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$*)

% exclude compounding of abbreviated final bases without a preceding hyphen
$CompRestrAbbr3$ = !(($Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$* <HB>? <CB>)* \
                      $Pref$? [<dc><uc>]* <Stem>        $C$* $Suff$*       <CB>   \
                      $Pref$? [<dc><uc>]* <Stem> <Abbr> $C$* $Suff$*)

$CompRestrAbbr$ = $CompRestrAbbr1$ & \
                  $CompRestrAbbr2$ & \
                  $CompRestrAbbr3$

$CompFilter$ = $CompRestrPOS$ & $CompRestrOrth$ & $CompRestrAbbr$
