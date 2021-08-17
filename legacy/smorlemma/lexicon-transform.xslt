<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" indent="no"/>
  <xsl:template match="smor">
    <xsl:apply-templates select="BaseStem"/>
  </xsl:template>
  <xsl:template match="BaseStem">
    <xsl:text>&lt;Stem&gt;</xsl:text>
    <xsl:apply-templates select="MorphMarker"/>
    <xsl:apply-templates select="Lemma"/>
    <xsl:apply-templates select="Stem"/>
    <xsl:apply-templates select="Pos"/>
    <xsl:text>&lt;base&gt;</xsl:text>
    <xsl:apply-templates select="Origin"/>
    <xsl:apply-templates select="InfClass"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <xsl:template match="Lemma|Upper">
    <xsl:value-of select="."/>
    <xsl:text>:</xsl:text>
  </xsl:template>
  <xsl:template match="Stem|Lower">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="Pos|Origin|InfClass|MorphMarker">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
</xsl:stylesheet>