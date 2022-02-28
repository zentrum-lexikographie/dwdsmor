<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 1.2 -->
<!-- Andreas Nolda 2022-02-28 -->

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

<xsl:template name="pos">
  <xsl:param name="lemma"/>
  <xsl:param name="pos"
             select="normalize-space(dwds:Wortklasse)"/>
  <xsl:choose>
    <xsl:when test="$pos='Affix' and
                    starts-with($lemma,'-')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$pos-mapping/pos[@pos='Suffix']"/>
        <xsl:with-param name="type">POS</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pos='Affix' and
                    ends-with($lemma,'-')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$pos-mapping/pos[@pos='Präfix']"/>
        <xsl:with-param name="type">POS</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$pos-mapping/pos[@pos=$pos]"/>
        <xsl:with-param name="type">POS</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

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
  <xsl:param name="pos"
             select="normalize-space(dwds:Wortklasse)"/>
  <xsl:param name="superlative"
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
       no plural -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-(e)s">NMasc/Sg_es</class>
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-es">NMasc/Sg_es</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-e">NMasc_es_e</class>
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-es"
         nominative-plural="-e">NMasc_es_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e">NMasc_es_$e</class>
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-e">NMasc_es_$e</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s">NMasc/Sg_s</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-e">NMasc_s_e</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-e">NMasc_s_$e</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-ses"
         nominative-plural="-se">NMasc-s/sse</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-en">NMasc_es_en</class>
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-es"
         nominative-plural="-en">NMasc_es_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-en">NMasc_s_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-n">NMasc_s_n</class>
  <!-- genitive singular: "-ens"
       nominative plural: "en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-ns"
         nominative-plural="-n">NMasc-ns</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-er">NMasc_es_er</class>
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-es"
         nominative-plural="-er">NMasc_es_er</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-er">NMasc_es_$er</class>
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-er">NMasc_es_$er</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-s">NMasc_s_s</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-">NMasc/Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-"
         nominative-plural="-se">NMasc-s0/sse</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-"
         nominative-plural="-s">NMasc_0_s</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, with stem-final "n"
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NMasc_s_x</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, without stem-final "n" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-">NMasc_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut, with stem-final "n"
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-">NMasc_s_$x</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut, without stem-final "n" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-">NMasc_s_$</class>
  <!-- all forms except nominative singular: "-en" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-en"
         nominative-plural="-en">NMasc_en_en</class>
  <!-- all forms except nominative singular: "-n" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-n"
         nominative-plural="-n">NMasc_n_n</class>
  <!-- nominalised adjectives: -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-n"
         nominative-plural="-(n)">NMasc-Adj</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NMasc_0_x</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/en">NMasc-o/en</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-en" substituted for "-us" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/en">NMasc-us/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-"
         nominative-plural="-us/en">NMasc-us/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/i">NMasc-o/i</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-i" substituted for "-us" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/i">NMasc-us/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-us" -->
  <class pos="Substantiv"
         gender="mask."
         genitive-singular="-"
         nominative-plural="-us/i">NMasc-us/i</class>
  <!-- neuter nouns: -->
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-(e)s">NNeut/Sg_es</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-es">NNeut/Sg_es</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-e">NNeut_es_e</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-es"
         nominative-plural="-e">NNeut_es_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e">NNeut_es_$e</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-e">NNeut_es_$e</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s">NNeut/Sg_s</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e">NNeut_s_e</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-ses"
         nominative-plural="-se">NNeut-s/sse</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-en">NNeut_es_en</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-es"
         nominative-plural="-en">NNeut_es_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en">NNeut_s_en</class>
  <!-- genitive singular: "-ens"
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-ens"
         nominative-plural="-en">NNeut-Herz</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-n">NNeut_s_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-er">NNeut_es_er</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-es"
         nominative-plural="-er">NNeut_es_er</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-er">NNeut_es_$er</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-er">NNeut_es_$er</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ien" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ien">NNeut-0/ien</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-s">NNeut_s_s</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ta" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ta">NNeut-a/ata</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, with stem-final "n"
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NNeut_s_x</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, without stem-final "n" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-">NNeut_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="&#x308;-">NNeut_s_$</class>
  <!-- nominalised adjectives without plural: -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-n">NNeut-Adj/Sg</class>
  <!-- nominalised adjectives: -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-n"
         nominative-plural="-(n)">NNeut-Adj</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-">NNeut/Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-"
         nominative-plural="-s">NNeut_0_s</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NNeut_0_x</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-a" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-a/en">NNeut-a/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/en">NNeut-o/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/i">NNeut-o/i</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ina" substituted for "-en" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en/ina">NNeut-en/ina</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-on" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/a">NNeut-on/a</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-um" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/a">NNeut-um/a</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-um" -->
  <class pos="Substantiv"
         gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/en">NNeut-um/en</class>
  <!-- feminine nouns: -->
  <!-- genitive singular: unmarked
       nominative plural: "-e" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-e">NFem_0_e</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-e">NFem_0_$e</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-se">NFem-s/sse</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-en">NFem_0_en</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "n" + "-en" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-nen">NFem-in</class>
  <!-- genitive singular: unmarked
       nominative plural: "-n" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-n">NFem_0_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-s">NFem_0_s</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-"
         dative-plural="-">NFem_0_$</class>
  <!-- nominalised adjectives: -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-n"
         nominative-plural="-(n)">NFem-Adj</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-">NFem/Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NFem_0_x</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-a" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-a/en">NFem-a/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-is" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-is/en">NFem-is/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-iden" substituted for "-is" -->
  <class pos="Substantiv"
         gender="fem."
         genitive-singular="-"
         nominative-plural="-is/iden">NFem-is/iden</class>
  <!-- pluralia tantum: -->
  <!-- nominative plural: with stem-final "n"
       dative plural: unmarked -->
  <class pos="Substantiv"
         dative-plural="-">N?/Pl_x</class>
  <!-- nominative plural: without stem-final "n" -->
  <class pos="Substantiv">N?/Pl_0</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:param name="pos"
             select="normalize-space(dwds:Wortklasse)"/>
  <xsl:param name="gender"
             select="normalize-space(dwds:Genus)"/>
  <xsl:param name="genitive-singular"
             select="normalize-space(dwds:Genitiv)"/>
  <xsl:param name="nominative-plural"
             select="normalize-space(dwds:Plural)"/>
  <xsl:param name="number-preference"
             select="normalize-space(dwds:Numeruspraeferenz)"/>
  <xsl:variable name="number">
    <xsl:choose>
      <xsl:when test="$number-preference='nur im Singular'">singular</xsl:when>
      <xsl:when test="$number-preference='nur im Plural'">plural</xsl:when>
      <xsl:otherwise>singular+plural</xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value">
      <xsl:choose>
        <!-- pluralia tantum -->
        <xsl:when test="$number='plural'">
          <xsl:choose>
            <!-- nominative plural: with stem-final "n"
                 dative plural: unmarked -->
            <xsl:when test="ends-with($lemma,'n')">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [not(@gender)]
                                                             [not(@genitive-singular)]
                                                             [not(@nominative-plural)]
                                                             [@dative-plural='-']"/>
            </xsl:when>
            <!-- other pluralia tantum -->
            <xsl:otherwise>
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [not(@gender)]
                                                             [not(@genitive-singular)]
                                                             [not(@nominative-plural)]
                                                             [not(@dative-plural)]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- singularia tantum -->
        <xsl:when test="$number='singular'">
          <xsl:variable name="genitive-singular-marker">
            <xsl:call-template name="get-nominal-marker">
              <xsl:with-param name="form"
                              select="$genitive-singular"/>
              <xsl:with-param name="lemma"
                              select="$lemma"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                         [@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [not(@nominative-plural)]
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- other nouns -->
        <xsl:otherwise>
          <xsl:variable name="genitive-singular-marker">
            <xsl:call-template name="get-nominal-marker">
              <xsl:with-param name="form"
                              select="$genitive-singular"/>
              <xsl:with-param name="lemma"
                              select="$lemma"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="nominative-plural-marker">
            <xsl:call-template name="get-nominal-marker">
              <xsl:with-param name="form"
                              select="$nominative-plural"/>
              <xsl:with-param name="lemma"
                              select="$lemma"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <!-- genitive singular: "-s"
                 nominative plural: umlaut or unmarked, with stem-final "n"
                 dative plural: unmarked -->
            <xsl:when test="$genitive-singular-marker='-s' and
                            ends-with($nominative-plural-marker,'-') and
                            ends-with($lemma,'n')">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural=$nominative-plural-marker]
                                                             [@dative-plural='-']"/>
            </xsl:when>
            <!-- genitive singular: unmarked
                 nominative plural: umlaut or unmarked
                 dative plural: unmarked -->
            <xsl:when test="$genitive-singular-marker='-' and
                            ends-with($nominative-plural-marker,'-')">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural=$nominative-plural-marker]
                                                             [@dative-plural='-']"/>
            </xsl:when>
            <!-- nominative plural: "-en" substituted for "-a" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'a') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)a$',
                                                                             '$1en'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-a/en']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-en" substituted for "-o" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'o') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)o$',
                                                                      '$1en'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-o/en']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-i" substituted for "-o" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'o') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)o$',
                                                                      '$1i'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-o/i']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-ina" substituted for "-en" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'en') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)en$',
                                                                      '$1ina'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-en/ina']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-en" substituted for "-is" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'is') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)is$',
                                                                      '$1en'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-is/en']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-iden" substituted for "-is" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'is') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)is$',
                                                                      '$1iden'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-is/iden']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-a" substituted for "-on" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'on') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)on$',
                                                                      '$1a'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-on/a']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-a" substituted for "-um" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'um') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)um$',
                                                                      '$1a'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-um/a']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-en" substituted for "-um" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'um') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)um$',
                                                                      '$1en'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-um/en']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-en" substituted for "-us" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'us') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)us$',
                                                                      '$1en'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-us/en']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- nominative plural: "-i" substituted for "-us" -->
            <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                            ends-with($lemma,'us') and
                            matches($nominative-plural,concat('^',
                                                              replace($lemma,'^(.+)us$',
                                                                      '$1i'),
                                                              '$'))">
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural='-us/i']
                                                             [not(@dative-plural)]"/>
            </xsl:when>
            <!-- other inflection classes -->
            <xsl:otherwise>
              <xsl:value-of select="$noun-class-mapping/class[@pos=$pos]
                                                             [@gender=$gender]
                                                             [@genitive-singular=$genitive-singular-marker]
                                                             [@nominative-plural=$nominative-plural-marker]
                                                             [not(@dative-plural)]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
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
  <xsl:param name="pos"
             select="normalize-space(dwds:Wortklasse)"/>
  <xsl:param name="past"
             select="normalize-space(dwds:Praeteritum)"/>
  <xsl:param name="participle"
             select="normalize-space(dwds:Partizip_II)"/>
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
  <xsl:variable name="past-marker"><!-- of weak verbs -->
    <xsl:call-template name="get-verbal-marker">
      <xsl:with-param name="form"
                      select="$past"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="participle-marker"><!-- of weak verbs or participles -->
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
