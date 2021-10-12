<?xml version="1.0" encoding="utf-8"?>
<!-- dwds.xsl -->
<!-- Version 1.1 -->
<!-- Andreas Nolda 2021-10-12 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

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
  <!-- ignore syntactically complex units (in particular, phrasal verbs and idioms) -->
  <xsl:apply-templates select="dwds:Formangabe[not(dwds:Schreibung[contains(normalize-space(.),' ')] or
                                                   dwds:Grammatik/dwds:Praesens[contains(normalize-space(.),' ')])]"/>
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
  <xsl:variable name="data-by-name">
    <xsl:for-each-group select="dwds:Grammatik/*[self::dwds:Genitiv or
                                                 self::dwds:Genus or
                                                 self::dwds:Komparativ or
                                                 self::dwds:Partizip_II or
                                                 self::dwds:Plural or
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
  <xsl:variable name="data-by-group">
    <xsl:apply-templates select="$data-by-name/*[1]/*"
                         mode="grammar"/>
  </xsl:variable>
  <!-- ignore invalid spellings -->
  <xsl:for-each select="dwds:Schreibung[not(starts-with(@Typ,'U'))]">
    <xsl:variable name="lemma"
                  select="normalize-space(.)"/>
    <xsl:if test="string-length($lemma)&gt;0">
      <xsl:for-each select="$data-by-group/dwds:Grammatik">
        <xsl:variable name="pos"
                      select="normalize-space(dwds:Wortklasse)"/>
        <!-- ignore sources with missing part of speech -->
        <xsl:if test="string-length($pos)&gt;0">
          <xsl:choose>
            <!-- affixes -->
            <xsl:when test="$pos='Affix'">
              <xsl:call-template name="affix-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="pos">
                  <xsl:apply-templates select="."
                                       mode="pos">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:apply-templates>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <!-- verbs -->
            <xsl:when test="$pos='Verb'">
              <xsl:variable name="present"
                            select="normalize-space(dwds:Praesens)"/>
              <xsl:variable name="past"
                            select="normalize-space(dwds:Praeteritum)"/>
              <xsl:variable name="participle"
                            select="normalize-space(dwds:Partizip_II)"/>
              <!-- ignore sources with missing forms -->
              <xsl:if test="string-length($present)&gt;0 and
                            string-length($past)&gt;0 and
                            string-length($participle)&gt;0">
                <xsl:variable name="stem">
                  <xsl:call-template name="verb-stem">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="present-stem">
                  <xsl:call-template name="present-stem"/>
                </xsl:variable>
                <xsl:variable name="past-stem">
                  <xsl:call-template name="past-stem"/>
                </xsl:variable>
                <xsl:variable name="participle-stem">
                  <xsl:call-template name="participle-stem">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- weak verbs -->
                  <xsl:when test="matches($past,concat('^',$stem,'e?te$')) and
                                  matches($participle,concat('^(ge)?',$stem,'e?t$'))">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="class">
                        <xsl:apply-templates select="."
                                             mode="class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                        </xsl:apply-templates>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- weak verbs with irregular past stem -->
                  <xsl:when test="matches($past,concat('^',$past-stem,'e?te$')) and
                                  matches($participle,concat('^(ge)?',$past-stem,'e?t$'))">
                    <!-- present -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="class">VVPres</xsl:with-param>
                    </xsl:call-template>
                    <!-- past indicative -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                    </xsl:call-template>
                    <!-- past subjunctive -->
                    <xsl:choose>
                      <!-- past stem ending in "ach" -->
                      <xsl:when test="matches($past-stem,'ach$')">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="n:umlaut($past-stem)"/>
                          <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- Rückumlaut -->
                      <xsl:otherwise>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/><!-- sic! -->
                          <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-- past participle -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-t</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- weak verbs with strong participle -->
                  <xsl:when test="matches($past,concat('^',$stem,'e?te$')) and
                                  matches($participle,concat('^(ge)?',$stem,'en$'))">
                    <!-- present -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="class">VVPres</xsl:with-param>
                    </xsl:call-template>
                    <!-- past indicative -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                    </xsl:call-template>
                    <!-- past subjunctive -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$past-stem"/>
                      <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                    </xsl:call-template>
                    <!-- past participle -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-en</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- strong verbs -->
                  <xsl:otherwise>
                    <!-- present -->
                    <xsl:choose>
                      <!-- uniform present stem -->
                      <xsl:when test="$stem=$present-stem">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- present stem for 2nd/3rd person singular with "e:i" alternation -->
                      <xsl:when test="contains(n:pair($stem,$present-stem),'e:i')">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VVPres2+Imp</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- other present stem for 2nd/3rd person singular -->
                      <xsl:otherwise>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VVPres2</xsl:with-param>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <!-- umlautable past stem -->
                      <!-- Caveat: "e" is considered as a full vowel. -->
                      <xsl:when test="matches($past-stem,'([aou]|au)[^aeiouäöü]*$','i')">
                        <!-- past indicative -->
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$past-stem"/>
                          <xsl:with-param name="class">VVPastIndStr</xsl:with-param>
                        </xsl:call-template>
                        <!-- past subjunctive -->
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="n:umlaut($past-stem)"/>
                          <xsl:with-param name="class">VVPastKonjStr</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- non-umlautable past stem -->
                      <xsl:otherwise>
                        <!-- past -->
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$past-stem"/>
                          <xsl:with-param name="class">VVPastStr</xsl:with-param>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-- past participle -->
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-en</xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                  <!-- TODO: support for irregular verbs, modal verbs, and auxiliaries -->
                </xsl:choose>
              </xsl:if>
            </xsl:when>
            <!-- adjectives -->
            <xsl:when test="$pos='Adjektiv'">
              <xsl:variable name="superlative"
                            select="normalize-space(dwds:Superlativ)"/>
              <!-- ignore sources with missing forms -->
              <xsl:if test="string-length($superlative)&gt;0">
                <xsl:call-template name="default-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="pos">
                    <xsl:apply-templates select="."
                                         mode="pos">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                  <xsl:with-param name="class">
                    <xsl:apply-templates select="."
                                         mode="class">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <!-- nouns -->
            <xsl:when test="$pos='Substantiv'">
              <xsl:variable name="gender"
                            select="normalize-space(dwds:Genus)"/>
              <xsl:variable name="genitive"
                            select="normalize-space(dwds:Genitiv)"/>
              <xsl:variable name="plural"
                            select="normalize-space(dwds:Plural)"/>
              <!-- ignore sources with missing forms -->
              <xsl:if test="string-length($gender)&gt;0 and
                            string-length($genitive)&gt;0 and
                            string-length($plural)&gt;0">
                <xsl:call-template name="default-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="pos">
                    <xsl:apply-templates select="."
                                         mode="pos">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                  <xsl:with-param name="class">
                    <xsl:apply-templates select="."
                                         mode="class">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
            <!-- other parts of speech -->
            <xsl:otherwise>
              <xsl:call-template name="default-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="pos">
                  <xsl:apply-templates select="."
                                       mode="pos">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:apply-templates>
                </xsl:with-param>
                <xsl:with-param name="class">
                  <xsl:apply-templates select="."
                                       mode="class">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:apply-templates>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- parts of speech -->
<xsl:template match="dwds:Grammatik"
              mode="pos">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
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
    <xsl:when test="$pos='Affix' and
                    ends-with($lemma,'-')">
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
</xsl:template>

<!-- inflection classes -->
<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
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
