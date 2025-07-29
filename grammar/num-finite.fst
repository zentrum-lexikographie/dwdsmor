% num-finite.fst
% Version 2.3
% Andreas Nolda 2025-07-28

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"
#include "wf.fst"

$DIGCARD$ = (<>:0)? [1-9][0-9]?[0-9]?

$DIGCARD0$ = $DIGCARD$ | 0

$BaseStemsDigCard$ = <Stem> $DIGCARD0$ <CARD> <base> <native> <DigCard>

$DIGORD$ = $DIGCARD$ \.

$BaseStemsDigOrd$ = <Stem> $DIGORD$ <ORD> <base> <native> <DigOrd>

$VULFRAC$ = [#frac#]

$DIGFRAC$ = $DIGCARD0$ \, [0-9]    | \
            $DIGCARD0$ / $DIGCARD$ | \
            $VULFRAC$

$BaseStemsDigFrac$ = <Stem> $DIGFRAC$ <FRAC> <base> <native> <DigFrac>

$ROMAN1$    = I | II | III | IV | V | VI | VII | VIII | IX
$ROMAN10$   = X | XX | XXX | XL | L | LX | LXX | LXXX | XC
$ROMAN100$  = C | CC | CCC | CD | D | DC | DCC | DCCC | CM

$ROMAN$ =                                     $ROMAN1$   | \
                                  ($ROMAN10$  $ROMAN1$?) | \
                      ($ROMAN100$  $ROMAN10$? $ROMAN1$?)

$BaseStemsRoman$ = <Stem> $ROMAN$ <CARD> <base> <native> <Roman>

$CARD1a$   = ein<SB>e
$CARD1b$   = eins | zwei | drei | vier | fünf | sechs | sieben | acht | neun
$CARD1c$   = ein  | zwei | drei | vier | fünf | sechs | sieben | acht | neun
$CARD2a$   =        zwei | drit | vier | fünf | sechs | sieb   | acht | neun
$CARD2b$   =        zwan | drei | vier | fünf | sech  | sieb   | acht | neun
$CARD3a$   =               drei | vier | fünf | sech  | sieb   | acht | neun
$CARD3b$   =               drit | vier | fünf | sechs | sieb   | acht | neun
$CARD10$   = zehn
$CARD11$   = elf | zwölf
$CARD100$  = hundert

$ORD1$ = erst<SB>e

$I$ = [#index#]
$C$ = [#inflection#]:<Card0>

% final bases in cardinal compounds like "hundertein(e)" and "hundertundein(e)"
$BaseStemFilterCard1aLv2$ = <Stem> $CARD1a$ $I$* <CARD> <base> <native>

% final bases in ordinal compounds like "hunderterste" and "hundertunderste"
$BaseStemFilterOrd1Lv2$ = <Stem> $ORD1$ $I$* <ORD> <base> <native>

% final bases in cardinal compounds like "hunderteins" and "hundertundeins"
$BaseStemFilterCard1b$ = <Stem> $CARD1b$ $I$* <CARD> <base> <native> $C$

% final basis in (uninflected) cardinal compounds like "sechzehn"
$BaseStemFilterCard10$ = <Stem> $CARD10$ $I$* <CARD> <base> <native> $C$

% final basis in ordinal compounds like "sechzehnte"
$BaseStemFilterOrd10$ = <Stem> $CARD10$ $I$* <CARD> <der> <-st> <native> <DB> ^$DerSuff-st$

% final basis in fractional compounds like "sechzehnte"
$BaseStemFilterFrac10$ = <Stem> $CARD10$ $I$* <CARD> <der> <-stel> <native> <DB> ^$DerSuff-stel$

% final basis in (uninflected) cardinal compounds like "hundertelf" and "hundertundelf"
$BaseStemFilterCard11$ = <Stem> $CARD11$ $I$* <CARD> <base> <native> $C$

% final basis in cardinal compounds like "einhundert"
$BaseStemFilterCard100$ = <Stem> $CARD100$ $I$* <CARD> <base> <native> $C$

% final basis in ordinal compounds like "einhundertste"
$BaseStemFilterOrd100$ = <Stem> $CARD100$ $I$* <CARD> <der> <-st> <native> <DB> ^$DerSuff-st$

% final basis in fractional compounds like "einhundertstel"
$BaseStemFilterFrac100$ = <Stem> $CARD100$ $I$* <CARD> <der> <-stel> <native> <DB> ^$DerSuff-stel$

% bases in derived cardinals like "sechzig"
$DerStemFilterCard2-zig$ = <Stem> $CARD2b$ <CARD> <der> <-zig> <native>

% bases in derived ordinals like "sechste"
$DerStemFilterCard2-st$ = <Stem> $CARD2a$ <CARD> <der> <-st> <native>

% bases in derived fractional numerals like "sechstel"
$DerStemFilterCard3-stel$ = <Stem> $CARD3b$ <CARD> <der> <-stel> <native>

% bases in derived ordinals like "zehnte"
$DerStemFilterCard10-st$ = <Stem> ($CARD10$ | $CARD11$) <CARD> <der> <-st> <native>

% bases in derived fractional numerals like "zehntel"
$DerStemFilterCard10-stel$ = <Stem> ($CARD10$ | $CARD11$) <CARD> <der> <-stel> <native>

% bases in derived ordinals like "hundertste"
$DerStemFilterCard100-st$ = <Stem> $CARD100$ <CARD> <der> <-st> <native>

% bases in derived ordinals like "hundertstel"
$DerStemFilterCard100-stel$ = <Stem> $CARD100$ <CARD> <der> <-stel> <native>

% initial bases in cardinal compounds like "einundsechzig" and "einhundert"
$CompStemFilterCard1c$ = <Stem> $CARD1c$ <CARD> <comp> <native>

% initial bases in cardinal compounds like "sechzehn"
$CompStemFilterCard3$ = <Stem> $CARD3a$ <CARD> <comp> <native>

% initial bases in cardinal compounds like "hunderteins" and "hundertundeins"
$CompStemFilterCard100$ = <Stem> $CARD100$ <CARD> <comp> <native>

$NUM$ = $BaseStemsDigCard$  | \
        $BaseStemsDigOrd$   | \
        $BaseStemsDigFrac$  | \
        $BaseStemsRoman$
