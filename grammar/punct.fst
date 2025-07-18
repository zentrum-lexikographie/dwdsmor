% punct.fst
% Version 2.0
% Andreas Nolda 2025-06-30

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$PUNCTCOMMA$  = [#punctcomma#]
$PUNCTPERIOD$ = [#punctperiod#]
$PUNCTELLIP$  = [#punctellip#] | \.\.\.
$PUNCTQUOTE$  = [#punctquote#]
$PUNCTPAREN$  = [#punctparen#]
$PUNCTDASH$   = [#punctdash#]
$PUNCTSLASH$  = [#punctslash#]
$PUNCTOTHER$  = [#punctother#]

$PUNCT$ = $PUNCTCOMMA$  {<PUNCT><Comma>}:{}  | \
          $PUNCTPERIOD$ {<PUNCT><Period>}:{} | \
          $PUNCTELLIP$  {<PUNCT><Ellip>}:{}  | \
          $PUNCTQUOTE$  {<PUNCT><Quote>}:{}  | \
          $PUNCTPAREN$  {<PUNCT><Paren>}:{}  | \
          $PUNCTDASH$   {<PUNCT><Dash>}:{}   | \
          $PUNCTSLASH$  {<PUNCT><Slash>}:{}  | \
          $PUNCTOTHER$  {<PUNCT><Other>}:{}
