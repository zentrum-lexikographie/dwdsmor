<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 5.1 -->
<!-- Andreas Nolda 2023-05-19 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

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
  <!-- superlative: umlaut and "-esten" -->
  <class superlative="&#x308;-esten">Adj$e</class>
  <!-- ungradable adjectives: -->
  <class>AdjPos</class>
</xsl:variable>

<xsl:template name="adjective-class">
  <xsl:param name="lemma"/>
  <xsl:param name="superlative"/>
  <xsl:param name="pronunciations"/>
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
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="mask."
         genitive-singular="-">NMasc/Sg_0</class>
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="mask."
         genitive-singular="-(e)s">NMasc/Sg_es</class>
  <class gender="mask."
         genitive-singular="-es">NMasc/Sg_es</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="mask."
         genitive-singular="-s">NMasc/Sg_s</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NMasc_0_x</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-n">NMasc_0_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-e">NMasc_0_e</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-se">NMasc_0_e~ss</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="&#x308;-e">NMasc_0_$e</class>
  <!-- genitive singular: unmarked
       nominative plural: "-nen" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-nen">NMasc_0_nen</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-s">NMasc_0_s</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-e">NMasc_es_e</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-e">NMasc_es_e</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-se">NMasc_es_e~ss</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e">NMasc_es_$e</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-e">NMasc_es_$e</class>
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
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-en">NMasc_es_en</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-en">NMasc_es_en</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-es" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-es">NMasc_es_es</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-es">NMasc_es_es</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-s" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-s">NMasc_es_s</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-s">NMasc_es_s</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NMasc_s_x</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-">NMasc_s_$x</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-n">NMasc_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-n">NMasc_s_$</class>
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
  <!-- genitive singular: "-s"
       nominative plural: "-er" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-er">NMasc_s_er</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-er" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-er">NMasc_s_$er</class>
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
  <!-- genitive singular: "-s"
       nominative plural: "-nen" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-nen">NMasc_s_nen</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-s">NMasc_s_s</class>
  <!-- all forms except nominative singular: "-en" -->
  <class gender="mask."
         genitive-singular="-en"
         nominative-plural="-en">NMasc_en_en</class>
  <!-- all forms except nominative singular: "-n" -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-n">NMasc_n_n</class>
  <!-- genitive singular: "-ens"
       nominative plural: "en" -->
  <class gender="mask."
         genitive-singular="-ns"
         nominative-plural="-n">NMasc-ns</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/en">NMasc-o/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-anten" substituted for "-as" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-as/anten">NMasc-as0/anten</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-anten" substituted for "-as" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-as/anten">NMasc-as/anten</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/en">NMasc-us0/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-os" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-os/en">NMasc-us0/en<!-- sic! --></class>
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
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/i">NMasc-o/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/i">NMasc-us0/i</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-i" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/i">NMasc-us/i</class>
  <!-- nominalised adjectives: -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-(n)">NMasc-Adj</class>
  <!-- neuter nouns: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="neutr."
         genitive-singular="-">NNeut/Sg_0</class>
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-(e)s">NNeut/Sg_es</class>
  <class gender="neutr."
         genitive-singular="-es">NNeut/Sg_es</class>
  <!-- genitive singular: geminate "s" + "-es"
       no plural -->
  <class gender="neutr."
         genitive-singular="-ses">NNeut/Sg_es~ss</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-s">NNeut/Sg_s</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NNeut_0_x</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-n">NNeut_0_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-e">NNeut_0_e</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-se">NNeut_0_e~ss</class>
  <!-- genitive singular: unmarked
       nominative plural: "-nen" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-nen">NNeut_0_nen</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-s">NNeut_0_s</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-e">NNeut_es_e</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-e">NNeut_es_e</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e" -->
  <class gender="neutr."
         genitive-singular="-ses"
         nominative-plural="-se">NNeut_es_e~ss</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e">NNeut_es_$e</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-e">NNeut_es_$e</class>
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
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-en">NNeut_es_en</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-en">NNeut_es_en</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-es" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-es">NNeut_es_es</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-es">NNeut_es_es</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-ien" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-ien">NNeut_es_ien</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-ien">NNeut_es_ien</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-s" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-s">NNeut_es_s</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-s">NNeut_es_s</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NNeut_s_x</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-n">NNeut_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-n">NNeut_s_$</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e">NNeut_s_e</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-er" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="&#x308;-er">NNeut_s_$er</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en">NNeut_s_en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-n">NNeut_s_n</class>
  <!-- genitive singular: "-ens"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-ens"
         nominative-plural="-en">NNeut-Herz</class>
  <!-- genitive singular: "-s"
       nominative plural: "-nen" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-nen">NNeut_s_nen</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ien" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ien">NNeut_s_ien</class>
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
       nominative plural: "-en" substituted for "-on" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/en">NNeut-on/en</class>
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
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/en">NNeut-us0/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-os" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-os/en">NNeut-us0/en<!-- sic! --></class>
  <!-- nominalised adjectives without plural: -->
  <class gender="neutr."
         genitive-singular="-n">NNeut-Adj/Sg</class>
  <!-- nominalised adjectives: -->
  <class gender="neutr."
         genitive-singular="-n"
         nominative-plural="-(n)">NNeut-Adj</class>
  <!-- feminine nouns: -->
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
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-n">NFem_0_0</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-"
         dative-plural="-n">NFem_0_$</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-e">NFem_0_e</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-se">NFem_0_e~ss</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-e">NFem_0_$e</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-en">NFem_0_en</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-en">NFem_0_$en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-n">NFem_0_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-es">NFem_0_es</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-s">NFem_0_s</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "n" + "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-nen">NFem-in</class>
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
  <!-- nominalised adjectives: -->
  <class gender="fem."
         genitive-singular="-n"
         nominative-plural="-(n)">NFem-Adj</class>
  <!-- pluralia tantum: -->
  <!-- dative plural: unmarked -->
  <class dative-plural="-">NNoGend/Pl_x</class>
  <!-- dative plural: "-n" -->
  <class dative-plural="-n">NNoGend/Pl_0</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- pluralia tantum -->
    <xsl:when test="$number='plural'">
      <xsl:choose>
        <!-- nominative plural: with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="n:has-final-schwa-syllable($lemma, $pronunciations)">
          <xsl:value-of select="$noun-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-n']"/>
        </xsl:when>
        <!-- other pluralia tantum -->
        <xsl:otherwise>
          <xsl:value-of select="$noun-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [not(@dative-plural='-n')]"/>
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
                                                     [not(@nominative-plural)]"/>
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
             nominative plural: umlaut or unmarked, with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="$genitive-singular-marker='-s' and
                        ends-with($nominative-plural-marker,'-') and
                        n:has-final-schwa-syllable($lemma, $pronunciations)">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [@dative-plural='-n']"/>
        </xsl:when>
        <!-- genitive singular: "-s"
             nominative plural: umlaut or unmarked, without final schwa-syllable
             dative plural: unmarked -->
        <xsl:when test="$genitive-singular-marker='-s' and
                        ends-with($nominative-plural-marker,'-')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [not(@dative-plural='-n')]"/>
        </xsl:when>
        <!-- genitive singular: unmarked
             nominative plural: umlaut or unmarked, with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="$genitive-singular-marker='-' and
                        ends-with($nominative-plural-marker,'-') and
                        n:has-final-schwa-syllable($lemma, $pronunciations)">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [@dative-plural='-n']"/>
        </xsl:when>
        <!-- genitive singular: unmarked
             nominative plural: umlaut or unmarked, without final schwa-syllable
             dative plural: unmarked -->
        <xsl:when test="$genitive-singular-marker='-' and
                        ends-with($nominative-plural-marker,'-')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [not(@dative-plural='-n')]"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-a" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'a') and
                        $nominative-plural=replace($lemma,'a$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-a/en']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-o" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'o') and
                        $nominative-plural=replace($lemma,'o$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-o/en']"/>
        </xsl:when>
        <!-- nominative plural: "-i" substituted for "-o" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'o') and
                        $nominative-plural=replace($lemma,'o$','i')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-o/i']"/>
        </xsl:when>
        <!-- nominative plural: "-ina" substituted for "-en" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'en') and
                        $nominative-plural=replace($lemma,'en$','ina')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-en/ina']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/en']"/>
        </xsl:when>
        <!-- nominative plural: "-iden" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','iden')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/iden']"/>
        </xsl:when>
        <!-- nominative plural: "-a" substituted for "-on" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'on') and
                        $nominative-plural=replace($lemma,'on$','a')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-on/a']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-on" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'on') and
                        $nominative-plural=replace($lemma,'on$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-on/en']"/>
        </xsl:when>
        <!-- nominative plural: "-a" substituted for "-um" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'um') and
                        $nominative-plural=replace($lemma,'um$','a')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-um/a']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-um" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'um') and
                        $nominative-plural=replace($lemma,'um$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-um/en']"/>
        </xsl:when>
        <!-- nominative plural: "-e" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','e')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/e']"/>
        </xsl:when>
        <!-- nominative plural: "-anten" substituted for "-as" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'as') and
                        $nominative-plural=replace($lemma,'as$','anten')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-as/anten']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/en']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-os" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'os') and
                        $nominative-plural=replace($lemma,'os$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-os/en']"/>
        </xsl:when>
        <!-- nominative plural: "-i" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','i')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/i']"/>
        </xsl:when>
        <!-- other inflection classes -->
        <xsl:otherwise>
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:variable name="name-class-mapping">
  <!-- masculine proper names: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="mask."
         genitive-singular="-">Name-Masc_0</class>
  <!-- genitive singular: "-(’)"
       no plural -->
  <class gender="mask."
         genitive-singular="-(’)">Name-Masc_apos</class>
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
  <!-- neuter proper names: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="neutr."
         genitive-singular="-">Name-Neut_0</class>
  <!-- genitive singular: "-(’)"
       no plural -->
  <class gender="neut."
         genitive-singular="-(’)">Name-Neut_apos</class>
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
  <!-- feminine proper names: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="fem."
         genitive-singular="-">Name-Fem_0</class>
  <!-- genitive singular: "-(’)"
       no plural -->
  <class gender="fem."
         genitive-singular="-(’)">Name-Fem_apos</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="fem."
         genitive-singular="-s">Name-Fem_s</class>
  <!-- plural proper names: -->
  <!-- dative plural: unmarked -->
  <class dative-plural="-">Name-Pl_x</class>
  <!-- dative plural: "-n" -->
  <class dative-plural="-n">Name-Pl_0</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="name-class">
  <xsl:param name="lemma"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- plural proper names -->
    <xsl:when test="$number='plural'">
      <xsl:choose>
        <!-- nominative plural: with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="n:has-final-schwa-syllable($lemma, $pronunciations)">
          <xsl:value-of select="$name-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-n']"/>
        </xsl:when>
        <!-- other plural proper names -->
        <xsl:otherwise>
          <xsl:value-of select="$name-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [not(@dative-plural='-n')]"/>
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
                                                     [not(@nominative-plural)]"/>
    </xsl:when>
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
  <xsl:param name="pronunciations"/>
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

<!-- other classes -->

<xsl:variable name="adposition-class-mapping">
  <!-- prepositions: -->
  <class position="pre">Prep</class>
  <!-- postpositions: -->
  <class position="post">Postp</class>
</xsl:variable>

<xsl:template name="adposition-class">
  <xsl:param name="lemma"/>
  <xsl:param name="position"/>
  <xsl:param name="pronunciations"/>
  <xsl:value-of select="$adposition-class-mapping/class[@position=$position]"/>
</xsl:template>

<xsl:variable name="contracted-adposition-class-mapping">
  <!-- clitic article: "(de)m" -->
  <class clitic="m">Prep/Art-m</class>
  <!-- clitic article: "(de)n" -->
  <class clitic="n">Prep/Art-n</class>
  <!-- clitic article: "(de)r" -->
  <class clitic="r">Prep/Art-r</class>
  <!-- clitic article: "(da)s" -->
  <class clitic="s">Prep/Art-s</class>
</xsl:variable>

<xsl:template name="contracted-adposition-class">
  <xsl:param name="lemma"/>
  <xsl:param name="clitic"/>
  <xsl:param name="pronunciations"/>
  <xsl:value-of select="$contracted-adposition-class-mapping/class[@clitic=$clitic]"/>
</xsl:template>

<xsl:variable name="conjunction-class-mapping">
  <!-- coordinating conjunctions: -->
  <class type="coord">Conj-Coord</class>
  <!-- subordinating conjunctions -->
  <class type="subord">Conj-Sub</class>
  <!-- infinitive conjunctions -->
  <class type="inf">Conj-Inf</class>
  <!-- comparative conjunctions -->
  <class type="comp">Conj-Compar</class>
</xsl:variable>

<xsl:template name="conjunction-class">
  <xsl:param name="lemma"/>
  <xsl:param name="type"/>
  <xsl:param name="pronunciations"/>
  <xsl:value-of select="$conjunction-class-mapping/class[@type=$type]"/>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for the following inflection classes:
* <Adj&>
* <Adj+(e)>
* <FamName_0>
* <FamName_s>
* <NFem_s_s>
* <NMasc_en_e>
* <Pref/Sep>
* <VMPast>
* <VMPastSubj>
* <WAdv> -->
