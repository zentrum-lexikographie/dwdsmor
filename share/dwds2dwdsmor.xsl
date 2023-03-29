<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2dwdsmor.xsl -->
<!-- Version 13.2 -->
<!-- Andreas Nolda 2023-03-29 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="strings.xsl"/>

<xsl:include href="forms.xsl"/>

<xsl:include href="dwds.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

<xsl:template name="insert-lemma-index">
  <xsl:param name="lemma-index"/>
  <xsl:param name="lemma"/>
  <xsl:if test="string-length($lemma-index)&gt;0">
    <xsl:choose>
      <xsl:when test="not(string(number($lemma-index))='NaN') and
                      $lemma-index&gt;0 and
                      $lemma-index&lt;6">
        <xsl:text>&lt;</xsl:text>
        <xsl:text>IDX</xsl:text>
        <xsl:value-of select="$lemma-index"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: "</xsl:text>
          <xsl:value-of select="$lemma"/>
          <xsl:text>" has UNSUPPORTED lemma index </xsl:text>
          <xsl:value-of select="$lemma-index"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="insert-paradigm-index">
  <xsl:param name="paradigm-index"/>
  <xsl:param name="lemma"/>
  <xsl:if test="string-length($paradigm-index)&gt;0">
    <xsl:choose>
      <xsl:when test="not(string(number($paradigm-index))='NaN') and
                      $paradigm-index&gt;0 and
                      $paradigm-index&lt;6">
        <xsl:text>&lt;</xsl:text>
        <xsl:text>PAR</xsl:text>
        <xsl:value-of select="$paradigm-index"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: "</xsl:text>
          <xsl:value-of select="$lemma"/>
          <xsl:text>" has UNSUPPORTED paradigm index </xsl:text>
          <xsl:value-of select="$paradigm-index"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- lexical entries for affixes -->
<xsl:template name="affix-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="type"/>
  <xsl:param name="separable"/>
  <xsl:param name="selection"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$type='prefix'">
      <xsl:text>Prefix</xsl:text>
    </xsl:when>
    <xsl:when test="$type='suffix'">
      <xsl:text>Suffix</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:text>&gt;</xsl:text>
  <xsl:if test="$abbreviation='yes'">
    <xsl:text>&lt;Abbr&gt;</xsl:text>
  </xsl:if>
  <xsl:call-template name="affix-separability">
    <xsl:with-param name="type"
                    select="$type"/>
    <xsl:with-param name="separable"
                    select="$separable"/>
    <xsl:with-param name="selection"
                    select="$selection"/>
  </xsl:call-template>
  <xsl:call-template name="affix-form">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:call-template name="insert-lemma-index">
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:call-template name="insert-paradigm-index">
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&lt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$type='prefix'">
      <xsl:text>PREF</xsl:text>
    </xsl:when>
    <xsl:when test="$type='suffix'">
      <xsl:text>SUFF</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$selection"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for words -->
<xsl:template name="word-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pos"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:if test="$abbreviation='yes'">
    <xsl:text>&lt;Abbr&gt;</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="string-length($form)&gt;0">
      <xsl:value-of select="n:pair($lemma,$form)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="insert-lemma-index">
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:call-template name="insert-paradigm-index">
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pos"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$class"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for composition stems of words -->
<xsl:template name="word-comp-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="comp-stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pos"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:if test="$abbreviation='yes'">
    <xsl:text>&lt;Abbr&gt;</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="string-length($comp-stem)&gt;0">
      <xsl:value-of select="n:pair($lemma,n:segment($lemma,$comp-stem))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pos"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;comp&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for derivation stems of words -->
<xsl:template name="word-der-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="der-stem"/>
  <xsl:param name="suffs"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pos"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:if test="$abbreviation='yes'">
    <xsl:text>&lt;Abbr&gt;</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="string-length($der-stem)&gt;0">
      <xsl:value-of select="n:pair($lemma,n:segment($lemma,$der-stem))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pos"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;der&gt;</xsl:text>
  <xsl:for-each select="tokenize(normalize-space($suffs),'&#x20;')">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&gt;</xsl:text>
  </xsl:for-each>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for adjectives -->
<xsl:template name="adjective-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:call-template name="word-entry">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="form"
                    select="$form"/>
    <xsl:with-param name="abbreviation"
                    select="$abbreviation"/>
    <xsl:with-param name="pos">ADJ</xsl:with-param>
    <xsl:with-param name="class"
                    select="$class"/>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
</xsl:template>

<!-- lexical entries for adverbs -->
<xsl:template name="adverb-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:call-template name="word-entry">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="form"
                    select="$form"/>
    <xsl:with-param name="abbreviation"
                    select="$abbreviation"/>
    <xsl:with-param name="pos">ADV</xsl:with-param>
    <xsl:with-param name="class"
                    select="$class"/>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
</xsl:template>

<!-- lexical entries for nouns -->
<xsl:template name="noun-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:call-template name="word-entry">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="form"
                    select="$form"/>
    <xsl:with-param name="abbreviation"
                    select="$abbreviation"/>
    <xsl:with-param name="pos">NN</xsl:with-param>
    <xsl:with-param name="class"
                    select="$class"/>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
</xsl:template>

<!-- lexical entries for verbs -->
<xsl:template name="verb-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="participle"/>
  <xsl:param name="particle"/>
  <xsl:param name="stem"/>
  <xsl:param name="class"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="etymology"/>
  <xsl:variable name="segmented-lemma"
                select="replace($lemma,'(e?n)$','&lt;FB&gt;$1')"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:if test="$abbreviation='yes'">
    <xsl:text>&lt;Abbr&gt;</xsl:text>
  </xsl:if>
  <xsl:if test="string-length($particle)&gt;0">
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
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:call-template name="insert-paradigm-index">
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&lt;V&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$class"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:if test="string-length($auxiliary)&gt;0">
    <xsl:choose>
      <xsl:when test="$auxiliary='hat'">
        <xsl:text>&lt;haben&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$auxiliary='ist'">
        <xsl:text>&lt;sein&gt;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for other words -->
<xsl:template name="other-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:call-template name="word-entry">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="form"
                    select="$form"/>
    <xsl:with-param name="abbreviation"
                    select="$abbreviation"/>
    <xsl:with-param name="pos">OTHER</xsl:with-param>
    <xsl:with-param name="class"
                    select="$class"/>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>
