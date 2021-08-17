<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" indent="no"/>
  <xsl:template match="smor">
    <xsl:apply-templates select="BaseStem|PrefStem|KomposStem|DerivStem|SuffStem"/>
  </xsl:template>
  <xsl:template match="BaseStem">
    <xsl:apply-templates select="MorphMarker"/>
    <xsl:text>&lt;Base_Stems&gt;</xsl:text>
    <xsl:apply-templates select="Lemma"/>
    <xsl:apply-templates select="Stem"/>
    <xsl:apply-templates select="Pos"/>
    <xsl:text>&lt;base&gt;</xsl:text>
    <xsl:apply-templates select="Origin"/>
    <xsl:apply-templates select="InfClass"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <xsl:template match="PrefStem">
    <xsl:apply-templates select="MorphMarker"/>
    <xsl:text>&lt;Pref_Stems&gt;</xsl:text>
    <xsl:apply-templates select="Upper"/>
    <xsl:apply-templates select="Lower"/>
    <xsl:text>&lt;PREF&gt;</xsl:text>
    <xsl:apply-templates select="Pos"/>
    <xsl:text>&lt;</xsl:text>
    <xsl:for-each select="Origin[position()!=last()]">
      <xsl:value-of select="."/>
      <xsl:text>,</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="Origin[position()=last()]"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <xsl:template match="KomposStem">
    <xsl:apply-templates select="MorphMarker"/>
    <xsl:text>&lt;Kompos_Stems&gt;</xsl:text>
    <xsl:apply-templates select="Upper"/>
    <xsl:apply-templates select="Lower"/>
    <xsl:apply-templates select="Pos"/>
    <xsl:text>&lt;kompos&gt;</xsl:text>
    <xsl:apply-templates select="Origin"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <xsl:template match="DerivStem">
    <xsl:apply-templates select="MorphMarker"/>
    <xsl:text>&lt;Deriv_Stems&gt;</xsl:text>
    <xsl:apply-templates select="Upper"/>
    <xsl:apply-templates select="Lower"/>
    <xsl:apply-templates select="Pos"/>
    <xsl:text>&lt;deriv&gt;</xsl:text>
    <xsl:apply-templates select="Origin"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <xsl:template match="/smor/SuffStem">
    <xsl:apply-templates select="MorphMarker"/>
    <xsl:text>&lt;Suff_Stems&gt;</xsl:text>
    <xsl:apply-templates select="PrevStem"/>
    <xsl:apply-templates select="Upper"/>
    <xsl:apply-templates select="Lower"/>
    <xsl:apply-templates select="NewStem"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <xsl:template match="PrevStem">
    <xsl:text>&lt;</xsl:text>
    <xsl:for-each select="Complexity[position()!=last()]">
      <xsl:value-of select="."/>
      <xsl:text>,</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="Complexity[position()=last()]"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:text>&lt;</xsl:text>
    <xsl:for-each select="Origin[position()!=last()]">
      <xsl:value-of select="."/>
      <xsl:text>,</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="Origin[position()=last()]"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="@stem_type"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:text>&lt;</xsl:text>
    <xsl:for-each select="Pos[position()!=last()]">
      <xsl:value-of select="."/>
      <xsl:text>,</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="Pos[position()=last()]"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="NewStem">
    <xsl:apply-templates select="Pos"/>
    <xsl:text>&lt;SUFF&gt;</xsl:text>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="@stem_type"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates select="Origin"/>
    <xsl:apply-templates select="InfClass"/>
  </xsl:template>
  <xsl:template match="Lemma|Upper">
    <xsl:value-of select="."/>
    <xsl:text>:</xsl:text>
  </xsl:template>
  <xsl:template match="Stem|Lower">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="Pos|Origin|InfClass|MorphMarker">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
