<?xml version="1.0" encoding="utf-8"?>
<!-- entries.xsl -->
<!-- Version 3.1 -->
<!-- Andreas Nolda 2022-07-01 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="categories.xsl"/>

<xsl:template name="affix-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="index"/>
  <xsl:param name="type"/>
  <xsl:param name="separable"/>
  <xsl:param name="selection"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:call-template name="affix-entry">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
      <xsl:with-param name="index"
                      select="$index"/>
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
  <xsl:param name="index"/>
  <xsl:param name="inflection"/>
  <xsl:param name="positive"/>
  <xsl:param name="comparative"/>
  <xsl:param name="superlative"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- uninflected adjectives -->
      <xsl:when test="$inflection='no'">
        <xsl:choose>
          <xsl:when test="matches($lemma,'^\p{Lu}')">
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">Adj0-Up</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
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
          <!-- adjectives with irregular positive forms -->
          <xsl:when test="string-length($positive)&gt;0 and
                          not(matches($positive-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPosPred</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
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
                <xsl:with-param name="index"
                                select="$index"/>
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
                <xsl:with-param name="index"
                                select="$index"/>
                <xsl:with-param name="form"
                                select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                <xsl:with-param name="class">AdjSup</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <!-- adjectives with the uninflected comparative form "mehr" -->
          <xsl:when test="$comparative='mehr'">
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="form"
                              select="$comparative"/>
              <xsl:with-param name="class">AdjComp0</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="form"
                              select="replace($superlative,'^am (.+)sten$','$1')"/>
              <xsl:with-param name="class">AdjSup</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives with irregular comparative forms -->
          <xsl:when test="ends-with($comparative,'er') and
                          not(matches($comparative-marker,'^&#x308;?(ß/ss)?-'))">
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="adjective-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="ends-with($comparative,'er')">
              <xsl:call-template name="adjective-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="index"
                                select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$comparative"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:if test="string-length($superlative)&gt;0 and
                          not(matches($superlative-marker,'^&#x308;?(ß/ss)?-'))">
              <xsl:call-template name="default-entry">
                <xsl:with-param name="lemma"
                                select="replace($superlative,'^am (.+)en$','$1')"/>
                <xsl:with-param name="index"
                                select="$index"/>
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
              <xsl:call-template name="default-entry">
                <xsl:with-param name="lemma"
                                select="$comparative"/>
                <xsl:with-param name="index"
                                select="$index"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPos</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="replace($superlative,'^am (.+)en$','$1')"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- ungradable adjectives with capitalised first member -->
          <xsl:when test="string-length($superlative)=0 and
                          matches($lemma,'\p{Lu}\p{L}*-')">
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjPos-Up</xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
          </xsl:when>
          <!-- other adjectives -->
          <xsl:otherwise>
            <xsl:call-template name="default-entry">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="index"
                              select="$index"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:call-template name="adjective-class">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="superlative"
                                  select="$superlative"/>
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
  <xsl:param name="index"/>
  <xsl:param name="comparative"/>
  <xsl:param name="superlative"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <!-- adverbs with the unsuffixed comparative form "mehr" -->
      <xsl:when test="$comparative='mehr'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="adverb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="form"
                          select="$comparative"/>
          <xsl:with-param name="class">AdvComp0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="adverb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="form"
                          select="replace($superlative,'^am (.+)sten$','$1')"/>
          <xsl:with-param name="class">AdvSup</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- adverbs with other comparative forms -->
      <xsl:when test="ends-with($comparative,'er')">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="adverb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
            <xsl:with-param name="index"
                            select="$index"/>
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
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">Adv</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="noun-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="index"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
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
      <!-- masculine nouns -->
      <!-- genitive singular: "-(e)s"
           nominative plural: "-ten" -->
      <xsl:when test="$gender='mask.' and
                      ($genitive-singular-marker='-(e)s' or
                       $genitive-singular-marker='-es') and
                      $nominative-plural-marker='-ten'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Sg_es</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="noun-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
      <!-- genitive singular: "-(s)"
           nominative plural: "-(s)" -->
      <xsl:when test="$gender='mask.' and
                      $genitive-singular-marker='-(s)' and
                      $nominative-plural-marker='-(s)'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Sg_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc_s_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc_s_s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- genitive singular: "-(s)" -->
      <xsl:when test="$gender='mask.' and
                      $genitive-singular-marker='-(s)'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc/Sg_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- nominative plural: "-(s)" -->
      <xsl:when test="$gender='mask.' and
                      $nominative-plural-marker='-(s)'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NMasc_s_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- lemma: compound with "Mann"
           nominative plural: compound with "Leute" -->
      <xsl:when test="$gender='mask.' and
                      ends-with($lemma,'mann') and
                      ends-with($nominative-plural,'leute')">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$nominative-plural"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">N?/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- neuter nouns -->
      <!-- genitive singular: "-(s)"
           nominative plural: "-(s)" -->
      <xsl:when test="$gender='neutr.' and
                      $genitive-singular-marker='-(s)' and
                      $nominative-plural-marker='-(s)'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut/Sg_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut_s_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut_s_s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- genitive singular: "-(s)" -->
      <xsl:when test="$gender='neutr.' and
                      $genitive-singular-marker='-(s)'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut/Sg_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- nominative plural: "-(s)" -->
      <xsl:when test="$gender='neutr.' and
                      $nominative-plural-marker='-(s)'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">NNeut_s_x</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
            </xsl:call-template>
          </xsl:with-param>
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
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$nominative-plural"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class">N?/Pl_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other nouns -->
      <xsl:otherwise>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
  <xsl:param name="index"/>
  <xsl:param name="gender"/>
  <xsl:param name="number"/>
  <xsl:param name="genitive-singular"/>
  <xsl:param name="nominative-plural"/>
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
      <!-- masculine proper names -->
      <!-- genitive singular: "-(s)"
           no plural -->
      <xsl:when test="$gender='mask.' and
                      $genitive-singular-marker='-(s)' and
                      $number='singular'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">Name-Masc_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">Name-Masc_s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- neuter proper names -->
      <!-- genitive singular: "-(s)"
           no plural -->
      <xsl:when test="$gender='neutr.' and
                      $genitive-singular-marker='-(s)' and
                      $number='singular'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">Name-Neut_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">Name-Neut_s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- feminine proper names -->
      <!-- genitive singular: "-(s)"
           no plural -->
      <xsl:when test="$gender='fem.' and
                      $genitive-singular-marker='-(s)' and
                      $number='singular'">
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">Name-Fem_0</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class">Name-Fem_s</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- other proper names -->
      <xsl:otherwise>
        <xsl:call-template name="default-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
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
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="verb-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="index"/>
  <xsl:param name="present"/>
  <xsl:param name="past"/>
  <xsl:param name="participle"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
            </xsl:call-template>
            <xsl:call-template name="verb-entry">
              <xsl:with-param name="lemma"
                              select="$lemma-without-particle"/>
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
                </xsl:call-template>
              </xsl:with-param>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
              <xsl:with-param name="index"
                              select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="concat($participle-stem,'&lt;FB&gt;')"/>
                  <xsl:with-param name="class">VVPP-t</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other weak past participle -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="index"
                                  select="$index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$participle-stem"/>
                  <xsl:with-param name="class">VVPP-t</xsl:with-param>
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
                  <xsl:with-param name="index"
                                  select="$index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="concat($participle-stem,'n')"/>
                  <xsl:with-param name="class">VPPast</xsl:with-param>
                  <xsl:with-param name="etymology"
                                  select="$etymology"/>
                </xsl:call-template>
              </xsl:when>
              <!-- other strong past participle -->
              <xsl:otherwise>
                <xsl:call-template name="verb-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma-without-particle"/>
                  <xsl:with-param name="index"
                                  select="$index"/>
                  <xsl:with-param name="participle"
                                  select="$participle-without-particle"/>
                  <xsl:with-param name="particle"
                                  select="$particle"/>
                  <xsl:with-param name="stem"
                                  select="$participle-stem"/>
                  <xsl:with-param name="class">VVPP-en</xsl:with-param>
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
  <xsl:param name="index"/>
  <xsl:param name="present"/>
  <xsl:param name="participle"/>
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
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="participle"
                          select="$participle-without-particle"/>
          <xsl:with-param name="particle"
                          select="$particle"/>
          <xsl:with-param name="stem"
                          select="$participle-stem"/>
          <xsl:with-param name="class">VVPP-t</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:when>
      <!-- strong participles -->
      <xsl:otherwise>
        <xsl:call-template name="verb-entry">
          <xsl:with-param name="lemma"
                          select="$lemma-without-particle"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="participle"
                          select="$participle-without-particle"/>
          <xsl:with-param name="particle"
                          select="$particle"/>
          <xsl:with-param name="stem"
                          select="$participle-stem"/>
          <xsl:with-param name="class">VVPP-en</xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="adposition-entry-set">
  <xsl:param name="lemma"/>
  <xsl:param name="index"/>
  <xsl:param name="position"/>
  <xsl:param name="case"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <xsl:when test="$position='pre+post'">
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="position">pre</xsl:with-param>
              <xsl:with-param name="case"
                              select="$case"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="etymology"
                          select="$etymology"/>
        </xsl:call-template>
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="position">post</xsl:with-param>
              <xsl:with-param name="case"
                              select="$case"/>
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
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="position"
                              select="$position"/>
              <xsl:with-param name="case"
                              select="$case"/>
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
  <xsl:param name="index"/>
  <xsl:param name="adposition"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
    <xsl:choose>
      <xsl:when test="string-length($adposition)&gt;0">
        <xsl:call-template name="other-entry">
          <xsl:with-param name="lemma"
                          select="$adposition"/>
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="form"
                          select="$lemma"/>
          <xsl:with-param name="class">
            <xsl:call-template name="contracted-adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="clitic"
                              select="replace($lemma,'^.+(.)$','$1')"/>
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
          <xsl:with-param name="index"
                          select="$index"/>
          <xsl:with-param name="class">
            <xsl:call-template name="contracted-adposition-class">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="clitic"
                              select="replace($lemma,'^.+(.)$','$1')"/>
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
  <xsl:param name="index"/>
  <xsl:param name="type"/>
  <xsl:param name="etymology"/>
  <xsl:if test="string-length($lemma)&gt;0">
  <xsl:call-template name="other-entry">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
    <xsl:with-param name="index"
                    select="$index"/>
    <xsl:with-param name="class">
      <xsl:call-template name="conjunction-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="type"
                        select="$type"/>
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="etymology"
                    select="$etymology"/>
  </xsl:call-template>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for the following part-of-speech categories:
* <ABBR> -->
