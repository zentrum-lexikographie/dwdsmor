# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

This project aims at developing a component for **morphological analysis of
German word forms** mainly for **segmenting morphologically complex words** and
for **lemmatisation**. To this end we adopt:

1. [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++ library
   and toolbox for finite-state transducers (FSTs),
2. [SMORLemma](https://github.com/rsennrich/SMORLemma), a modified version of
   the Stuttgart Morphology ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/))
   with an alternative lemmatisation component, and the
3. [DWDS dictionary](https://www.dwds.de/) replacing
   [IMSLex](https://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/imslex/)
   as the as the lexical data source for word components and their respective
   morphological annotations (part-of-speech, inflection class etc.).

Source code in this repository implements various steps in the process of
building and using FSTs for morphological analysis:

* `share/` contains XSLT stylesheets for extracting SMORLemma-compatible lexical
  entries from XML documents in the DWDS format. Sample inputs and outputs can
  be found in `samples/`.
* `lexicon/` contains scripts for generating a DWDSmor lexicon by means of the
  XSLT stylesheets in `share/` and the lexical data in `lexicon/wb/`, which is
  imported from the [DWDS article repository](https://git.zdl.org/zdl/wb) as a
  Git submodule.
* `SMORLemma/` imports sources from an
  [SMORLemma fork](https://git.zdl.org/zdl/SMORLemma) as a Git submodule,
  providing the morphology.
* `dwdsmor/` and `tests/` implement a Python library and accompanying test suite
  for using DWDSmor transducers for the aforementioned linguistic tasks.

## Prerequisites

[GNU/Linux](https://www.debian.org/)
: Development, builds and tests of DWDSmor are performed on [Debian
  GNU/Linux](https://debian.org/) (currently v10 “Buster”). While other
  UNIX-like operating systems (i. e. MacOS) might work, they are not supported.

[Python v3](https://www.python.org/)
: DWDSmor targets Python as its primary runtime environment. Building a
  transducer involves other languages and platforms as well; for example XSLT
  and Clojure on the JVM for lexicon generation. But ultimately, compiled
  transducers are supposed to be used via SFST's commandline tools or to be
  queried in Python applications via language-specific
  [bindings](https://github.com/gremid/sfst-transduce).

[Java (JDK) >= v8](https://openjdk.java.net/)
: The extraction of lexicon entries from XML documents in the DWDS format is
  implemented in XSLT 2, for which [Saxon-HE](https://www.saxonica.com/) is used
  as the runtime environment. The conversion of the whole dictionary (or larger
  parts) is orchestrated via a [Clojure](https://clojure.org/) script, running
  multiple XSLT pipelines in parallel and doing some pre- and postprocessing.
  Saxon and Clojure both require a Java runtime.

[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/)
: a C++ library and toolbox for finite-state transducers (FSTs); please take a
   look at its homepage for installation and usage instructions.

On a recent Debian GNU/Linux, install the following packages:

```sh
apt install python3 default-jdk sfst
```

Optionally set up a virtual environment for project builds, i. e. via
[pyenv](https://github.com/pyenv/pyenv):

```sh
$ curl https://pyenv.run | bash
$ make pyenv
```

or Python's venv

```sh
python3 -m venv .venv
source .venv/bin/activate
```

## Build a DWDSmor lexicon from the DWDS dictionary

Import the dictionary sources and the SMORLemma morphology via the configured
submodules:

```sh
git submodule init SMORLemma lexicon/wb
git submodule update SMORLemma lexicon/wb
```

**Note**: The imported Git repository `lexicon/wb/` is large, containing about
260.000 XML documents and their edit history of several years. Therefore the
lexicon extraction should not be performed in environments with [strict
quotas](https://www.hlrn.de/doc/display/PUB/Fixing+Quota+Issues) on the number
of files/inodes, e.g. on the HLRN-IV/ZIB compute cluster. For a workflow
leveraging HLRN's hardware resources for FST compilation, consider building a
potentially large, current lexicon locally and upload it to HLRN-IV for further
processing.

In addition, a compatible Clojure version has to be installed. This can be done
be calling:

```sh
make -C lexicon clojure
```

For lexicon generation, the shell script `lexicon/generate-lexicon` is provided,
which internally calls Clojure on `lexicon/src/dwdsmor/lexicon.clj`. The script
supports the following parameters:

```plaintext
$ lexicon/generate-lexicon --help
DWDSmor Lexicon Generation
Copyright (C) 2022 Berlin-Brandenburgische Akademie der Wissenschaften

Usage: clojure -M -m dwdsmor.lexicon [options] <dir|*.xml>...

Generates a DWDSmor lexicon from (directories of) XML documents in the DWDS format.

Options:
  -x, --xslt XSLT          XSLT stylesheet
  -b, --blacklist LIST     list of filenames of blacklisted XML documents
  -o, --output OUTPUT      Path of the generated lexicon
  -s, --smorlemma-lexica   Include additional lexica from SMORLemma
  -f, --filter             Filter entries with tag <UNKNOWN>
  -l, --limit MAX_ENTRIES  Limit the number of extracted lexicon entries for testing
  -d, --debug              Print debugging information
  -h, --help
```

This script is called with appropriate options for building a DWDSmor lexicon
from DWDS dictionary articles in `lexicon/wb/` and auxiliary input files in
`lexicon/aux/` by running:

```sh
make -C lexicon
```

A log is saved in `SMORLemma/lexicon/lexicon.log`. This includes XSLT warnings,
if any.

In order to build a lexicon without the auxiliary input files in `lexicon/aux/`,
run:

```sh
make INCLUDE_AUX=false -C lexicon
```

Individual input files can be blacklisted in `lexicon/exclude.list`.

By default, additional lexica from SMORLemma for irregular nouns, adjectives,
and adverbs as well as for adpositions and affixes are included. In order to
build a lexicon without them, run:

```sh
make INCLUDE_SMORLEMMA=false -C lexicon
```

The result is stored in `SMORLemma/lexicon/lexicon`, where it is picked up by
the FST compilation process of SMORLemma.

The lexicon will be re-built if XSLT stylesheets in `share/` have changed. In
order to re-generate the lexicon with unchanged XSLT stylesheets, first call:

```sh
make -C lexicon clean
```

In order to build a lexicon with debugging information, run:

```sh
make -C lexicon debug
```

This calls `lexicon/generate-lexicon` with the option `--debug` and without the
option `--filter`. The result, which may contain `<UNKNOWN>` tags, is stored in
`SMORLemma/lexicon/lexicon.debug`. A corresponding log file with input and
output mappings is saved in `SMORLemma/lexicon/lexicon.debug.log`. In order to
re-generate them with unchanged XSLT stylesheets, first call:

```sh
make -C lexicon debugclean
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

### Update the dictionary sources to the current revision

As said above, the dictionary sources are imported as a submodule, tracking the
working branch of the lexicography team `zdl-lex-server/production`. In order to
update the sources to the most recent revision, issue the following:

```sh
git submodule update --remote lexicon/wb
```

The option `--remote` pulls the current tip of the working branch and updates
the head of the submodule. Once you have tested the new version, commit the new
state of the submodule:

```
git add lexicon/wb
git commit -m "update dictionary sources"
```

### Update the SMORLemma sources to the current revision

In order to update the sources of the SMORLemma fork to the most recent
revision, issue the following commands:

```sh
git submodule update --remote SMORLemma
git add SMORLemma
git commit -m "update SMORLemma sources"
```

## Build FSTs

For compiling the transducers based on an extracted lexicon, first initialize
and update the submodule providing the SMORLemma morphology:

```sh
git submodule init SMORLemma
git submodule update SMORLemma
```

Then run setup routines which install Python dependencies (into the virtual
environment, should you have set one up beforehand):

```sh
make setup
```

Also make sure that you have the SFST toolbox installed, i. e. the tools
`fst-compiler-utf8` and `fst-compact` should be available on the `$PATH`. Once
the setup succeeded and a lexicon is provided in `SMORLemma/lexicon/lexicon`,
the transducers can be compiled:

```sh
make && make install
```

Resulting automata can be found in `lib/*.a` and `lib/*.ca`, including, most
notably, `lib/smor-full.a` and `lib/smor-full.ca`.

Depending on the size of the lexicon, this compilation process can take several
hours, depending on available hardware resources, specifically on the amount of
memory. On machines with less than 256 GB RAM or for fast development
iterations, it is recommended to build FSTs based on a subset of the complete
lexicon and test against the resulting smaller automata. Once the development
reaches a state where the complete lexicon should be processed, the compilation
could be moved to the
[HLRN-IV](https://www.hlrn.de/supercomputer/hlrn-iv-system/) compute cluster.

### Build on HLRN-IV's “Lise”

Lise's standard compute nodes provide 384 GB RAM, which speeds up FST
compilation considerably in comparison to common PC hardware with smaller
memory.

In order to build FSTs there, log into the cluster and prepare the build
environment:

```sh
ssh bembbaw1@blogin.hlrn.de /scratch/usr/bembbaw0/dwdsmor/hlrn/setup
```

Then upload a lexicon:

```sh
scp $LEXICON bembbaw1@blogin.hlrn.de:/scratch/usr/bembbaw1/dwdsmor/SMORLemma/lexicon/lexicon
```

Finally run the build on a compute host:

```sh
ssh bembbaw1@blogin.hlrn.de sbatch /scratch/usr/bembbaw1/dwdsmor/hlrn/build
```

You can check the status of running builds via

```sh
ssh bembbaw1@blogin.hlrn.de squeue -l --me
```

## Tests

Compiled automata can be examined with the test suite in `tests/` by running:

```sh
make test
```

## Tools

`dwdsmor.py` is a Python script for analysing word forms with a DWDSmor
transducer:

```plaintext
$ ./dwdsmor -h
usage: dwdsmor.py [-h] [-c] [-j] [-l] [-t TRANSDUCER] [-v] [input] [output]

positional arguments:
  input                 input file (one word form per line; default: stdin)
  output                output file (default: stdout)

optional arguments:
  -h, --help            show this help message and exit
  -C, --force-color     preserve color and formatting when piping output
  -c, --csv             output CSV table
  -j, --json            output JSON object
  -l, --both-layers     output analysis and surface layer
  -t TRANSDUCER, --transducer TRANSDUCER
                        path to transducer file (default: lib/smor-full.ca)
  -v, --version         show program's version number and exit
```

```plaintext
$ echo Kind | ./dwdsmor.py
Wordform	Analysis	Lemma	Index	POS	Function	Degree	Person	Gender	Number	Case	Inflection	Tense	Mood	Nonfinite	Metainfo
Kind	Kind<+NN><Neut><Acc><Sg>	Kind		NN				Neut	Sg	Acc
Kind	Kind<+NN><Neut><Dat><Sg>	Kind		NN				Neut	Sg	Dat
Kind	Kind<+NN><Neut><Nom><Sg>	Kind		NN				Neut	Sg	Nom
```

```plaintext
$ echo kleines | ./dwdsmor.py
Wordform	Analysis	Lemma	Index	POS	Function	Degree	Person	Gender	Number	Case	Inflection	Tense	Mood	Nonfinite	Metainfo
kleines	klein<+ADJ><Pos><Neut><Acc><Sg><St>	klein		ADJ		Pos		Neut	Sg	Acc	St
kleines	klein<+ADJ><Pos><Neut><Nom><Sg><St>	klein		ADJ		Pos		Neut	Sg	Nom	St
```

```plaintext
$ echo schlafe | ./dwdsmor.py
Wordform	Analysis	Lemma	Index	POS	Function	Degree	Person	Gender	Number	Case	Inflection	Tense	Mood	Nonfinite	Metainfo
schlafe	schlaf<~>en<+V><3><Sg><Pres><Subj>	schlafen		V			3		Sg			Pres	Subj
schlafe	schlaf<~>en<+V><1><Sg><Pres><Subj>	schlafen		V			1		Sg			Pres	Subj
schlafe	schlaf<~>en<+V><1><Sg><Pres><Ind>	schlafen		V			1		Sg			Pres	Ind
```

`dwdsmor-paradigm.py` is another Python script for generating noun, adjective,
and verb paradigms:

```plaintext
$ ./dwdsmor-paradigm.py -h
usage: dwdsmor-paradigm.py [-h] [-b] [-c] [-C] [-H] [-i {1,2,3,4}] [-j] [-o]
                           [-p {ADJ,NN,NPROP,V}] [-t TRANSDUCER] [-v] lemma [output]

positional arguments:
  lemma                 lemma
  output                output file (default: stdout)

optional arguments:
  -h, --help            show this help message and exit
  -b, --brief           output brief version without lemma and lexical
                        categories
  -c, --csv             output CSV table
  -C, --force-color     preserve color and formatting when piping output
  -H, --no-header       suppress table header
  -i {1,2,3,4}, --index {1,2,3,4}
                        homographic lemma index
  -j, --json            output JSON object
  -o, --old-forms       output also archaic forms
  -p {ADJ,NN,NPROP,V}, --pos {ADJ,NN,NPROP,V}
                        part of speech
  -t TRANSDUCER, --transducer TRANSDUCER
                        transducer file (default: lib/smor-index.a)
  -v, --version         show program's version number and exit
```

```plaintext
$ ./dwdsmor-paradigm.py Kind
Lemma	Index	Categories	Paradigm Categories	Paradigm Forms
Kind		NN Neut	Nom Sg	Kind
Kind		NN Neut	Acc Sg	Kind
Kind		NN Neut	Dat Sg	Kind
Kind		NN Neut	Gen Sg	Kindes, Kinds
Kind		NN Neut	Nom Pl	Kinder
Kind		NN Neut	Acc Pl	Kinder
Kind		NN Neut	Dat Pl	Kindern
Kind		NN Neut	Gen Pl	Kinder
```

```plaintext
$ ./dwdsmor-paradigm.py klein
Lemma	Index	Categories	Paradigm Categories	Paradigm Forms
klein		ADJ	Pos Pred	klein
klein		ADJ	Comp Pred	kleiner
klein		ADJ	Sup Pred	kleinsten
klein		ADJ	Pos Masc Nom Sg St	kleiner
klein		ADJ	Pos Masc Nom Sg Wk	kleine
klein		ADJ	Pos Masc Acc Sg St	kleinen
klein		ADJ	Pos Masc Acc Sg Wk	kleinen
klein		ADJ	Pos Masc Dat Sg St	kleinem
klein		ADJ	Pos Masc Dat Sg Wk	kleinen
klein		ADJ	Pos Masc Gen Sg St	kleinen
klein		ADJ	Pos Masc Gen Sg Wk	kleinen
klein		ADJ	Pos Neut Nom Sg St	kleines
klein		ADJ	Pos Neut Nom Sg Wk	kleine
klein		ADJ	Pos Neut Acc Sg St	kleines
klein		ADJ	Pos Neut Acc Sg Wk	kleine
klein		ADJ	Pos Neut Dat Sg St	kleinem
klein		ADJ	Pos Neut Dat Sg Wk	kleinen
klein		ADJ	Pos Neut Gen Sg St	kleinen
klein		ADJ	Pos Neut Gen Sg Wk	kleinen
klein		ADJ	Pos Fem Nom Sg St	kleine
klein		ADJ	Pos Fem Nom Sg Wk	kleine
klein		ADJ	Pos Fem Acc Sg St	kleine
klein		ADJ	Pos Fem Acc Sg Wk	kleine
klein		ADJ	Pos Fem Dat Sg St	kleiner
klein		ADJ	Pos Fem Dat Sg Wk	kleinen
klein		ADJ	Pos Fem Gen Sg St	kleiner
klein		ADJ	Pos Fem Gen Sg Wk	kleinen
klein		ADJ	Pos NoGend Nom Pl St	kleine
klein		ADJ	Pos NoGend Nom Pl Wk	kleinen
klein		ADJ	Pos NoGend Acc Pl St	kleine
klein		ADJ	Pos NoGend Acc Pl Wk	kleinen
klein		ADJ	Pos NoGend Dat Pl St	kleinen
klein		ADJ	Pos NoGend Dat Pl Wk	kleinen
klein		ADJ	Pos NoGend Gen Pl St	kleiner
klein		ADJ	Pos NoGend Gen Pl Wk	kleinen
klein		ADJ	Comp Masc Nom Sg St	kleinerer
klein		ADJ	Comp Masc Nom Sg Wk	kleinere
klein		ADJ	Comp Masc Acc Sg St	kleineren
klein		ADJ	Comp Masc Acc Sg Wk	kleineren
klein		ADJ	Comp Masc Dat Sg St	kleinerem
klein		ADJ	Comp Masc Dat Sg Wk	kleineren
klein		ADJ	Comp Masc Gen Sg St	kleineren
klein		ADJ	Comp Masc Gen Sg Wk	kleineren
klein		ADJ	Comp Neut Nom Sg St	kleineres
klein		ADJ	Comp Neut Nom Sg Wk	kleinere
klein		ADJ	Comp Neut Acc Sg St	kleineres
klein		ADJ	Comp Neut Acc Sg Wk	kleinere
klein		ADJ	Comp Neut Dat Sg St	kleinerem
klein		ADJ	Comp Neut Dat Sg Wk	kleineren
klein		ADJ	Comp Neut Gen Sg St	kleineren
klein		ADJ	Comp Neut Gen Sg Wk	kleineren
klein		ADJ	Comp Fem Nom Sg St	kleinere
klein		ADJ	Comp Fem Nom Sg Wk	kleinere
klein		ADJ	Comp Fem Acc Sg St	kleinere
klein		ADJ	Comp Fem Acc Sg Wk	kleinere
klein		ADJ	Comp Fem Dat Sg St	kleinerer
klein		ADJ	Comp Fem Dat Sg Wk	kleineren
klein		ADJ	Comp Fem Gen Sg St	kleinerer
klein		ADJ	Comp Fem Gen Sg Wk	kleineren
klein		ADJ	Comp NoGend Nom Pl St	kleinere
klein		ADJ	Comp NoGend Nom Pl Wk	kleineren
klein		ADJ	Comp NoGend Acc Pl St	kleinere
klein		ADJ	Comp NoGend Acc Pl Wk	kleineren
klein		ADJ	Comp NoGend Dat Pl St	kleineren
klein		ADJ	Comp NoGend Dat Pl Wk	kleineren
klein		ADJ	Comp NoGend Gen Pl St	kleinerer
klein		ADJ	Comp NoGend Gen Pl Wk	kleineren
klein		ADJ	Sup Masc Nom Sg St	kleinster
klein		ADJ	Sup Masc Nom Sg Wk	kleinste
klein		ADJ	Sup Masc Acc Sg St	kleinsten
klein		ADJ	Sup Masc Acc Sg Wk	kleinsten
klein		ADJ	Sup Masc Dat Sg St	kleinstem
klein		ADJ	Sup Masc Dat Sg Wk	kleinsten
klein		ADJ	Sup Masc Gen Sg St	kleinsten
klein		ADJ	Sup Masc Gen Sg Wk	kleinsten
klein		ADJ	Sup Neut Nom Sg St	kleinstes
klein		ADJ	Sup Neut Nom Sg Wk	kleinste
klein		ADJ	Sup Neut Acc Sg St	kleinstes
klein		ADJ	Sup Neut Acc Sg Wk	kleinste
klein		ADJ	Sup Neut Dat Sg St	kleinstem
klein		ADJ	Sup Neut Dat Sg Wk	kleinsten
klein		ADJ	Sup Neut Gen Sg St	kleinsten
klein		ADJ	Sup Neut Gen Sg Wk	kleinsten
klein		ADJ	Sup Fem Nom Sg St	kleinste
klein		ADJ	Sup Fem Nom Sg Wk	kleinste
klein		ADJ	Sup Fem Acc Sg St	kleinste
klein		ADJ	Sup Fem Acc Sg Wk	kleinste
klein		ADJ	Sup Fem Dat Sg St	kleinster
klein		ADJ	Sup Fem Dat Sg Wk	kleinsten
klein		ADJ	Sup Fem Gen Sg St	kleinster
klein		ADJ	Sup Fem Gen Sg Wk	kleinsten
klein		ADJ	Sup NoGend Nom Pl St	kleinste
klein		ADJ	Sup NoGend Nom Pl Wk	kleinsten
klein		ADJ	Sup NoGend Acc Pl St	kleinste
klein		ADJ	Sup NoGend Acc Pl Wk	kleinsten
klein		ADJ	Sup NoGend Dat Pl St	kleinsten
klein		ADJ	Sup NoGend Dat Pl Wk	kleinsten
klein		ADJ	Sup NoGend Gen Pl St	kleinster
klein		ADJ	Sup NoGend Gen Pl Wk	kleinsten
```

```plaintext
$ ./dwdsmor-paradigm.py schlafen
Lemma	Index	Categories	Paradigm Categories	Paradigm Forms
schlafen		V	Inf	schlafen
schlafen		V	PPres	schlafend
schlafen		V	PPast	geschlafen
schlafen		V	1 Sg Pres Ind	schlafe
schlafen		V	2 Sg Pres Ind	schläfst
schlafen		V	3 Sg Pres Ind	schläft
schlafen		V	1 Pl Pres Ind	schlafen
schlafen		V	2 Pl Pres Ind	schlaft
schlafen		V	3 Pl Pres Ind	schlafen
schlafen		V	1 Sg Pres Subj	schlafe
schlafen		V	2 Sg Pres Subj	schlafest
schlafen		V	3 Sg Pres Subj	schlafe
schlafen		V	1 Pl Pres Subj	schlafen
schlafen		V	2 Pl Pres Subj	schlafet
schlafen		V	3 Pl Pres Subj	schlafen
schlafen		V	1 Sg Past Ind	schlief
schlafen		V	2 Sg Past Ind	schliefst
schlafen		V	3 Sg Past Ind	schlief
schlafen		V	1 Pl Past Ind	schliefen
schlafen		V	2 Pl Past Ind	schlieft
schlafen		V	3 Pl Past Ind	schliefen
schlafen		V	1 Sg Past Subj	schliefe
schlafen		V	2 Sg Past Subj	schliefest
schlafen		V	3 Sg Past Subj	schliefe
schlafen		V	1 Pl Past Subj	schliefen
schlafen		V	2 Pl Past Subj	schliefet
schlafen		V	3 Pl Past Subj	schliefen
schlafen		V	2 Sg Imp	schlaf
schlafen		V	2 Pl Imp	schlaft

```

## Contact

In case of any question or issues, please contact [Andreas
Nolda](mailto:andreas.nolda@bbaw.de) for questions related to the lexicon or
[Gregor Middell](mailto:gregor.middell@bbaw.de) for issues related to the build
process or integrating DWDSmor with your application.

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

Copyright &copy; 2021 Berlin-Brandenburg Academy of Sciences and Humanities.

This project is licensed under the GNU Lesser General Public License v3.0.
