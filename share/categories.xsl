<?xml version="1.0" encoding="utf-8"?>
<!-- categories.xsl -->
<!-- Version 7.7 -->
<!-- Andreas Nolda 2025-04-24 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- inflection classes -->

<xsl:variable name="adjective-class-mapping">
  <!-- gradable adjectives: -->
  <!-- superlative: "-sten" or "-ten" -->
  <class superlative="-sten">Adj_er_st</class>
  <class superlative="-ten">Adj_er_st</class>
  <!-- superlative: umlaut and "-sten" or  "-ten" -->
  <class superlative="&#x308;-sten">Adj_er_$st</class>
  <class superlative="&#x308;-ten">Adj_er_$st</class>
  <!-- superlative: "-esten" -->
  <class superlative="-esten">Adj_er_est</class>
  <!-- superlative: umlaut and "-esten" -->
  <class superlative="&#x308;-esten">Adj_er_$est</class>
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
         genitive-singular="-">NMasc|Sg_0</class>
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="mask."
         genitive-singular="-(e)s">NMasc|Sg_es</class>
  <class gender="mask."
         genitive-singular="-es">NMasc|Sg_es</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="mask."
         genitive-singular="-s">NMasc|Sg_s</class>
  <!-- genitive singular: "-ns"
       no plural -->
  <class gender="mask."
         genitive-singular="-ns">NMasc|Sg_ns</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NMasc_0_0_0</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-n">NMasc_0_0_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-e"
         dative-plural="-n">NMasc_0_e_n</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-se"
         dative-plural="-n">NMasc_0_e_n~ss</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NMasc_0_$e_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-en"
         dative-plural="-">NMasc_0_en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-es"
         dative-plural="-">NMasc_0_es_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-nen"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-nen"
         dative-plural="-">NMasc_0_nen_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-s"
         dative-plural="-">NMasc_0_s_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-i"
         dative-plural="-">NMasc_0_i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-a"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-a/en"
         dative-plural="-">NMasc_0_a/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-anten" substituted for "-as"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-as/anten"
         dative-plural="-">NMasc_0_as/anten_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-e"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-e/i"
         dative-plural="-">NMasc_0_e/i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-entes" substituted for "-ens"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ens/entes"
         dative-plural="-">NMasc_0_ens/entes_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-iden" substituted for "-es"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-es/iden"
         dative-plural="-">NMasc_0_es/iden_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ides" substituted for "-es"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-es/ides"
         dative-plural="-">NMasc_0_es/ides_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izes" substituted for "-ex"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ex/izes"
         dative-plural="-">NMasc_0_ex/izes_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izes" substituted for "-ix"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ix/izes"
         dative-plural="-">NMasc_0_ix/izes_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-i"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-i/en"
         dative-plural="-">NMasc_0_i/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es" substituted for "-is"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-is/es"
         dative-plural="-">NMasc_0_is/es_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-o"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-o/en"
         dative-plural="-">NMasc_0_o/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-o"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-o/i"
         dative-plural="-">NMasc_0_o/i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-os"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-os/en"
         dative-plural="-">NMasc_0_os/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-oen" substituted for "-os"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-os/oen"
         dative-plural="-">NMasc_0_os/oen_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-oden" substituted for "-os"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-os/oden"
         dative-plural="-">NMasc_0_os/oden_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-oi" substituted for "-os"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-os/oi"
         dative-plural="-">NMasc_0_os/oi_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" substituted for "-us"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/e"
         dative-plural="-n">NMasc_0_us/e_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/en"
         dative-plural="-">NMasc_0_us/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-een" substituted for "-us"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/een"
         dative-plural="-">NMasc_0_us/een_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-us"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/i"
         dative-plural="-">NMasc_0_us/i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ier" substituted for "-us"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-us/ier"
         dative-plural="-n">NMasc_0_us/ier_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-yngen" substituted for "-ynx"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-"
         nominative-plural="-ynx/yngen"
         dative-plural="-">NMasc_0_ynx/yngen_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-e"
         dative-plural="-n">NMasc_es_e_n</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-e"
         dative-plural="-n">NMasc_es_e_n</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-se"
         dative-plural="-n">NMasc_es_e_n~ss</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NMasc_es_$e_n</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NMasc_es_$e_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-er"
         dative-plural="-n">NMasc_es_er_n</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-er"
         dative-plural="-n">NMasc_es_er_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-er"
         dative-plural="-n">NMasc_es_$er_n</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="&#x308;-er"
         dative-plural="-n">NMasc_es_$er_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-en"
         dative-plural="-">NMasc_es_en_0</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-en"
         dative-plural="-">NMasc_es_en_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-es"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-es"
         dative-plural="-">NMasc_es_es_0</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-es"
         dative-plural="-">NMasc_es_es_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-(e)s"
         nominative-plural="-s"
         dative-plural="-">NMasc_es_s_0</class>
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-s"
         dative-plural="-">NMasc_es_s_0</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-anten" substituted for "-as"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-as/anten"
         dative-plural="-">NMasc_es_as/anten_0~ss</class>
  <!-- genitive singular: "-es"
       nominative plural: "-izes" substituted for "-ex"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-ex/izes"
         dative-plural="-">NMasc_es_ex/izes_0</class>
  <!-- genitive singular: "-es"
       nominative plural: "-izes" substituted for "-ix"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-es"
         nominative-plural="-ix/izes"
         dative-plural="-">NMasc_is_ix/izes_0</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-en" substituted for "-us"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/en"
         dative-plural="-">NMasc_es_us/en_0~ss</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-een" substituted for "-us"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/een"
         dative-plural="-">NMasc_es_us/een_0~ss</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: "-i" substituted for "-us"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-ses"
         nominative-plural="-us/i"
         dative-plural="-">NMasc_es_us/i_0~ss</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NMasc_s_0_0</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-">NMasc_s_$_0</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-n">NMasc_s_0_n</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-n">NMasc_s_$_n</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-e"
         dative-plural="-n">NMasc_s_e_n</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-e"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NMasc_s_$e_n</class>
  <!-- genitive singular: "-s"
       nominative plural: "-er"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-er"
         dative-plural="-n">NMasc_s_er_n</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-er"
       dative plural: "-n" -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="&#x308;-er"
         dative-plural="-n">NMasc_s_$er_n</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-en"
         dative-plural="-">NMasc_s_en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-es"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-es"
         dative-plural="-">NMasc_s_es_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-n"
         dative-plural="-">NMasc_s_n_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ien"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-ien"
         dative-plural="-">NMasc_s_ien_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-nen"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-nen"
         dative-plural="-">NMasc_s_nen_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-s"
         dative-plural="-">NMasc_s_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-a"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-a/en"
         dative-plural="-">NMasc_s_a/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-e"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-e/i"
         dative-plural="-">NMasc_s_e/i_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-res" substituted for "-er"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-er/res"
         dative-plural="-">NMasc_s_er/res_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-i"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-i/en"
         dative-plural="-">NMasc_s_i/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/en"
         dative-plural="-">NMasc_s_o/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-s"
         nominative-plural="-o/i"
         dative-plural="-">NMasc_s_o/i_0</class>
  <!-- all forms except nominative singular: "-en" -->
  <class gender="mask."
         genitive-singular="-en"
         nominative-plural="-en"
         dative-plural="-">NMasc_en_en_0</class>
  <!-- all forms except nominative singular: "-n" -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-n"
         dative-plural="-">NMasc_n_n_0</class>
  <!-- genitive singular: "-n"
       nominative plural: "-ns"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-ns"
         dative-plural="-">NMasc_n_ns_0</class>
  <!-- genitive singular: "-n"
       nominative plural: "-s" substituted for "-e"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-e/s"
         dative-plural="-">NMasc_n_e/s_0</class>
  <!-- genitive singular: "-ns"
       nominative plural: "-n"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-ns"
         nominative-plural="-n"
         dative-plural="-">NMasc_ns_n_0</class>
  <!-- genitive singular: "-ns"
       nominative plural: umlaut and "-n"
       dative plural: unmarked -->
  <class gender="mask."
         genitive-singular="-ns"
         nominative-plural="&#x308;-n"
         dative-plural="-">NMasc_ns_$n_0</class>
  <!-- nominalised adjectives: -->
  <class gender="mask."
         genitive-singular="-n"
         nominative-plural="-(n)"
         dative-plural="-n">NMasc-Adj</class>
  <!-- neuter nouns: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="neutr."
         genitive-singular="-">NNeut|Sg_0</class>
  <!-- genitive singular: "-(e)s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-(e)s">NNeut|Sg_es</class>
  <class gender="neutr."
         genitive-singular="-es">NNeut|Sg_es</class>
  <!-- genitive singular: geminate "s" + "-es"
       no plural -->
  <class gender="neutr."
         genitive-singular="-ses">NNeut|Sg_es~ss</class>
  <!-- genitive singular: "-s"
       no plural -->
  <class gender="neutr."
         genitive-singular="-s">NNeut|Sg_s</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NNeut_0_0_0</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-n">NNeut_0_0_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-e"
         dative-plural="-n">NNeut_0_e_n</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-se"
         dative-plural="-n">NNeut_0_e_n~ss</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-en"
         dative-plural="-">NNeut_0_en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-es"
         dative-plural="-">NNeut_0_es_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-nen"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-nen"
         dative-plural="-">NNeut_0_nen_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-s"
         dative-plural="-">NNeut_0_s_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ata" substituted for "-a"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ta"
         dative-plural="-">NNeut_0_a/ata_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-a"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-a/en"
         dative-plural="-">NNeut_0_a/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-antien" substituted for "-ans"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ans/antien"
         dative-plural="-">NNeut_0_ans/antien_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-anzien" substituted for "-ans"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ans/anzien"
         dative-plural="-">NNeut_0_ans/anzien_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-e"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-e/i"
         dative-plural="-">NNeut_0_e/i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ia" substituted for "-e"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-e/ia"
         dative-plural="-">NNeut_0_e/ia_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ien" substituted for "-e"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-e/ien"
         dative-plural="-">NNeut_0_e/ien_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ina" substituted for "-en"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-en/ina"
         dative-plural="-">NNeut_0_en/ina_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-entia" substituted for "-ens"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ens/entia"
         dative-plural="-">NNeut_0_ens/entia_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-entien" substituted for "-ens"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ens/entien"
         dative-plural="-">NNeut_0_ens/entien_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-enzien" substituted for "-ens"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ens/enzien"
         dative-plural="-">NNeut_0_ens/enzien_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izia" substituted for "-ex"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-ex/izia"
         dative-plural="-">NNeut_0_ex/izia_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-i"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-i/en"
         dative-plural="-">NNeut_0_i/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-o"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-o/en"
         dative-plural="-">NNeut_0_o/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-o"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-o/i"
         dative-plural="-">NNeut_0_o/i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-a" substituted for "-on"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-on/a"
         dative-plural="-">NNeut_0_on/a_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-on"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-on/en"
         dative-plural="-">NNeut_0_on/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-os"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-os/en"
         dative-plural="-">NNeut_0_os/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-a" substituted for "-um"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-um/a"
         dative-plural="-">NNeut_0_um/a_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-um"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-um/en"
         dative-plural="-">NNeut_0_um/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-us"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/en"
         dative-plural="-">NNeut_0_us/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-era" substituted for "-us"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/era"
         dative-plural="-">NNeut_0_us/era_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ora" substituted for "-us"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-"
         nominative-plural="-us/ora"
         dative-plural="-">NNeut_0_us/ora_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-e"
         dative-plural="-n">NNeut_es_e_n</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-e"
         dative-plural="-n">NNeut_es_e_n</class>
  <!-- genitive singular: geminate "s" + "-es"
       nominative plural: geminate "s" + "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-ses"
         nominative-plural="-se"
         dative-plural="-n">NNeut_es_e_n~ss</class>
  <!-- genitive singular: geminate "z" + "-es"
       nominative plural: geminate "z" + "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-zes"
         nominative-plural="-ze"
         dative-plural="-n">NNeut_es_e_n~zz</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NNeut_es_$e_n</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NNeut_es_$e_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-er"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-er"
         dative-plural="-n">NNeut_es_er_n</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-er"
         dative-plural="-n">NNeut_es_er_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: umlaut and "-er"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="&#x308;-er"
         dative-plural="-n">NNeut_es_$er_n</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="&#x308;-er"
         dative-plural="-n">NNeut_es_$er_n</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-en"
         dative-plural="-">NNeut_es_en_0</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-en"
         dative-plural="-">NNeut_es_en_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-es"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-es"
         dative-plural="-">NNeut_es_es_0</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-es"
         dative-plural="-">NNeut_es_es_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-s"
         dative-plural="-">NNeut_es_s_0</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-s"
         dative-plural="-">NNeut_es_s_0</class>
  <!-- genitive singular: "-(e)s"
       nominative plural: "-ien"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-(e)s"
         nominative-plural="-ien"
         dative-plural="-">NNeut_es_ien_0</class>
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-ien"
         dative-plural="-">NNeut_es_ien_0</class>
  <!-- genitive singular: "-es"
       nominative plural: "-izia" substituted for "-ex"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-es"
         nominative-plural="-ex/izia"
         dative-plural="-">NNeut_es_ex/izia_0</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-">NNeut_s_0_0</class>
  <!-- genitive singular: "-s"
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-"
         dative-plural="-n">NNeut_s_0_n</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="&#x308;-"
         dative-plural="-n">NNeut_s_$_n</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-a"
         dative-plural="-">NNeut_s_a_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e"
         dative-plural="-n">NNeut_s_e_n</class>
  <!-- genitive singular: "-s"
       nominative plural: umlaut and "-er"
       dative plural: "-n" -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="&#x308;-er"
         dative-plural="-n">NNeut_s_$er_n</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en"
         dative-plural="-">NNeut_s_en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-n"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-n"
         dative-plural="-">NNeut_s_n_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-nen"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-nen"
         dative-plural="-">NNeut_s_nen_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ien"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ien"
         dative-plural="-">NNeut_s_ien_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-s"
         dative-plural="-">NNeut_s_s_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ta"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-ta"
         dative-plural="-">NNeut_s_a/ata_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-a"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-a/en"
         dative-plural="-">NNeut_s_a/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-e"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e/i"
         dative-plural="-">NNeut_s_e/i_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ia" substituted for "-e"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e/ia"
         dative-plural="-">NNeut_s_e/ia_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ien" substituted for "-e"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-e/ien"
         dative-plural="-">NNeut_s_e/ien_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-ina" substituted for "-en"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-en/ina"
         dative-plural="-">NNeut_s_en/ina_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-i"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-i/en"
         dative-plural="-">NNeut_s_i/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-o"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/en"
         dative-plural="-">NNeut_s_o/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-i" substituted for "-o"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-o/i"
         dative-plural="-">NNeut_s_o/i_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-on"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/a"
         dative-plural="-">NNeut_s_on/a_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-on"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-on/en"
         dative-plural="-">NNeut_s_on/en_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-a" substituted for "-um"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/a"
         dative-plural="-">NNeut_s_um/a_0</class>
  <!-- genitive singular: "-s"
       nominative plural: "-en" substituted for "-um"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-s"
         nominative-plural="-um/en"
         dative-plural="-">NNeut_s_um/en_0</class>
  <!-- genitive singular: "-ens"
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="neutr."
         genitive-singular="-ens"
         nominative-plural="-en"
         dative-plural="-">NNeut_ens_en_0</class>
  <!-- nominalised adjectives without plural: -->
  <class gender="neutr."
         genitive-singular="-n">NNeut-Adj|Sg</class>
  <!-- nominalised adjectives: -->
  <class gender="neutr."
         genitive-singular="-n"
         nominative-plural="-(n)"
         dative-plural="-n">NNeut-Adj</class>
  <!-- feminine nouns: -->
  <!-- genitive singular: unmarked
       no plural -->
  <class gender="fem."
         genitive-singular="-">NFem|Sg_0</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-">NFem_0_0_0</class>
  <!-- genitive singular: unmarked
       nominative plural: unmarked
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-"
         dative-plural="-n">NFem_0_0_n</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-"
         dative-plural="-n">NFem_0_$_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e"
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-e"
         dative-plural="-n">NFem_0_e_n</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "s" + "-e"
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-se"
         dative-plural="-n">NFem_0_e_n~ss</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-e"
       dative plural: "-n" -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-e"
         dative-plural="-n">NFem_0_$e_n</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-en"
         dative-plural="-">NFem_0_en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: umlaut and "-en"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="&#x308;-en"
         dative-plural="-">NFem_0_$en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-n"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-n"
         dative-plural="-">NFem_0_n_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-es"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-es"
         dative-plural="-">NFem_0_es_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-s"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-s"
         dative-plural="-">NFem_0_s_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ien"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ien"
         dative-plural="-">NFem_0_ien_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-nes"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-nes"
         dative-plural="-">NFem_0_nes_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-e" substituted for "-a"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-a/e"
         dative-plural="-">NFem_0_a/e_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-a"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-a/en"
         dative-plural="-">NFem_0_a/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-anten" substituted for "-ans"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ans/anten"
         dative-plural="-">NFem_0_ans/anten_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-angen" substituted for "-anx"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-anx/angen"
         dative-plural="-">NFem_0_anx/angen_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-i" substituted for "-e"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-e/i"
         dative-plural="-">NFem_0_e/i_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-es"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-es/en"
         dative-plural="-">NFem_0_es/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-eges" substituted for "-ex"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ex/eges"
         dative-plural="-">NFem_0_ex/eges_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-en" substituted for "-is"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/en"
         dative-plural="-">NFem_0_is/en_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-iden" substituted for "-is"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/iden"
         dative-plural="-">NFem_0_is/iden_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ides" substituted for "-is"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-is/ides"
         dative-plural="-">NFem_0_is/ides_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-ices" substituted for "-ix"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ix/ices"
         dative-plural="-">NFem_0_ix/ices_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izen" substituted for "-ix"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ix/izen"
         dative-plural="-">NFem_0_ix/izen_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-izes" substituted for "-ix"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ix/izes"
         dative-plural="-">NFem_0_ix/izes_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-otes" substituted for "-os"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-os/otes"
         dative-plural="-">NFem_0_os/otes_0</class>
  <!-- genitive singular: unmarked
       nominative plural: "-oces" substituted for "-ox"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-ox/oces"
         dative-plural="-">NFem_0_ox/oces_0</class>
  <!-- all forms except nominative singular: "-n" -->
  <class gender="fem."
         genitive-singular="-n"
         nominative-plural="-n"
         dative-plural="-">NFem_n_n_0</class>
  <!-- genitive singular: unmarked
       nominative plural: geminate "n" + "-en"
       dative plural: unmarked -->
  <class gender="fem."
         genitive-singular="-"
         nominative-plural="-nen"
         dative-plural="-">NFem-in</class>
  <!-- nominalised adjectives: -->
  <class gender="fem."
         genitive-singular="-n"
         nominative-plural="-(n)"
         dative-plural="-n">NFem-Adj</class>
  <!-- pluralia tantum: -->
  <!-- dative plural: unmarked -->
  <class dative-plural="-">NUnmGend|Pl_0</class>
  <!-- dative plural: "-n" -->
  <class dative-plural="-n">NUnmGend|Pl_n</class>
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
        <!-- nominative plural: "-e" substituted for "-a" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'a') and
                        $nominative-plural=replace($lemma,'a$','e')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-a/e']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-a" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'a') and
                        $nominative-plural=replace($lemma,'a$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-a/en']"/>
        </xsl:when>
        <!-- nominative plural: "-anten" substituted for "-ans" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ans') and
                        $nominative-plural=replace($lemma,'ans$','anten')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ans/anten']"/>
        </xsl:when>
        <!-- nominative plural: "-antien" substituted for "-ans" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ans') and
                        $nominative-plural=replace($lemma,'ans$','antien')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ans/antien']"/>
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
        <!-- nominative plural: "-ia" substituted for "-e" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'e') and
                        $nominative-plural=replace($lemma,'e$','ia')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-e/ia']"/>
        </xsl:when>
        <!-- nominative plural: "-ien" substituted for "-e" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'e') and
                        $nominative-plural=replace($lemma,'e$','ien')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-e/ien']"/>
        </xsl:when>
        <!-- nominative plural: "-s" substituted for "-e" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'e') and
                        $nominative-plural=replace($lemma,'e$','s')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-e/s']"/>
        </xsl:when>
        <!-- nominative plural: "-ina" substituted for "-en" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'en') and
                        $nominative-plural=replace($lemma,'en$','ina')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-en/ina']"/>
        </xsl:when>
        <!-- nominative plural: "-entes" substituted for "-ens" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ens') and
                        $nominative-plural=replace($lemma,'ens$','entes')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ens/entes']"/>
        </xsl:when>
        <!-- nominative plural: "-entia" substituted for "-ens" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ens') and
                        $nominative-plural=replace($lemma,'ens$','entia')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ens/entia']"/>
        </xsl:when>
        <!-- nominative plural: "-enzien" substituted for "-ens" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ens') and
                        $nominative-plural=replace($lemma,'ens$','entien')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ens/entien']"/>
        </xsl:when>
        <!-- nominative plural: "-enzien" substituted for "-ens" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ens') and
                        $nominative-plural=replace($lemma,'ens$','enzien')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ens/enzien']"/>
        </xsl:when>
        <!-- nominative plural: "-res" substituted for "-er" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'er') and
                        $nominative-plural=replace($lemma,'er$','res')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-er/res']"/>
        </xsl:when>
        <!-- nominative plural: "-iden" substituted for "-es" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'es') and
                        $nominative-plural=replace($lemma,'es$','iden')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-es/iden']"/>
        </xsl:when>
        <!-- nominative plural: "-ides" substituted for "-es" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'es') and
                        $nominative-plural=replace($lemma,'es$','ides')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-es/ides']"/>
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
        <!-- nominative plural: "-izia" substituted for "-ex" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ex') and
                        $nominative-plural=replace($lemma,'ex$','izia')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ex/izia']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-es" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'es') and
                        $nominative-plural=replace($lemma,'es$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-es/en']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-i" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'i') and
                        $nominative-plural=replace($lemma,'i$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-i/en']"/>
        </xsl:when>
        <!-- nominative plural: "-en" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','en')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/en']"/>
        </xsl:when>
        <!-- nominative plural: "-es" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','es')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/es']"/>
        </xsl:when>
        <!-- nominative plural: "-iden" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','iden')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/iden']"/>
        </xsl:when>
        <!-- nominative plural: "-ides" substituted for "-is" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'is') and
                        $nominative-plural=replace($lemma,'is$','ides')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-is/ides']"/>
        </xsl:when>
        <!-- nominative plural: "-ices" substituted for "-ix" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ix') and
                        $nominative-plural=replace($lemma,'ix$','ices')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ix/ices']"/>
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
        <!-- nominative plural: "-oen" substituted for "-os" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'os') and
                        $nominative-plural=replace($lemma,'os$','oen')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-os/oen']"/>
        </xsl:when>
        <!-- nominative plural: "-oden" substituted for "-os" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'os') and
                        $nominative-plural=replace($lemma,'os$','oden')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-os/oden']"/>
        </xsl:when>
        <!-- nominative plural: "-oi" substituted for "-os" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'os') and
                        $nominative-plural=replace($lemma,'os$','oi')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-os/oi']"/>
        </xsl:when>
        <!-- nominative plural: "-otes" substituted for "-os" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'os') and
                        $nominative-plural=replace($lemma,'os$','otes')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-os/otes']"/>
        </xsl:when>
        <!-- nominative plural: "-oces" substituted for "-ox" -->
        <xsl:when test="not(starts-with($nominative-plural-marker,'-')) and
                        ends-with($lemma,'ox') and
                        $nominative-plural=replace($lemma,'ox$','oces')">
          <xsl:value-of select="$noun-class-mapping/class[@gender=$gender]
                                                         [@genitive-singular=$genitive-singular-marker]
                                                         [@nominative-plural='-ox/oces']"/>
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
  <class dative-plural="-">NameUnmGend|Pl_0</class>
  <!-- dative plural: "-n" -->
  <class dative-plural="-n">NameUnmGend|Pl_n</class>
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
         participle="ge-t">VWeak</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class infinitive="-en"
         past="-te"
         participle="-t">VWeak</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-ete"
       past participle: "ge-" + "-et" -->
  <class infinitive="-en"
         past="-ete"
         participle="ge-et">VWeak-d-t</class>
  <!-- infinitive: "-en"
       past 3rd person singular: "-ete"
       past participle: "-et" -->
  <class infinitive="-en"
         past="-ete"
         participle="-et">VWeak-d-t</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "ge-" + "-t" -->
  <class infinitive="-n"
         past="-te"
         participle="ge-t">VWeak-el-er</class>
  <!-- infinitive: "-n"
       past 3rd person singular: "-te"
       past participle: "-t" -->
  <class infinitive="-n"
         past="-te"
         participle="-t">VWeak-el-er</class>
  <!-- weak verbs with irregular past stem: -->
  <!-- cf. entries.xsl -->
  <!-- weak verbs with strong participle: -->
  <!-- cf. entries.xsl -->
  <!-- strong verbs: -->
  <!-- cf. entries.xsl -->
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
  <!-- clausal infinitive conjunctions -->
  <class type="infcl">ConjInfCl</class>
  <!-- comparative conjunctions -->
  <class type="adjcomp">ConjAdjComp</class>
</xsl:variable>

<xsl:template name="conjunction-class">
  <xsl:param name="lemma"/>
  <xsl:param name="type"/>
  <xsl:param name="pronunciations"/>
  <xsl:value-of select="$conjunction-class-mapping/class[@type=$type]"/>
</xsl:template>
</xsl:stylesheet>
