% module_orth.fst
% Version 5.6
% Andreas Nolda 2025-09-22

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

% generate old spelling variants

$Vowel$ = [#vowel#]
$Cons$  = [#consonant#]

$ConsMinusS$ = $Cons$-[s]

$ConsNoSS$ = $Cons$               | \
             $ConsMinusS$ $Cons$* | \
             $Cons$ $ConsMinusS$ $Cons$*

$SSOld$ = {ss}:{ß}

$SegSylSS$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ ss $Vowel$ $ConsNoSS$?

$SegSylSSOld$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $SSOld$

$SegSylNoSSOld$ = $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $Vowel$ $Cons$* | \
                  $Cons$* ($Vowel$+ $ConsNoSS$?)* $Vowel$ $ConsNoSS$? % ...

$SegUnsyl$ = $Cons$+

$Seg$ = $SegSylNoSSOld$ | \
        $SegSylSS$      | \
        $SegSylSSOld$   | \
        $SegUnsyl$

$SegSylInflPref$ = ge <PB>

$SegSylSSInflSuffAdj$ = <SB>? t (<SB>  e(r | st))? (<SB> e[mnrs]?)?
$SegSylSSInflSuffV$   = <SB>  t  <SB> (e(n | s?t)?)?

$SegSylSSInflSuff$ = $SegSylSSInflSuffAdj$ | \
                     $SegSylSSInflSuffV$

$SegSylInflSuff$ = <SB> $Vowel$ (<SB>? $Cons$+ (<SB> $Cons$+)*)? | \
                   <SB>                $Cons$+ (<SB> $Cons$+)*   | \
                   $SegSylSSInflSuff$

$SegSylSSOldInfl$ = $SegSylInflPref$? $SegSylSSOld$ $SegSylSSInflSuff$?

$SegSylNoSSOldInfl$ = $SegSylInflPref$? $SegSylNoSSOld$ $SegSylInflSuff$?

$WordSSOld$ = anlä$SSOld$lich | \
              bi$SSOld$chen
              % ...

$B$ = [#boundary-trigger# \-]

$BMinusSB$ = $B$-[<SB>]

$OrthOld$ = (($B$+        $Seg$)*                      \
             ($B$+        $SegSylSSOld$)               \
             ($B$+        $Seg$)*                      \
             ($BMinusSB$+ $SegSylNoSSOldInfl$)) $B$+ | \
            (($B$+        $Seg$)*                      \
             ($BMinusSB$+ $SegSylSSOldInfl$))   $B$+ | \
            ($B$+         $WordSSOld$) $B$+


% filter out old spelling variants

ALPHABET = [#weight# #char# #morpheme-boundary# #index# #wf# #feature# \
            #metainfo# #syninfo# #ellipinfo#]

$NoOrthOldFilterLv2$ = .*


% generate Swiss spelling variants

$C$ = [#char# #morpheme-boundary#]-[ß]

$OrthCH$ = ($C$* {ß}:{ss})+ $C$*


% generate capitalised variants

$OrthCap$ = [#lowercase#]:[#uppercase#] [#char# #morpheme-boundary#]*
