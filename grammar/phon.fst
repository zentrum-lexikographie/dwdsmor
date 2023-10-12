% phon.fst
% Version 4.0
% Andreas Nolda 2023-10-12

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

$Cons$ = [#consonant#]

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


% "s"/"ss"-alternation
% Bus~+es     -> Busses
% Kenntnis~+e -> Kenntnisse

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           <SS>:[<>s]

$R4$ = ((s) [#ss-trigger#] <=> s  (<FB> [aeiou])) & \
       ((s) [#ss-trigger#] <=> <> (<FB> ($Cons$ | <WB>)))


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
% sicher+en  -> sichern
% handel+en  -> handeln
% sicher+e   -> sichre, sichere
% handel+e   -> handle, ?handele
% sicher+est -> sicherst, *sichrest, ?sicherest
% handel+est -> handelst, *handlest, ?handelest
% rechn+ung  -> Rechnung

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
% ras<INS-E>st  -> (du) rast
% feix<INS-E>st -> (du) feixt
% birs+st       -> (du) birst
% groß$st       -> größt

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

$R10cLv2$ = e <=> <> (<DB> lein)

$R10$ = $R10a$ || $R10b$ || $R10c$


% "e"-epenthesis
% regn<INS-E>t  -> regnet
% find<INS-E>st -> findest
% bet<INS-E>st  -> betest
% gelieb<INS-E>t<INS-E>st  -> geliebtest
% gewappn<INS-E>t<INS-E>st -> gewappnetst

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:<>

% gefeiert<INS-E>ste -> gefeiertste
% gefeiert<INS-E>ste -> gefeiertste

$R11$ = ([a-df-hj-z]e[rl]t) <INS-E> <=> <> (st)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:[e<>]

% gewappn<INS-E>t<INS-E>st -> gewappnetst

$R12$ = ((((c[hk])|[bdfgkmp])n | [#lowercase#]t) <INS-E> <=> e) & \
        ((<INS-E>:e[dt]) <INS-E> <=> <>)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:e

$R13$ = ([dt]m? | tw) <INS-E> <=> e


% suffix substution for plural forms
% Virus<^pl>+en     -> Viren
% Atlas<^pl>+anten  -> Atlanten
% Museum<^pl>+en    -> Museen
% Examen<^pl>+ina   -> Examina
% Affrikata<^pl>+en -> Affrikaten
% Konto<^pl>+en     -> Konten

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [aeiou]:<>

% substitute "-as"/"-is"/"-us"/"-um"/"-on"/"-os"/"-en"

$R14a$ = [aeiou] <=> <> ([mns]:. <^pl>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [amnos]:<>

$R14b$ = [amnos] <=> <> <^pl>

% substitute "e"

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           e:<>

$R14c$ = e <=> <> <^Del>

$R14$ = $R14a$ || $R14b$ || $R14c$


% letter case
% <WB><^UC>un<DB><^DC>Wetter<WB>                -> <WB>Un<DB>wetter<WB>
% <WB>Sommer<CB><^DC>Wetter<WB>                 -> <WB>Sommer<CB>wetter<WB>
% <WB>Sommer<CB><^DC><^UC>un<DB><^DC>Wetter<WB> -> <WB>Sommer<CB>un<DB>wetter<WB>

% remove spurious orthography triggers

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#]

$R15a$ = .* ([<WB><CB><DB>] [#orth-trigger#] ([#orth-trigger#]:<>)* .*)*

% downcase

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <^UC>] \
           [#uppercase#]:[#lowercase#] \
           <^DC>:<>

$R15b$ = ([<WB><CB><DB>] <^DC>:<>) [#uppercase#] <=> [#lowercase#]

% upcase

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <^DC>] \
           [#lowercase#]:[#uppercase#] \
           <^UC>:<>

$R15c$ = ([<WB><CB><DB>] <^UC>:<>) [#lowercase#] <=> [#uppercase#]

$R15$ = $R15a$ || $R15b$ || $R15c$


% marker deletion

ALPHABET = [#char# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [#phon-trigger#]:<>

$R16$ = .*


% composition of rules

$PHON$ = $R1$ || $R2$  || $R3$  || $R4$  || $R5$  || $R6$  || $R7$  || $R8$ || \
         $R9$ || $R10$ || $R11$ || $R12$ || $R13$ || $R14$ || $R15$ || $R16$

$PHONLv2$ = $R10b$ || $R10cLv2$ || $R15$
