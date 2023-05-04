<?xml version="1.0" encoding="utf-8"?>
<!-- strings.xsl -->
<!-- Version 5.1 -->
<!-- Andreas Nolda 2023-05-04 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:n="http://andreas.nolda.org/ns/lib"
                exclude-result-prefixes="xs">

<!-- return true if $string has a final schwa-syllable
     which can be suffixed with dative plural "-n" -->
<!-- $string has such a final schwa-syllable iff
     $string ends in schwa plus optional "r" and/or "l" or
     $string ends in syllabic "l". -->
<xsl:function name="n:has-final-schwa-syllable" as="xs:boolean">
  <xsl:param name="string"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- use $pronunciations if non-empty -->
    <xsl:when test="count($pronunciations)&gt;0">
      <xsl:choose>
        <!-- every $p in $pronunciations ends in schwa plus optional "r" and/or "l" -->
        <xsl:when test="every $p in $pronunciations satisfies matches($p,'(ə|ɐ|əɐ&#x32F;)l?$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- every $p in $pronunciations ends in syllabic "l" -->
        <xsl:when test="every $p in $pronunciations satisfies matches($p,'[^aeɛiɪoɔuʊøœyʏəɐ&#x32F;&#x2D0;]l&#x329;?$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- else fall back to $string -->
    <xsl:otherwise>
      <xsl:choose>
        <!-- $string is an uppercase acronym -->
        <xsl:when test="matches($string,'^\p{Lu}+$')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string is an uppercase acronym followed by "ler" -->
        <xsl:when test="matches($string,'^\p{Lu}+ler$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends with digits followed by "er" -->
        <xsl:when test="matches($string,'[0-9]er$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends in "ee" plus optional "r" and/or "l" -->
        <xsl:when test="matches($string,'ee(r|l|rl)?$')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in schwa plus optional "r" and/or "l" -->
        <xsl:when test="matches($string,'[AEIOUÄÖÜaeiouäöüy][^aeiouäöü]*e(r|l|rl)?$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends in syllabic "l" -->
        <xsl:when test="matches($string,'[AEIOUÄÖÜaeiouäöüy][^aeiouäöü]+l$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return a regex matching the "e"/"i"-alternation variant of $string, if any -->
<xsl:function name="n:e-i-alternation-re">
  <xsl:param name="string"/>
  <xsl:choose>
    <!-- replace the last vowel + "h" + consonant <C> matching /eäöh<C>/ with /ie?h?<C>+/ -->
    <xsl:when test="matches($string,'[eäö]h[^aeiouäöü]+$')">
      <xsl:sequence select="replace($string,'[eäö]h([^aeiouäöü])([^aeiouäöü]*)$','ie?h?$1+$2')"/>
    </xsl:when>
    <!-- replace the last vowel + consonant <C> matching /eäö<C>/ with /ie?<C>+/ -->
    <xsl:when test="matches($string,'[eäö][^aeiouäöü]+$')">
      <xsl:sequence select="replace($string,'[eäö]([^aeiouäöü])([^aeiouäöü]*)$','ie?$1+$2')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return a regex matching the umlaut variant of $string, if any -->
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
  <xsl:param name="string"/>
  <xsl:choose>
    <!-- replace the last vowel matching /([AOU]|Aa|Oo|Au)/ with /([ÄÖÜ]|Äu)/ -->
    <xsl:when test="matches($string,'^([AOU]|Aa|Oo|Au)[^aou]*$')">
      <xsl:sequence select="replace($string,'^([AOU]|Aa|Oo|Au)([^aou]*)$','([ÄÖÜ]|Äu)$2')"/>
    </xsl:when>
    <!-- replace the last vowel matching /([aou]|aa|oo|au)/ with /([äöü]|äu)/ -->
    <xsl:when test="matches($string,'([aou]|aa|oo|au)[^aou]*$')">
      <xsl:sequence select="replace($string,'([aou]|aa|oo|au)([^aou]*)$','([äöü]|äu)$2')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return the umlaut variant of $string, if any -->
<!-- Caveat: "e" is considered as a full vowel.
     Therefore make sure that $string contains no schwa endings. -->
<xsl:function name="n:umlaut">
  <xsl:param name="string"/>
  <xsl:choose>
    <!-- replace the last vowel matching /([AOU]|Aa|Oo|Au)/ with "Ä", "Ö", "Ü", or "Äu" -->
    <xsl:when test="matches($string,'^([AOU]||Aa|Oo|Au)[^aeiouäöü]*$')">
      <xsl:variable name="vowel"
                    select="replace($string,'^([AOU]||Aa|Oo|Au)[^aeiouäöü]*$','$1')"/>
      <xsl:choose>
        <xsl:when test="$vowel='A'">
          <xsl:sequence select="replace($string,'^A([^aeiouäöü]*)$','Ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='O'">
          <xsl:sequence select="replace($string,'^O([^aeiouäöü]*)$','Ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='U'">
          <xsl:sequence select="replace($string,'^U([^aeiouäöü]*)$','Ü$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Aa'">
          <xsl:sequence select="replace($string,'^Aa([^aeiouäöü]*)$','Ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Oo'">
          <xsl:sequence select="replace($string,'^Oo([^aeiouäöü]*)$','Ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Au'">
          <xsl:sequence select="replace($string,'^Au([^aeiouäöü]*)$','Äu$1')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <!-- replace the last vowel matching /([aou]|aa|oo|au)/ with "ä", "ö", "ü", or "äu" -->
    <xsl:when test="matches($string,'([aou]|aa|oo|au)[^aeiouäöü]*$')">
      <xsl:variable name="vowel"
                    select="replace($string,'^.*?([aou]|aa|oo|au)[^aeiouäöü]*$','$1')"/>
      <xsl:choose>
        <xsl:when test="$vowel='a'">
          <xsl:sequence select="replace($string,'a([^aeiouäöü]*)$','ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='o'">
          <xsl:sequence select="replace($string,'o([^aeiouäöü]*)$','ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='u'">
          <xsl:sequence select="replace($string,'u([^aeiouäöü]*)$','ü$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='aa'">
          <xsl:sequence select="replace($string,'aa([^aeiouäöü]*)$','ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='oo'">
          <xsl:sequence select="replace($string,'oo([^aeiouäöü]*)$','ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='au'">
          <xsl:sequence select="replace($string,'au([^aeiouäöü]*)$','äu$1')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return the "ß"/"ss"-alternation variant of $string, if any -->
<xsl:function name="n:sz-ss-alternation">
  <xsl:param name="string"/>
  <xsl:choose>
    <!-- replace final "ß" with "ss" -->
    <xsl:when test="matches($string,'ß$')">
      <xsl:sequence select="replace($string,'ß$','ss')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return the "ss"/"ß"-alternation variant of $string, if any -->
<xsl:function name="n:ss-sz-alternation">
  <xsl:param name="string"/>
  <xsl:choose>
    <!-- replace final "ss" with "ß" -->
    <xsl:when test="matches($string,'ss$')">
      <xsl:sequence select="replace($string,'ss$','ß')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return the pair of $string1 as input and $string2 as output -->
<xsl:function name="n:pair">
  <xsl:param name="string1"/>
  <xsl:param name="string2"/>
  <xsl:variable name="value">
    <xsl:if test="string-length($string1)&gt;0 or
                  string-length($string2)&gt;0">
      <xsl:variable name="substring1">
        <xsl:choose>
          <!-- a multi-character symbol in angle brackets -->
          <xsl:when test="matches($string1,'^&lt;.*&gt;')">
            <xsl:value-of select="replace($string1,'^(&lt;.*?&gt;).*$','$1')"/>
          </xsl:when>
          <!-- a character -->
          <xsl:otherwise>
            <xsl:value-of select="substring($string1,1,1)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="substring2">
        <xsl:choose>
          <!-- a multi-character symbol in angle brackets -->
          <xsl:when test="matches($string2,'^&lt;.*&gt;')">
            <xsl:value-of select="replace($string2,'^(&lt;.*?&gt;).*$','$1')"/>
          </xsl:when>
          <!-- a character -->
          <xsl:otherwise>
            <xsl:value-of select="substring($string2,1,1)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="escaped-substring1">
        <xsl:choose>
          <xsl:when test="string-length($substring1)=0">
            <xsl:text>&lt;&gt;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$substring1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="escaped-substring2">
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
        <xsl:when test="$escaped-substring1=$escaped-substring2">
          <xsl:value-of select="$escaped-substring1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($escaped-substring1,':',$escaped-substring2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="n:pair(substring-after($string1,$substring1),
                                   substring-after($string2,$substring2))"/>
    </xsl:if>
  </xsl:variable>
  <xsl:sequence select="$value"/>
</xsl:function>

<!-- return a segmented version of $string2 with $string1 as the first segment
     and the remainder of $string2 as the second segment -->
<xsl:function name="n:segment">
  <xsl:param name="string1"/>
  <xsl:param name="string2"/>
  <xsl:variable name="value">
    <xsl:if test="string-length($string1)&gt;0 or
                  string-length($string2)&gt;0">
      <xsl:choose>
        <xsl:when test="starts-with($string2,$string1)">
          <xsl:value-of select="$string1"/>
          <xsl:if test="string-length($string1)&lt;string-length($string2)">
            <xsl:text>&lt;FB&gt;</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring-after($string2,$string1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$string2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>
  <xsl:sequence select="$value"/>
</xsl:function>
</xsl:stylesheet>
