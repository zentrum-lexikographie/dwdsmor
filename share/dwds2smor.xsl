<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smor.xsl -->
<!-- Version 0.3 -->
<!-- Andreas Nolda 2021-08-20 -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt">

<xsl:output method="text"
            encoding="ISO-8859-1"/>

<xsl:strip-space elements="*"/>

<xsl:variable name="lemma"
              select="normalize-space(/dwds:DWDS/dwds:Artikel/dwds:Formangabe/dwds:Schreibung)"/>

<xsl:variable name="pos-mapping">
  <pos pos="Substantiv">NN</pos>
  <!-- TODO: more POS mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:variable name="class-mapping">
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="-er"
         umlaut="yes">NMasc_es_$er</class>
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-en"
         umlaut="no">NFem_0_en</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="-er"
         umlaut="no">NNeut_es_er</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template match="/">
  <xsl:apply-templates match="/dwds:DWDS/dwds:Artikel"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="stem"/>
  <xsl:value-of select="$lemma"/>
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="pos"/>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:apply-templates select="dwds:Diachronie"/>
  <!-- consider only the first formation specification -->
  <xsl:apply-templates select="dwds:Verweise[@Typ or
                                             dwds:Verweis[@Typ='Binnenglied' or
                                                          @Typ='Erstglied' or
                                                          @Typ='Grundform' or
                                                          @Typ='Letztglied']][1]"/>
  <xsl:apply-templates select="dwds:Formangabe"
                       mode="class"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="insert-value">
  <xsl:param name="value"/>
  <xsl:param name="type">value</xsl:param>
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

<xsl:template match="dwds:Diachronie">
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
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Verweise">
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
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="stem">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="pos"/>
  <xsl:text>_Stems&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="pos">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="pos"/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="class">
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="class"/>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="pos">
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="exslt:node-set($pos-mapping)/pos[@pos=$pos]"/>
    <xsl:with-param name="type">POS</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="gender"
                select="normalize-space(dwds:Genus)"/>
  <xsl:variable name="genitive"
                select="normalize-space(dwds:Genitiv)"/>
  <xsl:choose>
    <xsl:when test="starts-with(dwds:Plural,'-')">
      <xsl:variable name="plural"
                    select="normalize-space(dwds:Plural)"/>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($class-mapping)/class[@umlaut='no']
                                                                    [@pos=$pos]
                                                                    [@gender=$gender]
                                                                    [@genitive=$genitive]
                                                                    [@plural=$plural]"/>
        <xsl:with-param name="type">class</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="plural"
                    select="concat('-',
                                   substring-after(translate(normalize-space(dwds:Plural),'äöü',
                                                                                          'aou'),
                                                   $lemma))"/>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($class-mapping)/class[@umlaut='yes']
                                                                    [@pos=$pos]
                                                                    [@gender=$gender]
                                                                    [@genitive=$genitive]
                                                                    [@plural=$plural]"/>
        <xsl:with-param name="type">class</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for non-<base> stems (i.e. <deriv> and <kompos> stems) -->
