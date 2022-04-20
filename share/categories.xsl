<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 3.2 -->
<!-- Andreas Nolda 2022-04-20 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0">

<!-- inflection classes -->

<xsl:variable name="adjective-class-mapping">
  <!-- gradable adjectives: -->
  <!-- superlative: "-sten" or "-ten" -->
  <class superlative="-sten">Adj+</class>
  <class superlative="-ten">Adj+</class>
  <!-- superlative: umlaut and "-sten" or  "-ten" -->
  <class superlative="&#x308;-sten">Adj$</class>
  <class superlative="&#x308;-ten">Adj$</class>
  <!-- superlative: "-esten" -->
  <class superlative="-esten">Adj+e</class>
  <!-- superlative: "ß"/"ss"-alternation and "-esten" -->
  <class superlative="ß/ss-esten">Adj~+e</class>
  <!-- superlative: umlaut and "-esten" -->
  <class superlative="&#x308;-esten">Adj$e</class>
  <!-- superlative: "ß"/"ss"-alternation, umlaut, and "-esten" -->
  <class superlative="&#x308;ß/ss-esten">Adj~$e</class>
  <!-- ungradable adjectives: -->
  <class>AdjPos</class>
</xsl:variable>

<xsl:template name="adjective-class">
  <xsl:param name="lemma"/>
  <xsl:param name="superlative"/>
  <xsl:variable name="superlative-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="substring-after($superlative,'am ')"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- ungradable adjectives -->
    <xsl:when test="string-length($superlative)=0">
      <xsl:value-of select="$adjective-class-mapping/class[not(@superlative)]"/>
    </xsl:when>
    <!-- other adjectives -->
    <xsl:otherwise>
      <xsl:value-of select="$adjective-class-mapping/class[@superlative=$superlative-marker]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="noun-class-mapping">
  <!-- masculine nouns: -->
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="mask."
         genitive-singular="-(e)s">NMasc/Sg_es</class>
  <class gender="mask."
         genitive-singular="-es">NMasc/Sg_es</class>
  <!-- genitive singular: "ß"/"ss"-alternation and "-es"
       no plural -->
  <class gender="mask."
         genitive-singular="ß/ss-es">NMasc-s/Sg</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-e">NMasc_es_e</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-e">NMasc_es_e</class>
  <!-- genitive singular: "ß"/"ss"-alternation and "-es"
       nominative plural: "ß"/"ss"-alternation and "-e" -->
  <class gender="mask."
         genitive-singular="ß/ss-es"
         nominative-plural="ß/ss-e">NMasc-s/sse</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e">NMasc_es_$e</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-e">NMasc_es_$e</class>
  <!-- genitive singular: "ß"/"ss"-alternation and "-es"
       nominative plural: "ß"/"ss"-alternation, umlaut, and "-e" -->
  <class gender="mask."
         genitive-singular="ß/ss-es"
         nominative-plural="&#x308;ß/ss-e">NMasc-s/$sse</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="mask."
         genitive-singular="-s">NMasc/Sg_s</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-e">NMasc_s_e</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-e" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-e">NMasc_s_$e</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-se">NMasc-s/sse</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-en">NMasc_es_en</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-en">NMasc_es_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-en">NMasc_s_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-n">NMasc_s_n</class>
  <!-- genitive singular: "-ens"
       nominative plural: "en" -->
  <class gender="mask."
         genitive-singular="-ns"
         nominative-plural="-n">NMasc-ns</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-er">NMasc_es_er</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-er">NMasc_es_er</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-er">NMasc_es_$er</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-er">NMasc_es_$er</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-s">NMasc_s_s</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="mask."
         genitive-singular="-">NMasc/Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-se">NMasc-s0/sse</class>
  <!-- genitive singular: unmarked
       nominative plural: "ß"/"ss"-alternation and "-e" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="ß/ss-e">NMasc-s0/sse</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-s">NMasc_0_s</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, with stem-final "n" or uppercase lemma
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NMasc_s_x</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, without stem-final "n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-">NMasc_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut, with stem-final "n" or uppercase lemma
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-">NMasc_s_$x</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut, without stem-final "n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-">NMasc_s_$</class>
  <!-- all forms except nominative singular: "-en" -->
  <class gender="mask."
         genitive-singular="-en"
         nominative-plural="-en">NMasc_en_en</class>
  <!-- all forms except nominative singular: "-n" -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-n">NMasc_n_n</class>
  <!-- nominalised adjectives: -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-(n)">NMasc-Adj</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NMasc_0_x</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/en">NMasc-o/en</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-en" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/en">NMasc-us/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/e">NMasc-us/e</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/en">NMasc-us/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/i">NMasc-o/i</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-i" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/i">NMasc-us/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/i">NMasc-us/i</class>
  <!-- neuter nouns: -->
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-(e)s">NNeut/Sg_es</class>
  <class gender="neutr."
         genitive-singular="-es">NNeut/Sg_es</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-e">NNeut_es_e</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-e">NNeut_es_e</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e">NNeut_es_$e</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-e">NNeut_es_$e</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-s">NNeut/Sg_s</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e">NNeut_s_e</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class gender="neutr."
         genitive-singular="-ses"
         nominative-plural="-se">NNeut-s/sse</class>
  <!-- genitive singular: "ß"/"ss"-alternation and "-es"
       nominative plural: "ß"/"ss"-alternation and "-e" -->
  <class gender="neutr."
         genitive-singular="ß/ss-es"
         nominative-plural="ß/ss-e">NNeut-s/sse</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-en">NNeut_es_en</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-en">NNeut_es_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en">NNeut_s_en</class>
  <!-- genitive singular: "-ens"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-ens"
         nominative-plural="-en">NNeut-Herz</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-n">NNeut_s_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-er">NNeut_es_er</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-er">NNeut_es_er</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-er">NNeut_es_$er</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-er">NNeut_es_$er</class>
  <!-- genitive singular: "ß"/"ss"-alternation and "-es"
       nominative plural: "ß"/"ss"-alternation, umlaut, and "-er" -->
  <class gender="neutr."
         genitive-singular="ß/ss-es"
         nominative-plural="&#x308;ß/ss-er">NNeut-s/$sser</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ien" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ien">NNeut-0/ien</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-s">NNeut_s_s</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ta" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ta">NNeut-a/ata</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, with stem-final "n" or uppercase lemma
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NNeut_s_x</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked, without stem-final "n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-">NNeut_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="&#x308;-">NNeut_s_$</class>
  <!-- nominalised adjectives without plural: -->
  <class gender="neutr."
         genitive-singular="-n">NNeut-Adj/Sg</class>
  <!-- nominalised adjectives: -->
  <class gender="neutr."
         genitive-singular="-n"
         nominative-plural="-(n)">NNeut-Adj</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="neutr."
         genitive-singular="-">NNeut/Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-s">NNeut_0_s</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NNeut_0_x</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-a" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-a/en">NNeut-a/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/en">NNeut-o/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/i">NNeut-o/i</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ina" substituted for "-en" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en/ina">NNeut-en/ina</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-on" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/a">NNeut-on/a</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-um" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/a">NNeut-um/a</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-um" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/en">NNeut-um/en</class>
  <!-- feminine nouns: -->
  <!-- genitive singular: unmarked
       nominative plural: "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-e">NFem_0_e</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-e">NFem_0_$e</class>
  <!-- genitive singular: unmarked
       nominative plural: "ß"/"ss"-alternation, umlaut, and "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;ß/ss-e">NFem-s/$sse</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-se">NFem-s/sse</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-en">NFem_0_en</class>
  <!-- genitive singular: unmarked
       nominative plural: "ß"/"ss"-alternation and "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="ß/ss-en">NFem-s/ssen</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "n" + "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-nen">NFem-in</class>
  <!-- genitive singular: unmarked
       nominative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-n">NFem_0_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-s">NFem_0_s</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-"
         dative-plural="-">NFem_0_$</class>
  <!-- nominalised adjectives: -->
  <class gender="fem."
         genitive-singular="-n"
         nominative-plural="-(n)">NFem-Adj</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="fem."
         genitive-singular="-">NFem/Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NFem_0_x</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-a" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-a/en">NFem-a/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-is" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/en">NFem-is/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-iden" substituted for "-is" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/iden">NFem-is/iden</class>
  <!-- pluralia tantum: -->
  <!-- nominative plural: with stem-final "n" or uppercase lemma
       dative plural: unmarked -->
  <class dative-plural="-">N?/Pl_x</class>
  <!-- nominative plural: without stem-final "n" -->
  <class>N?/Pl_0</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:choose>
    <!-- pluralia tantum -->
    <xsl:when test="$number='plural'">
      <xsl:choose>
        <!-- nominative plural: with stem-final "n" or uppercase lemma
             dative plural: unmarked -->
        <xsl:when test="ends-with($lemma,'n') or
                        matches($lemma,'^\p{Lu}+$')">
          <xsl:value-of select="$noun-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- other pluralia tantum -->
        <xsl:otherwise>
          <xsl:value-of select="$noun-class-mapping/class[not(@gender)]
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
      <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
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
             nominative plural: umlaut or unmarked, with stem-final "n" or uppercase lemma
             dative plural: unmarked -->
        <xsl:when test="$genitive-singular-marker='-s' and
                        ends-with($nominative-plural-marker,'-') and
                        (ends-with($lemma,'n') or
                         matches($lemma,'^\p{Lu}+$'))">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- genitive singular: unmarked
             nominative plural: umlaut or unmarked
             dative plural: unmarked -->
        <xsl:when test="$genitive-singular-marker='-' and
                        ends-with($nominative-plural-marker,'-')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-a" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'a') and
                        $nominative-plural=replace($lemma,'a$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-a/en']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-o" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'o') and
                        $nominative-plural=replace($lemma,'o$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-o/en']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-i" substituted for "-o" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'o') and
                        $nominative-plural=replace($lemma,'o$','i')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-o/i']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-ina" substituted for "-en" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'en') and
                        $nominative-plural=replace($lemma,'en$','ina')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-en/ina']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/en']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-iden" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','iden')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/iden']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-a" substituted for "-on" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'on') and
                        $nominative-plural=replace($lemma,'on$','a')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-on/a']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-a" substituted for "-um" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'um') and
                        $nominative-plural=replace($lemma,'um$','a')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-um/a']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-um" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'um') and
                        $nominative-plural=replace($lemma,'um$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-um/en']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-e" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','e')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/e']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/en']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- nominative plural: "-i" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','i')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/i']
                                                         [not(@dative-plural)]"/>
        </xsl:when>
        <!-- other inflection classes -->
        <xsl:otherwise>
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [not(@dative-plural)]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="name-class-mapping">
  <!-- masculine proper names: -->
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="mask."
         genitive-singular="-(e)s">Name-Masc_es</class>
  <class gender="mask."
         genitive-singular="-es">Name-Masc_es</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="mask."
         genitive-singular="-s">Name-Masc_s</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="mask."
         genitive-singular="-">Name-Masc_0</class>
  <!-- neuter proper names: -->
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-(e)s">Name-Neut_es</class>
  <class gender="neutr."
         genitive-singular="-es">Name-Neut_es</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-s">Name-Neut_s</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="neutr."
         genitive-singular="-">Name-Neut_0</class>
  <!-- feminine proper names: -->
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="fem."
         genitive-singular="-s">Name-Fem_s</class>
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="fem."
         genitive-singular="-">Name-Fem_0</class>
  <!-- plural proper names: -->
  <!-- nominative plural: with stem-final "n"
       dative plural: unmarked -->
  <class dative-plural="-">Name-Pl_x</class>
  <!-- nominative plural: without stem-final "n" -->
  <class>Name-Pl_0</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="name-class">
  <xsl:param name="lemma"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:choose>
    <!-- plural proper names -->
    <xsl:when test="$number='plural'">
      <xsl:choose>
        <!-- nominative plural: with stem-final "n" or uppercase lemma
             dative plural: unmarked -->
        <xsl:when test="ends-with($lemma,'n') or
                        matches($lemma,'^\p{Lu}+$')">
          <xsl:value-of select="$name-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- other plural proper names -->
        <xsl:otherwise>
          <xsl:value-of select="$name-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [not(@dative-plural)]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- singular proper names -->
    <xsl:when test="$number='singular'">
      <xsl:variable name="genitive-singular-marker">
        <xsl:call-template name="get-nominal-marker">
          <xsl:with-param name="form"
                          select="$genitive-singular"/>
          <xsl:with-param name="lemma"
                          select="$lemma"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$name-class-mapping/class[@gender=$gender]
                                                     [@genitive-singular=$genitive-singular-marker]
                                                     [not(@nominative-plural)]
                                                     [not(@dative-plural)]"/>
    </xsl:when>
    <!-- other proper names -->
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
      <xsl:value-of select="$name-class-mapping/class[@gender=$gender]
                                                     [@genitive-singular=$genitive-singular-marker]
                                                     [@nominative-plural=$nominative-plural-marker]
                                                     [not(@dative-plural)]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="verb-class-mapping">
  <!-- weak verbs: -->
  <!-- infinitive: "-en"
       past 3rd person singular: "-te"
       past participle: "ge-" + "-t" -->
  <class infinitive="-en"
         past="-te"
         participle="ge-t">VVReg</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class infinitive="-en"
         past="-te"
         participle="-t">VVReg</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-ete"
       past participle: "ge-" + "-et" -->
  <class infinitive="-en"
         past="-ete"
         participle="ge-et">VVReg</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-ete"
       past participle: "-et" -->
  <class infinitive="-en"
         past="-ete"
         participle="-et">VVReg</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "ge-" + "-t" -->
  <class infinitive="-n"
         past="-te"
         participle="ge-t">VVReg-el/er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class infinitive="-n"
         past="-te"
         participle="-t">VVReg-el/er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-ete"
       past participle: "ge-" + "-et" -->
  <class infinitive="-n"
         past="-ete"
         participle="ge-et">VVReg-el/er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-ete"
       past participle: "-et" -->
  <class infinitive="-n"
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
  <xsl:param name="past"/>
  <xsl:param name="participle"/>
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
  <xsl:value-of select="$verb-class-mapping/class[@infinitive=$infinitive-marker]
                                                 [@past=$past-marker]
                                                 [@participle=$participle-marker]"/>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for the following inflection classes:
* <Abk_ADJ>
* <Abk_ADV>
* <Abk_KONJ>
* <Abk_NE>
* <Abk_NEFem>
* <Abk_NFem>
* <Abk_NMasc>
* <Abk_NN>
* <Abk_NNeut>
* <Adj&>
* <Adj+(e)>
* <Adj-el/er>
* <AdjComp>
* <AdjNNSuff>
* <AdjPosAttr-Up>
* <Adv>
* <FamName_0>
* <FamName_s>
* <Intj>
* <Konj-Kon>
* <Konj-Sub>
* <Konj-Vgl>
* <NFem_s_s>
* <NMasc_en_e>
* <Postp-Akk>
* <Postp-Dat>
* <Postp-Gen>
* <Pref/Sep>
* <Prep-Akk>
* <Prep-DA>
* <Prep-Dat>
* <Prep-GD>
* <Prep-GDA>
* <Prep-Gen>
* <Prep/Art-m>
* <Prep/Art-n>
* <Prep/Art-r>
* <Prep/Art-s>
* <ProAdv>
* <Ptkl-Ant>
* <Ptkl-Neg>
* <VMPast>
* <VMPastKonj>
* <WAdv> -->
