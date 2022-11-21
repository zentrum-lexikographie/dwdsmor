% num-finite.fst
% Version 1.0
% Andreas Nolda 2022-11-21

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$DIGCARD$ = (<>:0)? [1-9][0-9]?

$DIGCARD0$ = $DIGCARD$ | 0

$DIGORD$ = $DIGCARD$ \.

$VULFRAC$ = [½⅓⅔¼¾⅕⅖⅗⅘⅙⅚⅐⅛⅜⅝⅞⅑⅒]

$DIGFRAC$ = $DIGCARD0$ \, [0-9]    | \
            $DIGCARD0$ / $DIGCARD$ | \
            $VULFRAC$

$ROMAN1$    = I | II | III | IV | V | VI | VII | VIII | IX
$ROMAN10$   = X | XX | XXX | XL | L | LX | LXX | LXXX | XC

$ROMAN$ =            $ROMAN1$ | \
          ($ROMAN10$ $ROMAN1$?)

$NUM$ = <Stem> $DIGCARD0$ <CARD><base><nativ><DigCard> | \
        <Stem> $DIGORD$   <ORD><base><nativ><DigOrd>   | \
        <Stem> $DIGFRAC$  <FRAC><base><nativ><DigFrac> | \
        <Stem> $ROMAN$    <CARD><base><nativ><Roman>
