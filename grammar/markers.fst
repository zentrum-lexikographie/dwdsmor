% markers.fst
% Version 4.1
% Andreas Nolda 2023-01-17

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

$IMP$ = [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* | \
        [<Prefix><Stem>] ($C$* [<Prefix><Stem>])* $C$* <^imp>:<> $C$*

$IMPVPART$ = [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* | \
             [<Prefix><Stem>] ($C$* [<Prefix><Stem><VPART>])* $C$* <^imp>:<> $C$*

$C$ = [#char# #phon-trigger# #ss-trigger# #surface-trigger# <UL>]

$BREAK$ = ([<Prefix><Stem><VPART>]:<CB> $C$*)+
