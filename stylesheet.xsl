<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	        xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="h ixsl js saxon xs"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:template match="/specifications[branch]">
  <xsl:message>hello</xsl:message>
  <xsl:result-document href="#speclist" method="ixsl:replace-content">
    <xsl:choose>
      <xsl:when test="count(branch[@name='master']/specification) = 1
                      and branch[@name='master']/specification[@name='xslt-40']">
        <p>The <a href="branch/master/xslt-40/Overview.html">latest draft</a> of
        <cite>XSL Transformations (XSLT) Version 4.0</cite> is updated
        automatically when changes are made to the repository.</p>
        <xsl:if test="branch[@name != 'master']">
          <p>Additional drafts are available on alternate branches:</p>
          <ul>
            <xsl:apply-templates select="branch[@name != 'master']"/>
          </ul>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <p>The following drafts are available:</p>
        <ul>
          <xsl:apply-templates select="branch"/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:result-document>
</xsl:template>

<xsl:template match="branch">
  <li>
    <xsl:sequence select="string(@name)"/>
    <ul>
      <xsl:apply-templates select="specification"/>
    </ul>
  </li>
</xsl:template>

<xsl:template match="specification">
  <li>
    <a href="/branch/{../@name}/{@name}/Overview.html">
      <xsl:sequence select="string(@name)"/>
    </a>
  </li>
</xsl:template>

</xsl:stylesheet>
