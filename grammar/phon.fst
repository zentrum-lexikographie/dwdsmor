% phon.fst
% Version 1.0
% Andreas Nolda 2022-08-19

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

% allomorphs
% i<n>loyal     -> illoyal
% i<n>materiell -> immateriell
% trink+<er>ei  -> Trinkerei
% gaukel+<er>ei -> Gaukelei

ALPHABET = [#char# #phon-trigger# #ss-trigger# #morpheme_boundary_marker# <e><UL>] \
           <n>:[nlmrn] <d>:[dfgklnpst] <~n>:[<>n]

$R1$ = (<n>  <=> n (<CB>? [ac-knoqs-zäöüßAC-KNOQS-ZÄÖÜ])) & \
       (<n>  <=> l (<CB>? [Ll])) & \
       (<n>  <=> m (<CB>? [BbMmPp])) & \
       (<n>  <=> [rn] (<CB>? [Rr])) & \
       (<d>  <=> d (<CB>? [a-ehijmoqru-xäöüßA-EHIJMOQRU-XÄÖÜ])) & \
       (<d>  <=> f (<CB>? [Ff])) & \
       (<d>  <=> g (<CB>? [Gg])) & \
       (<d>  <=> k (<CB>? [Kk])) & \
       (<d>  <=> l (<CB>? [Ll])) & \
       (<d>  <=> n (<CB>? [Nn])) & \
       (<d>  <=> p (<CB>? [Pp])) & \
       (<d>  <=> s (<CB>? [Ss])) & \
       (<d>  <=> t (<CB>? [Tt])) & \
       (<~n> <=> <> (<CB>? [bcdfghjklmnpqrstvwxyz])) & \
       (<~n> <=> n (<CB>? [AEIOUÄÖÜaeiouäöü]))


% haplology
% birst+st -> birst

ALPHABET = [#char# #phon-trigger# #ss-trigger# #morpheme_boundary_marker# <e><UL>] \
           [st]:<>

$R2$ = ((st<FB>) s <=> <> (t:.)) & ((st<FB>s:.) t <=> <>)


% umlaut
% Apfel$           -> Äpfel
% alter$e          -> ältere
% Saal$e           -> Säle
% Koog$e           -> Köge
% Schwabe<^Del>$in -> Schwäbin
% Tochter$         -> Töchter

ALPHABET = [#char# #phon-trigger# #ss-trigger# #morpheme_boundary_marker#] <e> \
           <UL>:<FB> [aouAOU]:[äöüÄÖÜ] [ao]:<>

$Cons$   = [bcdfghjklmnpqrstvwxyzß]
$ConsUp$ = [BCDFGHJKLMNPQRSTVWXYZ]

$LC$ = <CB> | <WB> | <^UC> | $Cons$ | $ConsUp$

$R3$ = ($LC$ [aouAOU] <=> [äöüÄÖÜ] ([aou]:.? $Cons$* <FB>? ([#ss-trigger#]|(e($Cons$|<^Del>)))? <UL>:<FB>)) & \
       (([aA]:[äÄ]) a <=> <> ($Cons$)) & \
       (([oO]:[öÖ]) o <=> <> ($Cons$))


% "ß"/"ss"-alternation
% Fluß~+es    -> Flusses
% Fuß+es      -> Fußes
% Zeugnis~+es -> Zeugnisses

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <SSalt><e> \
           <SS>:[<><SS>]


% Schuß<SS><FB><SS...> -> Schuß<FB><SS...>

$R4a$ = (ß) <SS> <=> <> (<FB> [#ss-trigger#])

$B$ = [#morpheme_boundary_marker#]* [<FB><INS-E>] [#morpheme_boundary_marker#]*

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <SSalt><e> \
           ß:s <SS>:[<>s]

$R4b$ = (ß <=> s (<FB>? [#ss-trigger#]:. $B$ [aeiou])) & \
        ((ß:s <FB>? | s) [#ss-trigger#] <=> s ($B$ [aeiou])) & \
        ((s) [#ss-trigger#] <=> <> ($B$ ($Cons$ | <WB>)))

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           <SSalt>:<>

$R4c$ = (ß <FB>?) <SSalt> <=> <>


% "e"-elision after "e"
% Bote+e   -> Bote
% leise$er -> leiser

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           e:<>

$R5$ = e <=> <> ($B$ e)


% optional e-elision with genitive
% Tisch+es    -> Tisches, Tischs
% Haus+es     -> Hauses
% Fluß~+es    -> Flusses
% Fuß+es      -> Fußes
% Zeugnis~+es -> Zeugnisses

$R6$ = ([bcdfghjklmnpqrtuvwy] <FB>? $B$) e => <> (s <^Gen>)


% "e"-elision before "'"
% hab+e's  -> hab's
% kauf+t's -> kauft's

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           e:<>

$R7$ = e <=> <> ('s)


% adjective-"el"/"er" "e"-elision
% dunkel<^Ax>+e -> dunkle
% teuer<^Ax>+e  -> teure

$R8$ = e <=> <> ([lr] <^Ax> $B$ e)


% optional pronoun-"er" "e"-elision
% unser<^Px>+en   -> unsren, unsern
% unserig<^Px>+en -> unsrigen

$R8a$ = (e => <> (r(ig)? <^Px> $B$? e)) | \
        ((er <^Px> $B$) e => <> ([mns]))


% verb-"el"/"er" "e"-elision
% sicher<^Vx>+en  -> sichern
% handel<^Vx>+en  -> handeln
% sicher<^Vx>+e   -> sichre, sichere
% handel<^Vx>+e   -> handle, ?handele
% sicher<^Vx>+est -> sicherst, *sichrest, ?sicherest
% handel<^Vx>+est -> handelst, *handlest, ?handelest
% rechn+ung       -> Rechnung

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           e:<>

$R9$ = (<e>[lr] $B$) e <=> <> (n | s?t)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           <e>:<>

$R9a$ = <e> => <> ([lr] $B$ [eui])

$R10$ = <e> <=> <> (n $B$ [eui])


% "s"-elimination
% ras&st  -> (du) rast
% feix&st -> (du) feixt
% birs+st -> (du) birst
% groß$st -> größt

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <e>:e s:<>

$R11$ = ([xsßz] $B$) s <=> <> (t)


% "e"-epenthesis
% regn&t       -> regnet
% find&st      -> findest
% bet&st       -> betest
% gelieb&t&st  -> geliebtest
% gewappn&t&st -> gewappnetst

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <INS-E>:<>

% gefeiert&ste -> gefeiertste
% gefeiert&ste -> gefeiertste

$R12$ = ([a-df-hj-z]e[rl]t) <INS-E> <=> <> (st)


ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <INS-E>:[e<>]

% gewappn&t&st -> gewappnetst

$R13$ = ((((c[hk])|[bdfgmp])n | [a-zäöüß]t) <INS-E> <=> e) & \
        ((<INS-E>:e[dt]) <INS-E> <=> <>)


ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <INS-E>:e

$R14$ = ([dt]m? | tw) <INS-E> <=> e


% consonant reduction in old orthography
% Schiff=fahrt  -> Schiffahrt, Schifffahrt
% Schiff=fracht -> Schifffracht
% voll=laufen   -> vollaufen, volllaufen
% Sperr=rad     -> Sperrad, Sperrrad

$B$ = [<CB><FB>]

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
     f:[<f><>] <OLDORTH>:<>

$Rf$ = (f f <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [fF] [aeiouäöü])) & \
       (f f <=> <x> ([#morpheme_boundary_marker#]* $B$ [fF] [aeiouäöü])) & \
       ((f:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           l:[<l><>] <OLDORTH>:<> <f>:f

$Rl$ = (l l <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [lL] [aeiouäöü])) & \
       (l l <=> <x> ([#morpheme_boundary_marker#]* $B$ [lL] [aeiouäöü])) & \
       ((l:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           m:[<m><>] <OLDORTH>:<> <l>:l

$Rm$ = (m m <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [mM] [aeiouäöü])) & \
       (m m <=> <x> ([#morpheme_boundary_marker#]* $B$ [mM] [aeiouäöü])) & \
       ((m:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           n:[<n><>] <OLDORTH>:<> <m>:m

$Rn$ = (n n <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [nN] [aeiouäöü])) & \
       (n n <=> <x> ([#morpheme_boundary_marker#]* $B$ [nN] [aeiouäöü])) & \
       ((n:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           r:[<r><>] <OLDORTH>:<> <n>:n

$Rr$ = (r r <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [rR] [aeiouäöü])) & \
       (r r <=> <x> ([#morpheme_boundary_marker#]* $B$ [rR] [aeiouäöü])) & \
       ((r:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           t:[<t><>] <OLDORTH>:<> <r>:r

$Rt$ = (t t <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [tT] [aeiouäöü])) & \
       (t t <=> <x> ([#morpheme_boundary_marker#]* $B$ [tT] [aeiouäöü])) & \
       ((t:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

$R15$ = ($Rf$ || $Rl$ || $Rm$) || ($Rn$ || $Rr$ || $Rt$)


% suffix substution for plural forms
% Virus<^pl>+en     -> Viren
% Museum<^pl>+en    -> Museen
% Examen<^pl>+ina   -> Examina
% Affrikata<^pl>+en -> Affrikaten
% Konto<^pl>+en     -> Konten

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           [uioe]:<> <t>:t

% substitute "-is"/"-us"/"-um"/"-on"/"-os"/"-en"

$R16$ = [uioe] <=> <> ([mns]:. <^pl>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           [mnsao]:<>

$R17$ = [mnsao] <=> <> <^pl>

% substitute "e"

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           e:<>

$R18$ = e <=> <> <^Del>


% marker deletion

ALPHABET = [#char# #morpheme_boundary_marker# <FB><CB><^UC>] \
           [<INS-E><WB><^Ax><^Px><^Gen><^Del><^pl>]:<> \
           <FB>:<\~>

$R19$ = .*


% lower-case conversion

ALPHABET = [#char# #morpheme_boundary_marker#] <^UC> \
           <CB>:<#> [A-ZÄÖÜ]:[a-zäöü]

$R20$ = <CB>:<#> [A-ZÄÖÜ] <=> [a-zäöü] [a-zäöüßáéíóú]


% upper-case conversion

ALPHABET = [#char# #morpheme_boundary_marker#]  \
           <^UC>:<> [a-zäöü]:[A-ZÄÖÜ]

$R21$ = ((<^UC>:<>) [a-zäöü] <=> [A-ZÄÖÜ]) & \
        !(.* <^UC>:<> .:[a-zäöü] .*)


% word-initial morpheme-boundary deletion

$R22$ = <#>:<>* <#>:<>* [#char#] [#char# #morpheme_boundary_marker#]*


% duplicate morpheme-boundary deletion

ALPHABET = [#char# #morpheme_boundary_marker#]

$R23$ = [#morpheme_boundary_marker#]:<> ^-> (__[#morpheme_boundary_marker#])


% composition of rules

$PHON$ = $R1$ || $R2$ || $R3$ || $R4a$ || $R4b$ || $R4c$ || $R5$ || $R6$ || $R7$ || $R8$ || $R8a$ || $R9$ || $R9a$ || $R10$ || $R11$ || $R12$ || $R13$ || $R14$ || $R15$ || $R16$ || $R17$ || $R18$ || $R19$ || $R20$ || $R21$ || $R22$ || $R23$
