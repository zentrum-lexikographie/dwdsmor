<?xml version="1.0" encoding="utf-8"?>
<!-- dwds2smor.xsl -->
<!-- Version 3.0 -->
<!-- Andreas Nolda 2021-09-24 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<xsl:include href="strings.xsl"/>

<xsl:include href="forms.xsl"/>

<xsl:include href="categories.xsl"/>

<xsl:include href="dwds.xsl"/>

<xsl:output method="text"
            encoding="ISO-8859-1"/>

<xsl:template name="affix-category">
  <xsl:param name="lemma"/>
  <xsl:call-template name="insert-value">
    <xsl:with-param name="value">
      <xsl:choose>
        <xsl:when test="starts-with($lemma,'-')">
          <xsl:text>Suff_Stems</xsl:text>
        </xsl:when>
        <xsl:when test="ends-with($lemma,'-')">
          <xsl:text>Pref_Stems</xsl:text>
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
  <xsl:call-template name="etymology">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="verb-entry">
  <xsl:param name="lemma"/>
  <xsl:param name="stem"/>
  <xsl:param name="class"/>
  <xsl:variable name="base-stem">
    <xsl:call-template name="verb-stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="participle-prefix">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&lt;Base_Stems&gt;</xsl:text>
  <xsl:value-of select="n:pair($base-stem,$stem)"/>
  <xsl:text>&lt;V&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="etymology">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="formation">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
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
  <xsl:text>&lt;Base_Stems&gt;</xsl:text>
  <xsl:value-of select="$lemma"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$pos"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;base&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="etymology">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:call-template name="formation">
    <xsl:with-param name="lemma"
                    select="$lemma"/>
  </xsl:call-template>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$class"/>
  <xsl:text>&gt;</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for the following part-of-speech categories:
* <ABK>
* <ADV>
* <NE>
* <OTHER> -->
<!-- add support for the following inflection classes:
* <Abk_ADJ>
* <Abk_ADV>
* <Abk_ART>
* <Abk_DPRO>
* <Abk_KONJ>
* <Abk_NE-Low>
* <Abk_NE>
* <Abk_NN-Low>
* <Abk_NN>
* <Abk_PREP>
* <Abk_VPPAST>
* <Abk_VPPRES>
* <Adj+(e)>
* <Adj+Lang>
* <Adj-el/er>
* <Adj0-Up>
* <Adj0>
* <AdjComp>
* <AdjNN>
* <AdjNNSuff>
* <AdjPos>
* <AdjPosAttr>
* <AdjPosPred>
* <AdjPosSup>
* <AdjSup>
* <Adj~+e>
* <Adv>
* <Circp>
* <FamName_0>
* <FamName_s>
* <Intj>
* <Konj-Inf>
* <Konj-Kon>
* <Konj-Sub>
* <Konj-Vgl>
* <N?/Pl_0>
* <N?/Pl_x>
* <Name-Fem_0>
* <Name-Fem_s>
* <Name-Invar>
* <Name-Masc_0>
* <Name-Masc_s>
* <Name-Neut_0>
* <Name-Neut_s>
* <Name-Pl_0>
* <Name-Pl_x>
* <NFem-a/en>
* <NFem-Deriv>
* <NFem-is/en>
* <NFem-is/iden>
* <NFem/Pl>
* <NFem/Sg>
* <NMasc-Adj>
* <NMasc-s/Sg>
* <NMasc-us/en>
* <NMasc-us/i>
* <NMasc/Pl>
* <NMasc/Sg_0>
* <NMasc/Sg_es>
* <NMasc/Sg_s>
* <NMasc_en_e>
* <NNeut-a/ata>
* <NNeut-a/en>
* <NNeut-Dimin>
* <NNeut-on/a>
* <NNeut-um/a>
* <NNeut-um/en>
* <NNeut/Pl>
* <NNeut/Sg_0>
* <NNeut/Sg_en>
* <NNeut/Sg_es>
* <NNeut/Sg_s>
* <NNeut_Dimin>
* <NSFem_0_en>
* <NSFem_0_n>
* <NSMasc-s/$sse>
* <NSMasc_es_$e>
* <NSMasc_es_e>
* <NSNeut_es_e>
* <Postp-Akk>
* <Postp-Dat>
* <Postp-Gen>
* <Pref/Adj>
* <Pref/Adv>
* <Pref/N>
* <Pref/ProAdv>
* <Pref/Sep>
* <Pref/V>
* <Prep-Akk>
* <Prep-Dat>
* <Prep-Gen>
* <Prep/Art-m>
* <Prep/Art-n>
* <Prep/Art-r>
* <Prep/Art-s>
* <ProAdv>
* <Ptkl-Adj>
* <Ptkl-Ant>
* <Ptkl-Neg>
* <Ptkl-Zu>
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
* <VInf+PPres>
* <VInf>
* <VMPast>
* <VMPastKonj>
* <VMPresPl>
* <VMPresSg>
* <VPastIndReg>
* <VPastIndStr>
* <VPastKonjStr>
* <VPPast>
* <VPPres>
* <VPresKonj>
* <VPresPlInd>
* <VVPres2+Imp0>
* <VVPres2t>
* <VVPresPl>
* <VVPresSg>
* <WAdv> -->
