# DWDSmor

_SFST/SMOR/DWDS-based German morphology_

This project aims at developing a component for **morphological analysis of
German word forms** mainly for **decomposing compound words** and
**lemmatisation**. To this end we adopt

1. [SFST](https://www.cis.uni-muenchen.de/~schmid/tools/SFST/), a C++ library
   and toolbox for finite state transducers (FSTs),
1. [SMORLemma](https://github.com/rsennrich/SMORLemma), a modified version of
   the Stuttgart Morphology ([SMOR](https://www.cis.lmu.de/~schmid/tools/SMOR/))
   with an alternative lemmatisation component, and the
1. [DWDS dictionary](https://www.dwds.de/) replacing
   [IMSLex](https://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/imslex/)
   as the as the lexical data source for word components and their respective
   morphological annotations (part-of-speech, inflection class etc.).

Source code in this repository implements various steps in the process of
building and using FSTs for morphological analysis:

* `lexicon/` and `share/` contain sources for extracting SMOR-compatible lexicon
  entries from DWDS/XML documents comprising the lexical database.
* `sfst/` and `SMORLemma/` import sources from upstream repositories as Git
  submodules, providing the mentioned FST library, the morphology as well as
  Python bindings for applying compiled FSTs.
* `dwdsmor/` and `tests/` implement a Python library and accompanying test suite
  for using DWDSmor transducers for the aforementioned linguistic tasks.

## Prerequisites

[GNU/Linux](https://www.debian.org/)
: Development, builds and tests of DWDSmor are performed on [Debian
  GNU/Linux](https://debian.org/) (currently v10 “Buster”). While other
  UNIX-like operating systems (i. e. MacOS) might work, they are not supported.

[Python v3 (including dev headers)](https://www.python.org/)
: DWDSmor targets Python as its primary runtime environment. Building a
  transducer involves other languages and platforms as well; for example XSLT
  and Clojure on the JVM for lexicon generation. But ultimately, compiled
  transducers are supposed to be used via SFST's commandline tools or to be
  queried in Python applications via the included
  [bindings](https://github.com/gremid/sfst). As the bindings are compiled as
  part of the DWDSmor build, resources for compiling Python extensions (header
  files, C/C++ compiler, GNU make) must be installed.

[Java (JDK) >= v8](https://openjdk.java.net/)
: The extraction of lexicon entries from DWDS/XML articles files is implemented
  in XSLT 2, for which [Saxon-HE](https://www.saxonica.com/) is used as the
  runtime environment. The conversion of the whole dictionary (or larger parts)
  is orchestrated via a [Clojure](https://clojure.org/) script, running multiple
  XSLT pipelines in parallel and doing some pre- and postprocessing. Saxon and
  Clojure both require a Java runtime.

[CMake v3.1](https://cmake.org/), [Bison](https://www.gnu.org/software/bison/)
and [Flex v2.6.4](https://github.com/westes/flex)
: The SFST library and toolbox as well as its Python bindings require a recent
  version of `cmake` and `flex`/`bison` for compilation.

On a recent Debian GNU/Linux, install the following packages:

```sh
apt install\
    build-essential cmake bison flex\
    python3 libpython3-dev\
    default-jdk
```

Optionally set up a virtual environment for project builds, i. e. via
[pyenv](https://github.com/pyenv/pyenv):

```sh
$ curl https://pyenv.run | bash
$ make pyenv
```

or python's venv

```sh
python3 -m venv .venv
source .venv/bin/activate
```

## Extract the lexicon from the DWDS dictionary

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

After updating the submodules, a lexicon can be built via:

```sh 
make -C lexicon
```

The result is stored in `SMORLemma/lexicon/lexicon` where it is picked up by the
FST compilation process of SMORLemma.

Extracting the lexicon via `make` operates on the complete DWDS dataset. For
testing purposes, the extraction process can be called separately and with
varying input documents. First change to the `lexicon/` directory and make sure
that the Clojure installation is in place:

```sh
cd lexicon
make clojure
```

Then call the extraction script as follows to list its supported parameters:

```plaintext
$ ./generate-lexicon --help
DWDSmor Lexicon Generation
Copyright (C) 2021 Berlin-Brandenburgische Akademie der Wissenschaften

Usage: clojure -M -m dwdsmor.lexicon [options] <dir|*.xml>...

Generates a lexicon from the given XML documents and/or directories 
containing XML documents (files ending in .xml).

Options:
  -x, --xslt XSLT          XSLT stylesheet extracting lexicon entries from DWDS article files
  -o, --output OUTPUT      Path of the file the generated lexicon is written to
  -s, --smorlemma-lexica   include additional lexica from SMORLemma
  -l, --limit MAX_ENTRIES  Limit the number of extracted lexicon entries for testing
  -d, --debug              Print debugging information (including message from XSLT)
  -h, --help
```

A test run with two articles would resemble something like

```plaintext
$ ./generate-lexicon\
    --xslt ../share/dwds2smorlemma.xsl\
    --output ../SMORLemma/lexicon/lexicon\
    --debug\
    wb/WDG/ma/Mann-E_m_993.xml\
    wb/WDG/fr/Frau-E_f_7828.xml
[2021-08-31 08:44:39,788][INFO ][dwdsmor.lexicon     ] - Extracting lexicon entries from 2 file(s)
[2021-08-31 08:44:40,397][DEBUG][dwdsmor.lexicon     ] - Mann-E_m_993.xml -> <Stem>Mann<NN><base><nativ><NMasc_es_$er>
[2021-08-31 08:44:40,397][DEBUG][dwdsmor.lexicon     ] - Frau-E_f_7828.xml -> <Stem>Frau<NN><base><nativ><NFem_0_en>
[2021-08-31 08:44:40,399][INFO ][dwdsmor.lexicon     ] - Sorting lexicon entries and removing duplicates
[2021-08-31 08:44:40,401][INFO ][dwdsmor.lexicon     ] - Writing lexicon entries
[2021-08-31 08:44:40,403][INFO ][dwdsmor.lexicon     ] - Generated lexicon in PT0.624S
```

## Build FSTs

For compiling the transducers based on an extracted lexicon, first initialize
and update the submodules providing the FST library/toolbox and the SMORLemma
morphology:

```sh
git submodule init sfst SMORLemma
git submodule update sfst SMORLemma
```

Then run setup routines which compile SFST and install Python dependencies (into
the virtual environment, should you have set one up beforehand):

```sh
make setup
```

Once the setup succeeded and a lexicon is provided in
`SMORLemma/lexicon/lexicon`, the transducers can be compiled:

```sh 
make
```

The resulting automata can be found in `SMORLemma/*.a` and `SMORLemma/*.ca` and
tested via

```sh 
make test
```

Depending on the size of the lexicon, this compilation process can take several
hours, depending on available hardware resources, specifically on the amount of
memory. On machines with less than 256 GB RAM or for fast development
iterations, it is recommended to build FSTs based on a subset of the complete
lexicon and test against the resulting smaller automata. Once the development
reaches a state where the complete lexicon should be processed, the compilation
could be moved to the
[HLRN-IV](https://www.hlrn.de/supercomputer/hlrn-iv-system/) compute cluster.

### Building on HLRN-IV's “Lise”

Lise's standard compute nodes provide 384 GB RAM, which speeds up FST
compilation considerably in comparison to common PC hardware with smaller
memory.

In order to build FSTs there, log into the cluster and prepare the build
environment:

```sh
ssh bembbaw0@blogin.hlrn.de /scratch/usr/bembbaw0/dwdsmor/hlrn/setup
```

Then upload a lexicon:

```sh
scp $LEXICON bembbaw0@blogin.hlrn.de:/scratch/usr/bembbaw0/dwdsmor/SMORLemma/lexicon/lexicon
```

Finally run the build on a compute host:

```sh
ssh bembbaw0@blogin.hlrn.de sbatch /scratch/usr/bembbaw0/dwdsmor/hlrn/build 
```

You can check the status of running builds via

```sh 
ssh bembbaw0@blogin.hlrn.de squeue -l --me
```

## Contact

In case of any question or issues, please contact [Andreas
Nolda](mailto:andreas.nolda@bbaw.de) for questions related to the lexicon or
[Gregor Middell](mailto:gregor.middell@bbaw.de) for issues related to the build
process or integrating DWDSmor with your application.

## Bibliography

* A. Fitschen, “Ein Computerlinguistisches Lexikon Als Komplexes System,” 2004,
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
