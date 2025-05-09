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

$DerBaseStems$ = $Prev-ab$       <>:<VB> $BaseStems$ $DerPrev-ab$       | \
                 $Prev-an$       <>:<VB> $BaseStems$ $DerPrev-an$       | \
                 $Prev-auf$      <>:<VB> $BaseStems$ $DerPrev-auf$      | \
                 $Prev-aus$      <>:<VB> $BaseStems$ $DerPrev-aus$      | \
                 $Prev-bei$      <>:<VB> $BaseStems$ $DerPrev-bei$      | \
                 $Prev-durch$    <>:<VB> $BaseStems$ $DerPrev-durch$    | \
                 $Prev-ein$      <>:<VB> $BaseStems$ $DerPrev-ein$      | \
                 $Prev-fort$     <>:<VB> $BaseStems$ $DerPrev-fort$     | \
                 $Prev-gegen$    <>:<VB> $BaseStems$ $DerPrev-gegen$    | \
                 $Prev-heim$     <>:<VB> $BaseStems$ $DerPrev-heim$     | \
                 $Prev-her$      <>:<VB> $BaseStems$ $DerPrev-her$      | \
                 $Prev-hin$      <>:<VB> $BaseStems$ $DerPrev-hin$      | \
                 $Prev-hinter$   <>:<VB> $BaseStems$ $DerPrev-hinter$   | \
                 $Prev-los$      <>:<VB> $BaseStems$ $DerPrev-los$      | \
                 $Prev-mit$      <>:<VB> $BaseStems$ $DerPrev-mit$      | \
                 $Prev-nach$     <>:<VB> $BaseStems$ $DerPrev-nach$     | \
                 $Prev-ueber$    <>:<VB> $BaseStems$ $DerPrev-ueber$    | \
                 $Prev-um$       <>:<VB> $BaseStems$ $DerPrev-um$       | \
                 $Prev-unter$    <>:<VB> $BaseStems$ $DerPrev-unter$    | \
                 $Prev-vor$      <>:<VB> $BaseStems$ $DerPrev-vor$      | \
                 $Prev-weg$      <>:<VB> $BaseStems$ $DerPrev-weg$      | \
                 $Prev-wieder$   <>:<VB> $BaseStems$ $DerPrev-wieder$   | \
                 $Prev-zu$       <>:<VB> $BaseStems$ $DerPrev-zu$       | \
                 $Prev-zurueck$  <>:<VB> $BaseStems$ $DerPrev-zurueck$  | \
                 $Prev-zwischen$ <>:<VB> $BaseStems$ $DerPrev-zwischen$ || $DerFilter$

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

$ConvBaseStemsVPartPres$ = $BaseStemsVPartPres$   <ADJ> <base> <native> <>:<AdjPosAttr> $ConvPart$     % cf. Duden-Grammatik (2016: § 481, § 508, § 829)
$ConvBaseStemsVPartPerf$ = $BaseStemsVPartPerf-t$ <ADJ> <base> <native> <>:<AdjPos>     $ConvPart$ | \ % cf. Duden-Grammatik (2016: § 508)
                           $BaseStemsVPartPerf-n$ <ADJ> <base> <native> <>:<AdjPos-en>  $ConvPart$ | \ % cf. Duden-Grammatik (2016: § 508)
                           $BaseStemsVPartPerf-d$ <ADJ> <base> <native> <>:<AdjPosPred> $ConvPart$

$ConvBaseStems$ = $ConvBaseStemsVPartPres$ | \
                  $ConvBaseStemsVPartPerf$ || $ConvFilter$

$BaseStems$ = $BaseStems$ | $ConvBaseStems$

% derived base stems with affixes

$DerStemsSuff-e$    = $DerStems$ || $DerStemFilterSuff-e$
$DerStemsSuff-er$   = $DerStems$ || $DerStemFilterSuff-er$
$DerStemsSuff-chen$ = $DerStems$ || $DerStemFilterSuff-chen$
$DerStemsSuff-lein$ = $DerStems$ || $DerStemFilterSuff-lein$

$DerBaseStems$ = $UC$ $Pref-un$           <>:<DB> $DC$ $BaseStems$ $DerPref-un$       | \
                      $Pref-un$           <>:<DB>      $BaseStems$ $DerPref-un$       | \
                      $DerStemsSuff-e$    <>:<DB>      $Suff-e$    $DerSuff-e$        | \
                      $DerStemsSuff-er$   <>:<DB>      $Suff-er$   $DerSuff-er$       | \
                      $DerStemsSuff-chen$ <>:<DB>      $Suff-chen$ $DerSuff-chen$     | \
                      $DerStemsSuff-lein$ <>:<DB>      $Suff-lein$ $DerSuff-lein$ || $DerFilter$

$BaseStems$ = $BaseStems$ | $DerBaseStems$

$BASE$ = $BaseStems$

% derived compounding stems

$DerCompStems$ = $UC$ $Pref-un$       <>:<DB> $DC$ $CompStems$ $DerPref-un$      | \
                      $Pref-un$       <>:<DB>      $CompStems$ $DerPref-un$      | \
                      $Prev-ab$       <>:<VB>      $CompStems$ $DerPrev-ab$      | \
                      $Prev-an$       <>:<VB>      $CompStems$ $DerPrev-an$      | \
                      $Prev-auf$      <>:<VB>      $CompStems$ $DerPrev-auf$     | \
                      $Prev-aus$      <>:<VB>      $CompStems$ $DerPrev-aus$     | \
                      $Prev-bei$      <>:<VB>      $CompStems$ $DerPrev-bei$     | \
                      $Prev-durch$    <>:<VB>      $CompStems$ $DerPrev-durch$   | \
                      $Prev-ein$      <>:<VB>      $CompStems$ $DerPrev-ein$     | \
                      $Prev-fort$     <>:<VB>      $CompStems$ $DerPrev-fort$    | \
                      $Prev-gegen$    <>:<VB>      $CompStems$ $DerPrev-gegen$   | \
                      $Prev-heim$     <>:<VB>      $CompStems$ $DerPrev-heim$    | \
                      $Prev-her$      <>:<VB>      $CompStems$ $DerPrev-her$     | \
                      $Prev-hin$      <>:<VB>      $CompStems$ $DerPrev-hin$     | \
                      $Prev-hinter$   <>:<VB>      $CompStems$ $DerPrev-hinter$  | \
                      $Prev-los$      <>:<VB>      $CompStems$ $DerPrev-los$     | \
                      $Prev-mit$      <>:<VB>      $CompStems$ $DerPrev-mit$     | \
                      $Prev-nach$     <>:<VB>      $CompStems$ $DerPrev-nach$    | \
                      $Prev-ueber$    <>:<VB>      $CompStems$ $DerPrev-ueber$   | \
                      $Prev-um$       <>:<VB>      $CompStems$ $DerPrev-um$      | \
                      $Prev-unter$    <>:<VB>      $CompStems$ $DerPrev-unter$   | \
                      $Prev-vor$      <>:<VB>      $CompStems$ $DerPrev-vor$     | \
                      $Prev-weg$      <>:<VB>      $CompStems$ $DerPrev-weg$     | \
                      $Prev-wieder$   <>:<VB>      $CompStems$ $DerPrev-wieder$  | \
                      $Prev-zu$       <>:<VB>      $CompStems$ $DerPrev-zu$      | \
                      $Prev-zurueck$  <>:<VB>      $CompStems$ $DerPrev-zurueck$ | \
                      $Prev-zwischen$ <>:<VB>      $CompStems$ $DerPrev-zwischen$ || $DerFilter$

$CompStems$ = $CompStems$ | $DerCompStems$

% compounds

$COMP$ =           $O$? $CompStems$ \
         (<HB><CB> $O$? $CompStems$ $Comp-hyph$ | <CB> $DC$ $CompStems$ $Comp-concat$)* \
         (<HB><CB>      $BaseStems$ $Comp-hyph$ | <CB> $DC$ $BaseStems$ $Comp-concat$) || $CompFilter$

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

$MORPH$ = $MORPH$ | ($SepPrev1RootLv2$ || $MORPH$ || $SepPrev1$) <SEP>:<> | \
                    ($SepPrev2RootLv2$ || $MORPH$ || $SepPrev2$) <SEP>:<>


% morpheme truncation

$MORPH$ = $MORPH$ | ($TruncInitialLv2$ || $MORPH$ || $TruncInitial$) <TRUNC>:<> | \
                    ($TruncFinalLv2$   || $MORPH$ || $TruncFinal$)   <TRUNC>:<>


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
