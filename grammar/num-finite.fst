% num-finite.fst
% Version 2.0
% Andreas Nolda 2025-07-10

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

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

$CARD1a$   = eins | zwei | drei | vier | fünf | sechs | sieben | acht | neun
$CARD1b$   = ein  | zwei | drei | vier | fünf | sechs | sieben | acht | neun
$CARD2$    =        zwan | drei | vier | fünf | sech  | sieb   | acht | neun
$CARD3$    =               drei | vier | fünf | sech  | sieb   | acht | neun
$CARD10$   = zehn
$CARD11$   = elf | zwölf
$CARD100$  = hundert

$I$ = [#index#]
$C$ = [#inflection#]:<Card0>

% final bases in cardinal compounds like "hunderteins" or "hundertundeins"
$BaseStemFilterCard1a$ = <Stem> $CARD1a$ $I$* <CARD> <base> <native> $C$

% final basis in (uninflected) cardinal compounds like "sechzehn"
$BaseStemFilterCard10$ = <Stem> $CARD10$ $I$* <CARD> <base> <native> $C$

% final basis in (uninflected) cardinal compounds like "hundertelf" or "hundertundelf"
$BaseStemFilterCard11$ = <Stem> $CARD11$ $I$* <CARD> <base> <native> $C$

% final basis in cardinal compounds like "einhundert"
$BaseStemFilterCard100$ = <Stem> $CARD100$ $I$* <CARD> <base> <native> $C$

% bases in derived cardinals like "sechzig"
$DerStemFilterCard2$ = <Stem> $CARD2$ <CARD> <der> <-zig> <native>

% initial bases in cardinal compounds like "einundsechzig" or "einhundert"
$CompStemFilterCard1b$ = <Stem> $CARD1b$ <CARD> <comp> <native>

% initial bases in cardinal compounds like "sechzehn"
$CompStemFilterCard3$  = <Stem> $CARD3$  <CARD> <comp> <native>

% initial bases in cardinal compounds like "hunderteins" or "hundertundeins"
$CompStemFilterCard100$ = <Stem> $CARD100$ <CARD> <comp> <native>

$NUM$ = $BaseStemsDigCard$  | \
        $BaseStemsDigOrd$   | \
        $BaseStemsDigFrac$  | \
        $BaseStemsRoman$
