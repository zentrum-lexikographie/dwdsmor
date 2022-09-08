# Makefile
# Andreas Nolda 2022-09-08

FST_COMPILE = fst-compiler-utf8
FST_COMPACT = fst-compact

DWDSMOR         = dwdsmor.fst
DWDSMOR_INDEX   = dwdsmor-index.fst
DWDSMOR_MINIMAL = dwdsmor-minimal.fst

FST = $(DWDSMOR) $(DWDSMOR_MINIMAL) $(DWDSMOR_INDEX)

COMPILE = $(addsuffix .a,$(basename $(FST)))
COMPACT = $(addsuffix .ca,$(basename $(FST)))

TARGETS = $(COMPILE) $(COMPACT)

LEX         = DWDS.lex DWDS-Red2.lex aux.lex
LEX_INDEX   = DWDS.lex aux.lex
LEX_MINIMAL = aux.lex

INCLUDE         = symbols.fst map.fst flexion.fst markers.fst phon.fst elim.fst lemma.fst cleanup.fst
INCLUDE_INDEX   = $(filter-out $(INCLUDE),lemma.fst) lemma-index.fst
INCLUDE_MINIMAL = $(INCLUDE)

INSTALLDIR ?= $(realpath ../lib)

all: $(TARGETS)

%.ca: %.a
	$(FST_COMPACT) $< $@
%.a: %.fst
	$(FST_COMPILE) $< $@

$(DWDSMOR):         $(LEX) $(INCLUDE)
$(DWDSMOR_INDEX):   $(LEX_INDEX) $(INCLUDE_INDEX)
$(DWDSMOR_MINIMAL): $(LEX_MINIMAL) $(INCLUDE_MINIMAL)

install: $(TARGETS)
	mkdir -p $(INSTALLDIR)
	install -m 644 $(TARGETS) $(INSTALLDIR)

clean:
	$(RM) $(TARGETS)

.PHONY: all install clean
