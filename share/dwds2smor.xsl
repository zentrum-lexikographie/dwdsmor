<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smor.xsl -->
<!-- Version 0.4 -->
<!-- Andreas Nolda 2021-08-23 -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt">

<xsl:output method="text"
            encoding="ISO-8859-1"/>

<xsl:strip-space elements="*"/>

<xsl:variable name="pos-mapping">
  <pos pos="Adjektiv">ADJ</pos>
  <pos pos="Substantiv">NN</pos>
  <!-- TODO: more POS mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:variable name="noun-class-mapping">
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

<xsl:variable name="adjective-class-mapping">
  <class pos="Adjektiv"
         superlative="-"
         umlaut="no">ADJ+</class>
  <class pos="Adjektiv"
         superlative="-"
         umlaut="yes">ADJ$</class>
  <class pos="Adjektiv"
         superlative="-e-"
         umlaut="no">ADJ+e</class>
  <class pos="Adjektiv"
         superlative="-e-"
         umlaut="yes">ADJ$e</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:template match="/">
  <xsl:apply-templates match="/dwds:DWDS/dwds:Artikel"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <!-- generate one lexical entry per <Formangabe> -->
  <xsl:for-each select="dwds:Formangabe">
    <xsl:variable name="lemma"
                  select="normalize-space(dwds:Schreibung)"/>
    <xsl:apply-templates select="."
                         mode="stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <xsl:value-of select="$lemma"/>
    <xsl:apply-templates select="."
                         mode="pos">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <xsl:text>&lt;base&gt;</xsl:text>
    <xsl:apply-templates select="../dwds:Diachronie">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <!-- for the sake of simplicity, consider only the first formation specification -->
    <xsl:apply-templates select="../dwds:Verweise[not(preceding-sibling::dwds:Verweise[@Typ or
                                                                                       dwds:Verweis[@Typ='Binnenglied' or
                                                                                                    @Typ='Erstglied' or
                                                                                                    @Typ='Grundform' or
                                                                                                    @Typ='Letztglied']])]">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="."
                         mode="class">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
  <xsl:text>&#xA;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template name="insert-value">
  <xsl:param name="value"/>
  <xsl:param name="type"/>
  <xsl:param name="lemma"/>
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

<xsl:template match="dwds:Formangabe"
              mode="stem">
  <xsl:param name="lemma"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="pos">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:apply-templates>
  <xsl:text>_Stems&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="pos">
  <xsl:param name="lemma"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="pos">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:apply-templates>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Formangabe"
              mode="class">
  <xsl:param name="lemma"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:apply-templates select="dwds:Grammatik"
                       mode="class">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:apply-templates>
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="pos">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="exslt:node-set($pos-mapping)/pos[@pos=$pos]"/>
    <xsl:with-param name="type">POS</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:param name="pos"/>
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
                        select="exslt:node-set($noun-class-mapping)/class[@umlaut='no']
                                                                         [@pos=$pos]
                                                                         [@gender=$gender]
                                                                         [@genitive=$genitive]
                                                                         [@plural=$plural]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
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
                        select="exslt:node-set($noun-class-mapping)/class[@umlaut='yes']
                                                                         [@pos=$pos]
                                                                         [@gender=$gender]
                                                                         [@genitive=$genitive]
                                                                         [@plural=$plural]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="adjective-class">
  <xsl:param name="lemma"/>
  <xsl:param name="pos"/>
  <xsl:variable name="superlative"
                select="substring-after(normalize-space(dwds:Superlativ),'am ')"/>
  <xsl:choose>
    <xsl:when test="substring-after($superlative,$lemma)='sten'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($adjective-class-mapping)/class[@umlaut='no']
                                                                              [@pos=$pos]
                                                                              [@superlative='-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="substring-after(translate(normalize-space($superlative),'äöü',
                                                                            'aou'),
                                    $lemma)='sten'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($adjective-class-mapping)/class[@umlaut='yes']
                                                                              [@pos=$pos]
                                                                              [@superlative='-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="substring-after($superlative,$lemma)='esten'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($adjective-class-mapping)/class[@umlaut='no']
                                                                              [@pos=$pos]
                                                                              [@superlative='-e-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="substring-after(translate(normalize-space($superlative),'äöü',
                                                                            'aou'),
                                    $lemma)='esten'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($adjective-class-mapping)/class[@umlaut='yes']
                                                                              [@pos=$pos]
                                                                              [@superlative='-e-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="exslt:node-set($adjective-class-mapping)/class[@umlaut='yes']
                                                                              [@pos=$pos]
                                                                              [@superlative=$superlative]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:choose>
    <xsl:when test="$pos='Substantiv'">
      <xsl:call-template name="noun-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="pos"
                        select="$pos"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$pos='Adjektiv'">
      <xsl:call-template name="adjective-class">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
        <xsl:with-param name="pos"
                        select="$pos"/>
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
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for non-nouns and non-adjectives -->
<!-- add support for non-<base> stems (i.e. <deriv> and <kompos> stems) -->
