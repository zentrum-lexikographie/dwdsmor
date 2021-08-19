# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

## Prerequisites

* [GNU/Linux](https://www.debian.org/) (tested on Debian/Buster)
* [Python v3](https://www.python.org/)
* [SFST](http://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a toolbox for the
  implementation of morphological analysers and other tools which are based on
  finite state transducer technology
* [xsltproc](http://xmlsoft.org/xslt/)

## Setup

Install build prerequisites:

```sh
apt install build-essential cmake libsfst1-1.4-dev xsltproc
```

### Git Submodules

```sh
git submodule init
git submodule update
```

### Python setup

Optionally set up a virtual environment for project builds, i. e. via
[pyenv](https://github.com/pyenv/pyenv):

```sh
$ curl https://pyenv.run | bash
$ make pyenv
```

or python's venv

```sh
python3 -m venv .venv
source .venv/bin/activate
```

Then install the project and its dependencies:

```sh
make setup
```
## Compiling a lexicon and a SFST transducer

```sh 
make
```

## XSLT-based testbed for lexicon conversion

This repository also provides an XSLT 2 stylesheet for generating SMOR-compatible
lexicon entries from XML files in the DWDS format.

The stylesheets have been tested to work with Saxon 9.9, as provided by the Debian
package `libsaxonhe-java`. On Debian, they may be run as follows:

    java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform <XML file> share/dwds2smor.xsl

    java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform <XML file> share/dwds2smorlemma.xsl

Note that both stylesheets include the stylesheet `share/mappings.xsl` with
common mappings, functions, and templates.

Caveat: the stylesheets are meant as proof of concept and currently support only
a limited range of DWDS articles, such as "Mann", "Frau", "Kind", "alt", and
"orgeln".

For comparison, this repo also gathers a set of legacy XSLT stylesheets which
likewise generate SMOR-compatible lexicons from XML files:

* `legacy/fitschen/*.{xml,xsl}`:
  file contents listed in [Fitschen (2004: Anhang F)](http://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/IMSLex/fitschendiss.pdf)
* `legacy/morphisto/*.xslt`:
  part of the [Morphisto repo at Google Code](https://code.google.com/archive/p/morphisto/)
* `legacy/smorlemma/*.xslt`:
  part of the [SMORLemma repo at GitHub](https://github.com/rsennrich/SMORLemma/)

## License

Copyright &copy; 2021 Berlin-Brandenburg Academy of Sciences and Humanities.

This project is licensed under the GNU Lesser General Public License v3.0.
