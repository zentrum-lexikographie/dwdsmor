% num.fst
% Version 1.0
% Andreas Nolda 2022-11-11

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$DIGCARD$ = 0                   | \
            (<>:0)? [1-9][0-9]* | \
            [1-9][0-9]?[0-9]? (\. [0-9][0-9][0-9])+

$DIGORD$ = $DIGCARD$ \.

$VULFRAC$ = [½⅓⅔¼¾⅕⅖⅗⅘⅙⅚⅐⅛⅜⅝⅞⅑⅒]

$DIGFRAC$ = $DIGCARD$ \, [0-9]+    | \
            $DIGCARD$ / $DIGCARD$  | \
            $VULFRAC$

$NUM$ = <Stem> $DIGCARD$ <CARD><base><nativ><DigCard> | \
        <Stem> $DIGORD$  <ORD><base><nativ><DigOrd>   | \
        <Stem> $DIGFRAC$ <FRAC><base><nativ><DigFrac>
