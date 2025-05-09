% dwdsmor-lemma.fst
% Version 13.0
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


% levels

% use surface level of derivation stems and compounding stems
% also for their analysis level
$LEX$ = ( $LEX$ || $BaseStemFilter$) | \
        (^$LEX$ || $DerStemFilter$)  | \
        (^$LEX$ || $CompStemFilter$)


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

% affixes

$Pref-un$ = <Prefix> un
% ...

$Suff-e$    = <Suffix> e    <NN> <base> <native> <>:<NMasc_n_n_0>
$Suff-er$   = <Suffix> er   <NN> <base> <native> <>:<NMasc_s_0_n>
$Suff-chen$ = <Suffix> chen <NN> <base> <native> <>:<NNeut_s_0_0>
$Suff-lein$ = <Suffix> lein <NN> <base> <native> <>:<NNeut_s_0_0>
% ...

% means

$DC$ = <dc>
$UC$ = <uc>
$O$  = [#orth-trigger#]

% derived base stems with preverbs

$DerBaseStems$ = $Prev-ab$       <VB> $BaseStems$ | \
                 $Prev-an$       <VB> $BaseStems$ | \
                 $Prev-auf$      <VB> $BaseStems$ | \
                 $Prev-aus$      <VB> $BaseStems$ | \
                 $Prev-bei$      <VB> $BaseStems$ | \
                 $Prev-durch$    <VB> $BaseStems$ | \
                 $Prev-ein$      <VB> $BaseStems$ | \
                 $Prev-fort$     <VB> $BaseStems$ | \
                 $Prev-gegen$    <VB> $BaseStems$ | \
                 $Prev-heim$     <VB> $BaseStems$ | \
                 $Prev-her$      <VB> $BaseStems$ | \
                 $Prev-hin$      <VB> $BaseStems$ | \
                 $Prev-hinter$   <VB> $BaseStems$ | \
                 $Prev-los$      <VB> $BaseStems$ | \
                 $Prev-mit$      <VB> $BaseStems$ | \
                 $Prev-nach$     <VB> $BaseStems$ | \
                 $Prev-ueber$    <VB> $BaseStems$ | \
                 $Prev-um$       <VB> $BaseStems$ | \
                 $Prev-unter$    <VB> $BaseStems$ | \
                 $Prev-vor$      <VB> $BaseStems$ | \
                 $Prev-weg$      <VB> $BaseStems$ | \
                 $Prev-wieder$   <VB> $BaseStems$ | \
                 $Prev-zu$       <VB> $BaseStems$ | \
                 $Prev-zurueck$  <VB> $BaseStems$ | \
                 $Prev-zwischen$ <VB> $BaseStems$ || $DerFilter$

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

$BaseStemsVPartPres$ = ^$BaseStemsVPartPres$
$BaseStemsVPartPerf$ = ^$BaseStemsVPartPerf$

$BaseStemsVPartPerf-t$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf-t$
$BaseStemsVPartPerf-n$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf-n$
$BaseStemsVPartPerf-d$ = $BaseStemsVPartPerf$ || $BaseStemFilterVPartPerf-d$

$ConvBaseStemsVPartPres$ = $BaseStemsVPartPres$   <ADJ> <base> <native> <>:<AdjPosAttr>    % cf. Duden-Grammatik (2016: § 481, § 508, § 829)
$ConvBaseStemsVPartPerf$ = $BaseStemsVPartPerf-t$ <ADJ> <base> <native> <>:<AdjPos>    | \ % cf. Duden-Grammatik (2016: § 508)
                           $BaseStemsVPartPerf-n$ <ADJ> <base> <native> <>:<AdjPos-en> | \ % cf. Duden-Grammatik (2016: § 508)
                           $BaseStemsVPartPerf-d$ <ADJ> <base> <native> <>:<AdjPosPred>

$ConvBaseStems$ = $ConvBaseStemsVPartPres$ | \
                  $ConvBaseStemsVPartPerf$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStems$

% derived base stems with affixes

$DerStemsSuff-e$    = $DerStems$ || $DerStemFilterSuff-e$
$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStems$ = $UC$ $Pref-un$           <DB> $DC$ $BaseStems$ | \
                      $Pref-un$           <DB>      $BaseStems$ | \
                      $DerStemsSuff-e$    <DB>      $Suff-e$    | \
                      $DerStemsSuff-er$   <DB>      $Suff-er$   | \
                      $DerStemsSuff-chen$ <DB>      $Suff-chen$ | \
                      $DerStemsSuff-lein$ <DB>      $Suff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$       <DB> $DC$ $CompStems$ | \
                      $Pref-un$       <DB>      $CompStems$ | \
                      $Prev-ab$       <VB>      $CompStems$ | \
                      $Prev-an$       <VB>      $CompStems$ | \
                      $Prev-auf$      <VB>      $CompStems$ | \
                      $Prev-aus$      <VB>      $CompStems$ | \
                      $Prev-bei$      <VB>      $CompStems$ | \
                      $Prev-durch$    <VB>      $CompStems$ | \
                      $Prev-ein$      <VB>      $CompStems$ | \
                      $Prev-fort$     <VB>      $CompStems$ | \
                      $Prev-gegen$    <VB>      $CompStems$ | \
                      $Prev-heim$     <VB>      $CompStems$ | \
                      $Prev-her$      <VB>      $CompStems$ | \
                      $Prev-hin$      <VB>      $CompStems$ | \
                      $Prev-hinter$   <VB>      $CompStems$ | \
                      $Prev-los$      <VB>      $CompStems$ | \
                      $Prev-mit$      <VB>      $CompStems$ | \
                      $Prev-nach$     <VB>      $CompStems$ | \
                      $Prev-ueber$    <VB>      $CompStems$ | \
                      $Prev-um$       <VB>      $CompStems$ | \
                      $Prev-unter$    <VB>      $CompStems$ | \
                      $Prev-vor$      <VB>      $CompStems$ | \
                      $Prev-wieder$   <VB>      $CompStems$ | \
                      $Prev-weg$      <VB>      $CompStems$ | \
                      $Prev-zu$       <VB>      $CompStems$ | \
                      $Prev-zurueck$  <VB>      $CompStems$ | \
                      $Prev-zwischen$ <VB>      $CompStems$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ =           $O$? $CompStems$ \
         (<HB><CB> $O$? $CompStems$ | <CB> $DC$ $CompStems$)* \
         (<HB><CB>      $BaseStems$ | <CB> $DC$ $BaseStems$) || $CompFilter$

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

$MORPH$    = <>:<WB>   $MORPH$  <>:<WB>
$MORPHLv2$ = <>:<WB> (_$MORPH$) <>:<WB>


% (morpho)phonology

$MORPH$    = $MORPH$    || $PHON$
$MORPHLv2$ = $MORPHLv2$ || $PHONLv2$

$MORPH$ = (^_$MORPHLv2$) || $MORPH$


% cleanup of word-boundary markers on analysis level

$MORPH$ = $CleanupWBLv2$ || $MORPH$


% preverb separation

$MORPH$ = $MORPH$ | <SEP>:<> ($SepPrev1Lv2$ || $MORPH$ || $SepPrev1$) | \
                    <SEP>:<> ($SepPrev2Lv2$ || $MORPH$ || $SepPrev2$)


% morpheme truncation

$MORPH$ = $MORPH$ | <TRUNC>:<> ($TruncInitialLv2$ || $MORPH$ || $TruncInitial$) | \
                    <TRUNC>:<> ($TruncFinalLv2$   || $MORPH$ || $TruncFinal$)


% old spelling

$MORPH$ = $MORPH$ | <OLDORTH>:<> ($MORPH$ || $OrthOld$)


% cleanup of word-boundary markers

$MORPH$ = $MORPH$ || $CleanupWB$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryLv2$ || $MORPH$

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
