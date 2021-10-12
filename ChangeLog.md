This file logs the changes of the XSLT stylesheets in share/*.xsl.

2021-10-12:

* only consider (near-)final articles
* ignore invalid spellings

2021-09-24:

* modularise stylesheets
* rename `mappings.xsl` to `categories.xsl`
* reduce parameters of `affix-entry`, `verb-entry`, and `default-entry`

2021-09-16:

* add support for strong verbs
* add support for mixed verbs
* filter phrasal verbs
* ignore sources with missing information

2021-09-14:

* avoid duplicates

2021-09-09:

* document class mappings
* improve support for affixes

2021-09-06:

* simplify mapping.xsl
* fix inflection class for regular verbs ending in "-el" or "-er"

2021-08-31:

* filter idioms
* add support for multiple spellings
* add support for multiple grammatical data
* add support for participles of strong verbs
* add more noun class mappings

2021-08-30:

* add stylesheet for SMORLemma
* add more verb class mappings
* add `n:pair` function for generating colon-separated pairs

2021-08-24:

* port stylesheet to XSLT 2
* consider only the last umlautable vowel
* add mappings for regular verbs
* add initial support for affixes

2021-08-23:

* add adjective class mappings
* generate one lexical entry per `<Formangabe>`
* make sure that there is exactly one formation specification

2021-08-20:

* add check for loanwords
* add formation-type heuristics

2021-08-18:

* add more class mappings
* add warnings about unknown values

2021-08-17:

* initial commit
