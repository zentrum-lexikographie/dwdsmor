# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

This project aims at developing a component for **morphological analysis of
German word forms** mainly for **segmenting morphologically complex words** and
for **lemmatisation**. To this end we adopt:

1. [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++ library
   and toolbox for finite state transducers (FSTs),
2. [SMORLemma](https://github.com/rsennrich/SMORLemma), a modified version of
   the Stuttgart Morphology ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/))
   with an alternative lemmatisation component, and the
3. [DWDS dictionary](https://www.dwds.de/) replacing
   [IMSLex](https://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/imslex/)
   as the as the lexical data source for word components and their respective
   morphological annotations (part-of-speech, inflection class etc.).

Source code in this repository implements various steps in the process of
building and using FSTs for morphological analysis:

* `lexicon/` and `share/` contain sources for building the DWDSmor lexicon by
  extracting SMOR-compatible lexicon entries from XML documents of the DWDS
  dictionary.
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
: The extraction of lexicon entries from DWDS/XML articles files is implemented
  in XSLT 2, for which [Saxon-HE](https://www.saxonica.com/) is used as the
  runtime environment. The conversion of the whole dictionary (or larger parts)
  is orchestrated via a [Clojure](https://clojure.org/) script, running multiple
  XSLT pipelines in parallel and doing some pre- and postprocessing. Saxon and
  Clojure both require a Java runtime.

[SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/)
: a C++ library and toolbox for finite state transducers (FSTs); please take a
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

## Build the DWDSmor lexicon from the DWDS dictionary

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

Generates a lexicon from the given XML documents and/or directories
containing XML documents (files ending in .xml).

Options:
  -x, --xslt XSLT          XSLT stylesheet extracting lexicon entries from DWDS article files
  -o, --output OUTPUT      Path of the file the generated lexicon is written to
  -s, --smorlemma-lexica   Include additional lexica from SMORLemma
  -f, --filter             Filter entries with tag <UNKNOWN>
  -l, --limit MAX_ENTRIES  Limit the number of extracted lexicon entries for testing
  -d, --debug              Print debugging information
  -h, --help
```

This script is called with appropriate options for building the DWDSmor lexicon
by running:

```sh
make -C lexicon
```

A log is saved in `SMORLemma/lexicon/lexicon.log`. This includes XSLT warnings,
if any.

By default, additional lexica from SMORLemma for irregular adjectives and
adverbs as well as for adpositions and affixes are included. In order to built a
lexicon without them, run:

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

Compiled automata can be exercised by the test suite in `tests/`:

```sh
make test
```

There is also a Python-based command line tool for performing morphological
analyses of word forms:

```plaintext
$ dwdsmor-analyze --help
Usage: dwdsmor-analyze [OPTIONS] [INPUT] [OUTPUT]

  DWDSmor Morphological Analysis

  Copyright (C) 2021 Berlin-Brandenburgische Akademie der Wissenschaften

  Feeds word forms – given as one form per line – into a finite state
  transducer and outputs the results – valid paths through the transducer
  representing possible analyses.

  INPUT is the file with word forms to analyze (defaults to stdin).

  OUTPUT is the file to write results to (defaults to stdout).

Options:
  -a, --automaton FILE  Path to the FST (compacted, i.e. *.ca)  [required]
  --csv                 Output in CSV format (default)
  --json                Output in JSON format
  --help                Show this message and exit.
```

A sample run:

```plaintext
$ printf "Männern\nManns\nFrauen\nMänner" | dwdsmor-analyze -a lib/smor-full.ca
Word,Analysis,Lemma,POS,Gender,Number,Case,Person,Tense
Männern,Ma:änn<+NN>:<><Masc>:<><>:e<>:r<Dat>:n<Pl>:<>,Mann,NN,Masc,Pl,Dat,,
Manns,Mann<+NN>:<><Masc>:<><Gen>:<><Sg>:<><>:s,Mann,NN,Masc,Sg,Gen,,
Frauen,Frau<+NN>:<><Fem>:<><>:e<>:n<Nom>:<><Pl>:<>,Frau,NN,Fem,Pl,Nom,,
Frauen,Frau<+NN>:<><Fem>:<><>:e<>:n<Gen>:<><Pl>:<>,Frau,NN,Fem,Pl,Gen,,
Frauen,Frau<+NN>:<><Fem>:<><>:e<>:n<Dat>:<><Pl>:<>,Frau,NN,Fem,Pl,Dat,,
Frauen,Frau<+NN>:<><Fem>:<><>:e<>:n<Acc>:<><Pl>:<>,Frau,NN,Fem,Pl,Acc,,
Männer,Ma:änn<+NN>:<><Masc>:<><>:e<>:r<Nom>:<><Pl>:<>,Mann,NN,Masc,Pl,Nom,,
Männer,Ma:änn<+NN>:<><Masc>:<><>:e<>:r<Gen>:<><Pl>:<>,Mann,NN,Masc,Pl,Gen,,
Männer,Ma:änn<+NN>:<><Masc>:<><>:e<>:r<Acc>:<><Pl>:<>,Mann,NN,Masc,Pl,Acc,,
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
