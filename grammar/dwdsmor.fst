% dwdsmor.fst
% Version 9.1
% Andreas Nolda 2023-05-20

#include "symbols.fst"
#include "num.fst"
#include "stemtype.fst"
#include "wf.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "punct.fst"
#include "orth.fst"
#include "cleanup.fst"


% lexicon

$LEX$ = "dwds.lex"


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

$LEX$ = $LEX$ || $CleanupIndex$ || $CleanupOrthOld$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$
$DerStems$  = $LEX$ || $DerStemFilter$
$CompStems$ = $LEX$ || $CompStemFilter$


% word formation

% affixes

$Pref-un$ = <Prefix> un

$Part-ab$       = <Prefix> ab
$Part-an$       = <Prefix> an
$Part-auf$      = <Prefix> auf
$Part-aus$      = <Prefix> aus
$Part-bei$      = <Prefix> bei
$Part-durch$    = <Prefix> durch
$Part-ein$      = <Prefix> ein
$Part-gegen$    = <Prefix> gegen
$Part-hinter$   = <Prefix> hinter
$Part-los$      = <Prefix> los
$Part-mit$      = <Prefix> mit
$Part-nach$     = <Prefix> nach
$Part-ueber$    = <Prefix> über
$Part-um$       = <Prefix> um
$Part-unter$    = <Prefix> unter
$Part-vor$      = <Prefix> vor
$Part-weg$      = <Prefix> weg
$Part-zu$       = <Prefix> zu
$Part-zurueck$  = <Prefix> zurück
$Part-zwischen$ = <Prefix> zwischen

$Suff-er$   = <Suffix> er   <NN> <base> <native> <>:<NMasc_s_0>
$Suff-chen$ = <Suffix> chen <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> lein <NN> <base> <native> <>:<NNeut_s_x>

% means

$DC$ = <^DC>
$UC$ = <^UC>

% derived base stems

$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStems$ = $UC$ $Pref-un$           <DB> $DC$ $BaseStems$ | \
                      $Pref-un$           <DB>      $BaseStems$ | \
                      $Part-ab$           <VB>      $BaseStems$ | \
                      $Part-an$           <VB>      $BaseStems$ | \
                      $Part-auf$          <VB>      $BaseStems$ | \
                      $Part-aus$          <VB>      $BaseStems$ | \
                      $Part-bei$          <VB>      $BaseStems$ | \
                      $Part-durch$        <VB>      $BaseStems$ | \
                      $Part-ein$          <VB>      $BaseStems$ | \
                      $Part-gegen$        <VB>      $BaseStems$ | \
                      $Part-hinter$       <VB>      $BaseStems$ | \
                      $Part-los$          <VB>      $BaseStems$ | \
                      $Part-mit$          <VB>      $BaseStems$ | \
                      $Part-nach$         <VB>      $BaseStems$ | \
                      $Part-ueber$        <VB>      $BaseStems$ | \
                      $Part-um$           <VB>      $BaseStems$ | \
                      $Part-unter$        <VB>      $BaseStems$ | \
                      $Part-vor$          <VB>      $BaseStems$ | \
                      $Part-weg$          <VB>      $BaseStems$ | \
                      $Part-zu$           <VB>      $BaseStems$ | \
                      $Part-zurueck$      <VB>      $BaseStems$ | \
                      $Part-zwischen$     <VB>      $BaseStems$ | \
                      $DerStemsSuff-er$   <DB>      $Suff-er$   | \
                      $DerStemsSuff-chen$ <DB>      $Suff-chen$ | \
                      $DerStemsSuff-lein$ <DB>      $Suff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$       <DB> $DC$ $CompStems$ | \
                      $Pref-un$       <DB>      $CompStems$ | \
                      $Part-ab$       <VB>      $CompStems$ | \
                      $Part-an$       <VB>      $CompStems$ | \
                      $Part-auf$      <VB>      $CompStems$ | \
                      $Part-aus$      <VB>      $CompStems$ | \
                      $Part-bei$      <VB>      $CompStems$ | \
                      $Part-durch$    <VB>      $CompStems$ | \
                      $Part-ein$      <VB>      $CompStems$ | \
                      $Part-gegen$    <VB>      $CompStems$ | \
                      $Part-hinter$   <VB>      $CompStems$ | \
                      $Part-los$      <VB>      $CompStems$ | \
                      $Part-mit$      <VB>      $CompStems$ | \
                      $Part-nach$     <VB>      $CompStems$ | \
                      $Part-ueber$    <VB>      $CompStems$ | \
                      $Part-um$       <VB>      $CompStems$ | \
                      $Part-unter$    <VB>      $CompStems$ | \
                      $Part-vor$      <VB>      $CompStems$ | \
                      $Part-weg$      <VB>      $CompStems$ | \
                      $Part-zu$       <VB>      $CompStems$ | \
                      $Part-zurueck$  <VB>      $CompStems$ | \
                      $Part-zwischen$ <VB>      $CompStems$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = $CompStems$ \
         (<HB><CB> $CompStems$ | <CB> $DC$ $CompStems$)* \
         (<HB><CB> $BaseStems$ | <CB> $DC$ $BaseStems$) || $CompFilter$

$LEX$ = $BASE$ | $COMP$


% cleanup of word-formation-related symbols

$LEX$ = $CleanupWFLv2$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$
$MORPH$ = $MORPH$ || $MarkerZu$
$MORPH$ = $MORPH$ || $MarkerImp$


% (morpho)phonology

$MORPH$    = <>:<WB>   $MORPH$  <>:<WB> || $PHON$
$MORPHLv2$ = <>:<WB> (_$MORPH$) <>:<WB> || $PHONLv2$

$MORPH$ = (^_$MORPHLv2$) || $MORPH$


% old spelling

$MORPH$ = $MORPH$ | ($MORPH$ || $OrthOld$) <OLDORTH>:<>

$MORPH$ = $CleanupOrthOldLv2$ || $MORPH$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryLv2$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundary$


% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexLv2$ || $MORPH$


% Swiss spelling

$MORPH$ = $MORPH$ | ($NoOrthOldFilterLv2$ || $MORPH$ || $OrthCH$) <CH>:<>


% capitalisation

$MORPH$ = $MORPH$ | ($MORPH$ || $OrthCap$) <CAP>:<>


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% the resulting automaton

$MORPH$
