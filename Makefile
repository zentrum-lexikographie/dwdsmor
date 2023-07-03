# Makefile
# Andreas Nolda 2023-07-03

DATETIME = $(shell date +%FT%T%z)
DATE     = $(shell echo $(DATETIME) | cut -c 1-4,6-7,9-10)

CPUS = $(shell nproc)
JOBS = $(shell expr $(CPUS) \* 3 / 4)

SRCDIR = $(CURDIR)/grammar
LEXDIR = $(CURDIR)/lexicon

DWDSDIR   = $(LEXDIR)/dwds
SAMPLEDIR = $(LEXDIR)/sample

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

all: dwds dwds-install dwdsmor
	echo $(DATE) > $(CURDIR)/VERSION
	echo $(DATETIME) > $(CURDIR)/BUILD

dwds:
	$(MAKE) -C $(DWDSDIR) all

dwds-install:
	$(MAKE) -C $(DWDSDIR) install

sample:
	$(MAKE) -C $(SAMPLEDIR) all

sample-install:
	$(MAKE) -C $(SAMPLEDIR) install

dwdsmor:
	$(MAKE) -j $(JOBS) -C $(SRCDIR) all

install:
	$(MAKE) -C $(SRCDIR) install

release:
	mkdir -p $(RLIBDIR) $(RSRCDIR)
	cp -a $(RFILES) $(RDIR)
	cp -a $(RLIBFILES) $(RLIBDIR)
	cp -a $(RSRCFILES) $(RSRCDIR)
	ln -s -r -f -n $(RDIR) $(CURDIR)/releases/latest

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

.PHONY: all dwds dwds-install sample sample-install dwdsmor install release test clean setup pyenv pyenv-clean
