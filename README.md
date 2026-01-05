# DWDSmor – German Morphology

![PyPI - Version](https://img.shields.io/pypi/v/dwdsmor)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/dwdsmor)
![GitHub License](https://img.shields.io/github/license/zentrum-lexikographie/dwdsmor)

DWDSmor implements the **lemmatisation** and **morphosyntactic analysis**
of word forms as well as the **generation of paradigms** of lexical words
in **written German**. DWDSmor’s finite state transducers (the DWDSmor
automata) map word forms to specifications of corresponding lexical words
and morphosyntactic categories. By traversing such transducers

1. a given word form can be analysed and lemmatised, or
2. a lexical word together with a set of morphosyntactic tags will
   generate corresponding inflected word forms.

The DWDSmor automata are compiled and traversed via
[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++
library and toolbox for finite-state transducers (FSTs). In addition, a
DWDSmor Python library is provided, using the
[SFST Python bindings](https://github.com/gremid/sfst-transduce).

The coverage of the DWDSmor automata of the German language depends on

1. a DWDSmor lexicon, which declares lexical entries with lemmas, stem
   forms, word classes, inflection classes, etc., and
2. the DWDSmor grammar, which defines lemmatisation, inflection, and
   word-formation rules for written German.

While the DWDSmor grammar for word-formation is still work in progress,
its inflection grammar is pretty comprehensive. The inflection grammar as
well as the lexicon format are based on (heavily modified) code from
[SMORLemma](https://github.com/rsennrich/SMORLemma), which in turn is
derived from the Stuttgart Morphology
([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/)).

As a rule, the entries in a DWDSmor lexicon are extracted from a source
lexicon comprising a set of XML files in the
[format](https://github.com/zentrum-lexikographie/lex/tree/master/oxygen/framework/rnc) of the
[DWDS dictionary](https://www.dwds.de).

From a DWDSmor lexicon and the DWDSmor grammar, a DWDSmor edition with several
automata types can be compiled:

* `lemma`: automaton with inflection and word-formation components, for
  lemmatisation and morphosyntactic analysis of word forms in terms of
  grammatical categories.
* `lemma2`: variant of `lemma`, for the generation of morphologically segmented
  word forms.
* `finite`: variant of `lemma` with a finite word-formation component, for
  testing purposes.
* `root`: automaton with inflection and word-formation components, for lexical
  analysis of word forms in terms of root lemmas (i.e., lemmas of ultimate
  word-formation bases), word-formation process, word-formation means, and
  grammatical categories in term of the Pattern-and-Restriction Theory of word
  formation (Nolda 2022).
* `root2`: variant of `root`, for the generation of morphologically segmented
  word forms.
* `index`: automaton with an inflection component only with DWDS homographic
  lemma indices, for paradigm generation.

Automata are built in two formats: in standard format (with file extension `.a`)
for generation and in compact format (with file extension `.ca`) for analysis.

DWDSmor is released in two editions:

1. the **Open Edition**, based on a sample selection of DWDS lemmas and
   their grammatical specifications, and
1. the **DWDS Edition**, derived from the complete lexical dataset of
   the [DWDS dictionary](https://www.dwds.de).

The _DWDS Edition_ is only available upon request for research
purposes while the _Open Edition_ is released freely for general use
and experiments.

The coverage of DWDSmor is benchmarked regularly against the [German
Universal Dependencies HDT
treebank](https://universaldependencies.org/treebanks/de_hdt/index.html).
In the _DWDS Edition_, the coverage ratios typically range from 95 %
to 100 % for most word classes; notable exceptions include
foreign-language words and named entities, which are barely part of
the underlying DWDS dictionary and thus poorly covered by DWDSmor. In
the _Open Edition_, the coverage ratios of open word classes are
lower, due to the limited size of the sample source lexicon.


## Usage

The [DWDSmor Open Edition](https://pypi.org/project/dwdsmor/) is
available via the [Python Package Index (PyPI)](https://pypi.org):

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

There is also integration with spaCy:

```plaintext
pip install spacy de_zdl_lg --extra-index-url https://gitup.uni-potsdam.de/api/v4/projects/21461/packages/pypi/simple
```

``` python-console
>>> import spacy
>>> import dwdsmor.spacy
>>> nlp = spacy.load("de_zdl_lg")
>>> nlp.add_pipe("dwdsmor")
<dwdsmor.spacy.Component object at 0x7f99e634f220>
>>> tuple(t._.dwdsmor.analysis for t in nlp("Man sah neben diversen ICEs auch viele schöne Altbauten."))
('man', 'sehen', 'neben', 'divers', 'ICE', 'auch', 'viel', 'schön', 'Altbau', '.')
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
and `paradigm.py` in the `tools/` subdirectory. For their usage, cf. the
output of the following commands:

```plaintext
$ tools/analysis.py -h
```

```plaintext
$ tools/paradigm.py -h
```

### Installing the DWDS Edition

Should you have been granted access to the DWDS edition, please add
your private access token to `$HOME/.netrc`:

```plaintext
machine gitup.uni-potsdam.de login gitlab-ci-token password glpat-…
```

Then install the edition:

```plaintext
pip install dwdsmor-dwds --index-url https://gitup.uni-potsdam.de/api/v4/projects/21585/packages/pypi/simple
```

## Development

DWDSmor is in active development. In its current stage, it supports all
major inflection classes and some productive word-formation patterns of
written German.


### Prerequisites

* [GNU/Linux](https://www.debian.org/): Development, builds and tests
  of DWDSmor are performed on [Debian GNU/Linux](https://debian.org/).
  While other UNIX-like operating systems such as MacOS should work,
  too, they are not actively supported.
* [Python ≥ v3.12](https://www.python.org/): DWDSmor provides a Python
  interface for building DWDSmor lexica from source lexica in the DWDS
  [XML format](https://github.com/zentrum-lexikographie/lex/tree/master/oxygen/framework/rnc)
  and for compiling DWDSmor automata from the resulting DWDSmor lexica and
  the DWDSmor grammar.
* [Saxon-HE](https://www.saxonica.com/): The entries in DWDSmor lexica are
  extracted from source lexica in the DWDS
  [XML format](https://github.com/zentrum-lexikographie/lex/tree/master/oxygen/framework/rnc)
  by means of XSLT 2 stylesheets, using Saxon-HE as an XSLT processor.
  Saxon requires a [Java](https://openjdk.java.net/) runtime environment.
* [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/): The
  DWDSmor automata are compiled using the SFST C++ library and toolbox
  for finite-state transducers (FSTs).

On a Debian-based distribution, the following command installs the
required software:

```plaintext
sudo apt install python3 default-jdk libsaxonhe-java sfst
```

### Project setup

Optionally, set up a Python virtual environment for project builds,
i. e. via Python’s `venv`:

```plaintext
python3 -m venv .venv
source .venv/bin/activate
```

Then install DWDSmor, including development dependencies:

```plaintext
pip install -U pip setuptools && pip install -r requirements.dev.txt
```

### Building the DWDS edition

Install additional dependencies:

```plaintext
pip install -U pip setuptools && pip install -r requirements.dwds.txt
```

Download the lexicon:

```
GITUP_PRIVATE_TOKEN="…"  python -m dwdsmor.build.dwdswb
```

### Building lexica and automata

Building different editions and automata is facilitated via the
`dwdsmor.build` module. To build the default Open Edition, simply run:

```plaintext
python -m dwdsmor.build
```

For more build options, run:

```plaintext
python -m dwdsmor.build -h
```


### Testing

In order to test for basic automata functionality and potential regressions, run

    pytest

## License

As the original SMOR and SMORLemma grammars, the DWDSmor grammar and the
DWDSmor Python library are licensed under the GNU General Public License
v2.0. The same applies to the sample source lexicon and the automata of the
Open Edition.

For the DWDS Edition based on the complete DWDS dictionary, all rights
are reserved and individual license terms apply. If you are interested
in the automata of the DWDS Edition, please contact us.

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
   categories, and their morphosyntactic properties.

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
