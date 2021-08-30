<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smor.xsl -->
<!-- Version 0.8 -->
<!-- Andreas Nolda 2021-08-30 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0">

<xsl:include href="mappings.xsl"/>

<xsl:output method="text"
            encoding="ISO-8859-1"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <!-- generate one lexical entry per <Formangabe> -->
  <xsl:for-each select="dwds:Formangabe">
    <!-- for the sake of simplicity, consider only the first lemma specification -->
    <xsl:variable name="lemma"
                  select="normalize-space(dwds:Schreibung[1])"/>
    <xsl:variable name="pos"
                  select="normalize-space(dwds:Grammatik/dwds:Wortklasse)"/>
    <xsl:if test="$pos='Verb'">
      <xsl:apply-templates select="dwds:Grammatik"
                           mode="participle">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
    </xsl:if>
    <xsl:apply-templates select="dwds:Grammatik"
                         mode="stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="dwds:Grammatik"
                         mode="pos">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <xsl:text>&lt;base&gt;</xsl:text>
    <xsl:apply-templates select="../dwds:Diachronie">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <xsl:if test="not($pos='Affix')">
      <!-- for the sake of simplicity, consider only the first formation specification -->
      <xsl:apply-templates select="../dwds:Verweise[not(preceding-sibling::dwds:Verweise[@Typ or
                                                                                         dwds:Verweis[@Typ='Binnenglied' or
                                                                                                      @Typ='Erstglied' or
                                                                                                      @Typ='Grundform' or
                                                                                                      @Typ='Letztglied']])]">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="dwds:Grammatik"
                           mode="class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
    </xsl:if>
  <xsl:text>&#xA;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="stem">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$pos='Affix' and
                    starts-with($lemma,'-')">
      <xsl:text>Suff</xsl:text>
    </xsl:when>
    <xsl:when test="$pos='Affix'">
      <xsl:text>Pref</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Base</xsl:text>
    </xsl:otherwise>
    <!-- TODO: add support for <Deriv_Stems> and <Kompos_Stems> -->
  </xsl:choose>
  <xsl:text>_Stems&gt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$pos='Verb'">
      <xsl:call-template name="verb-stem">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
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

<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:choose>
    <xsl:when test="$pos='Adjektiv'">
      <xsl:call-template name="adjective-class">
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
  <xsl:if test="$participle=concat('ge',$stem,'t')">
    <xsl:text>&lt;ge&gt;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="dwds:Verweise">
  <xsl:param name="lemma"/>
  <xsl:variable name="formation">
    <xsl:choose>
      <!-- conversion -->
      <xsl:when test="@Typ='Konversion'">Komplex_abstrakt</xsl:when>
      <xsl:when test="count(dwds:Verweis[@Typ='Binnenglied' or
                                         @Typ='Erstglied' or
                                         @Typ='Grundform' or
                                         @Typ='Letztglied'])=1 and
                      dwds:Verweis[@Typ='Grundform']">Komplex_abstrakt</xsl:when>
      <!-- intransparent derivation or compounding -->
      <xsl:when test="count(dwds:Verweis[@Typ='Binnenglied' or
                                         @Typ='Erstglied' or
                                         @Typ='Grundform' or
                                         @Typ='Letztglied'])=1">Komplex_semi</xsl:when>
      <!-- derivation or compounding -->
      <xsl:when test="@Typ='Derivation' or
                      @Typ='Komposition'">Komplex</xsl:when>
      <xsl:when test="count(dwds:Verweis[@Typ='Binnenglied' or
                                         @Typ='Erstglied' or
                                         @Typ='Grundform' or
                                         @Typ='Letztglied'])&gt;1">Komplex</xsl:when>
      <!-- clipping -->
      <xsl:when test="@Typ='Kurzwortbildung'">Kurzwort</xsl:when>
      <!-- no formation -->
      <xsl:when test="@Typ='Simplex'">Simplex</xsl:when>
      <!-- TODO: more formation specifications -->
      <!-- ... -->
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$formation"/>
    <xsl:with-param name="type">formation</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
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
