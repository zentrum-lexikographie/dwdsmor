<?xml version="1.0" encoding="utf-8"?>
<!-- dwds.xsl -->
<!-- Version 2.4 -->
<!-- Andreas Nolda 2022-03-02 -->

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
      <xsl:when test="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'en$')]] and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]] and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'en$')]]/dwds:Praesens=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]]/dwds:Praesens and
                      $grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'en$')]]/dwds:Praeteritum=$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'e?t$')]]/dwds:Praeteritum">
        <xsl:copy-of select="$grouped-grammar-specs/dwds:Grammatik[not(dwds:Partizip_II[matches(normalize-space(.),'en$')])]"/>
        <xsl:for-each select="$grouped-grammar-specs/dwds:Grammatik[dwds:Partizip_II[matches(normalize-space(.),'en$')]]">
          <dwds:Grammatik>
            <dwds:Wortklasse>Partizip</dwds:Wortklasse><!-- ad-hoc POS -->
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
                          normalize-space(dwds:Wortklasse)='Verb' and
                            string-length(normalize-space(dwds:Praesens))&gt;0 and
                            string-length(normalize-space(dwds:Praeteritum))&gt;0 and
                            string-length(normalize-space(dwds:Partizip_II))&gt;0 or
                          normalize-space(dwds:Wortklasse)='Partizip' and
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
                                          select="replace($positive,'^(.+)e$','$1')"/>
                          <xsl:with-param name="class">AdjPosAttr</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="string-length($comparative)&gt;0">
                          <xsl:call-template name="adjective-entry">
                            <xsl:with-param name="lemma"
                                            select="$lemma"/>
                            <xsl:with-param name="form"
                                            select="replace($comparative,'^(.+)er$','$1')"/>
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
                                          select="replace($comparative,'^(.+)er$','$1')"/>
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
                                            select="replace($comparative,'^(.+)er$','$1')"/>
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
                <xsl:variable name="genitive-singular-marker">
                  <xsl:call-template name="get-nominal-marker">
                    <xsl:with-param name="form"
                                    select="$genitive-singular"/>
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="nominative-plural"
                              select="normalize-space(dwds:Plural)"/>
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
              <!-- verbs -->
              <xsl:when test="$pos='Verb'">
                <xsl:variable name="past"
                              select="normalize-space(dwds:Praeteritum)"/>
                <xsl:variable name="participle"
                              select="normalize-space(dwds:Partizip_II)"/>
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
                <xsl:variable name="past-marker"><!-- of weak verbs -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$past"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-marker"><!-- of weak verbs -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$participle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- weak verbs -->
                  <xsl:when test="$past-marker='-te' and
                                  ($participle-marker='-t' or
                                   $participle-marker='ge-t')">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="class">
                        <xsl:call-template name="verb-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$past-marker='-ete' and
                                  ($participle-marker='-et' or
                                   $participle-marker='ge-et')">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$stem"/>
                      <xsl:with-param name="class">
                        <xsl:call-template name="verb-class">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="pos"
                                          select="$pos"/>
                        </xsl:call-template>
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
                  <xsl:when test="($past-marker='-te' or
                                   $past-marker='-ete') and
                                   matches($participle,'en$')">
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
                    <!-- past -->
                    <xsl:choose>
                      <!-- umlautable past stem -->
                      <!-- Caveat: "e" is considered as a full vowel. -->
                      <xsl:when test="matches($past-stem,'([aou]|aa|oo|au)[^aeiouäöü]*$')">
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
                    <xsl:choose>
                      <!-- weak participle -->
                      <xsl:when test="$participle-marker='-t' or
                                      $participle-marker='ge-t'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$participle-stem"/>
                          <xsl:with-param name="class">VVPP-t</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:when test="$participle-marker='-et' or
                                      $participle-marker='ge-et'">
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$participle-stem"/>
                          <xsl:with-param name="class">VVPP-t</xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <!-- strong participle -->
                      <xsl:otherwise>
                        <xsl:call-template name="verb-entry">
                          <xsl:with-param name="lemma"
                                          select="$lemma"/>
                          <xsl:with-param name="stem"
                                          select="$participle-stem"/>
                          <xsl:with-param name="class">VVPP-en</xsl:with-param>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                  <!-- TODO: proper support for modal verbs and auxiliaries -->
                </xsl:choose>
              </xsl:when>
              <!-- verbal participles -->
              <xsl:when test="$pos='Partizip'"><!-- ad-hoc POS -->
                <xsl:variable name="participle"
                              select="normalize-space(dwds:Partizip_II)"/>
                <xsl:variable name="stem">
                  <xsl:call-template name="verb-stem">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-stem">
                  <xsl:call-template name="participle-stem">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="participle-marker"><!-- of weak participles -->
                  <xsl:call-template name="get-verbal-marker">
                    <xsl:with-param name="form"
                                    select="$participle"/>
                    <xsl:with-param name="stem"
                                    select="$stem"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                  <!-- weak participles -->
                  <xsl:when test="$participle-marker='-t' or
                                  $participle-marker='ge-t'">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-t</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$participle-marker='-et' or
                                  $participle-marker='ge-et'">
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
                      <xsl:with-param name="stem"
                                      select="$participle-stem"/>
                      <xsl:with-param name="class">VVPP-t</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <!-- strong participles -->
                  <xsl:otherwise>
                    <xsl:call-template name="verb-entry">
                      <xsl:with-param name="lemma"
                                      select="$lemma"/>
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
