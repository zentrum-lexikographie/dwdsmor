% dwdsmor-root.fst
% Version 10.0
% Andreas Nolda 2025-05-09

#include "symbols.fst"
#include "num.fst"
#include "stemtype.fst"
#include "wf.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "sep.fst"
#include "trunc.fst"
#include "orth.fst"
#include "punct.fst"
#include "cleanup.fst"


% lexicon

$LEX$ = "lex.txt"


% numbers

$LEX$ = $LEX$ | $NUM$


% cleanup of level-specific symbols

$LEX$ = $CleanupInflLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$ || $CleanupOrth$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$
$DerStems$  = $LEX$ || $DerStemFilter$
$CompStems$ = $LEX$ || $CompStemFilter$


% word formation

% preverbs

$Prev-ab$       = <Prefix> {}:{ab}
$Prev-an$       = <Prefix> {}:{an}
$Prev-auf$      = <Prefix> {}:{auf}
$Prev-aus$      = <Prefix> {}:{aus}
$Prev-bei$      = <Prefix> {}:{bei}
$Prev-durch$    = <Prefix> {}:{durch}
$Prev-ein$      = <Prefix> {}:{ein}
$Prev-fort$     = <Prefix> {}:{fort}
$Prev-gegen$    = <Prefix> {}:{gegen}
$Prev-heim$     = <Prefix> {}:{heim}
$Prev-her$      = <Prefix> {}:{her}
$Prev-hin$      = <Prefix> {}:{hin}
$Prev-hinter$   = <Prefix> {}:{hinter}
$Prev-los$      = <Prefix> {}:{los}
$Prev-mit$      = <Prefix> {}:{mit}
$Prev-nach$     = <Prefix> {}:{nach}
$Prev-ueber$    = <Prefix> {}:{über}
$Prev-um$       = <Prefix> {}:{um}
$Prev-unter$    = <Prefix> {}:{unter}
$Prev-vor$      = <Prefix> {}:{vor}
$Prev-weg$      = <Prefix> {}:{weg}
$Prev-wieder$   = <Prefix> {}:{wieder}
$Prev-zu$       = <Prefix> {}:{zu}
$Prev-zurueck$  = <Prefix> {}:{zurück}
$Prev-zwischen$ = <Prefix> {}:{zwischen}

% affixes

$Pref-un$ = <Prefix> {}:{un}

$Suff-e$    = <Suffix> {}:{e}    <NN> <base> <native> <>:<NMasc_n_n_0>
$Suff-er$   = <Suffix> {}:{er}   <NN> <base> <native> <>:<NMasc_s_0_n>
$Suff-chen$ = <Suffix> {}:{chen} <NN> <base> <native> <>:<NNeut_s_0_0>
$Suff-lein$ = <Suffix> {}:{lein} <NN> <base> <native> <>:<NNeut_s_0_0>

% processes and means

$ConvPart$ = <CONV>:<> <ident|Part>:<>

$DerPrev-ab$       = <DER>:<> <prev(ab)>:<>
$DerPrev-an$       = <DER>:<> <prev(an)>:<>
$DerPrev-auf$      = <DER>:<> <prev(auf)>:<>
$DerPrev-aus$      = <DER>:<> <prev(aus)>:<>
$DerPrev-bei$      = <DER>:<> <prev(bei)>:<>
$DerPrev-durch$    = <DER>:<> <prev(durch)>:<>
$DerPrev-ein$      = <DER>:<> <prev(ein)>:<>
$DerPrev-fort$     = <DER>:<> <prev(fort)>:<>
$DerPrev-gegen$    = <DER>:<> <prev(gegen)>:<>
$DerPrev-heim$     = <DER>:<> <prev(heim)>:<>
$DerPrev-her$      = <DER>:<> <prev(her)>:<>
$DerPrev-hin$      = <DER>:<> <prev(hin)>:<>
$DerPrev-hinter$   = <DER>:<> <prev(hinter)>:<>
$DerPrev-los$      = <DER>:<> <prev(los)>:<>
$DerPrev-mit$      = <DER>:<> <prev(mit)>:<>
$DerPrev-nach$     = <DER>:<> <prev(nach)>:<>
$DerPrev-ueber$    = <DER>:<> <prev(ueber)>:<>
$DerPrev-um$       = <DER>:<> <prev(um)>:<>
$DerPrev-unter$    = <DER>:<> <prev(unter)>:<>
$DerPrev-vor$      = <DER>:<> <prev(vor)>:<>
$DerPrev-weg$      = <DER>:<> <prev(weg)>:<>
$DerPrev-wieder$   = <DER>:<> <prev(wieder)>:<>
$DerPrev-zu$       = <DER>:<> <prev(zu)>:<>
$DerPrev-zurueck$  = <DER>:<> <prev(zurueck)>:<>
$DerPrev-zwischen$ = <DER>:<> <prev(zwischen)>:<>
% ...

$DerPref-un$ = <DER>:<> <pref(un)>:<>
% ...

$DerSuff-e$    = <DER>:<> <suff(e)>:<>
$DerSuff-er$   = <DER>:<> <suff(er)>:<>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<>
% ...

$Comp-concat$ = <COMP>:<> <concat>:<>
$Comp-hyph$   = <COMP>:<> <hyph>:<>

$DC$ = <>:<dc>
$UC$ = <>:<uc>
$O$  = <>:[#orth-trigger#]

% derived base stems with preverbs

$DerBaseStems$ = $DerPrev-ab$       $Prev-ab$       <>:<VB> $BaseStems$ | \
                 $DerPrev-an$       $Prev-an$       <>:<VB> $BaseStems$ | \
                 $DerPrev-auf$      $Prev-auf$      <>:<VB> $BaseStems$ | \
                 $DerPrev-aus$      $Prev-aus$      <>:<VB> $BaseStems$ | \
                 $DerPrev-bei$      $Prev-bei$      <>:<VB> $BaseStems$ | \
                 $DerPrev-durch$    $Prev-durch$    <>:<VB> $BaseStems$ | \
                 $DerPrev-ein$      $Prev-ein$      <>:<VB> $BaseStems$ | \
                 $DerPrev-fort$     $Prev-fort$     <>:<VB> $BaseStems$ | \
                 $DerPrev-gegen$    $Prev-gegen$    <>:<VB> $BaseStems$ | \
                 $DerPrev-heim$     $Prev-heim$     <>:<VB> $BaseStems$ | \
                 $DerPrev-her$      $Prev-her$      <>:<VB> $BaseStems$ | \
                 $DerPrev-hin$      $Prev-hin$      <>:<VB> $BaseStems$ | \
                 $DerPrev-hinter$   $Prev-hinter$   <>:<VB> $BaseStems$ | \
                 $DerPrev-los$      $Prev-los$      <>:<VB> $BaseStems$ | \
                 $DerPrev-mit$      $Prev-mit$      <>:<VB> $BaseStems$ | \
                 $DerPrev-nach$     $Prev-nach$     <>:<VB> $BaseStems$ | \
                 $DerPrev-ueber$    $Prev-ueber$    <>:<VB> $BaseStems$ | \
                 $DerPrev-um$       $Prev-um$       <>:<VB> $BaseStems$ | \
                 $DerPrev-unter$    $Prev-unter$    <>:<VB> $BaseStems$ | \
                 $DerPrev-vor$      $Prev-vor$      <>:<VB> $BaseStems$ | \
                 $DerPrev-weg$      $Prev-weg$      <>:<VB> $BaseStems$ | \
                 $DerPrev-wieder$   $Prev-wieder$   <>:<VB> $BaseStems$ | \
                 $DerPrev-zu$       $Prev-zu$       <>:<VB> $BaseStems$ | \
                 $DerPrev-zurueck$  $Prev-zurueck$  <>:<VB> $BaseStems$ | \
                 $DerPrev-zwischen$ $Prev-zwischen$ <>:<VB> $BaseStems$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

% converted base stems

$BaseStemsV$ = $BaseStems$ || $BaseStemFilterV$

$BaseStemsV$ = $CleanupWFLv2$ || $BaseStemsV$

$BaseStemsV$ = $BaseStemsV$ || $CleanupWF$

$BaseStemsV$ = $BaseStemsV$ $INFL$ || $InflFilter$

$BaseStemsVPartPres$ = $BaseStemFilterVPartPresLv2$ || $BaseStemsV$
$BaseStemsVPartPerf$ = $BaseStemFilterVPartPerfLv2$ || $BaseStemsV$

$BaseStemsVPartPres$ = $CleanupCatLv2$ || $BaseStemsVPartPres$
$BaseStemsVPartPerf$ = $CleanupCatLv2$ || $BaseStemsVPartPerf$

$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerGe$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerGe$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerZu$
$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerPartConv$

$BaseStemsVPartPres$ = <>:<WB> $BaseStemsVPartPres$ <>:<WB>
$BaseStemsVPartPerf$ = <>:<WB> $BaseStemsVPartPerf$ <>:<WB>

$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $PHON$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $PHON$

$BaseStemsVPartPres$ = $BaseStemsVPartPres$ || $MarkerWB$
$BaseStemsVPartPerf$ = $BaseStemsVPartPerf$ || $MarkerWB$

$BaseStemsVPartPerf-t$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf-t$
$BaseStemsVPartPerf-n$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf-n$
$BaseStemsVPartPerf-d$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf-d$

$ConvBaseStemsVPartPres$ = $ConvPart$ $BaseStemsVPartPres$   <ADJ> <base> <native> <>:<AdjPosAttr> % cf. Duden-Grammatik (2016: § 481, § 508, § 829)
$ConvBaseStemsVPartPerf$ = $ConvPart$ $BaseStemsVPartPerf-t$ <ADJ> <base> <native> <>:<AdjPos>     | \ % cf. Duden-Grammatik (2016: § 508)
                           $ConvPart$ $BaseStemsVPartPerf-n$ <ADJ> <base> <native> <>:<AdjPos-en>  | \ % cf. Duden-Grammatik (2016: § 508)
                           $ConvPart$ $BaseStemsVPartPerf-d$ <ADJ> <base> <native> <>:<AdjPosPred>

$ConvBaseStems$ = $ConvBaseStemsVPartPres$ | \
                  $ConvBaseStemsVPartPerf$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStems$

% derived base stems with affixes

$DerStemsSuff-e$    = $DerStems$ || $DerStemFilterSuff-e$
$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStems$ = $DerPref-un$ $UC$ $Pref-un$           <>:<DB> $DC$ $BaseStems$ | \
                 $DerPref-un$      $Pref-un$           <>:<DB>      $BaseStems$ | \
                 $DerSuff-e$       $DerStemsSuff-e$    <>:<DB>      $Suff-e$    | \
                 $DerSuff-er$      $DerStemsSuff-er$   <>:<DB>      $Suff-er$   | \
                 $DerSuff-chen$    $DerStemsSuff-chen$ <>:<DB>      $Suff-chen$ | \
                 $DerSuff-lein$    $DerStemsSuff-lein$ <>:<DB>      $Suff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $DerPref-un$  $UC$ $Pref-un$       <>:<DB> $DC$ $CompStems$ | \
                 $DerPref-un$       $Pref-un$       <>:<DB>      $CompStems$ | \
                 $DerPrev-ab$       $Prev-ab$       <>:<VB>      $CompStems$ | \
                 $DerPrev-an$       $Prev-an$       <>:<VB>      $CompStems$ | \
                 $DerPrev-auf$      $Prev-auf$      <>:<VB>      $CompStems$ | \
                 $DerPrev-aus$      $Prev-aus$      <>:<VB>      $CompStems$ | \
                 $DerPrev-bei$      $Prev-bei$      <>:<VB>      $CompStems$ | \
                 $DerPrev-durch$    $Prev-durch$    <>:<VB>      $CompStems$ | \
                 $DerPrev-ein$      $Prev-ein$      <>:<VB>      $CompStems$ | \
                 $DerPrev-fort$     $Prev-fort$     <>:<VB>      $CompStems$ | \
                 $DerPrev-gegen$    $Prev-gegen$    <>:<VB>      $CompStems$ | \
                 $DerPrev-heim$     $Prev-heim$     <>:<VB>      $CompStems$ | \
                 $DerPrev-her$      $Prev-her$      <>:<VB>      $CompStems$ | \
                 $DerPrev-hin$      $Prev-hin$      <>:<VB>      $CompStems$ | \
                 $DerPrev-hinter$   $Prev-hinter$   <>:<VB>      $CompStems$ | \
                 $DerPrev-los$      $Prev-los$      <>:<VB>      $CompStems$ | \
                 $DerPrev-mit$      $Prev-mit$      <>:<VB>      $CompStems$ | \
                 $DerPrev-nach$     $Prev-nach$     <>:<VB>      $CompStems$ | \
                 $DerPrev-ueber$    $Prev-ueber$    <>:<VB>      $CompStems$ | \
                 $DerPrev-um$       $Prev-um$       <>:<VB>      $CompStems$ | \
                 $DerPrev-unter$    $Prev-unter$    <>:<VB>      $CompStems$ | \
                 $DerPrev-vor$      $Prev-vor$      <>:<VB>      $CompStems$ | \
                 $DerPrev-weg$      $Prev-weg$      <>:<VB>      $CompStems$ | \
                 $DerPrev-wieder$   $Prev-wieder$   <>:<VB>      $CompStems$ | \
                 $DerPrev-zu$       $Prev-zu$       <>:<VB>      $CompStems$ | \
                 $DerPrev-zurueck$  $Prev-zurueck$  <>:<VB>      $CompStems$ | \
                 $DerPrev-zwischen$ $Prev-zwischen$ <>:<VB>      $CompStems$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = ($Comp-concat$ $O$? $CompStems$     <CB> | \
          $Comp-hyph$   $O$? $CompStems$ <HB><CB>)+ \
                        $O$? $BaseStems$ || $CompFilter$

$LEX$ = $BASE$ | $COMP$


% cleanup of word-formation-related symbols

$LEX$ = $CleanupWFLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$
$MORPH$ = $MORPH$ || $MarkerZu$
$MORPH$ = $MORPH$ || $MarkerPart$
$MORPH$ = $MORPH$ || $MarkerImp$


% word-boundary markers

$MORPH$ = <>:<WB> $MORPH$ <>:<WB>


% (morpho)phonology

$MORPH$ = $MORPH$ || $PHON$


% preverb separation

$MORPH$ = $MORPH$ | <SEP>:<> ($SepPrev1RootLv2$ || $MORPH$ || $SepPrev1$) | \
                    <SEP>:<> ($SepPrev2RootLv2$ || $MORPH$ || $SepPrev2$)


% morpheme truncation

$MORPH$ = $MORPH$ | <TRUNC>:<> ($TruncInitialRootLv2$ || $MORPH$ || $TruncInitial$) | \
                    <TRUNC>:<> ($TruncFinalLv2$       || $MORPH$ || $TruncFinal$)


% old spelling

$MORPH$ = $MORPH$ | <OLDORTH>:<> ($MORPH$ || $OrthOld$)


% cleanup of word-boundary markers

$MORPH$ = $MORPH$ || $CleanupWB$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryRootLv2$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundary$


% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexLv2$ || $MORPH$


% Swiss spelling

$MORPH$ = $MORPH$ | <CH>:<> ($NoOrthOldFilterLv2$ || $MORPH$ || $OrthCH$)


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $OrthCap$)


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% the resulting automaton

$MORPH$
