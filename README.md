# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

![PyPI - Version](https://img.shields.io/pypi/v/dwdsmor)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/dwdsmor)
![GitHub License](https://img.shields.io/github/license/zentrum-lexikographie/dwdsmor)

DWDSmor implements the lemmatisation and morphological analysis of
word forms as well as the generation of paradigms of lexical words in
written German.

## Usage

DWDSmor is available via PyPI:

    pip install dwdsmor

For lemmatisation:

    >>> import dwsdmor
    >>> lemmatizer = dwdsmor.lemmatizer()
    >>> assert lemmatizer("getestet", {"+V"}) == "testen"
    >>> assert lemmatizer("getestet", {"+ADJ"}) == "getestet"
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

Set up a virtual environment for project builds via Python's `venv`:

```sh
python3 -m venv .venv
source .venv/bin/activate
```

Then run the DWDSmor setup routine in order to install Python dependencies:

```sh
# make setup
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
make -C test test-dwds-paradigm-coverage
```

```sh
make -C test test-sample-paradigm-coverage
```

The `test-dwds-lemma-coverage` and `test-dwds-paradigm-coverage` targets of
`test/Makefile` require DWDS sources in `lexicon/dwds/wb/` (not part of this
repository).

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

`dwdsmor` is a Python script for the lemmatisation and morphological analysis
of word forms in written German by means of a DWDSmor transducer:

```plaintext
$ dwdsmor -h
usage: dwdsmor [-h] [-a] [-c] [-C] [-E] [-H] [-i] [-I] [-j] [-m] [-M] [-P] [-s] [-S]
               [-t TRANSDUCER] [-T TRANSDUCER2] [-v] [-w] [-W] [-y] [input] [output]

positional arguments:
  input                 input file (one word form per line; default: stdin)
  output                output file (default: stdout)

options:
  -h, --help            show this help message and exit
  -a, --analysis-string
                        output also analysis string
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -E, --no-empty        suppress empty columns or values
  -H, --no-header       suppress table header
  -i, --lemma-index     output also homographic lemma index
  -I, --paradigm-index  output also paradigm index
  -j, --json            output JSON object
  -m, --minimal         prefer lemmas with minimal number of boundaries
  -M, --maximal         prefer word forms with maximal number of boundaries (requires supplementary transducer file)
  -P, --plain           suppress color and formatting
  -s, --seg-lemma       output also segmented lemma
  -S, --seg-word        output also segmented word form (requires supplementary transducer file)
  -t TRANSDUCER, --transducer TRANSDUCER
                        path to transducer file in compact format (default: lib/dwdsmor.ca)
  -T TRANSDUCER2, --transducer2 TRANSDUCER2
                        path to supplementary transducer file in standard format (default: lib/dwdsmor-morph.a)
  -v, --version         show program's version number and exit
  -w, --wf-process      output also word-formation process
  -W, --wf-means        output also word-formation means
  -y, --yaml            output YAML document
```

By default, `dwdsmor` prints a TSV table on standard output:

```plaintext
$ echo "Ihr\nkönnt\neuch\nauf\nden\nKinderbänken\nausruhen\n." | dwdsmor -E
Wordform	Lemma	POS	Subcategory	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metalinguistic	Characters
Ihr	Ihre	POSS			Neut	Acc	Sg	NoInfl	Attr
Ihr	Ihre	POSS			Neut	Nom	Sg	NoInfl	Attr
Ihr	Ihre	POSS			Masc	Nom	Sg	NoInfl	Attr
Ihr	ihr	PPRO	Pers	2		Nom	Pl							CAP
Ihr	ihre	POSS			Neut	Acc	Sg	NoInfl	Attr					CAP
Ihr	ihre	POSS			Neut	Nom	Sg	NoInfl	Attr					CAP
Ihr	ihre	POSS			Masc	Nom	Sg	NoInfl	Attr					CAP
Ihr	Sie	PPRO	Pers	3	NoGend	Gen	Pl						Old
Ihr	sie	PPRO	Pers	3	NoGend	Gen	Pl						Old	CAP
Ihr	sie	PPRO	Pers	3	Fem	Dat	Sg							CAP
Ihr	sie	PPRO	Pers	3	Fem	Gen	Sg						Old	CAP
könnt	können	V		2			Pl				Ind	Pres
euch	euch	PPRO	Refl	2		Acc	Pl
euch	euch	PPRO	Refl	2		Dat	Pl
euch	ihr	PPRO	Pers	2		Acc	Pl
euch	ihr	PPRO	Pers	2		Dat	Pl
auf	auf	ADV
auf	auf	PREP
den	die	REL			Masc	Acc	Sg	St	Subst
den	die	DEM			Masc	Acc	Sg	St	Subst
den	die	DEM			NoGend	Dat	Pl	St	Attr
den	die	DEM			Masc	Acc	Sg	St	Attr
den	die	ART	Def		Masc	Acc	Sg	St	Subst
den	die	ART	Def		NoGend	Dat	Pl	St	Attr
den	die	ART	Def		Masc	Acc	Sg	St	Attr
Kinderbänken	Kinderbank	NN			Fem	Dat	Pl
ausruhen	ausruhen	V								Inf
ausruhen	ausruhen	V		3			Pl				Subj	Pres
ausruhen	ausruhen	V		3			Pl				Ind	Pres
ausruhen	ausruhen	V		1			Pl				Subj	Pres
ausruhen	ausruhen	V		1			Pl				Ind	Pres
.	.	PUNCT	Period
```

The transducer can be selected as an argument of option `-t`:

```plaintext
$ echo "Ihr\nkönnt\neuch\nauf\nden\nKinderbänken\nausruhen\n." | dwdsmor -E -t lib/dwdsmor-root.ca
Wordform	Lemma	POS	Subcategory	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metalinguistic	Characters
Ihr	Ihre	POSS			Neut	Acc	Sg	NoInfl	Attr
Ihr	Ihre	POSS			Neut	Nom	Sg	NoInfl	Attr
Ihr	Ihre	POSS			Masc	Nom	Sg	NoInfl	Attr
Ihr	ihr	PPRO	Pers	2		Nom	Pl							CAP
Ihr	ihre	POSS			Neut	Acc	Sg	NoInfl	Attr					CAP
Ihr	ihre	POSS			Neut	Nom	Sg	NoInfl	Attr					CAP
Ihr	ihre	POSS			Masc	Nom	Sg	NoInfl	Attr					CAP
Ihr	Sie	PPRO	Pers	3	NoGend	Gen	Pl						Old
Ihr	sie	PPRO	Pers	3	NoGend	Gen	Pl						Old	CAP
Ihr	sie	PPRO	Pers	3	Fem	Dat	Sg							CAP
Ihr	sie	PPRO	Pers	3	Fem	Gen	Sg						Old	CAP
könnt	können	V		2			Pl				Ind	Pres
euch	euch	PPRO	Refl	2		Acc	Pl
euch	euch	PPRO	Refl	2		Dat	Pl
euch	ihr	PPRO	Pers	2		Acc	Pl
euch	ihr	PPRO	Pers	2		Dat	Pl
auf	auf	ADV
auf	auf	PREP
den	die	REL			Masc	Acc	Sg	St	Subst
den	die	DEM			Masc	Acc	Sg	St	Subst
den	die	DEM			NoGend	Dat	Pl	St	Attr
den	die	DEM			Masc	Acc	Sg	St	Attr
den	die	ART	Def		Masc	Acc	Sg	St	Subst
den	die	ART	Def		NoGend	Dat	Pl	St	Attr
den	die	ART	Def		Masc	Acc	Sg	St	Attr
Kinderbänken	Kind + Bank	NN			Fem	Dat	Pl
ausruhen	ruhen	V								Inf
ausruhen	ruhen	V		3			Pl				Subj	Pres
ausruhen	ruhen	V		3			Pl				Ind	Pres
ausruhen	ruhen	V		1			Pl				Subj	Pres
ausruhen	ruhen	V		1			Pl				Ind	Pres
ausruhen	ausruhen	V								Inf
ausruhen	ausruhen	V		3			Pl				Subj	Pres
ausruhen	ausruhen	V		3			Pl				Ind	Pres
ausruhen	ausruhen	V		1			Pl				Subj	Pres
ausruhen	ausruhen	V		1			Pl				Ind	Pres
.	.	PUNCT	Period
```

CSV, JSON, and YAML outputs are available with options `-c`, `-j`, and `-y`
respectively.

`dwdsmor-paradigm` is Python script for the generation of paradigms of
lexical words in written German by means of a DWDSmor transducer:

```plaintext
$ dwdsmor-paradigm -h
usage: dwdsmor-paradigm [-h] [-c] [-C] [-E] [-H] [-i {1,2,3,4,5,6,7,8}] [-I {1,2,3,4,5,6,7,8}] [-j] [-n] [-N]
                        [-o] [-O] [-p {ADJ,ART,CARD,DEM,FRAC,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}]
                        [-P] [-s] [-S] [-t TRANSDUCER] [-u] [-v] [-y] lemma [output]

positional arguments:
  lemma                 lemma (determiners: Fem Nom Sg; nominalised
                        adjectives: Wk)
  output                output file (default: stdout)

options:
  -h, --help            show this help message and exit
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -E, --no-empty        suppress empty columns or values
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
  -p {ADJ,ART,CARD,DEM,FRAC,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}, --pos {ADJ,ART,CARD,DEM,FRAC,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}
                        part of speech
  -P, --plain           suppress color and formatting
  -s, --nonst           output also non-standard forms
  -S, --ch              output also forms in Swiss spelling
  -t TRANSDUCER, --transducer TRANSDUCER
                        path to transducer file in standard format (default: lib/dwdsmor-index.a)
  -u, --user-specified  use only user-specified information
  -v, --version         show program's version number and exit
  -y, --yaml            output YAML document
```

By default, `dwdsmor-paradigm` outputs a similar TSV table as `dwdsmor`:

```plaintext
$ dwdsmor-paradigm -E Bank
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
$ dwdsmor-paradigm -n -N -i 1 Bank
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
$ dwdsmor-paradigm -n -N -t lib/dwdsmor.a Kinderbank
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

## Coverage (German-UD-HDT)

    DWDSMOR_AUTOMATA_ROOT=build scripts/ud-german-hdt-coverage

### Open Edition

| POS    |   # types |   # tokens |   % types |   % tokens |   % types covered |   % tokens covered |
|:---    |       ---:|        ---:|       ---:|        ---:|               ---:|                ---:|
| Σ      |    75,741 |  2,536,413 |   100.00% |    100.00% |        **24.03%** |         **81.45%** |
| $(     |         3 |     71,651 |     0.00% |      2.82% |           100.00% |            100.00% |
| $,     |         1 |    140,413 |     0.00% |      5.54% |           100.00% |            100.00% |
| $.     |        10 |    177,078 |     0.01% |      6.98% |            60.00% |             99.99% |
| ADJA   |     9,047 |    144,009 |    11.94% |      5.68% |            14.39% |             68.04% |
| ADJD   |     4,259 |     67,174 |     5.62% |      2.65% |            27.21% |             72.15% |
| ADV    |       689 |    141,168 |     0.91% |      5.57% |            47.46% |             96.13% |
| APPO   |         9 |        995 |     0.01% |      0.04% |            88.89% |             99.90% |
| APPR   |       100 |    336,136 |     0.13% |     13.25% |            68.00% |             99.81% |
| APZR   |        16 |      1,243 |     0.02% |      0.05% |            93.75% |             99.03% |
| ART    |         2 |          2 |     0.00% |      0.00% |             0.00% |              0.00% |
| CARD   |     5,988 |     69,937 |     7.91% |      2.76% |            86.44% |             95.49% |
| FM     |     9,196 |     49,099 |    12.14% |      1.94% |             3.33% |              8.00% |
| ITJ    |         7 |         18 |     0.01% |      0.00% |            14.29% |             55.56% |
| KOKOM  |         3 |     18,329 |     0.00% |      0.72% |           100.00% |            100.00% |
| KON    |        14 |     72,723 |     0.02% |      2.87% |            85.71% |             99.94% |
| KOUI   |         2 |      3,385 |     0.00% |      0.13% |           100.00% |            100.00% |
| KOUS   |        30 |     19,208 |     0.04% |      0.76% |            73.33% |             98.06% |
| NE     |    23,390 |    179,613 |    30.88% |      7.08% |             0.12% |              3.24% |
| NN     |    11,907 |    484,592 |    15.72% |     19.11% |            32.12% |             71.94% |
| PDAT   |         1 |        235 |     0.00% |      0.01% |             0.00% |              0.00% |
| PDS    |         1 |          2 |     0.00% |      0.00% |           100.00% |            100.00% |
| PIAT   |        20 |      3,050 |     0.03% |      0.12% |            45.00% |             95.11% |
| PIDAT  |        10 |     10,430 |     0.01% |      0.41% |            90.00% |             95.39% |
| PIS    |        33 |     12,717 |     0.04% |      0.50% |            57.58% |             98.66% |
| PPER   |         9 |     32,870 |     0.01% |      1.30% |            88.89% |            100.00% |
| PRELS  |         3 |      1,042 |     0.00% |      0.04% |            33.33% |             99.81% |
| PRF    |         6 |     21,151 |     0.01% |      0.83% |           100.00% |            100.00% |
| PROAV  |        36 |        318 |     0.05% |      0.01% |             0.00% |              0.00% |
| PTKA   |         3 |      1,320 |     0.00% |      0.05% |           100.00% |            100.00% |
| PTKANT |         2 |         19 |     0.00% |      0.00% |           100.00% |            100.00% |
| PTKNEG |         1 |     18,383 |     0.00% |      0.72% |           100.00% |            100.00% |
| PTKVZ  |       124 |     20,075 |     0.16% |      0.79% |            75.00% |             97.01% |
| PTKZU  |         1 |     16,648 |     0.00% |      0.66% |           100.00% |            100.00% |
| PWAT   |         2 |         36 |     0.00% |      0.00% |            50.00% |              2.78% |
| PWAV   |        34 |      3,488 |     0.04% |      0.14% |            67.65% |             98.82% |
| PWS    |         3 |      2,429 |     0.00% |      0.10% |            66.67% |             99.42% |
| VAFIN  |         3 |     88,422 |     0.00% |      3.49% |           100.00% |            100.00% |
| VAIMP  |         3 |          3 |     0.00% |      0.00% |           100.00% |            100.00% |
| VAINF  |         3 |     13,385 |     0.00% |      0.53% |           100.00% |            100.00% |
| VAPP   |         3 |      2,959 |     0.00% |      0.12% |           100.00% |            100.00% |
| VMFIN  |         6 |     45,623 |     0.01% |      1.80% |           100.00% |            100.00% |
| VMINF  |         6 |      2,739 |     0.01% |      0.11% |           100.00% |            100.00% |
| VMPP   |         1 |          1 |     0.00% |      0.00% |           100.00% |            100.00% |
| VVFIN  |     3,330 |    133,174 |     4.40% |      5.25% |            49.85% |             89.00% |
| VVIMP  |       100 |        739 |     0.13% |      0.03% |            83.00% |             95.26% |
| VVINF  |     3,301 |     63,923 |     4.36% |      2.52% |            51.86% |             81.99% |
| VVIZU  |       876 |      5,145 |     1.16% |      0.20% |            67.69% |             82.99% |
| VVPP   |     3,141 |     59,009 |     4.15% |      2.33% |            53.68% |             79.96% |
| XY     |         6 |        305 |     0.01% |      0.01% |            16.67% |             34.10% |

### DWDS Edition

| POS    |   # types |   # tokens |   % types |   % tokens |  % types covered |  % tokens covered |
|:---    |       ---:|        ---:|       ---:|        ---:|              ---:|               ---:|
| Σ      |    67,650 |  2,484,111 |   100.00% |    100.00% |       **49.15%** |        **91.56%** |
| $(     |         3 |     71,651 |     0.00% |      2.88% |          100.00% |           100.00% |
| $,     |         1 |    140,413 |     0.00% |      5.65% |          100.00% |           100.00% |
| $.     |        10 |    177,078 |     0.01% |      7.13% |           60.00% |            99.99% |
| ADJA   |     5,269 |    130,432 |     7.79% |      5.25% |           50.88% |            93.63% |
| ADJD   |     3,637 |     64,234 |     5.38% |      2.59% |           80.26% |            98.39% |
| ADV    |       618 |    140,888 |     0.91% |      5.67% |           83.33% |            99.03% |
| APPO   |         9 |        996 |     0.01% |      0.04% |          100.00% |           100.00% |
| APPR   |        93 |    336,155 |     0.14% |     13.53% |           87.10% |            99.98% |
| APZR   |        16 |      1,243 |     0.02% |      0.05% |          100.00% |           100.00% |
| ART    |         2 |          2 |     0.00% |      0.00% |            0.00% |             0.00% |
| CARD   |     5,984 |     69,931 |     8.85% |      2.82% |           86.75% |            95.65% |
| FM     |     8,714 |     45,868 |    12.88% |      1.85% |           14.25% |            28.40% |
| ITJ    |         4 |         13 |     0.01% |      0.00% |           50.00% |            84.62% |
| KOKOM  |         3 |     18,329 |     0.00% |      0.74% |          100.00% |           100.00% |
| KON    |        14 |     72,723 |     0.02% |      2.93% |           92.86% |           100.00% |
| KOUI   |         5 |      3,459 |     0.01% |      0.14% |          100.00% |           100.00% |
| KOUS   |        27 |     19,191 |     0.04% |      0.77% |           96.30% |            99.99% |
| NE     |    20,963 |    160,534 |    30.99% |      6.46% |            0.38% |             5.93% |
| NN     |    11,172 |    471,391 |    16.51% |     18.98% |           86.44% |            97.82% |
| PDS    |         1 |          2 |     0.00% |      0.00% |          100.00% |           100.00% |
| PIAT   |        18 |      2,933 |     0.03% |      0.12% |           55.56% |            99.35% |
| PIDAT  |        10 |     10,430 |     0.01% |      0.42% |           90.00% |            95.39% |
| PIS    |        31 |     12,666 |     0.05% |      0.51% |           77.42% |            99.13% |
| PPER   |         9 |     32,870 |     0.01% |      1.32% |           88.89% |           100.00% |
| PRELS  |         3 |      1,042 |     0.00% |      0.04% |           33.33% |            99.81% |
| PRF    |         6 |     21,151 |     0.01% |      0.85% |          100.00% |           100.00% |
| PROAV  |         7 |         39 |     0.01% |      0.00% |            0.00% |             0.00% |
| PTKA   |         3 |      1,320 |     0.00% |      0.05% |          100.00% |           100.00% |
| PTKANT |         2 |         19 |     0.00% |      0.00% |          100.00% |           100.00% |
| PTKNEG |         1 |     18,383 |     0.00% |      0.74% |          100.00% |           100.00% |
| PTKVZ  |       126 |     20,022 |     0.19% |      0.81% |           92.86% |            98.60% |
| PTKZU  |         1 |     16,648 |     0.00% |      0.67% |          100.00% |           100.00% |
| PWAT   |         2 |         36 |     0.00% |      0.00% |           50.00% |             2.78% |
| PWAV   |        30 |      3,472 |     0.04% |      0.14% |           86.67% |            99.74% |
| PWS    |         3 |      2,429 |     0.00% |      0.10% |           66.67% |            99.42% |
| VAFIN  |         3 |     88,422 |     0.00% |      3.56% |          100.00% |           100.00% |
| VAIMP  |         3 |          3 |     0.00% |      0.00% |          100.00% |           100.00% |
| VAINF  |         3 |     13,385 |     0.00% |      0.54% |          100.00% |           100.00% |
| VAPP   |         3 |      2,959 |     0.00% |      0.12% |          100.00% |           100.00% |
| VMFIN  |         6 |     45,623 |     0.01% |      1.84% |          100.00% |           100.00% |
| VMINF  |         6 |      2,739 |     0.01% |      0.11% |          100.00% |           100.00% |
| VMPP   |         1 |          1 |     0.00% |      0.00% |          100.00% |           100.00% |
| VVFIN  |     3,358 |    133,390 |     4.96% |      5.37% |           97.47% |            99.87% |
| VVIMP  |       100 |        739 |     0.15% |      0.03% |          100.00% |           100.00% |
| VVINF  |     3,318 |     64,076 |     4.90% |      2.58% |           97.23% |            99.79% |
| VVIZU  |       877 |      5,148 |     1.30% |      0.21% |           99.09% |            99.83% |
| VVPP   |     3,169 |     59,328 |     4.68% |      2.39% |           97.70% |            99.71% |
| XY     |         6 |        305 |     0.01% |      0.01% |           16.67% |            34.10% |

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


## Contact

Feel free to contact [Andreas Nolda](mailto:andreas.nolda@bbaw.de) for
questions regarding the lexicon or the grammar and
[Gregor Middell](mailto:gregor.middell@bbaw.de) for question related
to the integration of DWDSmor into your corpus-annotation pipeline.


## License

As the original SMOR and SMORLemma grammars, the DWDSmor grammar is licensed
under the GNU General Public Licence v2.0. The rest of this project is licensed
under the GNU Lesser General Public License v3.0.

Andreas Nolda <andreas.nolda@bbaw.de>
