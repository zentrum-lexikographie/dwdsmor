<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smor.xsl -->
<!-- Version 1.0 -->
<!-- Andreas Nolda 2021-08-31 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="mappings.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <!-- ignore idioms -->
  <xsl:apply-templates select="dwds:Formangabe[not(normalize-space(dwds:Grammatik/dwds:Wortklasse)='Mehrwortausdruck')]"/>
</xsl:template>

<xsl:template match="dwds:Formangabe">
  <xsl:variable name="data-by-name">
    <xsl:for-each-group select="dwds:Grammatik/*"
                        group-by="name()">
      <xsl:element name="{name()}">
        <xsl:copy-of select="current-group()"/>
      </xsl:element>
    </xsl:for-each-group>
  </xsl:variable>
  <xsl:variable name="data-by-group">
    <xsl:apply-templates select="$data-by-name/*[1]/*"
                         mode="grammar"/>
  </xsl:variable>
  <xsl:for-each select="dwds:Schreibung">
    <xsl:variable name="lemma"
                  select="normalize-space(.)"/>
    <xsl:variable name="etymology">
      <xsl:apply-templates select="../../dwds:Diachronie">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:for-each select="$data-by-group/dwds:Grammatik">
      <xsl:variable name="pos"
                    select="normalize-space(dwds:Wortklasse)"/>
      <xsl:text>&lt;Stem&gt;</xsl:text>
      <xsl:if test="$pos='Verb'">
        <xsl:apply-templates select="."
                             mode="participle">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:apply-templates select="."
                           mode="form">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="."
                           mode="pos">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
      <xsl:text>&lt;base&gt;</xsl:text>
      <xsl:value-of select="$etymology"/>
      <xsl:if test="not($pos='Affix')">
        <xsl:apply-templates select="."
                             mode="class">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="form">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:choose>
    <xsl:when test="$pos='Verb'">
      <xsl:variable name="stem">
        <xsl:call-template name="verb-stem">
          <xsl:with-param name="lemma"
                          select="$lemma"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="n:pair($lemma,$stem)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$lemma"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="pos">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$pos='Affix' and
                    starts-with($lemma,'-')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$pos-mapping/pos[@pos='Suffix']"/>
        <xsl:with-param name="type">POS</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pos='Affix'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$pos-mapping/pos[@pos='Präfix']"/>
        <xsl:with-param name="type">POS</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$pos-mapping/pos[@pos=$pos]"/>
        <xsl:with-param name="type">POS</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template name="smorlemma-adjective-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="smor-adjective-class">
    <xsl:call-template name="adjective-class">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="replace($smor-adjective-class,'^ADJ','Adj')"/>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$pos='Adjektiv'">
      <!-- convert SMOR class to SMORLemma class -->
      <xsl:call-template name="smorlemma-adjective-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pos='Substantiv'">
      <xsl:call-template name="noun-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pos='Verb'">
      <xsl:call-template name="verb-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- unknown class -->
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="participle">
  <xsl:param name="lemma"/>
  <xsl:variable name="stem">
    <xsl:call-template name="verb-stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="participle"
                select="normalize-space(dwds:Partizip_II)"/>
  <xsl:if test="matches($participle,concat('^ge',$stem,'e?t$'))">
    <xsl:text>&lt;ge&gt;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="dwds:Diachronie">
  <xsl:param name="lemma"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:variable name="etymology">
    <xsl:choose>
      <xsl:when test="dwds:Etymologie[* or text()]">fremd</xsl:when>
      <xsl:when test="not(dwds:Etymologie[* or text()])">nativ</xsl:when>
      <!-- TODO: more etymology values -->
      <!-- ... -->
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$etymology"/>
    <xsl:with-param name="type">etymology</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
</xsl:template>
</xsl:stylesheet>
