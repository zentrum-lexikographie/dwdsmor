DWDSmor
=======

This repository provides an XSLT stylesheet for generating SMOR-compatible
lexicons from XML files in the DWDS format.

The stylesheet may be run as follows:

    xsltproc share/dwds2smor.xsl <XML file>

Caveat: the stylesheet is meant as proof of concept and currently supports only
a limited range of DWDS articles, such as "Mann", "Frau", "Kind", "alt", and
"orgeln".

For comparison, this repo also gathers a set of legacy XSLT stylesheets which
likewise generate SMOR-compatible lexicons from XML files:

* `legacy/fitschen/*.{xml,xsl}`:
  file contents listed in [Fitschen (2004: Anhang F)](http://www.ims.uni-stuttgart.de/forschung/ressourcen/lexika/IMSLex/fitschendiss.pdf)
* `legacy/morphisto/*.xslt`:
  part of the [Morphisto repo at Google Code](https://code.google.com/archive/p/morphisto/)
* `legacy/smorlemma/*.xslt`:
  part of the [SMORLemma repo at GitHub](https://github.com/rsennrich/SMORLemma/)

Andreas Nolda <andreas.nolda@bbaw.de>
