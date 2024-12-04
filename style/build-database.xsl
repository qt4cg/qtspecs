<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xs"
                expand-text="yes"
                version="3.0">

<xsl:param name="debug" select="'false'"/>

<xsl:strip-space elements="*"/>

<xsl:output method="xml" encoding="utf-8" indent="no"/>

<xsl:template name="xsl:initial-template">
  <xsl:variable name="all-documents" as="document-node()+">
    <xsl:for-each select="collection('../build/etc?select=*.xml;on-error=ignore')">
      <xsl:if test="/document-summary">
        <xsl:sequence select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="relevant-documents" as="document-node()+">
    <xsl:for-each select="$all-documents">
      <xsl:variable name="uri" select="/document-summary/@uri/string()"/>
      <xsl:choose>
        <xsl:when test="contains($uri, 'use-cases')
                        or contains($uri, 'requirements')
                        or contains($uri, 'shared')">
          <xsl:if test="$debug != 'false'">
            <xsl:message>Ignoring {$uri}</xsl:message>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$debug != 'false'">
            <xsl:message>Database {$uri}</xsl:message>
          </xsl:if>
          <xsl:sequence select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:message>
    <xsl:text>Loaded {count($relevant-documents)} </xsl:text>
    <xsl:text>(of {count($all-documents)}) </xsl:text>
    <xsl:text>documents into database</xsl:text>
  </xsl:message>

  <database>
    <xsl:apply-templates select="$relevant-documents/*"/>
  </database>
</xsl:template>

<xsl:template match="document-summary">
  <xsl:variable name="this" select="."/>

  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@* except @xlink:type"/>
    <xsl:apply-templates select="title,div1,inform-div1"/>

    <xsl:for-each select="distinct-values(nt/@def)">
      <xsl:sort select="."/>
      <xsl:variable name="def" select="."/>
      <xsl:apply-templates select="($this/nt[@def=$def])[1]"/>
    </xsl:for-each>

    <xsl:for-each select="distinct-values(termdef/@id)">
      <xsl:sort select="."/>
      <xsl:variable name="id" select="."/>
      <xsl:apply-templates select="($this/termdef[@id=$id])[1]"/>
    </xsl:for-each>

    <xsl:apply-templates select="$this/error"/>

    <xsl:apply-templates select="$this/prod"/>

    <xsl:for-each select="distinct-values((* except (title|div1|inform-div1|nt|termdef|error|prod))
                          ! local-name(.))">
      <xsl:message select="."/>
    </xsl:for-each>
  </xsl:element>
</xsl:template>

<!-- unwrap accidentally double-wrapped nt -->
<xsl:template match="nt[nt]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*">
  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@* except @xlink:type,node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="attribute()|text()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
