<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:g='http://nwalsh.com/ns/git-repo-info'
                xmlns='http://nwalsh.com/ns/git-repo-info'
                exclude-result-prefixes="xs"
                version="3.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="g:git-repo-info">
  <xsl:variable name="summary">
    <pr-summary>
      <xsl:apply-templates select="g:commit[g:file[starts-with(., 'pr/')]]"/>
    </pr-summary>
  </xsl:variable>
  <xsl:apply-templates select="$summary"/>
</xsl:template>

<xsl:template match="g:commit">
  <pr-commit>
    <xsl:copy-of select="g:hash"/>
    <xsl:variable name="prs" as="xs:string+">
      <xsl:for-each select="g:file[starts-with(., 'pr/')]">
        <xsl:value-of select="tokenize(., '/')[2]"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:for-each select="distinct-values($prs)">
      <g:pr>
        <xsl:value-of select="."/>
      </g:pr>
    </xsl:for-each>
  </pr-commit>
</xsl:template>

<xsl:template match="g:pr-commit">
  <xsl:variable name="last-mentions" as="xs:string*">
    <xsl:for-each select="g:pr">
      <xsl:variable name="number" select="string(.)"/>
      <xsl:if test="not(preceding::g:pr[. = $number])">
        <xsl:sequence select="$number"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="exists($last-mentions)">
      <pr-commit>
        <xsl:copy-of select="g:hash"/>
        <xsl:for-each select="$last-mentions">
          <g:pr>
            <xsl:value-of select="."/>
          </g:pr>
        </xsl:for-each>
      </pr-commit>
    </xsl:when>
    <xsl:otherwise>
<!--
      <g:dead-commit>
        <xsl:sequence select="*"/>
      </g:dead-commit>
-->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
