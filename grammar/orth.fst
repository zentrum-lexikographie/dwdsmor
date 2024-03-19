% orth.fst
% Version 4.0
% Andreas Nolda 2024-03-19

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

$SyllablesSS$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ ss $Vowel$ $ConsNoSS$?

$SyllablesSSOld$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $SSOld$

$SyllablesNoSSOld$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $Vowel$ $Cons$* | \
                     $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $ConsNoSS$? % ...

$Syllables$ = $SyllablesNoSSOld$ | \
              $SyllablesSS$ | \
              $SyllablesSSOld$

$SyllableInflPref$ = ge <PB>

$SyllableSSInflSuff$ = t (e[mnrst]?)?

$SyllableInflSuff$ = <SB> $Vowel$? $Cons$* | \
                     $SyllableSSInflSuff$

$SyllablesSSOldInfl$ = $SyllableInflPref$? $SyllablesSSOld$ $SyllableSSInflSuff$?

$SyllablesNoSSOldInfl$ = $SyllableInflPref$? $SyllablesNoSSOld$ $SyllableInflSuff$?

$WordSSOld$ = anlä$SSOld$lich | \
              bi$SSOld$chen
              % ...

$B$ = [#boundary-trigger# \-]

$BNoFB$ = $B$-[<SB>]

$OrthOld$ = (($B$+     $Syllables$)*                   \
             ($B$+     $SyllablesSSOld$)               \
             ($B$+     $Syllables$)*                   \
             ($BNoFB$+ $SyllablesNoSSOldInfl$)) $B$+ | \
            (($B$+     $Syllables$)*                   \
             ($BNoFB$+ $SyllablesSSOldInfl$))   $B$+ | \
            ($B$+      $WordSSOld$) $B$+


% filter out old spelling variants

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #feature# #metainfo#]

$NoOrthOldFilterLv2$ = .*


% generate Swiss spelling variants

$C$ = [#char#]-[ß]

$OrthCH$ = ($C$* ß:{ss})+ $C$*


% generate capitalised variants

$OrthCap$ = [#lowercase#]:[#uppercase#] [#char#]*
