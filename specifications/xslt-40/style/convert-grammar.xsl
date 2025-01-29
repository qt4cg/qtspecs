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
  version="2.0"
  xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
  exclude-result-prefixes="g">

  <xsl:import href="../../../style/assemble-spec.xsl"/>
  
  <xsl:param name="is-xslt40" select="true()"/>
  
  <xsl:template match="g:xref">
    <xnt spec="XP40" ref="prod-xpath40-{@name}"><xsl:value-of select="@name"/></xnt>
  </xsl:template>
  
  <xsl:template match="g:ref[//g:production[@name=current()/@name][contains(@if, 'xpath40') or not(contains(@if, 'xslt40-patterns'))]]">
    <!--<xsl:message>** XNT <xsl:value-of select="@name"/></xsl:message>-->
    <xnt spec="XP40" ref="prod-xpath40-{@name}"><xsl:value-of select="@name"/></xnt>
  </xsl:template>
  
  <!-- Handle references from the pattern grammar to tokens specially (life is too short to work out why) -->
  <xsl:template match="g:ref[@name='URIQualifiedName']">
    <xnt spec="XP40" ref="prod-xpath40-{@name}"><xsl:value-of select="@name"/></xnt>
  </xsl:template>
  
  <xsl:template match="g:ref[@name=('NCNameTok')]">
    <xnt spec="XP40" ref="prod-xpath40-NCName">NCName</xnt>
  </xsl:template>
  
  <xsl:template match="g:ref[@name=('LocalPart')]">
    <xnt spec="XP40" ref="prod-xpath40-NCName">NCName</xnt>
  </xsl:template>

  <xsl:template match="g:ref[@name=('StringLiteral')]">
    <xnt spec="XP40" ref="prod-xpath40-StringLiteral">StringLiteral</xnt>
  </xsl:template>
  
  <xsl:template match="g:ref">
    <!--<xsl:message>** NT <xsl:value-of select="@name"/></xsl:message>-->
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>

