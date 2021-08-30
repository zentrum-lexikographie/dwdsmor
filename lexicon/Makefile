SHELL := /bin/bash

CLOJURE_VERSION := 1.10.3.943

all: ../SMORLemma/lexicon/lexicon

clean:
	$(RM) ../SMORLemma/lexicon/lexicon

../SMORLemma/lexicon/lexicon: clojure
	clojure/bin/clojure -M -m dwdsmor.lexicon\
		-x ../share/dwds2smorlemma.xsl\
		-o $@\
		wb/WDG/ma/Mann-E_m_993.xml\
		wb/WDG/fr/Frau-E_f_7828.xml

clojure: clojure-install.sh
	mkdir -p $@
	./clojure-install.sh --prefix $(CURDIR)/$@

clojure-install.sh:
	curl -o $@ https://download.clojure.org/install/linux-install-$(CLOJURE_VERSION).sh
	chmod +x $@

