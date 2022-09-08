<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2dwdsmor.xsl -->
<!-- Version 9.0 -->
<!-- Andreas Nolda 2022-08-23 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="strings.xsl"/>

<xsl:include href="forms.xsl"/>

<xsl:include href="dwds.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

<xsl:template name="insert-value">
  <xsl:param name="value"/>
  <xsl:param name="type"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="string-length($value)&gt;0">
      <xsl:value-of select="$value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Warning: "</xsl:text>
        <xsl:value-of select="$lemma"/>
        <xsl:text>" has UNKNOWN </xsl:text>
        <xsl:value-of select="$type"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
      <xsl:text>UNKNOWN</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

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
  <xsl:param name="type"/>
  <xsl:param name="separable"/>
  <xsl:param name="selection"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value">
      <xsl:choose>
        <xsl:when test="$type='prefix'">
          <xsl:text>Prefix</xsl:text>
        </xsl:when>
        <xsl:when test="$type='suffix'">
          <xsl:text>Suffix</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:with-param>
    <xsl:with-param name="type">affix type</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
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
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value">
      <xsl:choose>
        <xsl:when test="$type='prefix'">
          <xsl:text>PREF</xsl:text>
        </xsl:when>
        <xsl:when test="$type='suffix'">
          <xsl:text>SUFF</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:with-param>
    <xsl:with-param name="type">POS</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$selection"/>
    <xsl:with-param name="type">selection</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$etymology"/>
    <xsl:with-param name="type">etymology</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for words -->
<xsl:template name="word-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
  <xsl:param name="pos"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
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
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$pos"/>
    <xsl:with-param name="type">POS</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$etymology"/>
    <xsl:with-param name="type">etymology</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$class"/>
    <xsl:with-param name="type">class</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<!-- lexical entries for adjectives -->
<xsl:template name="adjective-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="form"/>
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
  <xsl:param name="participle"/>
  <xsl:param name="particle"/>
  <xsl:param name="stem"/>
  <xsl:param name="class"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:if test="string-length($particle)&gt;0">
    <xsl:text>&lt;NoPref&gt;</xsl:text>
    <xsl:value-of select="$particle"/>
    <xsl:text>&lt;VPART&gt;</xsl:text>
  </xsl:if>
  <xsl:call-template name="participle-prefix">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="form"
                    select="$participle"/>
  </xsl:call-template>
  <xsl:value-of select="n:pair($lemma,$stem)"/>
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
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$etymology"/>
    <xsl:with-param name="type">etymology</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$class"/>
    <xsl:with-param name="type">class</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
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
    <xsl:with-param name="pos">OTHER</xsl:with-param>
    <xsl:with-param name="class"
                    select="$class"/>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
</xsl:template>
</xsl:stylesheet>
