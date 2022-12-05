% markers.fst
% Version 3.0
% Andreas Nolda 2022-12-05

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL><VPART><^imp><^zz><zu>]

$GE$ = $C$* | \
       $C$* <ge>:<> {<>}:{ge} $C$* <^pp>:<> $C$* | \
       $C$* <ge>:<> $C$* | \
       $C$* $C$* <^pp>:<> $C$*

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL><VPART><^imp>]

$C$ = $C$ | <zu>:<>

$ZU$ = $C$* | \
       $C$* <VPART> {<>}:{zu} $C$* <^zz>:<> $C$*

$C$ = [#char# #ss-trigger# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL>]

$IMP$ = <Stem>:<CB> ($C$* [<Stem><VPART>]:<CB>)* $C$* | \
        <Stem>:<CB> ($C$* <Stem>:<CB>)* $C$* <^imp>:<> $C$*

$IMPVPART$ = <Stem>:<CB> ($C$* [<Stem><VPART>]:<CB>)* $C$* | \
             <Stem>:<CB> ($C$* [<Stem><VPART>]:<CB>)* $C$* <^imp>:<> $C$*
