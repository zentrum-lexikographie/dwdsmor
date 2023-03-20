% markers.fst
% Version 5.1
% Andreas Nolda 2023-03-20

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid


% replace verb stem-final schwa with <e>

ALPHABET = [#entry-type# #char# #category# #stem-type# #stem-subtype# #origin# \
            #inflection# #auxiliary# <Abbr><FB><VPART><ge>] \
           e:<e>

$SchwaTrigger$ = e <=> <e> ([lr] <V> .* <VVReg-el/er>)

$SurfaceTriggers$ = $SchwaTrigger$


% replace <FB> and <VPART> with <~> and <#>, respectively, on analysis level

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #wf-process# #wf-means#] \
           <\~>:<FB> \
           <#>:<VPART>

$BoundaryAnalysis$ = .*


% process <ge> marker

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL><VPART><^imp><^zz><zu>]

$MarkerGe$ = $C$* | \
             $C$* <ge>:<> {<>}:{ge} $C$* <^pp>:<> $C$* | \
             $C$* <ge>:<> $C$* | \
             $C$* $C$* <^pp>:<> $C$*


% process <zu> marker

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL><VPART><^imp>]

$C$ = $C$ | <zu>:<>

$MarkerZu$ = $C$* | \
             $C$* <VPART> {<>}:{zu} $C$* <^zz>:<> $C$*


% process <^imp> marker

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL>]

$MarkerImp$ = [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* | \
              [<Prefix><Stem>] ($C$* [<Prefix><Stem>])* $C$* <^imp>:<> $C$*

$MarkerImpVPart$ = [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* | \
                   [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* <^imp>:<> $C$*


$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# <UL>]

$Boundary$ = (([<Stem><VPART>]:<CB> | [<Prefix><Suffix>]:<FB>) $C$*)+
