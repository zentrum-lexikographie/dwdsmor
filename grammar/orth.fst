% orth.fst
% Version 3.2
% Andreas Nolda 2024-03-15

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

$SSOld$ = {ss}:ß

$SyllablesSS$ = $Cons$* $Vowel$ ss $Vowel$ $ConsNoSS$?

$SyllableSSOld$ = $Cons$* $Vowel$ $SSOld$

$SyllableNoSSOld$ = $Cons$* $Vowel$ $Vowel$ $Cons$* | \
                    $Cons$* $Vowel$ $ConsNoSS$? % ...

$Syllable$ = $SyllableNoSSOld$ | \
             $SyllablesSS$ | \
             $SyllableSSOld$

$SyllableInflPref$ = ge <PB>

$SyllableSSInflSuff$ = t (e[mnrst]?)?

$SyllableInflSuff$ = <SB> $Vowel$? $Cons$* | \
                     $SyllableSSInflSuff$

$SyllableSSOldInfl$ = $SyllableInflPref$? $SyllableSSOld$ $SyllableSSInflSuff$?

$SyllableNoSSOldInfl$ = $SyllableInflPref$? $SyllableNoSSOld$ $SyllableInflSuff$?

$WordSSOld$ = Exze$SSOld$     | \
              Kompromi$SSOld$ | \
              Kongre$SSOld$   | \
              Proze$SSOld$    | \
              Stewarde$SSOld$ | \
              bi$SSOld$chen   | \
              gewi$SSOld$ % ...

$B$ = [#boundary-trigger#]

$BNoFB$ = $B$-[<SB>]

$OrthOld$ = (($B$+     $Syllable$)*                   \
             ($B$+     $SyllableSSOld$)               \
             ($B$+     $Syllable$)*                   \
             ($BNoFB$+ $SyllableNoSSOldInfl$)) $B$+ | \
            (($B$+     $Syllable$)*                   \
             ($BNoFB$+ $SyllableSSOldInfl$))   $B$+ | \
             ($B$+     $WordSSOld$)            $B$+


% filter out old spelling variants

ALPHABET = [#char# #morpheme-boundary# #feature# #metainfo#]

$NoOrthOldFilterLv2$ = .*


% generate Swiss spelling variants

$C$ = [#char#]-[ß]

$OrthCH$ = ($C$* ß:{ss})+ $C$*


% generate capitalised variants

$OrthCap$ = [#lowercase#]:[#uppercase#] [#char#]*
