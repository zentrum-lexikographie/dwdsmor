<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="ISO-8859-1"/>

<!-- ********************************************** -->
<!-- Stylesheet-NVA-auslesen.xsl                    -->
<!-- Arne Fitschen, IMS, 2004                       -->
<!--                                                -->
<!-- Dateien Luedelex_*.xsl auslesen:               -->
<!-- Stämme, DMOR-Klassen, DMOR-Unterlexikon        -->
<!-- (mit Kategorie, Herkunft, Stammtyp)            -->
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

  <!-- dann die Stammform-Elemente auslesen, falls vorhanden -->
  <!-- Parameter sind Form, Herkunft und das Kategoriesymbol -->

  <xsl:apply-templates select="Flexionsmorphologie/Stammformen/Stammform">

    <xsl:with-param name="kat"   select="$katsymbol"/>
    <xsl:with-param name="herk"  select="@herkunft"/>
    <xsl:with-param name="form"  select="@form"/>
    <xsl:with-param name="stamm" select="Flexionsmorphologie/Stammformen/DMORStamm"/>

  </xsl:apply-templates>

</xsl:template>


<!-- ****************************************************** -->
<!-- Stammformen: je nach DMORtyp Stamm und Klasse ausgeben -->
<!-- ****************************************************** -->

<!-- ****************************************************** -->
<!-- Dies ist das einzige Template, in dem wortart-         -->
<!-- spezifische Information verwendet wird. Alle anderen   -->
<!-- nehmen nur das Kategoriesymbol, das als Variable       -->
<!-- übergeben wird.                                        -->
<!--                                                        -->
<!-- Zuerst Unterlexikon auslesen aus <Komposition>         -->
<!--                                                        -->
<!-- Dann Fallunterscheidung DMORtyp:                       -->
<!-- (<default> ist Aktion "Stamm/DMORklasse auslesen")     -->
<!--                                                        -->
<!--   generell                                             -->
<!--   ========                                             -->
<!--   reg: <default>                                       -->
<!--                                                        -->
<!--   sonst                                                -->
<!--   =====                                                -->
<!--    irreg: DMORStamm:<default>                          -->
<!--                                                        -->
<!-- ****************************************************** -->

<xsl:template match="Stammform">

  <xsl:param name="kat" select="'FEHLER'"/>
  <xsl:param name="herk" select="'FEHLER'"/>
  <xsl:param name="form" select="'FEHLER'"/>
  <xsl:param name="stamm" select="'FEHLER'"/>

  <!-- für jede Stammform zunächst Unterlexikon ausgeben -->
  <xsl:apply-templates select="../../../Flexionsmorphologie">
    <xsl:with-param name="kat" select="$kat"/>
  </xsl:apply-templates>

  <!-- bei bestimmten DMOR-Typen zusätzlich zum Stamm noch -->
  <!-- den DMORStamm vorher ausgeben -->

  <xsl:choose>

    <!-- Sonderfälle NN/ADJ/V: Komma:Kommata, hoch:höh, back:buk -->
    <xsl:when test="@DMORtyp='irreg'">

      <!-- DMORStamm und : vor dem Stamm ausgeben... -->
      <xsl:value-of select="$stamm"/><xsl:text>:</xsl:text>

    </xsl:when>

    <xsl:otherwise>
      <!-- default: nur Stamm ausgeben, also hier nichts machen -->
    </xsl:otherwise>

  </xsl:choose>

  <!-- AB HIER wieder für alle Fälle:                 -->
  <!-- Stamm, Kategoriesymbol, Stammtyp, Herkunft und -->
  <!-- DMOR-Klasse ausgeben je Stamm, dann Zeilenende -->

  <!-- zuerst den Stamm ausgeben -->
  <xsl:value-of select="./Stamm"/>

  <!-- Kategorie-Kuerzel -->
  <xsl:text>&#60;</xsl:text>
  <xsl:value-of select="$kat"/>
  <xsl:text>&#62;</xsl:text>

  <!-- Stamm-Typ (hier immer Default 'base') -->
  <xsl:text>&#60;base&#62;</xsl:text>

  <!-- Herkunft -->
  <xsl:text>&#60;</xsl:text>
  <xsl:value-of select="$herk"/>
  <xsl:text>&#62;</xsl:text>

  <!-- Morphologische Form -->
  <xsl:text>&#60;</xsl:text>
  <xsl:value-of select="$form"/>
  <xsl:text>&#62;</xsl:text>

  <!-- dann die DMOR-Klasse in spitzen Klammern -->
  <xsl:text>&#60;</xsl:text>
  <xsl:value-of select="./DMORklasse"/>
  <xsl:text>&#62;</xsl:text>

  <xsl:text>&#10;</xsl:text>

</xsl:template>


<!-- ******************************************************* -->
<!-- je nach DMORlex DMOR-Unterlexikon ausgeben              -->
<!-- ******************************************************* -->

<!-- ******************************************************* -->
<!-- Fallunterscheidung DMORlex:                             -->
<!--                                                         -->
<!--   nicht vorhanden: Normalfall <Kategoriesymbol>_Stems   -->
<!--   vorhanden: Normalfall oder Sonderfall                 -->
<!--                                                         -->
<!-- ******************************************************* -->

<xsl:template match="Flexionsmorphologie">

  <xsl:param name="kat" select="'FEHLER'"/>

  <xsl:choose>

    <!-- wenn Unterlexikonname vorhanden, ausgeben (Vorsicht: -->
    <!-- leerer Wert wird als solcher ausgegeben: <>, darf -->
    <!-- aber nicht vorkommen nach DTD: Aufzählungstyp! -->

    <xsl:when test="@DMORlex">

      <!-- z.B. Sonderfälle NN_Stems/NoHead, NN_Stems/NoCp, -->
      <!-- z.B. Sonderfälle ADJ_Stems/NoHead, NE_Stems/NoCp etc. -->
      <xsl:text>&#60;</xsl:text>
      <xsl:value-of select="@DMORlex"/>
      <xsl:text>&#62;</xsl:text>

    </xsl:when>

    <!-- Default-Fall: Lexikonname setzt sich zusammen aus -->
    <!-- dem Kategoriesymbol und "_Stems" -->
    <xsl:otherwise>

      <xsl:text>&#60;</xsl:text>
      <xsl:value-of select="$kat"/>
      <xsl:text>_Stems</xsl:text>
      <xsl:text>&#62;</xsl:text>

    </xsl:otherwise>

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
      <xsl:text>FEHLER (Kategoriesymbol nicht in ersetzungen.xml)</xsl:text>
    </xsl:otherwise>

  </xsl:choose>

</xsl:template>

</xsl:stylesheet>
