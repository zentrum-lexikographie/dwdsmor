<?xml version="1.0" encoding="utf-8"?>
<!-- forms.xsl -->
<!-- Version 9.0 -->
<!-- Andreas Nolda 2026-03-13 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- extract inflection markers from nominal form specification, if any;
     else return the form itself -->
<xsl:template name="get-nominal-marker">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- empty forms -->
    <xsl:when test="string-length($form)=0"/>
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
    <!-- empty forms -->
    <xsl:when test="string-length($form)=0"/>
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

<!-- stems of masculine adjectival words -->
<xsl:template name="masculine-stem">
  <xsl:param name="lemma"/>
  <xsl:value-of select="replace($lemma,'er$','')"/>
</xsl:template>

<!-- stems of feminine adjectival words -->
<xsl:template name="feminine-stem">
  <xsl:param name="lemma"/>
  <xsl:value-of select="replace($lemma,'i?e$','')"/>
</xsl:template>

<!-- base stems of verbs -->
<xsl:template name="verb-stem">
  <xsl:param name="lemma"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- lemmas ending in consonant + "een" or "ien" -->
    <xsl:when test="matches($lemma,'[^aeiouäöü][ei]en$')">
      <xsl:value-of select="replace($lemma,'n$','')"/>
    </xsl:when>
    <!-- lemmas borrowed from English with stem-final "e" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations)">
      <xsl:value-of select="replace($lemma,'n$','')"/>
    </xsl:when>
    <!-- other lemmas -->
    <xsl:otherwise>
      <xsl:value-of select="replace($lemma,'e?n$','')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- present stems -->
<xsl:template name="present-stem">
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- forms ending in consonant + "eet" or "iet" -->
    <xsl:when test="matches($form,'[^aeiouäöü][ei]et$')">
      <xsl:value-of select="replace($form,'t$','')"/>
    </xsl:when>
    <!-- forms of verbs borrowed from English with stem-final "e" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations)">
      <xsl:value-of select="replace($form,'t$','')"/>
    </xsl:when>
    <!-- forms ending in "tt" -->
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
  <xsl:param name="lemma"/>
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- weak forms ending in consonant + "eete" or "iete" -->
    <xsl:when test="matches($form,'[^aeiouäöü][ei]ete$')">
      <xsl:value-of select="replace($form,'te$','')"/>
    </xsl:when>
    <!-- forms of verbs borrowed from English with stem-final "e" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations)">
      <xsl:value-of select="replace($form,'te$','')"/>
    </xsl:when>
    <!-- other weak forms -->
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
  <xsl:param name="pronunciations"/>
  <xsl:choose>
    <!-- weak forms with "ge-" prefix ending in consonant + "eet" or "iet" -->
    <xsl:when test="matches($form,'^ge.*[^aeiouäöü][ei]et$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+)t$','$1')"/>
    </xsl:when>
    <!-- weak forms without "ge-" prefix ending in consonant + "eet" or "iet" -->
    <xsl:when test="matches($form,'^.*[^aeiouäöü][ei]et$')">
      <xsl:value-of select="replace($form,'t$','')"/>
    </xsl:when>
    <!-- weak forms lemmas borrowed from English with stem-final "e"
         with "ge-" prefix ending in "et" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations) and
                    matches($form,'^ge.+et$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+)t$','$1')"/>
    </xsl:when>
    <!-- weak forms lemmas borrowed from English with stem-final "e"
         without "ge-" prefix ending in "t" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations) and
                    matches($form,'^.+et$')">
      <xsl:value-of select="replace($form,'t$','')"/>
    </xsl:when>
    <!-- weak forms lemmas borrowed from English with stem-final "e"
         with "ge-" prefix ending in "ed" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations) and
                    matches($form,'^ge.+ed$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+)d$','$1')"/>
    </xsl:when>
    <!-- weak forms lemmas borrowed from English with stem-final "e"
         without "ge-" prefix ending in "ed" -->
    <xsl:when test="n:is-verb-borrowed-from-english-with-stem-final-e($lemma,$pronunciations) and
                    matches($form,'^.+ed$')">
      <xsl:value-of select="replace($form,'d$','')"/>
    </xsl:when>
    <!-- weak forms with "ge-" prefix ending in "ed"  -->
    <xsl:when test="matches($form,'^ge.+ed$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+)ed$','$1')"/>
    </xsl:when>
    <!-- weak forms without "ge-" prefix ending in "ed" -->
    <xsl:when test="matches($form,'^.+ed$')">
      <xsl:value-of select="replace($form,'ed$','')"/>
    </xsl:when>
    <!-- other weak forms with "ge-" prefix -->
    <xsl:when test="matches($form,'^ge.+?e?t$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+?)e?t$','$1')"/>
    </xsl:when>
    <!-- other weak forms without "ge-" prefix -->
    <xsl:when test="matches($form,'^.+?e?t$')">
      <xsl:value-of select="replace($form,'e?t$','')"/>
    </xsl:when>
    <!-- strong forms with "ge-" prefix ending in consonnant + "ien" -->
    <xsl:when test="matches($form,'^ge.*[^aeiouäöü]ien$') and
                    not(matches($form,concat('^',substring($lemma,1,3))))">
      <xsl:value-of select="replace($form,'^ge(.+)n$','$1')"/>
    </xsl:when>
    <!-- strong forms without "ge-" prefix ending in consonnant + "ien" -->
    <xsl:when test="matches($form,'^.*[^aeiouäöü]ien')">
      <xsl:value-of select="replace($form,'n$','')"/>
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
  <xsl:param name="form"/>
  <xsl:param name="lemma"/>
  <xsl:param name="pronunciations"/>
  <xsl:variable name="participle-stem">
    <xsl:call-template name="participle-stem">
      <xsl:with-param name="form"
                      select="$form"/>
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="pronunciations"
                      select="$pronunciations"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="matches($form,concat('^ge',$participle-stem,'(e?[nt]|e?d)$'))">
    <xsl:text>&lt;ge&gt;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- return a segmented version of lemma if it is a back-formed verb -->
<xsl:function name="n:segment-verb-if-backformed">
  <xsl:param name="participle-stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                    matches($lemma,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
      <xsl:sequence select="replace($lemma,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return a segmented version of non-participle stem if its lemma is a back-formed verb -->
<xsl:function name="n:segment-stem-if-backformed">
  <xsl:param name="stem"/>
  <xsl:param name="participle-stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                    matches($lemma,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
      <xsl:sequence select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$stem"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return a segmented version of participle stem if its lemma is a back-formed verb -->
<xsl:function name="n:segment-participle-stem-if-backformed">
  <xsl:param name="participle-stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                    matches($lemma,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
      <xsl:sequence select="replace($participle-stem,'^(.+)(ge)(.+)$','$1&lt;CB&gt;$2&lt;PB&gt;$3')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$participle-stem"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return true if stem is a compounding stem of lemma -->
<xsl:function name="n:is-comp-stem" as="xs:boolean">
  <xsl:param name="stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- unchanged stems -->
    <xsl:when test="$stem=$lemma">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re($lemma),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems with "-e" suffix -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re($lemma),'e$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-e" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'e$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-ien" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'ien$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-ier" + "-en" suffixes -->
    <xsl:when test="matches($lemma,concat('^',$stem,'ieren$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with geminate "n" and "-en" suffix -->
    <xsl:when test="matches($lemma,'n$') and
                    matches($stem,concat('^',$lemma,'nen$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-nen" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'nen$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-(e)n" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'e?n$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems with an "-er" suffix -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re($lemma),'er$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-er" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'er$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-(e)ns" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'e?ns$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-(e)s" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'e?s$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-e" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'e$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-(e)n" suffix and with "rück-" substituted for "zurück-" -->
    <xsl:when test="matches($lemma,'^zurück') and
                    matches($lemma,concat('^zu',$stem,'e?n$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-(e)n" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'e?n$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-s" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'s$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-s" substituted for "-e" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'e$','s'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-en" substituted for "-nen" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'nen$','en'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-s" substituted for "-en" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'en$','s'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-en" substituted for "-a" or "-o" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'[ao]$','en'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-a" substituted for "-um" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'um$','a'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-en" substituted for "-um" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'um$','en'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-en" substituted for "-os" or "-us" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'[ou]s$','en'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without geminate "b", "p", "d", "t", "k", "g", "m", or "n" and "-en" suffix -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'([bpdtkgmn])\1en$','$1'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- "-sprich" substituted for "-sprechen" -->
    <xsl:when test="matches($lemma,'sprechen$') and
                    matches($stem,concat('^',replace($lemma,'sprechen$','sprich'),'$'))">
      <!-- stem is a compounding stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- ... -->
    <xsl:otherwise>
      <!-- stem is not a compounding stem of lemma -->
      <xsl:sequence select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- return true if stem is a derivation stem of lemma -->
<xsl:function name="n:is-der-stem" as="xs:boolean">
  <xsl:param name="stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <!-- unchanged stems -->
    <xsl:when test="$stem=$lemma">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re($lemma),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems with "-e" suffix -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re($lemma),'e$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-e" suffix -->
    <xsl:when test="matches($stem,concat('^',$lemma,'e$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems without "-e" suffix -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re(replace($lemma,'e$','')),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-e" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'e$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-n" substituted for "-e" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'e$','n'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-en" substituted for "-nen" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'nen$','en'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems with "-l" substituted for "-el" or "-eln" -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re(replace($lemma,'eln?$','l')),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-l" substituted for "-el" or "-eln" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'eln?$','l'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems with "-e" substituted for "-el" -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re(replace($lemma,'el$','e')),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems without "-el" suffix -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re(replace($lemma,'el$','')),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-ien" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'ien$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-ern" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'ern$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-r" substituted for "-ern" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'ern$','r'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-ier" + "-en" suffixes -->
    <xsl:when test="matches($lemma,concat('^',$stem,'ieren$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems with "-en" substituted for "-n" -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re(replace($lemma,'en$','n')),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- umlauted stems without "-(e)n" suffix -->
    <xsl:when test="matches($stem,concat('^',n:umlaut-re(replace($lemma,'e?n$','')),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-(e)n" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'e?n$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems without "-er" suffix -->
    <xsl:when test="matches($lemma,concat('^',$stem,'er$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "dn", "fn", and "gn" substituted for "den", "fen", and "gen", respectively -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'([dfg])en$','$1n'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with geminate "b", "p", "d", "t", "k", "g", "m", or "n" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'([bpdtkgmn])$','$1$1'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- stems with "-eur" substituted for "-euer" -->
    <xsl:when test="matches($stem,concat('^',replace($lemma,'euer$','eur'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- "-säng" substituted for "-singen" -->
    <xsl:when test="matches($lemma,'singen$') and
                    matches($stem,concat('^',replace($lemma,'singen$','säng'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- "ein" substituted for "eine" -->
    <xsl:when test="$lemma='eine' and
                    matches($lemma,concat('^',$stem,'e$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- "sech" substituted for "sechs" -->
    <xsl:when test="$lemma='sechs' and
                    matches($lemma,concat('^',$stem,'s$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- "zwan" substituted for "zwei" -->
    <xsl:when test="$lemma='zwei' and
                    matches($stem,concat('^',replace($lemma,'ei$','an'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- "drit" substituted for "drei" -->
    <xsl:when test="$lemma='drei' and
                    matches($stem,concat('^',replace($lemma,'ei$','it'),'$'))">
      <!-- stem is a derivation stem of lemma -->
      <xsl:sequence select="true()"/>
    </xsl:when>
    <!-- ... -->
    <xsl:otherwise>
      <!-- stem is not a derivation stem of lemma -->
      <xsl:sequence select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

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
          <xsl:with-param name="stem"
                          select="replace($lemma,concat('-',$lemma2,'$'),'','i')"/>
          <xsl:with-param name="lemma"
                          select="$lemma1"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other spellings -->
      <xsl:otherwise>
        <xsl:call-template name="set-comp-stem-case">
          <xsl:with-param name="stem"
                          select="replace($lemma,concat($lemma2,'$'),'','i')"/>
          <xsl:with-param name="lemma"
                          select="$lemma1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- derivation stems -->
<xsl:template name="der-stem">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma1"/>
  <xsl:param name="lemma2"/><!-- suffix lemma -->
  <xsl:if test="matches($lemma,concat('^.*[^-]',$lemma2,'$'),'i')">
    <xsl:call-template name="set-der-stem-case">
      <xsl:with-param name="stem"
                      select="replace($lemma,concat($lemma2,'$'),'','i')"/>
      <xsl:with-param name="lemma"
                      select="$lemma1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- adjust case of compounding stem as required -->
<xsl:template name="set-comp-stem-case">
  <xsl:param name="stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="matches($lemma,'^\p{Ll}') and
                    matches($stem,'^\p{Lu}')">
      <xsl:value-of select="lower-case($stem)"/>
    </xsl:when>
    <xsl:when test="matches($lemma,'^\p{Lu}') and
                    matches($stem,'^\p{Ll}')">
      <xsl:value-of select="upper-case(substring($stem,1,1))"/>
      <xsl:value-of select="substring($stem,2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$stem"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- adjust case of derivation stem as required -->
<xsl:template name="set-der-stem-case">
  <xsl:param name="stem"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="matches($lemma,'^\p{Ll}') and
                    matches($stem,'^\p{Lu}')">
      <xsl:value-of select="lower-case($stem)"/>
    </xsl:when>
    <xsl:when test="matches($lemma,'^\p{Lu}') and
                    matches($stem,'^\p{Ll}')">
      <xsl:value-of select="upper-case(substring($stem,1,1))"/>
      <xsl:value-of select="substring($stem,2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$stem"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
