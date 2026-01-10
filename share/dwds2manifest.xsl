<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2manifest.xsl -->
<!-- Version 2.3 -->
<!-- Andreas Nolda 2026-01-09 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib"
                exclude-result-prefixes="dwds n">

<xsl:include href="files.xsl"/>

<xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"/>

<xsl:strip-space elements="*"/>

<!-- top directory of DWDS sources -->
<xsl:param name="dwds-dir"/>

<!-- top directory of auxiliary sources -->
<xsl:param name="aux-dir"/>

<!-- file listing sources to be excluded -->
<xsl:param name="exclude-file"/>

<xsl:variable name="exclude">
  <xsl:if test="doc-available(n:absolute-path($exclude-file))">
    <xsl:copy-of select="doc(n:absolute-path($exclude-file))/exclude/*"/>
  </xsl:if>
</xsl:variable>

<!-- recursively process sources in $dwds-dir and $aux-dir,
     except for those listed in $exclude-file -->
<xsl:template name="xsl:initial-template">
  <manifest>
    <xsl:if test="string-length($dwds-dir)&gt;0">
      <xsl:call-template name="process-sources">
        <xsl:with-param name="dir"
                        select="$dwds-dir"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="string-length($aux-dir)&gt;0">
      <xsl:call-template name="process-sources">
        <xsl:with-param name="dir"
                        select="$aux-dir"/>
      </xsl:call-template>
    </xsl:if>
  </manifest>
</xsl:template>

<xsl:template name="process-sources">
  <xsl:param name="dir"/>
  <xsl:for-each select="collection(concat(n:absolute-path($dir),'?select=*.xml;recurse=yes'))">
    <xsl:variable name="article-uri"
                        select="document-uri(/)"/>
    <xsl:if test="not(exists($exclude/source[ends-with($article-uri,@href)]))">
      <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel[not(@Status!='Red-f')]"/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- process individual source (for testing purposes) -->
<xsl:template match="/">
  <manifest>
    <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel"/>
  </manifest>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <xsl:variable name="file"
                select="n:relative-path(document-uri(/))"/>
  <xsl:variable name="id"
                      select="@id"/><!-- may be empty -->
  <!-- position of article in file -->
  <xsl:variable name="n"
                select="position()"/>
  <xsl:if test="not(string-length($id)&gt;0 and
                    exists($exclude/source[ends-with(@href,$id)]))"><!-- by convention, Artikel/@id = source/@href minus the "wb/" subdirectory prefix -->
    <!-- ignore duplicate lemma-index pairs -->
    <!-- ignore idioms and non-standard spellings -->
    <xsl:for-each-group select="dwds:Formangabe[not(@class='invisible')]/dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                                                        [not(@Typ)]"
                        group-by="normalize-space(.)">
      <xsl:variable name="lemma"
                    select="normalize-space(.)"/>
      <xsl:for-each-group select="current-group()"
                          group-by="if (@hidx) then @hidx else 0">
        <xsl:variable name="index"
                      select="@hidx"/>
        <source>
          <xsl:attribute name="lemma"
                         select="$lemma"/>
          <xsl:if test="@hidx">
            <xsl:attribute name="index"
                           select="$index"/>
          </xsl:if>
          <xsl:attribute name="n"
                         select="$n"/>
          <!-- <xsl:if test="string-length($id)&gt;0">
            <xsl:attribute name="id"
                           select="$id"/>
          </xsl:if> -->
          <xsl:attribute name="href"
                         select="$file"/>
        </source>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
