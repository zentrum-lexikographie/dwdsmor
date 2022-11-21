# Makefile
# Andreas Nolda 2022-11-21

FST_COMPILE = fst-compiler-utf8
FST_COMPACT = fst-compact

FST = dwdsmor.fst dwdsmor-finite.fst dwdsmor-index.fst

A  = $(addsuffix .a,$(basename $(FST)))
CA = $(addsuffix .ca,$(basename $(FST)))

INCLUDE_COMMON = symbols.fst map.fst flexion.fst markers.fst phon.fst disj.fst cleanup.fst
INCLUDE        = $(INCLUDE_COMMON) lemma.fst num.fst wf.fst punct.fst
INCLUDE_FINITE = $(INCLUDE_COMMON) lemma.fst num-finite.fst wf-finite.fst punct.fst
INCLUDE_INDEX  = $(INCLUDE_COMMON) lemma-index.fst wf-base.fst

LEX_COMMON = DWDS.lex aux.lex
LEX        = $(LEX_COMMON) DWDS-Red2.lex
LEX_FINITE = $(LEX_COMMON) DWDS-Red2.lex
LEX_INDEX  = $(LEX_COMMON)

INSTALLDIR ?= $(abspath ../lib)

all: $(A) $(CA)

%.ca: %.a
	$(FST_COMPACT) $< $@

dwdsmor.a: dwdsmor.fst $(LEX) $(INCLUDE)
	$(FST_COMPILE) $< $@
dwdsmor-finite.a: dwdsmor-finite.fst $(LEX_FINITE) $(INCLUDE_FINITE)
	$(FST_COMPILE) $< $@
dwdsmor-index.a: dwdsmor-index.fst $(LEX_INDEX) $(INCLUDE_INDEX)
	$(FST_COMPILE) $< $@

install: $(A) $(CA)
	mkdir -p $(INSTALLDIR)
	install -m 644 $(A) $(CA) $(INSTALLDIR)

clean:
	$(RM) $(A) $(CA)

.PHONY: all install clean
