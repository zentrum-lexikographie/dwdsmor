% wf.fst
% Version 12.5
% Andreas Nolda 2025-07-08

#include "symbols.fst"

% processes and means

$ConvInfNonCl$   = <CONV>:<> <ident|Inf>:<>  <NN>  <base> <native> <>:<NNeut|Sg_s>
$ConvPartPres$   = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPosAttr> % cf. Duden-Grammatik (2016: § 481, § 508, § 829)
$ConvPartPerf_t$ = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPos>     % cf. Duden-Grammatik (2016: § 508)
$ConvPartPerf_n$ = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPos-en>  % cf. Duden-Grammatik (2016: § 508)
$ConvPartPerf_d$ = <CONV>:<> <ident|Part>:<> <ADJ> <base> <native> <>:<AdjPosPred>
$ConvADJMasc$    = <CONV>:<> <ident|Masc>:<> <NN>  <base> <native> <>:<del(-e)><>:<NMasc-Adj>
$ConvADJNeut$    = <CONV>:<> <ident|Neut>:<> <NN>  <base> <native> <>:<del(-e)><>:<NNeut-Adj|Sg>
$ConvADJFem$     = <CONV>:<> <ident|Fem>:<>  <NN>  <base> <native> <>:<del(-e)><>:<NFem-Adj>
% ...

$DerSuff-e$    = <DER>:<> <suff(e)>:<>    <Suff> e     <NN>   <base> <native> <>:<NMasc_n_n_0>
$DerSuff-er$   = <DER>:<> <suff(er)>:<>   <Suff> er    <NN>   <base> <native> <>:<NMasc_s_0_n>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<> <Suff> chen  <NN>   <base> <native> <>:<NNeut_s_0_0>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<> <Suff> lein  <NN>   <base> <native> <>:<NNeut_s_0_0>
$DerSuff-zig$  = <DER>:<> <suff(zig)>:<>  <Suff> <z>ig <CARD> <base> <native> <>:<Card0>
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

% conversion restrictions

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger# #phon-trigger# #pos# #subcat# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>]

% exclude "worden" as a conversion basis
$ConvRestrLexPartPerf$ = !(<Stem>word<SB>en ^$ConvPartPerf_n$)

$ConvRestrLex$ = $ConvRestrLexPartPerf$

$ConvFilter$ = $ConvRestrLex$

% derivation restrictions

ALPHABET = [#entry-type# #char# #boundary-trigger# #index# #wf# #pos# #subcat# \
            #stem-type# #suff# #origin# <Abbr>]

$C$ = [#index# #stem-type# #origin#]

% exclude "sein" as a basis for preverb prefixation
% cf. Deutsche Rechtschreibung (2024: § 35)
$DerRestrLexPrevLv2$ = !(_$DerPrev$ <VB> <Stem> sei<SB>n $C$* <V> $C$*)

$DerRestrLexLv2$ = $DerRestrLexPrevLv2$

$DerFilterLv2$ = $DerRestrLexLv2$

ALPHABET = [#entry-type# #char# #surface-trigger# #orth-trigger# \
            #boundary-trigger# #pos# #subcat# #stem-type# #suff# #origin# \
            #inflection# #auxiliary# <Abbr><ge>]

$C$ = .
$C$ = $C$-[#entry-type# <CB><VB><HB><DB>]

% restrict suff(zig) to cardinal bases
$DerRestrCardPOSSuff-zig$ = <Stem> $C$* <CARD> $C$* <DB> ^$DerSuff-zig$

$DerRestrCardPOS$ = $DerRestrCardPOSSuff-zig$

$DerCardFilter$ = $DerRestrCardPOS$

% restrict suff(e) to proper-name bases (?)
$DerRestrPOSSuff-e$ = [<dc><uc>]* <Stem> $C$* <NPROP> $C$* <DB> ^$DerSuff-e$

% restrict suff(er) to proper-name bases (?)
$DerRestrPOSSuff-er$ = [<dc><uc>]* <Stem> $C$* <NPROP> $C$* <DB> ^$DerSuff-er$

% restrict suff(chen) and suff(lein) to nominal bases
$DerRestrPOSSuff-chen$ = [<dc><uc>]* <Stem> $C$* <NN> $C$* <DB> ^$DerSuff-chen$
$DerRestrPOSSuff-lein$ = [<dc><uc>]* <Stem> $C$* <NN> $C$* <DB> ^$DerSuff-lein$

% restrict pref(un) to adjectival and nominal bases
$DerRestrPOSPref-un$ =      ^$DerPref-un$ <DB>      <Stem> ($C$* <VB>)? $C$* <ADJ> $C$*
$DerRestrPOSPref-Un$ = <uc> ^$DerPref-un$ <DB> <dc> <Stem> ($C$* <VB>)? $C$* <NN>  $C$*

% restrict prev() to verbal bases
$DerRestrPOSPrev-mit$ = ^$DerPrev-mit$ <VB> <Stem> ($C$* <VB>)? $C$* <V> $C$*

% restrict prev() to verbal bases without preverb
$DerRestrPOSPrev-ab$       = ^$DerPrev-ab$       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-an$       = ^$DerPrev-an$       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-auf$      = ^$DerPrev-auf$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-aus$      = ^$DerPrev-aus$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-bei$      = ^$DerPrev-bei$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-durch$    = ^$DerPrev-durch$    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-ein$      = ^$DerPrev-ein$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-fort$     = ^$DerPrev-fort$     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-gegen$    = ^$DerPrev-gegen$    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-heim$     = ^$DerPrev-heim$     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-her$      = ^$DerPrev-her$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-hin$      = ^$DerPrev-hin$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-hinter$   = ^$DerPrev-hinter$   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-los$      = ^$DerPrev-los$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-nach$     = ^$DerPrev-nach$     <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-ueber$    = ^$DerPrev-ueber$    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-um$       = ^$DerPrev-um$       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-unter$    = ^$DerPrev-unter$    <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-vor$      = ^$DerPrev-vor$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-weg$      = ^$DerPrev-weg$      <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-wieder$   = ^$DerPrev-wieder$   <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zu$       = ^$DerPrev-zu$       <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zurueck$  = ^$DerPrev-zurueck$  <VB> <Stem> $C$* <V> $C$*
$DerRestrPOSPrev-zwischen$ = ^$DerPrev-zwischen$ <VB> <Stem> $C$* <V> $C$*

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
$DerRestrAbbrSuff-e$    = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> ^$DerSuff-e$)
$DerRestrAbbrSuff-er$   = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> ^$DerSuff-er$)
$DerRestrAbbrSuff-chen$ = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> ^$DerSuff-chen$)
$DerRestrAbbrSuff-lein$ = !([<dc><uc>]* <Stem> <Abbr> $C$* <DB> ^$DerSuff-lein$)

% exclude pref(un) for abbreviated bases
$DerRestrAbbrPref-un$ = !([<dc><uc>]* ^$DerPref-un$ <DB> [<dc><uc>]* <Stem> <Abbr> ($C$* <VB>)? $C$*)

% exclude prev() for abbreviated bases
$DerRestrAbbrPrev$ = !(^$DerPrev$ <VB> [<dc><uc>]* <Stem> <Abbr> $C$*)

$DerRestrAbbr$ = $DerRestrAbbrSuff-e$    & \
                 $DerRestrAbbrSuff-er$   & \
                 $DerRestrAbbrSuff-chen$ & \
                 $DerRestrAbbrSuff-lein$ & \
                 $DerRestrAbbrPref-un$   & \
                 $DerRestrAbbrPrev$

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
