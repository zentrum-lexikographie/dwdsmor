<?xml version="1.0" encoding="utf-8"?>
<!-- dwds.xsl -->
<!-- Version 5.3 -->
<!-- Andreas Nolda 2022-04-01 -->

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
          <!-- only consider articles with appropriate grammar specifications -->
          <xsl:when test="normalize-space(dwds:Wortklasse)='Adjektiv' or
                          normalize-space(dwds:Wortklasse)='Substantiv' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            string-length(normalize-space(dwds:Genitiv))&gt;0 and
                            string-length(normalize-space(dwds:Plural))&gt;0 or
                          normalize-space(dwds:Wortklasse)='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz)='nur im Singular' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            string-length(normalize-space(dwds:Genitiv))&gt;0 or
                          normalize-space(dwds:Wortklasse)='Substantiv' and
                            normalize-space(dwds:Numeruspraeferenz)='nur im Plural' or
                          normalize-space(dwds:Wortklasse)='Eigenname' and
                            normalize-space(dwds:Numeruspraeferenz)='nur im Singular' and
                            string-length(normalize-space(dwds:Genus))&gt;0 and
                            string-length(normalize-space(dwds:Genitiv))&gt;0 or
                          normalize-space(dwds:Wortklasse)='Eigenname' and
                            normalize-space(dwds:Numeruspraeferenz)='nur im Plural' or
                          normalize-space(dwds:Wortklasse)='Verb' and
                            string-length(normalize-space(dwds:Praesens))&gt;0 and
                            string-length(normalize-space(dwds:Praeteritum))&gt;0 and
                            string-length(normalize-space(dwds:Partizip_II))&gt;0 or
                          normalize-space(dwds:Wortklasse)='Partizip' and
                            string-length(normalize-space(dwds:Praesens))&gt;0 and
                            string-length(normalize-space(dwds:Partizip_II))&gt;0 or
                          normalize-space(dwds:Wortklasse)='Affix'">
            <!-- TODO: more POS -->
            <!-- ... -->
            <xsl:choose>
              <!-- affixes -->
              <xsl:when test="$pos='Affix'">
                <xsl:call-template name="affix-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="pos">
                    <xsl:call-template name="pos">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos"
                                      select="$pos"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <!-- adjectives -->
              <xsl:when test="$pos='Adjektiv'">
                <xsl:choose>
                  <!-- uninflected adjectives -->
                  <xsl:when test="dwds:indeklinabel">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Adj0</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- inflected adjectives -->
                  <xsl:otherwise>
                    <xsl:variable name="positive"
                                  select="normalize-space(dwds:Positiv)"/>
                    <xsl:variable name="comparative"
                                  select="normalize-space(dwds:Komparativ)"/>
                    <xsl:variable name="superlative"
                                  select="normalize-space(dwds:Superlativ)"/>
                    <xsl:variable name="positive-marker">
                      <xsl:call-template name="get-nominal-marker">
                        <xsl:with-param name="form"
                                        select="$positive"/>
                        <xsl:with-param name="lemma"
                                        select="$lemma"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="comparative-marker">
                      <xsl:call-template name="get-nominal-marker">
                        <xsl:with-param name="form"
                                        select="$comparative"/>
                        <xsl:with-param name="lemma"
                                        select="$lemma"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="superlative-marker">
                      <xsl:call-template name="get-nominal-marker">
                        <xsl:with-param name="form"
                                        select="substring-after($superlative,'am ')"/>
                        <xsl:with-param name="lemma"
                                        select="$lemma"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                      <!-- adjectives with irregular positive forms -->
                      <xsl:when test="string-length($positive)&gt;0 and
                                      not(matches($positive-marker,'^&#x308;?-'))">
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">AdjPosPred</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="adjective-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="form"
                                          select="replace($positive,'e$','')"/>
                          <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="string-length($comparative)&gt;0">
                          <xsl:call-template name="adjective-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma"/>
                            <xsl:with-param name="form"
                                            select="replace($comparative,'er$','')"/>
                            <xsl:with-param name="class">AdjComp</xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="string-length($superlative)&gt;0">
                          <xsl:call-template name="adjective-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma"/>
                            <xsl:with-param name="form"
                                            select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                            <xsl:with-param name="class">AdjSup</xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                      </xsl:when>
                      <!-- adjectives with the uninflected comparative form "mehr" -->
                      <xsl:when test="$comparative='mehr'">
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">AdjPos</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="adjective-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="form"
                                          select="$comparative"/>
                          <xsl:with-param name="class">AdjComp0</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="adjective-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="form"
                                          select="replace($superlative,'^am (.+)sten$','$1')"/>
                          <xsl:with-param name="class">AdjSup</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- adjectives with irregular comparative forms -->
                      <xsl:when test="ends-with($comparative,'er') and
                                      not(matches($comparative-marker,'^&#x308;?-'))">
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">AdjPos</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="adjective-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="form"
                                          select="replace($comparative,'er$','')"/>
                          <xsl:with-param name="class">AdjComp</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="ends-with($superlative,'sten')">
                          <xsl:call-template name="adjective-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma"/>
                            <xsl:with-param name="form"
                                            select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                            <xsl:with-param name="class">AdjSup</xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                      </xsl:when>
                      <!-- adjectives with irregular superlative forms -->
                      <xsl:when test="ends-with($superlative,'sten') and
                                      not(matches($superlative-marker,'^&#x308;?-'))">
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">AdjPos</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="ends-with($comparative,'er')">
                          <xsl:call-template name="adjective-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma"/>
                            <xsl:with-param name="form"
                                            select="replace($comparative,'er$','')"/>
                            <xsl:with-param name="class">AdjComp</xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="adjective-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="form"
                                          select="replace($superlative,'^am (.*[aeiouäöü].*)e?sten$','$1')"/>
                          <xsl:with-param name="class">AdjSup</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- adjectives with word-internal comparative markers -->
                      <xsl:when test="string-length($comparative)&gt;0 and
                                      not(matches($comparative-marker,'^&#x308;?-'))">
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="$comparative"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">AdjPos</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="string-length($superlative)&gt;0 and
                                      not(matches($superlative-marker,'^&#x308;?-'))">
                          <xsl:call-template name="default-entry">
                            <xsl:with-param name="lemma"
                                            select="replace($superlative,'^am (.+)en$','$1')"/>
                            <xsl:with-param name="pos">
                              <xsl:call-template name="pos">
                                <xsl:with-param name="lemma"
                                                select="$lemma"/>
                                <xsl:with-param name="pos"
                                                select="$pos"/>
                              </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="class">AdjPos</xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                      </xsl:when>
                      <!-- adjectives with word-internal superlative markers -->
                      <xsl:when test="string-length($superlative)&gt;0 and
                                      not(matches($superlative-marker,'^&#x308;?-'))">
                        <xsl:if test="string-length($comparative)&gt;0 and
                                      not(matches($comparative-marker,'^&#x308;?-'))">
                          <xsl:call-template name="default-entry">
                            <xsl:with-param name="lemma"
                                            select="$comparative"/>
                            <xsl:with-param name="pos">
                              <xsl:call-template name="pos">
                                <xsl:with-param name="lemma"
                                                select="$lemma"/>
                                <xsl:with-param name="pos"
                                                select="$pos"/>
                              </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="class">AdjPos</xsl:with-param>
                          </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="replace($superlative,'^am (.+)en$','$1')"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">AdjPos</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- other adjectives -->
                      <xsl:otherwise>
                        <xsl:call-template name="default-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos">
                            <xsl:call-template name="pos">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                          <xsl:with-param name="class">
                            <xsl:call-template name="adjective-class">
                              <xsl:with-param name="lemma"
                                              select="$lemma"/>
                              <xsl:with-param name="pos"
                                              select="$pos"/>
                            </xsl:call-template>
                          </xsl:with-param>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- nouns -->
              <xsl:when test="$pos='Substantiv'">
                <xsl:variable name="gender"
                              select="normalize-space(dwds:Genus)"/>
                <xsl:variable name="genitive-singular"
                              select="normalize-space(dwds:Genitiv)"/>
                <xsl:variable name="nominative-plural"
                              select="normalize-space(dwds:Plural)"/>
                <xsl:variable name="genitive-singular-marker">
                  <xsl:call-template name="get-nominal-marker">
                    <xsl:with-param name="form"
                                    select="$genitive-singular"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="nominative-plural-marker">
                  <xsl:call-template name="get-nominal-marker">
                    <xsl:with-param name="form"
                                    select="$nominative-plural"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- masculine nouns -->
                  <!-- genitive singular: "-(e)s"
                       nominative plural: "-ten" -->
                  <xsl:when test="$gender='mask.' and
                                  ($genitive-singular-marker='-(e)s' or
                                   $genitive-singular-marker='-es') and
                                  $nominative-plural-marker='-ten'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc/Sg_es</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="noun-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="form">
                        <xsl:choose>
                          <xsl:when test="starts-with($nominative-plural,'-')">
                            <xsl:value-of select="concat($lemma,substring-after($nominative-plural,'-'))"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$nominative-plural"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc/Pl_x</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- genitive singular: "-(s)"
                       nominative plural: "-(s)" -->
                  <xsl:when test="$gender='mask.' and
                                  $genitive-singular-marker='-(s)' and
                                  $nominative-plural-marker='-(s)'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc/Sg_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc_s_x</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc_s_s</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- genitive singular: "-(s)" -->
                  <xsl:when test="$gender='mask.' and
                                  $genitive-singular-marker='-(s)'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc/Sg_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">
                        <xsl:call-template name="noun-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                          <xsl:with-param name="genitive-singular">-s</xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- nominative plural: "-(s)" -->
                  <xsl:when test="$gender='mask.' and
                                  $nominative-plural-marker='-(s)'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NMasc_s_x</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">
                        <xsl:call-template name="noun-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                          <xsl:with-param name="nominative-plural">-s</xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- lemma: compound with "Mann"
                       nominative plural: compound with "Leute" -->
                  <xsl:when test="$gender='mask.' and
                                  ends-with($lemma,'mann') and
                                  ends-with($nominative-plural,'leute')">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$nominative-plural"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">N?/Pl_0</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- neuter nouns -->
                  <!-- genitive singular: "-(s)"
                       nominative plural: "-(s)" -->
                  <xsl:when test="$gender='neutr.' and
                                  $genitive-singular-marker='-(s)' and
                                  $nominative-plural-marker='-(s)'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NNeut/Sg_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NNeut_s_x</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NNeut_s_s</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- genitive singular: "-(s)" -->
                  <xsl:when test="$gender='neutr.' and
                                  $genitive-singular-marker='-(s)'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NNeut/Sg_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">
                        <xsl:call-template name="noun-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                          <xsl:with-param name="genitive-singular">-s</xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- nominative plural: "-(s)" -->
                  <xsl:when test="$gender='neutr.' and
                                  $nominative-plural-marker='-(s)'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">NNeut_s_x</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">
                        <xsl:call-template name="noun-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                          <xsl:with-param name="nominative-plural">-s</xsl:with-param>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- feminine nouns -->
                  <!-- lemma: compound with "Frau"
                       nominative plural: compound with "Leute" -->
                  <xsl:when test="$gender='fem.' and
                                  ends-with($lemma,'frau') and
                                  ends-with($nominative-plural,'leute')">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$nominative-plural"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">N?/Pl_0</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- other nouns -->
                  <xsl:otherwise>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">
                        <xsl:call-template name="noun-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- proper names -->
              <xsl:when test="$pos='Eigenname'">
                <xsl:variable name="gender"
                              select="normalize-space(dwds:Genus)"/>
                <xsl:variable name="genitive-singular"
                              select="normalize-space(dwds:Genitiv)"/>
                <xsl:variable name="number-preference"
                              select="normalize-space(dwds:Numeruspraeferenz)"/>
                <xsl:variable name="genitive-singular-marker">
                  <xsl:call-template name="get-nominal-marker">
                    <xsl:with-param name="form"
                                    select="$genitive-singular"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- masculine proper names -->
                  <!-- genitive singular: "-(s)"
                       no plural -->
                  <xsl:when test="$gender='mask.' and
                                  $genitive-singular-marker='-(s)' and
                                  $number-preference='nur im Singular'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Name-Masc_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Name-Masc_s</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- neuter proper names -->
                  <!-- genitive singular: "-(s)"
                       no plural -->
                  <xsl:when test="$gender='neutr.' and
                                  $genitive-singular-marker='-(s)' and
                                  $number-preference='nur im Singular'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Name-Neut_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Name-Neut_s</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- feminine proper names -->
                  <!-- genitive singular: "-(s)"
                       no plural -->
                  <xsl:when test="$gender='fem.' and
                                  $genitive-singular-marker='-(s)' and
                                  $number-preference='nur im Singular'">
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Name-Fem_0</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">Name-Fem_s</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- other proper names -->
                  <xsl:otherwise>
                    <xsl:call-template name="default-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos">
                        <xsl:call-template name="pos">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                      <xsl:with-param name="class">
                        <xsl:call-template name="name-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- verbs -->
              <xsl:when test="$pos='Verb'">
                <xsl:variable name="present">
                  <!-- remove "sich", if any -->
                  <xsl:choose>
                    <xsl:when test="tokenize(normalize-space(dwds:Praesens))[2]='sich'">
                      <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens)),2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(dwds:Praesens)"/>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="past">
                  <!-- remove "sich", if any -->
                  <xsl:choose>
                    <xsl:when test="tokenize(normalize-space(dwds:Praeteritum))[2]='sich'">
                      <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praeteritum)),2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(dwds:Praeteritum)"/>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="participle"
                              select="normalize-space(dwds:Partizip_II)"/>
                <xsl:variable name="particle"
                              select="substring-after($present,' ')"/>
                <xsl:variable name="lemma-without-particle"
                              select="replace($lemma,concat('^',$particle,'(.+)$'),'$1')"/>
                <xsl:variable name="present-without-particle"
                              select="replace($present,concat('^(.+?)( ',$particle,')?$'),'$1')"/>
                <xsl:variable name="past-without-particle"
                              select="replace($past,concat('^(.+?)( ',$particle,')?$'),'$1')"/>
                <xsl:variable name="participle-without-particle"
                              select="replace($participle,concat('^',$particle,'(.+)$'),'$1')"/>
                <xsl:variable name="stem">
                  <xsl:call-template name="verb-stem">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="present-stem">
                  <xsl:call-template name="present-stem">
                    <xsl:with-param name="form"
                                    select="$present-without-particle"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="past-stem">
                  <xsl:call-template name="past-stem">
                    <xsl:with-param name="form"
                                    select="$past-without-particle"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-stem">
                  <xsl:call-template name="participle-stem">
                    <xsl:with-param name="form"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="present-marker"><!-- of regular verbs -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$present-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="past-marker"><!-- of regular verbs -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$past-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-marker"><!-- of regular verbs -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- regular verbs -->
                  <xsl:when test="$present-marker='-t' and
                                  $past-marker='-te' and
                                  ($participle-marker='-t' or
                                   $participle-marker='ge-t') or
                                  $present-marker='-et' and
                                  $past-marker='-ete' and
                                  ($participle-marker='-et' or
                                   $participle-marker='ge-et')">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="class">
                        <xsl:call-template name="verb-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                          <xsl:with-param name="past"
                                          select="$past-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- irregular verbs -->
                  <xsl:otherwise>
                    <!-- present -->
                    <xsl:choose>
                      <!-- "haben" -->
                      <xsl:when test="$lemma-without-particle='haben'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="replace($present-stem,'t$','')"/>
                          <xsl:with-param name="class">VVPres2</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- "sein" -->
                      <xsl:when test="$lemma-without-particle='sein'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VInf-n</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem">bin</xsl:with-param>
                          <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat('b',$present-stem)"/>
                          <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem">sind</xsl:with-param>
                          <xsl:with-param name="class">VAPres1/3PlInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'d')"/>
                          <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VAPresKonjSg</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'e')"/>
                          <xsl:with-param name="class">VAPres2SgKonj</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'e')"/>
                          <xsl:with-param name="class">VAPresKonjPl</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VAImpSg</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'d')"/>
                          <xsl:with-param name="class">VAImpPl</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- "tun" -->
                      <xsl:when test="$lemma-without-particle='tun'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="replace($stem,'n$','')"/>
                          <xsl:with-param name="class">VInf-n</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'e')"/>
                          <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($present-stem,'st')"/>
                          <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($present-stem,'t')"/>
                          <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'n')"/>
                          <xsl:with-param name="class">VAPres1/3PlInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'t')"/>
                          <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VPresKonj</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VAImpSg</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'t')"/>
                          <xsl:with-param name="class">VAImpPl</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- "werden" -->
                      <xsl:when test="$lemma-without-particle='werden'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="replace($stem,'en$','')"/>
                          <xsl:with-param name="class">VInf-en</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'e')"/>
                          <xsl:with-param name="class">VAPres1SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="replace($present-stem,'d$','st')"/>
                          <xsl:with-param name="class">VAPres2SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VAPres3SgInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'en')"/>
                          <xsl:with-param name="class">VAPres1/3PlInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'et')"/>
                          <xsl:with-param name="class">VAPres2PlInd</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VPresKonj</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'e')"/>
                          <xsl:with-param name="class">VAImpSg</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($stem,'et')"/>
                          <xsl:with-param name="class">VAImpPl</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- preterite-present verbs -->
                      <xsl:when test="$lemma-without-particle='bedürfen' or
                                      $lemma-without-particle='dürfen' or
                                      $lemma-without-particle='können' or
                                      $lemma-without-particle='mögen' or
                                      $lemma-without-particle='müssen' or
                                      $lemma-without-particle='sollen' or
                                      $lemma-without-particle='wissen' or
                                      $lemma-without-particle='wollen'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VMPresSg</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VMPresPl</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- uniform present stem -->
                      <xsl:when test="$stem=$present-stem">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation with stem-final "t" -->
                      <xsl:when test="matches($present-stem,'t$') and
                                      matches($present-stem,n:e-i-alternation-re($stem))">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VVPres2+Imp0</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- present stem for 2nd/3rd person singular with "e"/"i"-alternation -->
                      <xsl:when test="matches($present-stem,n:e-i-alternation-re($stem))">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VVPres2+Imp</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- present stem for 2nd/3rd person singular with stem-final "d" without "e" epenthesis before "-t" -->
                      <xsl:when test="matches($present-stem,'d$') and
                                      $present-without-particle=concat($present-stem,'t')">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="concat($present-stem,'&lt;FB&gt;')"/>
                          <xsl:with-param name="class">VVPres2</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- present stem for 2nd/3rd person singular with stem-final "t" -->
                      <xsl:when test="matches($present-stem,'t$') and
                                      $present-without-particle=$present-stem">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VVPres2t</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- other present stem for 2nd/3rd person singular -->
                      <xsl:otherwise>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$stem"/>
                          <xsl:with-param name="class">VVPres1+Imp</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma-without-particle"/>
                          <xsl:with-param name="participle"
                                          select="$participle-without-particle"/>
                          <xsl:with-param name="particle"
                                          select="$particle"/>
                          <xsl:with-param name="stem"
                                          select="$present-stem"/>
                          <xsl:with-param name="class">VVPres2</xsl:with-param>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-- past -->
                    <xsl:choose>
                      <!-- weak past stem -->
                      <xsl:when test="matches($past-without-particle,concat('^',$past-stem,'e?te$'))">
                        <!-- past indicative -->
                        <xsl:choose>
                          <!-- past indicative with stem-final "d" or "t" without "e" epenthesis before "-t" -->
                          <xsl:when test="matches($past-stem,'[dt]$') and
                                          $past-without-particle=concat($past-stem,'te')">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="concat($past-stem,'&lt;FB&gt;')"/>
                              <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- other weak past stem -->
                          <xsl:otherwise>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                        <!-- past subjunctive -->
                        <xsl:choose>
                          <!-- "haben" -->
                          <xsl:when test="$lemma-without-particle='haben'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="concat(n:umlaut($past-stem),'&lt;FB&gt;')"/>
                              <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- preterite-present verbs with umlautable past stem -->
                          <xsl:when test="$lemma-without-particle='bedürfen' or
                                          $lemma-without-particle='dürfen' or
                                          $lemma-without-particle='können' or
                                          $lemma-without-particle='mögen' or
                                          $lemma-without-particle='müssen' or
                                          $lemma-without-particle='wissen'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut($past-stem)"/>
                              <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- past stem ending in "ach" -->
                          <xsl:when test="matches($past-stem,'ach$')">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut($past-stem)"/>
                              <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- Rückumlaut -->
                          <xsl:when test="matches($present-stem,'en[dn]$') and
                                          matches($past-stem,'an[dn]$')">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$stem"/><!-- sic! -->
                              <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- other weak past stem -->
                          <xsl:otherwise>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <!-- strong past stem -->
                      <xsl:otherwise>
                        <xsl:choose>
                          <!-- "sein" -->
                          <xsl:when test="$lemma-without-particle='sein'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut($past-stem)"/>
                              <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut($past-stem)"/>
                              <xsl:with-param name="class">VAPastKonj2</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- "tun" -->
                          <xsl:when test="$lemma-without-particle='tun'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VPastIndStr</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut($past-stem)"/>
                              <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- "werden" -->
                          <xsl:when test="$lemma-without-particle='werden' and
                                          $past-stem='wurde'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="replace($past-stem,'e$','')"/>
                              <xsl:with-param name="class">VPastIndIrreg</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut(replace($past-stem,'e$',''))"/>
                              <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <xsl:when test="$lemma-without-particle='werden' and
                                          $past-stem='ward'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VAPastIndSg</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="replace($past-stem,'a','u')"/>
                              <xsl:with-param name="class">VAPastIndPl</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut(replace($past-stem,'a','u'))"/>
                              <xsl:with-param name="class">VPastKonjStr</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- umlautable strong past stem -->
                          <!-- Caveat: "e" is considered as a full vowel. -->
                          <xsl:when test="matches($past-stem,'([aou]|aa|oo|au)[^aeiouäöü]*$')">
                            <!-- past indicative -->
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VVPastIndStr</xsl:with-param>
                            </xsl:call-template>
                            <!-- past subjunctive -->
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="n:umlaut($past-stem)"/>
                              <xsl:with-param name="class">VVPastKonjStr</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- non-umlautable strong past stem -->
                          <xsl:otherwise>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$past-stem"/>
                              <xsl:with-param name="class">VVPastStr</xsl:with-param>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-- past participle -->
                    <xsl:choose>
                      <!-- weak past participle -->
                      <xsl:when test="matches($participle-without-particle,'e?t$')">
                        <xsl:choose>
                          <!-- past participle with stem-final "d" or "t" without "e" epenthesis before "-t" -->
                          <xsl:when test="matches($participle-stem,'[dt]$') and
                                          matches($participle-without-particle,concat('^(ge)?',$participle-stem,'t$'))">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="concat($participle-stem,'&lt;FB&gt;')"/>
                              <xsl:with-param name="class">VVPP-t</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- other weak past participle -->
                          <xsl:otherwise>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$participle-stem"/>
                              <xsl:with-param name="class">VVPP-t</xsl:with-param>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <!-- strong past participle -->
                      <xsl:otherwise>
                        <xsl:choose>
                          <!-- "tun" -->
                          <xsl:when test="$lemma-without-particle='tun'">
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="concat($participle-stem,'n')"/>
                              <xsl:with-param name="class">VPPast</xsl:with-param>
                            </xsl:call-template>
                          </xsl:when>
                          <!-- other strong past participle -->
                          <xsl:otherwise>
                            <xsl:call-template name="verb-entry">
                              <xsl:with-param name="lemma"
                                              select="$lemma-without-particle"/>
                              <xsl:with-param name="participle"
                                              select="$participle-without-particle"/>
                              <xsl:with-param name="particle"
                                              select="$particle"/>
                              <xsl:with-param name="stem"
                                              select="$participle-stem"/>
                              <xsl:with-param name="class">VVPP-en</xsl:with-param>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                  <!-- TODO: support for modal verbs -->
                </xsl:choose>
              </xsl:when>
              <!-- verbal participles -->
              <xsl:when test="$pos='Partizip'"><!-- ad-hoc POS -->
                <xsl:variable name="present">
                  <!-- remove "sich", if any -->
                  <xsl:choose>
                    <xsl:when test="tokenize(normalize-space(dwds:Praesens))[2]='sich'">
                      <xsl:value-of select="remove(tokenize(normalize-space(dwds:Praesens)),2)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(dwds:Praesens)"/>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="participle"
                              select="normalize-space(dwds:Partizip_II)"/>
                <xsl:variable name="particle"
                              select="substring-after($present,' ')"/>
                <xsl:variable name="lemma-without-particle"
                              select="replace($lemma,concat('^',$particle,'(.+)$'),'$1')"/>
                <xsl:variable name="participle-without-particle"
                              select="replace($participle,concat('^',$particle,'(.+)$'),'$1')"/>
                <xsl:variable name="stem">
                  <xsl:call-template name="verb-stem">
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-stem">
                  <xsl:call-template name="participle-stem">
                    <xsl:with-param name="form"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma-without-particle"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-marker"><!-- of regular verbs -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$participle-without-particle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- weak participles -->
                  <xsl:when test="$participle-marker='-t' or
                                  $participle-marker='ge-t' or
                                  $participle-marker='-et' or
                                  $participle-marker='ge-et'">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-t</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- strong participles -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma-without-particle"/>
                      <xsl:with-param name="participle"
                                      select="$participle-without-particle"/>
                      <xsl:with-param name="particle"
                                      select="$particle"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-en</xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- other parts of speech -->
              <xsl:otherwise>
                <xsl:call-template name="default-entry">
                  <xsl:with-param name="lemma"
                                  select="$lemma"/>
                  <xsl:with-param name="pos">
                    <xsl:call-template name="pos">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="pos"
                                      select="$pos"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="class">
                    <!-- unknown class -->
                    <xsl:call-template name="insert-value">
                      <xsl:with-param name="value"/>
                      <xsl:with-param name="type">class</xsl:with-param>
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="normalize-space(dwds:Wortklasse)='Adjektiv' or
                          normalize-space(dwds:Wortklasse)='Substantiv' or
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
