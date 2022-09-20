% lemma.fst
% Version 1.2
% Andreas Nolda 2022-09-20

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

$ADJ$ = (.*<>:<+ADJ><>:<Pos><>:[<Invar><Lemma><NonAttr>] || $MORPH$) <+ADJ>

$LEMMA$ = $ADV$ | $NN$ | $NPROP$ | $V$ | $ADJ$

$CB$ = [#char# #morpheme_boundary_marker#]* [#char#] [#morpheme_boundary_marker#]:<>* \
       [#part-of-speech#] [#feature#]*

$LEMMA$ = $LEMMA$ || $CB$

$LEMMA1$ = (^_$LEMMA$) .*

$C$ = [^#lemma-index# #paradigm-index#]*<>:[#lemma-index#]?<>:[#paradigm-index#]?

$LEMMA2$ = $C$ ([#part-of-speech#]-[<+V><+NN><+ADJ><+ADV><+NPROP>]) .*
