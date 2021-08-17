<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smor.xsl -->
<!-- Version 0.1 -->
<!-- Andreas Nolda 2021-08-17 -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt">

<xsl:output method="text"
            encoding="ISO-8859-1"/>

<xsl:strip-space elements="*"/>

<xsl:variable name="pos-mapping">
  <pos pos="Substantiv">NN</pos>
  <!-- TODO: more POS mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:variable name="class-mapping">
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="-er"
         umlaut="yes">NMasc_es_$er</class>
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-en"
         umlaut="no">NFem_0_en</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template match="/">
  <xsl:apply-templates match="/dwds:DWDS/dwds:Artikel"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="stem"/>
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="lemma"/>
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="pos"/>
  <!-- TODO: do not hard-code this -->
  <xsl:text>&lt;base&gt;</xsl:text>
  <!-- TODO: do not hard-code this -->
  <xsl:text>&lt;nativ&gt;</xsl:text>
  <xsl:apply-templates select="dwds:Verweise"/>
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="class"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="stem">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="pos"/>
  <xsl:text>_Stems&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="lemma">
  <xsl:apply-templates select="dwds:Schreibung"/>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="pos">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="pos"/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="class">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="class"/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Schreibung">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="dwds:Verweise">
  <xsl:text>&lt;</xsl:text>
  <!-- TODO: map @Typ to SMOR types -->
  <xsl:value-of select="normalize-space(@Typ)"/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="pos">
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:value-of select="exslt:node-set($pos-mapping)/pos[@pos=$pos]"/>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="gender"
                select="normalize-space(dwds:Genus)"/>
  <xsl:variable name="genitive"
                select="normalize-space(dwds:Genitiv)"/>
  <xsl:choose>
    <xsl:when test="starts-with(dwds:Plural,'-')">
      <xsl:variable name="plural"
                    select="normalize-space(dwds:Plural)"/>
      <xsl:value-of select="exslt:node-set($class-mapping)/class[@umlaut='no']
                                                                [@pos=$pos]
                                                                [@gender=$gender]
                                                                [@genitive=$genitive]
                                                                [@plural=$plural]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="lemma"
                    select="normalize-space(../dwds:Schreibung)"/>
      <xsl:variable name="plural"
                    select="concat('-',
                                   substring-after(translate(normalize-space(dwds:Plural),'äöü',
                                                                                          'aou'),
                                                   $lemma))"/>
      <xsl:value-of select="exslt:node-set($class-mapping)/class[@umlaut='yes']
                                                                [@pos=$pos]
                                                                [@gender=$gender]
                                                                [@genitive=$genitive]
                                                                [@plural=$plural]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
