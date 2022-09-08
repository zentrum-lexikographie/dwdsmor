# Makefile
# Gregor Middell, Andreas Nolda 2022-09-08

SHELL := /bin/bash

CLOJURE_VERSION := 1.10.3.943

DIFF = diff -s -y -Z --suppress-common-lines -W 120

SRCDIR  = $(abspath wb)
SRCDIRS = $(wildcard $(SRCDIR)/*)
AUXDIR  = $(abspath aux)
LEXDIR  = $(abspath ../grammar)
XSLDIR  = $(abspath ../share)
TESTDIR = $(abspath test)

LEX     = $(LEXDIR)/DWDS.lex
LEXRED2 = $(LEXDIR)/DWDS-Red2.lex
LEXAUX  = $(LEXDIR)/aux.lex

EXCL = $(wildcard $(CURDIR)/exclude.list)

XSL = $(XSLDIR)/dwds2dwdsmor.xsl
LIB = $(filter-out $(XSLDIR)/dwds2%.xsl, $(wildcard $(XSLDIR)/*.xsl))

TESTINPUT  = $(TESTDIR)/input
TESTOUTPUT = $(TESTDIR)/output
TESTTARGET = $(TESTDIR)/target

TESTINPUTS  = $(wildcard $(TESTINPUT)/*.list)
TESTOUTPUTS = $(patsubst $(TESTINPUT)/%.list,$(TESTOUTPUT)/%.lex,$(TESTINPUTS))

all: lexicon

clojure: clojure-install.sh
	mkdir -p $@
	./clojure-install.sh --prefix $(CURDIR)/$@

clojure-install.sh:
	curl -o $@ https://download.clojure.org/install/linux-install-$(CLOJURE_VERSION).sh
	chmod +x $@

lexicon: $(LEX) $(LEXRED2) $(LEXAUX)

$(LEX): $(SRCDIRS) $(XSL) $(LIB)
	./generate-lexicon -x $(XSL) -e $(EXCL) -s Red-f -f -o $@ $(SRCDIR) 2> $(LEX).log

$(LEXRED2): $(SRCDIRS) $(XSL) $(LIB)
	./generate-lexicon -x $(XSL) -e $(EXCL) -s Red-2 -f -o $@ $(SRCDIR) 2> $(LEXRED2).log

$(LEXAUX): $(AUXDIR) $(XSL) $(LIB)
	./generate-lexicon -x $(XSL) -f -o $@ $(AUXDIR) 2> $(LEXAUX).log

debug: $(LEX).debug $(LEXRED2).debug $(LEXAUX).debug

$(LEX).debug: $(XSL) $(LIB)
	./generate-lexicon -x $(XSL) -e $(EXCL) -s Red-f -d -o $@ $(SRCDIR) 2> $(LEX).debug.log

$(LEXRED2).debug: $(XSL) $(LIB)
	./generate-lexicon -x $(XSL) -e $(EXCL) -s Red-2 -d -o $@ $(SRCDIR) 2> $(LEXRED2).debug.log

$(LEXAUX).debug: $(XSL) $(LIB)
	./generate-lexicon -x $(XSL) -d -o $@ $(AUXDIR) 2> $(LEXAUX).debug.log

test: $(TESTOUTPUTS)

$(TESTOUTPUT):
	mkdir -p $@

$(TESTOUTPUT)/%: $(TESTTARGET)/% $(XSL) $(LIB) $(TESTINPUTS) | $(TESTOUTPUT)
	./generate-lexicon -x $(XSL) -f -o $@ $(addprefix $(CURDIR)/,$(file < $(patsubst $(TESTTARGET)%.lex,$(TESTINPUT)%.list,$<))) 2> /dev/null
	@$(DIFF) $< $@ || true

clean: debugclean testclean
	$(RM) $(LEX) $(LEXRED2) $(LEXAUX) $(LEX).log $(LEXRED2).log $(LEXAUX).log

debugclean:
	$(RM) $(LEX).debug $(LEXRED2).debug $(LEXAUX).debug $(LEX).debug.log $(LEXRED2).debug.log $(LEXAUX).debug.log

testclean:
	$(RM) $(TESTOUTPUTS)

.PHONY: all clojure lexicon debug test clean debugclean testclean
