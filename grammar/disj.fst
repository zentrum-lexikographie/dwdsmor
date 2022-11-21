% disj.fst
% Version 2.0
% Andreas Nolda 2022-11-21

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

ALPHABET = [#char# #morpheme-boundary# #lemma-index# #paradigm-index# #feature# \
            <VPART><Old><NonSt>] \
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
           [<Attr><Subst>]:<AS>

$DISJ$ = .*
