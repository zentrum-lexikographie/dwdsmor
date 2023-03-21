% markers.fst
% Version 6.0
% Andreas Nolda 2023-03-21

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid


% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #category# #stem-type# #stem-subtype# #origin# \
            #inflection# #auxiliary# <Abbr><FB><VPART><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* <VVReg-el/er>)

$SurfaceTriggers$ = $SchwaTrigger$


% generate morpheme-boundary triggers from entry types

$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# <UL>]

$BoundaryTriggers$ = (([<Stem><VPART>]:<CB> | [<Prefix><Suffix>]:<DB>) $C$*)+


% process <ge> marker

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# \
       <UL><VPART><^imp><^zz><zu>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge} $C$* <^pp>:<> $C$* | \
             $C$* <ge>:<> $C$* | \
             $C$* $C$* <^pp>:<> $C$*


% process <zu> marker

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# \
       <UL><VPART><^imp>]

$C$ = $C$ | <zu>:<>

$MarkerZu$ = $C$* | \
             $C$* <VPART> {<>}:{zu} $C$* <^zz>:<> $C$*


% process <^imp> marker

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# #boundary-trigger# \
       <UL>]

$MarkerImp$ = [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* | \
              [<Prefix><Stem>] ($C$* [<Prefix><Stem>])* $C$* <^imp>:<> $C$*

$MarkerImpVPart$ = [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* | \
                   [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* <^imp>:<> $C$*


% process morpheme-boundary triggers

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# #info#] \
           <#>:[<CB><VPART>] \
           <\=>:<HB> \
           <\~>:[<DB><FB>]

$MarkerBoundaryAnalysis$ = .*

ALPHABET = [#char# #lemma-index# #paradigm-index# #wf-process# #wf-means# \
            #feature# #info#] \
           <+>:<CB> \
           <>:<DB> \
           <#>:<VPART> \
           <\~>:<FB>

$MarkerBoundaryRootAnalysis$ = .*
