<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="ISO-8859-1"/>

<!-- ********************************************** -->
<!-- Stylesheet-DeKo-auslesen.xsl                   -->
<!-- Arne Fitschen, IMS, 2004                       -->
<!--                                                -->
<!-- Dateien Luedelex_*.xsl auslesen:               -->
<!-- Derivations- und Kompositionsstämme mit        -->
<!-- Kategorie, Herkunft und Stammtyp               -->
<!--                                                -->
<!-- ********************************************** -->


<!-- ************************************* -->
<!-- root: weitergehen zu jedem le-Element -->
<!-- ************************************* -->

<xsl:template match="lexikon">
  <xsl:apply-templates select="le"/>
</xsl:template>

<!-- ************************************* -->
<!-- le: ab hier Stammformen untersuchen   -->
<!-- ************************************* -->

<xsl:template match="le">

  <!-- zuerst Kategorie durch Kategoriesymbol ersetzen mit Hilfe -->
  <!-- einer Ersetzungsdatei, in der zu 'Nomen' 'NN' steht etc. -->

  <xsl:variable name="katsymbol">

    <xsl:call-template name="ersetze">

      <xsl:with-param name="quelle" select="@kategorie"/>

    </xsl:call-template>

  </xsl:variable>

  <!-- dann die Komposition/Derivation-Elemente auslesen -->
  <!-- Parameter sind Herkunft und Kategoriesymbol -->

  <xsl:apply-templates select="Wortbildung/Derivation">

    <xsl:with-param name="kat"   select="$katsymbol"/>
    <xsl:with-param name="herk"  select="@herkunft"/>
    <xsl:with-param name="stamm" select="Flexionsmorphologie/Stammformen/DMORStamm"/>
  </xsl:apply-templates>

  <xsl:apply-templates select="Wortbildung/Komposition">

    <xsl:with-param name="kat"   select="$katsymbol"/>
    <xsl:with-param name="herk"  select="@herkunft"/>
    <xsl:with-param name="stamm" select="Flexionsmorphologie/Stammformen/DMORStamm"/>

  </xsl:apply-templates>

</xsl:template>


<!-- ***************************************************** -->
<!-- Derivation/Komposition: gibt es die für diese Form?   -->
<!-- ***************************************************** -->

<xsl:template match="Komposition|Derivation">

  <xsl:param name="kat"   select="'FEHLER'"/>
  <xsl:param name="herk"  select="'FEHLER'"/>
  <xsl:param name="stamm" select="'FEHLER'"/>

  <xsl:param name="wobiart">

    <xsl:choose>
      <xsl:when test="local-name(.)='Komposition'">K</xsl:when>
      <xsl:otherwise>D</xsl:otherwise>
    </xsl:choose>

  </xsl:param>

  <!-- ************************************************************ -->
  <!-- Je nach Wortbildungsart in Derivation/Komposition verzweigen -->
  <!-- ************************************************************ -->

  <xsl:choose>

    <xsl:when test="@typ='ja' and
                    $wobiart='D'">

      <xsl:apply-templates select="Derivationsstaemme/Derivationsstamm">

        <xsl:with-param name="kat"   select="$kat"/>
        <xsl:with-param name="herk"  select="$herk"/>
        <xsl:with-param name="stamm" select="$stamm"/>

      </xsl:apply-templates>

    </xsl:when>

    <xsl:when test="@typ='ja' and
                    $wobiart='K'">

      <xsl:apply-templates select="Kompositionsstaemme/Kompositionsstamm">

        <xsl:with-param name="kat"   select="$kat"/>
        <xsl:with-param name="herk"  select="$herk"/>
        <xsl:with-param name="stamm" select="$stamm"/>

      </xsl:apply-templates>

    </xsl:when>

  </xsl:choose>

</xsl:template>


<!-- ********************************************************* -->
<!-- Derivation/Komposition: Stamm und Herkunft etc. ausgeben  -->
<!-- ********************************************************* -->

<xsl:template match="Kompositionsstamm|Derivationsstamm">

  <xsl:param name="kat"   select="'FEHLER'"/>
  <xsl:param name="herk"  select="'FEHLER'"/>
  <xsl:param name="stamm" select="'FEHLER'"/>

  <xsl:param name="stammtyp">
    <xsl:choose>
      <xsl:when test="local-name(.)='Kompositionsstamm'">kompos</xsl:when>
      <xsl:otherwise>deriv</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <!-- Stamm ausgeben, falls überhaupt vorhanden! -->
  <xsl:choose>

    <!-- ********************************************** -->
    <!-- *******************  WHEN  ******************* -->
    <!-- ********************************************** -->

    <xsl:when test="string-length(.)>0">

      <!-- für jede Stammform zunächst Unterlexikon ausgeben -->
      <!-- Lexikonname ist entweder D_Stems oder K_Stens, -->
      <!-- Derivation oder Komposition -->

      <xsl:text>&#60;</xsl:text>
      <xsl:text>DK_Stems&#62;</xsl:text>

      <!-- dann DMORStamm ausgeben und : und Stammform -->
      <xsl:value-of select="$stamm"/><xsl:text>:</xsl:text>

      <!-- Stamm, Kategoriesymbol und Herkunft ausgeben -->
      <!-- je Kompositionsstamm, dann Zeilenende -->

      <!-- zuerst den Stamm ausgeben -->
      <xsl:value-of select="."/>

      <!-- Kategorie-Kuerzel -->
      <xsl:text>&#60;</xsl:text>
      <xsl:value-of select="$kat"/>
      <xsl:text>&#62;</xsl:text>

      <!-- Stamm-Typ ('kompos' bei Komposition, 'deriv' sonst) -->
      <xsl:text>&#60;</xsl:text>
      <xsl:value-of select="$stammtyp"/>
      <xsl:text>&#62;</xsl:text>

      <!-- Herkunft -->
      <xsl:text>&#60;</xsl:text>
      <xsl:value-of select="$herk"/>
      <xsl:text>&#62;</xsl:text>

      <!-- und schließlich Zeilenumbruch -->
      <xsl:text>&#10;</xsl:text>

    </xsl:when>

  </xsl:choose>

</xsl:template>


<!-- ******************************************** -->
<!-- "matchall" am Ende: keine weiteren Ausgaben! -->
<!-- ******************************************** -->

<xsl:template match="*"/>


<!-- ******************************************** -->
<!-- Funktion 'ersetze'                           -->
<!-- ******************************************** -->

<xsl:template name="ersetze">

  <xsl:param name="quelle" select="'FEHLER'"/>

  <xsl:variable name="myersetze" select="document('ersetzungen.xml')/ersetzung/ersetze[@quelle=$quelle]"/>

  <xsl:choose>

    <xsl:when test="$myersetze">

      <xsl:value-of select="$myersetze/@ziel"/>

    </xsl:when>

    <xsl:otherwise>
      <xsl:text>FEHLER (Kategoriesymbol nicht in ersetze.xml)</xsl:text>
    </xsl:otherwise>

  </xsl:choose>

</xsl:template>

</xsl:stylesheet>
