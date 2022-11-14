# Makefile
# Andreas Nolda 2022-11-14

FST_COMPILE = fst-compiler-utf8
FST_COMPACT = fst-compact

FST = dwdsmor.fst dwdsmor-minimal.fst dwdsmor-index.fst

A  = $(addsuffix .a,$(basename $(FST)))
CA = $(addsuffix .ca,$(basename $(FST)))

INCLUDE_COMMON  = symbols.fst map.fst flexion.fst markers.fst phon.fst elim.fst cleanup.fst
INCLUDE         = $(INCLUDE_COMMON) lemma.fst num.fst
INCLUDE_INDEX   = $(INCLUDE_COMMON) lemma-index.fst
INCLUDE_MINIMAL = $(INCLUDE_COMMON) lemma.fst

LEX         = DWDS.lex DWDS-Red2.lex aux.lex
LEX_INDEX   = DWDS.lex aux.lex
LEX_MINIMAL = DWDS.lex

INSTALLDIR ?= $(abspath ../lib)

all: $(A) $(CA)

%.ca: %.a
	$(FST_COMPACT) $< $@

dwdsmor.a: dwdsmor.fst $(LEX) $(INCLUDE)
	$(FST_COMPILE) $< $@
dwdsmor-index.a: dwdsmor-index.fst $(LEX_INDEX) $(INCLUDE_INDEX)
	$(FST_COMPILE) $< $@
dwdsmor-minimal.a: dwdsmor-minimal.fst $(LEX_MINIMAL) $(INCLUDE_MINIMAL)
	$(FST_COMPILE) $< $@

install: $(A) $(CA)
	mkdir -p $(INSTALLDIR)
	install -m 644 $(A) $(CA) $(INSTALLDIR)

clean:
	$(RM) $(A) $(CA)

.PHONY: all install clean
