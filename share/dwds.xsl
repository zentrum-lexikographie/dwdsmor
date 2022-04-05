<?xml version="1.0" encoding="utf-8"?>
<!-- dwds.xsl -->
<!-- Version 6.0 -->
<!-- Andreas Nolda 2022-04-05 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="entries.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <!-- only consider (near-)final articles -->
  <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel[@Status='Red-2' or
                                                       @Status='Red-f']"/>
</xsl:template>

<!-- save <dwds:Artikel> for reference within <xsl:for-each> loops -->
<xsl:variable name="article"
              select="/dwds:DWDS/dwds:Artikel[@Status='Red-2' or
                                              @Status='Red-f']"/>

<!-- process <dwds:Artikel> -->
<xsl:template match="dwds:Artikel">
  <!-- ignore idioms and other syntactically complex units
       except for reflexive verbs and phrasal verbs -->
  <xsl:apply-templates select="dwds:Formangabe[not(dwds:Schreibung[count(tokenize(normalize-space(.)))&gt;1])]
                                              [not(dwds:Grammatik/dwds:Praesens[tokenize(normalize-space(.))[2]='sich']
                                                                               [count(tokenize(normalize-space(.)))&gt;3])]
                                              [not(dwds:Grammatik/dwds:Praesens[not(tokenize(normalize-space(.))[2]='sich')]
                                                                               [count(tokenize(normalize-space(.)))&gt;2])]"/>
</xsl:template>

<!-- group multiple grammar specifications of the same type
     into separate <dwds:Grammatik> elements -->
<!-- cf. https://stackoverflow.com/q/35525010 -->
<xsl:template match="*[not(position()=last())]/*"
              mode="grammar">
  <xsl:param name="previous" as="element()*"/>
  <xsl:apply-templates select="../following-sibling::*[1]/*"
                       mode="grammar">
    <xsl:with-param name="previous"
                    select="$previous | ."/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[position()=last()]/*"
              mode="grammar">
  <xsl:param name="previous"/>
  <dwds:Grammatik>
    <xsl:copy-of select="$previous"/>
    <xsl:copy-of select="."/>
  </dwds:Grammatik>
</xsl:template>

<!-- orthography and grammar specifications -->
<xsl:template match="dwds:Formangabe">
  <xsl:variable name="flat-grammar-specs">
    <xsl:for-each-group select="dwds:Grammatik/*[self::dwds:Genitiv or
                                                 self::dwds:Genus or
                                                 self::dwds:indeklinabel or
                                                 self::dwds:Komparativ or
                                                 self::dwds:Numeruspraeferenz or
                                                 self::dwds:Partizip_II or
                                                 self::dwds:Plural or
                                                 self::dwds:Positiv or
                                                 self::dwds:Praesens or
                                                 self::dwds:Praeteritum or
                                                 self::dwds:Superlativ or
                                                 self::dwds:Wortklasse]"
                        group-by="name()">
      <xsl:element name="{name()}">
        <xsl:copy-of select="current-group()"/>
      </xsl:element>
    </xsl:for-each-group>
  </xsl:variable>
  <xsl:variable name="grouped-grammar-specs">
    <xsl:apply-templates select="$flat-grammar-specs/*[1]/*"
                         mode="grammar"/>
  </xsl:variable>
  <xsl:variable name="grammar-specs">
    <xsl:choose>
      <!-- remove grammar specification for a noun
           with genitive singular form ending in "-s"
           if there is another grammar specification for a noun
           with genitive singular form ending in "-es" -->
      <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[normalize-space(.)='-es']] and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[normalize-space(.)='-s']]">
        <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[not(dwds:Genitiv[normalize-space(.)='-s'])]"/>
      </xsl:when>
      <!-- reduce grammar specification for a weak verb with strong participle to participle
           if there is another grammar specification for a weak verb with weak participle -->
      <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]] and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]] and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]]/dwds:Praesens=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]]/dwds:Praesens and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]]/dwds:Praeteritum=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]]/dwds:Praeteritum">
        <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[not(dwds:Partizip_II[matches(normalize-space(.),'e?n$')])]"/>
        <xsl:for-each select="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]]">
          <dwds:Grammatik>
            <dwds:Wortklasse>Partizip</dwds:Wortklasse><!-- ad-hoc POS -->
            <xsl:copy-of select="dwds:Praesens"/><!-- required for identifying phrasal verbs -->
            <xsl:copy-of select="dwds:Partizip_II"/>
          </dwds:Grammatik>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- ignore invalid spellings -->
  <xsl:for-each select="dwds:Schreibung[not(starts-with(@Typ,'U'))]">
    <xsl:variable name="lemma"
                  select="normalize-space(.)"/>
    <xsl:if test="string-length($lemma)&gt;0">
      <xsl:for-each select="$grammar-specs/dwds:Grammatik">
        <xsl:variable name="pos"
                      select="normalize-space(dwds:Wortklasse)"/>
        <xsl:choose>
          <!-- affixes -->
          <xsl:when test="$pos='Affix'">
            <xsl:call-template name="affix-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
            </xsl:call-template>
          </xsl:when>
          <!-- adjectives -->
          <xsl:when test="$pos='Adjektiv'">
            <xsl:call-template name="adjective-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="inflection">
                <xsl:choose>
                  <xsl:when test="dwds:indeklinabel">no</xsl:when>
                  <xsl:otherwise>yes</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="positive"
                              select="normalize-space(dwds:Positiv)"/>
              <xsl:with-param name="comparative"
                              select="normalize-space(dwds:Komparativ)"/>
              <xsl:with-param name="superlative"
                              select="normalize-space(dwds:Superlativ)"/>
            </xsl:call-template>
          </xsl:when>
          <!-- nouns -->
          <xsl:when test="$pos='Substantiv' and
                           normalize-space(dwds:Numeruspraeferenz)='nur im Singular' and
                           string-length(normalize-space(dwds:Genus))&gt;0 and
                           string-length(normalize-space(dwds:Genitiv))&gt;0">
            <xsl:call-template name="noun-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="normalize-space(dwds:Genus)"/>
              <xsl:with-param name="genitive-singular"
                              select="normalize-space(dwds:Genitiv)"/>
              <xsl:with-param name="number">singular</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pos='Substantiv' and
                          normalize-space(dwds:Numeruspraeferenz)='nur im Plural'">
            <xsl:call-template name="noun-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="normalize-space(dwds:Genus)"/>
              <xsl:with-param name="nominative-plural"
                              select="normalize-space(dwds:Plural)"/>
              <xsl:with-param name="number">plural</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pos='Substantiv' and
                          string-length(normalize-space(dwds:Genus))&gt;0 and
                          string-length(normalize-space(dwds:Genitiv))&gt;0 and
                          string-length(normalize-space(dwds:Plural))&gt;0">
            <xsl:call-template name="noun-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="normalize-space(dwds:Genus)"/>
              <xsl:with-param name="genitive-singular"
                              select="normalize-space(dwds:Genitiv)"/>
              <xsl:with-param name="nominative-plural"
                              select="normalize-space(dwds:Plural)"/>
              <xsl:with-param name="number">singular+plural</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <!-- proper names -->
          <xsl:when test="$pos='Eigenname' and
                          normalize-space(dwds:Numeruspraeferenz)='nur im Singular' and
                          string-length(normalize-space(dwds:Genus))&gt;0 and
                          string-length(normalize-space(dwds:Genitiv))&gt;0">
            <xsl:call-template name="name-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="normalize-space(dwds:Genus)"/>
              <xsl:with-param name="genitive-singular"
                              select="normalize-space(dwds:Genitiv)"/>
              <xsl:with-param name="number">singular</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$pos='Eigenname' and
                          normalize-space(dwds:Numeruspraeferenz)='nur im Plural'">
            <xsl:call-template name="name-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="gender"
                              select="normalize-space(dwds:Genus)"/>
              <xsl:with-param name="nominative-plural"
                              select="normalize-space(dwds:Plural)"/>
              <xsl:with-param name="number">plural</xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <!-- verbs -->
          <xsl:when test="$pos='Verb' and
                          string-length(normalize-space(dwds:Praesens))&gt;0 and
                          string-length(normalize-space(dwds:Praeteritum))&gt;0 and
                          string-length(normalize-space(dwds:Partizip_II))&gt;0">
            <xsl:call-template name="verb-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="present">
                <!-- remove "sich", if any -->
                <xsl:choose>
                  <xsl:when test="tokenize(normalize-space(dwds:Praesens))[2]='sich'">
                    <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens)),2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(dwds:Praesens)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="past">
                <!-- remove "sich", if any -->
                <xsl:choose>
                  <xsl:when test="tokenize(normalize-space(dwds:Praeteritum))[2]='sich'">
                    <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praeteritum)),2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(dwds:Praeteritum)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="participle"
                              select="normalize-space(dwds:Partizip_II)"/>
            </xsl:call-template>
          </xsl:when>
          <!-- verbal participles (ad-hoc POS) -->
          <xsl:when test="$pos='Partizip' and
                          string-length(normalize-space(dwds:Praesens))&gt;0 and
                          string-length(normalize-space(dwds:Partizip_II))&gt;0">
            <xsl:call-template name="participle-entry-set">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
              <xsl:with-param name="present">
                <!-- remove "sich", if any -->
                <xsl:choose>
                  <xsl:when test="tokenize(normalize-space(dwds:Praesens))[2]='sich'">
                    <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens)),2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(dwds:Praesens)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
              <xsl:with-param name="participle"
                              select="normalize-space(dwds:Partizip_II)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="normalize-space(dwds:Wortklasse)='Substantiv' or
                          normalize-space(dwds:Wortklasse)='Verb' or
                          normalize-space(dwds:Wortklasse)='Partizip'">
            <xsl:message>
              <xsl:text>Warning: "</xsl:text>
              <xsl:value-of select="$lemma"/>
              <xsl:text>" has an incomplete grammar specification with POS "</xsl:text>
              <xsl:value-of select="$pos"/>
              <xsl:text>".</xsl:text>
            </xsl:message>
          </xsl:when>
          <xsl:when test="string-length(normalize-space(dwds:Wortklasse))&gt;0">
            <xsl:message>
              <xsl:text>Warning: "</xsl:text>
              <xsl:value-of select="$lemma"/>
              <xsl:text>" has a grammar specification with unsupported POS "</xsl:text>
              <xsl:value-of select="$pos"/>
              <xsl:text>".</xsl:text>
            </xsl:message>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>Warning: "</xsl:text>
              <xsl:value-of select="$lemma"/>
              <xsl:text>" has a grammar specification with empty POS.</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- word-formation types -->
<xsl:template name="formation">
  <xsl:param name="lemma"/>
  <!-- refer to <dwds:Artikel> outside of <xsl:for-each> loops -->
  <xsl:if test="not($article/dwds:Formangabe/dwds:Grammatik/dwds:Wortklasse[.='Affix'])">
    <!-- for the sake of simplicity, consider only the first formation specification -->
    <xsl:apply-templates select="$article/dwds:Verweise[not(preceding-sibling::dwds:Verweise[@Typ or
                                                                                             dwds:Verweis[@Typ='Binnenglied' or
                                                                                                          @Typ='Erstglied' or
                                                                                                          @Typ='Grundform' or
                                                                                                          @Typ='Letztglied']])]">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:apply-templates>
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
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value"
                    select="$formation"/>
    <xsl:with-param name="type">formation</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>

<!-- etymological classes -->
<xsl:template name="etymology">
  <xsl:param name="lemma"/>
  <!-- refer to <dwds:Artikel> outside of <xsl:for-each> loops -->
  <xsl:apply-templates select="$article/dwds:Diachronie">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="dwds:Diachronie">
  <xsl:param name="lemma"/>
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
</xsl:template>
</xsl:stylesheet>
