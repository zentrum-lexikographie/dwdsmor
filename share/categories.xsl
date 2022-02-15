<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 0.14 -->
<!-- Andreas Nolda 2022-02-14 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- parts of speech-->

<xsl:variable name="pos-mapping">
  <pos pos="Adjektiv">ADJ</pos>
  <pos pos="Substantiv">NN</pos>
  <pos pos="Verb">V</pos>
  <pos pos="Präfix">PREF</pos>
  <pos pos="Suffix">SUFF</pos>
  <!-- TODO: more POS mappings -->
  <!-- ... -->
</xsl:variable>

<!-- inflection classes -->

<xsl:variable name="adjective-class-mapping">
  <!-- adjectives: -->
  <!-- superlative: "-sten" -->
  <class pos="Adjektiv"
         superlative="-sten">Adj+</class>
  <!-- superlative: umlaut and "-sten" -->
  <class pos="Adjektiv"
         superlative="&#x308;-sten">Adj$</class>
  <!-- superlative: "-esten" -->
  <class pos="Adjektiv"
         superlative="-esten">Adj+e</class>
  <!-- superlative: umlaut and "-esten" -->
  <class pos="Adjektiv"
         superlative="&#x308;-esten">Adj$e</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="adjective-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="superlative">
    <xsl:variable name="form"
                  select="substring-after(normalize-space(dwds:Superlativ),'am ')"/>
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$adjective-class-mapping/class[@pos=$pos]
                                                          [@superlative=$superlative]"/>
    <xsl:with-param name="type">class</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>

<xsl:variable name="noun-class-mapping">
  <!-- masculine nouns: -->
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="-e">NMasc_es_e</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-e">NMasc_es_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="&#x308;-e">NMasc_es_$e</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="&#x308;-e">NMasc_es_$e</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-s"
         plural="-e">NMasc_s_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="-en">NMasc_es_en</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-en">NMasc_es_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-s"
         plural="-en">NMasc_s_en</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="-er">NMasc_es_er</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-er">NMasc_es_er</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="&#x308;-er">NMasc_es_$er</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="&#x308;-er">NMasc_es_$er</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-s"
         plural="-s">NMasc_s_s</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-s"
         plural="-">NMasc_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-s"
         plural="&#x308;-">NMasc_s_$</class>
  <!-- all forms except nominative singular: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-en"
         plural="-en">NMasc_en_en</class>
  <!-- neuter nouns: -->
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="-e">NNeut_es_e</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-es"
         plural="-e">NNeut_es_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="&#x308;-e">NNeut_es_$e</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-es"
         plural="&#x308;-e">NNeut_es_$e</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-s"
         plural="-e">NNeut_s_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="-en">NNeut_es_en</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-es"
         plural="-en">NNeut_es_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-s"
         plural="-en">NNeut_s_en</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="-er">NNeut_es_er</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-es"
         plural="-er">NNeut_es_er</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="&#x308;-er">NNeut_es_$er</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-es"
         plural="&#x308;-er">NNeut_es_$er</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-s"
         plural="-s">NNeut_s_s</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-s"
         plural="-">NNeut_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-s"
         plural="&#x308;-">NNeut_s_$</class>
  <!-- feminine nouns: -->
  <!-- genitive singular: unmarked
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-en">NFem_0_en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-n" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-n">NFem_0_n</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="gender"
                select="normalize-space(dwds:Genus)"/>
  <xsl:variable name="genitive">
    <xsl:variable name="form"
                  select="normalize-space(dwds:Genitiv)"/>
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="plural">
    <xsl:variable name="form"
                  select="normalize-space(dwds:Plural)"/>
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$noun-class-mapping/class[@pos=$pos]
                                                     [@gender=$gender]
                                                     [@genitive=$genitive]
                                                     [@plural=$plural]"/>
    <xsl:with-param name="type">class</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>

<xsl:variable name="verb-class-mapping">
  <!-- weak verbs: -->
  <!-- infinitive: "-en"
       past 3rd person singular: "-te"
       past participle: "ge-" + "-t" -->
  <class pos="Verb"
         infinitive="-en"
         past="-te"
         participle="ge-t">VVReg</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class pos="Verb"
         infinitive="-en"
         past="-te"
         participle="-t">VVReg</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-ete"
       past participle: "ge-" + "-et" -->
  <class pos="Verb"
         infinitive="-en"
         past="-ete"
         participle="ge-et">VVReg</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-ete"
       past participle: "-et" -->
  <class pos="Verb"
         infinitive="-en"
         past="-ete"
         participle="-et">VVReg</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "ge-" + "-t" -->
  <class pos="Verb"
         infinitive="-n"
         past="-te"
         participle="ge-t">VVReg-el/er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class pos="Verb"
         infinitive="-n"
         past="-te"
         participle="-t">VVReg-el/er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-ete"
       past participle: "ge-" + "-et" -->
  <class pos="Verb"
         infinitive="-n"
         past="-ete"
         participle="ge-et">VVReg-el/er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-ete"
       past participle: "-et" -->
  <class pos="Verb"
         infinitive="-n"
         past="-ete"
         participle="-et">VVReg-el/er</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="verb-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="stem">
    <xsl:call-template name="verb-stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="infinitive">
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$lemma"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="past">
    <xsl:variable name="form"
                  select="normalize-space(dwds:Praeteritum)"/>
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="participle">
    <xsl:variable name="form"
                  select="normalize-space(dwds:Partizip_II)"/>
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$verb-class-mapping/class[@pos=$pos]
                                                     [@infinitive=$infinitive]
                                                     [@past=$past]
                                                     [@participle=$participle]"/>
    <xsl:with-param name="type">class</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>
