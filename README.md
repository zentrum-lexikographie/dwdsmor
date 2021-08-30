# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

This project aims at developing a component for **morphological analysis of
German word forms** mainly for **decomposing compound words** and
**lemmatisation**. To this end we adopt

1. [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++ library
   and toolbox for finite state transducers (FSTs),
1. [SMORLemma](https://github.com/rsennrich/SMORLemma), a modified version of
   the Stuttgart Morphology ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/))
   with an alternative lemmatisation component, and the
1. [DWDS dictionary](https://www.dwds.de/) replacing
   [IMSLex](https://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/imslex/)
   as the as the lexical data source for word components and their respective
   morphological annotations (part-of-speech, inflection class etc.).

Source code in this repository implements various steps in the process of
building and using FSTs for morphological analysis:

* [`lexicon/`](lexicon/) and [`share/`](share/) contain sources for extracting
  SMOR-compatible lexicon entries from DWDS/XML documents comprising the lexical
  database.
* [`sfst/`](sfst/) and [`SMORLemma/`](SMORLemma/) import sources from upstream
  repositories as Git submodules, providing the mentioned FST library, the
  morphology as well as Python bindings for applying compiled FSTs.
* [`dwdsmor/`](dwdsmor/) and [`tests/`](tests/) implement a Python library and
  accompanying test suite for using DWDSmor transducers for the aforementioned
  linguistic tasks.

## Prerequisites

[GNU/Linux](https://www.debian.org/)
: Development, builds and tests of DWDSmor are performed on [Debian
  GNU/Linux](https://debian.org/) (currently v10 “Buster”). While other
  UNIX-like operating systems (i. e. MacOS) might work, they are not supported.

[Python v3 (including dev headers)](https://www.python.org/)
: DWDSmor targets Python as its primary runtime environment. Building a
  transducer involves other languages and platforms as well; for example XSLT
  and Clojure on the JVM for lexicon generation. But ultimately, compiled
  transducers are supposed to be used via SFST's commandline tools or to be
  queried in Python applications via the included
  [bindings](https://github.com/gremid/sfst). As the bindings are compiled as
  part of the DWDSmor build, resources for compiling Python extensions (header
  files, C/C++ compiler, GNU make) must be installed.

[Java (JDK) >= v8](https://openjdk.java.net/)
: The extraction of lexicon entries from DWDS/XML articles files is implemented
  in XSLT 2, for which [Saxon-HE](https://www.saxonica.com/) is used as the
  runtime environment. The conversion of the whole dictionary (or larger parts)
  is orchestrated via a [Clojure](https://clojure.org/) script, running multiple
  XSLT pipelines in parallel and doing some pre- and postprocessing. Saxon and
  Clojure both require a Java runtime.

[CMake v3.1](https://cmake.org/)
: dependency of SFST build

[Bison](https://www.gnu.org/software/bison/) and [Flex
v2.6.4](https://github.com/westes/flex)
: dependency SFST command line tooling, i.e. compiler or automaton compaction

On a recent Debian GNU/Linux, install the following packages:

```sh
apt install\
    build-essential cmake bison flex\
    python3 libpython3-dev\
    default-jdk
```

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

## Extract the lexicon from the DWDS dictionary

Import the dictionary sources via the configured submodule in
[`lexicon/wb/`](lexicon/wb/):

```sh
git submodule init lexicon/wb
git submodule update lexicon/wb
```

**Note**: The imported Git repository is large, containing about 260.000 XML
documents and their edit history of several years. Therefore the lexicon
extraction should not be performed in environments with [strict
quotas](https://www.hlrn.de/doc/display/PUB/Fixing+Quota+Issues) on the number
of files/inodes, e.g. on the HLRN-IV/ZIB compute cluster. For a workflow
leveraging HLRN's hardware resources for FST compilation, consider building a
current lexicon locally and uploading it to HLRN-IV for further processing.

Given the dictionary sources a lexicon can be built via:

```sh 
make -C lexicon
```

The result is stored in `SMORLemma/lexicon/lexicon` where is is included in the
FST compilation process of SMORLemma.

## Prepare FST builds

Initialize and update submodules incorporating

```sh
git submodule init sfst SMORLemma
git submodule update sfst SMORLemma
```

Then setup :

```sh
make setup
```

## Compiling a lexicon and a SFST transducer

```sh 
make
```

## Building on HLRN-IV („Lise”)

Prepare the build environment On the login host:

```sh
/scratch/usr/bembbaw0/dwdsmor/hlrn/setup
```

Upload a lexicon:

```sh
scp $LEXICON bembbaw0@blogin.hlrn.de:/scratch/usr/bembbaw0/dwdsmor/SMORLemma/lexicon/lexicon
```

Run the build on a compute host:

```sh
srun /scratch/usr/bembbaw0/dwdsmor/hlrn/build 
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
