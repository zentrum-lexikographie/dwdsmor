# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

This project provides a component for the lemmatisation and morphological
analysis of word forms as well as for the generation of paradigms of lexical
words in written German. To this end we adopt:

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

This repository provides source code for building DWDSmor lexica and transducers
as well as for using DWDSmor transducers for morphological analysis and paradigm
generation:

* `share/` contains XSLT stylesheets for extracting lexical entries in SMORLemma
  format form XML sources of DWDS articles. Sample inputs and outputs can be
  found in `samples/`.
* `lexicon/dwds/` contains scripts for building DWDSmor lexica by means of the
  XSLT stylesheets in `share/` and DWDS sources in `lexicon/dwds/wb/`, which are
  not part of this repository.
* `lexicon/sample/` contains scripts for building sample DWDSmor lexica by means
  of the XSLT stylesheets in `share/` and the sample lexicon in
  `lexicon/sample/wb/`.
* `grammar/` contains an FST grammar derived from SMORLemma, providing the
  morphology for building DWDSmor automata from DWDSmor lexica.
* `test/` implements a test suite for the DWDSmor transducers.
* `dwdsmor.py` and `paradigm.py` are user-level Python scripts for morphological
  analysis and for paradigm generation by means of DWDSmor transducers.

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

Set up a virtual environment for project builds via Python's `venv`:

```sh
python3 -m venv .venv
source .venv/bin/activate
```

Then run the DWDSmor setup routine in order to install Python dependencies:

```sh
make setup
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
user-level Python scripts `dwdsmor.py` and `paradigm.py` expect them by default:

```sh
make install
```

The installed DWDSmor transducers are:

* `lib/dwdsmor.{a,ca}`: transducer with inflection and word-formation
  components, for lemmatisation and morphological analysis of word forms in
  terms of grammatical categories
* `lib/dwdsmor-finite.{a,ca}`: transducer with an inflection component and a
  finite word-formation component, for testing purposes
* `lib/dwdsmor-root.{a,ca}`: transducer with inflection and word-formation
  components, for lexical analysis of word forms in terms of root lemmas (i.e.,
  lemmas of ultimate word-formation bases), word-formation process,
  word-formation means, and grammatical categories in term of the
  Pattern-and-Restriction Theory of word formation (Nolda 2022)
* `lib/dwdsmor-index.{a,ca}`: transducer with an inflection component only with
  DWDS homographic lemma indices, for paradigm generation


## Testing DWDSmor transducers

The installed DWDSmor transducers can be examined with the test suite in
`test/`. It provides coverage tests and regression tests.

The coverage tests are run with the following command:

```sh
make test-coverage
```

Coverage test reports and statistics are saved as TSV tables in `test/reports/`
and `test/summaries/`, respectively.

Individual coverage tests can be run by calling `test/Makefile` as below:

```sh
make -C test test-dwds-lemma-coverage
```

```sh
make -C test test-sample-lemma-coverage
```

```sh
make -C test test-tuebadz-lemma-coverage
```

```sh
make -C test test-dwds-paradigm-coverage
```

```sh
make -C test test-sample-paradigm-coverage
```

The `test-dwds-lemma-coverage` and `test-dwds-paradigm-coverage` targets of
`test/Makefile` require DWDS sources in `lexicon/dwds/wb/` (not part of this
repository). The `test-tuebadz-lemma-coverage` target presupposes a TüBa-D/Z
treebank export `tuebadz-11.0-exportXML-v2.xml` at `test/data/tuebadz/`
(likewise not part of this repository).

Note that runs of the `test-dwds-paradigm-coverage` and
`test-sample-paradigm-coverage` targets of `test/Makefile` may take a
considerable amount of time.

Regression tests compare generated test results to saved snapshots in
`test/reports/`. To create the snapshots, first run:

```sh
make test-snapshot
```

Then, in order to test for regressions which may arise from changes of lexicon,
grammar, or user-level scripts, run:

```sh
make test-regression
```

Regression test targets can also be run individually by calling `test/Makefile`
as follows:

```sh
make -C test test-analysis-snapshot
```

```sh
make -C test test-paradigm-snapshot
```

```sh
make -C test test-analysis-regression
```

```sh
make -C test test-paradigm-regression
```


## Using DWDSmor

DWDSmor provides two Python scripts for using the DWDSmor transducers.

`dwdsmor.py` is a Python script for the lemmatisation and morphological analysis
of word forms in written German by means of a DWDSmor transducer:

```plaintext
$ ./dwdsmor.py -h
usage: dwdsmor.py [-h] [-c] [-C] [-E] [-H] [-I] [-j] [-m] [-n] [-N] [-P] [-t TRANSDUCER]
                  [-v] [-W] [-y] [input] [output]

positional arguments:
  input                 input file (one word form per line; default: stdin)
  output                output file (default: stdout)

optional arguments:
  -h, --help            show this help message and exit
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -E, --no-empty        do not output empty columns or values
  -H, --no-header       suppress table header
  -I, --no-index        do not output lemma and paradigm index
  -j, --json            output JSON object
  -m, --minimal         prefer analyses with minimal number of stem boundaries
  -n, --no-analysis     do not output raw analysis
  -N, --no-segmentation
                        do not output segmented lemma
  -P, --plain           suppress color and formatting
  -t TRANSDUCER, --transducer TRANSDUCER
                        path to transducer file (default: lib/dwdsmor.ca)
  -v, --version         show program's version number and exit
  -W, --no-wf           do not output word-formation process and means
  -y, --yaml            output YAML document
```

By default, `dwdsmor.py` prints a TSV table on standard output:

```plaintext
$ echo "Ihr\nkönnt\neuch\nauf\nden\nKinderbänken\nausruhen\n." | ./dwdsmor.py -E -n
Wordform	Lemma	Segmentation	POS	Subcategory	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metalinguistic	Characters
Ihr	Sie	Sie	PPRO	Pers	3	NoGend	Gen	Pl						Old
Ihr	sie	sie	PPRO	Pers	3	NoGend	Gen	Pl						Old	CAP
Ihr	sie	sie	PPRO	Pers	3	Fem	Dat	Sg							CAP
Ihr	sie	sie	PPRO	Pers	3	Fem	Gen	Sg						Old	CAP
Ihr	ihr	ihr	PPRO	Pers	2		Nom	Pl							CAP
Ihr	ihre	ihre	POSS			Neut	Acc	Sg	NoInfl	Attr					CAP
Ihr	ihre	ihre	POSS			Neut	Nom	Sg	NoInfl	Attr					CAP
Ihr	ihre	ihre	POSS			Masc	Nom	Sg	NoInfl	Attr					CAP
Ihr	Ihre	Ihre	POSS			Neut	Acc	Sg	NoInfl	Attr
Ihr	Ihre	Ihre	POSS			Neut	Nom	Sg	NoInfl	Attr
Ihr	Ihre	Ihre	POSS			Masc	Nom	Sg	NoInfl	Attr
könnt	können	könn<~>en	V		2			Pl				Ind	Pres
euch	euch	euch	PPRO	Refl	2		Acc	Pl
euch	euch	euch	PPRO	Refl	2		Dat	Pl
euch	ihr	ihr	PPRO	Pers	2		Acc	Pl
euch	ihr	ihr	PPRO	Pers	2		Dat	Pl
auf	auf	auf	ADV
auf	auf	auf	PREP
den	die	die	REL			Masc	Acc	Sg	St	Subst
den	die	die	DEM			Masc	Acc	Sg	St	Subst
den	die	die	DEM			NoGend	Dat	Pl	St	Attr
den	die	die	DEM			Masc	Acc	Sg	St	Attr
den	die	die	ART	Def		Masc	Acc	Sg	St	Subst
den	die	die	ART	Def		NoGend	Dat	Pl	St	Attr
den	die	die	ART	Def		Masc	Acc	Sg	St	Attr
Kinderbänken	Kinderbank	Kind<~>er<#>bank	NN			Fem	Dat	Pl
ausruhen	ausruhen	aus<#>ruh<~>en	V		3			Pl				Subj	Pres
ausruhen	ausruhen	aus<#>ruh<~>en	V		3			Pl				Ind	Pres
ausruhen	ausruhen	aus<#>ruh<~>en	V		1			Pl				Subj	Pres
ausruhen	ausruhen	aus<#>ruh<~>en	V		1			Pl				Ind	Pres
ausruhen	ausruhen	aus<#>ruh<~>en	V								Inf
.	.	.	PUNCT	Period

```

The transducer can be selected as an argument of option `-t`:

```plaintext
$ echo "Ihr\nkönnt\neuch\nauf\nden\nKinderbänken\nausruhen\n." | ./dwdsmor.py -E -n -t lib/dwdsmor-root.ca
Wordform	Lemma	Segmentation	Process	Means	POS	Subcategory	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metalinguistic	Characters
Ihr	sie	sie			PPRO	Pers	3	NoGend	Gen	Pl						Old	CAP
Ihr	sie	sie			PPRO	Pers	3	Fem	Dat	Sg							CAP
Ihr	sie	sie			PPRO	Pers	3	Fem	Gen	Sg						Old	CAP
Ihr	Sie	Sie			PPRO	Pers	3	NoGend	Gen	Pl						Old
Ihr	ihr	ihr			PPRO	Pers	2		Nom	Pl							CAP
Ihr	ihre	ihre			POSS			Neut	Acc	Sg	NoInfl	Attr					CAP
Ihr	ihre	ihre			POSS			Neut	Nom	Sg	NoInfl	Attr					CAP
Ihr	ihre	ihre			POSS			Masc	Nom	Sg	NoInfl	Attr					CAP
Ihr	Ihre	Ihre			POSS			Neut	Acc	Sg	NoInfl	Attr
Ihr	Ihre	Ihre			POSS			Neut	Nom	Sg	NoInfl	Attr
Ihr	Ihre	Ihre			POSS			Masc	Nom	Sg	NoInfl	Attr
könnt	können	könn<~>en			V		2			Pl				Ind	Pres
euch	euch	euch			PPRO	Refl	2		Acc	Pl
euch	euch	euch			PPRO	Refl	2		Dat	Pl
euch	ihr	ihr			PPRO	Pers	2		Acc	Pl
euch	ihr	ihr			PPRO	Pers	2		Dat	Pl
auf	auf	auf			ADV
auf	auf	auf			PREP
den	die	die			REL			Masc	Acc	Sg	St	Subst
den	die	die			DEM			Masc	Acc	Sg	St	Subst
den	die	die			DEM			NoGend	Dat	Pl	St	Attr
den	die	die			DEM			Masc	Acc	Sg	St	Attr
den	die	die			ART	Def		Masc	Acc	Sg	St	Subst
den	die	die			ART	Def		NoGend	Dat	Pl	St	Attr
den	die	die			ART	Def		Masc	Acc	Sg	St	Attr
Kinderbänken	Kind + Bank	Kind<+>Bank	COMP	concat	NN			Fem	Dat	Pl
ausruhen	ruhen	ruh<~>en	DER	part(aus)	V		3			Pl				Subj	Pres
ausruhen	ruhen	ruh<~>en	DER	part(aus)	V		3			Pl				Ind	Pres
ausruhen	ruhen	ruh<~>en	DER	part(aus)	V		1			Pl				Subj	Pres
ausruhen	ruhen	ruh<~>en	DER	part(aus)	V		1			Pl				Ind	Pres
ausruhen	ruhen	ruh<~>en	DER	part(aus)	V								Inf
.	.	.			PUNCT	Period

```

CSV, JSON, and YAML outputs are available with options `-c`, `-j`, and `-y`
respectively.

`paradigm.py` is Python script for the generation of paradigms of lexical words
in written German by means of a DWDSmor transducer:

```plaintext
$ ./paradigm.py -h
usage: paradigm.py [-h] [-c] [-C] [-E] [-H] [-i {1,2,3,4,5}] [-I {1,2,3,4,5}] [-j] [-n] [-N]
                   [-o] [-O] [-p {ADJ,ART,CARD,DEM,INDEF,NN,NPROP,POSS,PPRO,REL,V,WPRO}] [-P]
                   [-s] [-S] [-t TRANSDUCER] [-u] [-v] [-y] lemma [output]

positional arguments:
  lemma                 lemma (determiners: Fem Nom Sg; nominalised adjectives: Wk)
  output                output file (default: stdout)

optional arguments:
  -h, --help            show this help message and exit
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -E, --no-empty        do not output empty columns or values
  -H, --no-header       suppress table header
  -i {1,2,3,4,5}, --lemma-index {1,2,3,4,5}
                        homographic lemma index
  -I {1,2,3,4,5}, --paradigm-index {1,2,3,4,5}
                        paradigm index
  -j, --json            output JSON object
  -n, --no-cats         do not output category names
  -N, --no-lemma        do not output lemma, lemma index, paradigm index, and lexical categories
  -o, --old             output also archaic forms
  -O, --oldorth         output also forms in old spelling
  -p {ADJ,ART,CARD,DEM,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}, --pos {ADJ,ART,CARD,DEM,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}
                        part of speech
  -P, --plain           suppress color and formatting
  -s, --nonst           output also non-standard forms
  -S, --ch              output also forms in Swiss spelling
  -t TRANSDUCER, --transducer TRANSDUCER
                        transducer file (default: lib/dwdsmor-index.a)
  -u, --user-specified  use only user-specified information
  -v, --version         show program's version number and exit
  -y, --yaml            output YAML document
```

By default, `paradigm.py` outputs a similar TSV table as `dwdsmor.py`:

```plaintext
$ ./paradigm.py -E Bank
Lemma	Lemma Index	POS	Gender	Case	Number	Paradigm Forms
Bank	1	NN	Fem	Nom	Sg	Bank
Bank	1	NN	Fem	Acc	Sg	Bank
Bank	1	NN	Fem	Dat	Sg	Bank
Bank	1	NN	Fem	Gen	Sg	Bank
Bank	1	NN	Fem	Nom	Pl	Bänke
Bank	1	NN	Fem	Acc	Pl	Bänke
Bank	1	NN	Fem	Dat	Pl	Bänken
Bank	1	NN	Fem	Gen	Pl	Bänke
Bank	2	NN	Fem	Nom	Sg	Bank
Bank	2	NN	Fem	Acc	Sg	Bank
Bank	2	NN	Fem	Dat	Sg	Bank
Bank	2	NN	Fem	Gen	Sg	Bank
Bank	2	NN	Fem	Nom	Pl	Banken
Bank	2	NN	Fem	Acc	Pl	Banken
Bank	2	NN	Fem	Dat	Pl	Banken
Bank	2	NN	Fem	Gen	Pl	Banken
```

For a condensed version, the options `-n` and `-N` can be specified. The DWDS
homographic lemma index can be selected with option `-i`:

```plaintext
$ ./paradigm.py -n -N -i 1 Bank
Paradigm Categories	Paradigm Forms
Nom Sg	Bank
Acc Sg	Bank
Dat Sg	Bank
Gen Sg	Bank
Nom Pl	Bänke
Acc Pl	Bänke
Dat Pl	Bänken
Gen Pl	Bänke
```

The default transducer for paradigm generation is `dwdsmor-index.a` and
restricted to inflection only. Paradigms for word-formation products which are
unavailable in the DWDS can be generated with the transducer `dwdsmor.a`:
```plaintext
$ ./paradigm.py -n -N -t lib/dwdsmor.a Kinderbank
Paradigm Categories	Paradigm Forms
Nom Sg	Kinderbank
Acc Sg	Kinderbank
Dat Sg	Kinderbank
Gen Sg	Kinderbank
Nom Pl	Kinderbanken, Kinderbänke
Acc Pl	Kinderbanken, Kinderbänke
Dat Pl	Kinderbanken, Kinderbänken
Gen Pl	Kinderbanken, Kinderbänke
```
Note that this transducer does not know of DWDS homographic lemma indices.

Again, options `-c`, `-j`, `-y` select alternative CSV, JSON, and YAML outputs.


## Contact

Feel free to contact [Andreas Nolda](mailto:andreas.nolda@bbaw.de) for
questions regarding the lexicon or the grammar and
[Gregor Middell](mailto:gregor.middell@bbaw.de) for question related
to the integration of DWDSmor into your corpus-annotation pipeline.


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


## License

As the original SMOR and SMORLemma grammars, the DWDSmor grammar is licensed
under the GNU General Public Licence v2.0. The rest of this project is licensed
under the GNU Lesser General Public License v3.0.

Andreas Nolda <andreas.nolda@bbaw.de>
