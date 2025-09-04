% module_punct.fst
% Version 2.0
% Andreas Nolda 2025-09-04

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$PunctComma$  = [#punctcomma#]
$PunctPeriod$ = [#punctperiod#]
$PunctEllip$  = [#punctellip#] | \.\.\.
$PunctQuote$  = [#punctquote#]
$PunctParen$  = [#punctparen#]
$PunctDash$   = [#punctdash#]
$PunctSlash$  = [#punctslash#]
$PunctOther$  = [#punctother#]

$Punct$ = $PunctComma$  {<PUNCT><Comma>}:{}  | \
          $PunctPeriod$ {<PUNCT><Period>}:{} | \
          $PunctEllip$  {<PUNCT><Ellip>}:{}  | \
          $PunctQuote$  {<PUNCT><Quote>}:{}  | \
          $PunctParen$  {<PUNCT><Paren>}:{}  | \
          $PunctDash$   {<PUNCT><Dash>}:{}   | \
          $PunctSlash$  {<PUNCT><Slash>}:{}  | \
          $PunctOther$  {<PUNCT><Other>}:{}
