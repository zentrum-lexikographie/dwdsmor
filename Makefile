SHELL := /bin/bash

all: clean SMORLemma/smor.a SMORLemma/smor.ca test

SMORLemma/smor.a SMORLemma/smor.ca: SMORLemma/lexicon/wiki-lexicon.xml
	$(MAKE) -C SMORLemma

SMORLemma/lexicon/wiki-lexicon.xml:
	python -m dwdsmor.lexicon.cli --limit=1000 wb $@

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
		SMORLemma/lexicon/lexicon SMORLemma/lexicon/wiki-lexicon.xml\
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
