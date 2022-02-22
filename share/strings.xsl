<?xml version="1.0" encoding="utf-8"?>
<!-- strings.xsl -->
<!-- Version 2.1 -->
<!-- Andreas Nolda 2022-02-22 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- return a regex matching the umlaut variant of $argument, if any -->
<!-- Caveat: Morphological umlaut in German affects, as a rule, the last
     full vowel in the last morph of the base form, provided that it is
     an umlautable vowel matching /([aou]|aa|oo|au)/. The regex returned
     by this function also matches forms with an umlaut preceding vowels
     not matching /([aou]|aa|oo|au)/. In particular, those vowels include
     "e", which cannot be excluded here since it may represent not only a
     full vowel, but also a schwa that can indeed follow the vowel
     affected by morphological umlaut. This 'overmatching', however, is
     harmless for the intended use case, since the regex is only tested
     against forms of the same paradigm, where such cases do not arise. -->
<xsl:function name="n:umlaut-re">
  <xsl:param name="argument"/>
  <xsl:choose>
    <!-- replace the last vowel matching /([AOU]|Aa|Oo|Au)/ by /([ÄÖÜ]|Äu)/ -->
    <xsl:when test="matches($argument,'^([AOU]|Aa|Oo|Au)[^aou]*$')">
      <xsl:sequence select="replace($argument,'^([AOU]|Aa|Oo|Au)([^aou]*)$',
                                              '([ÄÖÜ]|Äu)$2')"/>
    </xsl:when>
    <!-- replace the last vowel matching /([aou]|aa|oo|au)/ by /([äöü]|äu)/ -->
    <xsl:when test="matches($argument,'([aou]|aa|oo|au)[^aou]*$')">
      <xsl:sequence select="replace($argument,'^(.*?)([aou]|aa|oo|au)([^aou]*)$',
                                              '$1([äöü]|äu)$3')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$argument"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return the umlaut variant of $argument, if any -->
<!-- Caveat: "e" is considered as a full vowel.
     Therefore make sure that $argument contains no schwa endings. -->
<xsl:function name="n:umlaut">
  <xsl:param name="argument"/>
  <xsl:choose>
    <!-- replace the last vowel matching /([AOU]|Aa|Oo|Au)/ by "Ä", "Ö", "Ü", or "Äu" -->
    <xsl:when test="matches($argument,'^([AOU]||Aa|Oo|Au)[^aeiouäöü]*$')">
      <xsl:variable name="vowel"
                    select="replace($argument,'^([AOU]||Aa|Oo|Au)[^aeiouäöü]*$',
                                              '$1')"/>
      <xsl:choose>
        <xsl:when test="$vowel='A'">
          <xsl:sequence select="replace($argument,'^A([^aeiouäöü]*)$',
                                                  'Ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='O'">
          <xsl:sequence select="replace($argument,'^O([^aeiouäöü]*)$',
                                                  'Ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='U'">
          <xsl:sequence select="replace($argument,'^U([^aeiouäöü]*)$',
                                                  'Ü$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Aa'">
          <xsl:sequence select="replace($argument,'^Aa([^aeiouäöü]*)$',
                                                  'Ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Oo'">
          <xsl:sequence select="replace($argument,'^Oo([^aeiouäöü]*)$',
                                                  'Ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Au'">
          <xsl:sequence select="replace($argument,'^Au([^aeiouäöü]*)$',
                                                  'Äu$1')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <!-- replace the last vowel matching /([aou]|aa|oo|au)/ by "ä", "ö", "ü", or "äu" -->
    <xsl:when test="matches($argument,'([aou]|aa|oo|au)[^aeiouäöü]*$')">
      <xsl:variable name="vowel"
                    select="replace($argument,'^.*?([aou]|aa|oo|au)[^aeiouäöü]*$',
                                              '$1')"/>
      <xsl:choose>
        <xsl:when test="$vowel='a'">
          <xsl:sequence select="replace($argument,'^(.*)a([^aeiouäöü]*)$',
                                                  '$1ä$2')"/>
        </xsl:when>
        <xsl:when test="$vowel='o'">
          <xsl:sequence select="replace($argument,'^(.*)o([^aeiouäöü]*)$',
                                                  '$1ö$2')"/>
        </xsl:when>
        <xsl:when test="$vowel='u'">
          <xsl:sequence select="replace($argument,'^(.*)u([^aeiouäöü]*)$',
                                                  '$1ü$2')"/>
        </xsl:when>
        <xsl:when test="$vowel='aa'">
          <xsl:sequence select="replace($argument,'^(.*)aa([^aeiouäöü]*)$',
                                                  '$1ä$2')"/>
        </xsl:when>
        <xsl:when test="$vowel='oo'">
          <xsl:sequence select="replace($argument,'^(.*)oo([^aeiouäöü]*)$',
                                                  '$1ö$2')"/>
        </xsl:when>
        <xsl:when test="$vowel='au'">
          <xsl:sequence select="replace($argument,'^(.*)au([^aeiouäöü]*)$',
                                                  '$1äu$2')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$argument"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return the pair of $argument1 as input and $argument2 as output -->
<xsl:function name="n:pair">
  <xsl:param name="argument1"/>
  <xsl:param name="argument2"/>
  <xsl:variable name="value">
    <xsl:if test="string-length($argument1)&gt;0 or
                  string-length($argument2)&gt;0">
      <xsl:variable name="substring1"
                    select="substring($argument1,1,1)"/>
      <xsl:variable name="substring2"
                    select="substring($argument2,1,1)"/>
      <xsl:variable name="string1">
        <xsl:choose>
          <xsl:when test="string-length($substring1)=0">
            <xsl:text>&lt;&gt;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$substring1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="string2">
        <xsl:choose>
          <xsl:when test="string-length($substring2)=0">
            <xsl:text>&lt;&gt;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$substring2"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$string1=$string2">
          <xsl:value-of select="$string1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($string1,':',$string2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="n:pair(substring($argument1,2),
                                   substring($argument2,2))"/>
    </xsl:if>
  </xsl:variable>
  <xsl:sequence select="$value"/>
</xsl:function>

<!-- output $value, if any;
     else warn about missing value of $type for $lemma -->
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
</xsl:stylesheet>
