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

Currently, the following DWDSmor editions are supported:

1. the **DWDS Edition**, derived from the complete lexical dataset of
   the [DWDS dictionary](https://www.dwds.de), and
2. the **Open Edition**, based on a sample selection of DWDS lemmas and
   their grammatical specifications.

The automata of the DWDS Edition are available upon request for research
purposes. The
[automata of the Open Edition](https://huggingface.co/zentrum-lexikographie/dwdsmor-open),
as well as its [sample source lexicon](lexicon/open/wb/open.xml), are released
freely for general use and experiments. For testing purposes, DWDSmor also
allows for compiling a development edition from a user-provided source lexicon.

The coverage of the released DWDSmor automata is measured against the
[German Universal Dependencies HDT treebank](https://universaldependencies.org/treebanks/de_hdt/index.html)
and reported on the
[Hugging Face Hub page](https://huggingface.co/zentrum-lexikographie).
In the DWDS Edition, the coverage ratios typically range from 95 % to 100 %
for most word classes; notable exceptions include foreign-language words
and named entities, which are barely part of the underlying DWDS dictionary
and thus poorly covered by DWDSmor. In the
[Open Edition](https://huggingface.co/zentrum-lexikographie/dwdsmor-open),
the coverage ratios of open word classes are lower, due to the limited size
of the sample source lexicon.


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
and `paradigm.py` in the `tools/` subdirectory:

```plaintext
$ ./tools/analysis.py -h
usage: analysis.py [-h] [-a] [-c] [-C] [-d AUTOMATA_DIR] [-e] [-H] [-I] [-j]
                   [-m] [-M] [-P] [-s] [-S] [-t {lemma,lemma2,finite,root,root2,index}]
                   [-T {lemma,lemma2,finite,root,root2,index}] [-v] [-y]
                   [input] [output]

positional arguments:
  input                 input file (one word form per line; default: stdin)
  output                output file (default: stdout)

options:
  -h, --help            show this help message and exit
  -a, --analysis-string output also analysis string
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -d AUTOMATA_DIR, --automata-dir AUTOMATA_DIR
                        automata directory
  -e, --empty           show empty columns or values
  -H, --no-header       suppress table header
  -I, --no-info         do not show analyses with info tags
  -j, --json            output JSON object
  -m, --minimal         prefer lemmas with minimal number of boundaries
  -M, --maximal         prefer word forms with maximal number of boundaries (requires secondary automaton)
  -P, --plain           suppress color and formatting
  -s, --seg-lemma       output also segmented lemma
  -S, --seg-word        output also segmented word form (requires secondary automaton)
  -t {lemma,lemma2,finite,root,root2,index}, --automaton-type {lemma,lemma2,finite,root,root2,index}
                        type of primary automaton (default: lemma)
  -T {lemma,lemma2,finite,root,root2,index}, --automaton2-type {lemma,lemma2,finite,root,root2,index}
                        type of secondary automaton (default: lemma2)
  -v, --version         show program's version number and exit
  -y, --yaml            output YAML document
```

```plaintext
$ ./tools/paradigm.py -h
usage: paradigm.py [-h] [-c] [-C] [-d AUTOMATA_DIR] [-e] [-H]
                   [-i {1,2,3,4,5,6,7,8}] [-I {1,2,3,4,5,6,7,8}] [-j] [-n] [-N] [-o] [-O]
                   [-p {NN,NPROP,ADJ,CARD,ORD,FRAC,ART,DEM,INDEF,POSS,PPRO,REL,WPRO,V}]
                   [-P] [-s] [-S] [-t {lemma,lemma2,finite,root,root2,index}] [-u] [-v] [-y]
                   lemma [output]

positional arguments:
  lemma                 lemma (determiners: Fem Nom Sg; nominalised adjectives: Wk)
  output                output file (default: stdout)

options:
  -h, --help            show this help message and exit
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -d AUTOMATA_DIR, --automata-dir AUTOMATA_DIR
                        automata directory
  -e, --empty           show empty columns or values
  -H, --no-header       suppress table header
  -i {1,2,3,4,5,6,7,8}, --lemma-index {1,2,3,4,5,6,7,8}
                        homographic lemma index
  -I {1,2,3,4,5,6,7,8}, --paradigm-index {1,2,3,4,5,6,7,8}
                        paradigm index
  -j, --json            output JSON object
  -n, --no-cats         do not output category names
  -N, --no-lemma        do not output lemma, lemma index, paradigm index, and lexical categories
  -o, --old             output also archaic forms
  -O, --oldorth         output also forms in old spelling
  -p {NN,NPROP,ADJ,CARD,ORD,FRAC,ART,DEM,INDEF,POSS,PPRO,REL,WPRO,V}, --pos {NN,NPROP,ADJ,CARD,ORD,FRAC,ART,DEM,INDEF,POSS,PPRO,REL,WPRO,V}
                        part of speech
  -P, --plain           suppress color and formatting
  -s, --nonst           output also non-standard forms
  -S, --ch              output also forms in Swiss spelling
  -t {lemma,lemma2,finite,root,root2,index}, --automaton-type {lemma,lemma2,finite,root,root2,index}
                        automaton type (default: index)
  -u, --user-specified  use only user-specified information
  -v, --version         show program's version number and exit
  -y, --yaml            output YAML document
```

Automata are searched in the following locations (in this order):

1. in the directory specified with option `-d`,
2. in edition subdirectories of `build/` if the environment variable
   `DWDSMOR_DEV` is set (as it is in [`.env.shared`](.env.shared)),
3. in the value of the environment variable `DWDSMOR_AUTOMATA_DIR`,
4. in the Hugging Face Hub repository in the value of the environment variable
   `DWDSMOR_HF_REPO_ID` (by default, `zentrum-lexikographie/dwdsmor-open`).


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

On a Debian-based distribution, the following command install the
required software:

```plaintext
apt-get install python3 default-jdk libsaxonhe-java sfst
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
pip install -U pip setuptools && pip install -e '.[dev]'
```


### Building lexica and automata

Building different editions is facilitated via the script `build-dwdsmor`:


```plaintext
$ ./build-dwdsmor -h
usage: cli.py [-h] [-e {dwds,open,dev}] [-t {lemma,lemma2,finite,root,root2,index}]
              [-m] [-f] [-q] [--release] [--tag]

Build DWDSmor.

options:
  -h, --help            show this help message and exit
  -e {dwds,open,dev}, --edition {dwds,open,dev}
                        edition to build (default: all)
  -t {lemma,lemma2,finite,root,root2,index}, --automaton-type {lemma,lemma2,finite,root,root2,index}
                        automaton type to build (default: all)
  -m, --with-metrics    measure UD/de-hdt coverage
  -f, --force           force building (also current targets)
  -q, --quiet           do not report progress
  --release             push automata to HF hub
  --tag                 tag HF hub release with current version
```

To build all editions available in the current git checkout, run:

```plaintext
./build-dwdsmor
```

The build result can be found in `build/` with one subdirectory per
edition.

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
