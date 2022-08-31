% elim.fst
% Version 1.2
% Andreas Nolda 2022-08-31

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

ALPHABET = [#char# #morpheme_boundary_marker# #lemma-index# #paradigm-index# #stemtype# #feature# \
            <VPART><Old><NonSt><X><F>] \
           [<1><3>]:<13> \
           [<Dat><Acc>]:<DA> \
           [<Gen><Acc>]:<GA> \
           [<Gen><Dat>]:<GD> \
           [<Gen><Dat><Acc>]:<GDA> \
           [<Masc><Fem><Neut>]:<MFN> \
           [<Masc><Neut>]:<MN> \
           [<Nom><Acc>]:<NA> \
           [<Nom><Dat><Acc>]:<NDA> \
           [<Nom><Gen><Acc>]:<NGA> \
           [#case#]:<NGDA> \
           [<St><Wk>]:<SW> \
           [<Attr><Subst>]:<AS> \
           [<Pred><Adv>]:<PA>

$DISJ$ = .*

ALPHABET = [#char# #lemma-index# #paradigm-index# #feature# \
            <Old><NonSt><13><DA><GA><GD><GDA><MFN><MN><NA><NDA><NGA><NGDA><SW><AS><PA><F>]

$X$ = (. | \
       [<VPART>] <>:[#category#] <>:<X> | \
       <>:[#category#] <>:<base> <>:<X>)*

$ELIM$ = $DISJ$ || $X$
