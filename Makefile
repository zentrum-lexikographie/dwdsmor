# Makefile
# Gregor Middell, Andreas Nolda 2022-08-19

all: lexicon grammar

lexicon:
	$(MAKE) -C lexicon all

grammar:
	$(MAKE) -C grammar all

install:
	$(MAKE) -C grammar install INSTALL_DIR=$(CURDIR)/lib

clean:
	$(MAKE) -C grammar clean

distclean:
	$(MAKE) -C grammar clean

setup: requirements.txt
	pip install --upgrade pip
	pip install -r $<

test:
	@py.test -vv -s -x tests

pyenv:
	pyenv local || (pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor

.PHONY: all grammar lexicon install test clean distclean setup pyenv pyenv-clean
