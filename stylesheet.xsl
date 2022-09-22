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

<xsl:template name="main">
  <ixsl:schedule-action
      http-request="map {
                      'method': 'GET',
                      'href': 'https://api.github.com/repos/qt4cg/qtspecs/pulls?state=open'
                    }">
    <xsl:call-template name="pull-requests"/>
  </ixsl:schedule-action>
  <ixsl:schedule-action
      http-request="map {
                      'method': 'GET',
                      'href': 'https://api.github.com/repos/qt4cg/qtspecs/branches'
                    }">
    <xsl:call-template name="branches"/>
  </ixsl:schedule-action>
</xsl:template>

<xsl:template name="pull-requests">
  <xsl:context-item as="map(*)" use="required"/>

  <xsl:if test=".?status = 200 and starts-with(.?headers?content-type, 'application/json')">
    <xsl:variable name="pulls" select="parse-json(.?body)"/>
    <xsl:variable name="prs" select="array:flatten($pulls)"/>
    <xsl:if test="exists($prs)">
      <ixsl:schedule-action
          http-request="map {
                          'method': 'GET',
                          'href': 'https://qt4cg.org/pr/' || $prs[1]?number || '/index.html',
                          'status-only': true()
                        }">
        <xsl:call-template name="check-pull-requests">
          <xsl:with-param name="pr" select="$prs[1]"/>
          <xsl:with-param name="open-prs" select="()"/>
          <xsl:with-param name="remaining-prs" select="$prs[position() gt 1]"/>
        </xsl:call-template>
      </ixsl:schedule-action>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="check-pull-requests">
  <xsl:context-item as="map(*)" use="required"/>
  <xsl:param name="pr" as="map(*)" required="yes"/>
  <xsl:param name="open-prs" as="map(*)*" required="yes"/>
  <xsl:param name="remaining-prs" as="map(*)*" required="yes"/>

  <xsl:variable name="found-prs"
                select="if (.?status = 200)
                        then ($open-prs, $pr)
                        else $open-prs"/>

  <xsl:choose>
    <xsl:when test="exists($remaining-prs)">
      <ixsl:schedule-action
          http-request="map {
                          'method': 'GET',
                          'href': 'https://qt4cg.org/pr/' || $remaining-prs[1]?number || '/index.html',
                          'status-only': true()
                        }">
        <xsl:call-template name="check-pull-requests">
          <xsl:with-param name="pr" select="$remaining-prs[1]"/>
          <xsl:with-param name="open-prs" select="$found-prs"/>
          <xsl:with-param name="remaining-prs" select="$remaining-prs[position() gt 1]"/>
        </xsl:call-template>
      </ixsl:schedule-action>
    </xsl:when>
    <xsl:when test="exists($found-prs)">
      <xsl:result-document href="#pull-requests" method="ixsl:replace-content">
        <div>
          <h3>Formatted pull requests</h3>
          <table>
            <thead>
              <tr>
                <th>PR</th>
                <th>Author</th>
                <th>Title</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$found-prs">
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
      </xsl:result-document>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>No open pull requests found.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="branches">
  <xsl:context-item as="map(*)" use="required"/>

  <xsl:if test=".?status = 200 and starts-with(.?headers?content-type, 'application/json')">
    <xsl:variable name="branches" select="array:flatten(parse-json(.?body))"/>
    <xsl:if test="exists($branches)">
      <ixsl:schedule-action
          http-request="map {
                          'method': 'GET',
                          'href': 'https://qt4cg.org/branch/' || $branches[1]?name || '/index.html',
                          'status-only': true()
                        }">
        <xsl:call-template name="check-branches">
          <xsl:with-param name="branch" select="$branches[1]"/>
          <xsl:with-param name="open-branches" select="()"/>
          <xsl:with-param name="remaining-branches" select="$branches[position() gt 1]"/>
        </xsl:call-template>
      </ixsl:schedule-action>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="check-branches">
  <xsl:context-item as="map(*)" use="required"/>
  <xsl:param name="branch" as="map(*)" required="yes"/>
  <xsl:param name="open-branches" as="map(*)*" required="yes"/>
  <xsl:param name="remaining-branches" as="map(*)*" required="yes"/>

  <xsl:variable name="found-branches"
                select="if (.?status = 200)
                        then ($open-branches, $branch)
                        else $open-branches"/>

  <xsl:choose>
    <xsl:when test="exists($remaining-branches)">
      <ixsl:schedule-action
          http-request="map {
                          'method': 'GET',
                          'href': 'https://qt4cg.org/branch/' || $remaining-branches[1]?name || '/index.html',
                          'status-only': true()
                        }">
        <xsl:call-template name="check-branches">
          <xsl:with-param name="branch" select="$remaining-branches[1]"/>
          <xsl:with-param name="open-branches" select="$found-branches"/>
          <xsl:with-param name="remaining-branches" select="$remaining-branches[position() gt 1]"/>
        </xsl:call-template>
      </ixsl:schedule-action>
    </xsl:when>
    <xsl:when test="exists($found-branches)">
      <xsl:result-document href="#branches" method="ixsl:replace-content">
        <div>
          <h2>Formatted branches</h2>
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Commit</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$found-branches">
                <tr>
                  <td>
                    <a href="https://qt4cg.org/branch/{.?name}/">
                      <xsl:sequence select=".?name"/>
                    </a>
                  </td>
                  <td>
                    <a href="{.?commit?url}">
                      <xsl:sequence select=".?commit?sha"/>
                    </a>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </xsl:result-document>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>No open branches found.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
