# DWDSmor – German morphology

![PyPI - Version](https://img.shields.io/pypi/v/dwdsmor)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/dwdsmor)
![GitHub License](https://img.shields.io/github/license/zentrum-lexikographie/dwdsmor)

DWDSmor implements the **lemmatisation and morphological analysis** of
word forms as well as the **generation of paradigms of lexical words**
in **written German**. Finite state transducers (automata) map word
forms to specifications of corresponding lexical words and tagging
which represents morphological properties. By traversing such
transducers

1. a given word form can be analysed and lemmatised, or
1. a lexical word together with a set of morphological tagging will
   generate corresponding inflected word forms.

The automata are compiled and traversed via
[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++
library and toolbox for finite-state transducers (FSTs). Their
coverage of the German language depends on

1. the DWDSmor grammar, defining the rules by which word formation happens, and
1. a lexicon, assigning inflection classes to lexical words.

## Usage

DWDSmor as a Python library is available via the package index PyPI:

``` plaintext
pip install dwdsmor
```

For lemmatisation:

``` python-console
>>> import dwsdmor
>>> lemmatizer = dwdsmor.lemmatizer()
>>> assert lemmatizer("getestet", pos={"+V"}) == "testen"
>>> assert lemmatizer("getestet", pos={"+ADJ"}) == "getestet"
```

…

## Development

This repository provides source code for building DWDSmor lexica and transducers
as well as for using DWDSmor transducers for morphological analysis and paradigm
generation:

* `dwdsmor/` contains Python packages for using DWDSmor, including
  scripts for morphological analysis and for paradigm generation by
  means of DWDSmor transducers.
* `share/` contains XSLT stylesheets for extracting lexical entries in SMORLemma
  format from XML sources of DWDS articles.
* `lexicon/dwds/` contains scripts for building DWDSmor lexica by means of the
  XSLT stylesheets in `share/` and DWDS sources in `lexicon/dwds/wb/`, which are
  not part of this repository.
* `lexicon/sample/` contains scripts for building sample DWDSmor lexica by means
  of the XSLT stylesheets in `share/` and the sample lexicon in
  `lexicon/sample/wb/`.
* `grammar/` contains an FST grammar derived from SMORLemma, providing the
  morphology for building DWDSmor automata from DWDSmor lexica.
* `test/` implements a test suite for the DWDSmor transducers.

DWDSmor is in active development. In its current stage, DWDSmor supports most
inflection classes and some productive word-formation patterns of written
German. Note that the sample lexicon in `lexicon/sample/wb/` only covers a
sketchy subset of the German vocabulary, and so do the DWDSmor automata compiled
from it.


## Prerequisites

[GNU/Linux](https://www.debian.org/)
: Development, builds and tests of DWDSmor are performed
  on [Debian GNU/Linux](https://debian.org/). While other UNIX-like operating
  systems such as MacOS should work, too, they are not actively supported.

[Python >= v3.9](https://www.python.org/)
: DWDSmor targets Python as its primary runtime environment. The DWDSmor
  transducers can be used via SFST's commandline tools, queried in Python
  applications via language-specific
  [bindings](https://github.com/gremid/sfst-transduce), or used by the Python
  scripts `dwdsmor.py` and `paradigm.py` for morphological analysis and for
  paradigm generation.

[Saxon-HE](https://www.saxonica.com/)
: The extraction of lexical entries from XML sources of DWDS articles is
  implemented in XSLT 2, for which Saxon-HE is used as the runtime environment.

[Java (JDK) >= v8](https://openjdk.java.net/)
:  Saxon requires a Java runtime.

[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/)
: a C++ library and toolbox for finite-state transducers (FSTs); please take a
  look at its homepage for installation and usage instructions.

On a Debian-based distribution, install the following packages:

```sh
apt install python3 default-jdk libsaxonhe-java sfst
```

Set up a virtual environment for project builds, for example via Python's `venv`:

```sh
python3 -m venv .venv
source .venv/bin/activate
```

Then run the DWDSmor setup routine in order to install Python dependencies:

```sh
pip install -e .[dev]
```


## Building DWDSmor lexica and transducers

For building DWDSmor lexica and transducers, run:

```sh
make all
```

Alternatively, you can run:

```sh
make dwds && make dwds-install && make dwdsmor
```

Note that these commands require DWDS sources in `lexicon/dwds/wb/`, which are
not part of this repository.

Alternatively, you can build sample DWDSmor lexica and transducers from the
sample lexicon in `lexicon/sample/wb/` by running:

```sh
make sample && make sample-install && make dwdsmor
```

After building DWDSmor transducers, install them into `lib/`, where the
Python scripts `dwdsmor` and `dwdsmor-paradigm` expect them by default:

```sh
make install
```

The installed DWDSmor transducers are:

* `lib/dwdsmor.{a,ca}`: transducer with inflection and word-formation
  components, for lemmatisation and morphological analysis of word forms in
  terms of grammatical categories
* `lib/dwdsmor-morph.{a,ca}`: transducer with inflection and word-formation
  components, for the generation of morphologically segmented word forms
* `lib/dwdsmor-finite.{a,ca}`: transducer with an inflection component and a
  finite word-formation component, for testing purposes
* `lib/dwdsmor-root.{a,ca}`: transducer with inflection and word-formation
  components, for lexical analysis of word forms in terms of root lemmas (i.e.,
  lemmas of ultimate word-formation bases), word-formation process,
  word-formation means, and grammatical categories in term of the
  Pattern-and-Restriction Theory of word formation (Nolda 2022)
* `lib/dwdsmor-index.{a,ca}`: transducer with an inflection component only with
  DWDS homographic lemma indices, for paradigm generation


## Testing DWDSmor

Run

    pytest

in order to test basic transducer usage and for potential regressions.

## Contact

Feel free to contact [Andreas Nolda](mailto:andreas.nolda@bbaw.de) for
questions regarding the lexicon or the grammar and
[Gregor Middell](mailto:gregor.middell@bbaw.de) for question related
to the integration of DWDSmor into your corpus-annotation pipeline.


## License

As the original SMOR and SMORLemma grammars, the DWDSmor grammar is
licensed under the GNU General Public Licence v2.0. The same applies
to the rest of this project.

## Credits

DWSDmor is based on the following software and datasets:

1. [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++ library
   and toolbox for finite-state transducers (FSTs) (Schmidt 2006)
2. [SMORLemma](https://github.com/rsennrich/SMORLemma) (Sennrich and Kunz 2014),
   a modified version of the Stuttgart Morphology
   ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/)) (Schmid, Fitschen, and
   Heid 2004) with an alternative lemmatisation component
3. the [DWDS dictionary](https://www.dwds.de/) (BBAW n.d.) replacing the
   [IMSLex](https://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/imslex/)
   (Fitschen 2004) as the lexical data source for German words, their grammatical
   categories, and their morphological properties.

## Bibliography

* Berlin-Brandenburg Academy of Sciences and Humanities (BBAW) (ed.) (n.d.).
  DWDS – Digitales Wörterbuch der deutschen Sprache: Das Wortauskunftssystem zur
  deutschen Sprache in Geschichte und Gegenwart.
  https://www.dwds.de
* Fitschen, Arne (2004). Ein computerlinguistisches Lexikon als komplexes
  System. Ph.D. thesis, Universität Stuttgart.
  [PDF](http://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/IMSLex/fitschendiss.pdf)
* Nolda, Andreas (2022). Headedness as an epiphenomenon: Case studies on
  compounding and blending in German. In *Headedness and/or Grammatical
  Anarchy?*, ed. by Ulrike Freywald, Horst Simon, and Stefan Müller, Empirically
  Oriented Theoretical Morphology and Syntax 11, Berlin: Language Science Press,
  343–376.
  [PDF](https://zenodo.org/record/7142720/files/336-FreywaldSimonMüller-2022-11.pdf).
* Schmid, Helmut (2006). A programming language for finite state transducers. In
  *Finite-State Methods and Natural Language Processing: 5th International
  Workshop, FSMNLP 2005, Helsinki, Finland, September 1–2, 2005*, ed. by Anssi
  Yli-Jyrä, Lauri Karttunen, and Juhani Karhumäki, Lecture Notes in Artificial
  Intelligence 4002, Berlin: Springer, 1263–1266.
  [PDF](https://www.cis.uni-muenchen.de/~schmid/papers/SFST-PL.pdf).
* Schmid, Helmut, Arne Fitschen, and Ulrich Heid (2004). SMOR: A German
  computational morphology covering derivation, composition, and inflection. In
  LREC 2004: Fourth International Conference on Language Resources and
  Evaluation, ed. by Maria T. Lino *et al.*, European Language Resources
  Association, 1263–1266.
  [PDF](http://www.lrec-conf.org/proceedings/lrec2004/pdf/468.pdf)
* Sennrich, Rico and Beta Kunz (2014). Zmorge: A German morphological lexicon
  extracted from Wiktionary. In LREC 2014: Ninth International Conference on
  Language Resources and Evaluation, ed. by Nicoletta Calzolari *et al.*,
  European Language Resources Association, 1063–1067.
  [PDF](http://www.lrec-conf.org/proceedings/lrec2014/pdf/116_Paper.pdf).
