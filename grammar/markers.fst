% markers.fst
% Version 4.0
% Andreas Nolda 2023-01-16

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

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# \
       <UL>]

$IMP$ = <Stem> ($C$* [<Stem><VPART>])* $C$* | \
        <Stem> ($C$* <Stem>)* $C$* <^imp>:<> $C$*

$IMPVPART$ = <Stem> ($C$* [<Stem><VPART>])* $C$* | \
             <Stem> ($C$* [<Stem><VPART>])* $C$* <^imp>:<> $C$*

$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# <UL>]

$BREAK$ = ([<Stem><VPART>]:<CB> $C$*)+
