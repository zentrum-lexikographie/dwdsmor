% phon.fst
% Version 5.1
% Andreas Nolda 2024-07-19

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"


% umlaut
% Apfel<UL>           -> Äpfel<SB>
% alter<UL>e          -> älter<SB>e
% Saal<UL>e           -> Säl<SB>e
% Koog<UL>e           -> Kög<SB>e
% Tochter<UL>         -> Töchter<SB>
% Schwabe<^Del><UL>in -> Schwäbe<^Del><SB>in

ALPHABET = [#char# #phon-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #feature# #info# <e><UL>]

$Cons$ = [#consonant#]

$X$ = $Cons$* <SB>? ([#ss-trigger#] | (e ($Cons$ <^Ax>? | <^Del>)?))?

$LC$ = [#char#] | <WB> | <CB>

$RC$ = [#char#] | <WB>

$PhonUmlaut1$ = ({Au}:{Äu} | \
                 {au}:{äu}) $X$ <UL>:<SB> ^-> $LC$__$RC$

$PhonUmlaut2$ = ({Aa}:{Ä} | \
                 {aa}:{ä} | \
                 {Oo}:{Ö} | \
                 {oo}:{ö}) $X$ <UL>:<SB> ^-> $LC$__$RC$

$PhonUmlaut3$ = ([AOUaou]:[ÄÖÜäöü]) $X$ <UL>:<SB> ^-> $LC$__$RC$

$PhonUmlaut$ = $PhonUmlaut1$ || \
               $PhonUmlaut2$ || \
               $PhonUmlaut3$


% stem-final "s"-duplication
% Bus<SS><SB>es     -> Buss<SB>es
% Kenntnis<SS><SB>e -> Kenntniss<SB>e

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           <SS>:[<>s]

$PhonSDuplication$ = ((s) [#ss-trigger#] <=> s  (<SB> [aeiou])) & \
                     ((s) [#ss-trigger#] <=> <> (<SB> ($Cons$ | <WB>)))


% deletion of "st"-suffixes
% birst<SB>st -> birst<SB>

ALPHABET = [#char# #phon-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #feature# #info# <e><UL>] \
           [st]:<>

$PhonStDeletion$ = ((st<SB>) s <=> <> (t:.)) & ((st<SB>s:.) t <=> <>)


% "e"-elision

% stem-final "e"-elision
% Bote<SB>e   -> Bot<SB>e
% leise<SB>er -> leis<SB>er

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           e:<>

$PhonEElision1$ = e <=> <> (<SB> e)

% optional "e"-elision in genitive suffixes
% Tisch<SB>es<^Gen> -> Tisch<SB>es<^Gen>, Tisch<SB>s<^Gen>
% Ei<SB>es<^Gen>    -> Ei<SB>es<^Gen>, Ei<SB>s<^Gen>

$PhonEElision2$ = (([bcdfghjklmnpqrtuvwy] <SB>? <SB>) e => <> (s <^Gen>)) | \
                  (([AEae]i <SB>? <SB>) e => <> (s <^Gen>))

% optional "e"-elision in pronoun stems ending in "er"
% unser<^Px><SB>en   -> unsr<^Px><SB>en, unser<^Px><SB>n
% unserig<^Px><SB>en -> unsrig<^Px><SB>en

$PhonEElision3$ = (e => <> (r(ig)? <^Px> <SB>? e)) | \
                  ((er <^Px> <SB>) e => <> ([mns]))

% "e"-elision in adjective stems ending in "el"/"er"
% dunkel<^Ax><SB>e  -> dunkl<^Ax><SB>e
% trocken<^Ax><SB>e -> trockn<^Ax><SB>e
% teuer<^Ax><SB>e   -> teur<^Ax><SB>e

$PhonEElision4$ = e <=> <> ([lnr] <^Ax> <SB> e)

% "e"-elision in verb stems ending in "el"/"er"
% hand<e>l<SB>en  -> hand<e>l<SB>n
% hand<e>l<SB>est -> hand<e>l<SB>st
% hand<e>l<SB>e   -> hand<e>l<SB>e, handl<SB>e
% sich<e>r<SB>en  -> sich<e>r<SB>n
% sich<e>r<SB>est -> sich<e>r<SB>st
% sich<e>r<SB>e   -> sich<e>r<SB>e, sichr<SB>e

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# #category# #feature# #info# <e>] \
           e:<>

$PhonEElision5$ = (<e>[lr] <SB>) e <=> <> (n | s?t)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <e>] \
           <e>:<>

$PhonEElision6$ = <e> => <> ([lr] <SB> [eui])

$PhonEElision7$ = <e> <=> <> (n <SB> [eui])

$PhonEElision$ = $PhonEElision1$ || \
                 $PhonEElision2$ || \
                 $PhonEElision3$ || \
                 $PhonEElision4$ || \
                 $PhonEElision5$ || \
                 $PhonEElision6$ || \
                 $PhonEElision7$


% "s"-deletion in "st"-suffixes
% ras<INS-E>st  -> ras<INS-E>t
% feix<INS-E>st -> feix<INS-E>t
% birs<SB>st    -> birs<SB>t

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <e>:e \
           s:<>

$PhonSDeletion$ = ([xsßz] [<SB><INS-E>]) s <=> <> (t)


% deletion of stem-final "e" marked by <^Del>
% Schwäbe<^Del><UL>in -> Schwäb<^Del><SB>in

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           e:<>

$PhonEDeletion$ = e <=> <> (<^Del>)


% "e"-epenthesis
% regn<INS-E>t             -> regnet
% find<INS-E>st            -> findest
% bet<INS-E>st             -> betest
% gelieb<INS-E>t<INS-E>st  -> geliebtest
% gewappn<INS-E>t<INS-E>st -> gewappnetst
% gefeiert<INS-E>ste       -> gefeiertste
% gefeiert<INS-E>ste       -> gefeiertste

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:<>

$PhonEEpenthesis1$ = ([a-df-hj-z]e[rl]t) <INS-E> <=> <> (st)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:[e<>]

$PhonEEpenthesis2$ = ((((c[hk])|[bdfgkmp])n | [#lowercase#]t) <INS-E> <=> e) & \
                     ((<INS-E>:e[dt]) <INS-E> <=> <>)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           <INS-E>:e

$PhonEEpenthesis3$ = ([dt]m? | tw) <INS-E> <=> e

$PhonEEpenthesis$ = $PhonEEpenthesis1$ || \
                    $PhonEEpenthesis2$ || \
                    $PhonEEpenthesis3$


% suffix substution for plural forms
% Dogma<^pl><SB>en         -> Dogm<SB>en
% Museum<^pl><SB>en        -> Muse<SB>en
% Stimulans<^pl><SB>anzien -> Stimul<SB>anzien

% remove final consonant in "-ans"/"-ens"/"-anx"/"-ynx"

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [sx]:<>

$PhonSuffSubstitution1$ = ([aeiouy]n) [sx] <=> <> (<^pl>)

% remove consonant in "-um"/"-en"/"-on"/"-as"/"-is"/"-os"/"-us"/"-ex"/"-ix"
% remove pre-final consonant in "-ans"/"-ens"/"-anx"/"-ynx"

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [mnsx]:<>

$PhonSuffSubstitution2$ = ([aeiouy]) [mnsx] <=> <> (<^pl>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [aeiouy]:<>

% remove vowel in "-a"/"-e"/"-o"
% remove vowel in "-um"/"-en"/"-on"/"-as"/"-is"/"-os"/"-us"/"-ex"/"-ix"
% remove vowel in "-ans"/"-ens"/"-anx"/"-ynx"

$PhonSuffSubstitution3$ = [aeiouy] <=> <> (<^pl>)

$PhonSuffSubstitution$ = $PhonSuffSubstitution1$ || \
                         $PhonSuffSubstitution2$ || \
                         $PhonSuffSubstitution3$


% allomorphy of "in"-prefixes
% i<n><DB>loyal     -> il<DB>loyal
% i<n><DB>materiell -> im<DB>materiell
% i<n><DB>real      -> ir<DB>real

ALPHABET = [#char# #phon-trigger# #orth-trigger# #ss-trigger# #boundary-trigger# \
            #lemma-index# #paradigm-index# #category# #feature# #info# <e><UL>] \
           <n>:[nlmrn]

$PhonPref-in$ = (<n>  <=> n    (<DB> [ac-knoqs-zäöüßAC-KNOQS-ZÄÖÜ])) & \
                (<n>  <=> l    (<DB> [Ll])) & \
                (<n>  <=> m    (<DB> [BbMmPp])) & \
                (<n>  <=> [rn] (<DB> [Rr]))


% segment deletion before "lein"-suffixes

% "l"-deletion before "lein"-suffixes
% Engel<DB>lein -> Enge<DB>lein

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           l:<>

$PhonSuff-lein1$ = (e) l <=> <> (<DB> lein)

% optional "e"-elision before "lein"-suffixes
% Enge<DB>lein -> Eng<DB>lein

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           e:<>

$PhonSuff-lein2$ = e => <> (<DB> lein)

% "e"-elision before "lein"-suffixes
% Enge<DB>lein -> Eng<DB>lein

$PhonSuff-lein2Lv2$ = e <=> <> (<DB> lein)

$PhonSuff-lein$ = $PhonSuff-lein1$ || \
                  $PhonSuff-lein2$

$PhonSuff-leinLv2$ = $PhonSuff-lein1$ || \
                     $PhonSuff-lein2Lv2$


% letter case

% remove spurious orthography triggers
% <WB>Sommer<CB><^DC><^UC>un<DB><^DC>Wetter<WB> -> <WB>Sommer<CB><^DC>un<DB><^DC>Wetter<WB>

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#]

$PhonCase1$ = .* ([<WB><CB><DB>] [#orth-trigger#] ([#orth-trigger#]:<>)* .*)*

% downcase
% <WB>Sommer<CB><^DC>Wetter<WB>            -> <WB>Sommer<CB>wetter<WB>
% <WB>Sommer<CB><^DC>un<DB><^DC>Wetter<WB> -> <WB>Sommer<CB>un<DB>wetter<WB>

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <^UC>] \
           [#uppercase#]:[#lowercase#] \
           <^DC>:<>

$PhonCase2$ = ([<WB><CB><DB>] <^DC>:<>) [#uppercase#] <=> [#lowercase#]

% upcase
% <WB><^UC>un<DB><^DC>Wetter<WB>                -> <WB>Un<DB>wetter<WB>

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info# <^DC>] \
           [#lowercase#]:[#uppercase#] \
           <^UC>:<>

$PhonCase3$ = ([<WB><CB><DB>] <^UC>:<>) [#lowercase#] <=> [#uppercase#]

$PhonCase$ = $PhonCase1$ || \
             $PhonCase2$ || \
             $PhonCase3$


% marker deletion

ALPHABET = [#char# #boundary-trigger# #lemma-index# #paradigm-index# \
            #category# #feature# #info#] \
           [#phon-trigger#]:<>

$PhonMarker$ = .*


$PHON$ = $PhonUmlaut$           || \
         $PhonSDuplication$     || \
         $PhonStDeletion$       || \
         $PhonEElision$         || \
         $PhonSDeletion$        || \
         $PhonEDeletion$        || \
         $PhonEEpenthesis$      || \
         $PhonSuffSubstitution$ || \
         $PhonPref-in$          || \
         $PhonSuff-lein$        || \
         $PhonCase$             || \
         $PhonMarker$

$PHONLv2$ = $PhonSuff-leinLv2$ || \
            $PhonCase$
