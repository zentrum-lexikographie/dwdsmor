% phon.fst
% Version 6.6
% Andreas Nolda 2025-06-13

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"


% umlaut
% Apfel<uml>                 -> Äpfel
% Haus<uml><SB>e             -> Häus<SB>er
% Saal<uml><SB>e             -> Säl<SB>e
% Schwabe<del(e)><uml><SB>in -> Schwäbe<del(e)><SB>in

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>]

$Cons$ = [#consonant#]

$X$ = $Cons$* (<dbl(s)> | (e (<del(e)> | $Cons$ <del(e)|ADJ>?)?))?

$C$ = [#char# #boundary-trigger#]

$PhonUmlaut1$ = ({Au}:{Äu} | \
                 {au}:{äu}) $X$ <uml>:<> ^-> $C$__$C$

$PhonUmlaut2$ = ({Aa}:{Ä} | \
                 {aa}:{ä} | \
                 {Oo}:{Ö} | \
                 {oo}:{ö}) $X$ <uml>:<> ^-> $C$__$C$

$PhonUmlaut3$ = ([AOUaou]:[ÄÖÜäöü]) $X$ <uml>:<> ^-> $C$__$C$

$PhonUmlaut$ = $PhonUmlaut1$ || \
               $PhonUmlaut2$ || \
               $PhonUmlaut3$


% stem-final "s"-duplication
% Bus<dbl(s)><SB>es     -> Buss<SB>es
% Kenntnis<dbl(s)><SB>e -> Kenntniss<SB>e

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           <dbl(s)>:[<>s]

$PhonSDuplication$ = ((s) <dbl(s)> <=> s  (<SB> [aeiou])) & \
                     ((s) <dbl(s)> <=> <> (<SB> $Cons$ | <WB>))


% stem-final "z"-duplication
% Quiz<dbl(z)><SB>es -> Quizz<SB>es
% Quiz<dbl(z)><SB>e  -> Quizz<SB>e

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           <dbl(z)>:[<>z]

$PhonZDuplication$ = ((z) <dbl(z)> <=> z  (<SB> [aeiou])) & \
                     ((z) <dbl(z)> <=> <> (<SB> $Cons$ | <WB>))


% deletion of "st"-suffixes
% birst<SB>st -> birst

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           [<SB>st]:<>

$PhonStDeletion$ = ((st) <SB>           <=> <> (s:. t:.)) & \
                   ((st  <SB>:.) s      <=> <>     (t:.)) & \
                   ((st  <SB>:.  s:.) t <=> <>)


% "e"-elision

% stem-final "e"-elision
% Bote<SB>e   -> Bot<SB>e
% leise<SB>er -> leis<SB>er

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           e:<>

$PhonEElision1$ = ([^<del(VC)|Pl>]) e <=> <> (<SB> e)

% optional "e"-elision in genitive suffixes
% Tisch<SB>es<del(e)|Gen> -> Tisch<SB>es<del(e)|Gen>, Tisch<SB>s<del(e)|Gen>
% Ei<SB>es<del(e)|Gen>    -> Ei<SB>es<del(e)|Gen>, Ei<SB>s<del(e)|Gen>

$PhonEElision2$ = (([bcdfghjklmnpqrtuvwy] <SB>) e => <> (s <del(e)|Gen>)) | \
                  (([AEae]i <SB>) e => <> (s <del(e)|Gen>))

% optional "e"-elision in pronoun stems ending in "er"
% unser<del(e)|PRO><SB>en   -> unsr<del(e)|PRO><SB>en, unser<del(e)|PRO><SB>n
% unserig<del(e)|PRO><SB>en -> unsrig<del(e)|PRO><SB>en

$PhonEElision3$ = (e => <> (r(ig)? <del(e)|PRO> <SB> e)) | \
                  ((er <del(e)|PRO> <SB>) e => <> ([mns]))

% "e"-elision in adjective stems ending in "el"/"er"
% dunkel<del(e)|ADJ><SB>e  -> dunkl<del(e)|ADJ><SB>e
% trocken<del(e)|ADJ><SB>e -> trockn<del(e)|ADJ><SB>e
% teuer<del(e)|ADJ><SB>e   -> teur<del(e)|ADJ><SB>e

$PhonEElision4$ = e <=> <> ([lnr] <del(e)|ADJ> <SB> e)

% "e"-elision in verb stems ending in "el"/"er"
% hand<e>l<SB>en  -> hand<e>l<SB>n
% hand<e>l<SB>est -> hand<e>l<SB>st, handl<SB>est
% hand<e>l<SB>e   -> hand<e>l<SB>e, handl<SB>e
% sich<e>r<SB>en  -> sich<e>r<SB>n
% sich<e>r<SB>est -> sich<e>r<SB>st
% sich<e>r<SB>e   -> sich<e>r<SB>e, sichr<SB>e

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           e:<>

$PhonEElision5$ = (<e>[lr] <SB>) e <=> <> (n)

$PhonEElision6$ = (<e>r <SB>) e <=> <> (s?t)

$PhonEElision7$ = (<e>l <SB>) e => <> (s?t)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           <e>:<>

$PhonEElision8$ = <e> <=> <> (n <SB> [eui])

$PhonEElision9$ = <e> => <> ([lr] <SB> [eui])

$PhonEElision10$ = <e> <=> <> (l <SB> es?t)

$PhonEElision$ = $PhonEElision1$ || \
                 $PhonEElision2$ || \
                 $PhonEElision3$ || \
                 $PhonEElision4$ || \
                 $PhonEElision5$ || \
                 $PhonEElision6$ || \
                 $PhonEElision7$ || \
                 $PhonEElision8$ || \
                 $PhonEElision9$ || \
                 $PhonEElision10$


% "s"-deletion in "st"-suffixes
% ras<SB><ins(e)>st  -> ras<SB><ins(e)>t
% feix<SB><ins(e)>st -> feix<SB><ins(e)>t

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           <e>:e \
           s:<>

$PhonSDeletion$ = ([sßxz] <SB><ins(e)>?) s <=> <> (t)


% deletion of stem-final "e" marked by <del(e)>
% Schwäbe<del(e)><SB>in -> Schwäb<del(e)><SB>in

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           e:<>

$PhonEDeletion$ = e <=> <> (<del(e)>)


% "e"-epenthesis
% bet<SB><ins(e)>st                       -> bet<SB>est
% find<SB><ins(e)>st                      -> find<SB>est
% regn<SB><ins(e)>t                       -> regn<SB>et
% gefeiert<SB><ins(e)>st<SB>e             -> gefeiert<SB>st<SB>e
% gelieb<SB><ins(e)>t<SB><ins(e)>st<SB>e  -> gelieb<SB>t<SB>est<SB>e
% gewappn<SB><ins(e)>t<SB><ins(e)>st<SB>e -> gewappn<SB>et<SB>st<SB>e

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           <ins(e)>:<>

$PhonEEpenthesis1$ = ([a-df-hj-z]e[rl]t <SB>) <ins(e)> <=> <> (st)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           <ins(e)>:[e<>]

$PhonEEpenthesis2$ = ((((c[hk] | [bdfgkmp])n | [#lowercase#]t) <SB>) <ins(e)> <=> e) & \
                     ((<ins(e)>:e[dt] <SB>) <ins(e)> <=> <>)


ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           <ins(e)>:e

$PhonEEpenthesis3$ = (([dt]m? | s[mn] | tw) <SB>) <ins(e)> <=> e

$PhonEEpenthesis$ = $PhonEEpenthesis1$ || \
                    $PhonEEpenthesis2$ || \
                    $PhonEEpenthesis3$


% suffix substution for plural forms
% Dogma<del(VC)|Pl><SB>en         -> Dogm<SB>en
% Museum<del(VC)|Pl><SB>en        -> Muse<SB>en
% Stimulans<del(VC)|Pl>anzi<SB>en -> Stimulanzi<SB>en

% remove final consonant in "-ans"/"-ens"/"-anx"/"-ynx"

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           [sx]:<>

$PhonSuffSubstitution1$ = ([aeiouy]n) [sx] <=> <> (<del(VC)|Pl>)

% remove consonant in "-um"/"-en"/"-on"/"-er"/"-as"/"-is"/"-os"/"-us"/"-ex"/"-ix"
% remove pre-final consonant in "-ans"/"-ens"/"-anx"/"-ynx"

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           [mnrsx]:<>

$PhonSuffSubstitution2$ = ([aeiouy]) [mnrsx] <=> <> (<del(VC)|Pl>)

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           [aeiouy]:<>

% remove vowel in "-a"/"-e"/"-o"
% remove vowel in "-um"/"-en"/"-on"/"-as"/"-is"/"-os"/"-us"/"-ex"/"-ix"
% remove vowel in "-ans"/"-ens"/"-anx"/"-ynx"

$PhonSuffSubstitution3$ = [aeiouy] <=> <> (<del(VC)|Pl>)

$PhonSuffSubstitution$ = $PhonSuffSubstitution1$ || \
                         $PhonSuffSubstitution2$ || \
                         $PhonSuffSubstitution3$


% allomorphy of "in"-prefixes
% i<n><DB>loyal     -> il<DB>loyal
% i<n><DB>materiell -> im<DB>materiell
% i<n><DB>real      -> ir<DB>real

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info# <e>] \
           <n>:[nlmrn]

$PhonPref-in$ = (<n> <=> n    (<DB> [ac-knoqs-zäöüßAC-KNOQS-ZÄÖÜ])) & \
                (<n> <=> l    (<DB> [Ll])) & \
                (<n> <=> m    (<DB> [BbMmPp])) & \
                (<n> <=> [rn] (<DB> [Rr]))


% segment deletion before "lein"-suffixes

% "l"-deletion before "lein"-suffixes
% Engel<DB>lein -> Enge<DB>lein

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
            #category# #feature# #info#] \
           l:<>

$PhonSuff-lein1$ = (e) l <=> <> (<DB> lein)

% optional "e"-elision before "lein"-suffixes
% Enge<DB>lein -> Eng<DB>lein

ALPHABET = [#char# #phon-trigger# #orth-trigger# #boundary-trigger# #index# #wf# \
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
% <WB>Sommer<CB><dc><uc>un<DB><dc>Wetter<WB> -> <WB>Sommer<CB><dc>un<DB><dc>Wetter<WB>

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #index# #wf# #category# \
            #feature# #info#]

$PhonCase1$ = .* ([<WB><CB><DB>] [#orth-trigger#] ([#orth-trigger#]:<>)* .*)*

% downcase
% <WB>Sommer<CB><dc>Wetter<WB>            -> <WB>Sommer<CB>wetter<WB>
% <WB>Sommer<CB><dc>un<DB><dc>Wetter<WB> -> <WB>Sommer<CB>un<DB>wetter<WB>

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #index# #wf# #category# \
            #feature# #info# <uc>] \
           [#uppercase#]:[#lowercase#] \
           <dc>:<>

$PhonCase2$ = ([<WB><CB><DB>] <dc>:<>) [#uppercase#] <=> [#lowercase#]

% upcase
% <WB><uc>un<DB><dc>Wetter<WB>                -> <WB>Un<DB>wetter<WB>

ALPHABET = [#char# #phon-trigger# #boundary-trigger# #index# #wf# #category# \
            #feature# #info# <dc>] \
           [#lowercase#]:[#uppercase#] \
           <uc>:<>

$PhonCase3$ = ([<WB><CB><DB>] <uc>:<>) [#lowercase#] <=> [#uppercase#]

$PhonCase$ = $PhonCase1$ || \
             $PhonCase2$ || \
             $PhonCase3$


% marker deletion

ALPHABET = [#char# #boundary-trigger# #index# #wf# #category# #feature# #info#] \
           [#phon-trigger#]:<>

$PhonMarker$ = .*


$PHON$ = $PhonUmlaut$           || \
         $PhonSDuplication$     || \
         $PhonZDuplication$     || \
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
