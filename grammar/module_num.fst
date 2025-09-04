% module_num.fst
% Version 2.4
% Andreas Nolda 2025-09-04

% must be loaded after wf.fst

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$DigCard$ = (<>:0)? [1-9][0-9]* | \
            [1-9][0-9]?[0-9]? (\. [0-9][0-9][0-9])+

$DigCard0$ = $DigCard$ | 0

$BaseStemsDigCard$ = <Stem> $DigCard0$ <CARD> <base> <native> <DigCard>

$DigOrd$ = $DigCard$ \.

$BaseStemsDigOrd$ = <Stem> $DigOrd$ <ORD> <base> <native> <DigOrd>

$VulFrac$ = [#frac#]

$DigFrac$ = $DigCard0$ \, [0-9]+   | \
            $DigCard0$ / $DigCard$ | \
            $VulFrac$

$BaseStemsDigFrac$ = <Stem> $DigFrac$ <FRAC> <base> <native> <DigFrac>

$Roman1$    = I | II | III | IV | V | VI | VII | VIII | IX
$Roman10$   = X | XX | XXX | XL | L | LX | LXX | LXXX | XC
$Roman100$  = C | CC | CCC | CD | D | DC | DCC | DCCC | CM
$Roman1000$ = M | MM | MMM

$Roman$ =                                     $Roman1$   | \
                                  ($Roman10$  $Roman1$?) | \
                      ($Roman100$  $Roman10$? $Roman1$?) | \
          ($Roman1000$ $Roman100$? $Roman10$? $Roman1$?)

$BaseStemsRoman$ = <Stem> $Roman$ <CARD> <base> <native> <Roman>

$Card1a$   = ein<SB>e
$Card1b$   = eins | zwei | drei | vier | fünf | sechs | sieben | acht | neun
$Card1c$   = ein  | zwei | drei | vier | fünf | sechs | sieben | acht | neun
$Card2a$   =        zwei | drit | vier | fünf | sechs | sieb   | acht | neun
$Card2b$   =        zwan | drei | vier | fünf | sech  | sieb   | acht | neun
$Card3a$   =               drei | vier | fünf | sech  | sieb   | acht | neun
$Card3b$   =               drit | vier | fünf | sechs | sieb   | acht | neun
$Card10$   = zehn
$Card11$   = elf | zwölf
$Card100$  = hundert
$Card1000$ = tausend

$Card1000000$ = Million | Milliard % derivation stem

$Ord1$ = erst<SB>e

$I$ = [#index#]
$C$ = [#inflection#]:<Card0>

% final bases in cardinal compounds like "hundertundein(e)" and "hundertein(e)"
$BaseStemFilterCard1aLv2$ = <Stem> $Card1a$ $I$* <CARD> <base> <native>

% final bases in ordinal compounds like "hundertunderste" and "hunderterste"
$BaseStemFilterOrd1Lv2$ = <Stem> $Ord1$ $I$* <ORD> <base> <native>

% final bases in cardinal compounds like "hundertundeins" and "hunderteins"
$BaseStemFilterCard1b$ = <Stem> $Card1b$ $I$* <CARD> <base> <native> $C$

% final basis in (uninflected) cardinal compounds like "dreizehn"
$BaseStemFilterCard10$ = <Stem> $Card10$ $I$* <CARD> <base> <native> $C$

% final basis in ordinal compounds like "dreizehnte"
$BaseStemFilterOrd10$ = <Stem> $Card10$ $I$* <CARD> <der> <-st> <native> <DB> ^$DerSuff-st$

% final basis in fractional compounds like "dreizehntel"
$BaseStemFilterFrac10$ = <Stem> $Card10$ $I$* <CARD> <der> <-stel> <native> <DB> ^$DerSuff-stel$

% final bases in (uninflected) cardinal compounds like "hundertundelf" and "hundertelf"
$BaseStemFilterCard11$ = <Stem> $Card11$ $I$* <CARD> <base> <native> $C$

% final basis in cardinal compounds like "einhundert"
$BaseStemFilterCard100$ = <Stem> $Card100$ $I$* <CARD> <base> <native> $C$

% final basis in ordinal compounds like "einhundertste"
$BaseStemFilterOrd100$ = <Stem> $Card100$ $I$* <CARD> <der> <-st> <native> <DB> ^$DerSuff-st$

% final basis in fractional compounds like "einhundertstel"
$BaseStemFilterFrac100$ = <Stem> $Card100$ $I$* <CARD> <der> <-stel> <native> <DB> ^$DerSuff-stel$

% final basis in cardinal compounds like "eintausend"
$BaseStemFilterCard1000$ = <Stem> $Card1000$ $I$* <CARD> <base> <native> $C$

% final basis in ordinal compounds like "eintausendste"
$BaseStemFilterOrd1000$ = <Stem> $Card1000$ $I$* <CARD> <der> <-st> <native> <DB> ^$DerSuff-st$

% final basis in fractional compounds like "eintausendstel"
$BaseStemFilterFrac1000$ = <Stem> $Card1000$ $I$* <CARD> <der> <-stel> <native> <DB> ^$DerSuff-stel$

% final bases in ordinal compounds like "einmillionste"
$BaseStemFilterOrd1000000$ = <dc> <Stem> $Card1000000$ $I$* <NN> <der> <-st> <foreign> <DB> ^$DerSuff-st$

% final bases in fractional compounds like "einmillionstel"
$BaseStemFilterFrac1000000$ = <dc> <Stem> $Card1000000$ $I$* <NN> <der> <-stel> <foreign> <DB> ^$DerSuff-stel$

% bases in derived cardinals like "zwanzig"
$DerStemFilterCard2-zig$ = <Stem> $Card2b$ <CARD> <der> <-zig> <native>

% bases in derived ordinals like "zweite"
$DerStemFilterCard2-st$ = <Stem> $Card2a$ <CARD> <der> <-st> <native>

% bases in derived fractional numerals like "drittel"
$DerStemFilterCard3-stel$ = <Stem> $Card3b$ <CARD> <der> <-stel> <native>

% bases in derived ordinals like "zehnte"
$DerStemFilterCard10-st$ = <Stem> ($Card10$ | $Card11$) <CARD> <der> <-st> <native>

% bases in derived fractional numerals like "zehntel"
$DerStemFilterCard10-stel$ = <Stem> ($Card10$ | $Card11$) <CARD> <der> <-stel> <native>

% bases in derived ordinals like "hundertste"
$DerStemFilterCard100-st$ = <Stem> $Card100$ <CARD> <der> <-st> <native>

% bases in derived ordinals like "hundertstel"
$DerStemFilterCard100-stel$ = <Stem> $Card100$ <CARD> <der> <-stel> <native>

% bases in derived ordinals like "tausendste"
$DerStemFilterCard1000-st$ = <Stem> $Card1000$ <CARD> <der> <-st> <native>

% bases in derived fractional numerals like "tausendstel"
$DerStemFilterCard1000-stel$ = <Stem> $Card1000$ <CARD> <der> <-stel> <native>

% bases in derived ordinals like "millionste"
$DerStemFilterCard1000000-st$ = <Stem> $Card1000000$ <NN> <der> <-st> <foreign>

% bases in derived fractional numerals like "millionstel"
$DerStemFilterCard1000000-stel$ = <Stem> $Card1000000$ <NN> <der> <-stel> <foreign>

% initial bases in cardinal compounds like "einundzwanzig" and "einhundert"
$CompStemFilterCard1c$ = <Stem> $Card1c$ <CARD> <comp> <native>

% initial bases in cardinal compounds like "dreizehn"
$CompStemFilterCard3$ = <Stem> $Card3a$ <CARD> <comp> <native>

% initial bases in cardinal compounds like "hundertundeins" and "hunderteins"
$CompStemFilterCard100$ = <Stem> $Card100$ <CARD> <comp> <native>

% initial bases in cardinal compounds like "tausendundeins" and "tausendeins"
$CompStemFilterCard1000$ = <Stem> $Card1000$ <CARD> <comp> <native>

$NumLex$ = $BaseStemsDigCard$  | \
           $BaseStemsDigOrd$   | \
           $BaseStemsDigFrac$  | \
           $BaseStemsRoman$
