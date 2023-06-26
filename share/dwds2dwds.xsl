<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2dwds.xsl -->
<!-- Version 1.0 -->
<!-- Andreas Nolda 2023-06-26 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib"
                xpath-default-namespace="http://www.dwds.de/ns/1.0"
                exclude-result-prefixes="n">

<xsl:include href="files.xsl"/>

<xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"/>

<xsl:strip-space elements="*"/>

<!-- file listing sources to be included -->
<xsl:param name="manifest-file"/>

<xsl:variable name="manifest">
  <xsl:if test="doc-available(n:absolute-path($manifest-file))">
    <!-- $manifest-file has empty namespaces -->
    <xsl:copy-of select="doc(n:absolute-path($manifest-file))/*/*"/>
  </xsl:if>
</xsl:variable>

<!-- process sources listed in $manifest-file -->
<xsl:template name="xsl:initial-template">
  <DWDS>
    <!-- $manifest has empty namespaces -->
    <xsl:for-each select="distinct-values($manifest/*/@href)">
      <xsl:call-template name="process-sources">
        <xsl:with-param name="file"
                        select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </DWDS>
</xsl:template>

<xsl:template name="process-sources">
  <xsl:param name="file"/>
  <xsl:for-each select="doc(n:absolute-path($file))">
    <xsl:apply-templates select="/DWDS/Artikel[not(@Status!='Red-f')]"/>
  </xsl:for-each>
</xsl:template>

<!-- process individual source (for testing purposes) -->
<xsl:template match="/">
  <DWDS>
    <xsl:apply-templates select="/DWDS/Artikel"/>
  </DWDS>
</xsl:template>

<xsl:template match="Artikel">
  <!-- ignore idioms and other syntactically complex units -->
  <!-- ignore non-standard spellings -->
  <!-- ignore form specifications without part of speech -->
  <xsl:if test="Formangabe[Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                     [not(@Typ)]]
                          [Grammatik/Wortklasse]">
    <Artikel>
      <xsl:apply-templates select="Formangabe[Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                        [not(@Typ)]]
                                             [Grammatik/Wortklasse]"/>
      <xsl:apply-templates select="Verweise[not(@Typ!='Derivation' and
                                                @Typ!='Komposition')]"/>
    </Artikel>
  </xsl:if>
</xsl:template>

<xsl:template match="Formangabe">
  <Formangabe>
    <xsl:copy-of select="@Typ"/>
    <xsl:apply-templates select="Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                           [not(@Typ)]"/>
    <xsl:apply-templates select="Grammatik"/>
  </Formangabe>
</xsl:template>

<xsl:template match="Schreibung">
  <Schreibung>
    <xsl:copy-of select="@hidx"/>
    <xsl:apply-templates/>
  </Schreibung>
</xsl:template>

<xsl:template match="Grammatik">
  <Grammatik>
    <xsl:apply-templates select="Auxiliar |
                                 Einschraenkung |
                                 Funktionspraeferenz |
                                 Genitiv |
                                 Genus |
                                 indeklinabel |
                                 Komparativ |
                                 Numeruspraeferenz |
                                 Partizip_II |
                                 Plural |
                                 Positivvariante |
                                 Praesens |
                                 Praeteritum |
                                 Superlativ |
                                 Wortklasse"/>
  </Grammatik>
</xsl:template>

<xsl:template match="Auxiliar |
                     Einschraenkung |
                     Genitiv |
                     Genus |
                     indeklinabel |
                     Komparativ |
                     Numeruspraeferenz |
                     Partizip_II |
                     Plural |
                     Positivvariante |
                     Praesens |
                     Praeteritum |
                     Superlativ |
                     Wortklasse">
  <xsl:element name="{name()}">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="Funktionspraeferenz">
  <Funktionspraeferenz>
    <xsl:copy-of select="@Frequenz"/>
    <xsl:apply-templates/>
  </Funktionspraeferenz>
</xsl:template>

<xsl:template match="Verweise">
  <Verweise>
    <xsl:copy-of select="@Typ"/>
    <xsl:apply-templates select="Verweis"/>
  </Verweise>
</xsl:template>

<xsl:template match="Verweis">
  <Verweis>
    <xsl:copy-of select="@Typ"/>
    <xsl:apply-templates select="Ziellemma"/>
  </Verweis>
</xsl:template>

<xsl:template match="Ziellemma">
  <Ziellemma>
    <xsl:copy-of select="@hidx"/>
    <xsl:apply-templates/>
  </Ziellemma>
</xsl:template>
</xsl:stylesheet>
