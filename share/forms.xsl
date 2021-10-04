<?xml version="1.0" encoding="utf-8"?>
<!-- forms.xsl -->
<!-- Version 1.0 -->
<!-- Andreas Nolda 2021-09-24 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0">

<!-- affix forms -->
<xsl:template name="affix-form">
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="starts-with($lemma,'-')">
      <xsl:value-of select="replace($lemma,'-(.+)',
                                           '$1')"/>
    </xsl:when>
    <xsl:when test="ends-with($lemma,'-')">
      <xsl:value-of select="replace($lemma,'(.+)-',
                                           '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- base-stem forms of verbs -->
<xsl:template name="verb-stem">
  <xsl:param name="lemma"/>
  <xsl:value-of select="replace($lemma,'^(.+?)e?n$',
                                       '$1')"/>
</xsl:template>

<!-- present-stem forms -->
<xsl:template name="present-stem">
  <xsl:variable name="dwds"
                select="normalize-space(dwds:Praesens)"/>
  <xsl:choose>
    <xsl:when test="matches($dwds,'^.+?e?t$')">
      <xsl:value-of select="replace($dwds,'^(.+?)e?t$',
                                          '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$dwds"/><!-- ? -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- past-stem forms -->
<xsl:template name="past-stem">
  <xsl:variable name="dwds"
                select="normalize-space(dwds:Praeteritum)"/>
  <xsl:choose>
    <xsl:when test="matches($dwds,'^.+?e?te$')">
      <xsl:value-of select="replace($dwds,'^(.+?)e?te$',
                                          '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$dwds"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- participle-stem forms -->
<xsl:template name="participle-stem">
  <xsl:param name="lemma"/>
  <xsl:variable name="dwds"
                select="normalize-space(dwds:Partizip_II)"/>
  <xsl:choose>
    <xsl:when test="matches($dwds,'^ge.+?e?t$') and
                    not(matches($dwds,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($dwds,'^ge(.+?)e?t$',
                                          '$1')"/>
    </xsl:when>
    <xsl:when test="matches($dwds,'^.+?e?t$')">
      <xsl:value-of select="replace($dwds,'^(.+?)e?t$',
                                          '$1')"/>
    </xsl:when>
    <xsl:when test="matches($dwds,'^ge.+en$') and
                    not(matches($dwds,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($dwds,'^ge(.+)en$',
                                          '$1')"/>
    </xsl:when>
    <xsl:when test="matches($dwds,'^.+en$')">
      <xsl:value-of select="replace($dwds,'^(.+)en$',
                                          '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$dwds"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- prefixes of participles -->
<xsl:template name="participle-prefix">
  <xsl:param name="lemma"/>
  <xsl:variable name="participle"
                select="normalize-space(dwds:Partizip_II)"/>
  <xsl:variable name="participle-stem">
    <xsl:call-template name="participle-stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="matches($participle,concat('^ge',$participle-stem,'e?[nt]$'))">
    <xsl:text>&lt;ge&gt;</xsl:text>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
