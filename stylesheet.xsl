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
  <xsl:if test="not(contains(ixsl:get(ixsl:window(), 'location.href'), '?nojs'))">
    <xsl:result-document href="#speclist" method="ixsl:replace-content">
      <p>The latest drafts of</p>
      <ul>
        <li><a href="specifications/xslt-40/Overview.html"
               >XSLT Transformations (XSLT) Version 4.0</a>
        <span class="diffs"> (<a href="specifications/xslt-40/Overview-diff.html">latest
        diffs</a>)</span>
        </li>
        <li><a href="specifications/xpath-functions-40/Overview.html"
               >XPath and XQuery Functions and Operators 4.0</a>
        <span class="diffs"> (<a href="specifications/xpath-functions-40/Overview-diff.html">latest
        diffs</a>)</span>
        </li>
        <li><a href="specifications/xquery-40/xpath-40.html"
               >XML Path Language (XPath) 4.0</a>
        <span class="diffs"> (<a href="specifications/xquery-40/xpath-40-diff.html">latest
        diffs</a>)</span>, and
        </li>
        <li><a href="specifications/xquery-40/xquery-40.html"
               >XQuery 4.0: An XML Query Language</a>
        <span class="diffs"> (<a href="specifications/xquery-40/xquery-40-diff.html">latest
        diffs</a>)</span>
        </li>
      </ul>
      <p>are updated automatically when changes are made to the repository.</p>
      <xsl:if test="branch[@name != 'master']">
        <p>Additional drafts are available on alternate branches:</p>
        <ul>
          <xsl:apply-templates select="branch[@name != 'master']"/>
        </ul>
      </xsl:if>
    </xsl:result-document>
  </xsl:if>
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
  <xsl:choose>
    <xsl:when test="html[. = 'Overview.html']">
      <li>
        <a href="/branch/{../@name}/{@name}/Overview.html">
          <xsl:sequence select="string(@name)"/>
        </a>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="html[ends-with(., '.html')]">
        <li>
          <a href="/branch/{../@name}/{@name}/{.}">
            <xsl:sequence select="string(.)"/>
          </a>
        </li>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="specification[@name='xslt-40']">
  <li>
    <a href="/branch/{../@name}/{@name}/Overview.html"
       >XSLT Transformations (XSLT) Version 4.0</a>
  </li>
</xsl:template>

<xsl:template match="specification[@name='xpath-functions-40']">
  <li>
    <a href="/branch/{../@name}/{@name}/Overview.html"
       >XPath and XQuery Functions and Operators 4.0</a>
  </li>
</xsl:template>

<xsl:template match="specification[@name='xquery-40']">
  <li><a href="/branch/{../@name}/{@name}/xpath-40.html"
         >XML Path Language (XPath) 4.0</a></li>
  <li><a href="/branch/{../@name}/{@name}/xquery-40.html"
         >XQuery 4.0: An XML Query Language</a></li>
</xsl:template>

</xsl:stylesheet>
