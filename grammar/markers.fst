% markers.fst
% Version 2.0
% Andreas Nolda 2022-11-17

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# #morpheme_boundary_marker# \
       <UL><VPART><Low#><Up#><Fix#><^imp><^zz><zu>]

$GE$ = $C$* | \
       $C$* <ge>:<> {<>}:{ge} $C$* <^pp>:<> $C$* | \
       $C$* <ge>:<> $C$* | \
       $C$* $C$* <^pp>:<> $C$*

$C$ = [#entry-type# #char# #phon-trigger# #ss-trigger# #surface-trigger# #morpheme_boundary_marker# \
       <UL><VPART><Low#><Up#><Fix#><^imp>]

$C$ = $C$ | <zu>:<>

$ZU$ = $C$* | \
       $C$* <VPART> {<>}:{zu} $C$* <^zz>:<> $C$*

$C$ = [#char# #ss-trigger# #phon-trigger# #ss-trigger# #surface-trigger# #morpheme_boundary_marker# \
       <UL><Low#><Up#><Fix#>]

$IMP$ = <Stem>:<CB> ($C$* [<Stem><VPART>]:<CB>)* $C$* | \
        <Stem>:<CB> ($C$* <Stem>:<CB>)* $C$* <^imp>:<> $C$*

$IMPVPART$ = <Stem>:<CB> ($C$* [<Stem><VPART>]:<CB>)* $C$* | \
             <Stem>:<CB> ($C$* [<Stem><VPART>]:<CB>)* $C$* <^imp>:<> $C$*

$C$ = [#char# #ss-trigger# #surface-trigger# #morpheme_boundary_marker# \
       <UL><INS-E><FB><^Ax><^Px><^Gen><^Del><^pl>]

$UPLOW$ = <CB>:<>        $C$ ($C$ | <CB>)* <Fix#>:<> | \
          [<CB><>]:<^UC> $C$ ($C$ | <CB>)* <Up#>:<>  | \
          [<CB><>]:<CB>  $C$ ($C$ | <CB>)* <Low#>:<>
