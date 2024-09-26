<?xml version="1.0" encoding="utf-8"?>
<!-- strings.xsl -->
<!-- Version 7.5 -->
<!-- Andreas Nolda 2024-09-26 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:n="http://andreas.nolda.org/ns/lib"
                exclude-result-prefixes="xs">

<!-- return true if $pronunciations have a final schwa-syllable -->
<xsl:function name="n:has-final-schwa-syllable" as="xs:boolean">
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- all $pronunciations end in /ə/ plus optional /l/, /n/, /r/, /rl/, or /rn/ -->
    <xsl:when test="every $p in $pronunciations satisfies matches($p,'(ə|ɐ|əɐ&#x32F;)[ln]?$')">
      <!-- $pronunciations have a final schwa-syllable -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- all $pronunciations end in syllabic /l/ or /n/ -->
    <xsl:when test="every $p in $pronunciations satisfies matches($p,'[^aeɛiɪoɔuʊøœyʏəɐ&#x32F;&#x2D0;][ln]&#x329;?$')">
      <!-- $pronunciations have a final schwa-syllable -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- all $pronunciations end in /ʒiːm/ -->
    <xsl:when test="every $p in $pronunciations satisfies matches($p,'[aeɛiɪoɔuʊøœyʏ].*ʒi&#x2D0;m$')">
      <!-- $pronunciations have a (latent) final schwa-syllable
           (unpronounced in the nominative singular) -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- all $pronunciations end in /viːs/ -->
    <xsl:when test="every $p in $pronunciations satisfies matches($p,'[aeɛiɪoɔuʊøœyʏ].*vi&#x2D0;s$')">
      <!-- $pronunciations have a (latent) final schwa-syllable
           (unpronounced in the nominative singular) -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- $pronunciations do not have a final schwa-syllable -->
      <xsl:sequence select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return true if $string is a noun with a final schwa-syllable,
     which can be suffixed with reduced dative plural "-n" -->
<xsl:function name="n:is-noun-with-final-schwa-syllable" as="xs:boolean">
  <xsl:param name="string"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- use $pronunciations if non-empty -->
    <xsl:when test="count($pronunciations)&gt;0">
      <xsl:value-of select="n:has-final-schwa-syllable($pronunciations)"/>
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
        <!-- $string ends in "e" plus optional "r" and/or "l" -->
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

<!-- return true if $string is an adjective with a final schwa-syllable,
     which can be reduced when suffixed with "-e", "-em", "-en", "-er", or "-es"
     or suffixed with reduced "-m" or "-n" -->
<xsl:function name="n:is-adjective-with-final-schwa-syllable" as="xs:boolean">
  <xsl:param name="string"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- use $pronunciations if non-empty -->
    <xsl:when test="count($pronunciations)&gt;0">
      <xsl:value-of select="n:has-final-schwa-syllable($pronunciations)"/>
    </xsl:when>
    <!-- else fall back to $string -->
    <xsl:otherwise>
      <xsl:choose>
        <!-- $string ends in "ee" plus optional "l", "n", or "r" -->
        <xsl:when test="matches($string,'ee[lnr]$')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "ie" plus optional "l", "n", or "r" -->
        <xsl:when test="matches($string,'ie[lnr]$')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "fidel" -->
        <xsl:when test="ends-with($string,'fidel')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "llel" -->
        <xsl:when test="ends-with($string,'llel')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "eagen" -->
        <xsl:when test="ends-with($string,'eagen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "llagen" -->
        <xsl:when test="ends-with($string,'llagen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "eigen" -->
        <xsl:when test="ends-with($string,'eigen')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends in "igen" -->
        <xsl:when test="ends-with($string,'igen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "erlogen" or "verlogen" -->
        <xsl:when test="matches($string,'v?erlogen$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends in "erwogen" or "gewogen" -->
        <xsl:when test="matches($string,'(er|ge)wogen$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends in "bezogen", "erzogen", "gezogen", or "umzogen" -->
        <xsl:when test="matches($string,'(be|er|ge|um)zogen$')">
          <!-- $string has a final schwa-syllable -->
          <xsl:sequence select="true()"/>
        </xsl:when>
        <!-- $string ends in "ogen" -->
        <xsl:when test="ends-with($string,'ogen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "llergen" -->
        <xsl:when test="ends-with($string,'llergen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "sgen" -->
        <xsl:when test="ends-with($string,'sgen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "ygen" -->
        <xsl:when test="ends-with($string,'ygen')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "seren" -->
        <xsl:when test="ends-with($string,'seren')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "phren" -->
        <xsl:when test="ends-with($string,'phren')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "thren" -->
        <xsl:when test="ends-with($string,'thren')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "then" -->
        <xsl:when test="ends-with($string,'then')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "amer" -->
        <xsl:when test="ends-with($string,'amer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "emer" -->
        <xsl:when test="ends-with($string,'emer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "imer" -->
        <xsl:when test="ends-with($string,'imer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "omer" -->
        <xsl:when test="ends-with($string,'omer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "ymer" -->
        <xsl:when test="ends-with($string,'ymer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "pher" -->
        <xsl:when test="ends-with($string,'pher')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "quer" -->
        <xsl:when test="ends-with($string,'quer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "schwer" -->
        <xsl:when test="ends-with($string,'schwer')">
          <!-- $string does not have a final schwa-syllable -->
          <xsl:sequence select="false()"/>
        </xsl:when>
        <!-- $string ends in "e" plus optional "l", "n", or "r" -->
        <xsl:when test="matches($string,'[aeiouäöüy][^aeiouäöü]*e[lnr]?$')">
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
     an umlautable vowel matching /(au|aa|oo|[aou])/. The regex returned
     by this function also matches forms with an umlaut preceding vowels
     not matching /(au|aa|oo|[aou])/. In particular, those vowels include
     "e", which cannot be excluded here since it may represent not only a
     full vowel, but also a schwa that can indeed follow the vowel
     affected by morphological umlaut. This 'overmatching', however, is
     harmless for the intended use case, since the regex is only tested
     against forms of the same paradigm, where such cases do not arise. -->
<xsl:function name="n:umlaut-re">
  <xsl:param name="string"/>
  <xsl:choose>
    <!-- replace the last vowel matching /(Au|Aa|Oo|[AOU])/ with /(Äu|[ÄÖÜ])/ -->
    <xsl:when test="matches($string,'(Au|Aa|Oo|[AOU])[^aouäöü-]*$')">
      <xsl:sequence select="replace($string,'(Au|Aa|Oo|[AOU])([^aouäöü-]*)$','(Äu|[ÄÖÜ])$2')"/>
    </xsl:when>
    <!-- replace the last vowel matching /(au|aa|oo|[aou])/ with /(äu|[äöü])/ -->
    <xsl:when test="matches($string,'(au|aa|oo|[aou])[^aouäöü-]*$')">
      <xsl:sequence select="replace($string,'(au|aa|oo|[aou])([^aouäöü-]*)$','(äu|[äöü])$2')"/>
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
    <!-- replace the last vowel matching /(Au|Aa|Oo|[AOU])/ with "Ä", "Ö", "Ü", or "Äu" -->
    <xsl:when test="matches($string,'^(Au|Aa|Oo|[AOU])[^aeiouäöü]*$')">
      <xsl:variable name="vowel"
                    select="replace($string,'^(Au|Aa|Oo|[AOU])[^aeiouäöü]*$','$1')"/>
      <xsl:choose>
        <xsl:when test="$vowel='Au'">
          <xsl:sequence select="replace($string,'^Au([^aeiouäöü]*)$','Äu$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Aa'">
          <xsl:sequence select="replace($string,'^Aa([^aeiouäöü]*)$','Ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='Oo'">
          <xsl:sequence select="replace($string,'^Oo([^aeiouäöü]*)$','Ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='A'">
          <xsl:sequence select="replace($string,'^A([^aeiouäöü]*)$','Ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='O'">
          <xsl:sequence select="replace($string,'^O([^aeiouäöü]*)$','Ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='U'">
          <xsl:sequence select="replace($string,'^U([^aeiouäöü]*)$','Ü$1')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <!-- replace the last vowel matching /(au|aa|oo|[aou])/ with "ä", "ö", "ü", or "äu" -->
    <xsl:when test="matches($string,'(au|aa|oo|[aou])[^aeiouäöü]*$')">
      <xsl:variable name="vowel"
                    select="replace($string,'^.*?(au|aa|oo|[aou])[^aeiouäöü]*$','$1')"/>
      <xsl:choose>
        <xsl:when test="$vowel='au'">
          <xsl:sequence select="replace($string,'au([^aeiouäöü]*)$','äu$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='aa'">
          <xsl:sequence select="replace($string,'aa([^aeiouäöü]*)$','ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='oo'">
          <xsl:sequence select="replace($string,'oo([^aeiouäöü]*)$','ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='a'">
          <xsl:sequence select="replace($string,'a([^aeiouäöü]*)$','ä$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='o'">
          <xsl:sequence select="replace($string,'o([^aeiouäöü]*)$','ö$1')"/>
        </xsl:when>
        <xsl:when test="$vowel='u'">
          <xsl:sequence select="replace($string,'u([^aeiouäöü]*)$','ü$1')"/>
        </xsl:when>
      </xsl:choose>
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
    <xsl:choose>
      <xsl:when test="$string1=$string2">
        <xsl:value-of select="$string1"/>
      </xsl:when>
      <xsl:when test="string-length($string1)&gt;0 or
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
      </xsl:when>
    </xsl:choose>
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
            <xsl:text>&lt;SB&gt;</xsl:text>
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

<!-- return a segmented version of $string2 with $string1 as the last segment
     and the remainder of $string2 as the first segment -->
<xsl:function name="n:segment-from-end">
  <xsl:param name="string1"/>
  <xsl:param name="string2"/>
  <xsl:variable name="value">
    <xsl:if test="string-length($string1)&gt;0 or
                  string-length($string2)&gt;0">
      <xsl:choose>
        <xsl:when test="ends-with($string2,$string1)">
          <xsl:value-of select="substring($string2,1,string-length($string2) - string-length($string1))"/>
          <xsl:if test="string-length($string1)&lt;string-length($string2)">
            <xsl:text>&lt;SB&gt;</xsl:text>
          </xsl:if>
          <xsl:value-of select="$string1"/>
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
