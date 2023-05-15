<?xml version="1.0" encoding="utf-8"?>
<!-- forms.xsl -->
<!-- Version 6.0 -->
<!-- Andreas Nolda 2023-03-15 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- affix forms -->
<xsl:template name="affix-form">
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- suffixes -->
    <xsl:when test="starts-with($lemma,'-')">
      <xsl:value-of select="replace($lemma,'-(.+)','$1')"/>
    </xsl:when>
    <!-- prefixes -->
    <xsl:when test="ends-with($lemma,'-')">
      <xsl:value-of select="replace($lemma,'(.+)-','$1')"/>
    </xsl:when>
    <!-- other forms -->
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- affix separability -->
<xsl:template name="affix-separability">
  <xsl:param name="type"/>
  <xsl:param name="separable"/>
  <xsl:param name="selection"/>
  <xsl:if test="$type='prefix' and
                $separable='no' and
                $selection='V'">
    <xsl:text>&lt;no-ge&gt;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- extract inflection markers from nominal form specification, if any;
     else return the form itself -->
<xsl:template name="get-nominal-marker">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- suffixes -->
    <xsl:when test="starts-with($form,'-')">
      <xsl:value-of select="$form"/>
    </xsl:when>
    <!-- forms without umlaut nor suffix -->
    <xsl:when test="$form=$lemma">-</xsl:when>
    <!-- forms with umlaut -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re($lemma),'$'))">&#x308;-</xsl:when>
    <!-- forms with suffix -->
    <xsl:when test="matches($form,concat('^',$lemma,'.+$'))">
      <xsl:value-of select="concat('-',replace($form,concat('^',$lemma),''))"/>
    </xsl:when>
    <!-- forms with umlaut and suffix -->
    <xsl:when test="matches($form,concat('^',n:umlaut-re($lemma),'.+$'))">
      <xsl:value-of select="concat('&#x308;-',replace($form,concat('^',n:umlaut-re($lemma)),''))"/>
    </xsl:when>
    <!-- other forms -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- extract (weak) inflection markers from verbal form specification, if any;
     else return the form itself -->
<xsl:template name="get-verbal-marker">
  <xsl:param name="form"/>
  <xsl:param name="stem"/>
  <xsl:choose>
    <!-- suffixes -->
    <xsl:when test="starts-with($form,'-')">
      <xsl:value-of select="$form"/>
    </xsl:when>
    <!-- forms without affix -->
    <xsl:when test="$form=$stem">-</xsl:when>
    <!-- forms with suffix -->
    <xsl:when test="matches($form,concat('^',$stem,'.+$'))">
      <xsl:value-of select="concat('-',replace($form,concat('^',$stem),''))"/>
    </xsl:when>
    <!-- forms with "ge-" prefix and suffix -->
    <xsl:when test="matches($form,concat('^ge',$stem,'.+$'))">
      <xsl:value-of select="concat('ge-',replace($form,concat('^ge',$stem),''))"/>
    </xsl:when>
    <!-- other forms -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- stems of feminine adjectival words -->
<xsl:template name="feminine-stem">
  <xsl:param name="lemma"/>
  <xsl:value-of select="replace($lemma,'i?e$','')"/>
</xsl:template>

<!-- base stems of verbs -->
<xsl:template name="verb-stem">
  <xsl:param name="lemma"/>
  <xsl:value-of select="replace($lemma,'e?n$','')"/>
</xsl:template>

<!-- present stems -->
<xsl:template name="present-stem">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- forms with stem-final "tt" -->
    <xsl:when test="matches($form,'tt$')">
      <xsl:value-of select="$form"/>
    </xsl:when>
    <!-- forms without umlaut or "e"/"i"-alternation -->
    <xsl:when test="matches($form,'^.+?e?t$') and
                    matches($form,concat('^',replace($lemma,'e?n$',''),'e?t$'))">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- forms with umlaut -->
    <xsl:when test="matches($form,'^.+?e?t$') and
                    matches($form,concat('^',n:umlaut-re(replace($lemma,'e?n$','')),'e?t$'))">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- forms with "e"/"i"-alternation -->
    <xsl:when test="matches($form,'^.+?e?t$') and
                    matches($form,concat('^',n:e-i-alternation-re(replace($lemma,'e?n$','')),'e?t$'))">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- other forms -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- past stems -->
<xsl:template name="past-stem">
  <xsl:param name="form"/>
  <xsl:choose>
    <!-- weak forms -->
    <xsl:when test="matches($form,'^.+?e?te$')">
      <xsl:value-of select="replace($form,'e?te$','')"/>
    </xsl:when>
    <!-- other forms -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- participle stems -->
<xsl:template name="participle-stem">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- weak forms with "ge-" prefix -->
    <xsl:when test="matches($form,'^ge.+?e?t$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+?)e?t$','$1')"/>
    </xsl:when>
    <!-- weak forms without "ge-" prefix -->
    <xsl:when test="matches($form,'^.+?e?t$')">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- strong forms with "ge-" prefix -->
    <xsl:when test="matches($form,'^ge.+?e?n$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+?)e?n$','$1')"/>
    </xsl:when>
    <!-- strong forms without "ge-" prefix -->
    <xsl:when test="matches($form,'^.+?e?n$')">
      <xsl:value-of select="replace($form,'e?n$','')"/>
    </xsl:when>
    <!-- other forms -->
    <xsl:otherwise>
      <xsl:value-of select="$form"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- participle prefixes -->
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

<!-- compounding stems -->
<xsl:template name="comp-stem">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma1"/>
  <xsl:param name="lemma2"/>
  <xsl:if test="matches($lemma,concat('^.*[^-]-?',$lemma2,'$'),'i')">
    <xsl:choose>
      <!-- hyphenated spellings ("Schiff-Fahrt") -->
      <xsl:when test="matches($lemma,concat('-',$lemma2,'$'),'i')">
        <xsl:call-template name="set-comp-stem-case">
          <xsl:with-param name="lemma"
                          select="$lemma1"/>
          <xsl:with-param name="comp-stem"
                          select="replace($lemma,concat('-',$lemma2,'$'),'','i')"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other spellings -->
      <xsl:otherwise>
        <xsl:call-template name="set-comp-stem-case">
          <xsl:with-param name="lemma"
                          select="$lemma1"/>
          <xsl:with-param name="comp-stem"
                          select="replace($lemma,concat($lemma2,'$'),'','i')"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- adjust case of compounding stem as required -->
<xsl:template name="set-comp-stem-case">
  <xsl:param name="lemma"/>
  <xsl:param name="comp-stem"/>
  <xsl:choose>
    <xsl:when test="matches($lemma,'^\p{Ll}') and
                    matches($comp-stem,'^\p{Lu}')">
      <xsl:value-of select="lower-case($comp-stem)"/>
    </xsl:when>
    <xsl:when test="matches($lemma,'^\p{Lu}') and
                    matches($comp-stem,'^\p{Ll}')">
      <xsl:value-of select="upper-case(substring($comp-stem,1,1))"/>
      <xsl:value-of select="substring($comp-stem,2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$comp-stem"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- derivation stems -->
<xsl:template name="der-stem">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma1"/>
  <xsl:param name="lemma2"/><!-- suffix lemma -->
  <xsl:if test="matches($lemma,concat('^.*[^-]',$lemma2,'$'),'i')">
    <xsl:call-template name="set-der-stem-case">
      <xsl:with-param name="lemma"
                      select="$lemma1"/>
      <xsl:with-param name="der-stem"
                      select="replace($lemma,concat($lemma2,'$'),'','i')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- adjust case of derivation stem as required -->
<xsl:template name="set-der-stem-case">
  <xsl:param name="lemma"/>
  <xsl:param name="der-stem"/>
  <xsl:choose>
    <xsl:when test="matches($lemma,'^\p{Ll}') and
                    matches($der-stem,'^\p{Lu}')">
      <xsl:value-of select="lower-case($der-stem)"/>
    </xsl:when>
    <xsl:when test="matches($lemma,'^\p{Lu}') and
                    matches($der-stem,'^\p{Ll}')">
      <xsl:value-of select="upper-case(substring($der-stem,1,1))"/>
      <xsl:value-of select="substring($der-stem,2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$der-stem"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
