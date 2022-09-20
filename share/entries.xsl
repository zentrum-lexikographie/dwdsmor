<?xml version="1.0" encoding="utf-8"?>
<!-- entries.xsl -->
<!-- Version 5.0 -->
<!-- Andreas Nolda 2022-09-02 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="categories.xsl"/>

<xsl:template name="affix-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="type"/>
  <xsl:param name="separable"/>
  <xsl:param name="selection"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:call-template name="affix-entry">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="lemma-index"
                      select="$lemma-index"/>
      <xsl:with-param name="paradigm-index"
                      select="$paradigm-index"/>
      <xsl:with-param name="type"
                      select="$type"/>
      <xsl:with-param name="separable"
                      select="$separable"/>
      <xsl:with-param name="selection">
        <xsl:choose>
          <xsl:when test="$selection='adjective'">ADJ</xsl:when>
          <xsl:when test="$selection='adverb'">ADV</xsl:when>
          <xsl:when test="$selection='noun'">NN</xsl:when>
          <xsl:when test="$selection='verb'">V</xsl:when>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="etymology"
                      select="$etymology"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="adjective-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="function"/>
  <xsl:param name="inflection"/>
  <xsl:param name="positive"/>
  <xsl:param name="comparative"/>
  <xsl:param name="superlative"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- predicative-only adjectives -->
      <xsl:when test="$function='nonattr'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">ADJ</xsl:with-param>
          <xsl:with-param name="class">AdjPosNonAttr</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- uninflected adjectives -->
      <xsl:when test="$inflection='no'">
        <xsl:choose>
          <!-- attributive-only location adjectives -->
          <xsl:when test="matches($lemma,'^\p{Lu}.*er$')">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj0-Up</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other uninflected adjectives -->
          <xsl:otherwise>
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPosNonAttr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
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
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives with irregular positive forms -->
          <xsl:when test="matches($lemma,'e[lr]$') and
                          $positive=replace($lemma,'e([lr])$','$1e')">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj-el/er</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="string-length($positive)&gt;0 and
                          not(matches($positive-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPosNonAttr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="form"
                              select="replace($positive,'e$','')"/>
              <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="string-length($comparative)&gt;0">
              <xsl:call-template name="adjective-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="form"
                                select="replace($comparative,'er$','')"/>
                <xsl:with-param name="class">AdjComp</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="string-length($superlative)&gt;0">
              <xsl:call-template name="adjective-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="form"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with the uninflected comparative form "mehr" or "weniger" -->
          <xsl:when test="$comparative='mehr' or
                          $comparative='weniger'">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="form"
                              select="$comparative"/>
              <xsl:with-param name="class">AdjComp0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="form"
                              select="replace($superlative,'^am (.+)sten$','$1')"/>
              <xsl:with-param name="class">AdjSup</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives with irregular comparative forms -->
          <xsl:when test="matches($lemma,'e[lr]$') and
                          $comparative=replace($lemma,'e([lr])$','$1er')">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj-el/er</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="ends-with($comparative,'er') and
                          not(matches($comparative-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="form"
                              select="replace($comparative,'er$','')"/>
              <xsl:with-param name="class">AdjComp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($superlative,'sten')">
              <xsl:call-template name="adjective-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
                <xsl:with-param name="form"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with irregular superlative forms -->
          <xsl:when test="ends-with($superlative,'sten') and
                          not(matches($superlative-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($comparative,'er')">
              <xsl:call-template name="adjective-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="form"
                                select="replace($comparative,'er$','')"/>
                <xsl:with-param name="class">AdjComp</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="form"
                              select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
              <xsl:with-param name="class">AdjSup</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives with word-internal comparative markers -->
          <xsl:when test="string-length($comparative)&gt;0 and
                          not(matches($comparative-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$comparative"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="string-length($superlative)&gt;0 and
                          not(matches($superlative-marker,'^&#x308;?(ß/ss)?-'))">
              <xsl:call-template name="word-entry">
                <xsl:with-param name="lemma"
                                select="replace($superlative,'^am (.+)en$','$1')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPos</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with word-internal superlative markers -->
          <xsl:when test="string-length($superlative)&gt;0 and
                          not(matches($superlative-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:if test="string-length($comparative)&gt;0 and
                          not(matches($comparative-marker,'^&#x308;?(ß/ss)?-'))">
              <xsl:call-template name="word-entry">
                <xsl:with-param name="lemma"
                                select="$comparative"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPos</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="replace($superlative,'^am (.+)en$','$1')"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- ungradable adjectives with capitalised first member -->
          <xsl:when test="string-length($superlative)=0 and
                          matches($lemma,'\p{Lu}\p{L}*-')">
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos-Up</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other adjectives -->
          <xsl:otherwise>
            <xsl:call-template name="word-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:call-template name="adjective-class">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="superlative"
                                  select="$superlative"/>
                  <xsl:with-param name="pronunciations"
                                  select="$pronunciations"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="adverb-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="comparative"/>
  <xsl:param name="superlative"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- adverbs with the unsuffixed comparative form "mehr" -->
      <xsl:when test="$comparative='mehr'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="adverb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$comparative"/>
          <xsl:with-param name="class">AdvComp0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="adverb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($superlative,'^am (.+)sten$','$1')"/>
          <xsl:with-param name="class">AdvSup</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- adverbs with other comparative forms -->
      <xsl:when test="ends-with($comparative,'er')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="adverb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($comparative,'er$','')"/>
          <xsl:with-param name="class">AdvComp</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:if test="ends-with($superlative,'sten')">
          <xsl:call-template name="adverb-entry">
            <xsl:with-param name="lemma"
                            select="$lemma"/>
            <xsl:with-param name="lemma-index"
                            select="$lemma-index"/>
            <xsl:with-param name="paradigm-index"
                            select="$paradigm-index"/>
            <xsl:with-param name="form"
                            select="replace($superlative,'^am (.+)sten$','$1')"/>
            <xsl:with-param name="class">AdvSup</xsl:with-param>
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <!-- other adverbs -->
      <xsl:otherwise>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="article-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtDef</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "eine", "'ne" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='eine'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtIndef</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma">eine</xsl:with-param>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">’n</xsl:with-param>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtIndef-n</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "keine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='keine'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">ART</xsl:with-param>
          <xsl:with-param name="class">ArtNeg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="cardinal-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-ein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "keine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='keine'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-kein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "zwei", "drei" -->
      <xsl:when test="$lemma='zwei' or
                      $lemma='drei'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-vier</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sieben" -->
      <xsl:when test="$lemma='sieben'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card-sieben</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">CARD</xsl:with-param>
          <xsl:with-param name="class">Card0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="ordinal-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
    <xsl:call-template name="word-entry">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="lemma-index"
                      select="$lemma-index"/>
      <xsl:with-param name="paradigm-index"
                      select="$paradigm-index"/>
      <xsl:with-param name="form"
                      select="$stem"/>
      <xsl:with-param name="pos">ORD</xsl:with-param>
      <xsl:with-param name="class">Ord</xsl:with-param>
      <xsl:with-param name="etymology"
                      select="$etymology"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="noun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
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
      <!-- nouns with meta-markers -->
      <!-- genitive singular: "-(s)"
           nominative plural: "-(s)" -->
      <xsl:when test="$genitive-singular-marker='-(s)' and
                      $nominative-plural-marker='-(s)'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="$gender"/>
              <xsl:with-param name="number"
                              select="$number"/>
              <xsl:with-param name="genitive-singular">-s</xsl:with-param>
              <xsl:with-param name="nominative-plural">-</xsl:with-param>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="$gender"/>
              <xsl:with-param name="number"
                              select="$number"/>
              <xsl:with-param name="genitive-singular">-</xsl:with-param>
              <xsl:with-param name="nominative-plural">-s</xsl:with-param>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- genitive singular: "-(s)" -->
      <xsl:when test="$genitive-singular-marker='-(s)'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- nominative plural: "-(s)" -->
      <xsl:when test="$nominative-plural-marker='-(s)'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- masculine nouns -->
      <!-- genitive singular: "-(e)s"
           nominative plural: "-ten" -->
      <xsl:when test="$gender='mask.' and
                      ($genitive-singular-marker='-(e)s' or
                       $genitive-singular-marker='-es') and
                      $nominative-plural-marker='-ten'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Sg_es</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="noun-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">
            <xsl:choose>
              <xsl:when test="starts-with($nominative-plural,'-')">
                <xsl:value-of select="concat($lemma,substring-after($nominative-plural,'-'))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$nominative-plural"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="class">NMasc/Pl_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: compound with "Mann"
           nominative plural: compound with "Leute" -->
      <xsl:when test="$gender='mask.' and
                      ends-with($lemma,'mann') and
                      ends-with($nominative-plural,'leute')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$nominative-plural"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">N?/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- neuter nouns -->
      <!-- lemma: "Innere" -->
      <xsl:when test="$lemma='Innere' and
                      $genitive-singular-marker='-n' and
                      $number='singular'">
        <xsl:call-template name="noun-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="class">NNeut-Inner</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: (compound with) "Regime" (with unpronounced final "e")
           nominative plural: "-" (with pronounced final schwa) -->
      <xsl:when test="($lemma='Regime' or
                       ends-with($lemma,'regime')) and
                      $nominative-plural-marker='-'">
        <xsl:call-template name="noun-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="class">NNeut_s_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- feminine nouns -->
      <!-- lemma: compound with "Frau"
           nominative plural: compound with "Leute" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'frau') and
                      ends-with($nominative-plural,'leute')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$nominative-plural"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">N?/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other nouns -->
      <xsl:otherwise>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="name-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other proper names -->
      <xsl:otherwise>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">
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
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="demonstrative-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem-dies</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jene", "ebenjene" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'jene')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "die", "ebendie" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'die')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">DemDef</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "solche", "ebensolche" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'solche')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">DEM</xsl:with-param>
          <xsl:with-param name="class">Dem-solch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "derjenige" -->
  <!-- "derselbe", "ebenderselbe", "höchstderselbe" -->
  <!-- "dieselbige" -->
  <!-- "selbige" -->
  <!-- "selben" -->
  <!-- "selber", "selbst", "höchstselbst" -->
  <!-- "deretwegen", "derethalben" -->
  <!-- "sone", "son" -->
  <!-- "dergleichen", "derlei" -->
  <!-- "alldem" -->
</xsl:template>

<xsl:template name="indefinite-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-ein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "irgendeine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='irgendeine'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-irgendein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "keine" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='keine'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-kein</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "welche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='welche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-welch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "irgendwelche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='irgendwelche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-irgendwelch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "einige" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='einige'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-einig</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "alle" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='alle'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-all</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jede" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='jede' or
                       $lemma='jedwede')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-jed</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jegliche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='jegliche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-jeglich</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "beide" -->
      <xsl:when test="$lemma='beide'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-beid</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "manche" -->
      <xsl:when test="$lemma='manche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-manch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "mehrere" -->
      <xsl:when test="$lemma='mehrere'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'e$','')"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-mehrer</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "genug" -->
      <xsl:when test="$lemma='genug'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "paar" -->
      <xsl:when test="$lemma='paar'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sämtliche" -->
      <xsl:when test="$lemma='sämtliche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">Indef-saemtlich</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jedermann" -->
      <xsl:when test="$lemma='jedermann'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-jedermann</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "man" -->
      <xsl:when test="$lemma='man'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IPro-man</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "jemand", "irgendjemand" -->
      <xsl:when test="ends-with($lemma,'jemand')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "niemand" -->
      <xsl:when test="$lemma='niemand'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMasc</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "etwas", "ebbes", "irgendetwas" -->
      <xsl:when test="ends-with($lemma,'etwas') or
                      $lemma='ebbes'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "was", "irgendwas", "sonstwas" -->
      <xsl:when test="ends-with($lemma,'was')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'was$','wes')"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "wer", "irgendwer", "sonstwer" -->
      <xsl:when test="ends-with($lemma,'wer')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'wer$','wen')"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'wer$','wem')"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'wer$','wes')"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">INDEF</xsl:with-param>
          <xsl:with-param name="class">IProNeut</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "aberhundert", "Aberhundert" -->
  <!-- "allerlei", "jederlei", "einerlei" -->
  <!-- "allesamt" -->
  <!-- "ebensoviel", "genausoviel", "geradesoviel", "gradesoviel", "soviel" -->
  <!-- "ebensowenig", "genausowenig", "sowenig", "blutwenig", "zuwenig" -->
  <!-- "männiglich" -->
  <!-- "meinesgleichen", "deinesgleichen", "seinesgleichen",
       "ihresgleichen", "unsersgleichen", "euresgleichen" -->
  <!-- "unsereiner" -->
  <!-- "unsereins" -->
  <!-- "mensch" -->
  <!-- "soundsovielte" -->
  <!-- "unsereiner" -->
  <!-- "unsereins" -->
  <!-- "zigtausend" -->
</xsl:template>

<xsl:template name="interrogative-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">wes</xsl:with-param>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "wer" -->
      <xsl:when test="$lemma='wer'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">wen</xsl:with-param>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">wem</xsl:with-param>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">wes</xsl:with-param>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">WProMascGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "welche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='welche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">WPRO</xsl:with-param>
          <xsl:with-param name="class">W-welch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "wieviele", "wievielte" -->
</xsl:template>

<xsl:template name="personal-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- "du" -->
      <xsl:when test="$lemma='du'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">dich</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">dir</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">dein</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Du" -->
      <xsl:when test="$lemma='Du'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Dich</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Dir</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Dein</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "er" -->
      <xsl:when test="$lemma='er'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihn</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihm</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">sein</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProMascGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "es", "'s" -->
      <xsl:when test="$lemma='es'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma">es</xsl:with-param>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">’s</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutNomSg-s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma">es</xsl:with-param>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">’s</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutAccSg-s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihm</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">sein</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNeutGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "ich" -->
      <xsl:when test="$lemma='ich'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1NomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">mich</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">mir</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">mein</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1GenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "ihr" -->
      <xsl:when test="$lemma='ihr'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">euch</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">euch</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">eu</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Ihr" -->
      <xsl:when test="$lemma='Ihr'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2NomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Euch</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2AccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Euch</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2DatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Eu</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro2GenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sie" -->
      <xsl:when test="$lemma='sie'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemNomSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendNomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemAccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendAccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihr</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemDatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihnen</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendDatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihr</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProFemGenSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">ihr</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendGenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Sie" -->
      <xsl:when test="$lemma='Sie'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendNomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendAccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Ihnen</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendDatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Ihr</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PProNoGendGenPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template><!-- ? -->
      </xsl:when>
      <!-- "wir" -->
      <xsl:when test="$lemma='wir'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1NomPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">uns</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1AccPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">uns</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PPro1DatPl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">uns</xsl:with-param>
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

<xsl:template name="reflexive-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="gender"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- "dich" -->
      <xsl:when test="$lemma='dich'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">dir</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Dich" -->
      <xsl:when test="$lemma='Dich'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">Dir</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "euch" -->
      <xsl:when test="$lemma='euch'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2Pl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Euch" -->
      <xsl:when test="$lemma='Euch'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl2Pl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "mich" -->
      <xsl:when test="$lemma='mich'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl1AccSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form">mir</xsl:with-param>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl1DatSg</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "sich" -->
      <xsl:when test="$lemma='sich'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl3</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "uns" -->
      <xsl:when test="$lemma='uns'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">PPRO</xsl:with-param>
          <xsl:with-param name="class">PRefl1Pl</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="possessive-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
      <!-- "meine", "deine", "seine" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'eine')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "ihre", "Ihre" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='ihre' or
                       $lemma='Ihre')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "unsere" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='unsere'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "eure", "Eure" -->
      <xsl:when test="$gender='fem.' and
                      ($lemma='eure' or
                       $lemma='Eure')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'re$','er')"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "Ew." -->
      <xsl:when test="$lemma='Ew.'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Abk_POSS</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "meinige", "deinige", "seinige" -->
      <xsl:when test="$gender='fem.' and
                      ends-with($lemma,'einige')">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss/Wk</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "unsrige" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='unsrige'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'rige$','erig')"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="replace($lemma,'rige$','erig')"/>
          <xsl:with-param name="pos">POSS</xsl:with-param>
          <xsl:with-param name="class">Poss/Wk-er</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="relative-pronoun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
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
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">Rel</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- "welche" -->
      <xsl:when test="$gender='fem.' and
                      $lemma='welche'">
        <xsl:call-template name="word-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$stem"/>
          <xsl:with-param name="pos">REL</xsl:with-param>
          <xsl:with-param name="class">Rel-welch</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  <!-- TODO: -->
  <!-- "derethalben", "deretwegen" -->
</xsl:template>

<xsl:template name="verb-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="present"/>
  <xsl:param name="past"/>
  <xsl:param name="participle"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="particle"
                  select="substring-after($present,' ')"/>
    <xsl:variable name="lemma-without-particle"
                  select="replace($lemma,concat('^',$particle,'(.+)$'),'$1')"/>
    <xsl:variable name="present-without-particle"
                  select="replace($present,concat('^(.+?)( ',$particle,')?$'),'$1')"/>
    <xsl:variable name="past-without-particle"
                  select="replace($past,concat('^(.+?)( ',$particle,')?$'),'$1')"/>
    <xsl:variable name="participle-without-particle"
                  select="replace($participle,concat('^',$particle,'(.+)$'),'$1')"/>
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
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">
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
              </xsl:with-param>
              <xsl:with-param name="auxiliary"
                              select="$auxiliary"/>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="n:umlaut($past-stem)"/>
              <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other regular verbs -->
          <xsl:otherwise>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">
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
              </xsl:with-param>
              <xsl:with-param name="auxiliary"
                              select="$auxiliary"/>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- irregular verbs -->
      <xsl:otherwise>
        <!-- present -->
        <xsl:choose>
          <!-- "haben" -->
          <xsl:when test="$lemma-without-particle='haben'">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="replace($present-stem,'t$','')"/>
              <xsl:with-param name="class">VVPres2</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- "sein" -->
          <xsl:when test="$lemma-without-particle='sein'">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VInf-n</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem">bin</xsl:with-param>
              <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat('b',$present-stem)"/>
              <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
              <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem">sind</xsl:with-param>
              <xsl:with-param name="class">VAPres1/3PlInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'d')"/>
              <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VAPresKonjSg</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'e')"/>
              <xsl:with-param name="class">VAPres2SgKonj</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'e')"/>
              <xsl:with-param name="class">VAPresKonjPl</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VAImpSg</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'d')"/>
              <xsl:with-param name="class">VAImpPl</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- "tun" -->
          <xsl:when test="$lemma-without-particle='tun'">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="replace($stem,'n$','')"/>
              <xsl:with-param name="class">VInf-n</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'e')"/>
              <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($present-stem,'st')"/>
              <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($present-stem,'t')"/>
              <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'n')"/>
              <xsl:with-param name="class">VAPres1/3PlInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'t')"/>
              <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VPresKonj</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VAImpSg</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'t')"/>
              <xsl:with-param name="class">VAImpPl</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- "werden" -->
          <xsl:when test="$lemma-without-particle='werden'">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="replace($stem,'en$','')"/>
              <xsl:with-param name="class">VInf-en</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'e')"/>
              <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="replace($present-stem,'d$','st')"/>
              <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
              <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'en')"/>
              <xsl:with-param name="class">VAPres1/3PlInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'et')"/>
              <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VPresKonj</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'e')"/>
              <xsl:with-param name="class">VAImpSg</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($stem,'et')"/>
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
                          $lemma-without-particle='wissen' or
                          $lemma-without-particle='wollen'">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
              <xsl:with-param name="class">VMPresSg</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VMPresPl</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- uniform present stem -->
          <xsl:when test="$stem=$present-stem">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation with stem-final "t" -->
          <xsl:when test="matches($present-stem,'t$') and
                          matches($present-stem,n:e-i-alternation-re($stem))">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres1</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
              <xsl:with-param name="class">VVPres2+Imp0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation -->
          <xsl:when test="matches($present-stem,n:e-i-alternation-re($stem))">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres1</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
              <xsl:with-param name="class">VVPres2+Imp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- present stem for 2nd/3rd person singular with stem-final "d" without "e" epenthesis before "-t" -->
          <xsl:when test="matches($present-stem,'d$') and
                          $present-without-particle=concat($present-stem,'t')">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="concat($present-stem,'&lt;FB&gt;')"/>
              <xsl:with-param name="class">VVPres2</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- present stem for 2nd/3rd person singular with stem-final "t" -->
          <xsl:when test="matches($present-stem,'t$') and
                          $present-without-particle=$present-stem">
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
              <xsl:with-param name="class">VVPres2t</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other present stem for 2nd/3rd person singular -->
          <xsl:otherwise>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$stem"/>
              <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="lemma-index"
                              select="$lemma-index"/>
              <xsl:with-param name="paradigm-index"
                              select="$paradigm-index"/>
              <xsl:with-param name="participle"
                              select="$participle-without-particle"/>
              <xsl:with-param name="particle"
                              select="$particle"/>
              <xsl:with-param name="stem"
                              select="$present-stem"/>
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
              <!-- past indicative with stem-final "d" or "t" without "e" epenthesis before "-t" -->
              <xsl:when test="matches($past-stem,'[dt]$') and
                              $past-without-particle=concat($past-stem,'te')">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="concat($past-stem,'&lt;FB&gt;')"/>
                  <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other weak past stem -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
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
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="concat(n:umlaut($past-stem),'&lt;FB&gt;')"/>
                  <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
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
                              $lemma-without-particle='wissen'">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- past stem ending in "ach" -->
              <xsl:when test="matches($past-stem,'ach$')">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- Rückumlaut -->
              <xsl:when test="matches($present-stem,'en[dn]$') and
                              matches($past-stem,'an[dn]$')">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$stem"/><!-- sic! -->
                  <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other weak past stem -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
                  <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
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
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
                  <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="class">VAPastKonj2</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "tun" -->
              <xsl:when test="$lemma-without-particle='tun'">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
                  <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- "werden" -->
              <xsl:when test="$lemma-without-particle='werden' and
                              $past-stem='wurde'">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="replace($past-stem,'e$','')"/>
                  <xsl:with-param name="class">VPastIndIrreg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut(replace($past-stem,'e$',''))"/>
                  <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="$lemma-without-particle='werden' and
                              $past-stem='ward'">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
                  <xsl:with-param name="class">VAPastIndSg</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="replace($past-stem,'a','u')"/>
                  <xsl:with-param name="class">VAPastIndPl</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut(replace($past-stem,'a','u'))"/>
                  <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- umlautable strong past stem -->
              <!-- Caveat: "e" is considered as a full vowel. -->
              <xsl:when test="matches($past-stem,'([aou]|aa|oo|au)[^aeiouäöü]*$')">
                <!-- past indicative -->
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
                  <xsl:with-param name="class">VVPastIndStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
                <!-- past subjunctive -->
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="n:umlaut($past-stem)"/>
                  <xsl:with-param name="class">VVPastKonjStr</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- non-umlautable strong past stem -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$past-stem"/>
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
              <!-- past participle with stem-final "d" or "t" without "e" epenthesis before "-t" -->
              <xsl:when test="matches($participle-stem,'[dt]$') and
                              matches($participle-without-particle,concat('^(ge)?',$participle-stem,'t$'))">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="concat($participle-stem,'&lt;FB&gt;')"/>
                  <xsl:with-param name="class">VVPP-t</xsl:with-param>
                  <xsl:with-param name="auxiliary"
                                  select="$auxiliary"/>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other weak past participle -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$participle-stem"/>
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
              <!-- "tun" -->
              <xsl:when test="$lemma-without-particle='tun'">
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="concat($participle-stem,'n')"/>
                  <xsl:with-param name="class">VPPast</xsl:with-param>
                  <xsl:with-param name="auxiliary"
                                  select="$auxiliary"/>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other strong past participle -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="lemma-index"
                                  select="$lemma-index"/>
                  <xsl:with-param name="paradigm-index"
                                  select="$paradigm-index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$participle-stem"/>
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
  </xsl:if>
</xsl:template>

<xsl:template name="participle-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="present"/>
  <xsl:param name="participle"/>
  <xsl:param name="auxiliary"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:variable name="particle"
                  select="substring-after($present,' ')"/>
    <xsl:variable name="lemma-without-particle"
                  select="replace($lemma,concat('^',$particle,'(.+)$'),'$1')"/>
    <xsl:variable name="participle-without-particle"
                  select="replace($participle,concat('^',$particle,'(.+)$'),'$1')"/>
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
     <xsl:call-template name="verb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma-without-particle"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="participle"
                          select="$participle-without-particle"/>
          <xsl:with-param name="particle"
                          select="$particle"/>
          <xsl:with-param name="stem"
                          select="$participle-stem"/>
          <xsl:with-param name="class">VVPP-t</xsl:with-param>
          <xsl:with-param name="auxiliary"
                          select="$auxiliary"/>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- strong participles -->
      <xsl:otherwise>
        <xsl:call-template name="verb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma-without-particle"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="participle"
                          select="$participle-without-particle"/>
          <xsl:with-param name="particle"
                          select="$particle"/>
          <xsl:with-param name="stem"
                          select="$participle-stem"/>
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

<xsl:template name="adposition-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="position"/>
  <xsl:param name="case"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <xsl:when test="$position='pre+post'">
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="position">pre</xsl:with-param>
              <xsl:with-param name="case"
                              select="$case"/>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="position">post</xsl:with-param>
              <xsl:with-param name="case"
                              select="$case"/>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="position"
                              select="$position"/>
              <xsl:with-param name="case"
                              select="$case"/>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="contracted-adposition-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="adposition"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <xsl:when test="string-length($adposition)&gt;0">
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$adposition"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="form"
                          select="$lemma"/>
          <xsl:with-param name="class">
            <xsl:call-template name="contracted-adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="clitic"
                              select="replace($lemma,'^.+(.)$','$1')"/>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="lemma-index"
                          select="$lemma-index"/>
          <xsl:with-param name="paradigm-index"
                          select="$paradigm-index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="contracted-adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="clitic"
                              select="replace($lemma,'^.+(.)$','$1')"/>
              <xsl:with-param name="pronunciations"
                              select="$pronunciations"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="conjunction-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="lemma-index"/>
  <xsl:param name="paradigm-index"/>
  <xsl:param name="type"/>
  <xsl:param name="pronunciations"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
  <xsl:call-template name="other-entry">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="lemma-index"
                    select="$lemma-index"/>
    <xsl:with-param name="paradigm-index"
                    select="$paradigm-index"/>
    <xsl:with-param name="class">
      <xsl:call-template name="conjunction-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="type"
                        select="$type"/>
        <xsl:with-param name="pronunciations"
                        select="$pronunciations"/>
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for abbreviations -->
