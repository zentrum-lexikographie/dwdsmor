% lemma-index.fst
% Version 1.3
% Andreas Nolda 2022-09-21

% based on code from SMORLemma by Rico Sennrich

ALPHABET = _$MORPH$

$C1$ = [^#lemma-index# #paradigm-index#]*<>:[#lemma-index#]?<>:[#paradigm-index#]?
$C2$ = [#lemma-index#]? [#paradigm-index#]?

$NN$ =  ($C1$ <>:<+NN><>:<Masc><>:<Nom><>:<Sg><>:<Wk>?   || $MORPH$) $C2$ <+NN><Masc>
$NN$ = (($C1$ <>:<+NN><>:<Fem><>:<Nom><>:<Sg><>:<Wk>?    || $MORPH$) $C2$ <+NN><Fem>)    | $NN$
$NN$ = (($C1$ <>:<+NN><>:<Neut><>:<Nom><>:<Sg><>:<Wk>?   || $MORPH$) $C2$ <+NN><Neut>)   | $NN$
$NN$ = (($C1$ <>:<+NN><>:<NoGend><>:<Nom><>:<Pl><>:<Wk>? || $MORPH$) $C2$ <+NN><NoGend>) | $NN$

$NPROP$ = (($C1$ <>:<+NPROP><>:<Masc><>:<Nom><>:<Sg>   || $MORPH$) $C2$ <+NPROP><Masc>)
$NPROP$ = (($C1$ <>:<+NPROP><>:<Fem><>:<Nom><>:<Sg>    || $MORPH$) $C2$ <+NPROP><Fem>)    | $NPROP$
$NPROP$ = (($C1$ <>:<+NPROP><>:<Neut><>:<Nom><>:<Sg>   || $MORPH$) $C2$ <+NPROP><Neut>)   | $NPROP$
$NPROP$ = (($C1$ <>:<+NPROP><>:<NoGend><>:<Nom><>:<Pl> || $MORPH$) $C2$ <+NPROP><NoGend>) | $NPROP$

$ADV$ = ($C1$ <>:<+ADV> || $MORPH$) $C2$ <+ADV>

$V$ = ($C1$ <>:<+V><>:<Inf> || $MORPH$) [#lemma-index#]? [#paradigm-index#]?<+V>

$ADJ$ = ($C1$ <>:<+ADJ><>:<Pos><>:<Pred/Adv>                     || $MORPH$) $C2$ <+ADJ>
$ADJ$ = ($C1$ <>:<+ADJ><>:<Sup><>:[<Attr><Attr/Subst>]<>:<Invar> || $MORPH$) $C2$ <+ADJ> | $ADJ$
$ADJ$ = ($C1$ <>:<+ADJ><>:[#degree#]<>:<Lemma>                   || $MORPH$) $C2$ <+ADJ> | $ADJ$

$LEMMA$ = $ADV$ | $NN$ | $NPROP$ | $V$ | $ADJ$

$CB$ = [#char# #morpheme_boundary_marker#]* [#char#] [#morpheme_boundary_marker#]:<>* \
       [#lemma-index#]? [#paradigm-index#]? [#part-of-speech#] [#feature#]*

$LEMMA$ = $LEMMA$ || $CB$

$LEMMA1$ = (^_$LEMMA$) .*

$LEMMA2$ = .* ([#part-of-speech#]-[<+V><+NN><+ADJ><+ADV><+NPROP>]) .*
