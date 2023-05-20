% dwdsmor-root.fst
% Version 6.1
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

$Pref-un$ = <Prefix> {}:{un}

$Part-ab$       = <Prefix> {}:{ab}
$Part-an$       = <Prefix> {}:{an}
$Part-auf$      = <Prefix> {}:{auf}
$Part-aus$      = <Prefix> {}:{aus}
$Part-bei$      = <Prefix> {}:{bei}
$Part-durch$    = <Prefix> {}:{durch}
$Part-ein$      = <Prefix> {}:{ein}
$Part-gegen$    = <Prefix> {}:{gegen}
$Part-hinter$   = <Prefix> {}:{hinter}
$Part-los$      = <Prefix> {}:{los}
$Part-mit$      = <Prefix> {}:{mit}
$Part-nach$     = <Prefix> {}:{nach}
$Part-ueber$    = <Prefix> {}:{über}
$Part-um$       = <Prefix> {}:{um}
$Part-unter$    = <Prefix> {}:{unter}
$Part-vor$      = <Prefix> {}:{vor}
$Part-weg$      = <Prefix> {}:{weg}
$Part-zu$       = <Prefix> {}:{zu}
$Part-zurueck$  = <Prefix> {}:{zurück}
$Part-zwischen$ = <Prefix> {}:{zwischen}

$Suff-er$   = <Suffix> {}:{er}   <NN> <base> <native> <>:<NMasc_s_0>
$Suff-chen$ = <Suffix> {}:{chen} <NN> <base> <native> <>:<NNeut_s_x>
$Suff-lein$ = <Suffix> {}:{lein} <NN> <base> <native> <>:<NNeut_s_x>

% processes and means

$Comp-concat$ = <COMP>:<> <concat>:<>
$Comp-hyph$   = <COMP>:<> <hyph>:<>

$DerPref-un$ = <DER>:<> <pref(un)>:<>

$DerPart-ab$       = <DER>:<> <part(ab)>:<>
$DerPart-an$       = <DER>:<> <part(an)>:<>
$DerPart-auf$      = <DER>:<> <part(auf)>:<>
$DerPart-aus$      = <DER>:<> <part(aus)>:<>
$DerPart-bei$      = <DER>:<> <part(bei)>:<>
$DerPart-durch$    = <DER>:<> <part(durch)>:<>
$DerPart-ein$      = <DER>:<> <part(ein)>:<>
$DerPart-gegen$    = <DER>:<> <part(gegen)>:<>
$DerPart-hinter$   = <DER>:<> <part(hinter)>:<>
$DerPart-los$      = <DER>:<> <part(los)>:<>
$DerPart-mit$      = <DER>:<> <part(mit)>:<>
$DerPart-nach$     = <DER>:<> <part(nach)>:<>
$DerPart-ueber$    = <DER>:<> <part(ueber)>:<>
$DerPart-um$       = <DER>:<> <part(um)>:<>
$DerPart-unter$    = <DER>:<> <part(unter)>:<>
$DerPart-vor$      = <DER>:<> <part(vor)>:<>
$DerPart-weg$      = <DER>:<> <part(weg)>:<>
$DerPart-zu$       = <DER>:<> <part(zu)>:<>
$DerPart-zurueck$  = <DER>:<> <part(zurueck)>:<>
$DerPart-zwischen$ = <DER>:<> <part(zwischen)>:<>

$DerSuff-er$   = <DER>:<> <suff(er)>:<>
$DerSuff-chen$ = <DER>:<> <suff(chen)>:<>
$DerSuff-lein$ = <DER>:<> <suff(lein)>:<>

$DC$ = <>:<^DC>
$UC$ = <>:<^UC>

% derived base stems

$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStems$ = $UC$ $Pref-un$           <>:<DB> $DC$ $BaseStems$ $DerPref-un$       | \
                      $Pref-un$           <>:<DB>      $BaseStems$ $DerPref-un$       | \
                      $Part-ab$           <>:<VB>      $BaseStems$ $DerPart-ab$       | \
                      $Part-an$           <>:<VB>      $BaseStems$ $DerPart-an$       | \
                      $Part-auf$          <>:<VB>      $BaseStems$ $DerPart-auf$      | \
                      $Part-aus$          <>:<VB>      $BaseStems$ $DerPart-aus$      | \
                      $Part-bei$          <>:<VB>      $BaseStems$ $DerPart-bei$      | \
                      $Part-durch$        <>:<VB>      $BaseStems$ $DerPart-durch$    | \
                      $Part-ein$          <>:<VB>      $BaseStems$ $DerPart-ein$      | \
                      $Part-gegen$        <>:<VB>      $BaseStems$ $DerPart-gegen$    | \
                      $Part-hinter$       <>:<VB>      $BaseStems$ $DerPart-hinter$   | \
                      $Part-los$          <>:<VB>      $BaseStems$ $DerPart-los$      | \
                      $Part-mit$          <>:<VB>      $BaseStems$ $DerPart-mit$      | \
                      $Part-nach$         <>:<VB>      $BaseStems$ $DerPart-nach$     | \
                      $Part-ueber$        <>:<VB>      $BaseStems$ $DerPart-ueber$    | \
                      $Part-um$           <>:<VB>      $BaseStems$ $DerPart-um$       | \
                      $Part-unter$        <>:<VB>      $BaseStems$ $DerPart-unter$    | \
                      $Part-vor$          <>:<VB>      $BaseStems$ $DerPart-vor$      | \
                      $Part-weg$          <>:<VB>      $BaseStems$ $DerPart-weg$      | \
                      $Part-zu$           <>:<VB>      $BaseStems$ $DerPart-zu$       | \
                      $Part-zurueck$      <>:<VB>      $BaseStems$ $DerPart-zurueck$  | \
                      $Part-zwischen$     <>:<VB>      $BaseStems$ $DerPart-zwischen$ | \
                      $DerStemsSuff-er$   <>:<DB>      $Suff-er$   $DerSuff-er$       | \
                      $DerStemsSuff-chen$ <>:<DB>      $Suff-chen$ $DerSuff-chen$     | \
                      $DerStemsSuff-lein$ <>:<DB>      $Suff-lein$ $DerSuff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$       <>:<DB> $DC$ $CompStems$ $DerPref-un$      | \
                      $Pref-un$       <>:<DB>      $CompStems$ $DerPref-un$      | \
                      $Part-ab$       <>:<VB>      $CompStems$ $DerPart-ab$      | \
                      $Part-an$       <>:<VB>      $CompStems$ $DerPart-an$      | \
                      $Part-auf$      <>:<VB>      $CompStems$ $DerPart-auf$     | \
                      $Part-aus$      <>:<VB>      $CompStems$ $DerPart-aus$     | \
                      $Part-bei$      <>:<VB>      $CompStems$ $DerPart-bei$     | \
                      $Part-durch$    <>:<VB>      $CompStems$ $DerPart-durch$   | \
                      $Part-ein$      <>:<VB>      $CompStems$ $DerPart-ein$     | \
                      $Part-gegen$    <>:<VB>      $CompStems$ $DerPart-gegen$   | \
                      $Part-hinter$   <>:<VB>      $CompStems$ $DerPart-hinter$  | \
                      $Part-los$      <>:<VB>      $CompStems$ $DerPart-los$     | \
                      $Part-mit$      <>:<VB>      $CompStems$ $DerPart-mit$     | \
                      $Part-nach$     <>:<VB>      $CompStems$ $DerPart-nach$    | \
                      $Part-ueber$    <>:<VB>      $CompStems$ $DerPart-ueber$   | \
                      $Part-um$       <>:<VB>      $CompStems$ $DerPart-um$      | \
                      $Part-unter$    <>:<VB>      $CompStems$ $DerPart-unter$   | \
                      $Part-vor$      <>:<VB>      $CompStems$ $DerPart-vor$     | \
                      $Part-weg$      <>:<VB>      $CompStems$ $DerPart-weg$     | \
                      $Part-zu$       <>:<VB>      $CompStems$ $DerPart-zu$      | \
                      $Part-zurueck$  <>:<VB>      $CompStems$ $DerPart-zurueck$ | \
                      $Part-zwischen$ <>:<VB>      $CompStems$ $DerPart-zwischen$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ = $CompStems$ \
         (<HB><CB> $CompStems$ $Comp-hyph$ | <CB> $DC$ $CompStems$ $Comp-concat$)* \
         (<HB><CB> $BaseStems$ $Comp-hyph$ | <CB> $DC$ $BaseStems$ $Comp-concat$) || $CompFilter$

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

$MORPH$ = <>:<WB> $MORPH$ <>:<WB> || $PHON$


% old spelling

$MORPH$ = $MORPH$ | ($MORPH$ || $OrthOld$) <OLDORTH>:<>

$MORPH$ = $CleanupOrthOldLv2$ || $MORPH$


% morpheme-boundary markers

$MORPH$ = $MarkerBoundaryRootLv2$ || $MORPH$

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
