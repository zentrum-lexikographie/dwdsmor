# Makefile
# Gregor Middell, Andreas Nolda 2022-09-08

DATETIME = $(shell date +%FT%TZ)
DATE     = $(shell echo $(DATETIME) | cut -c 1-4,6-7,9-10)

CPUS = $(shell nproc)
JOBS = $(shell expr $(CPUS) \* 3 / 4)

LEXDIR = $(CURDIR)/lexicon
SRCDIR = $(CURDIR)/grammar

INSTALLDIR = $(CURDIR)/lib

RELDIR    = $(CURDIR)/releases/$(DATE)
RELLIBDIR = $(RELDIR)/lib
RELSRCDIR = $(RELDIR)/src

RELFILES    = $(CURDIR)/BUILD \
              $(CURDIR)/VERSION \
              $(CURDIR)/dwdsmor.py \
              $(CURDIR)/paradigm.py
RELLIBFILES = $(wildcard $(INSTALLDIR)/*.a) \
              $(wildcard $(INSTALLDIR)/*.ca)
RELSRCFILES = $(SRCDIR)/Makefile \
              $(wildcard $(SRCDIR)/*.fst) \
              $(wildcard $(SRCDIR)/*.lex)

DISTDIR ?= /opt/dwdsmor

all: lexicon grammar
	echo $(DATE) > $(CURDIR)/VERSION
	echo $(DATETIME) > $(CURDIR)/BUILD

lexicon:
	$(MAKE) -C $(LEXDIR) all

grammar:
	$(MAKE) -j $(JOBS) -C $(SRCDIR) all

install:
	$(MAKE) -C $(SRCDIR) install INSTALLDIR=$(INSTALLDIR)

release:
	mkdir -p $(RELLIBDIR) $(RELSRCDIR)
	cp -a $(RELFILES) $(RELDIR)
	cp -a $(RELLIBFILES) $(RELLIBDIR)
	cp -a $(RELSRCFILES) $(RELSRCDIR)
	ln -s -r -f -n $(RELDIR) $(CURDIR)/releases/latest

dist:
	sudo rsync -a -v --exclude=/src/ $(RELDIR)/ $(DISTDIR)

clean:
	$(MAKE) -C $(SRCDIR) clean
	$(MAKE) -C $(LEXDIR) clean

setup: requirements.txt
	pip install --upgrade pip
	pip install -r $<
	make -C $(LEXDIR) clojure

test:
	@py.test -vv -s -x tests

pyenv:
	pyenv local || (pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor

.PHONY: all grammar lexicon install release dist test clean setup pyenv pyenv-clean
