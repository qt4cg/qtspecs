<?xml version="1.0" encoding="utf-8"?>

<!--
 * Copyright (c) 2002 World Wide Web Consortium,
 * (Massachusetts Institute of Technology, Institut National de
 * Recherche en Informatique et en Automatique, Keio University). All
 * Rights Reserved. This program is distributed under the W3C's Software
 * Intellectual Property License. This program is distributed in the
 * hope that it will be useful, but WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.
 * See W3C License http://www.w3.org/Consortium/Legal/ for more details.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>
  <xsl:param name="not-spec" select="'xpath'"/>
  <xsl:param name="spec" select="'xquery'"/>

<!-- Generate a comment that identifies as much as we can about the XSLT processor being used -->
  <xsl:template match="/">
    <xsl:variable name="XSLTprocessor">
      <xsl:text>XSLT Processor: </xsl:text>
      <xsl:value-of select="system-property('xsl:vendor')"/>
      <xsl:if test="system-property('xsl:version') = '2.0'">
        <xsl:text> </xsl:text>
        <xsl:value-of select="system-property('xsl:product-name')"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:if>
    </xsl:variable>
    <xsl:message><xsl:value-of select="$XSLTprocessor"/></xsl:message>
    <xsl:comment><xsl:value-of select="$XSLTprocessor"/></xsl:comment>
    <xsl:text>(: parse tests :)&#10;</xsl:text>
    <xsl:for-each select="//eg[@role='xquery']">
      <xsl:variable name="trimmed" select="normalize-space(.)"/>
      <xsl:variable name="lastChar" 
        select="substring($trimmed, string-length($trimmed))"/>

      <!-- xsl:message>
        [<xsl:value-of select="$lastChar"/>]
      </xsl:message -->

      <xsl:if test="$lastChar = '}' and not(starts-with($trimmed, 'module'))">
        <xsl:text>module myfns = "http://www.example.com/function-library"&#10;</xsl:text>
      </xsl:if>
      <xsl:value-of select="."/>
      <xsl:text>&#10;%%%&#10;</xsl:text>
    </xsl:for-each>
    <xsl:text>(: end of parse tests :)</xsl:text>
  </xsl:template>

</xsl:stylesheet>