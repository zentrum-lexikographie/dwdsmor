% phon.fst
% Version 1.3
% Andreas Nolda 2022-09-09

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

ALPHABET = [#char# #phon-trigger# #ss-trigger# #morpheme_boundary_marker#] <UL><e>

$Cons$ = [bcdfghjklmnpqrstvwxyzß]

$X$ = $Cons$* <FB>? ([#ss-trigger#] | (e ($Cons$ | <^Del>)))?

$LC$ = [#char#] | <WB> | <CB> | <^UC>

$RC$ = [#char#] | <WB>

$R3a$ = ({Au}:{Äu} | \
         {au}:{äu}) $X$ <UL>:<FB> ^-> $LC$__$RC$

$R3b$ = ({Aa}:Ä | \
         {aa}:ä | \
         {Oo}:Ö | \
         {oo}:ö) $X$ <UL>:<FB> ^-> $LC$__$RC$

$R3c$ = ([AOUaou]:[ÄÖÜäöü]) $X$ <UL>:<FB> ^-> $LC$__$RC$

$R3$ = $R3a$ || $R3b$ || $R3c$


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

$R4$ = $R4a$ || $R4b$ || $R4c$


% "e"-elision after "e"
% Bote+e   -> Bote
% leise$er -> leiser

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           e:<>

$R5$ = e <=> <> ($B$ e)


% optional genitive e-elision
% Tisch+es    -> Tisches, Tischs
% Ei+es       -> Eies, Eis
% Haus+es     -> Hauses
% Fluß~+es    -> Flusses
% Fuß+es      -> Fußes
% Zeugnis~+es -> Zeugnisses

$R6$ = (([bcdfghjklmnpqrtuvwy] <FB>? $B$) e => <> (s <^Gen>)) | \
       (([AEae]i <FB>? $B$) e => <> (s <^Gen>))


% adjective-"el"/"er" "e"-elision
% dunkel<^Ax>+e -> dunkle
% teuer<^Ax>+e  -> teure

$R7$ = e <=> <> ([lr] <^Ax> $B$ e)


% optional pronoun-"er" "e"-elision
% unser<^Px>+en   -> unsren, unsern
% unserig<^Px>+en -> unsrigen

$R8$ = (e => <> (r(ig)? <^Px> $B$? e)) | \
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

$R9a$ = (<e>[lr] $B$) e <=> <> (n | s?t)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] <e> \
           <e>:<>

$R9b$ = <e> => <> ([lr] $B$ [eui])

$R9c$ = <e> <=> <> (n $B$ [eui])

$R9$ = $R9a$ || $R9b$ || $R9c$


% "s"-elimination
% ras&st  -> (du) rast
% feix&st -> (du) feixt
% birs+st -> (du) birst
% groß$st -> größt

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <e>:e s:<>

$R10$ = ([xsßz] $B$) s <=> <> (t)


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

$R11$ = ([a-df-hj-z]e[rl]t) <INS-E> <=> <> (st)


ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <INS-E>:[e<>]

% gewappn&t&st -> gewappnetst

$R12$ = ((((c[hk])|[bdfgmp])n | [a-zäöüß]t) <INS-E> <=> e) & \
        ((<INS-E>:e[dt]) <INS-E> <=> <>)


ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           <INS-E>:e

$R13$ = ([dt]m? | tw) <INS-E> <=> e


% consonant reduction in old orthography
% Schiff=fahrt  -> Schiffahrt, Schifffahrt
% Schiff=fracht -> Schifffracht
% voll=laufen   -> vollaufen, volllaufen
% Sperr=rad     -> Sperrad, Sperrrad

$B$ = [<CB><FB>]

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
     f:[<f><>] <OLDORTH>:<>

$R14a$ = (f f <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [fF] [aeiouäöü])) & \
         (f f <=> <x> ([#morpheme_boundary_marker#]* $B$ [fF] [aeiouäöü])) & \
         ((f:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           l:[<l><>] <OLDORTH>:<> <f>:f

$R14b$ = (l l <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [lL] [aeiouäöü])) & \
         (l l <=> <x> ([#morpheme_boundary_marker#]* $B$ [lL] [aeiouäöü])) & \
         ((l:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           m:[<m><>] <OLDORTH>:<> <l>:l

$R14c$ = (m m <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [mM] [aeiouäöü])) & \
         (m m <=> <x> ([#morpheme_boundary_marker#]* $B$ [mM] [aeiouäöü])) & \
         ((m:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           n:[<n><>] <OLDORTH>:<> <m>:m

$R14d$ = (n n <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [nN] [aeiouäöü])) & \
         (n n <=> <x> ([#morpheme_boundary_marker#]* $B$ [nN] [aeiouäöü])) & \
         ((n:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           r:[<r><>] <OLDORTH>:<> <n>:n

$R14e$ = (r r <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [rR] [aeiouäöü])) & \
         (r r <=> <x> ([#morpheme_boundary_marker#]* $B$ [rR] [aeiouäöü])) & \
         ((r:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           t:[<t><>] <OLDORTH>:<> <r>:r

$R14f$ = (t t <=> <>  ([#morpheme_boundary_marker#]* <OLDORTH>:. $B$ [tT] [aeiouäöü])) & \
         (t t <=> <x> ([#morpheme_boundary_marker#]* $B$ [tT] [aeiouäöü])) & \
         ((t:<> [#morpheme_boundary_marker#]*) <OLDORTH> <=> <>)

$R14$ = ($R14a$ || $R14b$ || $R14c$) || \
        ($R14d$ || $R14e$ || $R14f$)


% suffix substution for plural forms
% Virus<^pl>+en     -> Viren
% Atlas<^pl>+anten  -> Atlanten
% Museum<^pl>+en    -> Museen
% Examen<^pl>+ina   -> Examina
% Affrikata<^pl>+en -> Affrikaten
% Konto<^pl>+en     -> Konten

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           [aeiou]:<> <t>:t

% substitute "-as"/"-is"/"-us"/"-um"/"-on"/"-os"/"-en"

$R15a$ = [aeiou] <=> <> ([mns]:. <^pl>)

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           [amnos]:<>

$R15b$ = [amnos] <=> <> <^pl>

% substitute "e"

ALPHABET = [#char# #phon-trigger# #morpheme_boundary_marker#] \
           e:<>

$R15c$ = e <=> <> <^Del>

$R15$ = $R15a$ || $R15b$ || $R15c$


% marker deletion

ALPHABET = [#char# #morpheme_boundary_marker# <FB><CB><^UC>] \
           [<INS-E><WB><^Ax><^Px><^Gen><^Del><^pl>]:<> \
           <FB>:<\~>

$R16$ = .*


% lower-case conversion

ALPHABET = [#char# #morpheme_boundary_marker#] <^UC> \
           <CB>:<#> [A-ZÄÖÜ]:[a-zäöü]

$R17$ = <CB>:<#> [A-ZÄÖÜ] <=> [a-zäöü] [a-zäöüßáéíóú]


% upper-case conversion

ALPHABET = [#char# #morpheme_boundary_marker#]  \
           <^UC>:<> [a-zäöü]:[A-ZÄÖÜ]

$R18$ = ((<^UC>:<>) [a-zäöü] <=> [A-ZÄÖÜ]) & \
        !(.* <^UC>:<> .:[a-zäöü] .*)


% word-initial morpheme-boundary deletion

$R19$ = <#>:<>* <#>:<>* [#char#] [#char# #morpheme_boundary_marker#]*


% duplicate morpheme-boundary deletion

ALPHABET = [#char# #morpheme_boundary_marker#]

$R20$ = [#morpheme_boundary_marker#]:<> ^-> (__[#morpheme_boundary_marker#])


% composition of rules

$PHON$ = $R1$  || $R2$  || $R3$  || $R4$  || $R5$  || $R6$  || $R7$  || $R8$  || $R9$  || $R10$ || \
         $R11$ || $R12$ || $R13$ || $R14$ || $R15$ || $R16$ || $R17$ || $R18$ || $R19$ || $R20$
