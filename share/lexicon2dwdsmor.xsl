<?xml version="1.0" encoding="utf-8"?>
<!-- lexicon2dwdsmor.xsl -->
<!-- Version 19.5 -->
<!-- Andreas Nolda 2026-01-09 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="categories.xsl"/>

<xsl:include href="entries.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

<!-- usage: key('entry-by-lemma',concat($lemma,'/',$pos,':',$type)) -->
<xsl:key name="entry-by-lemma"
         match="entry"
         use="concat(@lemma,'/',@pos,':',@type)"/>

<xsl:template match="/">
  <xsl:apply-templates select="lexicon/entry"/>
</xsl:template>

<!-- adjectives -->
<xsl:template match="entry[@pos='adjective']
                          [@type='base']">
  <xsl:variable name="pronunciations"
                select="tokenize(@pronunciations,'&#x20;')"/>
  <xsl:choose>
    <!-- abbreviated adjectives ("ff.") -->
    <xsl:when test="@abbreviation='yes'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">ADJ</xsl:with-param>
        <xsl:with-param name="class">AbbrAdj</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- predicative-only adjectives -->
    <xsl:when test="@function='nonattr'">
      <xsl:choose>
        <!-- predicative-only adjectives with a final schwa-syllable -->
        <xsl:when test="ends-with(@lemma,'e') and
                        n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="n:segment-from-end('e',@lemma)"/>
            <xsl:with-param name="stem"
                            select="replace(@lemma,'e$','')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPosPred-e</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- other predicative-only adjectives -->
        <xsl:otherwise>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPosPred</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- uninflected adjectives -->
    <xsl:when test="@inflection='no'">
      <xsl:choose>
        <!-- attributive-only location adjectives -->
        <xsl:when test="matches(@lemma,'^\p{Lu}.*er$')">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPosAttrSubst0</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- other attributive-only uninflected adjectives -->
        <xsl:when test="@function='attr'">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPosAttr0</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- other uninflected adjectives with a final schwa-syllable -->
        <xsl:when test="ends-with(@lemma,'e') and
                        n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="n:segment-from-end('e',@lemma)"/>
            <xsl:with-param name="stem"
                            select="replace(@lemma,'e$','')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos0-e</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- other uninflected adjectives -->
        <xsl:otherwise>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos0</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
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
                          select="@positive"/>
          <xsl:with-param name="lemma"
                          select="@lemma"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="comparative-marker">
        <xsl:call-template name="get-nominal-marker">
          <xsl:with-param name="form"
                          select="@comparative"/>
          <xsl:with-param name="lemma"
                          select="@lemma"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="superlative-marker">
        <xsl:call-template name="get-nominal-marker">
          <xsl:with-param name="form"
                          select="substring-after(@superlative,'am ')"/>
          <xsl:with-param name="lemma"
                          select="@lemma"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <!-- attributive-only adjectives -->
        <xsl:when test="@function='attr'">
          <xsl:choose>
            <!-- attributive-only adjectives with a final schwa-syllable -->
            <xsl:when test="ends-with(@lemma,'e') and
                            n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="lemma"
                                select="n:segment-from-end('e',@lemma)"/>
                <xsl:with-param name="stem"
                                select="replace(@lemma,'e$','')"/>
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="ends-with(@lemma,'ler') and
                            n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPosAttr-ler</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="ends-with(@lemma,'er') and
                            n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPosAttr-er</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- other attributive-only adjectives -->
            <xsl:otherwise>
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">ADJ</xsl:with-param>
                <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <!-- As a matter of fact, there are no comparative forms. -->
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSupAttr_est</xsl:when>
                  <xsl:otherwise>AdjSupAttr_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- adjectives with a final schwa-syllable -->
        <xsl:when test="ends-with(@lemma,'e') and
                        n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="n:segment-from-end('e',@lemma)"/>
            <xsl:with-param name="stem"
                            select="replace(@lemma,'e$','')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos-e</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="n:segment-from-end('e',@lemma)"/>
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="n:segment-from-end('e',@lemma)"/>
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="ends-with(@lemma,'el') and
                        n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos-el</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp-el_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="ends-with(@lemma,'en') and
                        n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos-en</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp-en_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="ends-with(@lemma,'er') and
                        n:is-adjective-with-final-schwa-syllable(@lemma,$pronunciations)">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos-er</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp-er_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- adjectives with irregular positive forms -->
        <xsl:when test="string-length(@positive)&gt;0 and
                        not(matches($positive-marker,'^&#x308;?-e$'))">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPosPred</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="stem"
                            select="replace(@positive,'e$','')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- adjectives with the uninflected comparative form "mehr" or "weniger" -->
        <xsl:when test="@comparative='mehr' or
                        @comparative='weniger'">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos0-viel</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="stem"
                            select="@comparative"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjComp0</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- adjectives with irregular comparative forms -->
        <xsl:when test="ends-with(@comparative,'er') and
                        not(matches($comparative-marker,'^&#x308;?-'))">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="stem"
                            select="replace(@comparative,'er$','')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjComp_er</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- adjectives with irregular superlative forms -->
        <xsl:when test="ends-with(@superlative,'sten') and
                        not(matches($superlative-marker,'^&#x308;?-'))">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="stem"
                            select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">
              <xsl:choose>
                <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                <xsl:otherwise>AdjSup_st</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- adjectives with word-internal comparative and superlative markers -->
        <xsl:when test="string-length(@comparative)&gt;0 and
                        string-length(@superlative)&gt;0 and
                        not(matches($comparative-marker,'^&#x308;?-')) and
                        not(matches($superlative-marker,'^&#x308;?-'))">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="@comparative"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="replace(@superlative,'^(am )?(.+)$','$2')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- adjectives superlative forms only: -->
        <xsl:when test="matches(@lemma,'^aller.+st$') and
                        @superlative=concat('am ',@lemma,'en')">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="lemma"
                            select="n:segment-from-end('st',@lemma)"/>
            <xsl:with-param name="stem"
                            select="replace(@superlative,'^am (aller.*?[aeiouäöü].*?)e?sten$','$1')"/>
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">
              <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am aller.*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <!-- adjectives without comparative forms: -->
        <xsl:when test="string-length(@comparative)=0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@superlative,'sten')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">
                <xsl:choose>
                  <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdjSup_est</xsl:when>
                  <xsl:otherwise>AdjSup_st</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- adjectives without superlative forms: -->
        <xsl:when test="string-length(@superlative)=0">
          <xsl:call-template name="stem-entry">
            <xsl:with-param name="pos">ADJ</xsl:with-param>
            <xsl:with-param name="class">AdjPos</xsl:with-param>
          </xsl:call-template>
          <xsl:if test="ends-with(@comparative,'er')">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="stem"
                              select="replace(@comparative,'er$','')"/>
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class">AdjComp_er</xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- other adjectives -->
        <xsl:otherwise>
          <xsl:variable name="class">
            <xsl:call-template name="adjective-class"/>
          </xsl:variable>
          <xsl:if test="string-length($class)&gt;0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="pos">ADJ</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- compounding stems of adjectives -->
<xsl:template match="entry[@pos='adjective']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='adjective']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="pos">ADJ</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of adjectives -->
<xsl:template match="entry[@pos='adjective']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='adjective']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="der-stem-entry">
        <xsl:with-param name="pos">ADJ</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- articles -->
<xsl:template match="entry[@pos='article']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- "die" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='die'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('ie',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">ART</xsl:with-param>
        <xsl:with-param name="subcat">Def</xsl:with-param>
        <xsl:with-param name="class">ArtDef</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='der'"/>
    <xsl:when test="@lemma='das'"/>
    <!-- "eine", "'ne" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='eine'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">ART</xsl:with-param>
        <xsl:with-param name="subcat">Indef</xsl:with-param>
        <xsl:with-param name="class">ArtIndef</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem">’n</xsl:with-param>
        <xsl:with-param name="abbreviation">yes</xsl:with-param>
        <xsl:with-param name="pos">ART</xsl:with-param>
        <xsl:with-param name="subcat">Indef</xsl:with-param>
        <xsl:with-param name="class">ArtIndef-n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='ein'"/>
    <!-- "keine" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='keine'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">ART</xsl:with-param>
        <xsl:with-param name="subcat">Neg</xsl:with-param>
        <xsl:with-param name="class">ArtNeg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='kein'"/>
  </xsl:choose>
</xsl:template>

<!-- cardinals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='cardinal']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- "eine" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='eine'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="class">Card-ein</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='ein'"/>
    <!-- "keine" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='keine'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="class">Card-kein</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='kein'"/>
    <!-- "zwei", "drei" -->
    <xsl:when test="@lemma='zwei' or
                    @lemma='drei'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="class">Card-zwei</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "vier", "fünf", "sechs", "acht", "neun", "zehn", "elf", "zwölf" -->
    <xsl:when test="@lemma='vier' or
                    @lemma='fünf' or
                    @lemma='sechs' or
                    @lemma='acht' or
                    @lemma='neun' or
                    @lemma='zehn' or
                    @lemma='elf' or
                    @lemma='zwölf'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="class">Card-vier</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "sieben" -->
    <xsl:when test="@lemma='sieben'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="class">Card-sieben</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="class">Card0</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- compounding stems of cardinals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='cardinal']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='numeral']
                                            [@subcat='cardinal']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of cardinals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='cardinal']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='numeral']
                                            [@subcat='cardinal']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="der-stem-entry">
        <xsl:with-param name="pos">CARD</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- ordinals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='ordinal']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="stem-entry">
    <xsl:with-param name="lemma"
                    select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
    <xsl:with-param name="pos">ORD</xsl:with-param>
    <xsl:with-param name="class">Ord</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- compounding stems of ordinals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='ordinal']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='numeral']
                                            [@subcat='ordinal']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="pos">ORD</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of ordinals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='ordinal']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='numeral']
                                            [@subcat='ordinal']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="der-stem-entry">
        <xsl:with-param name="pos">ORD</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- fractional numerals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='fractional']
                          [@type='base']">
  <xsl:call-template name="stem-entry">
    <xsl:with-param name="pos">FRAC</xsl:with-param>
    <xsl:with-param name="class">Frac0</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- compounding stems of fractional numerals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='fractional']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='numeral']
                                            [@subcat='fractional']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="pos">FRAC</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of fractional numerals -->
<xsl:template match="entry[@pos='numeral']
                          [@subcat='fractional']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='numeral']
                                            [@subcat='fractional']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="der-stem-entry">
        <xsl:with-param name="pos">FRAC</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- proper names -->
<xsl:template match="entry[@pos='name']
                          [@type='base']">
  <xsl:variable name="genitive-singular-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="@genitive-singular"/>
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- proper names with meta-markers -->
    <!-- genitive singular: "-(s)" -->
    <xsl:when test="$genitive-singular-marker='-(s)'">
      <xsl:variable name="class1">
        <xsl:call-template name="name-class">
          <xsl:with-param name="genitive-singular">-s</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="class2">
        <xsl:call-template name="name-class">
          <xsl:with-param name="genitive-singular">-</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class1)&gt;0 and
                    string-length($class2)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class1"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class2"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- other proper names -->
    <xsl:otherwise>
      <xsl:variable name="class">
        <xsl:call-template name="name-class"/>
      </xsl:variable>
      <xsl:if test="string-length($class)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NPROP</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- compounding stems of proper names -->
<xsl:template match="entry[@pos='name']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='name']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="pos">NPROP</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of proper names -->
<xsl:template match="entry[@pos='name']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='name']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="der-stem-entry">
        <xsl:with-param name="pos">NPROP</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- nouns -->
<xsl:template match="entry[@pos='noun']
                          [@type='base']">
  <xsl:variable name="genitive-singular-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="@genitive-singular"/>
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nominative-plural-marker">
    <xsl:call-template name="get-nominal-marker">
      <xsl:with-param name="form"
                      select="@nominative-plural"/>
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- measure nouns -->
    <!-- masculine measure nouns -->
    <!-- genitive singular: "-(e)s"
         nominative plural: "-" -->
    <xsl:when test="@noun-type='measure-noun' and
                    @gender='masculine' and
                    ($genitive-singular-marker='-(e)s' or
                     $genitive-singular-marker='-es') and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMasc-Meas_es</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- genitive singular: "-s"
         nominative plural: "-" -->
    <xsl:when test="@noun-type='measure-noun' and
                    @gender='masculine' and
                    ($genitive-singular-marker='-(s)' or
                     $genitive-singular-marker='-s') and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMasc-Meas_s</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- neuter measure nouns -->
    <!-- genitive singular: "-(e)s"
         nominative plural: "-" -->
    <xsl:when test="@noun-type='measure-noun' and
                    @gender='neuter' and
                    ($genitive-singular-marker='-(e)s' or
                     $genitive-singular-marker='-es') and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut-Meas_es</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- genitive singular: "-s"
         nominative plural: "-" -->
    <xsl:when test="@noun-type='measure-noun' and
                    @gender='neuter' and
                    ($genitive-singular-marker='-(s)' or
                     $genitive-singular-marker='-s') and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut-Meas_s</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- feminine measure nouns -->
    <!-- genitive singular: "-"
         nominative plural: "-" -->
    <xsl:when test="@noun-type='measure-noun' and
                    @gender='feminine' and
                    $genitive-singular-marker='-' and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NFem-Meas</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- nouns with suppletive plural -->
    <!-- lemma: "Bau"
         nominative plural: "Bauten" -->
    <xsl:when test="@gender='masculine' and
                    @lemma='Bau' and
                    $nominative-plural-marker='-ten'">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="concat(@lemma,'t&lt;SB&gt;en')"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMasc|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: compound with "Bau"
         nominative plural: compound with "Bauten" -->
    <xsl:when test="@gender='masculine' and
                    ends-with(@lemma,'bau') and
                    $nominative-plural-marker='-ten'">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="concat(@lemma,'t&lt;SB&gt;en')"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMasc|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: "Vieh"
         nominative plural: "Viecher" (coll.) -->
    <xsl:when test="@gender='neuter' and
                    @lemma='Vieh' and
                    @nominative-plural='Viecher'">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="n:segment-from-end('er',@nominative-plural)"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut|PlNonSt_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: compound with "Vieh"
         nominative plural: compound with "Viecher" (coll.) -->
    <xsl:when test="@gender='neuter' and
                    ends-with(@lemma,'vieh') and
                    @nominative-plural=replace(@lemma,'vieh$','viecher')">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="n:segment-from-end('er',@nominative-plural)"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut|PlNonSt_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: "Praxis"
         nominative plural: "Praktiken" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='Praxis' and
                    @nominative-plural='Praktiken'">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="n:segment-from-end('en',@nominative-plural)"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NFem|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: compound with "Praxis"
         nominative plural: compound with "Praktiken" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'praxis') and
                    ends-with(@nominative-plural,'praktiken')">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="n:segment-from-end('en',@nominative-plural)"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NFem|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: borrowed compound with "man"
         nominative plural: borrowed compound with "men" -->
    <xsl:when test="@gender='masculine' and
                    ends-with(@lemma,'man') and
                    @nominative-plural=replace(@lemma,'man$','men')">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="@nominative-plural"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMasc|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: borrowed compound with "woman"
         nominative plural: borrowed compound with "women" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'woman') and
                    @nominative-plural=replace(@lemma,'woman$','women')">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="@nominative-plural"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NFem|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: borrowed compound of "singulare" or "plurale" with "tantum"
         nominative plural: borrowed compound of "singularia" or "pluralia" with "tantum" -->
    <xsl:when test="@gender='neuter' and
                    ends-with(@lemma,'etantum') and
                    @nominative-plural=replace(@lemma,'etantum$','iatantum')">
      <xsl:call-template name="apply-templates-to-singular"/>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="@nominative-plural"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut|Pl_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: borrowed feminine nouns ending in "a"
         nominative plural: "-e" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'a') and
                    $nominative-plural-marker='-e'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NFem_0_e_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- nouns with extra-paradigmatic plural -->
    <!-- lemma: compound with "Mann"
         nominative plural: compound with "Leute" -->
    <xsl:when test="@gender='masculine' and
                    ends-with(@lemma,'mann') and
                    @nominative-plural=replace(@lemma,'mann$','leute')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="@nominative-plural"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NUnmGend|Pl_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: compound with "Frau"
         nominative plural: compound with "Leute" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'frau') and
                    @nominative-plural=replace(@lemma,'frau$','leute')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="@nominative-plural"/>
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NUnmGend|Pl_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- nouns with meta-markers -->
    <!-- genitive singular: "-(s)"
         nominative plural: "-(s)" -->
    <xsl:when test="$genitive-singular-marker='-(s)' and
                    $nominative-plural-marker='-(s)'">
      <xsl:variable name="class1">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="genitive-singular">-s</xsl:with-param>
          <xsl:with-param name="nominative-plural">-</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="class2">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="genitive-singular">-</xsl:with-param>
          <xsl:with-param name="nominative-plural">-s</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class1)&gt;0 and
                    string-length($class2)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class1"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class2"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- genitive singular: "-(s)" -->
    <xsl:when test="$genitive-singular-marker='-(s)'">
      <xsl:variable name="class1">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="genitive-singular">-s</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="class2">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="genitive-singular">-</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class1)&gt;0 and
                    string-length($class2)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class1"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class2"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- nominative plural: "-(s)" -->
    <xsl:when test="$nominative-plural-marker='-(s)'">
      <xsl:variable name="class1">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="nominative-plural">-s</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="class2">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="nominative-plural">-</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class1)&gt;0 and
                    string-length($class2)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class1"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class2"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- nominative plural: "-(e)s" -->
    <xsl:when test="$nominative-plural-marker='-(e)s'">
      <xsl:variable name="class1">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="nominative-plural">-es</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="class2">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="nominative-plural">-s</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class1)&gt;0 and
                    string-length($class2)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class1"/>
        </xsl:call-template>
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class2"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- nominative plural: "-e(n)" -->
    <xsl:when test="$nominative-plural-marker='-e(n)'">
      <xsl:choose>
        <!-- weak nouns -->
        <xsl:when test="$genitive-singular-marker='-en'">
          <xsl:variable name="class">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="nominative-plural">-en</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="string-length($class)&gt;0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="pos">NN</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- other nouns -->
        <xsl:otherwise>
          <xsl:variable name="class1">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="nominative-plural">-en</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="class2">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="nominative-plural">-e</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="string-length($class1)&gt;0 and
                        string-length($class2)&gt;0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="pos">NN</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class1"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="pos">NN</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class2"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- nominative plural: "-(n)" -->
    <xsl:when test="$nominative-plural-marker='-(n)'">
      <xsl:choose>
        <!-- nominalised adjectives with plural forms -->
        <xsl:when test="$genitive-singular-marker='-n'">
          <xsl:variable name="class">
            <xsl:call-template name="noun-class"/>
          </xsl:variable>
          <xsl:if test="string-length($class)&gt;0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="lemma"
                              select="n:segment-from-end('e',@lemma)"/>
              <xsl:with-param name="stem"
                              select="replace(@lemma,'e$','')"/>
              <xsl:with-param name="pos">NN</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <!-- other nouns -->
        <xsl:otherwise>
          <xsl:variable name="class1">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="nominative-plural">-n</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="class2">
            <xsl:call-template name="noun-class">
              <xsl:with-param name="nominative-plural">-</xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="string-length($class1)&gt;0 and
                        string-length($class2)&gt;0">
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="pos">NN</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class1"/>
            </xsl:call-template>
            <xsl:call-template name="stem-entry">
              <xsl:with-param name="pos">NN</xsl:with-param>
              <xsl:with-param name="class"
                              select="$class2"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- nominalised adjectives without plural forms -->
    <xsl:when test="$genitive-singular-marker='-n' and
                    @number='singular'">
      <xsl:variable name="class">
        <xsl:choose>
          <xsl:when test="@gender='neuter' and
                          @lemma='Innere'">NNeut-Inner</xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="noun-class"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="string-length($class)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="n:segment-from-end('e',@lemma)"/>
          <xsl:with-param name="stem"
                          select="replace(@lemma,'e$','')"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- abbreviated nouns without markers -->
    <xsl:when test="string-length($genitive-singular-marker)=0 and
                    string-length($nominative-plural-marker)=0 and
                    @abbreviation='yes'">
      <xsl:choose>
        <!-- acronyms in uppercase letters or
             acronyms consisting of an uppercase consonant letter
             followed by lowercase consonant letters -->
        <xsl:when test="matches(@lemma,'^\p{Lu}+$') or
                        matches(@lemma,'^[\p{Lu}-[AEIOUÄÖÜ]][\p{Ll}-[aeiouäöü]]+$')">
          <xsl:choose>
            <!-- masculine acronyms ("PC", "Pkw") -->
            <xsl:when test="@gender='masculine'">
              <xsl:choose>
                <xsl:when test="@number='singular'">
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NMasc|Sg_s</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NMasc|Sg_0</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NMasc_s_s_0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NMasc_0_0_0</xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- neuter acronyms ("WC") -->
            <xsl:when test="@gender='neuter'">
              <xsl:choose>
                <xsl:when test="@number='singular'">
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NNeut|Sg_s</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NNeut|Sg_0</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NNeut_s_s_0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NNeut_0_0_0</xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- feminine acronyms ("WG") -->
            <xsl:when test="@gender='feminine'">
              <xsl:choose>
                <xsl:when test="@number='singular'">
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NFem|Sg_0</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NFem_0_s_0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="stem-entry">
                    <xsl:with-param name="pos">NN</xsl:with-param>
                    <xsl:with-param name="class">NFem_0_0_0</xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- pluralia-tantum acronyms -->
            <xsl:when test="@number='plural'">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class">NUnmGend|Pl_0</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <!-- other abbreviated nouns -->
        <xsl:otherwise>
          <xsl:choose>
            <!-- abbreviated masculine nouns ("Prof.", "km", "§") -->
            <xsl:when test="@gender='masculine'">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class">AbbrNMasc</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- abbreviated neuter nouns ("Tel.", "kg", "°") -->
            <xsl:when test="@gender='neuter'">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class">AbbrNNeut</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- abbreviated feminine nouns ("Nr.", "min", "′") -->
            <xsl:when test="@gender='feminine'">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class">AbbrNFem</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- abbreviated pluralia tantum ("Gebr.", "§§") -->
            <xsl:when test="@number='plural'">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="pos">NN</xsl:with-param>
                <xsl:with-param name="class">AbbrNUnmGend</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- special cases -->
    <!-- lemma: "Regime" (with unpronounced final "e")
         nominative plural: unmarked (with pronounced final schwa) -->
    <xsl:when test="@gender='neuter' and
                    @lemma='Regime' and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut_s_0_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: compound with "Regime" (with unpronounced final "e")
         nominative plural: unmarked (with pronounced final schwa) -->
    <xsl:when test="@gender='neuter' and
                    ends-with(@lemma,'regime') and
                    $nominative-plural-marker='-'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeut_s_0_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- lemma: compound of "Elektro" with a stem with initial "o" -->
    <xsl:when test="matches(@lemma,'Elektroo[^aouäöü-]*$')">
      <!-- prevent "oo" from being considered as geminate "o" by umlaut functions -->
      <xsl:variable name="class">
        <xsl:call-template name="noun-class">
          <xsl:with-param name="lemma"
                          select="replace(@lemma,'(Elektro)(o[^aouäöü-]*)$','$1&lt;CB&gt;$2')"/>
          <xsl:with-param name="genitive-singular"
                          select="replace(@genitive-singular,'(Elektro)(o[^aouäöü-]*)$','$1&lt;CB&gt;$2')"/>
          <xsl:with-param name="nominative-plural"
                          select="replace(@nominative-plural,'(Elektro)([oö][^aouäöü-]*)$','$1&lt;CB&gt;$2')"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="replace(@lemma,'(Elektro)(o[^aouäöü-]*)$','$1&lt;CB&gt;$2')"/>
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- colloquial variants of masculine nouns -->
    <!-- genitive singular: "-s"
         nominative plural: "-en" -->
    <xsl:when test="@gender='masculine' and
                    $genitive-singular-marker='-s' and
                    $nominative-plural-marker='-en' and
                    @style='colloquial'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMascNonSt_s_en_0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- genitive singular: "-"
         nominative plural: geminate "s" + "-e" -->
    <xsl:when test="@gender='masculine' and
                    $genitive-singular-marker='-' and
                    $nominative-plural-marker='-se' and
                    @style='colloquial'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMascNonSt_0_e_n~ss</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- genitive singular: geminate "s" + "-es"
         nominative plural: geminate "s" + "-e" -->
    <xsl:when test="@gender='masculine' and
                    $genitive-singular-marker='-ses' and
                    $nominative-plural-marker='-se' and
                    @style='colloquial'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMascNonSt_es_e_n~ss</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- genitive singular: "-(e)s"
         nominative plural: umlaut and "-er" -->
    <xsl:when test="@gender='masculine' and
                    ($genitive-singular-marker='-(e)s' or
                     $genitive-singular-marker='-es') and
                    $nominative-plural-marker='&#x308;-er' and
                    @style='colloquial'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NMascNonSt_es_$er_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- colloquial variants of neuter nouns -->
    <!-- genitive singular: "-(e)s"
         nominative plural: "-er" -->
    <xsl:when test="@gender='neuter' and
                    ($genitive-singular-marker='-(e)s' or
                     $genitive-singular-marker='-es') and
                    $nominative-plural-marker='-er' and
                    @style='colloquial'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeutNonSt_es_er_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- genitive singular: "-(e)s"
         nominative plural: umlaut and "-er" -->
    <xsl:when test="@gender='neuter' and
                    ($genitive-singular-marker='-(e)s' or
                     $genitive-singular-marker='-es') and
                    $nominative-plural-marker='&#x308;-er' and
                    @style='colloquial'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="class">NNeutNonSt_es_$er_n</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- other nouns -->
    <xsl:otherwise>
      <xsl:variable name="class">
        <xsl:call-template name="noun-class"/>
      </xsl:variable>
      <xsl:if test="string-length($class)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="pos">NN</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- compounding stems of nouns -->
<xsl:template match="entry[@pos='noun']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='noun']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="comp-stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of nouns -->
<xsl:template match="entry[@pos='noun']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='noun']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="der-stem-entry">
        <xsl:with-param name="pos">NN</xsl:with-param>
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- demonstrative pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='demonstrative']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- "diese", "ebendiese" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'diese')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">Dem-dies</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ends-with(@lemma,'dieser')"/>
    <xsl:when test="ends-with(@lemma,'dieses')"/>
    <!-- "jene", "ebenjene" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'jene')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">Dem</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ends-with(@lemma,'jener')"/>
    <xsl:when test="ends-with(@lemma,'jenes')"/>
    <!-- "die", "ebendie" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'die')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('ie',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">DemDef</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ends-with(@lemma,'der')"/>
    <xsl:when test="ends-with(@lemma,'das')"/>
    <!-- "solche", "ebensolche" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'solche')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">Dem-solch</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ends-with(@lemma,'solcher')"/>
    <xsl:when test="ends-with(@lemma,'solches')"/>
    <!-- "diejenige" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='diejenige'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','der$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-der+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','den$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-den+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','dem$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-dem+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','des$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-des+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','das$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-das+DemNeut</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','dem$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-dem+DemNeut</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','des$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-des+DemNeut</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','die$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-die+DemFem</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','der$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-der+DemFem</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','die$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-die+DemUnmGend</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','den$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-den+DemUnmGend</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^die(jenig)e$','der$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-der+DemUnmGend</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='derjenige'"/>
    <xsl:when test="@lemma='dasjenige'"/>
    <!-- "dieselbe", "dieselbige" "ebendieselbe", "höchstdieselbe" -->
    <xsl:when test="@gender='feminine' and
                    (ends-with(@lemma,'dieselbe') or
                     @lemma='dieselbige')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','der$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-der+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','den$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-den+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','dem$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-dem+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','des$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-des+DemMasc</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','das$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-das+DemNeut</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','dem$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-dem+DemNeut</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','des$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-des+DemNeut</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','die$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-die+DemFem</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','der$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-der+DemFem</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','die$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-die+DemUnmGend</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','den$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-den+DemUnmGend</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'die(selb(ig)?)e$','der$1')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">ArtDef-der+DemUnmGend</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ends-with(@lemma,'derselbe') or
                    @lemma='derselbige'"/>
    <xsl:when test="ends-with(@lemma,'dasselbe') or
                    @lemma='dasselbige'"/>
    <!-- "alldem", "alledem" -->
    <xsl:when test="@lemma='alldem' or
                    @lemma='alledem'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@lemma,'em$','')"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">Dem-alldem</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "dergleichen", "derlei" -->
    <xsl:when test="@lemma='dergleichen' or
                    @lemma='derlei'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">DEM</xsl:with-param>
        <xsl:with-param name="class">Dem0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- indefinite pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='indefinite']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:choose>
      <xsl:when test="@gender='masculine'">
        <xsl:call-template name="masculine-stem">
          <xsl:with-param name="lemma"
                          select="@lemma"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@gender='feminine'">
        <xsl:call-template name="feminine-stem">
          <xsl:with-param name="lemma"
                          select="@lemma"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <!-- "einer", "eine"; "keiner", "keine" -->
    <xsl:when test="@gender='masculine' and
                    (@lemma='einer' or
                     @lemma='keiner')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('er',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-einer</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@gender='feminine' and
                    (@lemma='eine' or
                     @lemma='keine')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-eine</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='eines' or
                    @lemma='keines' or
                    @lemma='eins' or
                    @lemma='keins'"/>
    <!-- "irgendeine" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='irgendeine'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-irgendein</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='irgendeiner'"/>
    <xsl:when test="@lemma='irgendeines'"/>
    <!-- "welche" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='welche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-welch</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='welcher'"/>
    <xsl:when test="@lemma='welches'"/>
    <!-- "irgendwelche" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='irgendwelche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-irgendwelch</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='irgendwelcher'"/>
    <xsl:when test="@lemma='irgendwelches'"/>
    <!-- "einige" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='einige'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-einig</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='einiger'"/>
    <xsl:when test="@lemma='einiges'"/>
    <!-- "etliche" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='etliche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-einig</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='etlicher'"/>
    <xsl:when test="@lemma='etliches'"/>
    <!-- "alle" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='alle'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-all</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='aller'"/>
    <xsl:when test="@lemma='alles'"/>
    <!-- "jede" -->
    <xsl:when test="@gender='feminine' and
                    (@lemma='jede' or
                     @lemma='jedwede')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-jed</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='jeder' or
                    @lemma='jedweder'"/>
    <xsl:when test="@lemma='jedes' or
                    @lemma='jedwedes'"/>
    <!-- "jegliche" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='jegliche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-jeglich</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='jeglicher'"/>
    <xsl:when test="@lemma='jegliches'"/>
    <!-- "beide" -->
    <xsl:when test="@lemma='beide'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'e$','')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-beid</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "manche" -->
    <xsl:when test="@lemma='manche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'e$','')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-manch</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "mehrere" -->
    <xsl:when test="@lemma='mehrere'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'e$','')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-mehrer</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "sämtliche" -->
    <xsl:when test="@lemma='sämtliche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef-saemtlich</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "jedermann" -->
    <xsl:when test="@lemma='jedermann'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-jedermann</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "jedefrau" -->
    <xsl:when test="@lemma='jedefrau'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-jedefrau</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@lemma,'^jede(frau)$','jeder$1')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-jederfrau</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "man", "mensch" -->
    <xsl:when test="@lemma='man' or
                    @lemma='mensch'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-man</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "frau" -->
    <xsl:when test="@lemma='frau'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-frau</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "unsereiner" -->
    <xsl:when test="@lemma='unsereiner'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('er',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'er$','')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-unsereiner</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "unsereins" -->
    <xsl:when test="@lemma='unsereins'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IPro-unsereins</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "jemand", "irgendjemand" -->
    <xsl:when test="ends-with(@lemma,'jemand')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProMasc</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "niemand" -->
    <xsl:when test="@lemma='niemand'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProMasc</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "etwas", "ebbes", "irgendetwas" -->
    <xsl:when test="ends-with(@lemma,'etwas') or
                    @lemma='ebbes'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProNeut</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "was", "irgendwas", "sonstwas" -->
    <xsl:when test="ends-with(@lemma,'was')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProNeutNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProNeutAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProNeutDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@lemma,'was$','wes')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProNeutGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "wer", "irgendwer", "sonstwer" -->
    <xsl:when test="ends-with(@lemma,'wer')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProMascNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@lemma,'wer$','wen')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProMascAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@lemma,'wer$','wem')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProMascDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@lemma,'wer$','wes')"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProMascGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "nichts", "nischt", "nix" -->
    <xsl:when test="@lemma='nichts' or
                    @lemma='nischt' or
                    @lemma='nix'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">IProNeut</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "bisschen" -->
    <xsl:when test="@lemma='bisschen'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "paar" -->
    <xsl:when test="@lemma='paar'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "genug" -->
    <xsl:when test="@lemma='genug'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "allerlei", "beiderlei" -->
    <xsl:when test="@lemma='allerlei' or
                    @lemma='beiderlei'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">INDEF</xsl:with-param>
        <xsl:with-param name="class">Indef0</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- interrogative pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='interrogative']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- "was" -->
    <xsl:when test="@lemma='was'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProNeutNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProNeutAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProNeutDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wes</xsl:with-param>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProNeutGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "wer" -->
    <xsl:when test="@lemma='wer'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProMascNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wen</xsl:with-param>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProMascAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wem</xsl:with-param>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProMascDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wes</xsl:with-param>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">WProMascGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "welche" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='welche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">WPRO</xsl:with-param>
        <xsl:with-param name="class">W-welch</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='welcher'"/>
    <xsl:when test="@lemma='welches'"/>
  </xsl:choose>
</xsl:template>

<!-- personal pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='personal']
                          [@type='base']">
  <xsl:choose>
    <!-- "du" -->
    <xsl:when test="@lemma='du'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2NomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">dich</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2AccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">dir</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2DatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">dein</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2GenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "Du" -->
    <xsl:when test="@lemma='Du'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2NomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Dich</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2AccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Dir</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2DatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Dein</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2GenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "er" -->
    <xsl:when test="@gender='masculine' and
                    @lemma='er'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProMascNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihn</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProMascAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihm</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProMascDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">sein</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProMascGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "es", "'s" -->
    <xsl:when test="@gender='neuter' and
                    @lemma='es'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProNeutNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma">es</xsl:with-param>
        <xsl:with-param name="stem">’s</xsl:with-param>
        <xsl:with-param name="abbreviation">yes</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProNeutNomSg-s</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProNeutAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma">es</xsl:with-param>
        <xsl:with-param name="stem">’s</xsl:with-param>
        <xsl:with-param name="abbreviation">yes</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProNeutAccSg-s</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihm</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProNeutDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">sein</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProNeutGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "ich" -->
    <xsl:when test="@lemma='ich'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1NomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">mich</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1AccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">mir</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1DatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">mein</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1GenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "ihr" -->
    <xsl:when test="@lemma='ihr'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2NomPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">euch</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2AccPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">euch</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2DatPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">eu</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2GenPl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "Ihr" -->
    <xsl:when test="@lemma='Ihr'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2NomPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Euch</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2AccPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Euch</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2DatPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Eu</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro2GenPl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "sie" (singular) -->
    <xsl:when test="@gender='feminine' and
                    @lemma='sie'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProFemNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProFemAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihr</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProFemDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihr</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProFemGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "sie" (plural) -->
    <xsl:when test="@lemma='sie'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendNomPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendAccPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihnen</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendDatPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">ihr</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendGenPl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "Sie" -->
    <xsl:when test="@lemma='Sie'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendNomPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendAccPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Ihnen</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendDatPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Ihr</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PProUnmGendGenPl</xsl:with-param>
      </xsl:call-template><!-- ? -->
    </xsl:when>
    <!-- "wir" -->
    <xsl:when test="@lemma='wir'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1NomPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">uns</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1AccPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">uns</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1DatPl</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">uns</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Pers</xsl:with-param>
        <xsl:with-param name="class">PPro1GenPl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- reflexive pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='reflexive']
                          [@type='base']">
  <xsl:choose>
    <!-- "dich" -->
    <xsl:when test="@lemma='dich'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl2AccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">dir</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl2DatSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "Dich" -->
    <xsl:when test="@lemma='Dich'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl2AccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">Dir</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl2DatSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "euch" -->
    <xsl:when test="@lemma='euch'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl2Pl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "Euch" -->
    <xsl:when test="@lemma='Euch'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl2Pl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "mich" -->
    <xsl:when test="@lemma='mich'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl1AccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">mir</xsl:with-param>
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl1DatSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "sich" -->
    <xsl:when test="@lemma='sich'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl3</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "uns" -->
    <xsl:when test="@lemma='uns'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PPRO</xsl:with-param>
        <xsl:with-param name="subcat">Refl</xsl:with-param>
        <xsl:with-param name="class">PRefl1Pl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- reciprocal pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='reciprocal']
                          [@type='base']">
  <xsl:if test="@lemma='einander'">
    <xsl:call-template name="stem-entry">
      <xsl:with-param name="pos">PPRO</xsl:with-param>
      <xsl:with-param name="subcat">Rec</xsl:with-param>
      <xsl:with-param name="class">PRecPl</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- possessive pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='possessive']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- abbreviated possessive pronouns ("Ew.") -->
    <xsl:when test="@abbreviation='yes'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">AbbrPoss</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "meine", "deine", "seine" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'eine')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ends-with(@lemma,'ein')"/>
    <!-- "ihre", "Ihre" -->
    <xsl:when test="@gender='feminine' and
                    (@lemma='ihre' or
                     @lemma='Ihre')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='ihr' or
                    @lemma='Ihr'"/>
    <!-- "unsere" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='unsere'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss-er</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='unser'"/>
    <!-- "eure", "Eure" -->
    <xsl:when test="@gender='feminine' and
                    (@lemma='eure' or
                     @lemma='Eure')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'re$','er')"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss-er</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='euer' or
                    @lemma='Euer'"/>
    <!-- "meinige", "deinige", "seinige" -->
    <xsl:when test="@gender='feminine' and
                    ends-with(@lemma,'einige')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss|Wk</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "ihrige", "Ihrige" -->
    <xsl:when test="@gender='feminine' and
                    (@lemma='ihrige' or
                     @lemma='Ihrige')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss|Wk</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "unsrige" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='unsrige'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'rige$','erig')"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss|Wk-er</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "eurige", "Eurige" -->
    <xsl:when test="@gender='feminine' and
                    (@lemma='eurige' or
                     @lemma='Eurige')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="replace(@lemma,'rige$','erig')"/>
        <xsl:with-param name="pos">POSS</xsl:with-param>
        <xsl:with-param name="class">Poss|Wk-er</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- relative pronouns -->
<xsl:template match="entry[@pos='pronoun']
                          [@subcat='relative']
                          [@type='base']">
  <xsl:variable name="stem">
    <xsl:call-template name="feminine-stem">
      <xsl:with-param name="lemma"
                      select="@lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <!-- "die" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='die'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('ie',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">Rel</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='der'"/>
    <xsl:when test="@lemma='das'"/>
    <!-- "was" -->
    <xsl:when test="@lemma='was'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProNeutNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProNeutAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProNeutDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wes</xsl:with-param>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProNeutGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "wer" -->
    <xsl:when test="@lemma='wer'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProMascNomSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wen</xsl:with-param>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProMascAccSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wem</xsl:with-param>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProMascDatSg</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem">wes</xsl:with-param>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">RProMascGenSg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- "welche" -->
    <xsl:when test="@gender='feminine' and
                    @lemma='welche'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="n:segment-from-end('e',@lemma)"/>
        <xsl:with-param name="stem"
                        select="$stem"/>
        <xsl:with-param name="pos">REL</xsl:with-param>
        <xsl:with-param name="class">Rel-welch</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@lemma='welcher'"/>
    <xsl:when test="@lemma='welches'"/>
  </xsl:choose>
</xsl:template>

<!-- verbs -->
<xsl:template match="entry[@pos='verb']
                          [@type='base']">
  <xsl:choose>
    <!-- abbreviated verbs ("vgl.") -->
    <xsl:when test="@abbreviation='yes'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">V</xsl:with-param>
        <xsl:with-param name="class">AbbrVImp</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <!-- uninflected verbs (infinitive only) -->
        <xsl:when test="@inflection='no'">
          <xsl:variable name="stem">
            <xsl:call-template name="verb-stem">
              <xsl:with-param name="lemma"
                              select="@lemma"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <!-- borrowed uninflected verbs ending in "c", "g", or "p" + "len" -->
            <xsl:when test="matches(@lemma,'[cgp]len$')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="stem"
                                select="$stem"/>
                <xsl:with-param name="pos">V</xsl:with-param>
                <xsl:with-param name="class">VInf-le</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- uninflected verbs ending in "eln" or "ern" -->
            <xsl:when test="ends-with(@lemma,'eln') or
                            ends-with(@lemma,'ern')">
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="stem"
                                select="$stem"/>
                <xsl:with-param name="pos">V</xsl:with-param>
                <xsl:with-param name="class">VInf-el-er</xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- other uninflected verbs -->
            <xsl:otherwise>
              <xsl:call-template name="stem-entry">
                <xsl:with-param name="stem"
                                select="$stem"/>
                <xsl:with-param name="pos">V</xsl:with-param>
                <xsl:with-param name="class">VInf</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <!-- inflected verbs -->
        <xsl:otherwise>
          <xsl:variable name="particle">
            <xsl:choose>
              <xsl:when test="count(tokenize(@present,'&#x20;'))=3">
                <xsl:value-of select="substring-after(substring-after(@present,' '),' ')"/>
              </xsl:when>
              <xsl:when test="count(tokenize(@present,'&#x20;'))&lt;3">
                <xsl:value-of select="substring-after(@present,' ')"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="particle2"
                        select="substring-before(substring-after(@present,' '),' ')"/>
          <xsl:variable name="lemma-without-particle"
                        select="replace(@lemma,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
          <xsl:variable name="present-without-particle"
                        select="replace(@present,concat('^(.+?)(( ',$particle2,')? ',$particle,')?$'),'$1')"/>
          <xsl:variable name="past-without-particle"
                        select="replace(@past,concat('^(.+?)(( ',$particle2,')? ',$particle,')?$'),'$1')"/>
          <xsl:variable name="participle-without-particle"
                        select="replace(@participle,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
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
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                   <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="n:umlaut($past-stem)"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPastSubjWeak</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- borrowed verbs ending in "signen" -->
                <xsl:when test="ends-with($lemma-without-particle,'signen')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak-signen</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- borrowed verbs ending in "bi", "fa", or "li" + "ken" -->
                <xsl:when test="matches($lemma-without-particle,'(bi|fa|li)ken$')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak-ak-ik</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- borrowed verbs ending in "c", "g", or "p" + "len" -->
                <xsl:when test="matches($lemma-without-particle,'[cgp]len$')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak-le</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- regular verbs ending in consonant + "een" or "ien" -->
                <xsl:when test="matches($lemma-without-particle,'[^aeiouäöü][ei]en$')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- regular verbs with stem-final "n" or "m", preceded
                     by "b", "d", "f", "g", "k", "p", "s", "t", or "ch" -->
                <xsl:when test="matches($present-stem,'([bdfgkpst]|ch)[mn]$')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak-m-n</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- regular verbs with stem-final "s", "ß", "x", "z", or "sch" -->
                <xsl:when test="(ends-with($present-stem,'s') or
                                 ends-with($present-stem,'ß') or
                                 ends-with($present-stem,'x') or
                                 ends-with($present-stem,'z') or
                                 ends-with($present-stem,'sch'))">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VWeak-s</xsl:with-param>
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
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:if test="string-length($class)&gt;0">
                    <xsl:call-template name="verb-stem-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="particle2"
                                      select="$particle2"/>
                      <xsl:with-param name="class"
                                      select="$class"/>
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
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="replace($present-stem,'t$','')"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- "sein" -->
                <xsl:when test="$lemma-without-particle='sein'">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf_n</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem">bin</xsl:with-param>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd1Sg-sein</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="concat('b',$present-stem)"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd2Sg-sein</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="replace($present-stem,'t$','')"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd3Sg-sein</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem">sind</xsl:with-param>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd13Pl-sein</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="concat($stem,'d')"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd2Pl-sein</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresSubj-sein</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpSg0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="concat($stem,'d')"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpPl-sein</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- "tun" and related verbs -->
                <xsl:when test="$lemma-without-particle='tun' or
                                $lemma-without-particle='betun' or
                                $lemma-without-particle='vertun'">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf_n</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPres-tun</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpSg0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpPl</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- "werden" -->
                <xsl:when test="$lemma-without-particle='werden'">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="replace($present-stem,'d$','')"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd2Sg-werden</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd3Sg-werden</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp-d-t</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- preterite-present verbs with imperative forms -->
                <xsl:when test="ends-with($lemma-without-particle,'wissen')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VModPresIndSg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VModPresNonIndSg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp-m-n</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- other preterite-present verbs -->
                <xsl:when test="ends-with($lemma-without-particle,'dürfen') or
                                ends-with($lemma-without-particle,'können') or
                                ends-with($lemma-without-particle,'mögen') or
                                ends-with($lemma-without-particle,'müssen') or
                                ends-with($lemma-without-particle,'sollen') or
                                ends-with($lemma-without-particle,'wollen')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VModPresIndSg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VModPresNonIndSg</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- "sehen" -->
                <xsl:when test="$lemma-without-particle='sehen'">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpSg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpPl</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- "vgl." -->
                <xsl:when test="@lemma='vgl.'">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="abbreviation">yes</xsl:with-param>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">AbbrVImp</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- borrowed verbs ending in "bi", "fa", or "li" + "ken" -->
                <xsl:when test="matches($lemma-without-particle,'(bi|fa|li)ken$')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPres-ak-ik</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp-ak-ik</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- borrowed verbs ending in "c", "g", or "p" + "len" -->
                <xsl:when test="matches($lemma-without-particle,'[cgp]len$')">
                  <xsl:choose>
                    <!-- back-formation -->
                    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                    matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'n$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf-le</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres-le</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-le</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-le</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- no back-formation -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf-le</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres-le</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-le</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-le</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- irregular verbs ending in "eln" or "ern" -->
                <xsl:when test="ends-with($lemma-without-particle,'eln') or
                                ends-with($lemma-without-particle,'ern')">
                  <xsl:choose>
                    <!-- back-formation -->
                    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                    matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'n$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf-el-er</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres-el-er</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-el-er</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-el-er</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- no back-formation -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf-el-er</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres-el-er</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-el-er</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-el-er</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- uniform present stem with stem-final "d" or "t" -->
                <xsl:when test="$stem=$present-stem and
                                (ends-with($present-stem,'d') or
                                 ends-with($present-stem,'t'))">
                  <xsl:choose>
                    <!-- back-formation -->
                    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                    matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'en$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-d-t</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- no back-formation -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-d-t</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- uniform present stem with stem-final "n" or "m", preceded
                     by "b", "d", "f", "g", "k", "p", "s", "t", or "ch" -->
                <xsl:when test="$stem=$present-stem and
                                matches($present-stem,'([bdfgkpst]|ch)[mn]$')">
                  <xsl:choose>
                    <!-- back-formation -->
                    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                    matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'en$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-m-n</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-m-n</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- no back-formation -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-m-n</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp-m-n</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- uniform present stem with stem-final "s", "ß", "x", "z", or "sch" -->
                <xsl:when test="$stem=$present-stem and
                                (ends-with($past-stem,'s') or
                                 ends-with($past-stem,'ß') or
                                 ends-with($past-stem,'x') or
                                 ends-with($past-stem,'z') or
                                 ends-with($past-stem,'sch'))">
                  <xsl:choose>
                    <!-- back-formation -->
                    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                    matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'en$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-s</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(en)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- no back-formation -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres-s</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- uniform present stem -->
                <xsl:when test="$stem=$present-stem">
                  <xsl:choose>
                    <!-- back-formation -->
                    <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                    matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                        <xsl:with-param name="stem"
                                        select="replace($stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- no back-formation -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VInf</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPres</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VImp</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation
                     with stem-final "t" -->
                <xsl:when test="ends-with($present-stem,'t') and
                                matches($present-stem,n:e-i-alternation-re($stem))">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg-t_0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpSg0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpPl</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- other present stem for 2nd/3rd person singular with "e"/"i"-alternation -->
                <xsl:when test="matches($present-stem,n:e-i-alternation-re($stem))">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpSg0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImpPl</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- present stem for 2nd/3rd person singular with stem-final "d"
                     without "e" epenthesis before "-t" -->
                <xsl:when test="ends-with($present-stem,'d') and
                                $present-without-particle=concat($present-stem,'t')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg-d_t</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- present stem for 2nd/3rd person singular with stem-final "t" -->
                <xsl:when test="ends-with($present-stem,'t') and
                                $present-without-particle=$present-stem">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg-t_0</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp-d-t</xsl:with-param>
                  </xsl:call-template>
                </xsl:when>
                <!-- other present stem for 2nd/3rd person singular -->
                <xsl:otherwise>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VInf</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPres</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPresNonInd23Sg</xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="auxiliary"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VImp</xsl:with-param>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
              <!-- past -->
              <xsl:choose>
                <!-- weak past stem -->
                <xsl:when test="matches($past-without-particle,concat('^',$past-stem,'e?te$'))">
                  <!-- past indicative -->
                  <xsl:choose>
                    <!-- past indicative of borrowed verbs ending in "c", "g", or "p" + "let" -->
                    <xsl:when test="matches($past-without-particle,'[cgp]lete$')">
                      <xsl:choose>
                        <!-- back-formation -->
                        <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                        matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'n$'))">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                            <xsl:with-param name="stem"
                                            select="replace($past-stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastInd-le</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- no back-formation -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastInd-le</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <!-- past indicative with stem-final "d" or "t"
                         without "e" epenthesis before "-t" -->
                    <xsl:when test="matches($past-stem,'[dt]$') and
                                    $past-without-particle=concat($past-stem,'te')">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$past-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastInd-d-t_t</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- other weak past stem -->
                    <xsl:otherwise>
                      <xsl:choose>
                        <!-- back-formation -->
                        <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                        matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                            <xsl:with-param name="stem"
                                            select="replace($past-stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastIndWeak</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- no back-formation -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastIndWeak</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-- past subjunctive -->
                  <xsl:choose>
                    <!-- past indicative of borrowed verbs ending in "c", "g", or "p" + "let" -->
                    <xsl:when test="matches($past-without-particle,'[cgp]lete$')">
                      <xsl:choose>
                        <!-- back-formation -->
                        <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                        matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'n$'))">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                            <xsl:with-param name="stem"
                                            select="replace($past-stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastSubj-le</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- no back-formation -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastSubj-le</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <!-- "haben" -->
                    <xsl:when test="$lemma-without-particle='haben'">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubj-haben</xsl:with-param>
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
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjWeak</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- past stem ending in "ach" -->
                    <xsl:when test="ends-with($past-stem,'ach')">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjWeak</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- Rückumlaut -->
                    <xsl:when test="matches($present-stem,'en[dn]$') and
                                    matches($past-stem,'an[dn]$')">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$stem"/><!-- sic! -->
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjWeak</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- other weak past stem -->
                    <xsl:otherwise>
                      <xsl:choose>
                        <!-- back-formation -->
                        <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                        matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                            <xsl:with-param name="stem"
                                            select="replace($past-stem,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')$'),'$1&lt;CB&gt;$2')"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastSubjWeak</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- no back-formation -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastSubjWeak</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
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
                        <xsl:with-param name="stem"
                                        select="$past-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubj2-sein</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- "tun" and related verbs -->
                    <xsl:when test="$lemma-without-particle='tun' or
                                    $lemma-without-particle='betun' or
                                    $lemma-without-particle='vertun'">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$past-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut($past-stem)"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- "werden" -->
                    <xsl:when test="$lemma-without-particle='werden' and
                                    $past-stem='wurde'">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="replace($past-stem,'e$','')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastInd-werden</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut(replace($past-stem,'e$',''))"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$lemma-without-particle='werden' and
                                    $past-stem='ward'">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$past-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastIndSg-ward</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="replace($past-stem,'a','u')"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastIndPl-werden</xsl:with-param>
                      </xsl:call-template>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="n:umlaut(replace($past-stem,'a','u'))"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- umlautable strong past stem -->
                    <!-- Caveat: "e" is considered as a full vowel. -->
                    <xsl:when test="matches($past-stem,'(au|aa|oo|[aou])[^aeiouäöü]*$')">
                      <!-- past indicative -->
                      <xsl:choose>
                        <!-- past indicative with stem-final "s", "ß", or "z" -->
                        <xsl:when test="ends-with($past-stem,'s') or
                                        ends-with($past-stem,'ß') or
                                        ends-with($past-stem,'z')">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastIndStr-s</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- archaic past indicative with "u" -->
                        <xsl:when test="ends-with($past-stem,'schwur')">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastIndOld</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- other past indicative -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$past-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="auxiliary"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                      <!-- past subjunctive -->
                      <xsl:if test="not(ends-with($lemma-without-particle,'schwören') and
                                        ends-with($past-stem,'schwur') or
                                        ends-with($lemma-without-particle,'sterben') and
                                        ends-with($past-stem,'starb') or
                                        ends-with($lemma-without-particle,'werben') and
                                        ends-with($past-stem,'warb') or
                                        ends-with($lemma-without-particle,'werfen') and
                                        ends-with($past-stem,'warf'))">
                        <xsl:call-template name="verb-stem-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="stem"
                                          select="n:umlaut($past-stem)"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="auxiliary"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="particle2"
                                          select="$particle2"/>
                          <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                      <!-- past subjunctive with "ü" -->
                      <xsl:if test="ends-with($lemma-without-particle,'helfen') or
                                    ends-with($lemma-without-particle,'stehen') or
                                    ends-with($lemma-without-particle,'sterben') or
                                    ends-with($lemma-without-particle,'werben') or
                                    ends-with($lemma-without-particle,'werfen')">
                        <xsl:call-template name="verb-stem-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="stem"
                                          select="n:umlaut(replace($past-stem,'a([^aeiouäöü]*)$','u$1'))"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="auxiliary"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="particle2"
                                          select="$particle2"/>
                          <xsl:with-param name="class">VPastSubjStr</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                      <!-- archaic past subjunctive with "ü" -->
                      <xsl:if test="ends-with($lemma-without-particle,'heben') or
                                    ends-with($lemma-without-particle,'schwören')">
                        <xsl:call-template name="verb-stem-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="stem"
                                          select="n:umlaut(replace($past-stem,'o([^aeiouäöü]*)$','u$1'))"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="auxiliary"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="particle2"
                                          select="$particle2"/>
                          <xsl:with-param name="class">VPastSubjOld</xsl:with-param>
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
                          <xsl:with-param name="stem"
                                          select="n:umlaut(replace($past-stem,'a([^aeiouäöü]*)$','o$1'))"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="auxiliary"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="particle2"
                                          select="$particle2"/>
                          <xsl:with-param name="class">VPastSubjOld</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:when>
                    <!-- non-umlautable strong past stem with stem-final "s", "ß", or "z" -->
                    <xsl:when test="ends-with($past-stem,'s') or
                                    ends-with($past-stem,'ß') or
                                    ends-with($past-stem,'z')">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$past-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastStr-s</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- other non-umlautable strong past stem -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$past-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="auxiliary"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPastStr</xsl:with-param>
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
                    <!-- weak past participles of borrowed verbs ending in "c", "g", or "p" + "let" -->
                    <xsl:when test="matches($participle-without-particle,'[cgp]let$')">
                      <xsl:choose>
                        <!-- back-formation -->
                        <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                        matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'n$'))">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(n)$'),'$1&lt;CB&gt;$2$3')"/>
                            <xsl:with-param name="stem"
                                            select="replace($participle-stem,'^(.+)(ge)(.+)$','$1&lt;CB&gt;$2&lt;PB&gt;$3')"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPartPerf-le</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- no back-formation -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$participle-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPartPerf-le</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <!-- weak past participle with stem-final "d"
                         without "e" epenthesis before "-t" -->
                    <xsl:when test="ends-with($participle-stem,'d') and
                                    matches($participle-without-particle,concat('^(ge)?',$participle-stem,'t$'))">
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$participle-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPerf-d_t</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- other weak past participle -->
                    <xsl:otherwise>
                      <xsl:choose>
                        <!-- back-formation -->
                        <xsl:when test="matches($participle-stem,'^.+ge.+$') and
                                        matches($lemma-without-particle,concat('^',substring-before($participle-stem,'ge'),substring-after($participle-stem,'ge'),'e?n$'))">
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($lemma-without-particle,concat('^(',substring-before($participle-stem,'ge'),')(',substring-after($participle-stem,'ge'),')(e?n)$'),'$1&lt;CB&gt;$2$3')"/>
                            <xsl:with-param name="stem"
                                            select="replace($participle-stem,'^(.+)(ge)(.+)$','$1&lt;CB&gt;$2&lt;PB&gt;$3')"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPartPerfWeak</xsl:with-param>
                          </xsl:call-template>
                        </xsl:when>
                        <!-- no back-formation -->
                        <xsl:otherwise>
                          <xsl:call-template name="verb-stem-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma-without-particle"/>
                            <xsl:with-param name="stem"
                                            select="$participle-stem"/>
                            <xsl:with-param name="participle"
                                            select="$participle-without-particle"/>
                            <xsl:with-param name="particle"
                                            select="$particle"/>
                            <xsl:with-param name="particle2"
                                            select="$particle2"/>
                            <xsl:with-param name="class">VPartPerfWeak</xsl:with-param>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <!-- borrowed past participle ending in "ed" -->
                <xsl:when test="ends-with($participle-without-particle,'ed')">
                  <xsl:call-template name="verb-stem-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$participle-stem"/>
                    <xsl:with-param name="participle"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="particle"
                                    select="$particle"/>
                    <xsl:with-param name="particle2"
                                    select="$particle2"/>
                    <xsl:with-param name="class">VPartPerf_ed</xsl:with-param>
                  </xsl:call-template>
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
                        <xsl:with-param name="stem"
                                        select="$participle-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPerf_n</xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <!-- other strong past participle -->
                    <xsl:otherwise>
                      <xsl:call-template name="verb-stem-entry">
                        <xsl:with-param name="lemma"
                                        select="$lemma-without-particle"/>
                        <xsl:with-param name="stem"
                                        select="$participle-stem"/>
                        <xsl:with-param name="participle"
                                        select="$participle-without-particle"/>
                        <xsl:with-param name="particle"
                                        select="$particle"/>
                        <xsl:with-param name="particle2"
                                        select="$particle2"/>
                        <xsl:with-param name="class">VPartPerfStr</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- compounding stems of verbs -->
<xsl:template match="entry[@pos='verb']
                          [@type='comp']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='verb']
                                            [@type='comp']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-comp-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="verb-comp-stem-entry">
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- derivation stems of verbs -->
<xsl:template match="entry[@pos='verb']
                          [@type='der']">
  <!-- ignore duplicates -->
  <xsl:if test="not(preceding-sibling::entry[@pos='verb']
                                            [@type='der']
                                            [deep-equal(.,current())])">
    <!-- ignore single letters unless they are marked as abbreviations -->
    <xsl:if test="not(matches(@stem,'^\p{L}$') and
                      @abbreviation='no')">
      <xsl:variable name="frequency">
        <xsl:call-template name="get-der-stem-frequency"/>
      </xsl:variable>
      <xsl:call-template name="verb-der-stem-entry">
        <xsl:with-param name="frequency"
                        select="$frequency"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- verbal participles (ad-hoc POS) -->
<xsl:template match="entry[@pos='participle']
                          [@type='base']">
  <xsl:variable name="particle">
    <xsl:choose>
      <xsl:when test="count(tokenize(@present,'&#x20;'))=3">
        <xsl:value-of select="substring-after(substring-after(@present,' '),' ')"/>
      </xsl:when>
      <xsl:when test="count(tokenize(@present,'&#x20;'))&lt;3">
        <xsl:value-of select="substring-after(@present,' ')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="particle2"
                select="substring-before(substring-after(@present,' '),' ')"/>
  <xsl:variable name="lemma-without-particle"
                select="replace(@lemma,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
  <xsl:variable name="participle-without-particle"
                select="replace(@participle,concat('^',$particle2,$particle,'(.+)$'),'$1')"/>
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
        <xsl:with-param name="stem"
                        select="$participle-stem"/>
        <xsl:with-param name="participle"
                        select="$participle-without-particle"/>
        <xsl:with-param name="particle"
                        select="$particle"/>
        <xsl:with-param name="particle2"
                        select="$particle2"/>
        <xsl:with-param name="class">VPartPerfWeak</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <!-- strong participles -->
    <xsl:otherwise>
      <xsl:call-template name="verb-stem-entry">
        <xsl:with-param name="lemma"
                        select="$lemma-without-particle"/>
        <xsl:with-param name="stem"
                        select="$participle-stem"/>
        <xsl:with-param name="participle"
                        select="$participle-without-particle"/>
        <xsl:with-param name="particle"
                        select="$particle"/>
        <xsl:with-param name="particle2"
                        select="$particle2"/>
        <xsl:with-param name="class">VPartPerfStr</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- adverbs -->
<xsl:template match="entry[@pos='adverb']
                          [@type='base']">
  <xsl:choose>
    <!-- adverbs with the unsuffixed comparative form "mehr" -->
    <xsl:when test="@comparative='mehr'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">ADV</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="@comparative"/>
        <xsl:with-param name="pos">ADV</xsl:with-param>
        <xsl:with-param name="class">AdvComp0</xsl:with-param>
      </xsl:call-template>
      <xsl:if test="ends-with(@superlative,'sten')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="stem"
                          select="replace(@superlative,'^am (.+)sten$','$1')"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">AdvSup_st</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- adverbs with other comparative forms -->
    <xsl:when test="ends-with(@comparative,'er')">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">ADV</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="stem"
                        select="replace(@comparative,'er$','')"/>
        <xsl:with-param name="pos">ADV</xsl:with-param>
        <xsl:with-param name="class">AdvComp_er</xsl:with-param>
      </xsl:call-template>
      <xsl:if test="ends-with(@superlative,'sten')">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="stem"
                          select="replace(@superlative,'^am (.*?[aeiouäöü].*?)e?sten$','$1')"/>
          <xsl:with-param name="pos">ADV</xsl:with-param>
          <xsl:with-param name="class">
            <xsl:choose>
              <xsl:when test="matches(@superlative,'^am .*[aeiouäöü].*esten$')">AdvSup_est</xsl:when>
              <xsl:otherwise>AdvSup_st</xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <!-- other adverbs -->
    <xsl:otherwise>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">ADV</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- pronominal adverbs -->
<xsl:template match="entry[@pos='pronominal-adverb']
                          [@type='base']">
  <xsl:call-template name="stem-entry">
    <xsl:with-param name="pos">PROADV</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- interjections -->
<xsl:template match="entry[@pos='interjection']
                          [@type='base']">
  <xsl:call-template name="stem-entry">
    <xsl:with-param name="pos">INTJ</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- adpositions -->
<xsl:template match="entry[@pos='adposition']
                          [@type='base']">
  <xsl:choose>
    <xsl:when test="@position='any'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PREP</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">POSTP</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@position='post'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">POSTP</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PREP</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- contracted adpositions -->
<xsl:template match="entry[@pos='contracted-adposition']
                          [@type='base']">
  <xsl:variable name="adposition-lemma">
    <xsl:choose>
      <xsl:when test="string-length(@adposition)&gt;0">
        <xsl:value-of select="@adposition"/>
      </xsl:when>
      <xsl:when test="@lemma='am'">an</xsl:when>
      <xsl:when test="@lemma='im'">in</xsl:when>
      <xsl:when test="@lemma='vom'">von</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="replace(@lemma,'^(.+).$','$1')"/>
      </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  <xsl:variable name="clitic">
    <xsl:choose>
      <xsl:when test="@lemma='am'">m</xsl:when>
      <xsl:when test="@lemma='im'">m</xsl:when>
      <xsl:when test="@lemma='vom'">m</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after(@lemma,$adposition-lemma)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@lemma='aufm' or
                    @lemma='ausm'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="$adposition-lemma"/>
        <xsl:with-param name="stem"
                        select="@lemma"/>
        <xsl:with-param name="pos">PREPART</xsl:with-param>
        <xsl:with-param name="class">Prep+Art-m-NonSt</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$clitic='n'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="lemma"
                        select="$adposition-lemma"/>
        <xsl:with-param name="stem"
                        select="@lemma"/>
        <xsl:with-param name="pos">PREPART</xsl:with-param>
        <xsl:with-param name="class">Prep+Art-n-NonSt</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="class">
        <xsl:call-template name="contracted-adposition-class">
          <xsl:with-param name="clitic"
                          select="$clitic"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="string-length($class)&gt;0">
        <xsl:call-template name="stem-entry">
          <xsl:with-param name="lemma"
                          select="$adposition-lemma"/>
          <xsl:with-param name="stem"
                          select="@lemma"/>
          <xsl:with-param name="pos">PREPART</xsl:with-param>
          <xsl:with-param name="class"
                          select="$class"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- conjunctions -->
<xsl:template match="entry[@pos='conjunction']
                          [@type='base']">
  <xsl:choose>
    <xsl:when test="@subcat='coordinative'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">CONJ</xsl:with-param>
        <xsl:with-param name="subcat">Coord</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@subcat='subordinative'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">CONJ</xsl:with-param>
        <xsl:with-param name="subcat">Sub</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@subcat='clausal'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">CONJ</xsl:with-param>
        <xsl:with-param name="subcat">InfCl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@subcat='comparative'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">CONJ</xsl:with-param>
        <xsl:with-param name="subcat">AdjComp</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- particles -->
<xsl:template match="entry[@pos='particle']
                          [@type='base']">
  <xsl:choose>
    <xsl:when test="@subcat='intensifying'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PTCL</xsl:with-param>
        <xsl:with-param name="subcat">Int</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@subcat='negative'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PTCL</xsl:with-param>
        <xsl:with-param name="subcat">Neg</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@subcat='clausal'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PTCL</xsl:with-param>
        <xsl:with-param name="subcat">InfCl</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="@subcat='superlative'">
      <xsl:call-template name="stem-entry">
        <xsl:with-param name="pos">PTCL</xsl:with-param>
        <xsl:with-param name="subcat">AdjSup</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- helper templates -->

<xsl:template name="get-comp-stem-frequency">
  <xsl:variable name="same-lemmas"
                select="key('entry-by-lemma',concat(@lemma,'/',@pos,':',@type))"/>
  <xsl:variable name="stem"
                select="@stem"/>
  <xsl:variable name="same-stems"
                select="$same-lemmas[@stem=$stem]"/>
  <xsl:value-of select="format-number(count($same-stems) div count($same-lemmas),'0.##')"/>
</xsl:template>

<xsl:template name="get-der-stem-frequency">
  <xsl:variable name="same-lemmas"
                select="key('entry-by-lemma',concat(@lemma,'/',@pos,':',@type))"/>
  <xsl:variable name="suffs"
                select="@suffs"/>
  <xsl:variable name="same-lemmas-and-suffs"
                select="$same-lemmas[@suffs=$suffs]"/>
  <xsl:variable name="stem"
                select="@stem"/>
  <xsl:variable name="same-stems"
                select="$same-lemmas-and-suffs[@stem=$stem]"/>
  <xsl:value-of select="format-number(count($same-stems) div count($same-lemmas-and-suffs),'0.##')"/>
</xsl:template>

<xsl:template name="apply-templates-to-singular">
  <xsl:variable name="entry" as="element()">
    <entry>
      <xsl:copy-of select="@*[not(name()='number' or
                                  name()='nominative-plural')]"/>
      <xsl:attribute name="number">singular</xsl:attribute>
    </entry>
  </xsl:variable>
  <xsl:apply-templates select="$entry"/>
</xsl:template>
</xsl:stylesheet>
