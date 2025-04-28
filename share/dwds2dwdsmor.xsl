<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2dwdsmor.xsl -->
<!-- Version 16.3 -->
<!-- Andreas Nolda 2025-04-26 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="entries.xsl"/>

<xsl:include href="files.xsl"/>

<xsl:include href="strings.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

<xsl:strip-space elements="*"/>

<!-- file listing sources to be included -->
<xsl:param name="manifest-file"/>

<xsl:variable name="manifest">
  <xsl:if test="doc-available(n:absolute-path($manifest-file))">
    <xsl:copy-of select="doc(n:absolute-path($manifest-file))/manifest/*"/>
  </xsl:if>
</xsl:variable>

<!-- process sources listed in $manifest-file -->
<xsl:template name="xsl:initial-template">
  <xsl:for-each select="distinct-values($manifest/source/@href)">
    <xsl:call-template name="process-sources">
      <xsl:with-param name="file"
                      select="."/>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>

<xsl:template name="process-sources">
  <xsl:param name="file"/>
  <xsl:for-each select="doc(n:absolute-path($file))">
    <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel[not(@Status!='Red-f')]">
      <xsl:with-param name="file"
                      select="$file"/>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<!-- process individual source (for testing purposes) -->
<xsl:template match="/">
  <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel">
    <xsl:with-param name="file"
                    select="n:relative-path(document-uri(/))"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <xsl:param name="file"/>
  <xsl:variable name="etymology">
    <xsl:call-template name="get-etymology-value"/>
  </xsl:variable>
  <!-- ignore idioms and other syntactically complex units -->
  <xsl:for-each select="dwds:Formangabe[not(@class='invisible')]
                                       [dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]]">
    <xsl:variable name="diminutive">
      <xsl:if test="normalize-space(dwds:Grammatik/dwds:Wortklasse[not(@class='invisible')])='Substantiv'">
        <xsl:choose>
          <!-- normalised diminutive suffix -->
          <xsl:when test="../dwds:Verweise[@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
                                                                          [@Typ='Letztglied']/dwds:Ziellemma[normalize-space(.)='-chen']">chen</xsl:when>
          <xsl:when test="../dwds:Verweise[@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
                                                                          [@Typ='Letztglied']/dwds:Ziellemma[normalize-space(.)='-lein' or
                                                                                                             normalize-space(.)='-le' or
                                                                                                             normalize-space(.)='-li']">lein</xsl:when>
          <xsl:when test="../dwds:Verweise[@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
                                                                          [@Typ='Letztglied']/dwds:Ziellemma[normalize-space(.)='-l']">l</xsl:when>
          <!-- TODO: more diminutive values -->
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="adposition">
      <!-- adpositional basis of contracted adposition -->
      <xsl:if test="normalize-space(dwds:Grammatik/dwds:Wortklasse[not(@class='invisible')])='Präposition + Artikel'">
        <xsl:choose>
          <!-- canonical representation -->
          <xsl:when test="../dwds:Verweise[@Typ='Zusammenrückung']
                                          [dwds:Verweis[not(@class='invisible')]
                                                       [@Typ='Erstglied']]">
            <xsl:value-of select="normalize-space(../dwds:Verweise[@Typ='Zusammenrückung']/dwds:Verweis[not(@class='invisible')]
                                                                                                       [@Typ='Erstglied']/dwds:Ziellemma)"/>
          </xsl:when>
          <!-- legacy representation -->
          <xsl:when test="../dwds:Verweise[@Typ='Derivation']
                                          [dwds:Verweis[not(@class='invisible')]
                                                       [@Typ='Erstglied']]">
            <xsl:value-of select="normalize-space(../dwds:Verweise[@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
                                                                                                  [@Typ='Erstglied']/dwds:Ziellemma)"/>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="flat-grammar-specs">
      <!-- ignore idioms and other syntactically complex units
           except for reflexive verbs and phrasal verbs -->
      <xsl:for-each-group select="dwds:Grammatik/*[self::dwds:Wortklasse[not(@class='invisible')] or
                                                   self::dwds:Genus[not(normalize-space(.)='ohne erkennbares Genus')] or
                                                   self::dwds:indeklinabel or
                                                   self::dwds:Genitiv[count(tokenize(normalize-space(.),'&#x20;'))=1] or
                                                   self::dwds:Plural[count(tokenize(normalize-space(.),'&#x20;'))=1] or
                                                   self::dwds:Positivvariante[count(tokenize(normalize-space(.),'&#x20;'))=1] or
                                                   self::dwds:Komparativ[count(tokenize(normalize-space(.),'&#x20;'))=1] or
                                                   self::dwds:Superlativ[tokenize(normalize-space(.),'&#x20;')[1]='am']
                                                                        [count(tokenize(normalize-space(.),'&#x20;'))=2] or
                                                   self::dwds:Superlativ[not(tokenize(normalize-space(.),'&#x20;')[1]='am')]
                                                                        [count(tokenize(normalize-space(.),'&#x20;'))=1] or
                                                   self::dwds:Praesens[tokenize(normalize-space(.),'&#x20;')[2]='sich']
                                                                      [count(tokenize(normalize-space(.),'&#x20;'))&lt;5] or
                                                   self::dwds:Praesens[not(tokenize(normalize-space(.),'&#x20;')[2]='sich')]
                                                                      [count(tokenize(normalize-space(.),'&#x20;'))&lt;4] or
                                                   self::dwds:Praeteritum[tokenize(normalize-space(.),'&#x20;')[2]='sich']
                                                                         [count(tokenize(normalize-space(.),'&#x20;'))&lt;5] or
                                                   self::dwds:Praeteritum[not(tokenize(normalize-space(.),'&#x20;')[2]='sich')]
                                                                         [count(tokenize(normalize-space(.),'&#x20;'))&lt;4] or
                                                   self::dwds:Partizip_II[count(tokenize(normalize-space(.),'&#x20;'))=1] or
                                                   self::dwds:Auxiliar or
                                                   self::dwds:Funktionspraeferenz or
                                                   self::dwds:Numeruspraeferenz[not(@class='invisible')] or
                                                   self::dwds:Einschraenkung]"
                          group-by="name()">
        <xsl:element name="{name()}">
          <xsl:copy-of select="current-group()"/>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:variable name="flat-word-formation-specs">
      <!-- ignore idioms and other syntactically complex units
           except for reflexive verbs and phrasal verbs -->
      <xsl:for-each-group select="dwds:Grammatik/*[self::dwds:Wortklasse[not(@class='invisible')] or
                                                   self::dwds:Derivationsstamm or
                                                   self::dwds:Kompositionsstamm]"
                          group-by="name()">
        <xsl:element name="{name()}">
          <xsl:copy-of select="current-group()"/>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:variable name="grouped-grammar-specs">
      <xsl:apply-templates select="$flat-grammar-specs/*[1]/*"
                           mode="group"/>
    </xsl:variable>
    <xsl:variable name="grouped-word-formation-specs">
      <xsl:apply-templates select="$flat-word-formation-specs/*[1]/*"
                           mode="group"/>
    </xsl:variable>
    <xsl:variable name="grammar-specs">
      <xsl:choose>
        <!-- remove grammar specification for a noun with genitive singular form ending in "-s"
             if there is another grammar specification for a noun with genitive singular form ending in "-es" -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[normalize-space(.)='-es']] and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[normalize-space(.)='-s']]">
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[not(normalize-space(.)='-s')]]"/>
        </xsl:when>
        <!-- remove grammar specification for a verb with separable preverb only in the present tense -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Praesens[contains(normalize-space(.),'&#x20;')] and
                                                              dwds:Praeteritum[not(contains(normalize-space(.),'&#x20;'))]]"/>
        <!-- remove grammar specification for a verb with separable preverb only in the past tense -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Praeteritum[contains(normalize-space(.),'&#x20;')] and
                                                              dwds:Praesens[not(contains(normalize-space(.),'&#x20;'))]]"/>
        <!-- reduce grammar specification for a weak verb with strong participle to participle
             if there is another grammar specification for a weak verb with weak participle -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]] and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]] and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]]/dwds:Praesens=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]]/dwds:Praesens and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]]/dwds:Praeteritum=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]]/dwds:Praeteritum">
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[not(matches(normalize-space(.),'e?n$'))]]"/>
          <xsl:for-each select="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?n$')]]">
            <dwds:Grammatik>
              <dwds:Wortklasse>Partizip</dwds:Wortklasse><!-- ad-hoc POS -->
              <xsl:copy-of select="dwds:Praesens"/><!-- required for identifying phrasal verbs -->
              <xsl:copy-of select="dwds:Partizip_II"/>
              <xsl:copy-of select="dwds:Auxiliar"/>
            </dwds:Grammatik>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="word-formation-specs"
                  select="$grouped-word-formation-specs"/>
    <!-- sequence number of <Formangabe> -->
    <xsl:variable name="paradigm-index">
      <!-- empty in cases where there is a single <Formangabe> -->
      <xsl:if test="count(../dwds:Formangabe[not(@class='invisible')])>1">
        <xsl:number count="dwds:Formangabe[not(@class='invisible')]"/>
      </xsl:if>
    </xsl:variable>
    <!-- sequence of phonetic transcriptions (if any) -->
    <xsl:variable name="pronunciations"
                  select="distinct-values(dwds:Aussprache[not(@class='invisible')]/dwds:IPA[string-length(normalize-space(.))&gt;0]/normalize-space(.))"/>
    <!-- ignore idioms and non-standard spellings -->
    <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                         [not(@Typ)]">
      <xsl:variable name="lemma"
                    select="normalize-space(.)"/>
      <xsl:if test="string-length($lemma)&gt;0">
        <!-- homograph index -->
        <xsl:variable name="lemma-index"
                      select="@hidx"/>
        <xsl:variable name="meaning-type">
          <xsl:call-template name="get-meaning-type-value"/>
        </xsl:variable>
        <xsl:variable name="abbreviation">
          <xsl:call-template name="get-abbreviation-value"/>
        </xsl:variable>
        <!-- inflection stems -->
        <xsl:for-each select="$grammar-specs/dwds:Grammatik">
          <xsl:variable name="pos"
                        select="normalize-space(dwds:Wortklasse[not(@class='invisible')])"/>
          <xsl:choose>
            <!-- adjectives and adjectival participles -->
            <xsl:when test="$pos='Adjektiv' or
                            $pos='partizipiales Adjektiv'">
              <xsl:call-template name="adjective-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="function">
                  <xsl:call-template name="get-function-value"/>
                </xsl:with-param>
                <xsl:with-param name="inflection">
                  <xsl:call-template name="get-inflection-value"/>
                </xsl:with-param>
                <xsl:with-param name="positive"
                                select="normalize-space(dwds:Positivvariante)"/>
                <xsl:with-param name="comparative"
                                select="normalize-space(dwds:Komparativ)"/>
                <xsl:with-param name="superlative"
                                select="normalize-space(dwds:Superlativ)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- adverbs and adverbial participles -->
            <xsl:when test="$pos='Adverb' or
                            $pos='partizipiales Adverb'">
              <xsl:choose>
                <xsl:when test="$lemma='allzu'">
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
                    <xsl:with-param name="class">PtclAdjPos</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='so'">
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
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
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pos">OTHER</xsl:with-param>
                    <xsl:with-param name="class">Intj</xsl:with-param>
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
                    <xsl:with-param name="class">ConjSub</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='nicht'">
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
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
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pos">OTHER</xsl:with-param>
                    <xsl:with-param name="class">PtclNeg</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='wie'">
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
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
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pos">OTHER</xsl:with-param>
                    <xsl:with-param name="class">ConjAdjComp</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='zu'">
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
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
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pos">OTHER</xsl:with-param>
                    <xsl:with-param name="class">PtclAdjPos</xsl:with-param>
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
                    <xsl:with-param name="class">PtclInfCl</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="comparative"
                                    select="normalize-space(dwds:Komparativ)"/>
                    <xsl:with-param name="superlative"
                                    select="normalize-space(dwds:Superlativ)"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- pronominal adverbs -->
            <xsl:when test="$pos='Pronominaladverb'">
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
                <xsl:with-param name="class">ProAdv</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- articles -->
            <xsl:when test="$pos='bestimmter Artikel' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            not(dwds:Kasuspraeferenz[not(@Frequenz)]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <xsl:call-template name="article-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='unbestimmter Artikel' and
                            string-length(normalize-space(dwds:Genus))&gt;0">
              <xsl:call-template name="article-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- nouns -->
            <xsl:when test="$pos='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Singular' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            (string-length(normalize-space(dwds:Genitiv))&gt;0 or
                             $abbreviation='yes')">
              <xsl:call-template name="noun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="noun-type">
                  <xsl:call-template name="get-noun-type-value">
                    <xsl:with-param name="meaning-type"
                                    select="$meaning-type"/>
                  </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="number">singular</xsl:with-param>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Plural'">
              <xsl:call-template name="noun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="noun-type">
                  <xsl:call-template name="get-noun-type-value">
                    <xsl:with-param name="meaning-type"
                                    select="$meaning-type"/>
                  </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="number">plural</xsl:with-param>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            ((string-length(normalize-space(dwds:Genitiv))&gt;0 and
                              string-length(normalize-space(dwds:Plural))&gt;0) or
                             $abbreviation='yes')">
              <xsl:call-template name="noun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="noun-type">
                  <xsl:call-template name="get-noun-type-value">
                    <xsl:with-param name="meaning-type"
                                    select="$meaning-type"/>
                  </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="nominative-plural"
                                select="normalize-space(dwds:Plural)"/>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- proper names -->
            <xsl:when test="$pos='Eigenname' and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Singular' and
                            ((string-length(normalize-space(dwds:Genus))&gt;0 and
                              string-length(normalize-space(dwds:Genitiv))&gt;0) or
                             $abbreviation='yes')">
              <xsl:call-template name="name-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="number">singular</xsl:with-param>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Eigenname' and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Plural'">
              <xsl:call-template name="name-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="number">plural</xsl:with-param>
                <xsl:with-param name="diminutive"
                                select="$diminutive"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- cardinals -->
            <xsl:when test="$pos='Kardinalzahl' and
                            string-length(normalize-space(dwds:Genus))&gt;0">
              <xsl:call-template name="cardinal-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Kardinalzahl'">
              <xsl:call-template name="cardinal-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- ordinals -->
            <xsl:when test="$pos='Ordinalzahl'">
              <xsl:call-template name="ordinal-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- fractions -->
            <xsl:when test="$pos='Bruchzahl'">
              <xsl:call-template name="fraction-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- demonstrative pronouns -->
            <xsl:when test="$pos='Demonstrativpronomen' and
                            (string-length(normalize-space(dwds:Genus))&gt;0 or
                             dwds:indeklinabel) and
                            not(dwds:Kasuspraeferenz[not(@Frequenz)]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <xsl:call-template name="demonstrative-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- indefinite pronouns -->
            <xsl:when test="$pos='Indefinitpronomen' and
                            $lemma='beide'">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            ($lemma='jedermann' or
                             $lemma='jedefrau')">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            ends-with($lemma,'jemand')">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            $lemma='mehrere'">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            ($lemma='man' or
                             $lemma='frau' or
                             $lemma='mensch')">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            $lemma='unsereiner'">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            $lemma='manche'">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            $lemma='niemand'">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            (ends-with($lemma,'was') or
                             ends-with($lemma,'wer'))">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Indefinitpronomen' and
                            (string-length(normalize-space(dwds:Genus))&gt;0 or
                             dwds:indeklinabel)">
              <xsl:call-template name="indefinite-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- interrogative pronouns -->
            <xsl:when test="$pos='Interrogativpronomen' and
                            ($lemma='wer' or
                             $lemma='was')">
              <xsl:call-template name="interrogative-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Interrogativpronomen' and
                            string-length(normalize-space(dwds:Genus))&gt;0">
              <xsl:call-template name="interrogative-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- irreflexive personal pronouns -->
            <xsl:when test="$pos='Personalpronomen' and
                            not(dwds:Kasuspraeferenz[not(@Frequenz)]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <xsl:call-template name="personal-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- reflexive personal pronouns -->
            <xsl:when test="$pos='Reflexivpronomen' and
                            ($lemma='dich' or
                             $lemma='Dich' or
                             $lemma='euch' or
                             $lemma='Euch' or
                             $lemma='mich' or
                             $lemma='sich' or
                             $lemma='uns')">
              <xsl:call-template name="reflexive-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- reciprocal personal pronouns -->
            <xsl:when test="$pos='reziprokes Pronomen'">
              <xsl:call-template name="reciprocal-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- possessive pronouns -->
            <xsl:when test="$pos='Possessivpronomen' and
                            (string-length(normalize-space(dwds:Genus))&gt;0 or
                             $abbreviation='yes')">
              <xsl:call-template name="possessive-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- relative pronouns -->
            <xsl:when test="$pos='Relativpronomen' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            not(dwds:Kasuspraeferenz[not(@Frequenz)]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <xsl:call-template name="relative-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Relativpronomen' and
                            ($lemma='wer' or
                             $lemma='was')">
              <xsl:call-template name="relative-pronoun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- verbs -->
            <xsl:when test="$pos='Verb' and
                            ((string-length(normalize-space(dwds:Praesens))&gt;0 and
                              string-length(normalize-space(dwds:Praeteritum))&gt;0 and
                              string-length(normalize-space(dwds:Partizip_II))&gt;0 and
                              string-length(normalize-space(dwds:Auxiliar))&gt;0) or
                             $abbreviation='yes')">
              <xsl:call-template name="verb-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="present">
                  <!-- remove "sich", if any -->
                  <xsl:choose>
                    <xsl:when test="tokenize(normalize-space(dwds:Praesens),'&#x20;')[2]='sich'">
                      <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens),'&#x20;'),2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(dwds:Praesens)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="past">
                  <!-- remove "sich", if any -->
                  <xsl:choose>
                    <xsl:when test="tokenize(normalize-space(dwds:Praeteritum),'&#x20;')[2]='sich'">
                      <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praeteritum),'&#x20;'),2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(dwds:Praeteritum)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="participle"
                                select="normalize-space(dwds:Partizip_II)"/>
                <xsl:with-param name="auxiliary"
                                select="normalize-space(dwds:Auxiliar)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- verbal participles (ad-hoc POS) -->
            <xsl:when test="$pos='Partizip' and
                            string-length(normalize-space(dwds:Praesens))&gt;0 and
                            string-length(normalize-space(dwds:Partizip_II))&gt;0 and
                            string-length(normalize-space(dwds:Auxiliar))&gt;0">
              <xsl:call-template name="participle-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="present">
                  <!-- remove "sich", if any -->
                  <xsl:choose>
                    <xsl:when test="tokenize(normalize-space(dwds:Praesens),'&#x20;')[2]='sich'">
                      <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens),'&#x20;'),2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(dwds:Praesens)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="participle"
                                select="normalize-space(dwds:Partizip_II)"/>
                <xsl:with-param name="auxiliary"
                                select="normalize-space(dwds:Auxiliar)"/>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- interjections -->
            <xsl:when test="$pos='Interjektion'">
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
                <xsl:with-param name="class">Intj</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- adpositions -->
            <xsl:when test="$pos='Präposition'">
              <xsl:call-template name="adposition-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="position">
                  <xsl:call-template name="get-position-value"/>
                </xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- contracted adpositions -->
            <xsl:when test="$pos='Präposition + Artikel'">
              <xsl:choose>
                <xsl:when test="$lemma='am'">
                  <xsl:call-template name="contracted-adposition-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="adposition"
                                    select="$adposition"/>
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
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pos">OTHER</xsl:with-param>
                    <xsl:with-param name="class">PtclAdjSup</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="contracted-adposition-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="adposition"
                                    select="$adposition"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- conjunctions -->
            <xsl:when test="$pos='Konjunktion'">
              <xsl:choose>
                <xsl:when test="$lemma='als'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">coord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">subord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">adjcomp</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='auch'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">coord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">subord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='doch'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">coord</xsl:with-param>
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
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pos">OTHER</xsl:with-param>
                    <xsl:with-param name="class">Intj</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='sowie'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">coord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">subord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='trotzdem'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">subord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='wie'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">subord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">adjcomp</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='&amp;' or
                                $lemma='aber' or
                                $lemma='außer' or
                                $lemma='beziehungsweise' or
                                $lemma='bzw.' or
                                $lemma='denn' or
                                $lemma='entweder' or
                                $lemma='geschweige' or
                                $lemma='oder' or
                                $lemma='respektive' or
                                $lemma='sondern' or
                                $lemma='sowie' or
                                $lemma='sowohl' or
                                $lemma='und' or
                                $lemma='weder'"><!-- ... -->
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">coord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='alldieweil' or
                                $lemma='allwo' or
                                $lemma='bis' or
                                $lemma='bevor' or
                                $lemma='da' or
                                $lemma='damit' or
                                $lemma='dass' or
                                $lemma='ehe' or
                                $lemma='eh’' or
                                $lemma='falls' or
                                $lemma='gleichwohl' or
                                $lemma='indem' or
                                $lemma='insofern' or
                                $lemma='insoweit' or
                                $lemma='inwieweit' or
                                $lemma='je' or
                                $lemma='nachdem' or
                                $lemma='ob' or
                                $lemma='obgleich' or
                                $lemma='obschon' or
                                $lemma='obwohl' or
                                $lemma='obzwar' or
                                $lemma='seit' or
                                $lemma='seitdem' or
                                $lemma='sintemalen' or
                                $lemma='sobald' or
                                $lemma='sodass' or
                                $lemma='sofern' or
                                $lemma='solang' or
                                $lemma='solange' or
                                $lemma='sooft' or
                                $lemma='soviel' or
                                $lemma='soweit' or
                                $lemma='sowenig' or
                                $lemma='umso' or
                                $lemma='während' or
                                $lemma='weil' or
                                $lemma='wenn' or
                                $lemma='wenngleich' or
                                $lemma='wennschon' or
                                $lemma='wieweit' or
                                $lemma='wiewohl' or
                                $lemma='wofern' or
                                $lemma='wohingegen' or
                                $lemma='zumal'"><!-- ... -->
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">subord</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='anstatt' or
                                $lemma='statt' or
                                $lemma='ohne' or
                                $lemma='um'">
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">infcl</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='desto'"><!-- ... -->
                  <xsl:call-template name="conjunction-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="type">adjcomp</xsl:with-param>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- particles: -->
            <xsl:when test="$pos='Partikel'">
              <xsl:choose>
                <xsl:when test="$lemma='ja' or
                                $lemma='bitte'">
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
                    <xsl:with-param name="class">Intj</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$lemma='gä' or
                                $lemma='ge' or
                                $lemma='gell' or
                                $lemma='gelle' or
                                $lemma='gelt' or
                                $lemma='nein'">
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
                    <xsl:with-param name="class">Intj</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="adverb-entry-set">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' or
                            $pos='Verb' or
                            $pos='Partizip' or
                            $pos='Präposition' or
                            $pos='Konjunktion'">
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has an incomplete grammar specification with POS "</xsl:text>
                <xsl:value-of select="$pos"/>
                <xsl:text>".</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:when test="string-length($pos)&gt;0">
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has a grammar specification with unsupported POS "</xsl:text>
                <xsl:value-of select="$pos"/>
                <xsl:text>".</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has a grammar specification with empty POS.</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <!-- compounding stems directly encoded in DWDS sources -->
        <xsl:for-each select="$word-formation-specs/dwds:Grammatik">
          <xsl:variable name="pos"
                        select="normalize-space(dwds:Wortklasse[not(@class='invisible')])"/>
          <xsl:choose>
            <xsl:when test="$pos='Adjektiv' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="adjective-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="noun-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Eigenname' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="name-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Kardinalzahl' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="cardinal-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Ordinalzahl' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="ordinal-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Bruchzahl' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="fraction-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Verb' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="verb-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Kompositionsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- ... -->
            <!-- <xsl:when test="$pos='Adjektiv' or
                            $pos='Substantiv' or
                            $pos='Eigenname' or
                            $pos='Kardinalzahl' or
                            $pos='Ordinalzahl' or
                            $pos='Bruchzahl' or
                            $pos='Verb'">
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has an incomplete word-formation specification with POS "</xsl:text>
                <xsl:value-of select="$pos"/>
                <xsl:text>".</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:when test="string-length(normalize-space(dwds:Wortklasse[not(@class='invisible')]))&gt;0">
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has a word-formation specification with unsupported POS "</xsl:text>
                <xsl:value-of select="$pos"/>
                <xsl:text>".</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has a word-formation specification with empty POS.</xsl:text>
              </xsl:message>
            </xsl:otherwise> -->
          </xsl:choose>
        </xsl:for-each>
        <!-- derivation stems directly encoded in DWDS sources -->
        <xsl:for-each select="$word-formation-specs/dwds:Grammatik">
          <xsl:variable name="pos"
                        select="normalize-space(dwds:Wortklasse[not(@class='invisible')])"/>
          <xsl:choose>
            <xsl:when test="$pos='Adjektiv' and
                            string-length(normalize-space(dwds:Derivationsstamm))&gt;0">
              <xsl:call-template name="adjective-der-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Derivationsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="suffs"
                                as="item()*"
                                select="@Suffixe"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            string-length(normalize-space(dwds:Derivationsstamm))&gt;0">
              <xsl:call-template name="noun-der-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Derivationsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="suffs"
                                as="item()*"
                                select="@Suffixe"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Eigenname' and
                            string-length(normalize-space(dwds:Derivationsstamm))&gt;0">
              <xsl:call-template name="name-der-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Derivationsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="suffs"
                                as="item()*"
                                select="@Suffixe"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Kardinalzahl' and
                            string-length(normalize-space(dwds:Derivationsstamm))&gt;0">
              <xsl:call-template name="cardinal-der-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Derivationsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="suffs"
                                as="item()*"
                                select="@Suffixe"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Ordinalzahl' and
                            string-length(normalize-space(dwds:Derivationsstamm))&gt;0">
              <xsl:call-template name="ordinal-der-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Derivationsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="suffs"
                                as="item()*"
                                select="@Suffixe"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Verb' and
                            string-length(normalize-space(dwds:Derivationsstamm))&gt;0">
              <xsl:call-template name="verb-der-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="normalize-space(dwds:Derivationsstamm)"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="suffs"
                                as="item()*"
                                select="@Suffixe"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- ... -->
            <!-- <xsl:when test="$pos='Adjektiv' or
                            $pos='Substantiv' or
                            $pos='Eigenname' or
                            $pos='Kardinalzahl' or
                            $pos='Ordinalzahl' or
                            $pos='Verb'">
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has an incomplete word-formation specification with POS "</xsl:text>
                <xsl:value-of select="$pos"/>
                <xsl:text>".</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:when test="string-length(normalize-space(dwds:Wortklasse[not(@class='invisible')]))&gt;0">
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has a word-formation specification with unsupported POS "</xsl:text>
                <xsl:value-of select="$pos"/>
                <xsl:text>".</xsl:text>
              </xsl:message>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Warning: "</xsl:text>
                <xsl:value-of select="$lemma"/>
                <xsl:text>" in </xsl:text>
                <xsl:value-of select="$file"/>
                <xsl:text> has a word-formation specification with empty POS.</xsl:text>
              </xsl:message>
            </xsl:otherwise> -->
          </xsl:choose>
        </xsl:for-each>
        <!-- compounding stems inferred from links to the compound bases -->
        <xsl:for-each select="../../dwds:Verweise[not(@Typ!='Komposition')]
                                                 [dwds:Verweis[not(@class='invisible')]
                                                              [@Typ='Erstglied']]
                                                 [not(dwds:Verweis[not(@class='invisible')]
                                                                  [@Typ='Binnenglied'])]
                                                 [dwds:Verweis[not(@class='invisible')]
                                                              [@Typ='Letztglied']]">
          <xsl:variable name="basis1"
                        select="normalize-space(dwds:Verweis[not(@class='invisible')]
                                                            [@Typ='Erstglied']/dwds:Ziellemma)"/>
          <xsl:variable name="basis2"
                        select="normalize-space(dwds:Verweis[not(@class='invisible')]
                                                            [@Typ='Letztglied']/dwds:Ziellemma)"/>
          <!-- ignore affixes -->
          <xsl:if test="not(starts-with($lemma,'-') or
                            ends-with($lemma,'-')) and
                        not(starts-with($basis1,'-') or
                            ends-with($basis1,'-')) and
                        not(starts-with($basis2,'-') or
                            ends-with($basis2,'-'))">
            <xsl:variable name="index1"
                          select="dwds:Verweis[not(@class='invisible')]
                                              [@Typ='Erstglied']/dwds:Ziellemma/@hidx"/>
            <xsl:variable name="index2"
                          select="dwds:Verweis[not(@class='invisible')]
                                              [@Typ='Letztglied']/dwds:Ziellemma/@hidx"/>
            <xsl:variable name="source1"
                          select="$manifest/source[@lemma=$basis1]
                                                  [@index=$index1 or
                                                   not(@index) and string-length($index1)=0][1]"/>
            <xsl:variable name="source2"
                          select="$manifest/source[@lemma=$basis2]
                                                  [@index=$index2 or
                                                   not(@index) and string-length($index2)=0][1]"/>
            <xsl:variable name="file1"
                          select="$source1/@href"/>
            <xsl:variable name="file2"
                          select="$source2/@href"/>
            <xsl:variable name="n1"
                          select="$source1/@n"/>
            <xsl:variable name="n2"
                          select="$source2/@n"/>
            <xsl:variable name="article1">
              <xsl:if test="doc-available(n:absolute-path($file1))">
                <xsl:copy-of select="doc(n:absolute-path($file1))/dwds:DWDS/dwds:Artikel[position()=$n1]/*"/>
              </xsl:if>
            </xsl:variable>
            <xsl:variable name="article2">
              <xsl:if test="doc-available(n:absolute-path($file2))">
                <xsl:copy-of select="doc(n:absolute-path($file2))/dwds:DWDS/dwds:Artikel[position()=$n2]/*"/>
              </xsl:if>
            </xsl:variable>
            <xsl:for-each select="$article1">
              <xsl:variable name="etymology1">
                <xsl:call-template name="get-etymology-value"/>
              </xsl:variable>
              <!-- ignore symbols and abbreviations -->
              <xsl:for-each select="dwds:Formangabe[not(@class='invisible')]
                                                   [not(@Typ='Abkürzung' or
                                                        @Typ='Symbol')]">
                <xsl:variable name="pos1"
                              select="normalize-space(dwds:Grammatik/dwds:Wortklasse[not(@class='invisible')])"/>
                <xsl:if test="string-length($pos1)&gt;0">
                  <!-- ignore idioms and non-standard spellings -->
                  <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                       [not(@Typ)]">
                    <xsl:variable name="lemma1"
                                  select="normalize-space(.)"/>
                    <xsl:if test="string-length($lemma1)&gt;0">
                      <xsl:variable name="abbreviation1">
                        <xsl:call-template name="get-abbreviation-value"/>
                      </xsl:variable>
                      <xsl:for-each select="$article2">
                        <!-- ignore symbols and abbreviations -->
                        <xsl:for-each select="dwds:Formangabe[not(@class='invisible')]
                                                             [not(@Typ='Abkürzung' or
                                                                  @Typ='Symbol')]">
                          <!-- ignore idioms and non-standard spellings -->
                          <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                               [not(@Typ)]">
                            <xsl:variable name="lemma2"
                                          select="normalize-space(.)"/>
                            <xsl:if test="string-length($lemma2)&gt;0">
                              <xsl:variable name="comp-stem">
                                <xsl:call-template name="comp-stem">
                                  <xsl:with-param name="lemma"
                                                  select="$lemma"/>
                                  <xsl:with-param name="lemma1"
                                                  select="$lemma1"/>
                                  <xsl:with-param name="lemma2"
                                                  select="$lemma2"/>
                                </xsl:call-template>
                              </xsl:variable>
                              <xsl:if test="string-length($comp-stem)&gt;0">
                                <xsl:choose>
                                  <xsl:when test="$pos1='Adjektiv'">
                                    <xsl:call-template name="adjective-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Substantiv'">
                                    <xsl:call-template name="noun-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Eigenname'">
                                    <xsl:call-template name="name-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Kardinalzahl'">
                                    <xsl:call-template name="cardinal-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Ordinalzahl'">
                                    <xsl:call-template name="ordinal-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Bruchzahl'">
                                    <xsl:call-template name="fraction-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Verb'">
                                    <xsl:call-template name="verb-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$comp-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <!-- ... -->
                                </xsl:choose>
                              </xsl:if>
                            </xsl:if>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
        <!-- derivation stems inferred from links to the derivation bases -->
        <xsl:for-each select="../../dwds:Verweise[not(@Typ!='Derivation')]
                                                 [dwds:Verweis[not(@class='invisible')]
                                                              [@Typ='Erstglied']]
                                                 [not(dwds:Verweis[not(@class='invisible')]
                                                                  [@Typ='Binnenglied'])]
                                                 [dwds:Verweis[not(@class='invisible')]
                                                              [@Typ='Letztglied']]">

          <xsl:variable name="basis"
                        select="normalize-space(dwds:Verweis[not(@class='invisible')]
                                                            [@Typ='Erstglied']/dwds:Ziellemma)"/>
          <xsl:variable name="affix"
                        select="normalize-space(dwds:Verweis[not(@class='invisible')]
                                                            [@Typ='Letztglied']/dwds:Ziellemma)"/><!-- suffix -->
          <!-- ignore affixes as $lemma and $basis,
               and ensure that $affix is a suffix -->
          <xsl:if test="not(starts-with($lemma,'-') or
                            ends-with($lemma,'-')) and
                        not(starts-with($basis,'-') or
                            ends-with($basis,'-')) and
                        starts-with($affix,'-') and
                        not(ends-with($affix,'-'))">
            <xsl:variable name="index1"
                          select="dwds:Verweis[not(@class='invisible')]
                                              [@Typ='Erstglied']/dwds:Ziellemma/@hidx"/>
            <xsl:variable name="index2"
                          select="dwds:Verweis[not(@class='invisible')]
                                              [@Typ='Letztglied']/dwds:Ziellemma/@hidx"/>
            <xsl:variable name="source1"
                          select="$manifest/source[@lemma=$basis]
                                                  [@index=$index1 or
                                                   not(@index) and string-length($index1)=0][1]"/>
            <xsl:variable name="source2"
                          select="$manifest/source[@lemma=$affix]
                                                  [@index=$index2 or
                                                   not(@index) and string-length($index2)=0][1]"/>
            <xsl:variable name="file1"
                          select="$source1/@href"/>
            <xsl:variable name="file2"
                          select="$source2/@href"/>
            <xsl:variable name="n1"
                          select="$source1/@n"/>
            <xsl:variable name="n2"
                          select="$source2/@n"/>
            <xsl:variable name="article1">
              <xsl:if test="doc-available(n:absolute-path($file1))">
                <xsl:copy-of select="doc(n:absolute-path($file1))/dwds:DWDS/dwds:Artikel[position()=$n1]/*"/>
              </xsl:if>
            </xsl:variable>
            <xsl:variable name="article2">
              <xsl:if test="doc-available(n:absolute-path($file2))">
                <xsl:copy-of select="doc(n:absolute-path($file2))/dwds:DWDS/dwds:Artikel[position()=$n2]/*"/>
              </xsl:if>
            </xsl:variable>
            <xsl:for-each select="$article1">
              <xsl:variable name="etymology1">
                <xsl:call-template name="get-etymology-value"/>
              </xsl:variable>
              <!-- ignore symbols and abbreviations -->
              <xsl:for-each select="dwds:Formangabe[not(@class='invisible')]
                                                   [not(@Typ='Abkürzung' or
                                                        @Typ='Symbol')]">
                <xsl:variable name="pos1"
                              select="normalize-space(dwds:Grammatik/dwds:Wortklasse[not(@class='invisible')])"/>
                <xsl:if test="string-length($pos1)&gt;0">
                  <!-- ignore idioms and non-standard spellings -->
                  <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                       [not(@Typ)]">
                    <xsl:variable name="lemma1"
                                  select="normalize-space(.)"/>
                    <xsl:if test="string-length($lemma1)&gt;0">
                      <xsl:variable name="abbreviation1">
                        <xsl:call-template name="get-abbreviation-value"/>
                      </xsl:variable>
                      <xsl:for-each select="$article2">
                        <!-- ignore symbols abbreviations -->
                        <xsl:for-each select="dwds:Formangabe[not(@class='invisible')]
                                                             [not(@Typ='Abkürzung' or
                                                                  @Typ='Symbol')]">
                          <!-- ignore idioms and non-standard spellings -->
                          <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                               [not(@Typ)]">
                            <xsl:variable name="lemma2"
                                          select="substring-after(normalize-space(.),'-')"/><!-- suffix lemma -->
                            <xsl:if test="string-length($lemma2)&gt;0">
                              <xsl:variable name="der-stem">
                                <xsl:call-template name="der-stem">
                                  <xsl:with-param name="lemma"
                                                  select="$lemma"/>
                                  <xsl:with-param name="lemma1"
                                                  select="$lemma1"/>
                                  <xsl:with-param name="lemma2"
                                                  select="$lemma2"/>
                                </xsl:call-template>
                              </xsl:variable>
                              <xsl:variable name="suffs"
                                            as="item()*">
                                <xsl:choose>
                                  <!-- "-chen" -->
                                  <xsl:when test="$lemma2='chen'">
                                    <xsl:choose>
                                      <!-- idiosyncratic forms -->
                                      <xsl:when test="$lemma='Frauchen'">
                                        <xsl:sequence select="$lemma2"/>
                                      </xsl:when>
                                      <xsl:when test="$lemma='Muttchen'">
                                        <xsl:sequence select="$lemma2"/>
                                      </xsl:when>
                                      <!-- ... -->
                                      <xsl:otherwise>
                                        <!-- also used for "-lein" -->
                                        <xsl:sequence select="$lemma2,'lein'"/>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </xsl:when>
                                  <!-- ... -->
                                  <xsl:otherwise>
                                    <xsl:sequence select="$lemma2"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:variable>
                              <xsl:if test="string-length($der-stem)&gt;0">
                                <xsl:choose>
                                  <xsl:when test="$pos1='Adjektiv'">
                                    <xsl:call-template name="adjective-der-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$der-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="suffs"
                                                      select="$suffs"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Substantiv'">
                                    <xsl:call-template name="noun-der-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$der-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="suffs"
                                                      select="$suffs"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Eigenname'">
                                    <xsl:call-template name="name-der-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$der-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="suffs"
                                                      select="$suffs"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Kardinalzahl'">
                                    <xsl:call-template name="cardinal-der-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$der-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="suffs"
                                                      select="$suffs"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Ordinalzahl'">
                                    <xsl:call-template name="ordinal-der-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$der-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="suffs"
                                                      select="$suffs"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Verb'">
                                    <xsl:call-template name="verb-der-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="stem"
                                                      select="$der-stem"/>
                                      <xsl:with-param name="abbreviation"
                                                      select="$abbreviation1"/>
                                      <xsl:with-param name="suffs"
                                                      select="$suffs"/>
                                      <xsl:with-param name="etymology"
                                                      select="$etymology1"/>
                                    </xsl:call-template>
                                  </xsl:when>
                                  <!-- ... -->
                                </xsl:choose>
                              </xsl:if>
                            </xsl:if>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<!-- helper templates -->

<!-- group multiple grammar specifications of the same type
     into separate <dwds:Grammatik> elements -->
<!-- cf. https://stackoverflow.com/q/35525010 -->

<xsl:template match="*[not(position()=last())]/*"
              mode="group">
  <xsl:param name="previous" as="element()*"/>
  <xsl:apply-templates select="../following-sibling::*[1]/*"
                       mode="group">
    <xsl:with-param name="previous"
                    select="$previous | ."/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[position()=last()]/*"
              mode="group">
  <xsl:param name="previous"/>
  <dwds:Grammatik>
    <xsl:copy-of select="$previous"/>
    <xsl:copy-of select="."/>
  </dwds:Grammatik>
</xsl:template>

<xsl:template name="get-etymology-value">
  <xsl:choose>
    <xsl:when test="dwds:Diachronie[not(@class='invisible')]/dwds:Etymologie[not(@class='invisible')]/dwds:erwaehntes_Zeichen[@Sprache]">
      <xsl:choose>
        <xsl:when test="dwds:Diachronie[not(@class='invisible')]/dwds:Etymologie[not(@class='invisible')]/dwds:erwaehntes_Zeichen[@Sprache='ahd' or
                                                                                                                                  @Sprache='bair' or
                                                                                                                                  @Sprache='berlin' or
                                                                                                                                  @Sprache='dt' or
                                                                                                                                  @Sprache='frühnhd' or
                                                                                                                                  @Sprache='germ' or
                                                                                                                                  @Sprache='mhd' or
                                                                                                                                  @Sprache='mnd' or
                                                                                                                                  @Sprache='nd' or
                                                                                                                                  @Sprache='nhd' or
                                                                                                                                  @Sprache='nordd' or
                                                                                                                                  @Sprache='schweiz' or
                                                                                                                                  @Sprache='schweizerdt']">native</xsl:when><!-- ... -->
        <xsl:otherwise>foreign</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="dwds:Diachronie[not(@class='invisible')]/dwds:Etymologie[not(@class='invisible')]
                                                                            [not(*)]">
      <xsl:choose>
        <xsl:when test="dwds:Diachronie[not(@class='invisible')]/dwds:Etymologie[not(@class='invisible')]
                                                                                [string-length(normalize-space(.))=0]">native</xsl:when>
        <xsl:when test="dwds:Diachronie[not(@class='invisible')]/dwds:Etymologie[not(@class='invisible')]
                                                                                [contains(.,'Deutsch') or
                                                                                 contains(.,'deutsch')]">native</xsl:when>
        <xsl:otherwise>foreign</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>native</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-meaning-type-value">
  <xsl:choose>
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Generalisierung']
                                                                                                                                            [starts-with(normalize-space(.),'Maßangabe')]">measure</xsl:when>
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Generalisierung']
                                                                                                                                            [starts-with(normalize-space(.),'Maßeinheit')]">measure</xsl:when>
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Basis']
                                                                                                                                            [starts-with(normalize-space(.),'Maßeinheit')]">measure</xsl:when>
    <!-- TODO: more meaning-type values -->
    <xsl:otherwise>any</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-abbreviation-value">
  <xsl:choose>
    <!-- abbreviations with final period -->
    <xsl:when test="ends-with(normalize-space(.),'.')">yes</xsl:when>
    <!-- acronyms in uppercase letters with optional numbers and lowercase letters -->
    <xsl:when test="matches(normalize-space(.),'^\p{N}*\p{Lu}([\p{L}\p{N}]*\p{Lu})*\p{N}*$')">yes</xsl:when>
    <!-- acronyms consisting of uppercase letters preceded by a lowercase letter -->
    <xsl:when test="matches(normalize-space(.),'^\p{Ll}\p{Lu}+$')">yes</xsl:when>
    <!-- acronyms consisting of an uppercase consonant letter
         followed by lowercase consonant letters -->
    <xsl:when test="matches(normalize-space(.),'^[\p{Lu}-[AEIOUÄÖÜ]][\p{Ll}-[aeiouäöü]]+$')">yes</xsl:when>
    <!-- symbols -->
    <xsl:when test="matches(normalize-space(.),'^\p{Po}+$')">yes</xsl:when>
    <!-- spellings marked as symbols -->
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]
                                           [@Typ='Symbol']">yes</xsl:when>
    <!-- spellings marked as abbreviation -->
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]
                                           [@Typ='Abkürzung']">yes</xsl:when>
    <!-- letter names -->
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Generalisierung']
                                                                                                                                            [normalize-space(.)='Buchstabe']">yes</xsl:when>
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Basis']
                                                                                                                                            [matches(normalize-space(.),'^der .+ Buchstabe des Alphabets$')]">yes</xsl:when>
    <!-- sound names -->
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Basis']
                                                                                                                                            [matches(normalize-space(.),'^der Laut \p{L}$')]">yes</xsl:when>
    <!-- note names -->
    <xsl:when test="parent::dwds:Formangabe[not(@class='invisible')]/following-sibling::dwds:Lesart[not(@class='invisible')]/dwds:Definition[@Typ='Generalisierung']
                                                                                                                                            [normalize-space(.)='Tonbezeichnung']">yes</xsl:when>
    <xsl:otherwise>no</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-function-value">
  <xsl:choose>
    <xsl:when test="normalize-space(dwds:Funktionspraeferenz[@Frequenz='nur'])='attributiv'">attr</xsl:when>
    <xsl:when test="normalize-space(dwds:Einschraenkung)='nur attributiv'">attr</xsl:when>
    <xsl:when test="normalize-space(dwds:Funktionspraeferenz[@Frequenz='nur'])='prädikativ'">nonattr</xsl:when>
    <xsl:when test="normalize-space(dwds:Einschraenkung)='nur prädikativ'">nonattr</xsl:when>
    <xsl:when test="normalize-space(dwds:Funktionspraeferenz[@Frequenz='nicht'])='attributiv'">nonattr</xsl:when>
    <xsl:when test="normalize-space(dwds:Einschraenkung)='nicht attributiv'">nonattr</xsl:when>
    <!-- no test for "nicht prädikativ", which may still allow for adverbial use -->
    <xsl:otherwise>any</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-noun-type-value">
  <xsl:param name="meaning-type"/>
  <xsl:choose>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'bei Maßangabe')">measure-noun</xsl:when>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'bei Mengenangabe')">measure-noun</xsl:when>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'bei Wertangabe')">measure-noun</xsl:when>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'mit Mengenangabe')">measure-noun</xsl:when>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'nach Zahlenangabe')">measure-noun</xsl:when>
    <xsl:when test="$meaning-type='measure'">measure-noun</xsl:when>
    <!-- TODO: more noun-type values -->
    <xsl:otherwise>any</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-inflection-value">
  <xsl:choose>
    <xsl:when test="dwds:indeklinabel">no</xsl:when>
    <xsl:otherwise>yes</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-position-value">
  <xsl:choose>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'auch nachgestellt')">any</xsl:when>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'nachgestellt')">post</xsl:when>
    <xsl:otherwise>pre</xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
