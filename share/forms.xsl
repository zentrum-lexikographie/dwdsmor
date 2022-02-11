<?xml version="1.0" encoding="utf-8"?>
<!-- forms.xsl -->
<!-- Version 1.1 -->
<!-- Andreas Nolda 2022-02-11 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

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
  <xsl:variable name="form"
                select="normalize-space(dwds:Praesens)"/>
  <xsl:choose>
    <xsl:when test="matches($form,'^.+?e?t$')">
      <xsl:value-of select="replace($form,'^(.+?)e?t$',
                                          '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$form"/><!-- ? -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- past-stem forms -->
<xsl:template name="past-stem">
  <xsl:variable name="form"
                select="normalize-space(dwds:Praeteritum)"/>
  <xsl:choose>
    <xsl:when test="matches($form,'^.+?e?te$')">
      <xsl:value-of select="replace($form,'^(.+?)e?te$',
                                          '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- participle-stem forms -->
<xsl:template name="participle-stem">
  <xsl:param name="lemma"/>
  <xsl:variable name="form"
                select="normalize-space(dwds:Partizip_II)"/>
  <xsl:choose>
    <xsl:when test="matches($form,'^ge.+?e?t$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+?)e?t$',
                                          '$1')"/>
    </xsl:when>
    <xsl:when test="matches($form,'^.+?e?t$')">
      <xsl:value-of select="replace($form,'^(.+?)e?t$',
                                          '$1')"/>
    </xsl:when>
    <xsl:when test="matches($form,'^ge.+en$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+)en$',
                                          '$1')"/>
    </xsl:when>
    <xsl:when test="matches($form,'^.+en$')">
      <xsl:value-of select="replace($form,'^(.+)en$',
                                          '$1')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
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

<!-- extract inflection marker(s) from nominal form specification, if any;
     else return the form itself -->
<xsl:template name="get-nominal-marker">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- suffix -->
    <xsl:when test="starts-with($form,'-')">
      <xsl:value-of select="$form"/>
    </xsl:when>
    <!-- form without umlaut nor suffix -->
    <xsl:when test="matches($form,concat('^',$lemma,'$'))">-</xsl:when>
    <!-- form with umlaut -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re($lemma),'$'))">&#x308;-</xsl:when>
    <!-- form with suffix -->
    <xsl:when test="matches($form,concat('^',$lemma,'.+$'))">
      <xsl:value-of select="concat('-',replace($form,concat('^',$lemma),
                                                     ''))"/>
    </xsl:when>
    <!-- form with umlaut and suffix -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re($lemma),'.+$'))">
      <xsl:value-of select="concat('&#x308;-',replace($form,concat('^',n:umlaut-re($lemma)),
                                                            ''))"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- extract inflection marker(s) from verbal form specification, if any;
     else return the form itself -->
<xsl:template name="get-verbal-marker">
  <xsl:param name="form"/>
  <xsl:param name="stem"/>
  <xsl:choose>
    <!-- suffix -->
    <xsl:when test="starts-with($form,'-')">
      <xsl:value-of select="$form"/>
    </xsl:when>
    <!-- form without affix -->
    <xsl:when test="matches($form,concat('^',$stem,'$'))">-</xsl:when>
    <!-- form with suffix -->
    <xsl:when test="matches($form,concat('^',$stem,'.+$'))">
      <xsl:value-of select="concat('-',replace($form,concat('^',$stem),
                                                     ''))"/>
    </xsl:when>
    <!-- form with "ge-" prefix and suffix -->
    <xsl:when test="matches($form,concat('^ge',$stem,'.+$'))">
      <xsl:value-of select="concat('ge-',replace($form,concat('^ge',$stem),
                                                       ''))"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
