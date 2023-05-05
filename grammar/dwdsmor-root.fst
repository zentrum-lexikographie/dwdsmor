% dwdsmor-root.fst
% Version 5.3
% Andreas Nolda 2023-05-05

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


% cleanup of level-specific symbols

$LEX$ = $CleanupInflAnalysis$ || $LEX$

$LEX$ = $LEX$ || $CleanupIndex$


% surface triggers

$LEX$ = $LEX$ || $SurfaceTriggers$


% stem types

$BaseStems$ = $LEX$ || $BaseStemFilter$
$DerStems$  = $LEX$ || $DerStemFilter$
$CompStems$ = $LEX$ || $CompStemFilter$


% word formation

% affixes

$Pref-un$   = <Prefix> {}:{un}

$Suff-er$   = <Suffix> {}:{er} <NN> <base> <native> <>:<NMasc_s_0>
$Suff-chen$ = <Suffix> {}:{chen} <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> {}:{lein} <NN> <base> <native> <>:<NNeut_s_x>

% processes and means

$Comp-concat$ = <COMP>:<> <concat>:<>
$Comp-hyph$   = <COMP>:<> <hyph>:<>

$DerPref-un$   = <DER>:<> <pref(un)>:<>

$DerSuff-er$   = <DER>:<> <suff(er)>:<>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<>

$DC$ = <>:<^DC>
$UC$ = <>:<^UC>

% derived base stems

$DerStems-er$   = $DerStems$ || $DerStemFilter-er$
$DerStems-chen$ = $DerStems$ || $DerStemFilter-chen$
$DerStems-lein$ = $DerStems$ || $DerStemFilter-lein$

$DerBaseStems$ = $UC$ $Pref-un$       <DB> $DC$ $BaseStems$ $DerPref-un$   | \
                      $Pref-un$       <DB>      $BaseStems$ $DerPref-un$   | \
                      $DerStems-er$   <DB>      $Suff-er$   $DerSuff-er$   | \
                      $DerStems-chen$ <DB>      $Suff-chen$ $DerSuff-chen$ | \
                      $DerStems-lein$ <DB>      $Suff-lein$ $DerSuff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$ <DB> $DC$ $CompStems$ $DerPref-un$ | \
                      $Pref-un$ <DB>      $CompStems$ $DerPref-un$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = $CompStems$ \
         (<HB><CB> $CompStems$ $Comp-hyph$ | <CB> $DC$ $CompStems$ $Comp-concat$)* \
         (<HB><CB> $BaseStems$ $Comp-hyph$ | <CB> $DC$ $BaseStems$ $Comp-concat$) || $CompFilter$

$LEX$ = $BASE$ | $COMP$


% cleanup of word-formation-related symbols

$LEX$ = $CleanupWFAnalysis$ || $LEX$

$LEX$ = $LEX$ || $CleanupWF$


% inflection

$MORPH$ = $LEX$ $INFL$ || $InflFilter$


% inflection markers

$MORPH$ = $MORPH$ || $MarkerGe$

$MORPH$ = $MORPH$ || $MarkerZu$

$MORPH$ = $MORPH$ || $MarkerImp$


% (morpho)phonology

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% punctuation

$MORPH$ = $MORPH$ | $PUNCT$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryRootAnalysis$ || $MORPH$

$MORPH$ = $MORPH$ || $MarkerBoundary$


% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexAnalysis$ || $MORPH$


% orthography

$MORPH$ = $OrthOldAnalysis$ || $MORPH$

$MORPH$ = $MORPH$ | ($MORPH$ || $OrthCap$) <CAP>:<>


% the resulting automaton

$MORPH$
