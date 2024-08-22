<?xml version="1.0" encoding="utf-8"?>
<!-- entries.xsl -->
<!-- Version 14.1 -->
<!-- Andreas Nolda 2024-08-22 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="categories.xsl"/>

<xsl:include href="forms.xsl"/>

<!-- lexical entries -->

<!-- stems -->
<xsl:template name="stem-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pos"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
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

<!-- composition stems  -->
<xsl:template name="comp-stem-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pos"/>
  <xsl:param name="etymology"/>
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
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:variable name="supported-suffs"
              as="item()*"
              select="'chen','e','er','lein'"/><!-- ... -->

<!-- derivation stems -->
<xsl:template name="der-stem-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suff"/>
  <xsl:param name="pos"/>
  <xsl:param name="etymology"/>
  <xsl:choose>
    <xsl:when test="$supported-suffs=$suff">
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
      <xsl:value-of select="$suff"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="$etymology"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:text>&#xA;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Warning: "</xsl:text>
        <xsl:value-of select="$lemma"/>
        <xsl:text>" has derivation stem for unsupported suffix "-</xsl:text>
        <xsl:value-of select="$suff"/>
        <xsl:text>".</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- verb stems -->
<xsl:template name="verb-stem-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="participle"/>
  <xsl:param name="particle"/>
  <xsl:param name="particle2"/>
  <xsl:param name="class"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="etymology"/>
  <xsl:variable name="segmented-lemma">
    <xsl:choose>
      <!-- lemmas ending in consonant + "ien" -->
      <xsl:when test="matches($lemma,'[^aeiouäöü]ien$')">
        <xsl:value-of select="replace($lemma,'(n)$','&lt;SB&gt;$1')"/>
      </xsl:when>
      <!-- other lemmas -->
      <xsl:otherwise>
        <xsl:value-of select="replace($lemma,'(e?n)$','&lt;SB&gt;$1')"/>
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

<!-- driver templates -->

<!-- adjectives -->
<xsl:template name="adjective-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="function"/>
  <xsl:param name="inflection"/>
  <xsl:param name="positive"/>
  <xsl:param name="comparative"/>
  <xsl:param name="superlative"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- abbreviated adjectives ("ff.") -->
      <xsl:when test="$abbreviation='yes'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADJ</xsl:with-param>
          <xsl:with-param name="class">AbbrAdj</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- predicative-only adjectives -->
      <xsl:when test="$function='nonattr'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADJ</xsl:with-param>
          <xsl:with-param name="class">AdjPosPred</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- uninflected adjectives -->
      <xsl:when test="$inflection='no'">
        <xsl:choose>
          <!-- attributive-only location adjectives -->
          <xsl:when test="matches($lemma,'^\p{Lu}.*er$')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos0AttrSubst</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other attributive-only uninflected adjectives -->
          <xsl:when test="$function='attr'">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos0Attr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other uninflected adjectives -->
          <xsl:otherwise>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($comparative,'er')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($comparative,'er$','')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjComp</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- inflected adjectives -->
      <xsl:otherwise>
        <xsl:variable name="positive-marker">
          <xsl:call-template name="get-nominal-marker">
            <xsl:with-param name="form"
                            select="$positive"/>
            <xsl:with-param name="lemma"
                            select="$lemma"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="comparative-marker">
          <xsl:call-template name="get-nominal-marker">
            <xsl:with-param name="form"
                            select="$comparative"/>
            <xsl:with-param name="lemma"
                            select="$lemma"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="superlative-marker">
          <xsl:call-template name="get-nominal-marker">
            <xsl:with-param name="form"
                            select="substring-after($superlative,'am ')"/>
            <xsl:with-param name="lemma"
                            select="$lemma"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <!-- attributive-only adjectives -->
          <xsl:when test="$function='attr'">
            <xsl:choose>
              <xsl:when test="ends-with($lemma,'er') and
                              n:is-adjective-with-final-schwa-syllable($lemma,$pronunciations)">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="pos">ADJ</xsl:with-param>
                  <xsl:with-param name="class">AdjPosAttr-er</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="pos">ADJ</xsl:with-param>
                  <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            <!-- As a matter of fact, there are no comparative forms. -->
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjSupAttr</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with a final schwa-syllable -->
          <xsl:when test="ends-with($lemma,'el') and
                          n:is-adjective-with-final-schwa-syllable($lemma,$pronunciations)">
            <xsl:choose>
              <xsl:when test="matches($comparative,concat('^',n:umlaut-re($positive),'r$'))">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="pos">ADJ</xsl:with-param>
                  <xsl:with-param name="class">Adj-el_$</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="pos">ADJ</xsl:with-param>
                  <xsl:with-param name="class">Adj-el_0</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="ends-with($lemma,'en') and
            n:is-adjective-with-final-schwa-syllable($lemma,$pronunciations)">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj-en_0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="ends-with($lemma,'er') and
                          n:is-adjective-with-final-schwa-syllable($lemma,$pronunciations)">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj-er_0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives with irregular positive forms -->
          <xsl:when test="string-length($positive)&gt;0 and
                          not(matches($positive-marker,'^&#x308;?-e$'))">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPosPred</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="stem"
                              select="replace($positive,'e$','')"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($comparative,'er')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($comparative,'er$','')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjComp</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with the uninflected comparative form "mehr" or "weniger" -->
          <xsl:when test="$comparative='mehr' or
                          $comparative='weniger'">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos0-viel</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="stem"
                              select="$comparative"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp0-mehr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with irregular comparative forms -->
          <xsl:when test="ends-with($comparative,'er') and
                          not(matches($comparative-marker,'^&#x308;?-'))">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="stem"
                              select="replace($comparative,'er$','')"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with irregular superlative forms -->
          <xsl:when test="ends-with($superlative,'sten') and
                          not(matches($superlative-marker,'^&#x308;?-'))">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($comparative,'er')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($comparative,'er$','')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjComp</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="stem"
                              select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjSup</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives with word-internal comparative and superlative markers -->
          <xsl:when test="string-length($comparative)&gt;0 and
                          string-length($superlative)&gt;0 and
                          not(matches($comparative-marker,'^&#x308;?-')) and
                          not(matches($superlative-marker,'^&#x308;?-'))">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$comparative"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="replace($superlative,'^(am )?(.+)$','$2')"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives superlative forms only: -->
          <xsl:when test="matches($lemma,'^aller.+st$') and
                          $superlative=concat('am ',$lemma,'en')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="stem"
                              select="replace($superlative,'^am (.*[aeiouäöü].*)sten$','$1')"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjSup-aller</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives without comparative forms: -->
          <xsl:when test="string-length($comparative)=0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives without superlative forms: -->
          <xsl:when test="string-length($superlative)=0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="abbreviation"
                              select="$abbreviation"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($comparative,'er')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($comparative,'er$','')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjComp</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- other adjectives -->
          <xsl:otherwise>
            <xsl:variable name="class">
              <xsl:call-template name="adjective-class">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="superlative"
                                select="$superlative"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($class)&gt;0">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class"
                                select="$class"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- compounding stems of adjectives -->
<xsl:template name="adjective-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">ADJ</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of adjectives -->
<xsl:template name="adjective-der-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suffs"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:for-each select="$suffs">
        <xsl:call-template name="der-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="suff"
                          select="."/>
          <xsl:with-param name="pos">ADJ</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- adverbs -->
<xsl:template name="adverb-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="comparative"/>
  <xsl:param name="superlative"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- adverbs with the unsuffixed comparative form "mehr" -->
      <xsl:when test="$comparative='mehr'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$comparative"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">AdvComp0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:if test="ends-with($superlative,'sten')">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="stem"
                            select="replace($superlative,'^am (.+)sten$','$1')"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">ADV</xsl:with-param>
            <xsl:with-param name="class">AdvSup</xsl:with-param>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- adverbs with other comparative forms -->
      <xsl:when test="ends-with($comparative,'er')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($comparative,'er$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">AdvComp</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:if test="ends-with($superlative,'sten')">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="stem"
                            select="replace($superlative,'^am (.+)sten$','$1')"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">ADV</xsl:with-param>
            <xsl:with-param name="class">AdvSup</xsl:with-param>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- other adverbs -->
      <xsl:otherwise>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- articles -->
<xsl:template name="article-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- "die" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='die'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtDef</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='der'"/>
      <xsl:when test="$lemma='das'"/>
      <!-- "eine", "'ne" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='eine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtIndef</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma">eine</xsl:with-param>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">’n</xsl:with-param>
          <xsl:with-param name="abbreviation">yes</xsl:with-param>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtIndef-n</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='ein'"/>
      <!-- "keine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='keine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtNeg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='kein'"/>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- cardinals -->
<xsl:template name="cardinal-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- "eine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='eine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-ein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='ein'"/>
      <!-- "keine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='keine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-kein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='kein'"/>
      <!-- "zwei", "drei" -->
      <xsl:when test="$lemma='zwei' or
                      $lemma='drei'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-zwei</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "vier", "fünf", "sechs", "acht", "neun", "zehn", "elf", "zwölf" -->
      <xsl:when test="$lemma='vier' or
                      $lemma='fünf' or
                      $lemma='sechs' or
                      $lemma='acht' or
                      $lemma='neun' or
                      $lemma='zehn' or
                      $lemma='elf' or
                      $lemma='zwölf'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-vier</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sieben" -->
      <xsl:when test="$lemma='sieben'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-sieben</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- compounding stems of cardinals -->
<xsl:template name="cardinal-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of cardinals -->
<xsl:template name="cardinal-der-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suffs"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:for-each select="$suffs">
        <xsl:call-template name="der-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="suff"
                          select="."/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- ordinals -->
<xsl:template name="ordinal-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="stem-entry">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="lemma-index"
                      select="$lemma-index"/>
      <xsl:with-param name="paradigm-index"
                      select="$paradigm-index"/>
      <xsl:with-param name="stem"
                      select="$stem"/>
      <xsl:with-param name="abbreviation"
                      select="$abbreviation"/>
      <xsl:with-param name="pos">ORD</xsl:with-param>
      <xsl:with-param name="class">Ord</xsl:with-param>
      <xsl:with-param name="etymology"
                      select="$etymology"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- fractions -->
<xsl:template name="fraction-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:call-template name="stem-entry">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="lemma-index"
                      select="$lemma-index"/>
      <xsl:with-param name="paradigm-index"
                      select="$paradigm-index"/>
      <xsl:with-param name="abbreviation"
                      select="$abbreviation"/>
      <xsl:with-param name="pos">FRAC</xsl:with-param>
      <xsl:with-param name="class">Frac0</xsl:with-param>
      <xsl:with-param name="etymology"
                      select="$etymology"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- compounding stems of ordinals -->
<xsl:template name="ordinal-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">ORD</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of ordinals -->
<xsl:template name="ordinal-der-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suffs"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:for-each select="$suffs">
        <xsl:call-template name="der-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="suff"
                          select="."/>
          <xsl:with-param name="pos">ORD</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- compounding stems of fractions -->
<xsl:template name="fraction-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">FRAC</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- nouns -->
<xsl:template name="noun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:param name="diminutive"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="genitive-singular-marker">
      <xsl:call-template name="get-nominal-marker">
        <xsl:with-param name="form"
                        select="$genitive-singular"/>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="nominative-plural-marker">
      <xsl:call-template name="get-nominal-marker">
        <xsl:with-param name="form"
                        select="$nominative-plural"/>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- nouns with suppletive plural -->
      <!-- lemma: "Bau"
           nominative plural: "Bauten" -->
      <xsl:when test="$gender='mask.' and
                      $lemma='Bau' and
                      $nominative-plural-marker='-ten'">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="concat($lemma,'ten')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Pl_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: compound with "Bau"
           nominative plural: compound with "Bauten" -->
      <xsl:when test="$gender='mask.' and
                      ends-with($lemma,'bau') and
                      $nominative-plural-marker='-ten'">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="concat($lemma,'ten')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Pl_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: "Vieh"
           nominative plural: "Viecher" -->
      <xsl:when test="$gender='neutr.' and
                      $lemma='Vieh' and
                      $nominative-plural='Viecher'">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$nominative-plural"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: compound with "Vieh"
           nominative plural: compound with "Viecher" -->
      <xsl:when test="$gender='neutr.' and
                      ends-with($lemma,'vieh') and
                      $nominative-plural=replace($lemma,'vieh$','viecher')">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$nominative-plural"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: borrowed compound with "man"
           nominative plural: borrowed compound with "men" -->
      <xsl:when test="$gender='mask.' and
                      ends-with($lemma,'man') and
                      $nominative-plural=replace($lemma,'man$','men')">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$nominative-plural"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Pl_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: borrowed compound with "woman"
           nominative plural: borrowed compound with "women" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'woman') and
                      $nominative-plural=replace($lemma,'woman$','women')">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$nominative-plural"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NFem/Pl_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: borrowed compound of "singulare" or "plurale" with "tantum"
           nominative plural: borrowed compound of "singularia" or "pluralia" with "tantum" -->
      <xsl:when test="$gender='neutr.' and
                      ends-with($lemma,'etantum') and
                      $nominative-plural=replace($lemma,'etantum$','iatantum')">
        <xsl:call-template name="noun-entry-set">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="gender"
                          select="$gender"/>
          <xsl:with-param name="number">singular</xsl:with-param>
          <xsl:with-param name="genitive-singular"
                          select="$genitive-singular"/>
          <xsl:with-param name="diminutive"
                          select="$diminutive"/>
          <xsl:with-param name="pronunciations"
                          select="$pronunciations"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$nominative-plural"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut/Pl_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- nouns with extra-paradigmatic plural -->
      <!-- lemma: compound with "Mann"
           nominative plural: compound with "Leute" -->
      <xsl:when test="$gender='mask.' and
                      ends-with($lemma,'mann') and
                      $nominative-plural=replace($lemma,'mann$','leute')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$nominative-plural"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNoGend/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: compound with "Frau"
           nominative plural: compound with "Leute" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'frau') and
                      $nominative-plural=replace($lemma,'frau$','leute')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$nominative-plural"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNoGend/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- nouns with meta-markers -->
      <!-- genitive singular: "-(s)"
           nominative plural: "-(s)" -->
      <xsl:when test="$genitive-singular-marker='-(s)' and
                      $nominative-plural-marker='-(s)'">
        <xsl:variable name="class1">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular">-s</xsl:with-param>
            <xsl:with-param name="nominative-plural">-</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular">-</xsl:with-param>
            <xsl:with-param name="nominative-plural">-s</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- genitive singular: "-(s)" -->
      <xsl:when test="$genitive-singular-marker='-(s)'">
        <xsl:variable name="class1">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular">-s</xsl:with-param>
            <xsl:with-param name="nominative-plural"
                            select="$nominative-plural"/>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular">-</xsl:with-param>
            <xsl:with-param name="nominative-plural"
                            select="$nominative-plural"/>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- nominative plural: "-(s)" -->
      <xsl:when test="$nominative-plural-marker='-(s)'">
        <xsl:variable name="class1">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural">-s</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural">-</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- nominative plural: "-(e)s" -->
      <xsl:when test="$nominative-plural-marker='-(e)s'">
        <xsl:variable name="class1">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural">-es</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural">-s</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- nominative plural: "-e(n)" -->
      <xsl:when test="$nominative-plural-marker='-e(n)'">
        <xsl:variable name="class1">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural">-en</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural">-e</xsl:with-param>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- nominative plural: "-(n)" -->
      <xsl:when test="$nominative-plural-marker='-(n)'">
        <xsl:choose>
          <!-- nominalised adjectives -->
          <xsl:when test="$genitive-singular-marker='-n'">
            <xsl:variable name="class">
              <xsl:call-template name="noun-class">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="gender"
                                select="$gender"/>
                <xsl:with-param name="number"
                                select="$number"/>
                <xsl:with-param name="genitive-singular"
                                select="$genitive-singular"/>
                <xsl:with-param name="nominative-plural"
                                select="$nominative-plural"/>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($class)&gt;0">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="stem"
                                select="replace($lemma,'e$','')"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class"
                                select="$class"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- other nouns -->
          <xsl:otherwise>
            <xsl:variable name="class1">
              <xsl:call-template name="noun-class">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="gender"
                                select="$gender"/>
                <xsl:with-param name="number"
                                select="$number"/>
                <xsl:with-param name="genitive-singular"
                                select="$genitive-singular"/>
                <xsl:with-param name="nominative-plural">-n</xsl:with-param>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="class2">
              <xsl:call-template name="noun-class">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="gender"
                                select="$gender"/>
                <xsl:with-param name="number"
                                select="$number"/>
                <xsl:with-param name="genitive-singular"
                                select="$genitive-singular"/>
                <xsl:with-param name="nominative-plural">-</xsl:with-param>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($class1)&gt;0 and
                          string-length($class2)&gt;0">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class"
                                select="$class1"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class"
                                select="$class2"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- abbreviated nouns without markers -->
      <xsl:when test="string-length($genitive-singular-marker)=0 and
                      string-length($nominative-plural-marker)=0 and
                      $abbreviation='yes'">
        <xsl:choose>
          <!-- acronyms in uppercase letters or
               acronyms consisting of an uppercase consonant letter
               followed by lowercase consonant letters -->
          <xsl:when test="matches($lemma,'^\p{Lu}+$') or
                          matches($lemma,'^[\p{Lu}-[AEIOUÄÖÜ]][\p{Ll}-[aeiouäöü]]+$')">
            <xsl:choose>
              <!-- masculine acronyms ("PC", "Pkw") -->
              <xsl:when test="$gender='mask.'">
                <xsl:choose>
                  <xsl:when test="$number='singular'">
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NMasc/Sg_s</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NMasc/Sg_0</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NMasc_s_s</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NMasc_0_x</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- neuter acronyms ("WC") -->
              <xsl:when test="$gender='neutr.'">
                <xsl:choose>
                  <xsl:when test="$number='singular'">
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NNeut/Sg_s</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NNeut/Sg_0</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NNeut_s_s</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NNeut_0_x</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- feminine acronyms ("WG") -->
              <xsl:when test="$gender='fem.'">
                <xsl:choose>
                  <xsl:when test="$number='singular'">
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NFem/Sg_0</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NFem_0_s</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                      <xsl:with-param name="pos">NN</xsl:with-param>
                      <xsl:with-param name="class">NFem_0_x</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- pluralia-tantum acronyms -->
              <xsl:when test="$number='plural'">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                  <xsl:with-param name="pos">NN</xsl:with-param>
                  <xsl:with-param name="class">NNoGend/Pl_x</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <!-- other abbreviated nouns -->
          <xsl:otherwise>
            <xsl:choose>
              <!-- abbreviated masculine nouns ("Prof.", "km", "§") -->
              <xsl:when test="$gender='mask.'">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                  <xsl:with-param name="pos">NN</xsl:with-param>
                  <xsl:with-param name="class">AbbrNMasc</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- abbreviated neuter nouns ("Tel.", "kg", "°") -->
              <xsl:when test="$gender='neutr.'">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                  <xsl:with-param name="pos">NN</xsl:with-param>
                  <xsl:with-param name="class">AbbrNNeut</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- abbreviated feminine nouns ("Nr.", "min", "′") -->
              <xsl:when test="$gender='fem.'">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                  <xsl:with-param name="pos">NN</xsl:with-param>
                  <xsl:with-param name="class">AbbrNFem</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- abbreviated pluralia tantum ("Gebr.", "§§") -->
              <xsl:when test="$number='plural'">
                <xsl:call-template name="stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                  <xsl:with-param name="pos">NN</xsl:with-param>
                  <xsl:with-param name="class">AbbrNNoGend</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- special cases -->
      <!-- lemma: "Innere" -->
      <xsl:when test="$gender='neutr.' and
                      $lemma='Innere' and
                      $genitive-singular-marker='-n' and
                      $number='singular'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut-Inner</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: "Regime" (with unpronounced final "e")
           nominative plural: unmarked (with pronounced final schwa) -->
      <xsl:when test="$gender='neutr.' and
                      $lemma='Regime' and
                      $nominative-plural-marker='-'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut_s_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: compound with "Regime" (with unpronounced final "e")
           nominative plural: unmarked (with pronounced final schwa) -->
      <xsl:when test="$gender='neutr.' and
                      ends-with($lemma,'regime') and
                      $nominative-plural-marker='-'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut_s_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other nouns -->
      <xsl:otherwise>
        <xsl:variable name="class">
          <xsl:call-template name="noun-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural"
                            select="$nominative-plural"/>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NN</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- compounding stems of nouns -->
<xsl:template name="noun-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of nouns -->
<xsl:template name="noun-der-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suffs"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:for-each select="$suffs">
        <xsl:call-template name="der-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="suff"
                          select="."/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- names -->
<xsl:template name="name-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
  <xsl:param name="diminutive"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="genitive-singular-marker">
      <xsl:call-template name="get-nominal-marker">
        <xsl:with-param name="form"
                        select="$genitive-singular"/>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- proper names with meta-markers -->
      <!-- genitive singular: "-(s)" -->
      <xsl:when test="$genitive-singular-marker='-(s)'">
        <xsl:variable name="class1">
          <xsl:call-template name="name-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular">-s</xsl:with-param>
            <xsl:with-param name="nominative-plural"
                            select="$nominative-plural"/>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="name-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular">-</xsl:with-param>
            <xsl:with-param name="nominative-plural"
                            select="$nominative-plural"/>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NPROP</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NPROP</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- other proper names -->
      <xsl:otherwise>
        <xsl:variable name="class">
          <xsl:call-template name="name-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="gender"
                            select="$gender"/>
            <xsl:with-param name="number"
                            select="$number"/>
            <xsl:with-param name="genitive-singular"
                            select="$genitive-singular"/>
            <xsl:with-param name="nominative-plural"
                            select="$nominative-plural"/>
            <xsl:with-param name="diminutive"
                            select="$diminutive"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">NPROP</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- compounding stems of names -->
<xsl:template name="name-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">NPROP</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of names -->
<xsl:template name="name-der-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suffs"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:for-each select="$suffs">
        <xsl:call-template name="der-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="suff"
                          select="."/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- demonstrative pronouns -->
<xsl:template name="demonstrative-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- "diese", "ebendiese" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'diese')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem-dies</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ends-with($lemma,'dieser')"/>
      <xsl:when test="ends-with($lemma,'dieses')"/>
      <!-- "jene", "ebenjene" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'jene')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ends-with($lemma,'jener')"/>
      <xsl:when test="ends-with($lemma,'jenes')"/>
      <!-- "die", "ebendie" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'die')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">DemDef</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ends-with($lemma,'der')"/>
      <xsl:when test="ends-with($lemma,'das')"/>
      <!-- "solche", "ebensolche" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'solche')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem-solch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ends-with($lemma,'solcher')"/>
      <xsl:when test="ends-with($lemma,'solches')"/>
      <!-- "diejenige" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='diejenige'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','der$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-der+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','den$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-den+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','dem$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-dem+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','des$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-des+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','das$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-das+DemNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','dem$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-dem+DemNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','des$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-des+DemNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','die$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-die+DemFem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','der$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-der+DemFem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','die$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-die+DemNoGend</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','den$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-den+DemNoGend</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^die(jenig)e$','der$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-der+DemNoGend</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='derjenige'"/>
      <xsl:when test="$lemma='dasjenige'"/>
      <!-- "dieselbe", "dieselbige" "ebendieselbe", "höchstdieselbe" -->
      <xsl:when test="$gender='fem.' and
                      (ends-with($lemma,'dieselbe') or
                       $lemma='dieselbige')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','der$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-der+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','den$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-den+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','dem$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-dem+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','des$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-des+DemMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','das$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-das+DemNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','dem$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-dem+DemNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','des$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-des+DemNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','die$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-die+DemFem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','der$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-der+DemFem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','die$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-die+DemNoGend</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','den$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-den+DemNoGend</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'die(selb(ig)?)e$','der$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">ArtDef-der+DemNoGend</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ends-with($lemma,'derselbe') or
                      $lemma='derselbige'"/>
      <xsl:when test="ends-with($lemma,'dasselbe') or
                      $lemma='dasselbige'"/>
      <!-- "alldem", "alledem" -->
      <xsl:when test="$lemma='alldem' or
                      $lemma='alledem'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'em$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem-alldem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "dergleichen", "derlei" -->
      <xsl:when test="$lemma='dergleichen' or
                      $lemma='derlei'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "selbige" -->
  <!-- "selben" -->
  <!-- "selber", "selbst", "höchstselbst" -->
  <!-- "sone", "son" -->
</xsl:template>

<!-- indefinite pronouns -->
<xsl:template name="indefinite-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- "eine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='eine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-ein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='einer'"/>
      <xsl:when test="$lemma='eines'"/>
      <!-- "irgendeine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='irgendeine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-irgendein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='irgendeiner'"/>
      <xsl:when test="$lemma='irgendeines'"/>
      <!-- "keine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='keine'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-kein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='keiner'"/>
      <xsl:when test="$lemma='keines'"/>
      <!-- "welche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='welche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-welch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='welcher'"/>
      <xsl:when test="$lemma='welches'"/>
      <!-- "irgendwelche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='irgendwelche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-irgendwelch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='irgendwelcher'"/>
      <xsl:when test="$lemma='irgendwelches'"/>
      <!-- "einige" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='einige'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-einig</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='einiger'"/>
      <xsl:when test="$lemma='einiges'"/>
      <!-- "etliche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='etliche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-einig</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='etlicher'"/>
      <xsl:when test="$lemma='etliches'"/>
      <!-- "alle" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='alle'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-all</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='aller'"/>
      <xsl:when test="$lemma='alles'"/>
      <!-- "jede" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='jede' or
                       $lemma='jedwede')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-jed</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='jeder' or
                      $lemma='jedweder'"/>
      <xsl:when test="$lemma='jedes' or
                      $lemma='jedwedes'"/>
      <!-- "jegliche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='jegliche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-jeglich</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='jeglicher'"/>
      <xsl:when test="$lemma='jegliches'"/>
      <!-- "beide" -->
      <xsl:when test="$lemma='beide'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-beid</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "manche" -->
      <xsl:when test="$lemma='manche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-manch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "mehrere" -->
      <xsl:when test="$lemma='mehrere'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-mehrer</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sämtliche" -->
      <xsl:when test="$lemma='sämtliche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-saemtlich</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jedermann" -->
      <xsl:when test="$lemma='jedermann'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-jedermann</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jedefrau" -->
      <xsl:when test="$lemma='jedefrau'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-jedefrau</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'^jede(frau)$','jeder$1')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-jederfrau</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "man", "mensch" -->
      <xsl:when test="$lemma='man' or
                      $lemma='mensch'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-man</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "frau" -->
      <xsl:when test="$lemma='frau'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-frau</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "unsereiner" -->
      <xsl:when test="$lemma='unsereiner'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'er$','')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-unsereiner</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "unsereins" -->
      <xsl:when test="$lemma='unsereins'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-unsereins</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jemand", "irgendjemand" -->
      <xsl:when test="ends-with($lemma,'jemand')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "niemand" -->
      <xsl:when test="$lemma='niemand'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "etwas", "ebbes", "irgendetwas" -->
      <xsl:when test="ends-with($lemma,'etwas') or
                      $lemma='ebbes'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "was", "irgendwas", "sonstwas" -->
      <xsl:when test="ends-with($lemma,'was')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'was$','wes')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "wer", "irgendwer", "sonstwer" -->
      <xsl:when test="ends-with($lemma,'wer')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'wer$','wen')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'wer$','wem')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'wer$','wes')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "nichts", "nischt", "nix" -->
      <xsl:when test="$lemma='nichts' or
                      $lemma='nischt' or
                      $lemma='nix'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "bisschen" -->
      <xsl:when test="$lemma='bisschen'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "paar" -->
      <xsl:when test="$lemma='paar'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "genug" -->
      <xsl:when test="$lemma='genug'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "allerlei", "beiderlei" -->
      <xsl:when test="$lemma='allerlei' or
                      $lemma='beiderlei'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "aberhundert", "Aberhundert" -->
  <!-- "jederlei", "einerlei" -->
  <!-- "allesamt" -->
  <!-- "ebensoviel", "genausoviel", "geradesoviel", "gradesoviel", "soviel" -->
  <!-- "ebensowenig", "genausowenig", "sowenig", "blutwenig", "zuwenig" -->
  <!-- "männiglich" -->
  <!-- "meinesgleichen", "deinesgleichen", "seinesgleichen",
       "ihresgleichen", "unsersgleichen", "euresgleichen" -->
  <!-- "soundsovielte" -->
  <!-- "zigtausend" -->
</xsl:template>

<!-- interrogative pronouns -->
<xsl:template name="interrogative-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- "was" -->
      <xsl:when test="$lemma='was'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wes</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "wer" -->
      <xsl:when test="$lemma='wer'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wen</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wem</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wes</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "welche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='welche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">W-welch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='welcher'"/>
      <xsl:when test="$lemma='welches'"/>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "wieviele", "wievielte" -->
</xsl:template>

<!-- personal pronouns -->
<xsl:template name="personal-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- "du" -->
      <xsl:when test="$lemma='du'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">dich</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">dir</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">dein</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Du" -->
      <xsl:when test="$lemma='Du'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Dich</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Dir</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Dein</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "er" -->
      <xsl:when test="$gender='mask.' and
                      $lemma='er'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihn</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihm</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">sein</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "es", "'s" -->
      <xsl:when test="$gender='neutr.' and
                      $lemma='es'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma">es</xsl:with-param>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">’s</xsl:with-param>
          <xsl:with-param name="abbreviation">yes</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutNomSg-s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma">es</xsl:with-param>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">’s</xsl:with-param>
          <xsl:with-param name="abbreviation">yes</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutAccSg-s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihm</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">sein</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "ich" -->
      <xsl:when test="$lemma='ich'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1NomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">mich</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">mir</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">mein</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1GenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "ihr" -->
      <xsl:when test="$lemma='ihr'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">euch</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">euch</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">eu</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Ihr" -->
      <xsl:when test="$lemma='Ihr'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Euch</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Euch</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Eu</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sie" (singular) -->
      <xsl:when test="$gender='fem.' and
                      $lemma='sie'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihr</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihr</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sie" (plural) -->
      <xsl:when test="$lemma='sie'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendNomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendAccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihnen</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendDatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">ihr</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendGenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Sie" -->
      <xsl:when test="$lemma='Sie'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendNomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendAccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Ihnen</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendDatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Ihr</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendGenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template><!-- ? -->
      </xsl:when>
      <!-- "wir" -->
      <xsl:when test="$lemma='wir'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1NomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">uns</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1AccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">uns</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1DatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">uns</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1GenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "Dero", "Ihro" -->
</xsl:template>

<!-- reflexive pronouns -->
<xsl:template name="reflexive-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- "dich" -->
      <xsl:when test="$lemma='dich'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">dir</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Dich" -->
      <xsl:when test="$lemma='Dich'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">Dir</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "euch" -->
      <xsl:when test="$lemma='euch'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2Pl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Euch" -->
      <xsl:when test="$lemma='Euch'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2Pl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "mich" -->
      <xsl:when test="$lemma='mich'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl1AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">mir</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl1DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sich" -->
      <xsl:when test="$lemma='sich'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl3</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "uns" -->
      <xsl:when test="$lemma='uns'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl1Pl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- reciprocal pronouns -->
<xsl:template name="reciprocal-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:if test="$lemma='einander'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="lemma-index"
                        select="$lemma-index"/>
        <xsl:with-param name="paradigm-index"
                        select="$paradigm-index"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="class">PRecPl</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- possessive pronouns -->
<xsl:template name="possessive-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- abbreviated possessive pronouns ("Ew.") -->
      <xsl:when test="$abbreviation='yes'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">AbbrPoss</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "meine", "deine", "seine" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'eine')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="ends-with($lemma,'ein')"/>
      <!-- "ihre", "Ihre" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='ihre' or
                       $lemma='Ihre')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='ihr' or
                      $lemma='Ihr'"/>
      <!-- "unsere" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='unsere'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='unser'"/>
      <!-- "eure", "Eure" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='eure' or
                       $lemma='Eure')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'re$','er')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='euer' or
                      $lemma='Euer'"/>
      <!-- "meinige", "deinige", "seinige" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'einige')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss/Wk</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "ihrige", "Ihrige" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='ihrige' or
                       $lemma='Ihrige')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss/Wk</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "unsrige" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='unsrige'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'rige$','erig')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss/Wk-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "eurige", "Eurige" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='eurige' or
                       $lemma='Eurige')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="replace($lemma,'rige$','erig')"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss/Wk-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- relative pronouns -->
<xsl:template name="relative-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="stem">
      <xsl:call-template name="feminine-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- "die" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='die'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">Rel</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='der'"/>
      <xsl:when test="$lemma='das'"/>
      <!-- "was" -->
      <xsl:when test="$lemma='was'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wes</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "wer" -->
      <xsl:when test="$lemma='wer'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wen</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wem</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem">wes</xsl:with-param>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">RProMascGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "welche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='welche'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">Rel-welch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$lemma='welcher'"/>
      <xsl:when test="$lemma='welches'"/>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- verbs -->
<xsl:template name="verb-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="present"/>
  <xsl:param name="past"/>
  <xsl:param name="participle"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- abbreviated verbs ("vgl.") -->
      <xsl:when test="$abbreviation='yes'">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="pos">V</xsl:with-param>
          <xsl:with-param name="class">AbbrVImp</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="particle">
          <xsl:choose>
            <xsl:when test="count(tokenize($present,'&#x20;'))=3">
              <xsl:value-of select="substring-after(substring-after($present,' '),' ')"/>
            </xsl:when>
            <xsl:when test="count(tokenize($present,'&#x20;'))&lt;3">
              <xsl:value-of select="substring-after($present,' ')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="particle2"
                      select="substring-before(substring-after($present,' '),' ')"/>
        <xsl:variable name="lemma-without-particle"
                      select="replace($lemma,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
        <xsl:variable name="present-without-particle"
                      select="replace($present,concat('^(.+?)(( ',$particle2,')? ',$particle,')?$'),'$1')"/>
        <xsl:variable name="past-without-particle"
                      select="replace($past,concat('^(.+?)(( ',$particle2,')? ',$particle,')?$'),'$1')"/>
        <xsl:variable name="participle-without-particle"
                      select="replace($participle,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
        <xsl:variable name="stem">
          <xsl:call-template name="verb-stem">
            <xsl:with-param name="lemma"
                            select="$lemma-without-particle"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="present-stem">
          <xsl:call-template name="present-stem">
            <xsl:with-param name="form"
                            select="$present-without-particle"/>
            <xsl:with-param name="lemma"
                            select="$lemma-without-particle"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="past-stem">
          <xsl:call-template name="past-stem">
            <xsl:with-param name="form"
                            select="$past-without-particle"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="participle-stem">
          <xsl:call-template name="participle-stem">
            <xsl:with-param name="form"
                            select="$participle-without-particle"/>
            <xsl:with-param name="lemma"
                            select="$lemma-without-particle"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="present-marker"><!-- of regular verbs -->
          <xsl:call-template name="get-verbal-marker">
            <xsl:with-param name="form"
                            select="$present-without-particle"/>
            <xsl:with-param name="stem"
                            select="$stem"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="past-marker"><!-- of regular verbs -->
          <xsl:call-template name="get-verbal-marker">
            <xsl:with-param name="form"
                            select="$past-without-particle"/>
            <xsl:with-param name="stem"
                            select="$stem"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="participle-marker"><!-- of regular verbs -->
          <xsl:call-template name="get-verbal-marker">
            <xsl:with-param name="form"
                            select="$participle-without-particle"/>
            <xsl:with-param name="stem"
                            select="$stem"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <!-- regular verbs -->
          <xsl:when test="$present-marker='-t' and
                          $past-marker='-te' and
                          ($participle-marker='-t' or
                           $participle-marker='ge-t') or
                          $present-marker='-et' and
                          $past-marker='-ete' and
                          ($participle-marker='-et' or
                           $participle-marker='ge-et')">
            <xsl:choose>
              <!-- "brauchen" -->
              <xsl:when test="$lemma-without-particle='brauchen'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVReg</xsl:with-param>
                  <xsl:with-param name="auxiliary"
                                  select="$auxiliary"/>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPastSubjReg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- regular verbs ending in consonant + "ien" -->
              <xsl:when test="matches($lemma-without-particle,'[^aeiouäöü]ien$')">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVReg</xsl:with-param>
                  <xsl:with-param name="auxiliary"
                                  select="$auxiliary"/>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other regular verbs -->
              <xsl:otherwise>
                <xsl:variable name="class">
                  <xsl:call-template name="verb-class">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="past"
                                    select="$past-without-particle"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:if test="string-length($class)&gt;0">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class"
                                    select="$class"/>
                    <xsl:with-param name="auxiliary"
                                    select="$auxiliary"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- irregular verbs -->
          <xsl:otherwise>
            <!-- present -->
            <xsl:choose>
              <!-- "haben" -->
              <xsl:when test="$lemma-without-particle='haben'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1_Imp</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="replace($present-stem,'t$','')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "sein" -->
              <xsl:when test="$lemma-without-particle='sein'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VInf-n</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem">bin</xsl:with-param>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat('b',$present-stem)"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem">sind</xsl:with-param>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres13PlInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'d')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPresSubjSg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'e')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2SgSubj</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'e')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPresSubjPl</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAImpSg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'d')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAImpPl</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "tun" and related verbs -->
              <xsl:when test="$lemma-without-particle='tun' or
                              $lemma-without-particle='betun' or
                              $lemma-without-particle='vertun'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="replace($stem,'n$','')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VInf-n</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'e')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($present-stem,'st')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($present-stem,'t')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'n')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres13PlInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'t')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VPresSubj</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAImpSg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'t')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAImpPl</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "werden" -->
              <xsl:when test="$lemma-without-particle='werden'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="replace($stem,'en$','')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VInf-en</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'e')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="replace($present-stem,'d$','st')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'en')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres13PlInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'et')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VPresSubj</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'e')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAImpSg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($stem,'et')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VAImpPl</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- preterite-present verbs -->
              <xsl:when test="$lemma-without-particle='bedürfen' or
                              $lemma-without-particle='dürfen' or
                              $lemma-without-particle='können' or
                              $lemma-without-particle='mögen' or
                              $lemma-without-particle='müssen' or
                              $lemma-without-particle='sollen' or
                              $lemma-without-particle='vermögen' or
                              $lemma-without-particle='wissen' or
                              $lemma-without-particle='wollen'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VMPresSg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VMPresPl</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "sehen" -->
              <xsl:when test="$lemma-without-particle='sehen'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2_Imp</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "vgl." -->
              <xsl:when test="$lemma='vgl.'">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation">yes</xsl:with-param>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">AbbrVImp</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- uniform present stem -->
              <xsl:when test="$stem=$present-stem">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation
                   with stem-final "t" -->
              <xsl:when test="ends-with($present-stem,'t') and
                              matches($present-stem,n:e-i-alternation-re($stem))">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2t_Imp0</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation -->
              <xsl:when test="matches($present-stem,n:e-i-alternation-re($stem))">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2_Imp0</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- present stem for 2nd/3rd person singular with stem-final "d"
                   without "e" epenthesis before "-t" -->
              <xsl:when test="ends-with($present-stem,'d') and
                              $present-without-particle=concat($present-stem,'t')">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1_Imp</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="concat($present-stem,'&lt;SB&gt;')"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- present stem for 2nd/3rd person singular with stem-final "t" -->
              <xsl:when test="ends-with($present-stem,'t') and
                              $present-without-particle=$present-stem">
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1_Imp</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2t</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other present stem for 2nd/3rd person singular -->
              <xsl:otherwise>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres1_Imp</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-stem-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="stem"
                                  select="$present-stem"/>
                  <xsl:with-param name="abbreviation"
                                  select="$abbreviation"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="particle2"
                                  select="$particle2"/>
                  <xsl:with-param name="class">VVPres2</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            <!-- past -->
            <xsl:choose>
              <!-- weak past stem -->
              <xsl:when test="matches($past-without-particle,concat('^',$past-stem,'e?te$'))">
                <!-- past indicative -->
                <xsl:choose>
                  <!-- past indicative with stem-final "d" or "t"
                       without "e" epenthesis before "-t" -->
                  <xsl:when test="matches($past-stem,'[dt]$') and
                                  $past-without-particle=concat($past-stem,'te')">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="concat($past-stem,'&lt;SB&gt;')"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- other weak past stem -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                <!-- past subjunctive -->
                <xsl:choose>
                  <!-- "haben" -->
                  <xsl:when test="$lemma-without-particle='haben'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="concat(n:umlaut($past-stem),'&lt;SB&gt;')"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastSubjReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- preterite-present verbs with umlautable past stem -->
                  <xsl:when test="$lemma-without-particle='bedürfen' or
                                  $lemma-without-particle='dürfen' or
                                  $lemma-without-particle='können' or
                                  $lemma-without-particle='mögen' or
                                  $lemma-without-particle='müssen' or
                                  $lemma-without-particle='vermögen' or
                                  $lemma-without-particle='wissen'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut($past-stem)"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastSubjReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- past stem ending in "ach" -->
                  <xsl:when test="ends-with($past-stem,'ach')">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut($past-stem)"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastSubjReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- Rückumlaut -->
                  <xsl:when test="matches($present-stem,'en[dn]$') and
                                  matches($past-stem,'an[dn]$')">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/><!-- sic! -->
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastSubjReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- other weak past stem -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastSubjReg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- strong past stem -->
              <xsl:otherwise>
                <xsl:choose>
                  <!-- "sein" -->
                  <xsl:when test="$lemma-without-particle='sein'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut($past-stem)"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut($past-stem)"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VAPastSubj2</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- "tun" and related verbs -->
                  <xsl:when test="$lemma-without-particle='tun' or
                                  $lemma-without-particle='betun' or
                                  $lemma-without-particle='vertun'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut($past-stem)"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- "werden" -->
                  <xsl:when test="$lemma-without-particle='werden' and
                                  $past-stem='wurde'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="replace($past-stem,'e$','')"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastIndIrreg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut(replace($past-stem,'e$',''))"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$lemma-without-particle='werden' and
                                  $past-stem='ward'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VAPastIndSg</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="replace($past-stem,'a','u')"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VAPastIndPl</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="n:umlaut(replace($past-stem,'a','u'))"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- umlautable strong past stem -->
                  <!-- Caveat: "e" is considered as a full vowel. -->
                  <xsl:when test="matches($past-stem,'(au|aa|oo|[aou])[^aeiouäöü]*$')">
                    <!-- past indicative -->
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastIndStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                    <!-- past subjunctive -->
                    <xsl:if test="not(ends-with($lemma-without-particle,'sterben') or
                                      ends-with($lemma-without-particle,'werben') or
                                      ends-with($lemma-without-particle,'werfen'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="lemma-index"
                                        select="$lemma-index"/>
                        <xsl:with-param name="paradigm-index"
                                        select="$paradigm-index"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VVPastSubjStr</xsl:with-param>
                        <xsl:with-param name="etymology"
                                        select="$etymology"/>
                      </xsl:call-template>
                    </xsl:if>
                    <!-- past subjunctive with "ü" -->
                    <xsl:if test="ends-with($lemma-without-particle,'heben') or
                                  ends-with($lemma-without-particle,'helfen') or
                                  ends-with($lemma-without-particle,'schwören') or
                                  ends-with($lemma-without-particle,'stehen') or
                                  ends-with($lemma-without-particle,'sterben') or
                                  ends-with($lemma-without-particle,'werben') or
                                  ends-with($lemma-without-particle,'werfen')">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="lemma-index"
                                        select="$lemma-index"/>
                        <xsl:with-param name="paradigm-index"
                                        select="$paradigm-index"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut(replace($past-stem,'[ao]([^aeiouäöü]*)$','u$1'))"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VVPastSubjStr</xsl:with-param>
                        <xsl:with-param name="etymology"
                                        select="$etymology"/>
                      </xsl:call-template>
                    </xsl:if>
                    <!-- archaic past subjunctive with "ö" -->
                    <xsl:if test="ends-with($lemma-without-particle,'befehlen') or
                                  ends-with($lemma-without-particle,'beginnen') or
                                  ends-with($lemma-without-particle,'empfehlen') or
                                  ends-with($lemma-without-particle,'gelten') or
                                  ends-with($lemma-without-particle,'gewinnen') or
                                  ends-with($lemma-without-particle,'rinnen') or
                                  ends-with($lemma-without-particle,'schelten') or
                                  ends-with($lemma-without-particle,'schwimmen') or
                                  ends-with($lemma-without-particle,'sinnen') or
                                  ends-with($lemma-without-particle,'spinnen')">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="lemma-index"
                                        select="$lemma-index"/>
                        <xsl:with-param name="paradigm-index"
                                        select="$paradigm-index"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut(replace($past-stem,'a([^aeiouäöü]*)$','o$1'))"/>
                        <xsl:with-param name="abbreviation"
                                        select="$abbreviation"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VVPastSubjOld</xsl:with-param>
                        <xsl:with-param name="etymology"
                                        select="$etymology"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <!-- non-umlautable strong past stem -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPastStr</xsl:with-param>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <!-- past participle -->
            <xsl:choose>
              <!-- weak past participle -->
              <xsl:when test="matches($participle-without-particle,'e?t$')">
                <xsl:choose>
                  <!-- weak past participle with stem-final "d" or "t"
                       without "e" epenthesis before "-t" -->
                  <xsl:when test="matches($participle-stem,'[dt]$') and
                                  matches($participle-without-particle,concat('^(ge)?',$participle-stem,'t$'))">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="concat($participle-stem,'&lt;SB&gt;')"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPP-t</xsl:with-param>
                      <xsl:with-param name="auxiliary"
                                      select="$auxiliary"/>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- other weak past participle -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPP-t</xsl:with-param>
                      <xsl:with-param name="auxiliary"
                                      select="$auxiliary"/>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- strong past participle -->
              <xsl:otherwise>
                <xsl:choose>
                  <!-- "tun" and related verbs -->
                  <xsl:when test="$lemma-without-particle='tun' or
                                  $lemma-without-particle='betun' or
                                  $lemma-without-particle='vertun'">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="concat($participle-stem,'n')"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VPPast</xsl:with-param>
                      <xsl:with-param name="auxiliary"
                                      select="$auxiliary"/>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- other strong past participle -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="lemma-index"
                                      select="$lemma-index"/>
                      <xsl:with-param name="paradigm-index"
                                      select="$paradigm-index"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="abbreviation"
                                      select="$abbreviation"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class">VVPP-en</xsl:with-param>
                      <xsl:with-param name="auxiliary"
                                      select="$auxiliary"/>
                      <xsl:with-param name="etymology"
                                      select="$etymology"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- compounding stems of verbs -->
<xsl:template name="verb-comp-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">V</xsl:with-param>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of verbs -->
<xsl:template name="verb-der-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="suffs"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches($stem,'^\p{L}$') and
                      $abbreviation='no')">
      <xsl:for-each select="$suffs">
        <xsl:call-template name="der-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="stem"
                          select="$stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="suff"
                          select="."/>
          <xsl:with-param name="pos">V</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- verbal participles (ad-hoc POS) -->
<xsl:template name="participle-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="present"/>
  <xsl:param name="participle"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="particle">
      <xsl:choose>
        <xsl:when test="count(tokenize($present,'&#x20;'))=3">
          <xsl:value-of select="substring-after(substring-after($present,' '),' ')"/>
        </xsl:when>
        <xsl:when test="count(tokenize($present,'&#x20;'))&lt;3">
          <xsl:value-of select="substring-after($present,' ')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="particle2"
                  select="substring-before(substring-after($present,' '),' ')"/>
    <xsl:variable name="lemma-without-particle"
                  select="replace($lemma,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
    <xsl:variable name="participle-without-particle"
                  select="replace($participle,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
    <xsl:variable name="stem">
      <xsl:call-template name="verb-stem">
        <xsl:with-param name="lemma"
                        select="$lemma-without-particle"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="participle-stem">
      <xsl:call-template name="participle-stem">
        <xsl:with-param name="form"
                        select="$participle-without-particle"/>
        <xsl:with-param name="lemma"
                        select="$lemma-without-particle"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="participle-marker"><!-- of regular verbs -->
      <xsl:call-template name="get-verbal-marker">
        <xsl:with-param name="form"
                        select="$participle-without-particle"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- weak participles -->
      <xsl:when test="$participle-marker='-t' or
                      $participle-marker='ge-t' or
                      $participle-marker='-et' or
                      $participle-marker='ge-et'">
        <xsl:call-template name="verb-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma-without-particle"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$participle-stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="participle"
                          select="$participle-without-particle"/>
          <xsl:with-param name="particle"
                          select="$particle"/>
          <xsl:with-param name="particle2"
                          select="$particle2"/>
          <xsl:with-param name="class">VVPP-t</xsl:with-param>
          <xsl:with-param name="auxiliary"
                          select="$auxiliary"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- strong participles -->
      <xsl:otherwise>
        <xsl:call-template name="verb-stem-entry">
          <xsl:with-param name="lemma"
                          select="$lemma-without-particle"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="stem"
                          select="$participle-stem"/>
          <xsl:with-param name="abbreviation"
                          select="$abbreviation"/>
          <xsl:with-param name="participle"
                          select="$participle-without-particle"/>
          <xsl:with-param name="particle"
                          select="$particle"/>
          <xsl:with-param name="particle2"
                          select="$particle2"/>
          <xsl:with-param name="class">VVPP-en</xsl:with-param>
          <xsl:with-param name="auxiliary"
                          select="$auxiliary"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- adpositions -->
<xsl:template name="adposition-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="position"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <xsl:when test="$position='any'">
        <xsl:variable name="class1">
          <xsl:call-template name="adposition-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="position">pre</xsl:with-param>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="class2">
          <xsl:call-template name="adposition-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="position">post</xsl:with-param>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class1)&gt;0 and
                      string-length($class2)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">OTHER</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class1"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">OTHER</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class2"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="class">
          <xsl:call-template name="adposition-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="position"
                            select="$position"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">OTHER</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- contracted adpositions -->
<xsl:template name="contracted-adposition-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="adposition"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <xsl:when test="string-length($adposition)&gt;0">
        <xsl:variable name="class">
          <xsl:call-template name="contracted-adposition-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="clitic"
                            select="replace($lemma,'^.+(.)$','$1')"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$adposition"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="stem"
                            select="$lemma"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">OTHER</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="class">
          <xsl:call-template name="contracted-adposition-class">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="clitic"
                            select="replace($lemma,'^.+(.)$','$1')"/>
            <xsl:with-param name="pronunciations"
                            select="$pronunciations"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length($class)&gt;0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="abbreviation"
                            select="$abbreviation"/>
            <xsl:with-param name="pos">OTHER</xsl:with-param>
            <xsl:with-param name="class"
                            select="$class"/>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- conjunctions -->
<xsl:template name="conjunction-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="abbreviation"/>
  <xsl:param name="type"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="class">
      <xsl:call-template name="conjunction-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="type"
                        select="$type"/>
        <xsl:with-param name="pronunciations"
                        select="$pronunciations"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="string-length($class)&gt;0">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="lemma-index"
                        select="$lemma-index"/>
        <xsl:with-param name="paradigm-index"
                        select="$paradigm-index"/>
        <xsl:with-param name="abbreviation"
                        select="$abbreviation"/>
        <xsl:with-param name="pos">OTHER</xsl:with-param>
        <xsl:with-param name="class"
                        select="$class"/>
        <xsl:with-param name="etymology"
                        select="$etymology"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- helper templates -->

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
          <xsl:text>" has unsupported lemma index </xsl:text>
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
          <xsl:text>" has unsupported paradigm index </xsl:text>
          <xsl:value-of select="$paradigm-index"/>
          <xsl:text>.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
