This file logs the changes of the XSLT stylesheets in share/*.xsl.

2022-05-17:

* add support for adpositions
* add support for contracted adpositions

2022-05-12:

* add support for interjections
* add support for pronominal adverbs

2022-05-11:

* add support for adjectival participles
* add support for adverbs and adverbial participles

2022-04-20:

* add support for nouns in old spelling with nominative plural forms involving
  "ß"/"ss"-alternation
* add support for adjectives in old spelling with inflected forms involving
  "ß"/"ss"-alternation

2022-04-11:

* add support for capitalised adjectives derived from geographic proper names
* add support for ungradable adjectives with capitalised first member

2022-04-05:

* modularise `dwds.xsl` and add `entries.xsl`
* add support for multiple `<Artikel>` children of `<DWDS>`

2022-04-01:

* add support for modal verbs and related verbs
* add support for umlauted past subjunctive forms of "brauchen"

2022-03-31:

* add support for auxiliary verb "werden"

2022-03-30:

* add support for irregular verb "tun"

2022-03-29:

* add support for weak verbs with irregular past stem and regular participle stem
* unify processing of irregular verbs

2022-03-25:

* fix lexical entries of irregular verbs

2022-03-24:

* add support for strong verbs with 2nd/3rd person singular present stem without
  "e" epenthesis between stem-final "d" or "t" and suffix "-t"

2022-03-23:

* add support for weak verbs with irregular past stem without "e" epenthesis
  between stem-final "d" or "t" and suffix "-t"

2022-03-22:

* add support for masculine and neuter proper names with genitive singular forms
  ending in "-es" or "-s"

2022-03-21:

* add initial support for proper names
* ensure that dative plural forms of uppercase acronyms are not suffixed with "-n"

2022-03-11:

* add support for phrasal verbs
* add support for reflexive verbs

2022-03-02:

* add support for adjectives with irregular positive forms
* add support for adjectives with uninflected comparative forms
* add support for adjectives with superlative forms ending in "-ten"
* add support for adjectives with word-internal comparative and superlative
  markers

2022-02-28:

* add support for ungradable adjectives
* add support for uninflected adjectives
* add support for irregular adjectives
* add support for masculine and neuter nouns with nominative plural forms ending
  in optional "-s"
* add support for masculine nouns with nominative plural forms ending in "-e"
  substituted for "-us"
* add support for masculine and feminine nouns with nominative plural forms that
  are compounds with "Leute"

2022-02-25:

* simplify processing of nouns with genitive singular forms ending in optional "-s"
* add support for masculine and neuter nouns with genitive singular forms ending
  in "-s" and nominative plural forms ending in "-en" or "-i" substituted for "-o"

2022-02-24:

* add support for masculine nouns with genitive singular forms ending in "-es"
  or "-s" and nominative plural forms ending in "-ten"
* add support for masculine and neuter nouns with genitive singular forms ending
  in optional "-s" and nominative plural forms ending in "-s"
* add support for singularia tantum with genitive singular forms ending in
  optional "-s"

2022-02-23:

* add support for neuter nominalised adjectives with singular forms only

2022-02-22:

* generalise the functions `n:umlaut` and `n:umlaut-re` for geminate vowels
* add support for masculine and neuter nouns with unmarked genitive singular
  forms and nominative plural forms ending in "-s"
* add support for neuter nouns with genitive singular forms ending in "-s" and
  nominative plural forms ending in "-ina" substituted for "-en"

2022-02-21:

* add support for masculine, feminine, and neuter nominalised adjectives

2022-02-18:

* add support for masculine nouns with genitive singular forms ending in
  geminate "s" + "-es" or unmarked genitive singular forms and nominative plural
  forms ending in "-i" substituted for "-us"
* add support for neuter nouns with genitive singular forms ending in "-s" and
  nominative plural forms ending in "-a" substituted for "-on" or "-um"
* add support for feminine nouns with unmarked genitive singular forms and
  nominative plural forms ending in "-iden" substituted for "-is"
* add support for feminine nouns with genitive singular forms ending in "-s"
  and nominative plural forms ending in "-ta"
* add support for masculine and neuter singularia tantum with genitive singular
  forms ending in "-es" or "-s"
* add support for singularia tantum with unmarked genitive singular forms
* add support for pluralia tantum

2022-02-17:

* generalise the functions `n:umlaut` and `n:umlaut-re` for capitalised arguments
* add support for masculine and neuter nouns with genitive singular forms ending
  in "-s" and nominative plural forms ending in "-n"
* add support for masculine nouns with genitive singular forms ending in "-s"
  and umlauted nominative plural forms ending in "-e"
* add support for masculine nouns with genitive singular forms ending in "-ns"
  and nominative plural forms ending in "-n"
* add support for neuter nouns with genitive singular forms ending in "-ens"
  and nominative plural forms ending in "-en"
* add support for neuter nouns with genitive singular forms ending in "-s"
  and nominative plural forms ending in "-ien"
* add support for feminine nouns with unmarked genitive singular forms and
  nominative plural forms ending in geminate "n" + "-en"
* add support for masculine nouns with genitive singular forms ending in
  geminate "s" + "-es" or unmarked genitive singular forms and nominative plural
  forms ending in "-en" substituted for "-us"
* add support for neuter nouns with genitive singular forms ending in "-s" and
  nominative plural forms ending in "-en" substituted for "-a" or "-um"
* add support for feminine nouns with unmarked genitive singular forms and
  nominative plural forms ending in "-en" substituted for "-a" or "-is"

2022-02-15:

* add support for nouns with unmarked genitive singular and nominative plural
  forms
* add support for feminine nouns with unmarked genitive singular and umlauted
  nominative plural forms
* add support for feminine nouns with unmarked genitive singular forms and
  nominative plural forms ending in "-s"
* add support for feminine nouns with unmarked genitive singular forms and
  nominative plural forms ending in "-e"
* add support for feminine nouns with unmarked genitive singular forms and
  umlauted nominative plural forms ending in "-e"
* add support for feminine nouns with unmarked genitive singular forms and
  nominative plural forms ending in geminate "s" + "-e"
* add support for masculine and neuter nouns with genitive singular forms ending
  in geminate "s" + "-es" and nominative plural forms ending in geminate "s" +
  "-e"
* add support for masculine nouns with all forms except the nominative singular
  one ending in "-n"
* add warnings for articles with inappropriate grammar specifications

2022-02-14:
* add support for neuter nouns with genitive singular forms ending in "-es" or
  "-s" and nominative plural forms ending in "-e" or "-en"
* add support for masculine and neuter nouns with genitive singular and
  nominative plural forms ending in "-s"
* add support for masculine and neuter nouns with genitive singular forms ending
  in "-s" and unmarked or umlauted nominative plural forms
* add support for masculine nouns with genitive singular forms ending in "-es"
  and nominative plural forms ending in "-er"
* add support for neuter nouns with genitive singular forms ending in "-es" and
  umlauted nominative plural forms ending in "-er"
* add support for masculine and neuter nouns with genitive singular forms ending
  in "-es" and umlauted nominative plural forms ending in "-e"
* add support for feminine nouns with nominative plural forms ending in "-n"

2022-02-11:

* determine nominal and verbal inflection markers in a unified way
* do not generate spurious lexical entries for weak verbs with weak and strong participles
* add support for masculine nouns with genitive singular forms ending in "-s"
* treat genitive singular specifications "-(e)s" and "-es" as equivalent

2021-10-15:

* add support for strong verbs with weak participle
* add support for weak verbs with ablauted strong participle

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
