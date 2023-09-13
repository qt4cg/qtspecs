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

<xsl:output method="html" html-version="5" encoding="utf-8" indent="yes"
            omit-xml-declaration="yes"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template name="xsl:initial-template">
  <xsl:variable name="issues" select="parse-json(unparsed-text($issues))"/>

  <html>
    <head>
      <meta charset='UTF-8' />
      <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
      <title>Index of available pull requests</title>

      <link rel="stylesheet" href="/css/style.css" />
      <link rel="stylesheet" href="/css/ux.css" />

      <link rel="shortcut icon" href="img/QT4-64.png" />
      <link rel="apple-touch-icon" sizes="64x64" href="img/QT4-64.png" type="image/png" />
      <link rel="apple-touch-icon" sizes="76x76" href="img/QT4-76.png" type="image/png" />
      <link rel="apple-touch-icon" sizes="120x120" href="img/QT4-120.png" type="image/png" />
      <link rel="apple-touch-icon" sizes="152x152" href="img/QT4-152.png" type="image/png" />
      <style xsl:expand-text="no">
        .closed { text-decoration: line-through; }
        .cdate { float: right; font-size: 75%; padding-right: 0.5rem; }
        dl div { padding-top: 0.25rem; padding-bottom: 0.25rem; }
        dl div:nth-child(even) { background-color: var(--quote-color); }
        dl { border: 1px solid black; padding: 0; }
        dl dt { padding-left: 0.5rem; }
      </style>
    </head>
    <body>
      <h1>Available pull requests</h1>

      <xsl:variable name="Z" select="xs:dayTimeDuration('PT0S')"/>
      <xsl:variable name="ztime" select="adjust-dateTime-to-timezone(current-dateTime(), $Z)"/>

      <main>
        <p>This page lists all of the formatted pull requests that were available
        on <b>{format-dateTime($ztime, '[D01] [MNn,*-3] [Y0001] at [H01]:[m01]')} UTC</b>.
        This often includes recently closed pull requests that are no longer
        on the dashboard.</p>

        <p>Unlike the dashboard, this page is not dynamically generated
        so it can be a little bit out-of-date.</p>
      <dl>
        <xsl:for-each select="array:flatten($issues)">
          <xsl:sort select=".?number" order="descending"/>

          <xsl:variable name="issue" select="."/>
          <xsl:variable name="dt" select="xs:dateTime($issue?created_at)"/>
          <xsl:variable name="pr" select="map:contains($issue, 'pull_request')"/>

          <xsl:if test="$pr">
            <xsl:variable name="index"
                          select="resolve-uri('../../pr/'||$issue?number||'/index.html',
                                              static-base-uri())"/>
            <xsl:if test="unparsed-text-available($index)">
              <div>
                <dt>
                  <xsl:text>PR </xsl:text>
                  <a href="https://qt4cg.org/pr/{$issue?number}/">#{$issue?number}</a>
                  <xsl:text>, </xsl:text>
                  <span class="{$issue?state}">{$issue?title}</span>
                  <xsl:if test="$issue?state = 'closed'">
                    <span class="cdate">
                      <xsl:text>Closed: </xsl:text>
                      <xsl:text>{format-dateTime(xs:dateTime($issue?closed_at), '[D01] [MNn,*-3] [Y0001]')}</xsl:text>

                    </span>
                  </xsl:if>
                </dt>
              </div>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </dl>
      </main>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
