# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

This project provides a component for the morphological analysis of word forms
and for the generation of paradigms of lexical words in written German. To this
end we adopt:

1. [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++ library
   and toolbox for finite-state transducers (FSTs),
2. [SMORLemma](https://github.com/rsennrich/SMORLemma), a modified version of
   the Stuttgart Morphology ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/))
   with an alternative lemmatisation component, and the
3. [DWDS dictionary](https://www.dwds.de/) replacing
   [IMSLex](https://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/imslex/)
   as the as the lexical data source for word components and their respective
   morphological annotations (part-of-speech, inflection class etc.).

This repository provides source code for building DWDSmor lexica and transducers
as well as for using DWDSmor transducers for morphological analysis and paradigm
generation:

* `share/` contains XSLT stylesheets for extracting lexical entries in SMORLemma
  format form XML sources of DWDS articles. Sample inputs and outputs can be
  found in `samples/`.
* `lexicon/` contains scripts for building DWDSmor lexica by means of the XSLT
  stylesheets in `share/` and the lexical data in `lexicon/wb/`, which is
  imported from the [DWDS article repository](https://git.zdl.org/zdl/wb) as a
  Git submodule.
* `grammar/` contains an FST grammar based on SMORLemma, providing the
  morphology.
* `dwdsmor/` and `tests/` implement a Python library and accompanying test suite
  for the DWDSmor transducers.
* `dwdsmor.py` and `paradigm.py` are user-level Python scripts for morphological
  analysis and for paradigm generation by means of DWDSmor transducers.

DWDSmor is in active development. In its current stage, DWDSmor supports
inflection for a large subset of the vocabulary of written German. Support for
word formation will be added in future versions.

## Prerequisites

[GNU/Linux](https://www.debian.org/)
: Development, builds and tests of DWDSmor are performed on the current stable
  distribution of [Debian GNU/Linux](https://debian.org/). While other
  UNIX-like operating systems such as MacOS should work, too, they are not
  actively supported.

[Python >= v3](https://www.python.org/)
: DWDSmor targets Python as its primary runtime environment. The DWDSmor
  transducers can be used via SFST's commandline tools, queried in Python
  applications via language-specific
  [bindings](https://github.com/gremid/sfst-transduce), or used by the Python
  scripts `dwdsmor.py` and `paradigm.py` for morphological analysis and for
  paradigm generation.

[Java (JDK) >= v8](https://openjdk.java.net/)
: The extraction of lexicon entries from XML sources of DWDS articles is
  implemented in XSLT 2, for which [Saxon-HE](https://www.saxonica.com/) is used
  as the runtime environment. Saxon requires a Java runtime.

[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/)
: a C++ library and toolbox for finite-state transducers (FSTs); please take a
  look at its homepage for installation and usage instructions.

On a Debian-based distribution, install the following packages:

```sh
apt install python3 default-jdk libsaxonhe-java sfst
```

Set up a virtual environment for project builds, i. e. via
[`pyenv`](https://github.com/pyenv/pyenv):

```sh
$ curl https://pyenv.run | bash
$ make pyenv
```

or Python's `venv`:

```sh
python3 -m venv .venv
source .venv/bin/activate
```

Then run the DWDSmor setup routine in order to install Python dependencies:

```sh
make setup
```

For building DWDSmor lexica, DWDS dictionary sources are required. Import them
via the configured submodule:

```sh
git submodule init lexicon/wb
```

In order to update the dictionary sources to the most recent revision, issue the
following command:

```sh
git submodule update --remote lexicon/wb
```

The option `--remote` pulls the current tip of the working branch and updates
the head of the submodule. Once you have tested the new version, commit the new
state of the submodule:

```sh
git add lexicon/wb
git commit -m "update dictionary sources"
```

## Building DWDSmor lexica and transducers

For building DWDSmor lexica and transducers, simply run:

```sh
make all && make install
```

This will build DWDSmor lexica and transducers and install the
latter into `lib/`, where the user-level Python scripts `dwdsmor.py` and
`paradigm.py` expect them by default.

For experts, the individual steps of building DWDSmor lexica and transducers
will be described in more details in the following subsections.

### Building DWDSmor lexica

For generating a lexicon from XML sources of DWDS articles in `lexicon/wb/`
`lexicon/aux/`, run:


```sh
make lexicon
```

The lexicon is saved as `grammar/dwds.lex`. A log file can be found in
`grammar/dwds.log` which includes XSLT warnings, if any.

Individual input files can be blacklisted in `lexicon/exclude.xml`. In this
way, individual DWDS articles can be overwritten in the auxiliary input files.

The lexicon will be re-built if XSLT stylesheets in `share/` have changed. In
order to re-generate the lexicon with unchanged XSLT stylesheets, first call:

```sh
make -C lexicon clean
```

For regression testing, the `test` make target is provided:

```sh
make -s -C lexicon test
```

This generates small sample lexica from the file lists in `lexicon/test/input/`
and compares the outputs in `lexicon/test/output/` with pre-generated target
lexica in `lexicon/test/target/`. Note that filenames in the file lists are
relative to `lexicon/wb/`.

In order to re-run tests with unchanged lexicon, XSLT stylesheets and file
lists, first call:

```sh
make -C lexicon testclean
```

### Building DWDSmor transducers

The DWDSmor transducers are built by running:

```sh
make -C grammar all
```

The resulting DWDSmor transducers are:

* `grammar/dwdsmor.{a,ca}`: for morphological analysis, with inflection and
  word-formation components
* `grammar/dwdsmor-finite.{a,ca}`: for testing purposes, with an inflection
  component and a finite word-formation component
* `grammar/dwdsmor-index.{a,ca}`: for paradigm generation, with an inflection
  component including paradigm indices and homographic lemma indices

Once built, the DWDSmor transducers should be installed into `lib/`, where the
Python scripts `dwdsmor.py` and `paradigm.py` expect them by default:

```sh
make -C grammar install
```

The DWDSmor transducers can then be examined with the test suite in `tests/` by
running:

```sh
make test
```

## Using DWDSmor

DWDSmor provides two Python scripts for using the DWDSmor transducers.

`dwdsmor.py` is a Python script for the morphological analysis of word forms in
written German by means of a DWDSmor transducer:

```plaintext
$ ./dwdsmor.py -h
usage: dwdsmor.py [-h] [-c] [-C] [-H] [-j] [-t TRANSDUCER] [-v] [input] [output]

positional arguments:
  input                 input file (one word form per line; default: stdin)
  output                output file (default: stdout)

optional arguments:
  -h, --help            show this help message and exit
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -H, --no-header       suppress table header
  -j, --json            output JSON object
  -t TRANSDUCER, --transducer TRANSDUCER
                        path to transducer file (default: lib/dwdsmor.ca)
  -v, --version         show program's version number and exit
```

By default, `dwdsmor.py` prints a CSV table on standard output:

```plaintext
$ echo Kind | ./dwdsmor.py
Wordform	Analysis	Lemma	Segmentation	Lemma Index	Paradigm Index	POS	Subcategory	Auxiliary	Degree	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metainfo
Kind	Kind<+NN><Neut><Acc><Sg>	Kind	Kind			NN					Neut	Acc	Sg
Kind	Kind<+NN><Neut><Dat><Sg>	Kind	Kind			NN					Neut	Dat	Sg
Kind	Kind<+NN><Neut><Nom><Sg>	Kind	Kind			NN					Neut	Nom	Sg
```

```plaintext
$ echo kleines | ./dwdsmor.py
Wordform	Analysis	Lemma	Segmentation	Lemma Index	Paradigm Index	POS	Subcategory	Auxiliary	Degree	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metainfo
kleines	klein<+ADJ><Pos><Attr/Subst><Neut><Acc><Sg><St>	klein	klein			ADJ			Pos		Neut	Acc	Sg	St	Attr/Subst
kleines	klein<+ADJ><Pos><Attr/Subst><Neut><Nom><Sg><St>	klein	klein			ADJ			Pos		Neut	Nom	Sg	St	Attr/Subst
```

```plaintext
$ echo mein | ./dwdsmor.py
Wordform	Analysis	Lemma	Segmentation	Lemma Index	Paradigm Index	POS	Subcategory	Auxiliary	Degree	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metainfo
mein	mein<~>en<+V><Imp><Sg>	meinen	mein<~>en			V							Sg				Imp
mein	meine<+POSS><Attr><Neut><Acc><Sg><NoInfl>	meine	meine			POSS					Neut	Acc	Sg	NoInfl	Attr
mein	meine<+POSS><Attr><Neut><Nom><Sg><NoInfl>	meine	meine			POSS					Neut	Nom	Sg	NoInfl	Attr
mein	meine<+POSS><Attr><Masc><Nom><Sg><NoInfl>	meine	meine			POSS					Masc	Nom	Sg	NoInfl	Attr
mein	ich<+PPRO><Pers><1><Gen><Sg><Old>	ich	ich			PPRO	Pers			1		Gen	Sg						Old
```

```plaintext
$ echo schlafe | ./dwdsmor.py
Wordform	Analysis	Lemma	Segmentation	Lemma Index	Paradigm Index	POS	Subcategory	Auxiliary	Degree	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Metainfo
schlafe	schlaf<~>en<+V><3><Sg><Pres><Subj>	schlafen	schlaf<~>en			V				3			Sg				Subj	Pres
schlafe	schlaf<~>en<+V><1><Sg><Pres><Subj>	schlafen	schlaf<~>en			V				1			Sg				Subj	Pres
schlafe	schlaf<~>en<+V><1><Sg><Pres><Ind>	schlafen	schlaf<~>en			V				1			Sg				Ind	Pres
```

An alternative JSON output is available with the option `-j`.

`paradigm.py` is Python script for the generation of paradigms of lexical words
in written German by means of a DWDSmor transducer:

```plaintext
$ ./paradigm.py -h
usage: paradigm.py [-h] [-c] [-C] [-H] [-i {1,2,3,4,5}] [-I {1,2,3,4,5}] [-j] [-n] [-N] [-o]
                   [-p {ADJ,ART,CARD,DEM,INDEF,NN,NPROP,POSS,PPRO,REL,V,WPRO}] [-s]
                   [-t TRANSDUCER] [-u] [-v] lemma [output]

positional arguments:
  lemma                 lemma (determiners: Fem Nom Sg; nominalised adjectives: Wk)
  output                output file (default: stdout)

optional arguments:
  -h, --help            show this help message and exit
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -H, --no-header       suppress table header
  -i {1,2,3,4,5}, --lemma-index {1,2,3,4,5}
                        homographic lemma index
  -I {1,2,3,4,5}, --paradigm-index {1,2,3,4,5}
                        paradigm index
  -j, --json            output JSON object
  -n, --no-category-names
                        do not output category names
  -N, --no-lemma        do not output lemma, lemma index, paradigm index, and lexical categories
  -o, --old-forms       output also archaic forms
  -p {ADJ,ART,CARD,DEM,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}, --pos {ADJ,ART,CARD,DEM,INDEF,NN,NPROP,ORD,POSS,PPRO,REL,V,WPRO}
                        part of speech
  -s, --nonstandard-forms
                        output also non-standard forms
  -t TRANSDUCER, --transducer TRANSDUCER
                        transducer file (default: lib/dwdsmor-index.a)
  -u, --user-specified  use only user-specified information
  -v, --version         show program's version number and exit
```

By default, `paradigm.py` outputs a similar CSV table as `dwdsmor.py`:

```plaintext
$ ./paradigm.py Kind
Lemma	Lemma Index	Paradigm Index	POS	Subcategory	Auxiliary	Person	Gender	Degree	Person	Gender	Case	Number	Inflection	Function	Nonfinite	Mood	Tense	Paradigm Forms
Kind			NN				Neut				Nom	Sg						Kind
Kind			NN				Neut				Acc	Sg						Kind
Kind			NN				Neut				Dat	Sg						Kind
Kind			NN				Neut				Gen	Sg						Kindes, Kinds
Kind			NN				Neut				Nom	Pl						Kinder
Kind			NN				Neut				Acc	Pl						Kinder
Kind			NN				Neut				Dat	Pl						Kindern
Kind			NN				Neut				Gen	Pl						Kinder
```

For a condensed version, the options `-n` and `-N` can be specified:

```plaintext
$ ./paradigm.py -n -N Kind
Paradigm Categories	Paradigm Forms
Nom Sg	Kind
Acc Sg	Kind
Dat Sg	Kind
Gen Sg	Kindes, Kinds
Nom Pl	Kinder
Acc Pl	Kinder
Dat Pl	Kindern
Gen Pl	Kinder
```

```plaintext
$ ./paradigm.py -n -N klein
Paradigm Categories	Paradigm Forms
Pos Pred/Adv	klein
Comp Pred/Adv	kleiner
Sup Pred/Adv	am kleinsten
Pos Masc Nom Sg St Attr/Subst	kleiner
Pos Masc Nom Sg Wk Attr/Subst	kleine
Pos Masc Acc Sg St Attr/Subst	kleinen
Pos Masc Acc Sg Wk Attr/Subst	kleinen
Pos Masc Dat Sg St Attr/Subst	kleinem
Pos Masc Dat Sg Wk Attr/Subst	kleinen
Pos Masc Gen Sg St Attr/Subst	kleinen
Pos Masc Gen Sg Wk Attr/Subst	kleinen
Pos Neut Nom Sg St Attr/Subst	kleines
Pos Neut Nom Sg Wk Attr/Subst	kleine
Pos Neut Acc Sg St Attr/Subst	kleines
Pos Neut Acc Sg Wk Attr/Subst	kleine
Pos Neut Dat Sg St Attr/Subst	kleinem
Pos Neut Dat Sg Wk Attr/Subst	kleinen
Pos Neut Gen Sg St Attr/Subst	kleinen
Pos Neut Gen Sg Wk Attr/Subst	kleinen
Pos Fem Nom Sg St Attr/Subst	kleine
Pos Fem Nom Sg Wk Attr/Subst	kleine
Pos Fem Acc Sg St Attr/Subst	kleine
Pos Fem Acc Sg Wk Attr/Subst	kleine
Pos Fem Dat Sg St Attr/Subst	kleiner
Pos Fem Dat Sg Wk Attr/Subst	kleinen
Pos Fem Gen Sg St Attr/Subst	kleiner
Pos Fem Gen Sg Wk Attr/Subst	kleinen
Pos NoGend Nom Pl St Attr/Subst	kleine
Pos NoGend Nom Pl Wk Attr/Subst	kleinen
Pos NoGend Acc Pl St Attr/Subst	kleine
Pos NoGend Acc Pl Wk Attr/Subst	kleinen
Pos NoGend Dat Pl St Attr/Subst	kleinen
Pos NoGend Dat Pl Wk Attr/Subst	kleinen
Pos NoGend Gen Pl St Attr/Subst	kleiner
Pos NoGend Gen Pl Wk Attr/Subst	kleinen
Comp Masc Nom Sg St Attr/Subst	kleinerer
Comp Masc Nom Sg Wk Attr/Subst	kleinere
Comp Masc Acc Sg St Attr/Subst	kleineren
Comp Masc Acc Sg Wk Attr/Subst	kleineren
Comp Masc Dat Sg St Attr/Subst	kleinerem
Comp Masc Dat Sg Wk Attr/Subst	kleineren
Comp Masc Gen Sg St Attr/Subst	kleineren
Comp Masc Gen Sg Wk Attr/Subst	kleineren
Comp Neut Nom Sg St Attr/Subst	kleineres
Comp Neut Nom Sg Wk Attr/Subst	kleinere
Comp Neut Acc Sg St Attr/Subst	kleineres
Comp Neut Acc Sg Wk Attr/Subst	kleinere
Comp Neut Dat Sg St Attr/Subst	kleinerem
Comp Neut Dat Sg Wk Attr/Subst	kleineren
Comp Neut Gen Sg St Attr/Subst	kleineren
Comp Neut Gen Sg Wk Attr/Subst	kleineren
Comp Fem Nom Sg St Attr/Subst	kleinere
Comp Fem Nom Sg Wk Attr/Subst	kleinere
Comp Fem Acc Sg St Attr/Subst	kleinere
Comp Fem Acc Sg Wk Attr/Subst	kleinere
Comp Fem Dat Sg St Attr/Subst	kleinerer
Comp Fem Dat Sg Wk Attr/Subst	kleineren
Comp Fem Gen Sg St Attr/Subst	kleinerer
Comp Fem Gen Sg Wk Attr/Subst	kleineren
Comp NoGend Nom Pl St Attr/Subst	kleinere
Comp NoGend Nom Pl Wk Attr/Subst	kleineren
Comp NoGend Acc Pl St Attr/Subst	kleinere
Comp NoGend Acc Pl Wk Attr/Subst	kleineren
Comp NoGend Dat Pl St Attr/Subst	kleineren
Comp NoGend Dat Pl Wk Attr/Subst	kleineren
Comp NoGend Gen Pl St Attr/Subst	kleinerer
Comp NoGend Gen Pl Wk Attr/Subst	kleineren
Sup Masc Nom Sg St Attr/Subst	kleinster
Sup Masc Nom Sg Wk Attr/Subst	kleinste
Sup Masc Acc Sg St Attr/Subst	kleinsten
Sup Masc Acc Sg Wk Attr/Subst	kleinsten
Sup Masc Dat Sg St Attr/Subst	kleinstem
Sup Masc Dat Sg Wk Attr/Subst	kleinsten
Sup Masc Gen Sg St Attr/Subst	kleinsten
Sup Masc Gen Sg Wk Attr/Subst	kleinsten
Sup Neut Nom Sg St Attr/Subst	kleinstes
Sup Neut Nom Sg Wk Attr/Subst	kleinste
Sup Neut Acc Sg St Attr/Subst	kleinstes
Sup Neut Acc Sg Wk Attr/Subst	kleinste
Sup Neut Dat Sg St Attr/Subst	kleinstem
Sup Neut Dat Sg Wk Attr/Subst	kleinsten
Sup Neut Gen Sg St Attr/Subst	kleinsten
Sup Neut Gen Sg Wk Attr/Subst	kleinsten
Sup Fem Nom Sg St Attr/Subst	kleinste
Sup Fem Nom Sg Wk Attr/Subst	kleinste
Sup Fem Acc Sg St Attr/Subst	kleinste
Sup Fem Acc Sg Wk Attr/Subst	kleinste
Sup Fem Dat Sg St Attr/Subst	kleinster
Sup Fem Dat Sg Wk Attr/Subst	kleinsten
Sup Fem Gen Sg St Attr/Subst	kleinster
Sup Fem Gen Sg Wk Attr/Subst	kleinsten
Sup NoGend Nom Pl St Attr/Subst	kleinste
Sup NoGend Nom Pl Wk Attr/Subst	kleinsten
Sup NoGend Acc Pl St Attr/Subst	kleinste
Sup NoGend Acc Pl Wk Attr/Subst	kleinsten
Sup NoGend Dat Pl St Attr/Subst	kleinsten
Sup NoGend Dat Pl Wk Attr/Subst	kleinsten
Sup NoGend Gen Pl St Attr/Subst	kleinster
Sup NoGend Gen Pl Wk Attr/Subst	kleinsten
```

```plaintext
$ ./paradigm.py -n -N meine
Paradigm Categories	Paradigm Forms
Masc Nom Sg NoInfl Attr	mein
Masc Nom Sg St Subst	meiner
Masc Nom Sg Wk Subst	meine
Masc Acc Sg St Attr	meinen
Masc Acc Sg St Subst	meinen
Masc Acc Sg Wk Subst	meinen
Masc Dat Sg St Attr	meinem
Masc Dat Sg St Subst	meinem
Masc Dat Sg Wk Subst	meinen
Masc Gen Sg St Attr	meines
Masc Gen Sg St Subst	meines
Masc Gen Sg Wk Subst	meinen
Neut Nom Sg NoInfl Attr	mein
Neut Nom Sg St Subst	meines, meins
Neut Nom Sg Wk Subst	meine
Neut Acc Sg NoInfl Attr	mein
Neut Acc Sg St Subst	meines, meins
Neut Acc Sg Wk Subst	meine
Neut Dat Sg St Attr	meinem
Neut Dat Sg St Subst	meinem
Neut Dat Sg Wk Subst	meinen
Neut Gen Sg St Attr	meines
Neut Gen Sg St Subst	meines
Neut Gen Sg Wk Subst	meinen
Fem Nom Sg St Attr	meine
Fem Nom Sg St Subst	meine
Fem Nom Sg Wk Subst	meine
Fem Acc Sg St Attr	meine
Fem Acc Sg St Subst	meine
Fem Acc Sg Wk Subst	meine
Fem Dat Sg St Attr	meiner
Fem Dat Sg St Subst	meiner
Fem Dat Sg Wk Subst	meinen
Fem Gen Sg St Attr	meiner
Fem Gen Sg St Subst	meiner
Fem Gen Sg Wk Subst	meinen
NoGend Nom Pl St Attr	meine
NoGend Nom Pl St Subst	meine
NoGend Nom Pl Wk Subst	meinen
NoGend Acc Pl St Attr	meine
NoGend Acc Pl St Subst	meine
NoGend Acc Pl Wk Subst	meinen
NoGend Dat Pl St Attr	meinen
NoGend Dat Pl St Subst	meinen
NoGend Dat Pl Wk Subst	meinen
NoGend Gen Pl St Attr	meiner
NoGend Gen Pl St Subst	meiner
NoGend Gen Pl Wk Subst	meinen
```

```plaintext
$ ./paradigm.py -n -N schlafen
Paradigm Categories	Paradigm Forms
Inf Pres	schlafen
Inf Perf	geschlafen haben
Part Pres	schlafend
Part Perf	geschlafen
1 Sg Ind Pres	schlafe
2 Sg Ind Pres	schläfst
3 Sg Ind Pres	schläft
1 Pl Ind Pres	schlafen
2 Pl Ind Pres	schlaft
3 Pl Ind Pres	schlafen
1 Sg Subj Pres	schlafe
2 Sg Subj Pres	schlafest
3 Sg Subj Pres	schlafe
1 Pl Subj Pres	schlafen
2 Pl Subj Pres	schlafet
3 Pl Subj Pres	schlafen
1 Sg Ind Perf	habe geschlafen
2 Sg Ind Perf	hast geschlafen
3 Sg Ind Perf	hat geschlafen
1 Pl Ind Perf	haben geschlafen
2 Pl Ind Perf	habt geschlafen
3 Pl Ind Perf	haben geschlafen
1 Sg Subj Perf	habe geschlafen
2 Sg Subj Perf	habest geschlafen
3 Sg Subj Perf	habe geschlafen
1 Pl Subj Perf	haben geschlafen
2 Pl Subj Perf	habet geschlafen
3 Pl Subj Perf	haben geschlafen
1 Sg Ind Past	schlief
2 Sg Ind Past	schliefst
3 Sg Ind Past	schlief
1 Pl Ind Past	schliefen
2 Pl Ind Past	schlieft
3 Pl Ind Past	schliefen
1 Sg Subj Past	schliefe
2 Sg Subj Past	schliefest
3 Sg Subj Past	schliefe
1 Pl Subj Past	schliefen
2 Pl Subj Past	schliefet
3 Pl Subj Past	schliefen
1 Sg Ind PastPerf	hatte geschlafen
2 Sg Ind PastPerf	hattest geschlafen
3 Sg Ind PastPerf	hatte geschlafen
1 Pl Ind PastPerf	hatten geschlafen
2 Pl Ind PastPerf	hattet geschlafen
3 Pl Ind PastPerf	hatten geschlafen
1 Sg Subj PastPerf	hätte geschlafen
2 Sg Subj PastPerf	hättest geschlafen
3 Sg Subj PastPerf	hätte geschlafen
1 Pl Subj PastPerf	hätten geschlafen
2 Pl Subj PastPerf	hättet geschlafen
3 Pl Subj PastPerf	hätten geschlafen
1 Sg Ind Fut	werde schlafen
2 Sg Ind Fut	wirst schlafen
3 Sg Ind Fut	wird schlafen
1 Pl Ind Fut	werden schlafen
2 Pl Ind Fut	werdet schlafen
3 Pl Ind Fut	werden schlafen
1 Sg Subj Fut	werde schlafen
2 Sg Subj Fut	werdest schlafen
3 Sg Subj Fut	werde schlafen
1 Pl Subj Fut	werden schlafen
2 Pl Subj Fut	werdet schlafen
3 Pl Subj Fut	werden schlafen
1 Sg Ind FutPerf	werde geschlafen haben
2 Sg Ind FutPerf	wirst geschlafen haben
3 Sg Ind FutPerf	wird geschlafen haben
1 Pl Ind FutPerf	werden geschlafen haben
2 Pl Ind FutPerf	werdet geschlafen haben
3 Pl Ind FutPerf	werden geschlafen haben
1 Sg Subj FutPerf	werde geschlafen haben
2 Sg Subj FutPerf	werdest geschlafen haben
3 Sg Subj FutPerf	werde geschlafen haben
1 Pl Subj FutPerf	werden geschlafen haben
2 Pl Subj FutPerf	werdet geschlafen haben
3 Pl Subj FutPerf	werden geschlafen haben
Sg Imp	schlaf
Pl Imp	schlaft
```

Again, the option `-j` selects an alternative JSON output.


## Contact

Feel free to contact [Andreas Nolda](mailto:andreas.nolda@bbaw.de) for
questions regarding the lexicon or the grammar and
[Gregor Middell](mailto:gregor.middell@bbaw.de) for question related
to the build process or the integration of DWDSmor with your application.

## Bibliography

* A. Fitschen, “Ein computerlinguistisches Lexikon als komplexes System,” 2004,
  [pdf](https://www.ims.uni-stuttgart.de/documents/ressourcen/lexika/imslex/fitschendiss.pdf).
* Helmut Schmid, Arne Fitschen, and Ulrich Heid, “SMOR: A German Computational
  Morphology Covering Derivation, Composition and Inflection,” in Proceedings of
  the Fourth International Conference on Language Resources and Evaluation
  (LREC’04) (Presented at the LREC 2004, Lisbon, Portugal: European Language
  Resources Association (ELRA), 2004), accessed August 2, 2021,
  [pdf](http://www.lrec-conf.org/proceedings/lrec2004/pdf/468.pdf).
* Helmut Schmid, “A Programming Language for Finite State Transducers,” in
  Finite-State Methods and Natural Language Processing, ed. Anssi Yli-Jyrä,
  Lauri Karttunen, and Juhani Karhumäki, Lecture Notes in Computer Science
  (Berlin, Heidelberg: Springer, 2006), 308–309,
  [pdf](https://www.cis.uni-muenchen.de/~schmid/papers/SFST-PL.pdf).
* Rico Sennrich and Beat Kunz, “Zmorge: A German Morphological Lexicon Extracted
  from Wiktionary,” in Proceedings of the Ninth International Conference on
  Language Resources and Evaluation (LREC’14) (Presented at the LREC 2014,
  Reykjavik, Iceland: European Language Resources Association (ELRA), 2014),
  1063–1067, accessed August 2, 2021,
  [pdf](http://www.lrec-conf.org/proceedings/lrec2014/pdf/116_Paper.pdf).

## License

Copyright &copy; 2022 Berlin-Brandenburg Academy of Sciences and Humanities.

This project is licensed under the GNU Lesser General Public License v3.0.
