% module_markers.fst
% Version 10.1
% Andreas Nolda 2025-09-12

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #boundary-trigger# #pos# #subcat# #stem-type# \
            #suff# #origin# #inflection# #auxiliary# <Abbr><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* [<VWeak-el-er><VInf-el-er><VPartPres-el-er><VPres-el-er><VImp-el-er>])

$SurfaceTriggers$ = $SchwaTrigger$


% process <ins(ge)> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp><rm|Part><ins(zu)>]

$CMinusCBVB$ = $C$-[<CB><VB>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge<PB>} $CMinusCBVB$* <ins(ge)>:<> $C$* | \
             $C$* <ge>:<>               $CMinusCBVB$*                   | \
             $C$*                       $CMinusCBVB$* <ins(ge)>:<> $C$*


% process <ins(zu)> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp><rm|Part>]

$CMinusCBVB$ = $C$-[<CB><VB>]

$MarkerZu$ = $C$* | \
             $C$* [<CB><VB>] {<>}:{zu<PB>} $CMinusCBVB$* <ins(zu)>:<> $C$*


% process <rm|Part> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp>]

% exclude clausal present participles with "zu"
$MarkerPart$ = $C$*

% include clausal present participles with "zu" as conversion bases
$MarkerPartConv$ = $C$* <rm|Part>:<> $C$* | \
                   $C$*


% process <rm|Imp> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger#]

$CMinusVB$ = $C$-[<VB>]

% exclude imperative forms of verbs with preverbs, which do not occur as a single token
$MarkerImp$ =                                         $CMinusVB$* <rm|Imp>:<> $CMinusVB$* | \
              (($CMinusVB$* <VB>)? $CMinusVB$* <VB>)? $CMinusVB$*

% include imperative forms of verbs with preverbs for paradigm generation
$MarkerImpVB$ = (($CMinusVB$* <VB>)? $CMinusVB$* <VB>)? $CMinusVB$* <rm|Imp>:<> $CMinusVB$* | \
                (($CMinusVB$* <VB>)? $CMinusVB$* <VB>)?                         $CMinusVB$*


% process morpheme-boundary triggers

ALPHABET = [#char# #boundary-trigger#]

$MarkerWB$ = <WB>:<Stem> .* <WB>:<>

ALPHABET = [#char# #index# #feature# #info#]

$MarkerBoundaryLv2$ = (.         | \
                        <|>:<VB> | \
                        <#>:<CB> | \
                       <\=>:<IB> | \
                        <->:<DB> | \
                       <\~>:[<PB><SB>])*

ALPHABET = [#char# #index# #wf# #feature# #info#] \
           <>:[<DB><IB>]

$MarkerBoundaryRootLv2$ = (.         | \
                            <+>:<CB> | \
                            <|>:<VB> | \
                           <\~>:[<PB><SB>])*

ALPHABET = [#char#]

$MarkerBoundary$ = (.               | \
                                <VB>:<|>  | \
                                <CB>:<#>  | \
                                <IB>:<\=> | \
                                <DB>:<->  | \
                          [<PB><SB>]:<\~>)*

ALPHABET = [#char#] \
           [<CB><VB><DB><IB><PB><SB>]:<>

$MarkerBoundaryEmpty$ = .*
