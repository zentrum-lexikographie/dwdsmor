% punct.fst
% Version 1.0
% Andreas Nolda 2022-11-14

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

#include "symbols.fst"

$PUNCTCOMMA$  = \,
$PUNCTPERIOD$ = [\.\?\!\:;]
$PUNCTELLIP$  = (\.\.\.|…)
$PUNCTQUOTE$  = [\"\'„“‚‘»«›‹]
$PUNCTPAREN$  = [\(\)\[\]]
$PUNCTDASH$   = [-–]
$PUNCTSLASH$  = /

$PUNCT$ = $PUNCTCOMMA$  {<+PUNCT><Comma>}:{}  | \
          $PUNCTPERIOD$ {<+PUNCT><Period>}:{} | \
          $PUNCTELLIP$  {<+PUNCT><Ellip>}:{}  | \
          $PUNCTQUOTE$  {<+PUNCT><Quote>}:{}  | \
          $PUNCTPAREN$  {<+PUNCT><Paren>}:{}  | \
          $PUNCTDASH$   {<+PUNCT><Dash>}:{}   | \
          $PUNCTSLASH$  {<+PUNCT><Slash>}:{}
