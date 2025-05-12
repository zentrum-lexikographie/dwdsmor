% dwdsmor-root.fst
% Version 10.1
% Andreas Nolda 2025-05-12

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

% derived base stems with preverbs

$DerBaseStems$ = $DerPrevRoot-ab$       $PrevRoot-ab$       <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-an$       $PrevRoot-an$       <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-auf$      $PrevRoot-auf$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-aus$      $PrevRoot-aus$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-bei$      $PrevRoot-bei$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-durch$    $PrevRoot-durch$    <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-ein$      $PrevRoot-ein$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-fort$     $PrevRoot-fort$     <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-gegen$    $PrevRoot-gegen$    <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-heim$     $PrevRoot-heim$     <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-her$      $PrevRoot-her$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-hin$      $PrevRoot-hin$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-hinter$   $PrevRoot-hinter$   <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-los$      $PrevRoot-los$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-mit$      $PrevRoot-mit$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-nach$     $PrevRoot-nach$     <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-ueber$    $PrevRoot-ueber$    <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-um$       $PrevRoot-um$       <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-unter$    $PrevRoot-unter$    <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-vor$      $PrevRoot-vor$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-weg$      $PrevRoot-weg$      <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-wieder$   $PrevRoot-wieder$   <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-zu$       $PrevRoot-zu$       <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-zurueck$  $PrevRoot-zurueck$  <>:<VB> $BaseStems$ | \
                 $DerPrevRoot-zwischen$ $PrevRoot-zwischen$ <>:<VB> $BaseStems$ || $DerFilter$

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

$ConvBaseStemsVPartPres$ = $ConvPartRoot$ $BaseStemsVPartPres$   <ADJ> <base> <native> <>:<AdjPosAttr> % cf. Duden-Grammatik (2016: § 481, § 508, § 829)
$ConvBaseStemsVPartPerf$ = $ConvPartRoot$ $BaseStemsVPartPerf-t$ <ADJ> <base> <native> <>:<AdjPos>    | \ % cf. Duden-Grammatik (2016: § 508)
                           $ConvPartRoot$ $BaseStemsVPartPerf-n$ <ADJ> <base> <native> <>:<AdjPos-en> | \ % cf. Duden-Grammatik (2016: § 508)
                           $ConvPartRoot$ $BaseStemsVPartPerf-d$ <ADJ> <base> <native> <>:<AdjPosPred>

$ConvBaseStems$ = $ConvBaseStemsVPartPres$ | \
                  $ConvBaseStemsVPartPerf$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStems$

% derived base stems with affixes

$DerStemsSuff-e$    = $DerStems$ || $DerStemFilterSuff-e$
$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStems$ = $DerPrefRoot-un$ <>:<uc> $PrefRoot-un$       <>:<DB> <>:<dc> $BaseStems$     | \
                 $DerPrefRoot-un$         $PrefRoot-un$       <>:<DB>         $BaseStems$     | \
                 $DerSuffRoot-e$          $DerStemsSuff-e$    <>:<DB>         $SuffRoot-e$    | \
                 $DerSuffRoot-er$         $DerStemsSuff-er$   <>:<DB>         $SuffRoot-er$   | \
                 $DerSuffRoot-chen$       $DerStemsSuff-chen$ <>:<DB>         $SuffRoot-chen$ | \
                 $DerSuffRoot-lein$       $DerStemsSuff-lein$ <>:<DB>         $SuffRoot-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $DerPrefRoot-un$  <>:<uc> $PrefRoot-un$       <>:<DB> <>:<dc> $CompStems$ | \
                 $DerPrefRoot-un$          $PrefRoot-un$       <>:<DB>         $CompStems$ | \
                 $DerPrevRoot-ab$          $PrevRoot-ab$       <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-an$          $PrevRoot-an$       <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-auf$         $PrevRoot-auf$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-aus$         $PrevRoot-aus$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-bei$         $PrevRoot-bei$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-durch$       $PrevRoot-durch$    <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-ein$         $PrevRoot-ein$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-fort$        $PrevRoot-fort$     <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-gegen$       $PrevRoot-gegen$    <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-heim$        $PrevRoot-heim$     <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-her$         $PrevRoot-her$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-hin$         $PrevRoot-hin$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-hinter$      $PrevRoot-hinter$   <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-los$         $PrevRoot-los$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-mit$         $PrevRoot-mit$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-nach$        $PrevRoot-nach$     <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-ueber$       $PrevRoot-ueber$    <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-um$          $PrevRoot-um$       <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-unter$       $PrevRoot-unter$    <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-vor$         $PrevRoot-vor$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-weg$         $PrevRoot-weg$      <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-wieder$      $PrevRoot-wieder$   <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-zu$          $PrevRoot-zu$       <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-zurueck$     $PrevRoot-zurueck$  <>:<VB>         $CompStems$ | \
                 $DerPrevRoot-zwischen$    $PrevRoot-zwischen$ <>:<VB>         $CompStems$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = ($CompRoot-concat$ <>:[<dc><uc>]? $CompStems$     <CB> | \
          $CompRoot-hyph$   <>:[<dc><uc>]? $CompStems$ <HB><CB>)+ \
                            <>:[<dc><uc>]? $BaseStems$ || $CompFilter$

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
