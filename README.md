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
2. a lexical word together with a set of morphological tagging will
   generate corresponding inflected word forms.

The DWDSmor automata are compiled and traversed via
[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++
library and toolbox for finite-state transducers (FSTs). In addition, a
DWDSmor Python library is provided, using the
[SFST Python bindings](https://github.com/gremid/sfst-transduce).

The coverage of the DWDSmor automata of the German language depends on

1. the DWDSmor grammar, which defines lemmatisation, inflection, and
   word-formation rules for written German, and
2. a DWDSmor lexicon, which declares lexical entries with lemmas, stem
   forms, word classes, and inflection classes of the covered lexical
   words.

While the DWDSmor grammar for word-formation is still work in progress,
its inflection grammar is very comprehensive. The inflection grammar as
well as the lexicon format are based on (heavily modified) code from
[SMORLemma](https://github.com/rsennrich/SMORLemma), which in turn is
derived from the Stuttgart Morphology
([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/)).

From the DWDSmor grammar and a DWDSmor lexicon, a DWDSmor edition can be
compiled, containing several automata types in standard (`.a`) and
compact format (`.ca`):

* `lemma.{a,ca}`: transducer with inflection and word-formation
  components, for lemmatisation and morphological analysis of word
  forms in terms of grammatical categories.
* `morph.{a,ca}`: transducer with inflection and word-formation
  components, for the generation of morphologically segmented word
  forms.
* `finite.{a,ca}`: transducer with an inflection component and a
  finite word-formation component, for testing purposes.
* `root.{a,ca}`: transducer with inflection and word-formation
  components, for lexical analysis of word forms in terms of root
  lemmas (i.e., lemmas of ultimate word-formation bases),
  word-formation process, word-formation means, and grammatical
  categories in term of the Pattern-and-Restriction Theory of word
  formation (Nolda 2022).
* `index.{a,ca}`: transducer with an inflection component only with
  DWDS homographic lemma indices, for paradigm generation.

Currently, the following DWDSmor editions are supported:

1. the **DWDS Edition**, derived from the complete lexical dataset of
   the [DWDS dictionary](https://www.dwds.de) and available upon
   request for research purposes, and
2. the **Open Edition**, based on a free subset of the grammatical
   specifications in the DWDS dictionary.

The Open Edition covers a sample of common German words and is released
freely with the grammar for general use and experiments.

Current overall coverage is measured against the
[German Universal Dependencies treebank](https://universaldependencies.org/treebanks/de_hdt/index.html)
and documented on the respective
[Hugging Face Hub page](https://huggingface.co/zentrum-lexikographie) of
each edition. In the DWDS Edition, coverage typically ranges from
95 % to 100 % for most word classes; notable exceptions include
foreign-language words and named entities, which are barely part of the
underlying DWDS dictionary and thus poorly covered by DWDSmor.


## Usage

The [DWDSmor Python library](https://pypi.org/project/dwdsmor/) is available via
the [Python Package Index (PyPI)](https://pypi.org):

``` plaintext
pip install dwdsmor
```

The library can be used for lemmatisation:

``` python-console
>>> import dwdsmor
>>> lemmatizer = dwdsmor.lemmatizer()
>>> assert lemmatizer("getestet", pos={"V"}).analysis == "testen"
>>> assert lemmatizer("getestet", pos={"ADJ"}).analysis == "getestet"
```

There is also integration with spacy:

``` python-console
>>> import spacy
>>> import dwdsmor.spacy
>>> nlp = spacy.load("de_hdt_lg")
>>> nlp.add_pipe("dwdsmor")
<dwdsmor.spacy.Component object at 0x7f99e634f220>
>>> tuple((t.lemma_, t._.dwdsmor.analysis) for t in nlp("Das ist ein Test."))
(('der', 'die'), ('sein', 'sein'), ('ein', 'eine'), ('Test', 'Test'), ('.', '.'))
```

In addition to the Python API, the package provides a simple
command-line interface named `dwdsmor`. To analyze a word form, pass it
as an argument:

```plaintext
$ dwdsmor gebildet
Wordform  	Lemma   	Analysis                           	POS  	Degree  	Function  	Nonfinite  	Tense  	Auxiliary
gebildet  	bilden  	bild<~>en<+V><Part><Perf><haben>   	V   	        	          	Part       	Perf   	haben
gebildet  	gebildet	ge<~>bild<~>et<+ADJ><Pos><Pred/Adv>	ADJ 	Pos     	Pred/Adv
```

To generate all word forms for a lexical word, pass it (or a form
which can be analyzed as the lexical word) as an argument together
with the option `-g`:

``` plaintext
$ dwdsmor -g gebildet
[…]
Wordform  	Lemma   	Analysis                                             	POS  	Degree  	Function  	  Person	Gender  	Case  	Number  	Nonfinite  	Tense  	Mood  	Auxiliary  	Inflection
[…]
gebildete 	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Acc><Sg><St>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Acc   	Sg      	           	       	      	           	St
gebildete 	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Acc><Sg><Wk>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Acc   	Sg      	           	       	      	           	Wk
gebildeter	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Dat><Sg><St>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Dat   	Sg      	           	       	      	           	St
gebildeten	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Dat><Sg><Wk>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Dat   	Sg      	           	       	      	           	Wk
gebildeter	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Gen><Sg><St>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Gen   	Sg      	           	       	      	           	St
gebildeten	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Gen><Sg><Wk>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Gen   	Sg      	           	       	      	           	Wk
gebildete 	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Nom><Sg><St>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Nom   	Sg      	           	       	      	           	St
gebildete 	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Fem><Nom><Sg><Wk>    	ADJ 	Pos     	Attr/Subst	        	Fem     	Nom   	Sg      	           	       	      	           	Wk
gebildeten	gebildet	gebildet<+ADJ><Pos><Attr/Subst><Masc><Acc><Sg><St>   	ADJ 	Pos     	Attr/Subst	        	Masc    	Acc   	Sg      	           	       	      	           	St
[…]
bildeten  	bilden  	bild<~>en<+V><1><Pl><Past><Ind>                      	V   	        	          	       1	        	      	Pl      	           	Past   	Ind
bildeten  	bilden  	bild<~>en<+V><1><Pl><Past><Subj>                     	V   	        	          	       1	        	      	Pl      	           	Past   	Subj
bilden    	bilden  	bild<~>en<+V><1><Pl><Pres><Ind>                      	V   	        	          	       1	        	      	Pl      	           	Pres   	Ind
bilden    	bilden  	bild<~>en<+V><1><Pl><Pres><Subj>                     	V   	        	          	       1	        	      	Pl      	           	Pres   	Subj
bildete   	bilden  	bild<~>en<+V><1><Sg><Past><Ind>                      	V   	        	          	       1	        	      	Sg      	           	Past   	Ind
bildete   	bilden  	bild<~>en<+V><1><Sg><Past><Subj>                     	V   	        	          	       1	        	      	Sg      	           	Past   	Subj
bilde     	bilden  	bild<~>en<+V><1><Sg><Pres><Ind>                      	V   	        	          	       1	        	      	Sg      	           	Pres   	Ind
bilde     	bilden  	bild<~>en<+V><1><Sg><Pres><Subj>                     	V   	        	          	       1	        	      	Sg      	           	Pres   	Subj
bildetet  	bilden  	bild<~>en<+V><2><Pl><Past><Ind>                      	V   	        	          	       2	        	      	Pl      	           	Past   	Ind
[…]
```

More sophisticated tools for analysis and paradigm generation with the
DWDSmor Python library are provided by the Python scripts `analysis.py`
and `paradigm.py` in the `tools/` subdirectory.


## Development

DWDSmor is in active development. In its current stage, it supports
most inflection classes and some productive word-formation patterns of
written German.


### Prerequisites

* [GNU/Linux](https://www.debian.org/): Development, builds and tests
  of DWDSmor are performed on [Debian GNU/Linux](https://debian.org/).
  While other UNIX-like operating systems such as MacOS should work,
  too, they are not actively supported.
* [Python >= v3.10](https://www.python.org/): DWDSmor provides a Python
  interface for building DWDSmor automata from XML sources of DWDS
  articles.
* [Saxon-HE](https://www.saxonica.com/): The extraction of lexical
  entries from XML sources of DWDS articles is implemented in XSLT 2,
  for which Saxon-HE is used as an XSLT processor. Saxon requires
  [Java](https://openjdk.java.net/)) as a runtime environment.
* [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/): The
  DWDSmor automata are compiled using the SFST C++ library and toolbox
  for finite-state transducers (FSTs).

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
edition.

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
   and toolbox for finite-state transducers (FSTs) (Schmidt 2006).
2. [SMORLemma](https://github.com/rsennrich/SMORLemma) (Sennrich and Kunz 2014),
   a modified version of the Stuttgart Morphology
   ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/)) (Schmid, Fitschen, and
   Heid 2004) with an alternative lemmatisation component.
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
