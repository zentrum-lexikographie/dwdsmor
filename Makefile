SHELL := /bin/bash

all: clean sfst/build SMORLemma/smor.a SMORLemma/smor.ca

sfst/build: | sfst
	make -C $<

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
	$(RM) -r\
		SMORLemma/lexicon/wiki-lexicon.xml\
		SMORLemma/lexicon/lexicon\
		SMORLemma/lexicon/__pycache__\
		SMORLemma/*.a SMORLemma/*.ca\
		build *.egg-info *.cpython-38-x86_64-linux-gnu.so

# ---------------------------------------- pyenv support

.PHONY: pyenv
pyenv:
	pyenv local ||\
		(pyenv virtualenv zdl-dwdsmor && pyenv local zdl-dwdsmor)

.PHONY: pyenv-clean
pyenv-clean:
	pyenv local --unset && pyenv virtualenv-delete zdl-dwdsmor
