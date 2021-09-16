<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smorlemma.xsl -->
<!-- Version 2.1 -->
<!-- Andreas Nolda 2021-09-16 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="mappings.xsl"/>

<xsl:output method="text"
            encoding="UTF-8"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
  <xsl:apply-templates select="/dwds:DWDS/dwds:Artikel"/>
</xsl:template>

<xsl:template match="dwds:Artikel">
  <!-- ignore idioms -->
  <xsl:apply-templates select="dwds:Formangabe[not(normalize-space(dwds:Grammatik/dwds:Wortklasse)='Mehrwortausdruck')]"/>
</xsl:template>

<xsl:template name="affix-category">
  <xsl:param name="lemma"/>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value">
      <xsl:choose>
        <xsl:when test="starts-with($lemma,'-')">
          <xsl:text>Suffix</xsl:text>
        </xsl:when>
        <xsl:when test="ends-with($lemma,'-')">
          <xsl:text>Prefix</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:with-param>
    <xsl:with-param name="type">affix category</xsl:with-param>
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="affix-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="pos"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="affix-category">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:call-template name="affix-form">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pos"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="verb-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:call-template name="participle-prefix"/>
  <xsl:value-of select="n:pair($lemma,$stem)"/>
  <xsl:text>&lt;V&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$class"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="default-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="pos"/>
  <xsl:param name="class"/>
  <xsl:param name="etymology"/>
  <xsl:text>&lt;Stem&gt;</xsl:text>
  <xsl:value-of select="$lemma"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pos"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$etymology"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$class"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

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
  <xsl:for-each select="dwds:Schreibung">
    <xsl:variable name="lemma"
                  select="normalize-space(.)"/>
    <xsl:variable name="etymology">
      <xsl:apply-templates select="../../dwds:Diachronie">
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:for-each select="$data-by-group/dwds:Grammatik">
      <xsl:variable name="pos"
                    select="normalize-space(dwds:Wortklasse)"/>
      <xsl:choose>
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
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$pos='Verb'">
          <xsl:variable name="stem">
            <xsl:call-template name="verb-stem">
              <xsl:with-param name="lemma"
                              select="$lemma"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="past"
                        select="normalize-space(dwds:Praeteritum)"/>
          <xsl:variable name="participle"
                        select="normalize-space(dwds:Partizip_II)"/>
          <xsl:variable name="present-stem">
            <xsl:call-template name="present-stem"/>
          </xsl:variable>
          <xsl:variable name="past-stem">
            <xsl:call-template name="past-stem"/>
          </xsl:variable>
          <xsl:variable name="participle-stem">
            <xsl:call-template name="participle-stem"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
              <!-- past indicative -->
              <xsl:call-template name="verb-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="$past-stem"/>
                <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
              <!-- past indicative -->
              <xsl:call-template name="verb-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="$past-stem"/>
                <xsl:with-param name="class">VVPastIndReg</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
              <!-- past subjunctive -->
              <xsl:call-template name="verb-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="$past-stem"/>
                <xsl:with-param name="class">VVPastKonjReg</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
              <!-- past participle -->
              <xsl:call-template name="verb-entry">
                <xsl:with-param name="lemma"
                                select="$lemma"/>
                <xsl:with-param name="stem"
                                select="$participle-stem"/>
                <xsl:with-param name="class">VVPP-en</xsl:with-param>
                <xsl:with-param name="etymology"
                                select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="verb-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="class">VVPres2+Imp</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <xsl:call-template name="verb-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="stem"
                                    select="$present-stem"/>
                    <xsl:with-param name="class">VVPres2</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
                  </xsl:call-template>
                  <!-- past subjunctive -->
                  <xsl:call-template name="verb-entry">
                    <xsl:with-param name="lemma"
                                    select="$lemma"/>
                    <xsl:with-param name="stem"
                                    select="n:umlaut($past-stem)"/>
                    <xsl:with-param name="class">VVPastKonjStr</xsl:with-param>
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                    <xsl:with-param name="etymology"
                                    select="$etymology"/>
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
                <xsl:with-param name="etymology"
                                select="$etymology"/>
              </xsl:call-template>
            </xsl:otherwise>
            <!-- TODO: support for irregular verbs, modal verbs, and auxiliaries -->
          </xsl:choose>
        </xsl:when>
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
            <xsl:with-param name="etymology"
                            select="$etymology"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

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

<xsl:template name="smorlemma-adjective-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="smor-adjective-class">
    <xsl:call-template name="adjective-class">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="replace($smor-adjective-class,'^ADJ','Adj')"/>
</xsl:template>

<xsl:template match="dwds:Grammatik"
              mode="class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:choose>
    <xsl:when test="$pos='Adjektiv'">
      <!-- convert SMOR class to SMORLemma class -->
      <xsl:call-template name="smorlemma-adjective-class">
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
<!-- TODO: -->
<!-- add support for the following part-of-speech categories:
* <ABBR>
* <ADV>
* <NPROP>
* <OTHER> -->
<!-- add support for the following inflection classes:
* <Abk_ADJ>
* <Abk_ADV>
* <Abk_KONJ>
* <Abk_NE>
* <Abk_NEFem>
* <Abk_NFem>
* <Abk_NMasc>
* <Abk_NN>
* <Abk_NNeut>
* <Adj&>
* <Adj0>
* <Adj0-Up>
* <AdjComp>
* <Adj+(e)>
* <Adj-el/er>
* <AdjNNSuff>
* <AdjPos>
* <AdjPosAttr-Up>
* <AdjSup>
* <Adv>
* <FamName_0>
* <FamName_s>
* <Intj>
* <Konj-Kon>
* <Konj-Sub>
* <Konj-Vgl>
* <Name-Fem_0>
* <Name-Fem_s>
* <Name-Masc_0>
* <Name-Masc_s>
* <Name-Neut_0>
* <Name-Neut_s>
* <Name-Pl_0>
* <Name-Pl_x>
* <NFem_0_$>
* <NFem_0_$e>
* <NFem_0_e>
* <NFem_0_n>
* <NFem_0_s>
* <NFem_0_x>
* <NFem-a/en>
* <NFem-in>
* <NFem-is/en>
* <NFem-is/iden>
* <NFem/Pl>
* <NFem/Sg>
* <NFem_s_s>
* <NFem-s/sse>
* <NFem-s/ssen>
* <NMasc_0_x>
* <NMasc-Adj>
* <NMasc_en_e>
* <NMasc_es_$e>
* <NMasc-es_e>
* <NMasc_es_er>
* <NMasc_n_n>
* <NMasc-ns>
* <NMasc/Pl>
* <NMasc_s_$>
* <NMasc-s/$sse>
* <NMasc_s_$x>
* <NMasc_s_0>
* <NMasc_s_e>
* <NMasc_s_en>
* <NMasc/Sg_0>
* <NMasc/Sg_es>
* <NMasc/Sg_s>
* <NMasc_s_n>
* <NMasc_s_s>
* <NMasc-s/sse>
* <NMasc_s_x>
* <NMasc-us/en>
* <NMasc-us/i>
* <NNeut-0/ien>
* <NNeut_0_x>
* <NNeut-a/ata>
* <NNeut-a/en>
* <NNeut_es_$er>
* <NNeut_es_e>
* <NNeut_es_en>
* <NNeut-on/a>
* <NNeut/Pl>
* <NNeut_s_$>
* <NNeut_s_0>
* <NNeut_s_e>
* <NNeut_s_en>
* <NNeut/Sg_0>
* <NNeut/Sg_es>
* <NNeut/Sg_s>
* <NNeut_s_n>
* <NNeut_s_s>
* <NNeut-s/sse>
* <NNeut_s_x>
* <NNeut-um/a>
* <NNeut-um/en>
* <N?/Pl_0>
* <N?/Pl_x>
* <Postp-Akk>
* <Postp-Dat>
* <Postp-Gen>
* <Pref/Sep>
* <Prep-Akk>
* <Prep/Art-m>
* <Prep/Art-n>
* <Prep/Art-r>
* <Prep/Art-s>
* <Prep-DA>
* <Prep-Dat>
* <Prep-GD>
* <Prep-GDA>
* <Prep-Gen>
* <ProAdv>
* <Ptkl-Ant>
* <Ptkl-Neg>
* <VAImpPl>
* <VAImpSg>
* <VAPastKonj2>
* <VAPres1/3PlInd>
* <VAPres1SgInd>
* <VAPres2PlInd>
* <VAPres2SgInd>
* <VAPres3SgInd>
* <VAPresKonjPl>
* <VAPresKonjSg>
* <VInf>
* <VMPast>
* <VMPastKonj>
* <VMPresPl>
* <VMPresSg>
* <VPastIndStr>
* <VPastKonjStr>
* <VPPast>
* <VVPres2+Imp0>
* <VVPres2t>
* <WAdv> -->
