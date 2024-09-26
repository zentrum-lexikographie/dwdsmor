% markers.fst
% Version 8.6
% Andreas Nolda 2024-09-26

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid


% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #boundary-trigger# #category# #stem-type# #suff# \
            #origin# #inflection# #auxiliary# <Abbr><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* [<VInf-el-er><VPPres-el-er><VPres-el-er><VImp-el-er><VWeak-el-er>])

$SurfaceTriggers$ = $SchwaTrigger$


% process <ins(ge)> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp><ins(zu)><zu>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge<PB>} $C$* <ins(ge)>:<> $C$* | \
             $C$* <ge>:<>               $C$*                   | \
             $C$*                       $C$* <ins(ge)>:<> $C$*


% process <ins(zu)> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger# \
       <rm|Imp>]

$C$ = $C$-[<VB>] | <zu>:<>

$MarkerZu$ = (($C$* <VB>)? $C$* <VB>)?             $C$* | \
              ($C$* <VB>)? $C$* <VB> {<>}:{zu<PB>} $C$* <ins(zu)>:<> $C$*


% process <rm|Imp> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #boundary-trigger#]

$C$ = $C$-[<VB>]

% exclude imperative forms of particle verbs, which do not occur as a single token
$MarkerImp$ =                           $C$* <rm|Imp>:<> $C$* | \
              (($C$* <VB>)? $C$* <VB>)? $C$*

% include imperative forms of particle verbs for paradigm generation
$MarkerImpVB$ = (($C$* <VB>)? $C$* <VB>)? $C$* <rm|Imp>:<> $C$* | \
                (($C$* <VB>)? $C$* <VB>)?                  $C$*


% process morpheme-boundary triggers

ALPHABET = [#char# #boundary-trigger#]

$MarkerWB$ = <WB>:<Stem> .* <WB>:<>

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info# <TRUNC>]

$MarkerBoundaryLv2$ = (.                   | \
                            <#>:[<CB><VB>] | \
                       {<\=>\-}:{<HB>}     | \
                            <->:<DB>       | \
                           <\~>:[<PB><SB>])*

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info# <TRUNC>] \
           <>:[<HB><DB>]

$MarkerBoundaryRootLv2$ = (.         | \
                            <+>:<CB> | \
                            <#>:<VB> | \
                           <\~>:[<PB><SB>])*

ALPHABET = [#char#] \
           [<CB><VB><DB><PB><SB>]:<>

$MarkerBoundary$ = (. | \
                    <HB>:\-)*

ALPHABET = [#char#]

$MarkerBoundaryMorph$ = (.                       | \
                             [<CB><VB>]:<#>      | \
                                 {<HB>}:{<\=>\-} | \
                                   <DB>:<->      | \
                             [<PB><SB>]:<\~>)*
