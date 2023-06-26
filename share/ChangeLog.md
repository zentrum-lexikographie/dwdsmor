2023-06-26:

* add `dwds2dwds.xsl` for compiling sample DWDS lexica from DWDS sources

2023-05-19:

* add support for common abbrevations
* add support for alternate imperative singular form "siehe" of "sehen"
* add support for neuter nouns with genitive singular forms ending in "-es" or
  "-s" and nominative plural forms ending in "-ien"
* add support for masculine or neuter nouns with nominative plural forms ending
  in "-en" substituted for "-os"

2023-05-15:

* remove support for generating lexical entries from non-standard spellings in
  DWDS articles, which lack proper grammatical information for them

2023-05-10:

* use new "ss" spellings as lemmas for old "ß" spellings

2023-05-08:

* add support for more old spellings of verb forms

2023-05-04:

* add support for old spellings of verb forms

2023-05-03:

* add support for verbs with archaic past subjunctive forms

2023-04-26:

* do not inflect abbreviated nouns and adjectives

2023-04-25:

* do not mark case government of adpositions

2023-03-29:

* move templates from `dwsd2dwdsmor.xsl` to `entries.xsl`
* move templates from `dwds.xsl` to `dwsd2dwdsmor.xsl`
* remove `dwds.xsl`
* mark derivation stems with suffix

2023-03-28:

* add support for masculine and neuter nouns with unmarked genitive singular
  forms and nominative plural forms ending in "-e"
* add support for masculine nouns with unmarked genitive singular forms and
  umlauted nominative plural forms ending in "-e"
* add support for neuter nouns with unmarked genitive singular forms and
  nominative plural forms ending in geminate "s" + "-e"
* add support for nouns with unmarked genitive singular forms, unmarked
  nominative plural forms, and dative plural forms ending in "-n"

2023-03-27:

* add support for adjectives with schwa-elision and umlauted comparative and
  superlative forms

2023-03-23:

* mark boundary between particle and verb with `<VB>`

2023-03-21:

* do not infer diminutive derivation stems from "lein"-suffixed lemmas, which
  may be phonologically reduced

2023-03-20:

* add support for lexical entries of derivation stems
* infer lexical entries of derivation stems from links derivation bases in DWDS
  articles listed in `manifest.xml`
* mark diminutive derivation-stem type
* remove tests for obsolete values of `Schreibung/@Typ`

2023-01-27:

* adapt lexicon processing to upstream markup of irregular positive forms

2022-12-20:

* pair lemma with compounding stem in compounding-stem entries

2022-12-13:

* make test for foreign lemmas more restrictive
* improve detection of abbreviations

2022-12-06:

* make processing of articles, cardinals, and pronouns more robust

2022-12-05:

* add `<FB>` before suffixes of compounding stems
* add `<Abbr>` in lexical entries of abbreviations

2022-12-02:

* add `dwds2manifest.xsl` for generating `manifest.xml` from DWDS articles in
  `$dwds-dir` and `$aux-dir`
* respect `exclude.xml` while generating `manifest.xml`
* recursively process DWDS articles in `$dwds-dir` and `$aux-dir`
* infer lexical entries of compounding stems from links to compound bases in
  DWDS articles listed in `manifest.xml`
* add file names to warnings

2022-11-21:

* rename `dwdsmor-minimal.fst` to `dwdsmor-finite.fst`

2022-11-18:

* align forms and analyses of compound variants

2022-11-17:

* add support for lexical entries of nominal compounding stems

2022-11-14:

* add support for Arabic and Roman numerals
* add support for punctuation marks
* add support for neuter nouns with genitive singular forms ending in "-s" and
  nominative plural forms ending in "-en" substituted for "-on"
* add support for feminine nouns with unmarked genitive singular forms and
  umlauted nominative plural forms ending in "-en"

2022-11-11:

* add support for masculine nouns with genitive singular forms ending in "-s"
  and nominative plural forms ending in "-er"
* add support for masculine or neuter nouns with genitive singular forms ending
  in "-s" and umlauted nominative plural forms ending in "-er"

2022-11-08:

* add support for masculine or neuter nouns with genitive singular forms ending
  in "-(e)s" and nominative plural forms ending in "-es"
* add support for feminine nouns with unmarked genitive singular and nominative
  plural forms ending in "-es"
* add support for nouns with nominative plural forms ending ending in "-s" or "-es"
* add support for nouns with nominative plural forms ending ending in "-e" or "-en"

2022-09-20:

* use stricter rules for identifying attributive-only or predicative-only adjectives
* add better support for exceptional adjectives

2022-09-08:

* add `$status` parameter for specifying the status of DWDS articles to be considered

2022-09-05:

* add support for masculine and neuter nouns with genitive singular forms ending
  in "-s" and nominative plural forms ending in "-nen"
* add support for masculine and neuter nouns with unmarked genitive singular
  forms and nominative plural forms ending in "-nen"

2022-09-02:

* restrict inflection classes with dative plural "-n" to nouns with final schwa-syllable
* use phonetic transcriptions for identifying final schwa-syllables

2022-09-01:

* add support for masculine or neuter nouns with genitive singular forms ending
  in "-(e)s" and nominative plural forms ending in "-s"

2022-08-31:

* add proper lemmas for reflexive personal pronouns

2022-08-30:

* add support for ordinals

2022-08-29:

* add support for more indefinite pronouns
* add support for more cardinals

2022-08-24:

* add support for masculine nouns with nominative plural forms ending in
  "-anten" substituted for "-as"
* add support for neuter nouns with nominative plural forms ending in "-en"
  substituted for "-us"

2022-08-23:

* add support for paradigm indices

2022-08-19:

* rename `dwds2smorlemma.xsl` to `dwds2dwdsmor.xsl`

2022-08-17:

* add support for auxiliary tags of past participles

2022-08-15:

* add support for more indefinite pronouns

2022-08-12:

* add support for attributive-only adjectives
* add support for predicative-only adjectives

2022-08-11:

* add support for personal pronouns
* add support for more interrogative pronouns
* add support for more indefinite pronouns

2022-08-10:

* add support for more pronouns

2022-08-05:

* add preliminary support for articles, pronouns, and cardinals

2022-08-03:

* simplify templates for lexical entries

2022-07-06:

* add support for adjectives with schwa-elision

2022-07-05:

* add support for reduced form of "Innere" without schwa

2022-06-29:

* prohibit prefixation of particle verbs with another verb particle

2022-06-25:

* add support for homographic lemma indices

2022-06-21:

* add support for proper names with genitive forms ending in optional "'"

2022-05-18:

* add support for conjunctions
* add support for particles

2022-05-17:

* add support for adpositions
* add support for contracted adpositions
* weaken idiom filter
* add support for neuter singularia tantum with genitive singular forms ending
  in geminate "s" + "-es"

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
