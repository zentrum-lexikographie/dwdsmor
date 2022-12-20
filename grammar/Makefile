# Makefile
# Andreas Nolda 2022-12-20

FST_COMPILE = fst-compiler-utf8
FST_COMPACT = fst-compact

FST = dwdsmor.fst dwdsmor-finite.fst dwdsmor-index.fst

A  = $(addsuffix .a,$(basename $(FST)))
CA = $(addsuffix .ca,$(basename $(FST)))

INCLUDE_COMMON = symbols.fst level.fst map.fst stemtype.fst wf.fst \
                 flexion.fst markers.fst phon.fst disj.fst cleanup.fst
INCLUDE        = $(INCLUDE_COMMON) num.fst punct.fst cap.fst
INCLUDE_FINITE = $(INCLUDE_COMMON) num-finite.fst punct.fst cap.fst
INCLUDE_INDEX  = $(INCLUDE_COMMON)

LEX = dwds.lex

INSTALLDIR ?= $(abspath $(CURDIR)/../lib)

all: $(A) $(CA)

%.ca: %.a
	$(FST_COMPACT) $< $@

dwdsmor.a: dwdsmor.fst $(LEX) $(INCLUDE)
	$(FST_COMPILE) $< $@
dwdsmor-finite.a: dwdsmor-finite.fst $(LEX) $(INCLUDE_FINITE)
	$(FST_COMPILE) $< $@
dwdsmor-index.a: dwdsmor-index.fst $(LEX) $(INCLUDE_INDEX)
	$(FST_COMPILE) $< $@

install: $(A) $(CA)
	mkdir -p $(INSTALLDIR)
	install -m 644 $(A) $(CA) $(INSTALLDIR)

clean:
	$(RM) $(A) $(CA)

.PHONY: all install clean
