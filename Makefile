SHELL := /bin/bash

all: sfst/build SMORLemma/smor.a SMORLemma/smor.ca

sfst/build:
	make -C sfst

SMORLemma/lexicon/lexicon:
	$(MAKE) -C lexicon

SMORLemma/smor.a SMORLemma/smor.ca: SMORLemma/lexicon/lexicon
	$(MAKE) -C SMORLemma -f ../Makefile.SMORLemma

# ---------------------------------------- Project setup

.PHONY: setup
setup: pip-install

.PHONY: pip-install
pip-install: requirements.txt
	pip install --upgrade pip
	pip install -r $<

# ---------------------------------------- Tests
.PHONY: test
test:
	@py.test -vv -s -x tests

# ---------------------------------------- Cleanup

.PHONY: clean
clean:
	$(RM) SMORLemma/lexicon/lexicon SMORLemma/*.a SMORLemma/*.ca

# ---------------------------------------- pyenv support

.PHONY: pyenv
pyenv:
	pyenv local ||\
		(pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

.PHONY: pyenv-clean
pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor
