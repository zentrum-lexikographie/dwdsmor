SHELL := /bin/bash

SMORLemma/smor.a SMORLemma/smor.ca: SMORLemma/lexicon/lexicon
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
setup: requirements.txt
	pip install --upgrade pip
	pip install -r $<

# ---------------------------------------- pyenv support

.PHONY: pyenv
pyenv:
	pyenv local ||\
		(pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

.PHONY: pyenv-clean
pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor
