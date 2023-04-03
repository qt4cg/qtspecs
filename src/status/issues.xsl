<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                xmlns:ext="http://nwalsh.com/xslt"
                xmlns:f="https://qt4cg.org/ns/functions"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

<xsl:param name="issues" select="'qtspecs-issues.json'"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"
            omit-xml-declaration="yes"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template name="xsl:initial-template">
  <xsl:variable name="issues" select="parse-json(unparsed-text($issues))"/>

  <xsl:for-each select="array:flatten($issues)">
    <xsl:variable name="issue" select="."/>
    <xsl:variable name="dt" select="xs:dateTime($issue?created_at)"/>
    <xsl:variable name="pr" select="map:contains($issue, 'pull_request')"/>

    <xsl:variable name="filename"
                  select="year-from-dateTime($dt)||'/'||$issue?number||'-created.xml'"/>
    <xsl:variable name="output"
                  select="resolve-uri($filename, static-base-uri())"/>

    <xsl:result-document href="{$output}">
      <item>
        <title>
          <xsl:choose>
            <xsl:when test="$pr">
              <xsl:text>Pull request #{$issue?number} created</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Issue #{$issue?number} created</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </title>
        <pubDate>{$issue?created_at}</pubDate>
        <link>{$issue?html_url}</link>
        <guid>https://qt4cg.org/@qt4cg/{substring($issue?created_at, 1, 4)}/#created-{$issue?number}</guid>

        <xsl:variable name="body" as="element()">
          <div>
            <xsl:if test="normalize-space($issue?title) != ''">
              <p>{$issue?title}</p>
            </xsl:if>
            <xsl:if test="$issue?body">
              <xsl:variable
                  name="body"
                  select="ext:commonmark($issue?body)
                          =&gt; replace('&lt;hr&gt;', '&lt;hr/&gt;')
                          =&gt; replace('&lt;br&gt;', '&lt;br/&gt;')"/>
              <xsl:try>
                <xsl:sequence
                    select="parse-xml('&lt;div class=''markup''&gt;'||$body||'&lt;/div&gt;')"/>
                <xsl:catch>
                  <xsl:message select="'Markup not well formed:', $issue?number"/>
                  <xsl:sequence select="'…failed to parse issue text…'"/>
                </xsl:catch>
              </xsl:try>
            </xsl:if>
          </div>
        </xsl:variable>

        <description>
          <xsl:sequence select="serialize($body,map{'method':'xml'})"/>
        </description>
      </item>
    </xsl:result-document>

    <xsl:if test="$issue?closed_at">
      <xsl:variable name="filename"
                    select="year-from-dateTime($dt)||'/'||$issue?number||'-closed.xml'"/>
      <xsl:variable name="output"
                    select="resolve-uri($filename, static-base-uri())"/>

      <xsl:result-document href="{$output}">
        <item>
          <title>Issue #{$issue?number} closed</title>
          <pubDate>{$issue?closed_at}</pubDate>
          <link>{$issue?html_url}</link>
          <guid>https://qt4cg.org/@qt4cg/{substring($issue?created_at, 1, 4)}/#closed-{$issue?number}</guid>

          <xsl:variable name="body" as="element()">
            <div>
              <xsl:if test="normalize-space($issue?title) != ''">
                <p>{$issue?title}</p>
              </xsl:if>
            </div>
          </xsl:variable>

          <description>
            <xsl:sequence select="serialize($body,map{'method':'xml'})"/>
          </description>
        </item>
      </xsl:result-document>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
