SHELL := /bin/bash

CLOJURE_VERSION := 1.10.3.943

LEXDIR = $(abspath ../SMORLemma/lexicon)
XSLDIR = $(abspath ../share)

LEX = $(LEXDIR)/lexicon
XSL = $(XSLDIR)/dwds2smorlemma.xsl
LIB = $(filter-out $(XSLDIR)/dwds2%.xsl, $(wildcard $(XSLDIR)/*.xsl))

INCLUDE_SMORLEMMA = true

ifeq ($(INCLUDE_SMORLEMMA),true)
  GENERATE_EXTRA_OPTIONS = --smorlemma-lexica
endif

all: $(LEX)

clean:
	$(RM) $(LEX)

$(LEX): clojure $(XSL) $(LIB)
	@./generate-lexicon --xslt $(XSL) --filter $(GENERATE_EXTRA_OPTIONS) --output $@ wb

clojure: clojure-install.sh
	mkdir -p $@
	./clojure-install.sh --prefix $(CURDIR)/$@

clojure-install.sh:
	curl -o $@ https://download.clojure.org/install/linux-install-$(CLOJURE_VERSION).sh
	chmod +x $@
