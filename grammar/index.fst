% index.fst
% Version 11.0
% Andreas Nolda 2025-09-04

#include "module_symbols.fst"
#include "module_stemtype.fst"
#include "module_infl.fst"
#include "module_markers.fst"
#include "module_phon.fst"
#include "module_orth.fst"
#include "module_cleanup.fst"


% lexicon

$Lex$ = "lex.txt"

#include "macro_postlex.fst"


% stems

$BaseStems$ = $Lex$ || $BaseStemFilter$


% no word formation

#include "macro_postwf.fst"


% inflection

$Words$ = ($BaseStems$ $Infl$ || $InflFilter$) | \
          ($BaseStems$        || $NoInflFilter$)

#include "macro_postinfl-index.fst"


% (morpho)phonology

#include "macro_phon.fst"


% special forms

#include "macro_oldorth.fst"


% markers

#include "macro_postphon.fst"

#include "macro_boundaries.fst"


% further special forms

#include "macro_ch.fst"


% the resulting automaton

$Words$
