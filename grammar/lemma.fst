% lemma.fst
% Version 19.0
% Andreas Nolda 2025-09-04

#include "module_symbols.fst"
#include "module_stemtype.fst"
#include "module_wf.fst"
#include "module_num.fst"
#include "module_infl.fst"
#include "module_markers.fst"
#include "module_phon.fst"
#include "module_sep.fst"
#include "module_trunc.fst"
#include "module_orth.fst"
#include "module_punct.fst"
#include "module_cleanup.fst"


% lexicon

$Lex$ = "lex.txt"

$Lex$ = $Lex$ | $NumLex$

#include "macro_surface.fst"

#include "macro_postlex.fst"


% stems

$BaseStems$ = $Lex$ || $BaseStemFilter$
$DerStems$  = $Lex$ || $DerStemFilter$
$CompStems$ = $Lex$ || $CompStemFilter$


% word formation

#include "macro_der-num.fst"
#include "macro_comp-num.fst"

#include "macro_der-prev.fst"

#include "macro_conv-v.fst"
#include "macro_conv-adj.fst"

#include "macro_der-suff.fst"
#include "macro_der-pref.fst"

#include "macro_comp.fst"

#include "macro_postwf.fst"


% inflection

$Words$ = ($BaseStems$ $Infl$ || $InflFilter$) | \
          ($BaseStems$        || $NoInflFilter$)

#include "macro_postinfl.fst"


% (morpho)phonology

#include "macro_phon.fst"
#include "macro_phon-lv2.fst"


% special forms

#include "macro_sep.fst"

#include "macro_trunc.fst"

#include "macro_oldorth.fst"


% markers

#include "macro_postphon.fst"

#include "macro_boundaries.fst"

#include "macro_indices.fst"


% further special forms

#include "macro_ch.fst"

#include "macro_cap.fst"


% punctuation

$Words$ = $Words$ | $Punct$


% the resulting automaton

$Words$
