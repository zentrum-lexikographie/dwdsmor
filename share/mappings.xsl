<?xml version="1.0" encoding="utf-8"?>
<!-- mappings.xsl -->
<!-- Version 0.5 -->
<!-- Andreas Nolda 2021-09-06 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dwds="http://www.dwds.de/ns/1.0"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- mappings -->

<xsl:variable name="pos-mapping">
  <pos pos="Adjektiv">ADJ</pos>
  <pos pos="Präfix">PREF</pos>
  <pos pos="Substantiv">NN</pos>
  <pos pos="Suffix">SUFF</pos>
  <pos pos="Verb">V</pos>
  <!-- TODO: more POS mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:variable name="adjective-class-mapping">
  <class pos="Adjektiv"
         superlative="-"
         umlaut="no">ADJ+</class>
  <class pos="Adjektiv"
         superlative="-"
         umlaut="yes">ADJ$</class>
  <class pos="Adjektiv"
         superlative="-e-"
         umlaut="no">ADJ+e</class>
  <class pos="Adjektiv"
         superlative="-e-"
         umlaut="yes">ADJ$e</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:variable name="noun-class-mapping">
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-e"
         umlaut="no">NMasc_es_e</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-es"
         plural="-en"
         umlaut="no">NMasc_es_en</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-(e)s"
         plural="-er"
         umlaut="yes">NMasc_es_$er</class>
  <class pos="Substantiv"
         gender="mask."
         genitive="-en"
         plural="-en"
         umlaut="no">NMasc_en_en</class>
  <class pos="Substantiv"
         gender="fem."
         genitive="-"
         plural="-en"
         umlaut="no">NFem_0_en</class>
  <class pos="Substantiv"
         gender="neutr."
         genitive="-(e)s"
         plural="-er"
         umlaut="no">NNeut_es_er</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<xsl:variable name="verb-class-mapping">
  <class pos="Verb"
         infinitive="-en"
         past="-te"
         participle="ge-t">VVReg</class>
  <class pos="Verb"
         infinitive="-en"
         past="-te"
         participle="-t">VVReg</class>
  <class pos="Verb"
         infinitive="-en"
         past="-ete"
         participle="ge-et">VVReg</class>
  <class pos="Verb"
         infinitive="-en"
         past="-ete"
         participle="-et">VVReg</class>
  <class pos="Verb"
         infinitive="-n"
         past="-te"
         participle="ge-t">VVReg-el/er</class>
  <class pos="Verb"
         infinitive="-n"
         past="-te"
         participle="-t">VVReg-el/er</class>
  <class pos="Verb"
         infinitive="-n"
         past="-ete"
         participle="ge-et">VVReg-el/er</class>
  <class pos="Verb"
         infinitive="-n"
         past="-ete"
         participle="-et">VVReg-el/er</class>
  <!-- TODO: more class mappings -->
  <!-- ... -->
</xsl:variable>

<!-- helper functions and templates -->

<xsl:function name="n:umlaut-re">
  <xsl:param name="argument"/>
  <!-- return a regexp matching the umlaut variant of the argument, if any -->
  <xsl:choose>
    <!-- replace the last vowel matching [aou] by [äöü] -->
    <xsl:when test="matches($argument,'[aou]')">
      <xsl:sequence select="replace($argument,'^(.*)[aou]([^äöü]*)$',
                                              '$1[äöü]$2',
                                              'i')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$argument"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="n:pair">
  <xsl:param name="argument1"/>
  <xsl:param name="argument2"/>
  <xsl:variable name="value">
    <xsl:if test="string-length($argument1)&gt;0 or
                  string-length($argument2)&gt;0">
      <xsl:variable name="substring1"
                    select="substring($argument1,1,1)"/>
      <xsl:variable name="substring2"
                    select="substring($argument2,1,1)"/>
      <xsl:variable name="string1">
        <xsl:choose>
          <xsl:when test="string-length($substring1)=0">
            <xsl:text>&lt;&gt;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$substring1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="string2">
        <xsl:choose>
          <xsl:when test="string-length($substring2)=0">
            <xsl:text>&lt;&gt;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$substring2"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$string1=$string2">
          <xsl:value-of select="$string1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($string1,':',$string2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="n:pair(substring($argument1,2),
                                   substring($argument2,2))"/>
    </xsl:if>
  </xsl:variable>
  <xsl:sequence select="$value"/>
</xsl:function>

<xsl:template name="verb-stem">
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="ends-with($lemma,'en')">
      <xsl:value-of select="substring($lemma,1,string-length($lemma)-2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring($lemma,1,string-length($lemma)-1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="insert-value">
  <xsl:param name="value"/>
  <xsl:param name="type"/>
  <xsl:param name="lemma"/>
  <xsl:choose>
    <xsl:when test="string-length($value)&gt;0">
      <xsl:value-of select="$value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Warning: "</xsl:text>
        <xsl:value-of select="$lemma"/>
        <xsl:text>" has UNKNOWN </xsl:text>
        <xsl:value-of select="$type"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
      <xsl:text>UNKNOWN</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- grouping templates -->

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

<!-- mapping templates -->

<xsl:template name="adjective-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="superlative"
                select="substring-after(normalize-space(dwds:Superlativ),'am ')"/>
  <xsl:choose>
    <xsl:when test="substring-after($superlative,$lemma)='sten'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$adjective-class-mapping/class[@umlaut='no']
                                                              [@pos=$pos]
                                                              [@superlative='-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="matches($superlative,
                            concat('^',
                                   n:umlaut-re($lemma),
                                   'sten$'))">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$adjective-class-mapping/class[@umlaut='yes']
                                                              [@pos=$pos]
                                                              [@superlative='-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="substring-after($superlative,$lemma)='esten'">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$adjective-class-mapping/class[@umlaut='no']
                                                              [@pos=$pos]
                                                              [@superlative='-e-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="matches($superlative,
                            concat('^',
                                   n:umlaut-re($lemma),
                                   'esten$'))">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$adjective-class-mapping/class[@umlaut='yes']
                                                              [@pos=$pos]
                                                              [@superlative='-e-']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$adjective-class-mapping/class[@umlaut='yes']
                                                              [@pos=$pos]
                                                              [@superlative=$superlative]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="noun-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="gender"
                select="normalize-space(dwds:Genus)"/>
  <xsl:variable name="genitive"
                select="normalize-space(dwds:Genitiv)"/>
  <xsl:choose>
    <xsl:when test="starts-with(dwds:Plural,'-')">
      <xsl:variable name="plural"
                    select="normalize-space(dwds:Plural)"/>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$noun-class-mapping/class[@umlaut='no']
                                                         [@pos=$pos]
                                                         [@gender=$gender]
                                                         [@genitive=$genitive]
                                                         [@plural=$plural]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="plural"
                    select="concat('-',
                                   replace(normalize-space(dwds:Plural),
                                           concat('^',
                                                  n:umlaut-re($lemma)),
                                           ''))"/>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$noun-class-mapping/class[@umlaut='yes']
                                                         [@pos=$pos]
                                                         [@gender=$gender]
                                                         [@genitive=$genitive]
                                                         [@plural=$plural]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="verb-class">
  <xsl:param name="lemma"/>
  <xsl:variable name="pos"
                select="normalize-space(dwds:Wortklasse)"/>
  <xsl:variable name="stem">
    <xsl:call-template name="verb-stem">
      <xsl:with-param name="lemma"
                      select="$lemma"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="infinitive"
                select="concat('-',substring-after($lemma,$stem))"/>
  <xsl:variable name="past"
                select="normalize-space(dwds:Praeteritum)"/>
  <xsl:variable name="participle"
                select="normalize-space(dwds:Partizip_II)"/>
  <xsl:choose>
    <xsl:when test="$past=concat($stem,'te') and
                    $participle=concat('ge',$stem,'t')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$verb-class-mapping/class[@pos=$pos]
                                                         [@infinitive=$infinitive]
                                                         [@past='-te']
                                                         [@participle='ge-t']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$past=concat($stem,'te') and
                    $participle=concat($stem,'t')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$verb-class-mapping/class[@pos=$pos]
                                                         [@infinitive=$infinitive]
                                                         [@past='-te']
                                                         [@participle='-t']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$past=concat($stem,'ete') and
                    $participle=concat('ge',$stem,'et')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$verb-class-mapping/class[@pos=$pos]
                                                         [@infinitive=$infinitive]
                                                         [@past='-ete']
                                                         [@participle='ge-et']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$past=concat($stem,'ete') and
                    $participle=concat($stem,'et')">
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$verb-class-mapping/class[@pos=$pos]
                                                         [@infinitive=$infinitive]
                                                         [@past='-ete']
                                                         [@participle='-et']"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="insert-value">
        <xsl:with-param name="value"
                        select="$verb-class-mapping/class[@pos=$pos]
                                                         [@infinitive=$infinitive]
                                                         [@past=$past]
                                                         [@participle=$participle]"/>
        <xsl:with-param name="type">class</xsl:with-param>
        <xsl:with-param name="lemma"
                        select="$lemma"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
<!-- TODO: -->
<!-- add support for more parts of speech -->
