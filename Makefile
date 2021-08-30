SHELL := /bin/bash

SMORLemma/smor.a SMORLemma/smor.ca: sfst/build SMORLemma/lexicon/lexicon
	$(MAKE) -C SMORLemma -f ../Makefile.SMORLemma

# ---------------------------------------- Tests
.PHONY: test
test:
	@py.test -vv -s -x tests

# ---------------------------------------- Cleanup

.PHONY: clean
clean:
	$(RM) SMORLemma/*.a SMORLemma/*.ca

# ---------------------------------------- Project setup

.PHONY: setup
setup: pip-install sfst/build

.PHONY: pip-install
pip-install: requirements.txt
	pip install --upgrade pip
	pip install -r $<

sfst/build:
	make -C sfst

# ---------------------------------------- pyenv support

.PHONY: pyenv
pyenv:
	pyenv local ||\
		(pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

.PHONY: pyenv-clean
pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor
