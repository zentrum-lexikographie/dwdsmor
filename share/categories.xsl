<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 0.15 -->
<!-- Andreas Nolda 2022-02-15 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- parts of speech-->

<xsl:variable name="pos-mapping">
  <pos pos="Adjektiv">ADJ</pos>
  <pos pos="Substantiv">NN</pos>
  <pos pos="Verb">V</pos>
  <pos pos="Partizip">V</pos><!-- ad-hoc POS -->
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
  <xsl:variable name="superlative"
                select="substring-after(normalize-space(dwds:Superlativ),'am ')"/>
  <xsl:variable name="superlative-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="$superlative"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$adjective-class-mapping/class[@pos=$pos]
                                                          [@superlative=$superlative-marker]"/>
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
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-ses"
         plural="-se">NMasc-s/sse</class>
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
       nominative plural: unmarked, with stem-final "n" -->
  <!-- cf. dwds.xsl -->
  <!-- genitive singular: "-s"
       nominative plural: unmarked, without stem-final "n" -->
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
  <!-- all forms except nominative singular: "-n" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-n"
         plural="-n">NMasc_n_n</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-"
         plural="-">NMasc_0_x</class>
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
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-ses"
         plural="-se">NNeut-s/sse</class>
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
       nominative plural: unmarked, with stem-final "n" -->
  <!-- cf. dwds.xsl -->
  <!-- genitive singular: "-s"
       nominative plural: unmarked, without stem-final "n" -->
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
  <!-- genitive singular: unmarked
       nominative plural: unmarked -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-"
         plural="-">NNeut_0_x</class>
  <!-- feminine nouns: -->
  <!-- genitive singular: unmarked
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-e">NFem_0_e</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="&#x308;-e">NFem_0_$e</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-se">NFem-s/sse</class>
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
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-s">NFem_0_s</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="&#x308;-">NFem_0_$</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-">NFem_0_x</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="gender"
                select="normalize-space(dwds:Genus)"/>
  <xsl:variable name="genitive"
                select="normalize-space(dwds:Genitiv)"/>
  <xsl:variable name="genitive-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="$genitive"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="plural"
                select="normalize-space(dwds:Plural)"/>
  <xsl:variable name="plural-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="$plural"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$noun-class-mapping/class[@pos=$pos]
                                                     [@gender=$gender]
                                                     [@genitive=$genitive-marker]
                                                     [@plural=$plural-marker]"/>
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
  <!-- weak verbs with irregular past stem: -->
  <!-- cf. dwds.xsl -->
  <!-- weak verbs with strong participle: -->
  <!-- cf. dwds.xsl -->
  <!-- strong verbs: -->
  <!-- cf. dwds.xsl -->
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
  <xsl:variable name="infinitive-marker">
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$lemma"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="past"
                select="normalize-space(dwds:Praeteritum)"/>
  <xsl:variable name="past-marker">
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$past"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="participle"
                select="normalize-space(dwds:Partizip_II)"/>
  <xsl:variable name="participle-marker">
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$participle"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$verb-class-mapping/class[@pos=$pos]
                                                     [@infinitive=$infinitive-marker]
                                                     [@past=$past-marker]
                                                     [@participle=$participle-marker]"/>
    <xsl:with-param name="type">class</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>
