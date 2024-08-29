% orth.fst
% Version 5.1
% Andreas Nolda 2024-08-29

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

$SSOld$ = {ss}:{ß}

$SyllablesSS$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ ss $Vowel$ $ConsNoSS$?

$SyllablesSSOld$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $SSOld$

$SyllablesNoSSOld$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $Vowel$ $Cons$* | \
                     $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $ConsNoSS$? % ...

$Syllables$ = $SyllablesNoSSOld$ | \
              $SyllablesSS$      | \
              $SyllablesSSOld$

$SyllableInflPref$ = ge <PB>

$SyllableSSInflSuffAdj$ = <SB>? t (<SB>  e(r | st))? (<SB> e[mnrs]?)?
$SyllableSSInflSuffV$   = <SB>  t  <SB> (e(n | s?t)?)?

$SyllableSSInflSuff$ = $SyllableSSInflSuffAdj$ | \
                       $SyllableSSInflSuffV$

$SyllableInflSuff$ = <SB> $Vowel$ (<SB>? $Cons$+ (<SB> $Cons$+)*)? | \
                     <SB>                $Cons$+ (<SB> $Cons$+)*   | \
                     $SyllableSSInflSuff$

$SyllablesSSOldInfl$ = $SyllableInflPref$? $SyllablesSSOld$ $SyllableSSInflSuff$?

$SyllablesNoSSOldInfl$ = $SyllableInflPref$? $SyllablesNoSSOld$ $SyllableInflSuff$?

$WordSSOld$ = anlä$SSOld$lich | \
              bi$SSOld$chen
              % ...

$B$ = [#boundary-trigger# \-]

$BNoSB$ = $B$-[<SB>]

$OrthOld$ = (($B$+     $Syllables$)*                   \
             ($B$+     $SyllablesSSOld$)               \
             ($B$+     $Syllables$)*                   \
             ($BNoSB$+ $SyllablesNoSSOldInfl$)) $B$+ | \
            (($B$+     $Syllables$)*                   \
             ($BNoSB$+ $SyllablesSSOldInfl$))   $B$+ | \
            ($B$+      $WordSSOld$) $B$+


% filter out old spelling variants

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# \
            #feature# #metainfo#]

$NoOrthOldFilterLv2$ = .*


% generate Swiss spelling variants

$C$ = [#char#]-[ß]

$OrthCH$ = ($C$* {ß}:{ss})+ $C$*


% generate capitalised variants

$OrthCap$ = [#lowercase#]:[#uppercase#] [#char#]*
