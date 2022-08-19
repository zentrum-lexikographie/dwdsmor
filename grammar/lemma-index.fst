% lemma-index.fst
% Version 1.0
% Andreas Nolda 2022-08-19

% based on code from SMORLemma by Rico Sennrich

ALPHABET = _$MORPH$

$NN$ =  ([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NN><>:<Masc><>:<Nom><>:<Sg><>:<Wk>?   || $MORPH$) [#lemma-index#]?<+NN><Masc>
$NN$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NN><>:<Fem><>:<Nom><>:<Sg><>:<Wk>?    || $MORPH$) [#lemma-index#]?<+NN><Fem>)    | $NN$
$NN$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NN><>:<Neut><>:<Nom><>:<Sg><>:<Wk>?   || $MORPH$) [#lemma-index#]?<+NN><Neut>)   | $NN$
$NN$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NN><>:<NoGend><>:<Nom><>:<Pl><>:<Wk>? || $MORPH$) [#lemma-index#]?<+NN><NoGend>) | $NN$

$NPROP$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NPROP><>:<Masc><>:<Nom><>:<Sg>   || $MORPH$) [#lemma-index#]?<+NPROP><Masc>)
$NPROP$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NPROP><>:<Fem><>:<Nom><>:<Sg>    || $MORPH$) [#lemma-index#]?<+NPROP><Fem>)    | $NPROP$
$NPROP$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NPROP><>:<Neut><>:<Nom><>:<Sg>   || $MORPH$) [#lemma-index#]?<+NPROP><Neut>)   | $NPROP$
$NPROP$ = (([^#lemma-index#]*<>:[#lemma-index#]?<>:<+NPROP><>:<NoGend><>:<Nom><>:<Pl> || $MORPH$) [#lemma-index#]?<+NPROP><NoGend>) | $NPROP$

$ADV$ = ([^#lemma-index#]*<>:[#lemma-index#]?<>:<+ADV> || $MORPH$) [#lemma-index#]?<+ADV>

$V$ = ([^#lemma-index#]*<>:[#lemma-index#]?<>:<+V><>:<Inf> || $MORPH$) [#lemma-index#]?<+V>

$ADJ$ = ([^#lemma-index#]*<>:[#lemma-index#]?<>:<+ADJ><>:<Pos><>:[<Adv><Invar><Pred><Lemma>] || $MORPH$) [#lemma-index#]?<+ADJ>

$LEMMA$ = $ADV$ | $NN$ | $NPROP$ | $V$ | $ADJ$

$CB$ = [#char# #morpheme_boundary_marker#]* [#char#] [#morpheme_boundary_marker#]:<>* \
       [#lemma-index#]? [#part-of-speech#] [#feature#]*

$LEMMA$ = $LEMMA$ || $CB$

$LEMMA1$ = (^_$LEMMA$) .*

$LEMMA2$ = .* ([#part-of-speech#]-[<+V><+NN><+ADJ><+ADV><+NPROP>]) .*
