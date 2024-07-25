% markers.fst
% Version 8.0
% Andreas Nolda 2024-07-25

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid


% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #category# #stem-type# #suff# #origin# \
            #inflection# #auxiliary# <Abbr><SB><VB><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* <VVReg-el-er>)

$SurfaceTriggers$ = $SchwaTrigger$


% process <ge> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #ss-trigger# \
       #boundary-trigger# <UL><^imp><^zz><zu>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge<PB>} $C$* <^pp>:<> $C$* | \
             $C$* <ge>:<>               $C$* | \
             $C$*                       $C$* <^pp>:<> $C$*


% process <zu> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #ss-trigger# \
       #boundary-trigger# <UL><^imp>]

$C$ = $C$-[<VB>] | <zu>:<>

$MarkerZu$ = (($C$* <VB>)? $C$* <VB>)?             $C$* | \
              ($C$* <VB>)? $C$* <VB> {<>}:{zu<PB>} $C$* <^zz>:<> $C$*


% process <^imp> marker

$C$ = [#char# #surface-trigger# #phon-trigger# #orth-trigger# #ss-trigger# \
       #boundary-trigger# <UL>]

$C$ = $C$-[<VB>]

% exclude imperative forms of particle verbs, which do not occur as a single token
$MarkerImp$ =                           $C$* <^imp>:<> $C$* | \
              (($C$* <VB>)? $C$* <VB>)? $C$*

% include imperative forms of particle verbs for paradigm generation
$MarkerImpVB$ = (($C$* <VB>)? $C$* <VB>)? $C$* <^imp>:<> $C$* | \
                (($C$* <VB>)? $C$* <VB>)?                $C$*


% process morpheme-boundary triggers

ALPHABET = [#char# #boundary-trigger#]

$MarkerWB$ = <WB>:<Stem> .* <WB>:<>

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info# <TRUNC>]

$MarkerBoundaryLv2$ = (.                   | \
                            <#>:[<CB><VB>] | \
                       {<\=>\-}:{<HB>}     | \
                           <\~>:[<DB><PB><SB>])*

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
