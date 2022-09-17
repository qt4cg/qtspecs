<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	        xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                xmlns:err="http://www.w3.org/2005/xqt-errors"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                expand-text="yes"
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
      <xsl:call-template name="pull-requests"/>
      <xsl:call-template name="branches"/>
    </xsl:result-document>
  </xsl:if>
</xsl:template>

<xsl:template name="pull-requests">
  <xsl:try>
    <xsl:variable name="pulls"
         select="unparsed-text('https://api.github.com/repos/qt4cg/qtspecs/pulls?state=open')"/>
    <xsl:variable name="pulls" select="parse-json($pulls)"/>

    <xsl:variable name="open" as="map(*)*">
      <xsl:for-each select="array:flatten($pulls)">
        <xsl:sort select=".?number" order="descending"/>
        <xsl:try>
          <xsl:variable name="formatted"
               select="unparsed-text('https://qt4cg.org/pr/' || .?number || '/index.html')"/>
          <xsl:if test="not(contains($formatted, 'Cannot retrieve unparsed-text'))">
            <xsl:sequence select="."/>
          </xsl:if>
          <xsl:catch>
            <!-- nop -->
          </xsl:catch>
        </xsl:try>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="exists($open)">
      <div>
        <h2>Formatted pull requests</h2>
        <table>
          <thead>
            <tr>
              <th>PR</th>
              <th>Author</th>
              <th>Title</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="$open">
              <tr>
                <td>
                  <a href="{.?html_url}">
                    <xsl:sequence select=".?number"/>
                  </a>
                </td>
                <td>
                  <xsl:sequence select=".?user?login"/>
                </td>
                <td>
                  <a href="https://qt4cg.org/pr/{.?number}/index.html">
                    <xsl:sequence select=".?title"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
    </xsl:if>

    <xsl:catch>
      <p>Failed to get list of pull requests from GitHub API.</p>
      <xsl:message select="$err:code, $err:description"/>
    </xsl:catch>
  </xsl:try>
</xsl:template>

<xsl:template name="branches">
  <xsl:try>
    <xsl:variable name="branches"
                  select="unparsed-text('https://api.github.com/repos/qt4cg/qtspecs/branches')"/>
    <xsl:variable name="branches" select="parse-json($branches)"/>

    <xsl:variable name="open" as="map(*)*">
      <xsl:for-each select="array:flatten($branches)">
        <xsl:sort select=".?name" order="ascending"/>
        <xsl:choose>
          <xsl:when test=".?name = 'gh-pages' or .?name = 'master'">
            <!-- ignore this one -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:try>
              <xsl:variable name="formatted"
                   select="unparsed-text('https://qt4cg.org/branch/' || .?name || '/index.html')"/>
              <xsl:if test="not(contains($formatted, 'Cannot retrieve unparsed-text'))">
                <xsl:sequence select="."/>
              </xsl:if>
              <xsl:catch>
                <!-- nop -->
              </xsl:catch>
            </xsl:try>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>

    <xsl:if test="exists($open)">
      <div>
        <h2>Formatted branches</h2>
        <ul>
          <xsl:for-each select="$open">
            <li>
              <a href="https://qt4cg.org/branch/{.?name}/">
                <xsl:sequence select=".?name"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </xsl:if>

    <xsl:catch>
      <p>Failed to get list of branches from GitHub API.</p>
      <xsl:message select="$err:code, $err:description"/>
    </xsl:catch>
  </xsl:try>
</xsl:template>

</xsl:stylesheet>
