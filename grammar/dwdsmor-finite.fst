% dwdsmor-finite.fst
% Version 9.0
% Andreas Nolda 2023-05-17

#include "symbols.fst"
#include "num-finite.fst"
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

$Suff-er$   = <Suffix> er   <NN> <base> <native> <>:<NMasc_s_0>
$Suff-chen$ = <Suffix> chen <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> lein <NN> <base> <native> <>:<NNeut_s_x>

% means

$DC$ = <^DC>
$UC$ = <^UC>

% derived base stems

$DerStems-er$   = $DerStems$ || $DerStemFilter-er$
$DerStems-chen$ = $DerStems$ || $DerStemFilter-chen$
$DerStems-lein$ = $DerStems$ || $DerStemFilter-lein$

$DerBaseStems$ = $UC$ $Pref-un$       <DB> $DC$ $BaseStems$ | \
                      $Pref-un$       <DB>      $BaseStems$ | \
                      $DerStems-er$   <DB>      $Suff-er$   | \
                      $DerStems-chen$ <DB>      $Suff-chen$ | \
                      $DerStems-lein$ <DB>      $Suff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$ <DB> $DC$ $CompStems$ | \
                      $Pref-un$ <DB>      $CompStems$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = $CompStems$ (<HB><CB> $BaseStems$ | <CB> $DC$ $BaseStems$) || $CompFilter$

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
