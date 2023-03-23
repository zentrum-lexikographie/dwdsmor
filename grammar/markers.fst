% markers.fst
% Version 7.0
% Andreas Nolda 2023-03-23

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid


% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #category# #stem-type# #stem-subtype# #origin# \
            #inflection# #auxiliary# <Abbr><FB><VB><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* <VVReg-el/er>)

$SurfaceTriggers$ = $SchwaTrigger$


% process <ge> marker

$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# \
       <UL><^imp><^zz><zu>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge} $C$* <^pp>:<> $C$* | \
             $C$* <ge>:<> $C$* | \
             $C$* $C$* <^pp>:<> $C$*


% process <zu> marker

$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# \
       <UL><^imp>]

$C$ = $C$ | <zu>:<>

$MarkerZu$ = $C$* | \
             $C$* <VB> {<>}:{zu} $C$* <^zz>:<> $C$*


% process <^imp> marker

$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# \
       <UL>]

$C$ = $C$-[<VB>]

% exclude imperative forms of particle verbs, which do not occur as a single token
$MarkerImp$ =              $C$* <^imp>:<> $C$* | \
              ($C$* <VB>)? $C$*

% include imperative forms of particle verbs for paradigm generation
$MarkerImpVB$ = ($C$* <VB>)? $C$* <^imp>:<> $C$* | \
                ($C$* <VB>)?                $C$*


% process morpheme-boundary triggers

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info#]

$MarkerBoundaryAnalysis$ = (.                   | \
                                 <#>:[<CB><VB>] | \
                            {<\=>\-}:{<HB>}     | \
                                <\~>:[<DB><FB>])*

ALPHABET = [#char# #lemma-index# #paradigm-index#  #feature# #info# \
            #wf-process# #wf-means#] \
           <>:[<HB><DB>]

$MarkerBoundaryRootAnalysis$ = (.         | \
                                 <+>:<CB> | \
                                 <#>:<VB> | \
                                <\~>:<FB>)*

ALPHABET = [#char#] \
           [<WB><CB><VB><DB><FB>]:<>

$MarkerBoundary$ = (. | \
                    <HB>:\-)*
