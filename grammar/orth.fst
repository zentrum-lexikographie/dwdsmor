% orth.fst
% Version 3.0
% Andreas Nolda 2023-05-17

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"


% generate old spelling variants

$Vowel$ = [#vowel#]
$Cons$  = [#consonant#]

$ConsMinusS$ = $Cons$-[s]

$ConsNoSS$ = $Cons$               | \
             $ConsMinusS$ $Cons$* | \
             $Cons$ $ConsMinusS$ $Cons$*

$SyllablesSS$ = $Cons$* $Vowel$ ss $Vowel$ $ConsNoSS$?

$SyllableSSOld$ = $Cons$* $Vowel$ {ss}:ß

$SyllableNoSSOld$ = $Cons$* $Vowel$ $Vowel$ $Cons$* | \
                    $Cons$* $Vowel$ $ConsNoSS$? % ...

$Syllable$ = $SyllableNoSSOld$ | \
             $SyllablesSS$ | \
             $SyllableSSOld$

$SyllableInflPref$ = ge <FB>

$SyllableSSInflSuff$ = t (e[mnrst]?)?

$SyllableInflSuff$ = <FB> $Vowel$? $Cons$* | \
                     $SyllableSSInflSuff$

$SyllableSSOldInfl$ = $SyllableInflPref$? $SyllableSSOld$ $SyllableSSInflSuff$?

$SyllableNoSSOldInfl$ = $SyllableInflPref$? $SyllableNoSSOld$ $SyllableInflSuff$?

$B$ = [#boundary-trigger#]

$BNoFB$ = $B$-[<FB>]

$OrthOld$ = (($B$+     $Syllable$)*                   \
             ($B$+     $SyllableSSOld$)               \
             ($B$+     $Syllable$)*                   \
             ($BNoFB$+ $SyllableNoSSOldInfl$)) $B$+ | \
            (($B$+     $Syllable$)*                   \
             ($BNoFB$+ $SyllableSSOldInfl$)) $B$+


% filter out old spelling variants

ALPHABET = [#char# #morpheme-boundary# #feature# #metainfo#]

$NoOrthOldFilterLv2$ = .*


% generate Swiss spelling variants

$C$ = [#char#]-[ß]

$OrthCH$ = ($C$* ß:{ss})+ $C$*


% generate capitalised variants

$OrthCap$ = [#lowercase#]:[#uppercase#] [#char#]*
