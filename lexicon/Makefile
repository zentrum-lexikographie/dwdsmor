SHELL := /bin/bash

CLOJURE_VERSION := 1.10.3.943

DIFF = diff --ignore-trailing-space --side-by-side --report-identical-files --suppress-common-lines --width=120

SRCDIR  = $(abspath wb)
LEXDIR  = $(abspath ../SMORLemma/lexicon)
XSLDIR  = $(abspath ../share)
TESTDIR = $(abspath test)

LEX = $(LEXDIR)/lexicon
XSL = $(XSLDIR)/dwds2smorlemma.xsl
LIB = $(filter-out $(XSLDIR)/dwds2%.xsl, $(wildcard $(XSLDIR)/*.xsl))

TESTINPUT  = $(TESTDIR)/input
TESTOUTPUT = $(TESTDIR)/output
TESTTARGET = $(TESTDIR)/target

TESTINPUTS  = $(wildcard $(TESTINPUT)/*.list)
TESTOUTPUTS = $(patsubst $(TESTINPUT)/%.list,$(TESTOUTPUT)/%.lex,$(TESTINPUTS))

INCLUDE_SMORLEMMA = true

ifeq ($(INCLUDE_SMORLEMMA),true)
  GENERATE_EXTRA_OPTIONS = --smorlemma-lexica
endif

all: lexicon

clojure: clojure-install.sh
	mkdir -p $@
	./clojure-install.sh --prefix $(CURDIR)/$@

clojure-install.sh:
	curl -o $@ https://download.clojure.org/install/linux-install-$(CLOJURE_VERSION).sh
	chmod +x $@

lexicon: $(LEX)

$(LEX): $(XSL) $(LIB)
	@./generate-lexicon --xslt $(XSL) $(GENERATE_EXTRA_OPTIONS) --filter --output $@ $(SRCDIR)

debug: $(LEX).debug

$(LEX).debug: $(XSL) $(LIB)
	@./generate-lexicon --xslt $(XSL) $(GENERATE_EXTRA_OPTIONS) --debug --output $@ $(SRCDIR) | tee $(LEX).log

test: $(TESTOUTPUTS)

$(TESTOUTPUT):
	mkdir -p $@

$(TESTOUTPUT)/%: $(TESTTARGET)/% $(XSL) $(LIB) $(LEX) $(TESTINPUTS) | $(TESTOUTPUT)
	@./generate-lexicon --xslt $(XSL) --filter --output $@ \
	  $(addprefix $(SRCDIR)/,$(file < $(patsubst $(TESTTARGET)%.lex,$(TESTINPUT)%.list,$<)))
	@$(DIFF) $< $@ || true

clean: debugclean testclean
	$(RM) $(LEX)

debugclean:
	$(RM) $(LEX).debug $(LEX).log

testclean:
	$(RM) $(TESTOUTPUTS)

.PHONY: all clojure lexicon debug test clean debugclean testclean
