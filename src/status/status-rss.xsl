<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="https://qt4cg.org/ns/functions"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:output method="xml" encoding="utf-8" indent="no"/>

<xsl:param name="root" select="resolve-uri('.')"/>

<xsl:variable name="Z" select="xs:dayTimeDuration('PT0S')"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template name="xsl:initial-template">
  <xsl:variable name="statuses" as="element(item)+">
    <xsl:for-each select="collection($root||'?recurse=yes;select=*.xml')">
      <xsl:sort select="/item/pubDate || /item/title" order="descending"/>
      <xsl:sequence select="f:valid(/*)"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable
      name="fn"
      select="resolve-uri('../../@qt4cg/status.rss', static-base-uri())"/>

  <xsl:result-document href="{$fn}">
    <rss version="2.0">
      <channel>
        <title>@qt4cg</title>
        <link>https://qt4cg.org/@qt4cg/</link>
        <description>QT4 CG status feed.</description>
        <language>en-us</language>
        <pubDate>
          <xsl:sequence select="f:dateTime($statuses[1]/pubDate)"/>
        </pubDate>
        <lastBuildDate>
          <xsl:sequence select="f:dateTime(string(current-dateTime()))"/>
        </lastBuildDate>
        <managingEditor>ndw@nwalsh.com</managingEditor>
        <webMaster>ndw@nwalsh.com</webMaster>
        <xsl:apply-templates select="$statuses"/>
      </channel>
    </rss>
  </xsl:result-document>

  <xsl:variable name="head-elements" as="element()+">
    <meta charset='UTF-8' />
    <meta http-equiv="x-ua-compatible" content="ie=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
    <link rel="stylesheet" href="/css/status.css" />
  </xsl:variable>

  <xsl:variable name="years" as="xs:string+"
                select="distinct-values($statuses/pubDate
                                        ! format-dateTime(xs:dateTime(.),
                                            '[Y0001]'))"/>

  <xsl:for-each select="$years">
    <xsl:variable name="year" select="."/>

    <xsl:result-document
        href="{resolve-uri('../../@qt4cg/'||$year||'/index.html')}"
        method="html" html-version="5">
      <html>
        <head>
          <xsl:sequence select="$head-elements"/>
          <title>@qt4cg statuses in <xsl:sequence select="$year"/></title>
        </head>
        <body>
          <main>
            <article>
              <h1>@qt4cg statuses in <xsl:sequence select="$year"/></h1>
              <p>This page displays status
              updates
              about the QT4 CG project from <xsl:sequence
              select="$year"/>.</p>
              <p>See also <a href="../">recent statuses</a>.</p>

              <xsl:call-template name="statuses">
                <xsl:with-param
                    name="statuses"
                    select="$statuses
                            [format-dateTime(xs:dateTime(pubDate),
                               '[Y0001]') = $year]"/>
              </xsl:call-template>
            </article>
          </main>
        </body>
      </html>
    </xsl:result-document>
  </xsl:for-each>

  <xsl:result-document href="{resolve-uri('../../@qt4cg/index.html')}"
                       method="html" html-version="5">
    <html>
      <head>
        <xsl:sequence select="$head-elements"/>
        <title>@qt4cg statuses</title>
      </head>
      <body>
        <main>
          <article>
            <h1>@qt4cg statuses</h1>
            <p>This page displays recent status
            updates
            about the QT4CG project.</p>
            <p>The are also captured in <a href="status.rss">an RSS feed</a>.</p>
            <p>
              <xsl:text>By year: </xsl:text>
              <xsl:for-each select="$years">
                <xsl:sort select="." order="descending"/>
                <xsl:if test="position() gt 1">, </xsl:if>
                <a href="{.}/"><xsl:sequence select="."/></a>
              </xsl:for-each>
            </p>

            <xsl:call-template name="statuses">
              <xsl:with-param
                  name="statuses"
                  select="subsequence($statuses, 1, 30)"/>
            </xsl:call-template>

            <p>See <xsl:value-of select="count($statuses) - 30"/>
            more statuses in yearly archives.</p>
          </article>
        </main>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<xsl:template name="statuses">
  <xsl:param name="statuses" as="element(item)+"/>

  <div class="toots">
    <xsl:for-each select="$statuses">
      <xsl:sort select="pubDate" order="descending"/>

      <xsl:variable
          name="pd"
          select="xs:dateTime(pubDate)"/>

      <xsl:variable
          name="id" 
          select="substring-after(guid, '#')"/>

      <xsl:text>&#10;</xsl:text>

      <div class="toot" id="{$id}">
        <h2>
          <xsl:if test="exists(title)">
            <xsl:sequence select="string(title)"/>
          </xsl:if>
          <span class="toot-id">
            <xsl:text> #</xsl:text>
            <xsl:sequence select="$id"/>
          </span>
        </h2>

        <div class="pubdate">
          <xsl:variable
              name="dt"
              select="adjust-dateTime-to-timezone(
                      xs:dateTime(pubDate), $Z)"/>
          <xsl:sequence
              select="format-dateTime($dt,
                      '[D01] [MNn,*-3] at [H01]:[m01]:[s01] GMT')"/>
        </div>

        <xsl:if test="link">
          <div class="link">
            <xsl:text>Link: </xsl:text>
            <a href="{string(link)}">
              <xsl:sequence select="string(link)"/>
            </a>
          </div>
        </xsl:if>

        <xsl:variable name="content" as="element()?">
          <xsl:choose>
            <xsl:when test="contains(description, '&lt;div')">
              <xsl:sequence select="parse-xml(description)/*"/>
            </xsl:when>
            <xsl:when test="normalize-space(description) != ''">
              <p>
                <xsl:sequence select="string(description)"/>
              </p>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$content/p and $content/div">
            <details>
              <summary>
                <xsl:sequence select="string($content/p[1])"/>
              </summary>
              <xsl:sequence select="$content/div"/>
            </details>
          </xsl:when>
          <xsl:when test="$content/p">
            <xsl:sequence select="$content/p[1]"/>
          </xsl:when>
          <xsl:when test="$content/div">
            <details>
              <summary>More…</summary>
              <xsl:sequence select="$content/div"/>
            </details>
          </xsl:when>
          <xsl:when test="$content/self::p">
            <xsl:sequence select="$content"/>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="item">
  <xsl:copy>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="pubDate">
  <xsl:copy>
    <xsl:sequence select="f:dateTime(.)"/>
  </xsl:copy>
</xsl:template>

<xsl:function name="f:valid" as="element(item)">
  <xsl:param name="item" as="element()"/>

  <xsl:if test="not($item/self::item)">
    <xsl:message terminate="yes"
                 select="'Item is not an item:', local-name($item)"/>
  </xsl:if>

  <xsl:if test="empty($item/description) and empty($item/title)">
    <xsl:message terminate="yes"
                 select="'Item must have a title or a description:', $item"/>
  </xsl:if>

  <xsl:if test="empty($item/pubDate)">
    <xsl:message terminate="yes"
                 select="'Item does not have a pubDate'"/>
  </xsl:if>

  <xsl:if test="empty($item/guid)">
    <xsl:message terminate="yes"
                 select="'Item does not have a guid'"/>
  </xsl:if>

  <xsl:if test="exists($item/* except ($item/title|$item/link|$item/description
                                       |$item/pubDate|$item/guid))">
    <xsl:message terminate="yes"
                 select="'Unexpected extra content:', $item"/>
  </xsl:if>

  <xsl:sequence select="$item"/>
</xsl:function>

<xsl:function name="f:uri" as="xs:string">
  <xsl:param name="item" as="element(item)"/>
  <xsl:variable
      name="year"
      select="substring-before(substring-after(base-uri($item), '/src/'), '/')"/>
  <xsl:sequence
      select="$year || '#status-' || format-dateTime(xs:dateTime($item/pubDate),
                                                     '[M02][D02][h02][m02]')"/>
</xsl:function>

<xsl:function name="f:dateTime" as="xs:string">
  <xsl:param name="dateTime" as="xs:string"/>

  <xsl:variable name="dt"
                select="adjust-dateTime-to-timezone(xs:dateTime($dateTime), $Z)"/>
  <xsl:sequence
      select="format-dateTime($dt,
                '[FNn,*-3], [D] [MNn,*-3] [Y0001] [H01]:[m01]:[s01] GMT')"/>
</xsl:function>

</xsl:stylesheet>
