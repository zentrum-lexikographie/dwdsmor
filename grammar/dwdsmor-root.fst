% dwdsmor-root.fst
% Version 5.1
% Andreas Nolda 2023-03-29

#include "symbols.fst"
#include "num.fst"
#include "stemtype.fst"
#include "wf.fst"
#include "infl.fst"
#include "markers.fst"
#include "phon.fst"
#include "punct.fst"
#include "cap.fst"
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

$Suff-chen$ = <Suffix> {}:{chen} <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> {}:{lein} <NN> <base> <native> <>:<NNeut_s_x>

% processes and means

$Comp-concat$ = <COMP>:<> <concat>:<>
$Comp-hyph$   = <COMP>:<> <hyph>:<>

$DerPref-un$   = <DER>:<> <pref(un)>:<>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<>

$DC$ = <>:<^DC>
$UC$ = <>:<^UC>

% derived base stems

$DerStemsChen$ = $DerStems$ || $DerStemChenFilter$
$DerStemsLein$ = $DerStems$ || $DerStemLeinFilter$

$DerBaseStems$ = $UC$ $Pref-un$      <DB> $DC$ $BaseStems$ $DerPref-un$   | \
                      $Pref-un$      <DB>      $BaseStems$ $DerPref-un$   | \
                      $DerStemsChen$ <DB>      $Suff-chen$ $DerSuff-chen$ | \
                      $DerStemsLein$ <DB>      $Suff-lein$ $DerSuff-lein$ || $DerFilter$

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


% cleanup of orthography-related symbols

$MORPH$ = $CleanupOrthAnalysis$ || $MORPH$

% cleanup of lemma and paradigm indices

$MORPH$ = $CleanupIndexAnalysis$ || $MORPH$


% capitalisation

$MORPH$ = $MORPH$ | <CAP>:<> ($MORPH$ || $CAP$)


% the resulting automaton

$MORPH$
