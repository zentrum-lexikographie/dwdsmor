<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 6.9 -->
<!-- Andreas Nolda 2024-07-22 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- inflection classes -->

<xsl:variable name="adjective-class-mapping">
  <!-- gradable adjectives: -->
  <!-- superlative: "-sten" or "-ten" -->
  <class superlative="-sten">Adj_0</class>
  <class superlative="-ten">Adj_0</class>
  <!-- superlative: umlaut and "-sten" or  "-ten" -->
  <class superlative="&#x308;-sten">Adj_$</class>
  <class superlative="&#x308;-ten">Adj_$</class>
  <!-- superlative: "-esten" -->
  <class superlative="-esten">Adj_e</class>
  <!-- superlative: umlaut and "-esten" -->
  <class superlative="&#x308;-esten">Adj_$e</class>
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
  <!-- genitive singular: "-ns"
       no plural -->
  <class gender="mask."
         genitive-singular="-ns">NMasc/Sg_ns</class>
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
       nominative plural: "-en" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-en">NMasc_0_en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-es">NMasc_0_es</class>
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
  <!-- genitive singular: unmarked
       nominative plural: "-anten" substituted for "-as" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-as/anten">NMasc_0_as/anten</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-e" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-e/i">NMasc_0_e/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izes" substituted for "-ex" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ex/izes">NMasc_0_ex/izes</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izes" substituted for "-ix" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ix/izes">NMasc_0_ex/izes<!-- sic! --></class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-o/en">NMasc_0_o/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-o/i">NMasc_0_o/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/e">NMasc_0_us/e</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/en">NMasc_0_us/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-een" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/een">NMasc_0_us/een</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-os" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-os/en">NMasc_0_us/en<!-- sic! --></class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/i">NMasc_0_us/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ier" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/ier">NMasc_0_us/ier</class>
  <!-- genitive singular: unmarked
       nominative plural: "-yngen" substituted for "-ynx" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ynx/yngen">NMasc_0_ynx/yngen</class>
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
  <!-- genitive singular: "-(e)s"
       nominative plural: "-ten" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-ten">NMasc_es_ten</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-ten">NMasc_es_ten</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-anten" substituted for "-as" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-as/anten">NMasc_es_as/anten~ss</class>
  <!-- genitive singular: "-es"
       nominative plural: "-izes" substituted for "-ex" -->
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-ex/izes">NMasc_es_ex/izes</class>
  <!-- genitive singular: "-es"
       nominative plural: "-izes" substituted for "-ix" -->
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-ix/izes">NMasc_es_ex/izes<!-- sic! --></class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-en" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/en">NMasc_es_us/en~ss</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-een" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/een">NMasc_es_us/een~ss</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-i" substituted for "-us" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/i">NMasc_es_us/i~ss</class>
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
       nominative plural: "-es" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-es">NMasc_s_es</class>
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
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-e" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-e/i">NMasc_s_e/i</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/en">NMasc_s_o/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/i">NMasc_s_o/i</class>
  <!-- all forms except nominative singular: "-en" -->
  <class gender="mask."
         genitive-singular="-en"
         nominative-plural="-en">NMasc_en_en</class>
  <!-- all forms except nominative singular: "-n" -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-n">NMasc_n_n</class>
  <!-- genitive singular: "-ns"
       nominative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-ns"
         nominative-plural="-n">NMasc_ns_n</class>
  <!-- genitive singular: "-ns"
       nominative plural: umlaut and "-n" -->
  <class gender="mask."
         genitive-singular="-ns"
         nominative-plural="&#x308;-n">NMasc_ns_$n</class>
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
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-en">NNeut_0_en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-es">NNeut_0_es</class>
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
  <!-- genitive singular: unmarked
       nominative plural: "-ata" substituted for "-a" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ta">NNeut_0_a/ata</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-a" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-a/en">NNeut_0_a/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-anzien" substituted for "-ans" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ans/anzien">NNeut_0_ans/anzien</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-e" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-e/i">NNeut_0_e/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ina" substituted for "-en" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-en/ina">NNeut_0_en/ina</class>
  <!-- genitive singular: unmarked
       nominative plural: "-enzien" substituted for "-ens" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ens/enzien">NNeut_0_ens/enzien</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-o" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-o/en">NNeut_0_o/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-o" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-o/i">NNeut_0_o/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-a" substituted for "-on" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-on/a">NNeut_0_on/a</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-on" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-on/en">NNeut_0_on/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-a" substituted for "-um" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-um/a">NNeut_0_um/a</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-um" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-um/en">NNeut_0_um/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/en">NNeut_0_us/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-os" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-os/en">NNeut_0_us/en<!-- sic! --></class>
  <!-- genitive singular: unmarked
       nominative plural: "-era" substituted for "-us" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/era">NNeut_0_us/era</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ora" substituted for "-us" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/ora">NNeut_0_us/ora</class>
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
         nominative-plural="-ta">NNeut_s_a/ata</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-a" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-a/en">NNeut_s_a/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-e" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e/i">NNeut_s_e/i</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ina" substituted for "-en" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en/ina">NNeut_s_en/ina</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/en">NNeut_s_o/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/i">NNeut_s_o/i</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-on" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/a">NNeut_s_on/a</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-on" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/en">NNeut_s_on/en</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-um" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/a">NNeut_s_um/a</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-um" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/en">NNeut_s_um/en</class>
  <!-- genitive singular: "-ens"
       nominative plural: "-en" -->
  <class gender="neutr."
         genitive-singular="-ens"
         nominative-plural="-en">NNeut_ens_en</class>
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
       nominative plural: "-en" substituted for "-a" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-a/en">NFem_0_a/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-angen" substituted for "-anx" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-anx/angen">NFem_0_anx/angen</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-e" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-e/i">NFem_0_e/i</class>
  <!-- genitive singular: unmarked
       nominative plural: "-eges" substituted for "-ex" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ex/eges">NFem_0_ex/eges</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-is" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/en">NFem_0_is/en</class>
  <!-- genitive singular: unmarked
       nominative plural: "-iden" substituted for "-is" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/iden">NFem_0_is/iden</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izen" substituted for "-ix" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ix/izen">NFem_0_ix/izen</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izes" substituted for "-ix" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ix/izes">NFem_0_ix/izes</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "n" + "-en" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-nen">NFem-in</class>
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
  <xsl:param name="diminutive"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- pluralia tantum -->
    <xsl:when test="$number='plural'">
      <xsl:choose>
        <!-- "lein"-diminuitive:
             dative plural: unmarked -->
        <xsl:when test="$diminutive='lein'">
          <xsl:value-of select="$noun-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- nominative plural: with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="not(ends-with($lemma,'n')) and
                        n:is-noun-with-final-schwa-syllable($lemma, $pronunciations)">
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
        <!-- "lein"-diminuitive:
             genitive singular: "-s" or unmarked
             nominative plural: unmarked
             dative plural: unmarked -->
        <xsl:when test="($genitive-singular-marker='-s' or
                         $genitive-singular-marker='-') and
                        $nominative-plural-marker='-' and
                        $diminutive='lein'">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <xsl:when test="($genitive-singular-marker='-s' or
                         $genitive-singular-marker='-') and
                        $nominative-plural-marker='-' and
                        $diminutive='l' and
                        matches($lemma,'l[aei]$')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural=$nominative-plural-marker]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- genitive singular: "-s"
             nominative plural: umlaut or unmarked, with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="$genitive-singular-marker='-s' and
                        ends-with($nominative-plural-marker,'-') and
                        not(ends-with($lemma,'n')) and
                        n:is-noun-with-final-schwa-syllable($lemma, $pronunciations)">
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
                        not(ends-with($lemma,'n')) and
                        n:is-noun-with-final-schwa-syllable($lemma, $pronunciations)">
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
        <!-- nominative plural: "-anzien" substituted for "-ans" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ans') and
                        $nominative-plural=replace($lemma,'ans$','anzien')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ans/anzien']"/>
        </xsl:when>
        <!-- nominative plural: "-angen" substituted for "-anx" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'anx') and
                        $nominative-plural=replace($lemma,'anx$','angen')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-anx/angen']"/>
        </xsl:when>
        <!-- nominative plural: "-anten" substituted for "-as" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'as') and
                        $nominative-plural=replace($lemma,'as$','anten')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-as/anten']"/>
        </xsl:when>
        <!-- nominative plural: "-i" substituted for "-e" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'e') and
                        $nominative-plural=replace($lemma,'e$','i')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-e/i']"/>
        </xsl:when>
        <!-- nominative plural: "-ina" substituted for "-en" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'en') and
                        $nominative-plural=replace($lemma,'en$','ina')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-en/ina']"/>
        </xsl:when>
        <!-- nominative plural: "-enzien" substituted for "-ens" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ens') and
                        $nominative-plural=replace($lemma,'ens$','enzien')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ens/enzien']"/>
        </xsl:when>
        <!-- nominative plural: "-eges" substituted for "-ex" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ex') and
                        $nominative-plural=replace($lemma,'ex$','eges')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ex/eges']"/>
        </xsl:when>
        <!-- nominative plural: "-izes" substituted for "-ex" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ex') and
                        $nominative-plural=replace($lemma,'ex$','izes')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ex/izes']"/>
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
        <!-- nominative plural: "-izen" substituted for "-ix" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ix') and
                        $nominative-plural=replace($lemma,'ix$','izen')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ix/izen']"/>
        </xsl:when>
        <!-- nominative plural: "-izes" substituted for "-ix" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ix') and
                        $nominative-plural=replace($lemma,'ix$','izes')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ix/izes']"/>
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
        <!-- nominative plural: "-en" substituted for "-os" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'os') and
                        $nominative-plural=replace($lemma,'os$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-os/en']"/>
        </xsl:when>
        <!-- nominative plural: "-era" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','era')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/era']"/>
        </xsl:when>
        <!-- nominative plural: "-ora" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','ora')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/ora']"/>
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
        <!-- nominative plural: "-en" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/en']"/>
        </xsl:when>
        <!-- nominative plural: "-een" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','een')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/een']"/>
        </xsl:when>
        <!-- nominative plural: "-i" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','i')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/i']"/>
        </xsl:when>
        <!-- nominative plural: "-ier" substituted for "-us" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'us') and
                        $nominative-plural=replace($lemma,'us$','ier')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-us/ier']"/>
        </xsl:when>
        <!-- nominative plural: "-yngen" substituted for "-ynx" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ynx') and
                        $nominative-plural=replace($lemma,'ynx$','yngen')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ynx/yngen']"/>
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
         genitive-singular="-">NameMasc_0</class>
  <!-- genitive singular: "-(’)"
       no plural -->
  <class gender="mask."
         genitive-singular="-(’)">NameMasc_apos</class>
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="mask."
         genitive-singular="-(e)s">NameMasc_es</class>
  <class gender="mask."
         genitive-singular="-es">NameMasc_es</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="mask."
         genitive-singular="-s">NameMasc_s</class>
  <!-- neuter proper names: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="neutr."
         genitive-singular="-">NameNeut_0</class>
  <!-- genitive singular: "-(’)"
       no plural -->
  <class gender="neut."
         genitive-singular="-(’)">NameNeut_apos</class>
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-(e)s">NameNeut_es</class>
  <class gender="neutr."
         genitive-singular="-es">NameNeut_es</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-s">NameNeut_s</class>
  <!-- feminine proper names: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="fem."
         genitive-singular="-">NameFem_0</class>
  <!-- genitive singular: "-(’)"
       no plural -->
  <class gender="fem."
         genitive-singular="-(’)">NameFem_apos</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="fem."
         genitive-singular="-s">NameFem_s</class>
  <!-- plural proper names: -->
  <!-- dative plural: unmarked -->
  <class dative-plural="-">NameNoGend/Pl_x</class>
  <!-- dative plural: "-n" -->
  <class dative-plural="-n">NameNoGend/Pl_0</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template name="name-class">
  <xsl:param name="lemma"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:param name="diminutive"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- plural proper names -->
    <xsl:when test="$number='plural'">
      <xsl:choose>
        <!-- "lein"-diminuitive:
             dative plural: unmarked -->
        <xsl:when test="$diminutive='lein'">
          <xsl:value-of select="$name-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <xsl:when test="$diminutive='l' and
                        matches($lemma,'l[aei]$')">
          <xsl:value-of select="$name-class-mapping/class[not(@gender)]
                                                         [not(@genitive-singular)]
                                                         [not(@nominative-plural)]
                                                         [@dative-plural='-']"/>
        </xsl:when>
        <!-- nominative plural: with final schwa-syllable
             dative plural: "-n" -->
        <xsl:when test="not(ends-with($lemma,'n')) and
                        n:is-noun-with-final-schwa-syllable($lemma, $pronunciations)">
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
         participle="ge-t">VVReg-el-er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class infinitive="-n"
         past="-te"
         participle="-t">VVReg-el-er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-ete"
       past participle: "ge-" + "-et" -->
  <class infinitive="-n"
         past="-ete"
         participle="ge-et">VVReg-el-er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-ete"
       past participle: "-et" -->
  <class infinitive="-n"
         past="-ete"
         participle="-et">VVReg-el-er</class>
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
  <class clitic="m">Prep+Art-m</class>
  <!-- clitic article: "(de)n" -->
  <class clitic="n">Prep+Art-n</class>
  <!-- clitic article: "(de)r" -->
  <class clitic="r">Prep+Art-r</class>
  <!-- clitic article: "(da)s" -->
  <class clitic="s">Prep+Art-s</class>
</xsl:variable>

<xsl:template name="contracted-adposition-class">
  <xsl:param name="lemma"/>
  <xsl:param name="clitic"/>
  <xsl:param name="pronunciations"/>
  <xsl:value-of select="$contracted-adposition-class-mapping/class[@clitic=$clitic]"/>
</xsl:template>

<xsl:variable name="conjunction-class-mapping">
  <!-- coordinating conjunctions: -->
  <class type="coord">ConjCoord</class>
  <!-- subordinating conjunctions -->
  <class type="subord">ConjSub</class>
  <!-- infinitive conjunctions -->
  <class type="inf">ConjInf</class>
  <!-- comparative conjunctions -->
  <class type="comp">ConjCompar</class>
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
* <FamName_0>
* <FamName_s>
* <NFem_s_s>
* <NMasc_en_e>
* <VPart>
* <VMPast>
* <VMPastSubj>
* <WAdv> -->
