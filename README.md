# DWDSmor – German Morphology

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

1. the DWDSmor grammar, defining the rules by which word formation
   happens, and
1. a lexicon, declaring inflection classes and other morphological
   properties for covered lexical words.

The grammar, derived from
[SMORLemma](https://github.com/rsennrich/SMORLemma) and providing the
morphology for building automata from lexica, is common to all DWDSmor
installations and published as open source. In contrast we provide
**multiple lexica** resulting in different editions of DWDSmor:

1. the **DWDS Edition**, derived from the complete lexical dataset of
   the [DWDS dictionary](https://www.dwds.de/) and available upon
   request for research purposes,
1. the **Open Edition**, based on a subset of the DWDS, covering the
   most common word forms and released freely with the grammar for
   general use and experiments.

Depending on the edition and word class, coverage ranges from 70 to
100% with the notable exceptions of foreign language words and named
entities: Generally, both classes are not part of the underlying DWDS
dictionary and thus barely covered by DWDSmor. Current overall
coverage measured against the [German Universal Dependencies
treebank](https://universaldependencies.org/treebanks/de_hdt/index.html)
is documented on the respective [Hugging Face Hub
page](https://huggingface.co/zentrum-lexikographie) of each edition.


## Usage

DWDSmor as a Python library is available via the package index PyPI:

``` plaintext
pip install dwdsmor
```

The library can be used for lemmatisation:

``` python-console
>>> import dwdsmor
>>> lemmatizer = dwdsmor.lemmatizer()
>>> assert lemmatizer("getestet", pos={"+V"}) == "testen"
>>> assert lemmatizer("getestet", pos={"+ADJ"}) == "getestet"
```

Next to the Python API, the package provides a simple command line
interface named `dwdsmor`. To analyze a word form, pass it as an
argument:

```plaintext
$ dwdsmor getestet
| Wordform   | Lemma    | Analysis                            | POS   | Degree   | Function   | Nonfinite   | Tense   | Auxiliary   |
|------------|----------|-------------------------------------|-------|----------|------------|-------------|---------|-------------|
| getestet   | getestet | ge<~>test<~>et<+ADJ><Pos><Pred/Adv> | +ADJ  | Pos      | Pred/Adv   |             |         |             |
| getestet   | testen   | test<~>en<+V><Part><Perf><haben>    | +V    |          |            | Part        | Perf    | haben       |
```

To generate all word forms for a lexical word, pass it (or a form
which can be analyzed as the lexical word) as an argument together
with the option `-g`:

``` plaintext
$ dwdsmor -g getestet
[…]
| Wordform   | Lemma    | Analysis                                                    | POS   | Subcategory   | Degree   | Function   |   Person | Gender   | Case   | Number   | Nonfinite   | Tense   | Mood   | Auxiliary   | Inflection   |
|------------|----------|-------------------------------------------------------------|-------|---------------|----------|------------|----------|----------|--------|----------|-------------|---------|--------|-------------|--------------|
| getestete  | getestet | ge<~>test<~>et<+ADJ><Pos><Attr/Subst><Fem><Acc><Sg><St>     | +ADJ  |               | Pos      | Attr/Subst |          | Fem      | Acc    | Sg       |             |         |        |             | St           |
| getestete  | getestet | ge<~>test<~>et<+ADJ><Pos><Attr/Subst><Fem><Acc><Sg><Wk>     | +ADJ  |               | Pos      | Attr/Subst |          | Fem      | Acc    | Sg       |             |         |        |             | Wk           |
| getesteter | getestet | ge<~>test<~>et<+ADJ><Pos><Attr/Subst><Fem><Dat><Sg><St>     | +ADJ  |               | Pos      | Attr/Subst |          | Fem      | Dat    | Sg       |             |         |        |             | St           |
| getesteten | getestet | ge<~>test<~>et<+ADJ><Pos><Attr/Subst><Fem><Dat><Sg><Wk>     | +ADJ  |               | Pos      | Attr/Subst |          | Fem      | Dat    | Sg       |             |         |        |             | Wk           |
| getesteter | getestet | ge<~>test<~>et<+ADJ><Pos><Attr/Subst><Fem><Gen><Sg><St>     | +ADJ  |               | Pos      | Attr/Subst |          | Fem      | Gen    | Sg       |             |         |        |             | St           |
| getesteten | getestet | ge<~>test<~>et<+ADJ><Pos><Attr/Subst><Fem><Gen><Sg><Wk>     | +ADJ  |               | Pos      | Attr/Subst |          | Fem      | Gen    | Sg       |             |         |        |             | Wk           |
[…]
| testeten   | testen   | test<~>en<+V><1><Pl><Past><Ind>                             | +V    |               |          |            |        1 |          |        | Pl       |             | Past    | Ind    |             |              |
| testeten   | testen   | test<~>en<+V><1><Pl><Past><Subj>                            | +V    |               |          |            |        1 |          |        | Pl       |             | Past    | Subj   |             |              |
| testen     | testen   | test<~>en<+V><1><Pl><Pres><Ind>                             | +V    |               |          |            |        1 |          |        | Pl       |             | Pres    | Ind    |             |              |
| testen     | testen   | test<~>en<+V><1><Pl><Pres><Subj>                            | +V    |               |          |            |        1 |          |        | Pl       |             | Pres    | Subj   |             |              |
| testete    | testen   | test<~>en<+V><1><Sg><Past><Ind>                             | +V    |               |          |            |        1 |          |        | Sg       |             | Past    | Ind    |             |              |
| testete    | testen   | test<~>en<+V><1><Sg><Past><Subj>                            | +V    |               |          |            |        1 |          |        | Sg       |             | Past    | Subj   |             |              |
| teste      | testen   | test<~>en<+V><1><Sg><Pres><Ind>                             | +V    |               |          |            |        1 |          |        | Sg       |             | Pres    | Ind    |             |              |
| teste      | testen   | test<~>en<+V><1><Sg><Pres><Subj>                            | +V    |               |          |            |        1 |          |        | Sg       |             | Pres    | Subj   |             |              |
| testetet   | testen   | test<~>en<+V><2><Pl><Past><Ind>                             | +V    |               |          |            |        2 |          |        | Pl       |             | Past    | Ind    |             |              |
[…]
```

## Development

DWDSmor is in active development. In its current stage, it supports
most inflection classes and some productive word-formation patterns of
written German.


### Prerequisites

* [GNU/Linux](https://www.debian.org/): Development, builds and tests
  of DWDSmor are performed on [Debian
  GNU/Linux](https://debian.org/). While other UNIX-like operating
  systems such as MacOS should work, too, they are not actively
  supported.
* [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/): a C++
  library and toolbox for finite-state transducers (FSTs); please take
  a look at its homepage for installation and usage instructions.
* [Python >= v3.9](https://www.python.org/): DWDSmor targets Python as
  its primary runtime environment. The DWDSmor transducers can be used
  via SFST's commandline tools, queried in Python applications via
  language-specific
  [bindings](https://github.com/gremid/sfst-transduce), or used by the
  Python scripts `dwdsmor.py` and `paradigm.py` for morphological
  analysis and for paradigm generation.
* [Saxon-HE](https://www.saxonica.com/): The extraction of lexical
  entries from XML sources of DWDS articles is implemented in XSLT 2,
  for which Saxon-HE is used as the runtime environment. Saxon
  requires [Java](https://openjdk.java.net/)) as a runtime
  environment.

On a Debian-based distribution, the following command install the
required software:

```plaintext
apt-get install python3 default-jdk libsaxonhe-java sfst
```

### Project setup

Optionally, set up a Python virtual environment for project builds,
i. e. via Python's `venv`:

```plaintext
python3 -m venv .venv
source .venv/bin/activate
```

Then install DWDSmor, including development dependencies:

```plaintext
pip install -U pip setuptools && pip install -e '.[dev]'
```


### Building lexica and automata

Building different editions is facilitated via the script `build-dwdsmor`:


```plaintext
$ ./build-dwdsmor --help
usage: cli.py [-h] [--automaton AUTOMATON] [--force] [--with-metrics] [--release] [--tag]
              [editions ...]

Build DWDSmor.

positional arguments:
  editions              Editions to build (all by default)

options:
  -h, --help            show this help message and exit
  --automaton AUTOMATON
                        Automaton type to build (all by default)
  --force               Force building (also current targets)
  --with-metrics        Measure UD/de-hdt coverage
  --release             Push automata to HF hub
  --tag                 Tag HF hub release with current version
```

To build all editions available in the current git checkout, run:

```plaintext
./build-dwdsmor
```

The build result can be found in `build/` with one subdirectory per
edition. Each edition contains several automata types in standard and
compact format:


* `lemma.{a,ca}`: transducer with inflection and word-formation
  components, for lemmatisation and morphological analysis of word
  forms in terms of grammatical categories
* `morph.{a,ca}`: transducer with inflection and word-formation
  components, for the generation of morphologically segmented word
  forms
* `finite.{a,ca}`: transducer with an inflection component and a
  finite word-formation component, for testing purposes
* `root.{a,ca}`: transducer with inflection and word-formation
  components, for lexical analysis of word forms in terms of root
  lemmas (i.e., lemmas of ultimate word-formation bases),
  word-formation process, word-formation means, and grammatical
  categories in term of the Pattern-and-Restriction Theory of word
  formation (Nolda 2022)
* `index.{a,ca}`: transducer with an inflection component only with
  DWDS homographic lemma indices, for paradigm generation


### Testing

In order to test basic transducer usage and for potential regressions, run

    pytest

## License

As the original SMOR and SMORLemma grammars, the DWDSmor grammar and
Python library are licensed under the GNU General Public License
v2.0. The same applies to the open edition of the DWDSmor lexicon.

For the DWDS edition based on the complete DWDS dictionary, all rights
are reserved and individual license terms apply. If you are interested
in the DWDS edition, please contact us.

## Contact

Feel free to contact [Andreas Nolda](mailto:andreas.nolda@bbaw.de) for any
question about this project.

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

## References

* Berlin-Brandenburg Academy of Sciences and Humanities (BBAW) (ed.) (n.d.).
  DWDS – Digitales Wörterbuch der deutschen Sprache: Das Wortauskunftssystem zur
  deutschen Sprache in Geschichte und Gegenwart. [Online](https://www.dwds.de/)
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
