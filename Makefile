# Makefile
# Gregor Middell, Andreas Nolda 2022-06-24

all: SMORLemma/smor-full.a SMORLemma/smor-full.ca

SMORLemma/smor-full.a SMORLemma/smor-full.ca: SMORLemma/lexicon/lexicon
	$(MAKE) -C SMORLemma -f ../SMORLemma.mk

install:
	$(MAKE) -C SMORLemma -f ../SMORLemma.mk install INSTALL_DIR=$(realpath lib)

test:
	@py.test -vv -s -x tests

clean:
	$(RM) SMORLemma/*.a SMORLemma/*.ca

setup: requirements.txt
	pip install --upgrade pip
	pip install -r $<

pyenv:
	pyenv local || (pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor

.PHONY: all install test clean setup pyenv pyenv-clean
