<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 0.11 -->
<!-- Andreas Nolda 2021-09-24 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- parts of speech-->

<xsl:variable name="pos-mapping">
  <pos pos="Adjektiv">ADJ</pos>
  <pos pos="Präfix">PREF</pos>
  <pos pos="Substantiv">NN</pos>
  <pos pos="Suffix">SUFF</pos>
  <pos pos="Verb">V</pos>
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
    <xsl:variable name="dwds"
                  select="substring-after(normalize-space(dwds:Superlativ),'am ')"/>
    <xsl:choose>
      <xsl:when test="matches($dwds,concat('^',$lemma,'sten$'))">-sten</xsl:when>
      <xsl:when test="matches($dwds,concat('^',n:umlaut-re($lemma),'sten$'))">&#x308;-sten</xsl:when>
      <xsl:when test="matches($dwds,concat('^',$lemma,'esten$'))">-esten</xsl:when>
      <xsl:when test="matches($dwds,concat('^',n:umlaut-re($lemma),'esten$'))">&#x308;-esten</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dwds"/>
      </xsl:otherwise>
    </xsl:choose>
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
  <!-- genitive singular: "-es"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-e">NMasc_es_e</class>
  <!-- genitive singular: "-es"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-en">NMasc_es_en</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="&#x308;-er">NMasc_es_$er</class>
  <!-- all forms except nominative singular: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive="-en"
         plural="-en">NMasc_en_en</class>
  <!-- feminine nouns: -->
  <!-- nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-en">NFem_0_en</class>
  <!-- neuter nouns: -->
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="-er">NNeut_es_er</class>
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
  <xsl:variable name="plural">
    <xsl:variable name="dwds"
                  select="normalize-space(dwds:Plural)"/>
    <xsl:choose>
      <xsl:when test="starts-with($dwds,'-')">
        <xsl:value-of select="$dwds"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('&#x308;-',replace(normalize-space($dwds),concat('^',n:umlaut-re($lemma)),
                                                                         ''))"/>
      </xsl:otherwise>
    </xsl:choose>
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
  <xsl:variable name="infinitive"
                select="concat('-',substring-after($lemma,$stem))"/>
  <xsl:variable name="past">
    <xsl:variable name="dwds"
                  select="normalize-space(dwds:Praeteritum)"/>
    <xsl:choose>
      <xsl:when test="matches($dwds,concat('^',$stem,'te$'))">-te</xsl:when>
      <xsl:when test="matches($dwds,concat('^',$stem,'ete$'))">-ete</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dwds"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="participle">
    <xsl:variable name="dwds"
                  select="normalize-space(dwds:Partizip_II)"/>
    <xsl:choose>
      <xsl:when test="matches($dwds,concat('^ge',$stem,'t$'))">ge-t</xsl:when>
      <xsl:when test="matches($dwds,concat('^',$stem,'t$'))">-t</xsl:when>
      <xsl:when test="matches($dwds,concat('^ge',$stem,'et$'))">ge-et</xsl:when>
      <xsl:when test="matches($dwds,concat('^',$stem,'et$'))">-et</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dwds"/>
      </xsl:otherwise>
    </xsl:choose>
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
