<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2lexicon.xsl -->
<!-- Version 19.0 -->
<!-- Andreas Nolda 2025-09-09 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib"
                exclude-result-prefixes="dwds n">

<xsl:include href="files.xsl"/>

<xsl:include href="forms.xsl"/>

<xsl:include href="strings.xsl"/>

<xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"/>

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
  <lexicon>
    <xsl:for-each select="distinct-values($manifest/source/@href)">
      <xsl:call-template name="process-sources">
        <xsl:with-param name="file"
                        select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </lexicon>
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
  <lexicon>
    <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel">
      <xsl:with-param name="file"
                      select="n:relative-path(document-uri(/))"/>
    </xsl:apply-templates>
  </lexicon>
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
          <xsl:when test="../dwds:Verweise[not(@class='invisible')]
                                          [@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
                                                                          [@Typ='Letztglied']/dwds:Ziellemma[normalize-space(.)='-chen']">chen</xsl:when>
          <xsl:when test="../dwds:Verweise[not(@class='invisible')]
                                          [@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
                                                                          [@Typ='Letztglied']/dwds:Ziellemma[normalize-space(.)='-lein' or
                                                                                                             normalize-space(.)='-le' or
                                                                                                             normalize-space(.)='-li']">lein</xsl:when>
          <xsl:when test="../dwds:Verweise[not(@class='invisible')]
                                          [@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
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
          <xsl:when test="../dwds:Verweise[not(@class='invisible')]
                                          [@Typ='Zusammenrückung']
                                          [dwds:Verweis[not(@class='invisible')]
                                                       [@Typ='Erstglied']]">
            <xsl:value-of select="normalize-space(../dwds:Verweise[not(@class='invisible')]
                                                                  [@Typ='Zusammenrückung']/dwds:Verweis[not(@class='invisible')]
                                                                                                       [@Typ='Erstglied']/dwds:Ziellemma)"/>
          </xsl:when>
          <!-- legacy representation -->
          <xsl:when test="../dwds:Verweise[not(@class='invisible')]
                                          [@Typ='Derivation']
                                          [dwds:Verweis[not(@class='invisible')]
                                                       [@Typ='Erstglied']]">
            <xsl:value-of select="normalize-space(../dwds:Verweise[not(@class='invisible')]
                                                                  [@Typ='Derivation']/dwds:Verweis[not(@class='invisible')]
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
                                                   self::dwds:Genitiv[count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=1] or
                                                   self::dwds:Plural[count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=1] or
                                                   self::dwds:Positivvariante[count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=1] or
                                                   self::dwds:Komparativ[count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=1] or
                                                   self::dwds:Superlativ[tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;')[1]='am']
                                                                        [count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=2] or
                                                   self::dwds:Superlativ[not(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;')[1]='am')]
                                                                        [count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=1] or
                                                   self::dwds:Praesens[tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;')[2]='sich']
                                                                      [count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))&lt;5] or
                                                   self::dwds:Praesens[not(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;')[2]='sich')]
                                                                      [count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))&lt;4] or
                                                   self::dwds:Praeteritum[tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;')[2]='sich']
                                                                         [count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))&lt;5] or
                                                   self::dwds:Praeteritum[not(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;')[2]='sich')]
                                                                         [count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))&lt;4] or
                                                   self::dwds:Partizip_II[count(tokenize(normalize-space(dwds:Wert[not(@Typ)]),'&#x20;'))=1] or
                                                   self::dwds:Auxiliar or
                                                   self::dwds:Funktionspraeferenz[not(normalize-space(.)='adverbiell')] or
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
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[normalize-space(dwds:Wert)='-es']] and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[normalize-space(dwds:Wert)='-s']]">
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[dwds:Genitiv[not(normalize-space(dwds:Wert)='-s')]]"/>
        </xsl:when>
        <!-- remove grammar specification for a verb with separable preverb only in the present tense -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Praesens[contains(normalize-space(dwds:Wert),'&#x20;')] and
                                                              dwds:Praeteritum[not(contains(normalize-space(dwds:Wert),'&#x20;'))]]"/>
        <!-- remove grammar specification for a verb with separable preverb only in the past tense -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Praeteritum[contains(normalize-space(dwds:Wert),'&#x20;')] and
                                                              dwds:Praesens[not(contains(normalize-space(dwds:Wert),'&#x20;'))]]"/>
        <!-- reduce grammar specification for a weak verb with strong participle to participle
             if there is another grammar specification for a weak verb with weak participle -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?n$')]] and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?t$')]] and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?n$')]]/dwds:Praesens/dwds:Wert=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?t$')]]/dwds:Praesens/dwds:Wert and
                        $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?n$')]]/dwds:Praeteritum/dwds:Wert=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?t$')]]/dwds:Praeteritum/dwds:Wert">
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[not(matches(normalize-space(dwds:Wert),'e?n$'))]]"/>
          <xsl:for-each select="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(dwds:Wert),'e?n$')]]">
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
                  select="distinct-values(dwds:Aussprache[not(@class='invisible')]/dwds:IPA[string-length(normalize-space(.))&gt;0]/replace(.,'\s',''))"/>
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
          <xsl:variable name="function">
            <xsl:if test="$pos='Adjektiv' or
                          $pos='partizipiales Adjektiv'"><!-- ... -->
              <xsl:call-template name="get-function-value"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="inflection">
            <xsl:if test="$pos='Adjektiv' or
                          $pos='partizipiales Adjektiv' or
                          $pos='Verb'"><!-- ... -->
              <xsl:call-template name="get-inflection-value"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="auxiliary">
            <xsl:if test="$pos='Verb' or
                          $pos='Partizip'">
              <xsl:call-template name="get-auxiliary-value"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="gender">
            <xsl:if test="$pos='bestimmter Artikel' or
                          $pos='unbestimmter Artikel' or
                          $pos='Demonstrativpronomen' or
                          $pos='Eigenname' or
                          $pos='Indefinitpronomen' or
                          $pos='Interrogativpronomen' or
                          $pos='Kardinalzahlwort' or
                          $pos='Personalpronomen' or
                          $pos='Possessivpronomen' or
                          $pos='Relativpronomen' or
                          $pos='Substantiv'">
              <xsl:call-template name="get-gender-value"/>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="noun-type">
            <xsl:if test="$pos='Substantiv'">
              <xsl:call-template name="get-noun-type-value">
                <xsl:with-param name="meaning-type"
                                select="$meaning-type"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="style">
            <xsl:if test="$pos='Substantiv'">
              <xsl:call-template name="get-style-value">
              </xsl:call-template>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="position">
            <xsl:if test="$pos='Präposition'">
              <xsl:call-template name="get-position-value"/>
            </xsl:if>
          </xsl:variable>
          <xsl:choose>
            <!-- adjectives and adjectival participles -->
            <xsl:when test="$pos='Adjektiv' or
                            $pos='partizipiales Adjektiv'">
              <xsl:variable name="positive"
                            select="normalize-space(dwds:Positivvariante/dwds:Wert)"/>
              <xsl:variable name="comparative"
                            select="normalize-space(dwds:Komparativ/dwds:Wert)"/>
              <xsl:variable name="superlative"
                            select="normalize-space(dwds:Superlativ/dwds:Wert)"/>
              <entry pos="adjective"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($function)&gt;0">
                  <xsl:attribute name="function"
                                 select="$function"/>
                </xsl:if>
                <xsl:if test="string-length($inflection)&gt;0">
                  <xsl:attribute name="inflection"
                                 select="$inflection"/>
                </xsl:if>
                <xsl:if test="string-length($positive)&gt;0">
                  <xsl:attribute name="positive"
                                 select="$positive"/>
                </xsl:if>
                <xsl:if test="string-length($comparative)&gt;0">
                  <xsl:attribute name="comparative"
                                 select="$comparative"/>
                </xsl:if>
                <xsl:if test="string-length($superlative)&gt;0">
                  <xsl:attribute name="superlative"
                                 select="$superlative"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- articles -->
            <xsl:when test="($pos='bestimmter Artikel' or
                             $pos='unbestimmter Artikel') and
                            not(dwds:Kasuspraeferenz[not(@Frequenz!='nur')]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <entry pos="article"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- cardinals -->
            <xsl:when test="$pos='Kardinalzahlwort'">
              <entry pos="numeral"
                     subcat="cardinal"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- ordinals -->
            <xsl:when test="$pos='Ordinalzahlwort'">
              <entry pos="numeral"
                     subcat="ordinal"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- fractional numerals -->
            <xsl:when test="$pos='Bruchzahlwort'">
              <entry pos="numeral"
                     subcat="fractional"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- proper names -->
            <xsl:when test="($pos='Eigenname' or
                             $pos='Substantiv' and $noun-type='proper-name') and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Singular' and
                            (($gender!='none' and
                              string-length(normalize-space(dwds:Genitiv/dwds:Wert))&gt;0) or
                             $abbreviation='yes')">
              <xsl:variable name="genitive-singular"
                            select="normalize-space(dwds:Genitiv/dwds:Wert)"/>
              <entry pos="name"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:attribute name="number">singular</xsl:attribute>
                <xsl:if test="string-length($genitive-singular)&gt;0">
                  <xsl:attribute name="genitive-singular"
                                 select="$genitive-singular"/>
                </xsl:if>
                <xsl:if test="string-length($diminutive)&gt;0">
                  <xsl:attribute name="diminutive"
                                 select="$diminutive"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="($pos='Eigenname' or
                             $pos='Substantiv' and $noun-type='proper-name') and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Plural'">
              <entry pos="name"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:attribute name="number">plural</xsl:attribute>
                <xsl:if test="string-length($diminutive)&gt;0">
                  <xsl:attribute name="diminutive"
                                 select="$diminutive"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- nouns -->
            <xsl:when test="$pos='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Singular' and
                            $gender!='none' and
                            (string-length(normalize-space(dwds:Genitiv/dwds:Wert))&gt;0 or
                             $abbreviation='yes')">
              <xsl:variable name="genitive-singular"
                            select="normalize-space(dwds:Genitiv/dwds:Wert)"/>
              <entry pos="noun"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($noun-type)&gt;0">
                  <xsl:attribute name="noun-type"
                                 select="$noun-type"/>
                </xsl:if>
                <xsl:if test="string-length($style)&gt;0">
                  <xsl:attribute name="style"
                                 select="$style"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:attribute name="number">singular</xsl:attribute>
                <xsl:if test="string-length($genitive-singular)&gt;0">
                  <xsl:attribute name="genitive-singular"
                                 select="$genitive-singular"/>
                </xsl:if>
                <xsl:if test="string-length($diminutive)&gt;0">
                  <xsl:attribute name="diminutive"
                                 select="$diminutive"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz[not(@class='invisible')])='nur im Plural'">
              <entry pos="noun"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($noun-type)&gt;0">
                  <xsl:attribute name="noun-type"
                                 select="$noun-type"/>
                </xsl:if>
                <xsl:if test="string-length($style)&gt;0">
                  <xsl:attribute name="style"
                                 select="$style"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:attribute name="number">plural</xsl:attribute>
                <xsl:if test="string-length($diminutive)&gt;0">
                  <xsl:attribute name="diminutive"
                                 select="$diminutive"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            $gender!='none' and
                            ((string-length(normalize-space(dwds:Genitiv/dwds:Wert))&gt;0 and
                              string-length(normalize-space(dwds:Plural/dwds:Wert))&gt;0) or
                             $abbreviation='yes')">
              <xsl:variable name="genitive-singular"
                            select="normalize-space(dwds:Genitiv/dwds:Wert)"/>
              <xsl:variable name="nominative-plural"
                            select="normalize-space(dwds:Plural/dwds:Wert)"/>
              <entry pos="noun"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($noun-type)&gt;0">
                  <xsl:attribute name="noun-type"
                                 select="$noun-type"/>
                </xsl:if>
                <xsl:if test="string-length($style)&gt;0">
                  <xsl:attribute name="style"
                                 select="$style"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="string-length($genitive-singular)&gt;0">
                  <xsl:attribute name="genitive-singular"
                                 select="$genitive-singular"/>
                </xsl:if>
                <xsl:if test="string-length($nominative-plural)&gt;0">
                  <xsl:attribute name="nominative-plural"
                                 select="$nominative-plural"/>
                </xsl:if>
                <xsl:if test="string-length($diminutive)&gt;0">
                  <xsl:attribute name="diminutive"
                                 select="$diminutive"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- demonstrative pronouns -->
            <xsl:when test="$pos='Demonstrativpronomen' and
                            not(dwds:Kasuspraeferenz[not(@Frequenz!='nur')]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <entry pos="pronoun"
                     subcat="demonstrative"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- indefinite pronouns -->
            <xsl:when test="$pos='Indefinitpronomen'">
              <entry pos="pronoun"
                     subcat="indefinite"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- interrogative pronouns -->
            <xsl:when test="$pos='Interrogativpronomen'">
              <entry pos="pronoun"
                     subcat="interrogative"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- personal pronouns -->
            <xsl:when test="$pos='Personalpronomen' and
                            not(dwds:Kasuspraeferenz[not(@Frequenz!='nur')]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <entry pos="pronoun"
                     subcat="personal"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- reflexive pronouns -->
            <xsl:when test="$pos='Reflexivpronomen'">
              <entry pos="pronoun"
                     subcat="reflexive"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- reciprocal personal pronouns -->
            <xsl:when test="$pos='reziprokes Pronomen'">
              <entry pos="pronoun"
                     subcat="reciprocal"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- possessive pronouns -->
            <xsl:when test="$pos='Possessivpronomen'">
              <entry pos="pronoun"
                     subcat="possessive"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- relative pronouns -->
            <xsl:when test="$pos='Relativpronomen' and
                            not(dwds:Kasuspraeferenz[not(@Frequenz!='nur')]
                                                    [normalize-space(.)='im Akkusativ' or
                                                     normalize-space(.)='im Dativ' or
                                                     normalize-space(.)='im Genitiv'])">
              <entry pos="pronoun"
                     subcat="relative"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($gender)&gt;0">
                  <xsl:attribute name="gender"
                                 select="$gender"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- verbs -->
            <xsl:when test="$pos='Verb' and
                            ((string-length(normalize-space(dwds:Praesens/dwds:Wert))&gt;0 and
                              string-length(normalize-space(dwds:Praeteritum/dwds:Wert))&gt;0 and
                              string-length(normalize-space(dwds:Partizip_II/dwds:Wert))&gt;0 and
                              $auxiliary!='none') or
                             $inflection='no' or
                             $abbreviation='yes')">
              <xsl:variable name="present">
                <!-- remove "sich", if any -->
                <xsl:choose>
                  <xsl:when test="tokenize(normalize-space(dwds:Praesens/dwds:Wert),'&#x20;')[2]='sich'">
                    <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens/dwds:Wert),'&#x20;'),2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(dwds:Praesens/dwds:Wert)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="past">
                <!-- remove "sich", if any -->
                <xsl:choose>
                  <xsl:when test="tokenize(normalize-space(dwds:Praeteritum/dwds:Wert),'&#x20;')[2]='sich'">
                    <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praeteritum/dwds:Wert),'&#x20;'),2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(dwds:Praeteritum/dwds:Wert)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="participle"
                            select="normalize-space(dwds:Partizip_II/dwds:Wert)"/>
              <entry pos="verb"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="$lemma-index">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($inflection)&gt;0">
                  <xsl:attribute name="inflection"
                                 select="$inflection"/>
                </xsl:if>
                <xsl:if test="string-length($present)&gt;0">
                  <xsl:attribute name="present"
                                 select="$present"/>
                </xsl:if>
                <xsl:if test="string-length($past)&gt;0">
                  <xsl:attribute name="past"
                                 select="$past"/>
                </xsl:if>
                <xsl:if test="string-length($participle)&gt;0">
                  <xsl:attribute name="participle"
                                 select="$participle"/>
                </xsl:if>
                <xsl:if test="string-length($auxiliary)&gt;0">
                  <xsl:attribute name="auxiliary"
                                 select="$auxiliary"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- verbal participles (ad-hoc POS) -->
            <xsl:when test="$pos='Partizip' and
                            string-length(normalize-space(dwds:Praesens/dwds:Wert))&gt;0 and
                            string-length(normalize-space(dwds:Partizip_II/dwds:Wert))&gt;0 and
                            $auxiliary!='none'">
              <xsl:variable name="present">
                <!-- remove "sich", if any -->
                <xsl:choose>
                  <xsl:when test="tokenize(normalize-space(dwds:Praesens/dwds:Wert),'&#x20;')[2]='sich'">
                    <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens/dwds:Wert),'&#x20;'),2)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(dwds:Praesens/dwds:Wert)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name="participle"
                            select="normalize-space(dwds:Partizip_II/dwds:Wert)"/>
              <entry pos="participle"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="$lemma-index">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($present)&gt;0">
                  <xsl:attribute name="present"
                                 select="$present"/>
                </xsl:if>
                <xsl:if test="string-length($participle)&gt;0">
                  <xsl:attribute name="participle"
                                 select="$participle"/>
                </xsl:if>
                <xsl:if test="string-length($auxiliary)&gt;0">
                  <xsl:attribute name="auxiliary"
                                 select="$auxiliary"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- adverbs and adverbial participles -->
            <xsl:when test="$pos='Adverb' or
                            $pos='partizipiales Adverb'">
              <xsl:choose>
                <xsl:when test="$lemma='allzu'">
                  <entry pos="particle"
                         subcat="intensifying"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='so'">
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="interjection"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='nicht'">
                  <entry pos="particle"
                         subcat="negative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='wie'">
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="comparative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='zu'">
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="particle"
                         subcat="intensifying"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="particle"
                         subcat="clausal"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="comparative"
                                select="normalize-space(dwds:Komparativ/dwds:Wert)"/>
                  <xsl:variable name="superlative"
                                select="normalize-space(dwds:Superlativ/dwds:Wert)"/>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="string-length($comparative)&gt;0">
                      <xsl:attribute name="comparative"
                                     select="$comparative"/>
                    </xsl:if>
                    <xsl:if test="string-length($superlative)&gt;0">
                      <xsl:attribute name="superlative"
                                     select="$superlative"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- pronominal adverbs -->
            <xsl:when test="$pos='Pronominaladverb'">
              <entry pos="pronominal-adverb"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- interjections -->
            <xsl:when test="$pos='Interjektion'">
              <entry pos="interjection"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- adpositions -->
            <xsl:when test="$pos='Präposition'">
              <entry pos="adposition"
                     type="base">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:if test="string-length($lemma-index)&gt;0">
                  <xsl:attribute name="lemma-index"
                                 select="$lemma-index"/>
                </xsl:if>
                <xsl:if test="string-length($paradigm-index)&gt;0">
                  <xsl:attribute name="paradigm-index"
                                 select="$paradigm-index"/>
                </xsl:if>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($position)&gt;0">
                  <xsl:attribute name="position"
                                 select="$position"/>
                </xsl:if>
                <xsl:if test="count($pronunciations)&gt;0">
                  <xsl:attribute name="pronunciations"
                                 select="$pronunciations"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- contracted adpositions -->
            <xsl:when test="$pos='Präposition + Artikel'">
              <xsl:choose>
                <xsl:when test="$lemma='am'">
                  <entry pos="contracted-adposition"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="string-length($adposition)&gt;0">
                      <xsl:attribute name="adposition"
                                     select="$adposition"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="particle"
                         subcat="superlative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:otherwise>
                  <entry pos="contracted-adposition"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="string-length($adposition)&gt;0">
                      <xsl:attribute name="adposition"
                                     select="$adposition"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- conjunctions -->
            <xsl:when test="$pos='Konjunktion'">
              <xsl:choose>
                <xsl:when test="$lemma='als'">
                  <entry pos="conjunction"
                         subcat="coordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="comparative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='auch'">
                  <entry pos="conjunction"
                         subcat="coordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='doch'">
                  <entry pos="conjunction"
                         subcat="coordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="interjection"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='sowie'">
                  <entry pos="conjunction"
                         subcat="coordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='trotzdem'">
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='wie'">
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="conjunction"
                         subcat="comparative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
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
                  <entry pos="conjunction"
                         subcat="coordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
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
                  <entry pos="conjunction"
                         subcat="subordinative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='anstatt' or
                                $lemma='statt' or
                                $lemma='ohne' or
                                $lemma='um'">
                  <entry pos="conjunction"
                         subcat="clausal"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='desto'"><!-- ... -->
                  <entry pos="conjunction"
                         subcat="comparative"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:otherwise>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <!-- particles: -->
            <xsl:when test="$pos='Partikel'">
              <xsl:choose>
                <xsl:when test="$lemma='ja' or
                                $lemma='bitte'">
                  <entry pos="interjection"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:when test="$lemma='gä' or
                                $lemma='ge' or
                                $lemma='gell' or
                                $lemma='gelle' or
                                $lemma='gelt' or
                                $lemma='nein'">
                  <entry pos="interjection"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
                </xsl:when>
                <xsl:otherwise>
                  <entry pos="adverb"
                         type="base">
                    <xsl:attribute name="lemma"
                                   select="$lemma"/>
                    <xsl:if test="string-length($lemma-index)&gt;0">
                      <xsl:attribute name="lemma-index"
                                     select="$lemma-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($paradigm-index)&gt;0">
                      <xsl:attribute name="paradigm-index"
                                     select="$paradigm-index"/>
                    </xsl:if>
                    <xsl:if test="string-length($abbreviation)&gt;0">
                      <xsl:attribute name="abbreviation"
                                     select="$abbreviation"/>
                    </xsl:if>
                    <xsl:if test="count($pronunciations)&gt;0">
                      <xsl:attribute name="pronunciations"
                                     select="$pronunciations"/>
                    </xsl:if>
                    <xsl:if test="string-length($etymology)&gt;0">
                      <xsl:attribute name="etymology"
                                     select="$etymology"/>
                    </xsl:if>
                  </entry>
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
        <!-- compounding and derivation stems directly encoded in DWDS sources -->
        <xsl:for-each select="$word-formation-specs/dwds:Grammatik">
          <xsl:variable name="pos"
                        select="normalize-space(dwds:Wortklasse[not(@class='invisible')])"/>
          <xsl:variable name="noun-type">
            <xsl:if test="$pos='Substantiv'">
              <xsl:call-template name="get-noun-type-value">
                <xsl:with-param name="meaning-type"
                                select="$meaning-type"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:variable>
          <xsl:variable name="comp-stem"
                        select="normalize-space(dwds:Kompositionsstamm)"/>
          <xsl:variable name="der-stem"
                        select="normalize-space(dwds:Derivationsstamm)"/>
          <xsl:variable name="suffs"
                        select="tokenize(normalize-space(dwds:Derivationsstamm/@Suffixe),'&#x20;')"/>
          <xsl:choose>
            <xsl:when test="$pos='Adjektiv' and
                            string-length($comp-stem)&gt;0">
              <entry pos="adjective"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Adjektiv' and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="adjective"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="($pos='Eigenname' or
                             $pos='Substantiv' and $noun-type='proper-name') and
                            string-length($comp-stem)&gt;0">
              <entry pos="name"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="($pos='Eigenname' or
                             $pos='Substantiv' and $noun-type='proper-name') and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="name"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            string-length($comp-stem)&gt;0">
              <entry pos="noun"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="noun"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Kardinalzahlwort' and
                            string-length($comp-stem)&gt;0">
              <entry pos="numeral"
                     subcat="cardinal"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Kardinalzahlwort' and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="numeral"
                     subcat="cardinal"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Ordinalzahlwort' and
                            string-length($comp-stem)&gt;0">
              <entry pos="numeral"
                     subcat="ordinal"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Ordinalzahlwort' and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="numeral"
                     subcat="ordinal"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Bruchzahlwort' and
                            string-length($comp-stem)&gt;0">
              <entry pos="numeral"
                     subcat="fractional"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Bruchzahlwort' and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="numeral"
                     subcat="fractional"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Verb' and
                            string-length($comp-stem)&gt;0">
              <entry pos="verb"
                     type="comp">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$comp-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <xsl:when test="$pos='Verb' and
                            string-length($der-stem)&gt;0 and
                            count($suffs)&gt;0">
              <entry pos="verb"
                     type="der">
                <xsl:attribute name="lemma"
                               select="$lemma"/>
                <xsl:attribute name="stem"
                               select="$der-stem"/>
                <xsl:if test="string-length($abbreviation)&gt;0">
                  <xsl:attribute name="abbreviation"
                                 select="$abbreviation"/>
                </xsl:if>
                <xsl:attribute name="suffs"
                               select="$suffs"/>
                <xsl:if test="string-length($etymology)&gt;0">
                  <xsl:attribute name="etymology"
                                 select="$etymology"/>
                </xsl:if>
              </entry>
            </xsl:when>
            <!-- ... -->
            <!-- <xsl:when test="$pos='Adjektiv' or
                            $pos='Eigenname' or
                            $pos='Substantiv' or
                            $pos='Kardinalzahlwort' or
                            $pos='Ordinalzahlwort' or
                            $pos='Bruchzahlwort' or
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
        <xsl:for-each select="../../dwds:Verweise[not(@class='invisible')]
                                                 [not(@Typ!='Komposition') or
                                                  @Typ='Zusammenrückung' and
                                                    ../dwds:Formangabe/dwds:Grammatik/dwds:Wortklasse[not(@class='invisible')]
                                                                                                     [normalize-space(.)='Kardinalzahlwort']]
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
                                    <entry pos="adjective"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Kardinalzahlwort'">
                                    <entry pos="numeral"
                                           subcat="cardinal"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Ordinalzahlwort'">
                                    <entry pos="numeral"
                                           subcat="ordinal"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Bruchzahlwort'">
                                    <entry pos="numeral"
                                           subcat="fractional"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Eigenname'">
                                    <entry pos="name"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Substantiv'">
                                    <entry pos="noun"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
                                  </xsl:when>
                                  <xsl:when test="$pos1='Verb'">
                                    <entry pos="verb"
                                           type="comp">
                                      <xsl:attribute name="lemma"
                                                     select="$lemma1"/>
                                      <xsl:attribute name="stem"
                                                     select="$comp-stem"/>
                                      <xsl:if test="string-length($abbreviation1)&gt;0">
                                        <xsl:attribute name="abbreviation"
                                                       select="$abbreviation1"/>
                                      </xsl:if>
                                      <xsl:if test="string-length($etymology1)&gt;0">
                                        <xsl:attribute name="etymology"
                                                       select="$etymology1"/>
                                      </xsl:if>
                                    </entry>
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
        <!-- derivation stems inferred from links to the derivation base and the affix -->
        <xsl:for-each select="../../dwds:Verweise[not(@class='invisible')]
                                                 [not(@Typ!='Derivation')]
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
                              <xsl:if test="string-length($der-stem)&gt;0">
                                <!-- suffixes -->
                                <xsl:variable name="suffs" as="xs:string*">
                                  <xsl:choose>
                                    <!-- "-bar" -->
                                    <xsl:when test="$lemma2='bar'">
                                      <xsl:sequence select="$lemma2"/>
                                    </xsl:when>
                                    <!-- "-e" -->
                                    <xsl:when test="$lemma2='e'">
                                      <xsl:sequence select="$lemma2"/>
                                    </xsl:when>
                                    <!-- "-er" -->
                                    <xsl:when test="$lemma2='er'">
                                      <xsl:sequence select="$lemma2"/>
                                    </xsl:when>
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
                                    <!-- "-lein" -->
                                    <xsl:when test="$lemma2='lein'">
                                      <xsl:sequence select="$lemma2"/>
                                    </xsl:when>
                                    <!-- "-st" and "-stel" -->
                                    <xsl:when test="$lemma2='st' or
                                                    $lemma2='stel'">
                                      <xsl:sequence select="$lemma2"/>
                                    </xsl:when>
                                    <!-- "-zig" -->
                                    <xsl:when test="$lemma2='zig'">
                                      <xsl:sequence select="$lemma2"/>
                                    </xsl:when>
                                    <!-- "-ßig" -->
                                    <xsl:when test="$lemma2='ßig'">
                                      <!-- normalise to "-zig" -->
                                      <xsl:sequence select="'zig'"/>
                                    </xsl:when>
                                    <!-- ... -->
                                    <xsl:otherwise>
                                      <xsl:message>
                                        <xsl:text>Warning: "</xsl:text>
                                        <xsl:value-of select="$lemma"/>
                                        <xsl:text>" in </xsl:text>
                                        <xsl:value-of select="$file"/>
                                        <xsl:text> has a word-formation analysis with unsupported suffix "-</xsl:text>
                                        <xsl:value-of select="."/>
                                        <xsl:text>".</xsl:text>
                                      </xsl:message>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:variable>
                                <xsl:if test="count($suffs)&gt;0">
                                  <xsl:choose>
                                    <xsl:when test="$pos1='Adjektiv'">
                                      <entry pos="adjective"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <xsl:when test="$pos1='Eigenname'">
                                      <entry pos="name"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <xsl:when test="$pos1='Substantiv'">
                                      <entry pos="noun"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <xsl:when test="$pos1='Kardinalzahlwort'">
                                      <entry pos="numeral"
                                             subcat="cardinal"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <xsl:when test="$pos1='Ordinalzahlwort'">
                                      <entry pos="numeral"
                                             subcat="ordinal"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <xsl:when test="$pos1='Bruchzahlwort'">
                                      <entry pos="numeral"
                                             subcat="fractional"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <xsl:when test="$pos1='Verb'">
                                      <entry pos="verb"
                                             type="der">
                                        <xsl:attribute name="lemma"
                                                       select="$lemma1"/>
                                        <xsl:attribute name="stem"
                                                       select="$der-stem"/>
                                        <xsl:if test="string-length($abbreviation1)&gt;0">
                                          <xsl:attribute name="abbreviation"
                                                         select="$abbreviation1"/>
                                        </xsl:if>
                                        <xsl:attribute name="suffs"
                                                       select="$suffs"/>
                                        <xsl:if test="string-length($etymology1)&gt;0">
                                          <xsl:attribute name="etymology"
                                                         select="$etymology1"/>
                                        </xsl:if>
                                      </entry>
                                    </xsl:when>
                                    <!-- ... -->
                                  </xsl:choose>
                                </xsl:if>
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
        <!-- derivation stems inferred from links to the derivation base only -->
        <xsl:for-each select="../../dwds:Verweise[not(@class='invisible')]
                                                 [not(@Typ!='Derivation')]
                                                 [dwds:Verweis[not(@class='invisible')]
                                                              [@Typ='Grundform']]">

          <xsl:variable name="basis"
                        select="normalize-space(dwds:Verweis[not(@class='invisible')]
                                                            [@Typ='Grundform']/dwds:Ziellemma)"/>
          <!-- ignore affixes as $lemma and $basis -->
          <xsl:if test="not(starts-with($lemma,'-') or
                            ends-with($lemma,'-')) and
                        not(starts-with($basis,'-') or
                            ends-with($basis,'-'))">
            <xsl:variable name="index1"
                          select="dwds:Verweis[not(@class='invisible')]
                                              [@Typ='Grundform']/dwds:Ziellemma/@hidx"/>
            <xsl:variable name="source1"
                          select="$manifest/source[@lemma=$basis]
                                                  [@index=$index1 or
                                                   not(@index) and string-length($index1)=0][1]"/>
            <xsl:variable name="file1"
                          select="$source1/@href"/>
            <xsl:variable name="n1"
                          select="$source1/@n"/>
            <xsl:variable name="article1">
              <xsl:if test="doc-available(n:absolute-path($file1))">
                <xsl:copy-of select="doc(n:absolute-path($file1))/dwds:DWDS/dwds:Artikel[position()=$n1]/*"/>
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
                <!-- currently, only cardinal bases are supported -->
                <xsl:if test="$pos1='Kardinalzahlwort'">
                  <!-- ignore idioms and non-standard spellings -->
                  <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                       [not(@Typ)]">
                    <xsl:variable name="lemma1"
                                  select="normalize-space(.)"/>
                    <xsl:if test="string-length($lemma1)&gt;0">
                      <xsl:variable name="abbreviation1">
                        <xsl:call-template name="get-abbreviation-value"/>
                      </xsl:variable>
                      <xsl:variable name="der-stem">
                        <xsl:choose>
                          <xsl:when test="$lemma1='acht'">
                            <xsl:call-template name="der-stem">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="lemma1"
                                              select="$lemma1"/>
                              <xsl:with-param name="lemma2">e</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:when test="ends-with($lemma1,'ig')">
                            <xsl:call-template name="der-stem">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="lemma1"
                                              select="$lemma1"/>
                              <xsl:with-param name="lemma2">ste</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:when test="$lemma1='hundert'">
                            <xsl:call-template name="der-stem">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="lemma1"
                                              select="$lemma1"/>
                              <xsl:with-param name="lemma2">ste</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:when test="$lemma1='tausend'">
                            <xsl:call-template name="der-stem">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="lemma1"
                                              select="$lemma1"/>
                              <xsl:with-param name="lemma2">ste</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- ... -->
                          <xsl:otherwise>
                            <xsl:call-template name="der-stem">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="lemma1"
                                              select="$lemma1"/>
                              <xsl:with-param name="lemma2">te</xsl:with-param>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:if test="string-length($der-stem)&gt;0">
                        <!-- suffixes -->
                        <xsl:variable name="suffs">
                          <xsl:choose>
                            <!-- "-st" -->
                            <xsl:when test="$lemma1='zwei'">
                              <!-- normalise to "-st" -->
                              <xsl:sequence select="'st'"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <!-- also used for "-stel" -->
                              <xsl:sequence select="'st','stel'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:variable>
                        <entry pos="numeral"
                               subcat="cardinal"
                               type="der">
                          <xsl:attribute name="lemma"
                                         select="$lemma1"/>
                          <xsl:attribute name="stem"
                                         select="$der-stem"/>
                          <xsl:if test="string-length($abbreviation1)&gt;0">
                            <xsl:attribute name="abbreviation"
                                           select="$abbreviation1"/>
                          </xsl:if>
                          <xsl:attribute name="suffs"
                                         select="$suffs"/>
                          <xsl:if test="string-length($etymology1)&gt;0">
                            <xsl:attribute name="etymology"
                                           select="$etymology1"/>
                          </xsl:if>
                        </entry>
                      </xsl:if>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
                <!-- also consider the nouns "Million" and "Milliarde" -->
                <xsl:if test="$pos1='Substantiv' and
                              dwds:Schreibung[normalize-space(.)='Million' or
                                              normalize-space(.)='Milliarde']">
                  <!-- ignore idioms and non-standard spellings -->
                  <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.),'&#x20;'))=1]
                                                       [not(@Typ)]">
                    <xsl:variable name="lemma1"
                                  select="normalize-space(.)"/>
                    <xsl:if test="string-length($lemma1)&gt;0">
                      <xsl:variable name="abbreviation1">
                        <xsl:call-template name="get-abbreviation-value"/>
                      </xsl:variable>
                      <xsl:variable name="der-stem">
                        <xsl:call-template name="der-stem">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="lemma1"
                                          select="$lemma1"/>
                          <xsl:with-param name="lemma2">ste</xsl:with-param>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:if test="string-length($der-stem)&gt;0">
                        <!-- suffixes -->
                        <xsl:variable name="suffs">
                          <!-- also used for "-stel" -->
                          <xsl:sequence select="'st','stel'"/>
                        </xsl:variable>
                        <entry pos="noun"
                               type="der">
                          <xsl:attribute name="lemma"
                                         select="$lemma1"/>
                          <xsl:attribute name="stem"
                                         select="$der-stem"/>
                          <xsl:if test="string-length($abbreviation1)&gt;0">
                            <xsl:attribute name="abbreviation"
                                           select="$abbreviation1"/>
                          </xsl:if>
                          <xsl:attribute name="suffs"
                                         select="$suffs"/>
                          <xsl:if test="string-length($etymology1)&gt;0">
                            <xsl:attribute name="etymology"
                                           select="$etymology1"/>
                          </xsl:if>
                        </entry>
                      </xsl:if>
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

<xsl:template name="get-gender-value">
  <xsl:choose>
    <xsl:when test="normalize-space(dwds:Genus)='mask.'">masculine</xsl:when>
    <xsl:when test="normalize-space(dwds:Genus)='neutr.'">neuter</xsl:when>
    <xsl:when test="normalize-space(dwds:Genus)='fem.'">feminine</xsl:when>
    <xsl:otherwise>none</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-noun-type-value">
  <xsl:param name="meaning-type"/>
  <xsl:choose>
    <xsl:when test="normalize-space(dwds:Funktionspraeferenz[not(@Frequenz!='nur')])='als Eigenname'">proper-name</xsl:when>
    <xsl:when test="normalize-space(dwds:Funktionspraeferenz)='nur als Eigenname'">proper-name</xsl:when>
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
    <xsl:when test="normalize-space(dwds:Einschraenkung)='nur im Infinitiv'">no</xsl:when>
    <xsl:otherwise>yes</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-auxiliary-value">
  <xsl:choose>
    <xsl:when test="normalize-space(dwds:Auxiliar/dwds:Wert)='hat'">haben</xsl:when>
    <xsl:when test="normalize-space(dwds:Auxiliar/dwds:Wert)='ist'">sein</xsl:when>
    <xsl:otherwise>none</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-position-value">
  <xsl:choose>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'auch nachgestellt')">any</xsl:when>
    <xsl:when test="contains(normalize-space(dwds:Einschraenkung),'nachgestellt')">post</xsl:when>
    <xsl:otherwise>pre</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-style-value">
  <xsl:choose>
    <xsl:when test="normalize-space(*/dwds:Diasystematik/dwds:Stilebene)='umgangssprachlich'">colloquial</xsl:when>
    <xsl:when test="normalize-space(*/dwds:Diasystematik/dwds:Stilebene)='salopp'">colloquial</xsl:when>
    <!-- <xsl:when test="normalize-space(*/dwds:Diasystematik/dwds:Gebrauchszeitraum)='veraltet'">archaic</xsl:when> -->
    <!-- TODO: more style values -->
    <xsl:otherwise>standard</xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
