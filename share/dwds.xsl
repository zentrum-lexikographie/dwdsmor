<?xml version="1.0" encoding="utf-8"?>
<!-- dwds.xsl -->
<!-- Version 8.1 -->
<!-- Andreas Nolda 2022-05-12 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="entries.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <!-- do not consider articles which are not (near-)final -->
  <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel[not(@Status!='Red-2' and
                                                           @Status!='Red-f')]"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <xsl:variable name="etymology">
    <xsl:choose>
      <xsl:when test="dwds:Diachronie[dwds:Etymologie[string-length(normalize-space(.))&gt;0]]">fremd</xsl:when>
      <xsl:when test="dwds:Diachronie[not(dwds:Etymologie[string-length(normalize-space(.))&gt;0])]">nativ</xsl:when>
      <!-- TODO: more etymology values -->
      <!-- ... -->
    </xsl:choose>
  </xsl:variable>
  <!-- ignore idioms and other syntactically complex units
       except for reflexive verbs and phrasal verbs -->
  <xsl:for-each select="dwds:Formangabe[not(dwds:Schreibung[count(tokenize(normalize-space(.)))&gt;1])]
                                       [not(dwds:Grammatik/dwds:Praesens[tokenize(normalize-space(.))[2]='sich']
                                                                        [count(tokenize(normalize-space(.)))&gt;3])]
                                       [not(dwds:Grammatik/dwds:Praesens[not(tokenize(normalize-space(.))[2]='sich')]
                                                                        [count(tokenize(normalize-space(.)))&gt;2])]">
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
    <xsl:for-each select="dwds:Schreibung[not(@Typ='U_NR' or
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
      <xsl:if test="string-length($lemma)&gt;0">
        <xsl:for-each select="$expanded-grammar-specs/dwds:Grammatik">
          <xsl:variable name="pos"
                        select="normalize-space(dwds:Wortklasse)"/>
          <xsl:choose>
            <!-- affixes -->
            <xsl:when test="$pos='Affix'">
              <xsl:call-template name="affix-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
              <xsl:with-param name="etymology"
                              select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- adjectives and adjectival participles -->
            <xsl:when test="$pos='Adjektiv' or
                            $pos='partizipiales Adjektiv'">
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- adverbs and adverbial participles -->
            <xsl:when test="$pos='Adverb' or
                            $pos='partizipiales Adverb'">
              <xsl:call-template name="adverb-entry-set">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="comparative"
                                select="normalize-space(dwds:Komparativ)"/>
                <xsl:with-param name="superlative"
                                select="normalize-space(dwds:Superlativ)"/>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- pronominal adverbs -->
            <xsl:when test="$pos='Pronominaladverb'">
              <xsl:call-template name="default-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="pos">OTHER</xsl:with-param>
                <xsl:with-param name="class">ProAdv</xsl:with-param>
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
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="number">singular</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="nominative-plural"
                                select="normalize-space(dwds:Plural)"/>
                <xsl:with-param name="number">singular+plural</xsl:with-param>
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
                <xsl:with-param name="gender"
                                select="normalize-space(dwds:Genus)"/>
                <xsl:with-param name="genitive-singular"
                                select="normalize-space(dwds:Genitiv)"/>
                <xsl:with-param name="number">singular</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:when>
            <!-- interjections -->
            <xsl:when test="$pos='Interjektion'">
              <xsl:call-template name="default-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="pos">OTHER</xsl:with-param>
                <xsl:with-param name="class">Intj</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
  </xsl:for-each>
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
</xsl:stylesheet>
