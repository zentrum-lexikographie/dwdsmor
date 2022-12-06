<?xml version="1.0" encoding="utf-8"?>
<!-- dwds.xsl -->
<!-- Version 13.1 -->
<!-- Andreas Nolda 2022-12-06 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="entries.xsl"/>

<xsl:include href="files.xsl"/>

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
  <xsl:for-each select="dwds:Formangabe[dwds:Schreibung[count(tokenize(normalize-space(.)))=1]]">
    <xsl:variable name="abbreviation">
      <xsl:call-template name="get-abbreviation-value"/>
    </xsl:variable>
    <xsl:variable name="basis">
      <xsl:choose>
        <!-- adpositional basis of contracted adposition -->
        <xsl:when test="normalize-space(dwds:Grammatik/dwds:Wortklasse)='Präposition + Artikel'">
          <xsl:value-of select="normalize-space(../dwds:Verweise[@Typ='Zusammenrückung']/dwds:Verweis[@Typ='Erstglied']/dwds:Ziellemma)"/>
        </xsl:when>
        <!-- TODO: more basis values -->
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="flat-grammar-specs">
      <!-- ignore idioms and other syntactically complex units
           except for reflexive verbs and phrasal verbs -->
      <xsl:for-each-group select="dwds:Grammatik/*[self::dwds:Wortklasse or
                                                   self::dwds:Genus or
                                                   self::dwds:indeklinabel or
                                                   self::dwds:Genitiv[count(tokenize(normalize-space(.)))=1] or
                                                   self::dwds:Plural[count(tokenize(normalize-space(.)))=1] or
                                                   self::dwds:Positiv[count(tokenize(normalize-space(.)))=1] or
                                                   self::dwds:Komparativ[count(tokenize(normalize-space(.)))=1] or
                                                   self::dwds:Superlativ[tokenize(normalize-space(.))[1]='am']
                                                                        [count(tokenize(normalize-space(.)))=2] or
                                                   self::dwds:Superlativ[not(tokenize(normalize-space(.))[1]='am')]
                                                                        [count(tokenize(normalize-space(.)))=1] or
                                                   self::dwds:Praesens[tokenize(normalize-space(.))[2]='sich']
                                                                      [count(tokenize(normalize-space(.)))&lt;4] or
                                                   self::dwds:Praesens[not(tokenize(normalize-space(.))[2]='sich')]
                                                                      [count(tokenize(normalize-space(.)))&lt;3] or
                                                   self::dwds:Praeteritum[tokenize(normalize-space(.))[2]='sich']
                                                                         [count(tokenize(normalize-space(.)))&lt;4] or
                                                   self::dwds:Praeteritum[not(tokenize(normalize-space(.))[2]='sich')]
                                                                         [count(tokenize(normalize-space(.)))&lt;3] or
                                                   self::dwds:Partizip_II[count(tokenize(normalize-space(.)))=1] or
                                                   self::dwds:Auxiliar or
                                                   self::dwds:Funktionspraeferenz or
                                                   self::dwds:Kasuspraeferenz or
                                                   self::dwds:Numeruspraeferenz or
                                                   self::dwds:Einschraenkung or
                                                   self::dwds:Kommentar]"
                          group-by="name()">
        <xsl:element name="{name()}">
          <xsl:copy-of select="current-group()"/>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:variable name="flat-word-formation-specs">
      <!-- ignore idioms and other syntactically complex units
           except for reflexive verbs and phrasal verbs -->
      <xsl:for-each-group select="dwds:Grammatik/*[self::dwds:Wortklasse or
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
        <!-- remove grammar specification for a noun
             with genitive singular form ending in "-s"
             if there is another grammar specification for a noun
             with genitive singular form ending in "-es" -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[normalize-space(dwds:Genitiv)='-es'] and
                        $grouped-grammar-specs/dwds:Grammatik[normalize-space(dwds:Genitiv)='-s']">
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[not(normalize-space(dwds:Genitiv)='-s')]"/>
        </xsl:when>
        <!-- reduce grammar specification for a weak verb with strong participle to participle
             if there is another grammar specification for a weak verb with weak participle -->
        <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?n$')] and
                        $grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?t$')] and
                        $grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?n$')]/dwds:Praesens=$grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?t$')]/dwds:Praesens and
                        $grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?n$')]/dwds:Praeteritum=$grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?t$')]/dwds:Praeteritum">
          <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[not(matches(normalize-space(dwds:Partizip_II),'e?n$'))]"/>
          <xsl:for-each select="$grouped-grammar-specs/dwds:Grammatik[matches(normalize-space(dwds:Partizip_II),'e?n$')]">
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
      <xsl:if test="count(../dwds:Formangabe)>1">
        <xsl:number/>
      </xsl:if>
    </xsl:variable>
    <!-- sequence of phonetic transcriptions (if any) -->
    <xsl:variable name="pronunciations"
                  select="distinct-values(dwds:Aussprache[not(@class='invisible')]/@IPA)"/>
    <!-- ignore idioms and invalid spellings -->
    <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.)))=1]
                                         [not(@Typ='U_NR' or
                                              @Typ='U_U' or
                                              @Typ='U_Falschschreibung')]">
      <xsl:variable name="expanded-grammar-specs">
        <xsl:choose>
          <!-- expand grammar specifications for old spellings with "ß"/"ss"-alternation
               unless there are proper grammar specifications for the old spelling -->
          <xsl:when test="starts-with(@Typ,'U') and
                          ../dwds:Schreibung[ends-with(@Typ,'G')][.=n:sz-ss-alternation(current())]">
            <xsl:variable name="canonical-lemma"
                          select="../dwds:Schreibung[ends-with(@Typ,'G')][1]"/>
            <xsl:for-each select="$grammar-specs/dwds:Grammatik">
              <dwds:Grammatik>
                <xsl:for-each select="*">
                  <xsl:choose>
                    <!-- expand grammar specifications with vocalic suffixes
                         using the canonical lemma in new spelling -->
                    <xsl:when test="(self::dwds:Genitiv or
                                     self::dwds:Komparativ or
                                     self::dwds:Plural or
                                     self::dwds:Positiv or
                                     self::dwds:Superlativ) and
                                    not(starts-with(@Typ,'U')) and
                                    matches(.,'^-[aeiouäöü]')">
                      <xsl:element name="{name()}"
                                   namespace="{namespace-uri()}">
                        <xsl:value-of select="$canonical-lemma"/>
                        <xsl:value-of select="substring-after(.,'-')"/>
                      </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </dwds:Grammatik>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$grammar-specs"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="lemma"
                    select="normalize-space(.)"/>
      <!-- homograph index -->
      <xsl:variable name="lemma-index"
                    select="@hidx"/>
      <!-- spelling type -->
      <xsl:variable name="spelling-type"
                    select="@Typ"/>
      <xsl:if test="string-length($lemma)&gt;0">
        <!-- affixes and inflection stems -->
        <xsl:for-each select="$expanded-grammar-specs/dwds:Grammatik">
          <xsl:variable name="pos"
                        select="normalize-space(dwds:Wortklasse)"/>
          <xsl:choose>
            <!-- affixes -->
            <xsl:when test="$pos='Affix' and
                            ends-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='adjektivisch'">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'-$','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">prefix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">adjective</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- <xsl:when test="$pos='Affix' and
                            starts-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='adjektivisch'">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'^-','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">suffix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">adjective</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when> -->
            <xsl:when test="$pos='Affix' and
                            ends-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='adverbiell'">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'-$','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">prefix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">adverb</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- <xsl:when test="$pos='Affix' and
                            starts-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='adverbiell'">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'^-','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">suffix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">adverb</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when> -->
            <xsl:when test="$pos='Affix' and
                            ends-with($lemma,'-') and
                            (normalize-space(dwds:Funktionspraeferenz)='nominal' or
                             normalize-space(dwds:Funktionspraeferenz)='substantivisch')">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'-$','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">prefix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">noun</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- <xsl:when test="$pos='Affix' and
                            starts-with($lemma,'-') and
                            (normalize-space(dwds:Funktionspraeferenz)='nominal' or
                             normalize-space(dwds:Funktionspraeferenz)='substantivisch')">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'^-','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">suffix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">noun</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when> -->
            <xsl:when test="$pos='Affix' and
                            ends-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='verbal' and
                            contains(normalize-space(dwds:Kommentar),'untrennbar')">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'-$','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">prefix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">verb</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Affix' and
                            ends-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='verbal' and
                            contains(normalize-space(dwds:Kommentar),'trennbar')">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'-$','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">prefix</xsl:with-param>
                <xsl:with-param name="separable">yes</xsl:with-param>
                <xsl:with-param name="selection">verb</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- <xsl:when test="$pos='Affix' and
                            starts-with($lemma,'-') and
                            normalize-space(dwds:Funktionspraeferenz)='verbal'">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="replace($lemma,'^-','')"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="type">suffix</xsl:with-param>
                <xsl:with-param name="separable">no</xsl:with-param>
                <xsl:with-param name="selection">noun</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when> -->
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
                                select="normalize-space(dwds:Positiv)"/>
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
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="class">Ptkl-Adj</xsl:with-param>
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
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="class">Ptkl-Neg</xsl:with-param>
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
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="class">Konj-Vgl</xsl:with-param>
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
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="class">Ptkl-Adj</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="class">Ptkl-Zu</xsl:with-param>
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
              <xsl:call-template name="other-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="class">ProAdv</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- articles -->
            <xsl:when test="$pos='bestimmter Artikel' and
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
                             normalize-space(dwds:Numeruspraeferenz)='nur im Singular' and
                             string-length(normalize-space(dwds:Genus))&gt;0 and
                             string-length(normalize-space(dwds:Genitiv))&gt;0">
              <xsl:call-template name="noun-entry-set">
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
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="number">singular</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz)='nur im Plural'">
              <xsl:call-template name="noun-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="nominative-plural"
                                select="normalize-space(dwds:Plural)"/>
                <xsl:with-param name="number">plural</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Substantiv' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            string-length(normalize-space(dwds:Genitiv))&gt;0 and
                            string-length(normalize-space(dwds:Plural))&gt;0">
              <xsl:call-template name="noun-entry-set">
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
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="nominative-plural"
                                select="normalize-space(dwds:Plural)"/>
                <xsl:with-param name="number">any</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="number">singular</xsl:with-param>
                <xsl:with-param name="pronunciations"
                                select="$pronunciations"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$pos='Eigenname' and
                            normalize-space(dwds:Numeruspraeferenz)='nur im Plural'">
              <xsl:call-template name="name-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
                <xsl:with-param name="nominative-plural"
                                select="normalize-space(dwds:Plural)"/>
                <xsl:with-param name="number">plural</xsl:with-param>
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
            <!-- demonstrative pronouns -->
            <xsl:when test="$pos='Demonstrativpronomen' and
                            string-length(normalize-space(dwds:Genus))&gt;0">
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
                            $lemma='genug'">
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
                            $lemma='jedermann'">
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
                            $lemma='paar'">
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
                            $lemma='man'">
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
                            ($lemma='nichts' or
                             $lemma='nischt' or
                             $lemma='nix')">
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
                            (ends-with($lemma,'etwas') or
                             $lemma='ebbes')">
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
                            string-length(normalize-space(dwds:Genus))&gt;0">
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
                            ($lemma='du' or
                             $lemma='Du' or
                             $lemma='er' or
                             $lemma='es' or
                             $lemma='ich' or
                             $lemma='ihr' or
                             $lemma='Ihr' or
                             $lemma='sie' or
                             $lemma='Sie' or
                             $lemma='wir')">
              <xsl:call-template name="personal-pronoun-entry-set">
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
            <!-- possessive pronouns -->
            <xsl:when test="$pos='Possessivpronomen' and
                            $lemma='Ew.'">
              <xsl:call-template name="possessive-pronoun-entry-set">
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
            <xsl:when test="$pos='Possessivpronomen' and
                            string-length(normalize-space(dwds:Genus))&gt;0">
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
                            string-length(normalize-space(dwds:Genus))&gt;0">
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
            <!-- verbs -->
            <xsl:when test="$pos='Verb' and
                            string-length(normalize-space(dwds:Praesens))&gt;0 and
                            string-length(normalize-space(dwds:Praeteritum))&gt;0 and
                            string-length(normalize-space(dwds:Partizip_II))&gt;0 and
                            string-length(normalize-space(dwds:Auxiliar))&gt;0">
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
              <xsl:call-template name="other-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="lemma-index"
                                select="$lemma-index"/>
                <xsl:with-param name="paradigm-index"
                                select="$paradigm-index"/>
                <xsl:with-param name="abbreviation"
                                select="$abbreviation"/>
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
                <xsl:with-param name="case">
                  <xsl:call-template name="get-case-value"/>
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
                                    select="$basis"/>
                    <xsl:with-param name="pronunciations"
                                    select="$pronunciations"/>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
                    <xsl:with-param name="class">Ptkl-Adj</xsl:with-param>
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
                                    select="$basis"/>
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
                    <xsl:with-param name="type">comp</xsl:with-param>
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
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
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
                    <xsl:with-param name="type">comp</xsl:with-param>
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
                                $lemma='daß' or
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
                                $lemma='sodaß' or
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
                    <xsl:with-param name="type">inf</xsl:with-param>
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
                    <xsl:with-param name="type">comp</xsl:with-param>
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
                <xsl:when test="$lemma='gä' or
                                $lemma='ge' or
                                $lemma='gell' or
                                $lemma='gelle' or
                                $lemma='gelt' or
                                $lemma='nein'">
                  <xsl:call-template name="other-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="lemma-index"
                                    select="$lemma-index"/>
                    <xsl:with-param name="paradigm-index"
                                    select="$paradigm-index"/>
                    <xsl:with-param name="abbreviation"
                                    select="$abbreviation"/>
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
                        select="normalize-space(dwds:Wortklasse)"/>
          <xsl:choose>
            <xsl:when test="$pos='Adjektiv' and
                            string-length(normalize-space(dwds:Kompositionsstamm))&gt;0">
              <xsl:call-template name="adjective-comp-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="comp-stem"
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
                <xsl:with-param name="comp-stem"
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
                <xsl:with-param name="comp-stem"
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
                <xsl:with-param name="comp-stem"
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
                <xsl:with-param name="comp-stem"
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
                <xsl:with-param name="comp-stem"
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
            <xsl:when test="string-length(normalize-space(dwds:Wortklasse))&gt;0">
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
                                                 [dwds:Verweis[@Typ='Erstglied']]
                                                 [not(dwds:Verweis[@Typ='Binnenglied'])]
                                                 [dwds:Verweis[@Typ='Letztglied']]">
          <xsl:variable name="basis1"
                        select="normalize-space(dwds:Verweis[@Typ='Erstglied']/dwds:Ziellemma)"/>
          <xsl:variable name="basis2"
                        select="normalize-space(dwds:Verweis[@Typ='Letztglied']/dwds:Ziellemma)"/>
          <!-- ignore affixes -->
          <xsl:if test="not(ends-with($basis1,'-')) and
                        not(starts-with($basis2,'-'))">
            <xsl:variable name="index1"
                          select="string(dwds:Verweis[@Typ='Erstglied']/dwds:Ziellemma/@hidx)"/>
            <xsl:variable name="index2"
                          select="string(dwds:Verweis[@Typ='Letztglied']/dwds:Ziellemma/@hidx)"/>
            <xsl:variable name="file1">
              <xsl:choose>
                <xsl:when test="string-length($index1)&gt;0">
                  <xsl:value-of select="$manifest/source[@lemma=$basis1]
                                                        [@index=$index1][1]/@href"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$manifest/source[@lemma=$basis1][1]/@href"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="file2">
              <xsl:choose>
                <xsl:when test="string-length($index2)&gt;0">
                  <xsl:value-of select="$manifest/source[@lemma=$basis2]
                                                        [@index=$index2][1]/@href"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$manifest/source[@lemma=$basis2][1]/@href"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="article1">
              <xsl:if test="doc-available(n:absolute-path($file1))">
                <xsl:copy-of select="doc(n:absolute-path($file1))/dwds:DWDS/dwds:Artikel/*"/>
              </xsl:if>
            </xsl:variable>
            <xsl:variable name="article2">
              <xsl:if test="doc-available(n:absolute-path($file2))">
                <xsl:copy-of select="doc(n:absolute-path($file2))/dwds:DWDS/dwds:Artikel/*"/>
              </xsl:if>
            </xsl:variable>
            <xsl:for-each select="$article1">
              <xsl:variable name="etymology1">
                <xsl:call-template name="get-etymology-value"/>
              </xsl:variable>
              <!-- ignore abbreviations -->
              <xsl:for-each select="dwds:Formangabe[not(@Typ='Abkürzung')]">
                <xsl:variable name="pos1"
                              select="normalize-space(dwds:Grammatik/dwds:Wortklasse)"/>
                <xsl:if test="string-length($pos1)&gt;0">
                  <xsl:variable name="abbreviation1">
                    <xsl:call-template name="get-abbreviation-value"/>
                  </xsl:variable>
                  <!-- ignore idioms and invalid spellings -->
                  <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.)))=1]
                                                       [not(@Typ='U_NR' or
                                                            @Typ='U_U' or
                                                            @Typ='U_Falschschreibung')]">
                    <xsl:variable name="lemma1"
                                  select="normalize-space(.)"/>
                    <xsl:if test="string-length($lemma1)&gt;0">
                      <xsl:for-each select="$article2">
                        <!-- ignore abbreviations -->
                        <xsl:for-each select="dwds:Formangabe[not(@Typ='Abkürzung')]">
                          <xsl:for-each select="dwds:Schreibung[count(tokenize(normalize-space(.)))=1]
                                                               [not(@Typ='U_NR' or
                                                                    @Typ='U_U' or
                                                                    @Typ='U_Falschschreibung')]">
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
                                  <xsl:with-param name="spelling-type"
                                                  select="$spelling-type"/>
                                </xsl:call-template>
                              </xsl:variable>
                              <xsl:if test="string-length($comp-stem)&gt;0">
                                <xsl:choose>
                                  <xsl:when test="$pos1='Adjektiv'">
                                    <xsl:call-template name="adjective-comp-entry-set">
                                      <xsl:with-param name="lemma"
                                                      select="$lemma1"/>
                                      <xsl:with-param name="comp-stem"
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
                                      <xsl:with-param name="comp-stem"
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
                                      <xsl:with-param name="comp-stem"
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
                                      <xsl:with-param name="comp-stem"
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
                                      <xsl:with-param name="comp-stem"
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
                                      <xsl:with-param name="comp-stem"
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
      </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

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
    <xsl:when test="dwds:Diachronie/dwds:Etymologie[string-length(normalize-space(.))&gt;0]">fremd</xsl:when>
    <xsl:otherwise>nativ</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="get-abbreviation-value">
  <xsl:choose>
    <xsl:when test="@Typ='Abkürzung'">yes</xsl:when>
    <xsl:when test="../dwds:Lesart/dwds:Definition[@Typ='Generalisierung']
                                                  [normalize-space(.)='Buchstabe']">yes</xsl:when>
    <xsl:when test="../dwds:Lesart/dwds:Definition[@Typ='Generalisierung']
                                                  [normalize-space(.)='Tonbezeichnung']">yes</xsl:when>
    <xsl:when test="../dwds:Lesart/dwds:Definition[@Typ='Basis']
                                                  [matches(normalize-space(.),'^der Laut \p{L}$')]">yes</xsl:when>
    <xsl:when test="../dwds:Lesart/dwds:Definition[@Typ='Basis']
                                                  [matches(normalize-space(.),'^der .+ Buchstabe des Alphabets$')]">yes</xsl:when>
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

<xsl:template name="get-case-value">
  <xsl:choose>
    <xsl:when test="normalize-space(dwds:Kasuspraeferenz)='mit Akkusativ'">accusative</xsl:when>
    <xsl:when test="normalize-space(dwds:Kasuspraeferenz)='mit Dativ'">dative</xsl:when>
    <xsl:when test="normalize-space(dwds:Kasuspraeferenz)='mit Genitiv'">genitive</xsl:when>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
