<?xml version="1.0" encoding="utf-8"?>
<!-- forms.xsl -->
<!-- Version 3.1 -->
<!-- Andreas Nolda 2022-03-30 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- affix forms -->
<xsl:template name="affix-form">
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- suffix -->
    <xsl:when test="starts-with($lemma,'-')">
      <xsl:value-of select="replace($lemma,'-(.+)','$1')"/>
    </xsl:when>
    <!-- prefix -->
    <xsl:when test="ends-with($lemma,'-')">
      <xsl:value-of select="replace($lemma,'(.+)-','$1')"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- base stem of verbs -->
<xsl:template name="verb-stem">
  <xsl:param name="lemma"/>
  <xsl:value-of select="replace($lemma,'e?n$','')"/>
</xsl:template>

<!-- present stem -->
<xsl:template name="present-stem">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- form with stem-final "tt" -->
    <xsl:when test="matches($form,'tt$')">
      <xsl:value-of select="$form"/>
    </xsl:when>
    <!-- form without umlaut or "e"/"i"-alternation -->
    <xsl:when test="matches($form,'^.+?e?t$') and
                    matches($form,concat('^',replace($lemma,'e?n$',''),'e?t$'))">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- form with umlaut -->
    <xsl:when test="matches($form,'^.+?e?t$') and
                    matches($form,concat('^',n:umlaut-re(replace($lemma,'e?n$','')),'e?t$'))">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- form with "e"/"i"-alternation -->
    <xsl:when test="matches($form,'^.+?e?t$') and
                    matches($form,concat('^',n:e-i-alternation-re(replace($lemma,'e?n$','')),'e?t$'))">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- past stem -->
<xsl:template name="past-stem">
  <xsl:param name="form"/>
  <xsl:choose>
    <!-- weak form -->
    <xsl:when test="matches($form,'^.+?e?te$')">
      <xsl:value-of select="replace($form,'e?te$','')"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- participle stem -->
<xsl:template name="participle-stem">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- weak form with "ge-" prefix -->
    <xsl:when test="matches($form,'^ge.+?e?t$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+?)e?t$','$1')"/>
    </xsl:when>
    <!-- weak form without "ge-" prefix -->
    <xsl:when test="matches($form,'^.+?e?t$')">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- strong form with "ge-" prefix -->
    <xsl:when test="matches($form,'^ge.+?e?n$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+?)e?n$','$1')"/>
    </xsl:when>
    <!-- strong form without "ge-" prefix -->
    <xsl:when test="matches($form,'^.+?e?n$')">
      <xsl:value-of select="replace($form,'e?n$','')"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- prefixes of participles -->
<xsl:template name="participle-prefix">
  <xsl:param name="form"
             select="normalize-space(dwds:Partizip_II)"/>
  <xsl:param name="lemma"/>
  <xsl:variable name="participle-stem">
    <xsl:call-template name="participle-stem">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="matches($form,concat('^ge',$participle-stem,'e?[nt]$'))">
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
    <!-- form without "ß"/"ss"-alternation nor umlaut nor suffix -->
    <xsl:when test="$form=$lemma">-</xsl:when>
    <!-- form with "ß"/"ss"-alternation -->
    <xsl:when test="matches($form,concat('^',n:sz-ss-alternation($lemma),'$'))">ß/ss-</xsl:when>
    <!-- form with umlaut -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re($lemma),'$'))">&#x308;-</xsl:when>
    <!-- form with "ß"/"ss"-alternation and umlaut -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re(n:sz-ss-alternation($lemma)),'$'))">&#x308;ß/ss-</xsl:when>
    <!-- form with suffix -->
    <xsl:when test="matches($form,concat('^',$lemma,'.+$'))">
      <xsl:value-of select="concat('-',replace($form,concat('^',$lemma),''))"/>
    </xsl:when>
    <!-- form with "ß"/"ss"-alternation and suffix -->
    <xsl:when test="matches($form,concat('^',n:sz-ss-alternation($lemma),'.+$'))">
      <xsl:value-of select="concat('ß/ss-',replace($form,concat('^',n:sz-ss-alternation($lemma)),''))"/>
    </xsl:when>
    <!-- form with umlaut and suffix -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re($lemma),'.+$'))">
      <xsl:value-of select="concat('&#x308;-',replace($form,concat('^',n:umlaut-re($lemma)),''))"/>
    </xsl:when>
    <!-- form with "ß"/"ss"-alternation, umlaut, and suffix -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re(n:sz-ss-alternation($lemma)),'.+$'))">
      <xsl:value-of select="concat('&#x308;ß/ss-',replace($form,concat('^',n:umlaut-re(n:sz-ss-alternation($lemma))),''))"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- extract (weak) inflection marker(s) from verbal form specification, if any;
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
    <xsl:when test="$form=$stem">-</xsl:when>
    <!-- form with suffix -->
    <xsl:when test="matches($form,concat('^',$stem,'.+$'))">
      <xsl:value-of select="concat('-',replace($form,concat('^',$stem),''))"/>
    </xsl:when>
    <!-- form with "ge-" prefix and suffix -->
    <xsl:when test="matches($form,concat('^ge',$stem,'.+$'))">
      <xsl:value-of select="concat('ge-',replace($form,concat('^ge',$stem),''))"/>
    </xsl:when>
    <!-- other form -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
