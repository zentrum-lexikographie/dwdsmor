# Makefile
# Andreas Nolda 2022-11-30

DATETIME = $(shell date +%FT%T%z)
DATE     = $(shell echo $(DATETIME) | cut -c 1-4,6-7,9-10)

CPUS = $(shell nproc)
JOBS = $(shell expr $(CPUS) \* 3 / 4)

LEXDIR = $(CURDIR)/lexicon
SRCDIR = $(CURDIR)/grammar

INSTALLDIR = $(CURDIR)/lib

RDIR    = $(CURDIR)/releases/$(DATE)
RLIBDIR = $(RDIR)/lib
RSRCDIR = $(RDIR)/src

RFILES    = $(CURDIR)/BUILD \
            $(CURDIR)/VERSION \
            $(CURDIR)/dwdsmor.py \
            $(CURDIR)/paradigm.py
RLIBFILES = $(wildcard $(INSTALLDIR)/*.a) \
            $(wildcard $(INSTALLDIR)/*.ca)
RSRCFILES = $(SRCDIR)/Makefile \
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
	mkdir -p $(RLIBDIR) $(RSRCDIR)
	cp -a $(RFILES) $(RDIR)
	cp -a $(RLIBFILES) $(RLIBDIR)
	cp -a $(RSRCFILES) $(RSRCDIR)
	ln -s -r -f -n $(RDIR) $(CURDIR)/releases/latest

dist:
	sudo rsync -r -t -v --exclude=/src/ $(RDIR)/ $(DISTDIR)

clean:
	$(MAKE) -C $(SRCDIR) clean
	$(MAKE) -C $(LEXDIR) clean

setup: requirements.txt
	pip install --upgrade pip
	pip install -r $<

test:
	@py.test -vv -s -x tests

pyenv:
	pyenv local || (pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor

.PHONY: all grammar lexicon install release dist test clean setup pyenv pyenv-clean
