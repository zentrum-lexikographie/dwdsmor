SHELL := /bin/bash

CLOJURE_VERSION := 1.10.3.943

LEXDIR = ../SMORLemma/lexicon
XSLDIR = ../share

LEX = $(LEXDIR)/lexicon
XSL = $(XSLDIR)/dwds2smorlemma.xsl
LIB = $(filter-out $(XSLDIR)/dwds2%.xsl, $(wildcard $(XSLDIR)/*.xsl))

all: $(LEX)

clean:
	$(RM) $(LEX)

$(LEX): clojure $(XSL) $(LIB)
	@./generate-lexicon\
		--xslt $(XSL)\
		--smorlemma-lexica\
		--filter\
		--output $@\
		wb

clojure: clojure-install.sh
	mkdir -p $@
	./clojure-install.sh --prefix $(CURDIR)/$@

clojure-install.sh:
	curl -o $@ https://download.clojure.org/install/linux-install-$(CLOJURE_VERSION).sh
	chmod +x $@
