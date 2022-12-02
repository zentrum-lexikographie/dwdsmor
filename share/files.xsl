<?xml version="1.0" encoding="utf-8"?>
<!-- files.xsl -->
<!-- Version 1.0 -->
<!-- Andreas Nolda 2022-11-30 -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:n="http://andreas.nolda.org/ns/lib">

<!-- current working directory -->
<xsl:variable name="current-dir"
              select="system-property('user.dir')"/>

<xsl:function name="n:uri2path">
  <xsl:param name="uri"/>
  <xsl:if test="string-length($uri)&gt;0">
    <xsl:choose>
      <xsl:when test="starts-with($uri,'file:')">
        <xsl:sequence select="substring-after($uri,'file:')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$uri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:function>

<xsl:function name="n:absolute-path">
  <xsl:param name="uri"/>
  <xsl:variable name="path"
                select="n:uri2path($uri)"/>
  <xsl:if test="string-length($path)&gt;0">
    <xsl:choose>
      <xsl:when test="starts-with($path,'/')">
        <xsl:sequence select="$path"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="concat($current-dir,'/',$path)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:function>

<xsl:function name="n:relative-path">
  <xsl:param name="uri"/>
  <xsl:variable name="path"
                select="n:uri2path($uri)"/>
  <xsl:if test="string-length($path)&gt;0">
    <xsl:choose>
      <xsl:when test="starts-with($path,$current-dir)">
        <xsl:sequence select="substring-after($path,concat($current-dir,'/'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$path"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:function>
</xsl:stylesheet>
