<?xml version="1.0" encoding="utf-8"?>
<!-- entries.xsl -->
<!-- Version 19.1 -->
<!-- Andreas Nolda 2025-09-10 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="forms.xsl"/>

<xsl:include href="strings.xsl"/>

<xsl:variable name="minimal-frequency">0.1</xsl:variable>

<!-- stems -->
<xsl:template name="stem-entry">
  <xsl:param name="lemma"
             select="@lemma"/>
  <xsl:param name="stem"
             select="@stem"/>
  <xsl:param name="abbreviation"
             select="@abbreviation"/>
  <xsl:param name="etymology"
             select="@etymology"/>
  <xsl:param name="pos"/>
  <xsl:param name="subcat"/>
  <xsl:param name="class"/>
  <xsl:if test="string-length($lemma)&gt;0 and
                string-length($pos)&gt;0">
    <xsl:text>&lt;Stem&gt;</xsl:text>
    <xsl:if test="$abbreviation='yes'">
      <xsl:text>&lt;Abbr&gt;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="string-length($stem)&gt;0">
        <xsl:value-of select="n:pair($lemma,$stem)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$lemma"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="insert-lemma-index">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
    <xsl:call-template name="insert-paradigm-index">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="$pos"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:if test="string-length($subcat)&gt;0">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$subcat"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:text>&lt;base&gt;</xsl:text>
    <xsl:if test="string-length($etymology)&gt;0">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$etymology"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:if test="string-length($class)&gt;0">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$class"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:text>&#xA;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- composition stems  -->
<xsl:template name="comp-stem-entry">
  <xsl:param name="lemma"
             select="@lemma"/>
  <xsl:param name="stem"
             select="@stem"/>
  <xsl:param name="abbreviation"
             select="@abbreviation"/>
  <xsl:param name="etymology"
             select="@etymology"/>
  <xsl:param name="pos"/>
  <xsl:param name="frequency"/>
  <xsl:if test="string-length($lemma)&gt;0 and
                string-length($pos)&gt;0">
    <xsl:choose>
      <xsl:when test="$frequency&gt;=$minimal-frequency">
        <xsl:text>&lt;Stem&gt;</xsl:text>
        <xsl:if test="$abbreviation='yes'">
          <xsl:text>&lt;Abbr&gt;</xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="string-length($stem)&gt;0">
            <xsl:value-of select="n:pair($lemma,n:segment($lemma,$stem))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lemma"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$pos"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:text>&lt;comp&gt;</xsl:text>
        <xsl:if test="string-length($etymology)&gt;0">
          <xsl:text>&lt;</xsl:text>
          <xsl:value-of select="$etymology"/>
          <xsl:text>&gt;</xsl:text>
        </xsl:if>
        <xsl:text>&#xA;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: "</xsl:text>
          <xsl:value-of select="$lemma"/>
          <xsl:text>" has compounding stem "</xsl:text>
          <xsl:value-of select="$stem"/>
          <xsl:text>" with type frequency </xsl:text>
          <xsl:value-of select="$frequency"/>
          <xsl:text disable-output-escaping="yes"> &lt; minimum type frequency </xsl:text>
          <xsl:value-of select="$minimal-frequency"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- derivation stems -->
<xsl:template name="der-stem-entry">
  <xsl:param name="lemma"
             select="@lemma"/>
  <xsl:param name="stem"
             select="@stem"/>
  <xsl:param name="abbreviation"
             select="@abbreviation"/>
  <xsl:param name="etymology"
             select="@etymology"/>
  <xsl:param name="suffs"
             select="@suffs"/>
  <xsl:param name="pos"/>
  <xsl:param name="frequency"/>
  <xsl:if test="string-length($lemma)&gt;0 and
                string-length($pos)&gt;0 and
                string-length($suffs)&gt;0">
    <xsl:choose>
      <xsl:when test="$frequency&gt;=$minimal-frequency">
        <xsl:for-each select="tokenize($suffs,'&#x20;')">
          <xsl:text>&lt;Stem&gt;</xsl:text>
          <xsl:if test="$abbreviation='yes'">
            <xsl:text>&lt;Abbr&gt;</xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="string-length($stem)&gt;0">
              <xsl:value-of select="n:pair($lemma,n:segment($lemma,$stem))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$lemma"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>&lt;</xsl:text>
          <xsl:value-of select="$pos"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:text>&lt;der&gt;</xsl:text>
          <xsl:text>&lt;-</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>&gt;</xsl:text>
          <xsl:if test="string-length($etymology)&gt;0">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="$etymology"/>
            <xsl:text>&gt;</xsl:text>
          </xsl:if>
          <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: "</xsl:text>
          <xsl:value-of select="$lemma"/>
          <xsl:text>" has derivation stem "</xsl:text>
          <xsl:value-of select="$stem"/>
          <xsl:text>" with type frequency </xsl:text>
          <xsl:value-of select="$frequency"/>
          <xsl:text disable-output-escaping="yes"> &lt; minimum type frequency </xsl:text>
          <xsl:value-of select="$minimal-frequency"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- verb stems -->
<xsl:template name="verb-stem-entry">
  <xsl:param name="lemma"
             select="@lemma"/>
  <xsl:param name="stem"
             select="@stem"/>
  <xsl:param name="abbreviation"
             select="@abbreviation"/>
  <xsl:param name="etymology"
             select="@etymology"/>
  <xsl:param name="participle"
             select="@participle"/>
  <xsl:param name="auxiliary"
             select="@auxiliary"/>
  <xsl:param name="particle"/>
  <xsl:param name="particle2"/>
  <xsl:param name="class"/>
  <xsl:if test="string-length($lemma)&gt;0 and
                string-length($stem)&gt;0 and
                string-length($participle)&gt;0">
    <xsl:variable name="segmented-lemma">
      <xsl:choose>
        <!-- lemmas ending in consonant + "een" or "ien" -->
        <xsl:when test="matches($lemma,'[^aeiouäöü][ei]en$')">
          <xsl:value-of select="n:segment-from-end('n',$lemma)"/>
        </xsl:when>
        <!-- borrowed lemmas ending in "c", "g", or "p" + "len" -->
        <xsl:when test="matches($lemma,'[cgp]len$')">
          <xsl:value-of select="n:segment-from-end('n',$lemma)"/>
        </xsl:when>
        <!-- other lemmas -->
        <xsl:otherwise>
          <xsl:value-of select="n:segment-from-end(replace($lemma,'^.+?(e?n)$','$1'),$lemma)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>&lt;Stem&gt;</xsl:text>
    <xsl:if test="$abbreviation='yes'">
      <xsl:text>&lt;Abbr&gt;</xsl:text>
    </xsl:if>
    <xsl:if test="string-length($particle)&gt;0">
      <xsl:if test="string-length($particle2)&gt;0">
        <xsl:value-of select="$particle2"/>
        <xsl:text>&lt;VB&gt;</xsl:text>
      </xsl:if>
      <xsl:value-of select="$particle"/>
      <xsl:text>&lt;VB&gt;</xsl:text>
    </xsl:if>
    <xsl:call-template name="participle-prefix">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="form"
                      select="$participle"/>
    </xsl:call-template>
    <xsl:value-of select="n:pair($segmented-lemma,$stem)"/>
    <xsl:call-template name="insert-lemma-index">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
    <xsl:call-template name="insert-paradigm-index">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
    <xsl:text>&lt;V&gt;</xsl:text>
    <xsl:text>&lt;base&gt;</xsl:text>
    <xsl:if test="string-length($etymology)&gt;0">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$etymology"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="$class"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:if test="string-length($auxiliary)&gt;0">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$auxiliary"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:if>
    <xsl:text>&#xA;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- helper templates -->

<xsl:template name="insert-lemma-index">
  <xsl:param name="lemma"/>
  <xsl:if test="string-length(@lemma-index)&gt;0">
    <xsl:choose>
      <xsl:when test="not(string(number(@lemma-index))='NaN') and
                      @lemma-index&gt;0 and
                      @lemma-index&lt;8">
        <xsl:text>&lt;</xsl:text>
        <xsl:text>IDX</xsl:text>
        <xsl:value-of select="@lemma-index"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: "</xsl:text>
          <xsl:value-of select="$lemma"/>
          <xsl:text>" has unsupported lemma index </xsl:text>
          <xsl:value-of select="@lemma-index"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="insert-paradigm-index">
  <xsl:param name="lemma"/>
  <xsl:if test="string-length(@paradigm-index)&gt;0">
    <xsl:choose>
      <xsl:when test="not(string(number(@paradigm-index))='NaN') and
                      @paradigm-index&gt;0 and
                      @paradigm-index&lt;8">
        <xsl:text>&lt;</xsl:text>
        <xsl:text>PAR</xsl:text>
        <xsl:value-of select="@paradigm-index"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: "</xsl:text>
          <xsl:value-of select="$lemma"/>
          <xsl:text>" has unsupported paradigm index </xsl:text>
          <xsl:value-of select="@paradigm-index"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
