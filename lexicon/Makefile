SHELL := /bin/bash

CLOJURE_VERSION := 1.10.3.943

../lexicon.fst: clojure
	clojure/bin/clojure -M -m dwdsmor.lexicon\
		-x ../share/dwds2smor.xsl\
		-o $@\
		../wb

clojure: clojure-install.sh
	mkdir -p $@
	./clojure-install.sh --prefix $(CURDIR)/$@

clojure-install.sh:
	curl -o $@ https://download.clojure.org/install/linux-install-$(CLOJURE_VERSION).sh
	chmod +x $@
