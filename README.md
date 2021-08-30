DWDSmor
=======

This repository provides XSLT 2 stylesheets for generating lexicons compatible
with SMOR and SMORLemma from XML files in the DWDS format.

The stylesheets have been tested to work with Saxon 9.9, as provided by the Debian
package `libsaxonhe-java`. On Debian, they may be run as follows:

    java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform <XML file> share/dwds2smor.xsl

    java -cp /usr/share/java/Saxon-HE.jar net.sf.saxon.Transform <XML file> share/dwds2smorlemma.xsl

Note that both stylesheets include the stylesheet `share/mappings.xsl` with
common mappings, functions, and templates.

Caveat: the stylesheets are meant as proof of concept and currently support only
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
