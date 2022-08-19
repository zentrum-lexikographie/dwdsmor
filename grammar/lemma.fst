% lemma.fst
% Version 1.0
% Andreas Nolda 2022-08-19

% based on code from SMORLemma by Rico Sennrich

ALPHABET = _$MORPH$

$NN$ = ((.*<>:<+NN><>:<Masc><>:<Nom><>:<Sg><>:<Wk>?   || $MORPH$) <+NN><Masc>)
$NN$ = ((.*<>:<+NN><>:<Fem><>:<Nom><>:<Sg><>:<Wk>?    || $MORPH$) <+NN><Fem>)    | $NN$
$NN$ = ((.*<>:<+NN><>:<Neut><>:<Nom><>:<Sg><>:<Wk>?   || $MORPH$) <+NN><Neut>)   | $NN$
$NN$ = ((.*<>:<+NN><>:<NoGend><>:<Nom><>:<Pl><>:<Wk>? || $MORPH$) <+NN><NoGend>) | $NN$

$NPROP$ = ((.*<>:<+NPROP><>:<Masc><>:<Nom><>:<Sg>   || $MORPH$) <+NPROP><Masc>)
$NPROP$ = ((.*<>:<+NPROP><>:<Fem><>:<Nom><>:<Sg>    || $MORPH$) <+NPROP><Fem>)    | $NPROP$
$NPROP$ = ((.*<>:<+NPROP><>:<Neut><>:<Nom><>:<Sg>   || $MORPH$) <+NPROP><Neut>)   | $NPROP$
$NPROP$ = ((.*<>:<+NPROP><>:<NoGend><>:<Nom><>:<Pl> || $MORPH$) <+NPROP><NoGend>) | $NPROP$

$ADV$ = (.*<>:<+ADV> || $MORPH$) <+ADV>

$V$ = (.*<>:<+V><>:<Inf> || $MORPH$) <+V>

$ADJ$ = (.*<>:<+ADJ><>:<Pos><>:[<Adv><Invar><Pred><Lemma>] || $MORPH$) <+ADJ>

$LEMMA$ = $ADV$ | $NN$ | $NPROP$ | $V$ | $ADJ$

$CB$ = [#char# #morpheme_boundary_marker#]* [#char#] [#morpheme_boundary_marker#]:<>* \
       [#part-of-speech#] [#feature#]*

$LEMMA$ = $LEMMA$ || $CB$

$LEMMA1$ = (^_$LEMMA$) .*

$LEMMA2$ = .* ([#part-of-speech#]-[<+V><+NN><+ADJ><+ADV><+NPROP>]) .*
