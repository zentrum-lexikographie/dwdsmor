% markers.fst
% Version 9.0
% Andreas Nolda 2024-10-11

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid


% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #boundary-trigger# #category# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* [<VWeak-el-er><VInf-el-er><VPartPres-el-er><VPres-el-er><VImp-el-er>])

$SurfaceTriggers$ = $SchwaTrigger$


% process <ins(ge)> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp><rm|Part><ins(zu)>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge<PB>} $C$* <ins(ge)>:<> $C$* | \
             $C$* <ge>:<>               $C$*                   | \
             $C$*                       $C$* <ins(ge)>:<> $C$*


% process <ins(zu)> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp><rm|Part>]

$CMinusCB$ = $C$-[<CB>]
$CMinusVB$ = $C$-[<VB>]

$MarkerZu$ = ($CMinusCB$* <CB>)*                                $CMinusCB$* | \
            (($CMinusVB$* <VB>)? $CMinusVB$* <VB>)?             $CMinusVB$* | \
             ($CMinusCB$* <CB>)* $CMinusCB$* <CB> {<>}:{zu<PB>} $CMinusCB$* <ins(zu)>:<> $CMinusCB$* | \
             ($CMinusVB$* <VB>)? $CMinusVB$* <VB> {<>}:{zu<PB>} $CMinusVB$* <ins(zu)>:<> $CMinusVB$*


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

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info#]

$MarkerBoundaryLv2$ = (.               | \
                            <|>:<VB>   | \
                            <#>:<CB>   | \
                       {<\=>\-}:{<HB>} | \
                            <->:<DB>   | \
                           <\~>:[<PB><SB>])*

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info#] \
           <>:[<HB><DB>]

$MarkerBoundaryRootLv2$ = (.         | \
                            <+>:<CB> | \
                            <|>:<VB> | \
                           <\~>:[<PB><SB>])*

ALPHABET = [#char#] \
           [<CB><VB><DB><PB><SB>]:<>

$MarkerBoundary$ = (. | \
                    <HB>:\-)*

ALPHABET = [#char#]

$MarkerBoundaryMorph$ = (.                   | \
                               <VB>:<|>      | \
                               <CB>:<#>      | \
                             {<HB>}:{<\=>\-} | \
                               <DB>:<->      | \
                         [<PB><SB>]:<\~>)*
