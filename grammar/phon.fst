% phon.fst
% Version 3.4
% Andreas Nolda 2023-03-25

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

% allomorphs
% i<n>loyal     -> illoyal
% i<n>materiell -> immateriell
% trink+<er>ei  -> Trinkerei
% gaukel+<er>ei -> Gaukelei

ALPHABET = [#char# #phon-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #feature# #info# <e><UL>] \
           <n>:[nlmrn] \
           <d>:[dfgklnpst] \
           <~n>:[<>n]

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

ALPHABET = [#char# #phon-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #feature# #info# <e><UL>] \
           [st]:<>

$R2$ = ((st<FB>) s <=> <> (t:.)) & ((st<FB>s:.) t <=> <>)


% umlaut
% Apfel$           -> Äpfel
% alter$e          -> ältere
% Saal$e           -> Säle
% Koog$e           -> Köge
% Schwabe<^Del>$in -> Schwäbin
% Tochter$         -> Töchter

ALPHABET = [#char# #phon-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #feature# #info# <e><UL>]

$Cons$ = [bcdfghjklmnpqrstvwxyzß]

$X$ = $Cons$* <FB>? ([#ss-trigger#] | (e ($Cons$ <^Ax>? | <^Del>)))?

$LC$ = [#char#] | <WB> | <CB>

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

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <SSalt><e>] \
           <SS>:[<><SS>]

% Schuß<SS><FB><SS...> -> Schuß<FB><SS...>

$R4a$ = (ß) <SS> <=> <> (<FB> [#ss-trigger#])

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <SSalt><e>] \
           ß:s <SS>:[<>s]

$R4b$ = (ß <=> s (<FB>? [#ss-trigger#]:. <FB> [aeiou])) & \
        ((ß:s <FB>? | s) [#ss-trigger#] <=> s (<FB> [aeiou])) & \
        ((s) [#ss-trigger#] <=> <> (<FB> ($Cons$ | <WB>)))

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           <SSalt>:<>

$R4c$ = (ß <FB>?) <SSalt> <=> <>

$R4$ = $R4a$ || $R4b$ || $R4c$


% "e"-elision after "e"
% Bote+e   -> Bote
% leise$er -> leiser

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           e:<>

$R5$ = e <=> <> (<FB> e)


% optional genitive "e"-elision
% Tisch+es    -> Tisches, Tischs
% Ei+es       -> Eies, Eis
% Haus+es     -> Hauses
% Fluß~+es    -> Flusses
% Fuß+es      -> Fußes
% Zeugnis~+es -> Zeugnisses

$R6$ = (([bcdfghjklmnpqrtuvwy] <FB>? <FB>) e => <> (s <^Gen>)) | \
       (([AEae]i <FB>? <FB>) e => <> (s <^Gen>))


% adjective-"el"/"er" "e"-elision
% dunkel<^Ax>+e -> dunkle
% teuer<^Ax>+e  -> teure

$R7$ = e <=> <> ([lr] <^Ax> <FB> e)


% optional pronoun-"er" "e"-elision
% unser<^Px>+en   -> unsren, unsern
% unserig<^Px>+en -> unsrigen

$R8$ = (e => <> (r(ig)? <^Px> <FB>? e)) | \
       ((er <^Px> <FB>) e => <> ([mns]))


% verb-"el"/"er" "e"-elision
% sicher<^Vx>+en  -> sichern
% handel<^Vx>+en  -> handeln
% sicher<^Vx>+e   -> sichre, sichere
% handel<^Vx>+e   -> handle, ?handele
% sicher<^Vx>+est -> sicherst, *sichrest, ?sicherest
% handel<^Vx>+est -> handelst, *handlest, ?handelest
% rechn+ung       -> Rechnung

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# #category# #feature# #info# <e>] \
           e:<>

$R9a$ = (<e>[lr] <FB>) e <=> <> (n | s?t)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           <e>:<>

$R9b$ = <e> => <> ([lr] <FB> [eui])

$R9c$ = <e> <=> <> (n <FB> [eui])

$R9$ = $R9a$ || $R9b$ || $R9c$


% "s"-elimination
% ras&st  -> (du) rast
% feix&st -> (du) feixt
% birs+st -> (du) birst
% groß$st -> größt

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <e>:e \
           s:<>

$R10a$ = ([xsßz] [<FB><INS-E>]) s <=> <> (t)

% "l"-elimination
% Engel<DB>lein -> Enge<DB>lein

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           l:<>

$R10b$ = (e) l <=> <> (<DB> lein)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           e:<>

% optional "e"-elision
% Enge<DB>lein -> Eng<DB>lein

$R10c$ = e => <> (<DB> lein)

% non-optional "e"-elision
% Enge<DB>lein -> Eng<DB>lein

$R10cAnalysis$ = e <=> <> (<DB> lein)

$R10$ = $R10a$ || $R10b$ || $R10c$


% "e"-epenthesis
% regn&t       -> regnet
% find&st      -> findest
% bet&st       -> betest
% gelieb&t&st  -> geliebtest
% gewappn&t&st -> gewappnetst

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:<>

% gefeiert&ste -> gefeiertste
% gefeiert&ste -> gefeiertste

$R11$ = ([a-df-hj-z]e[rl]t) <INS-E> <=> <> (st)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:[e<>]

% gewappn&t&st -> gewappnetst

$R12$ = ((((c[hk])|[bdfgmp])n | [#lowercase#]t) <INS-E> <=> e) & \
        ((<INS-E>:e[dt]) <INS-E> <=> <>)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:e

$R13$ = ([dt]m? | tw) <INS-E> <=> e


% consonant reduction in old orthography
% Schiff=fahrt  -> Schiffahrt, Schifffahrt
% Schiff=fracht -> Schifffracht
% voll=laufen   -> vollaufen, volllaufen
% Sperr=rad     -> Sperrad, Sperrrad

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           f:[<f><>] \
           <OLDORTH>:<>

$R14a$ = (f f <=> <>  (<OLDORTH>:. <CB> [fF] [aeiouäöü])) & \
         (f f <=> <x> (<CB> [fF] [aeiouäöü])) & \
         ((f:<>) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           l:[<l><>] \
           <OLDORTH>:<> \
           <f>:f

$R14b$ = (l l <=> <>  (<OLDORTH>:. <CB> [lL] [aeiouäöü])) & \
         (l l <=> <x> (<CB> [lL] [aeiouäöü])) & \
         ((l:<>) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           m:[<m><>] \
           <OLDORTH>:<> \
           <l>:l

$R14c$ = (m m <=> <>  (<OLDORTH>:. <CB> [mM] [aeiouäöü])) & \
         (m m <=> <x> (<CB> [mM] [aeiouäöü])) & \
         ((m:<>) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           n:[<n><>] \
           <OLDORTH>:<> \
           <m>:m

$R14d$ = (n n <=> <>  (<OLDORTH>:. <CB> [nN] [aeiouäöü])) & \
         (n n <=> <x> (<CB> [nN] [aeiouäöü])) & \
         ((n:<>) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           r:[<r><>] \
           <OLDORTH>:<> \
           <n>:n

$R14e$ = (r r <=> <>  (<OLDORTH>:. <CB> [rR] [aeiouäöü])) & \
         (r r <=> <x> (<CB> [rR] [aeiouäöü])) & \
         ((r:<>) <OLDORTH> <=> <>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           t:[<t><>] \
           <OLDORTH>:<> \
           <r>:r

$R14f$ = (t t <=> <>  (<OLDORTH>:. <CB> [tT] [aeiouäöü])) & \
         (t t <=> <x> (<CB> [tT] [aeiouäöü])) & \
         ((t:<>) <OLDORTH> <=> <>)

$R14$ = ($R14a$ || $R14b$ || $R14c$) || \
        ($R14d$ || $R14e$ || $R14f$)


% suffix substution for plural forms
% Virus<^pl>+en     -> Viren
% Atlas<^pl>+anten  -> Atlanten
% Museum<^pl>+en    -> Museen
% Examen<^pl>+ina   -> Examina
% Affrikata<^pl>+en -> Affrikaten
% Konto<^pl>+en     -> Konten

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [aeiou]:<> \
           <t>:t

% substitute "-as"/"-is"/"-us"/"-um"/"-on"/"-os"/"-en"

$R15a$ = [aeiou] <=> <> ([mns]:. <^pl>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [amnos]:<>

$R15b$ = [amnos] <=> <> <^pl>

% substitute "e"

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           e:<>

$R15c$ = e <=> <> <^Del>

$R15$ = $R15a$ || $R15b$ || $R15c$


% letter case
% <WB><^UC>un<DB><^DC>Wetter<WB>                -> <WB>Un<DB>wetter<WB>
% <WB>Sommer<CB><^DC>Wetter<WB>                 -> <WB>Sommer<CB>wetter<WB>
% <WB>Sommer<CB><^DC><^UC>un<DB><^DC>Wetter<WB> -> <WB>Sommer<CB>un<DB>wetter<WB>

% remove spurious orthography triggers

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#]

$R16a$ = .* ([<WB><CB><DB>] [#orth-trigger#] ([#orth-trigger#]:<>)* .*)*

% downcase

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <^UC>] \
           [#uppercase#]:[#lowercase#] \
           <^DC>:<>

$R16b$ = ([<WB><CB><DB>] <^DC>:<>) [#uppercase#] <=> [#lowercase#]

% upcase

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <^DC>] \
           [#lowercase#]:[#uppercase#] \
           <^UC>:<>

$R16c$ = ([<WB><CB><DB>] <^UC>:<>) [#lowercase#] <=> [#uppercase#]

$R16$ = $R16a$ || $R16b$ || $R16c$


% marker deletion

ALPHABET = [#char# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [#phon-trigger#]:<>

$R17$ = .*


% composition of rules

$PHON$ = $R1$  || $R2$  || $R3$  || $R4$  || $R5$  || $R6$  || $R7$  || $R8$  || $R9$ || \
         $R10$ || $R11$ || $R12$ || $R13$ || $R14$ || $R15$ || $R16$ || $R17$

$PHONAnalysis$ = $R10b$ || $R10cAnalysis$ || $R16$
