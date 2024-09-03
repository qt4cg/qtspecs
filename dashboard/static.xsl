<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:variable name="specifications" as="map(*)">
  <xsl:map>
    <xsl:map-entry key="'xpath-functions-40'">
      <xsl:map>
        <xsl:map-entry key="'dir'" select="'xpath-functions-40'"/>
        <xsl:map-entry key="'html'" select="'Overview.html'"/>
        <xsl:map-entry key="'title'" select="'XPath and XQuery Functions and Operators 4.0'"/>
      </xsl:map>
    </xsl:map-entry>
    <xsl:map-entry key="'xslt-40'">
      <xsl:map>
        <xsl:map-entry key="'dir'" select="'xslt-40'"/>
        <xsl:map-entry key="'html'" select="'Overview.html'"/>
        <xsl:map-entry key="'title'" select="'XSL Transformations (XSLT) Version 4.0'"/>
      </xsl:map>
    </xsl:map-entry>
    <xsl:map-entry key="'xpath-datamodel-40'">
      <xsl:map>
        <xsl:map-entry key="'dir'" select="'xpath-datamodel-40'"/>
        <xsl:map-entry key="'html'" select="'Overview.html'"/>
        <xsl:map-entry key="'title'" select="'XQuery and XPath Data Model 4.0'"/>
      </xsl:map>
    </xsl:map-entry>
    <xsl:map-entry key="'xpath-40'">
      <xsl:map>
        <xsl:map-entry key="'dir'" select="'xquery-40'"/>
        <xsl:map-entry key="'html'" select="'xpath-40.html'"/>
        <xsl:map-entry key="'title'" select="'XML Path Language (XPath) 4.0'"/>
      </xsl:map>
    </xsl:map-entry>
    <xsl:map-entry key="'xquery-40'">
      <xsl:map>
        <xsl:map-entry key="'dir'" select="'xquery-40'"/>
        <xsl:map-entry key="'html'" select="'xquery-40.html'"/>
        <xsl:map-entry key="'title'" select="'XQuery 4.0: An XML Query Language'"/>
      </xsl:map>
    </xsl:map-entry>
    <xsl:map-entry key="'xslt-xquery-serialization-40'">
      <xsl:map>
        <xsl:map-entry key="'dir'" select="'xslt-xquery-serialization-40'"/>
        <xsl:map-entry key="'html'" select="'Overview.html'"/>
        <xsl:map-entry key="'title'" select="'XSLT and XQuery Serialization 4.0'"/>
      </xsl:map>
    </xsl:map-entry>
  </xsl:map>
</xsl:variable>

<xsl:variable name="html-list" as="element()*">
  <xsl:for-each select="tokenize(unparsed-text('/tmp/pr-list.txt'), '\s+')[starts-with(., 'pr/')]">
    <xsl:variable name="parts" select="tokenize(., '/')"/>
    <document number="{$parts[2]}" spec="{$parts[3]}" html="{$parts[4]}"/>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="issues" as="map(*)*">
  <xsl:sequence select="array:flatten(parse-json(unparsed-text('../pr-status/issues.json')))"/>
</xsl:variable>

<xsl:variable name="changes" as="map(*)*">
  <xsl:sequence select="array:flatten(parse-json(unparsed-text('../pr-status/changes.json')))"/>
</xsl:variable>

<xsl:template name="xsl:initial-template">
  <html xmlns="http://www.w3.org/1999/xhtml" class="no-js">
    <head>
      <meta charset='UTF-8' />
      <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
      <title>QT4 CG Dashboard</title>
      <link rel="stylesheet" href="../css/style.css" />
      <link rel="shortcut icon" href="/img/QT4-64.png" />
      <link rel="apple-touch-icon" sizes="64x64" href="/img/QT4-64.png" type="image/png" />
      <link rel="apple-touch-icon" sizes="76x76" href="/img/QT4-76.png" type="image/png" />
      <link rel="apple-touch-icon" sizes="120x120" href="/img/QT4-120.png" type="image/png" />
      <link rel="apple-touch-icon" sizes="152x152" href="/img/QT4-152.png" type="image/png" />
    </head>
    <body>
      <h1>QT4 CG Dashboard (Static)</h1>
      <main>
        <section class="community" x-name="qt4cg">
          <section class="repository" x-name="qtspecs">
            <p>These are the open pull requests and current branches.
            Where possible, a summary of the
            changes between the pull request or branch and the latest drafts is
            provided with a <a href="deltaxml.html">DeltaXML</a> pipeline.
            </p>

            <div class="pull-requests">
              <h3>
                <xsl:text>Pull requests in descending</xsl:text>
                <xsl:text> order</xsl:text>
              </h3>

              <xsl:for-each select="$issues[exists(.?pull_request) and .?state = 'open']">
                <xsl:sort select=".?number" order="descending"/>
                <xsl:variable name="issue" select="."/>

                <div class="pull-request" id="pr-{$issue?number}" x-pull="{$issue?number}">
                  <h4>PR #{$issue?number}: {$issue?title}</h4>

                  <details>
                    <summary>Pull request 
                    <a href="https://github.com/qt4cg/qtspecs/pull/{$issue?number}">#{$issue?number}</a>
                    by <a href="https://github.com/{$issue?user?login}">{$issue?user?login}</a>.</summary>
                    <p>{$issue?body}</p>
                  </details>

                  <xsl:variable name="changed" select="map:get($changes, string($issue?number))"/>
                  <xsl:variable name="changed-files" as="xs:string*">
                    <xsl:for-each select="array:flatten($changed)">
                      <xsl:sort select=".?filename"/>
                      <xsl:sequence select=".?filename"/>
                    </xsl:for-each>
                  </xsl:variable>

                  <details>
                    <summary>Changed files</summary>
                    <ul class="changed-files">
                      <xsl:for-each select="$changed-files">
                        <li>{.}</li>
                      </xsl:for-each>
                    </ul>
                  </details>

                  <ul class="spec-list">
                    <xsl:for-each select="map:keys($specifications)">
                      <xsl:sort select="."/>
                      <xsl:variable name="key" select="."/>
                      <xsl:variable name="spec" select="map:get($specifications, .)"/>

                      <xsl:variable name="files"
                                    select="$html-list[@number = $issue?number and @spec = $spec?dir]"/>

                      <xsl:variable name="matches" as="xs:string*">
                        <xsl:for-each select="distinct-values($files/@spec)">
                          <xsl:variable name="dir" select="."/>
                          <xsl:for-each select="$changed-files">
                            <xsl:if test="contains(., '/'||$dir||'/')">yes</xsl:if>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:variable>

                      <li>
                        <xsl:if test="count($matches) gt 0">
                          <xsl:attribute name="class" select="'likely-changed'"/>
                        </xsl:if>
                        <a href="https://qt4cg.org/pr/{$issue?number}/{$spec?dir}/{$spec?html}">
                          <xsl:sequence select="$spec?title"/>
                        </a>

                        <xsl:variable name="autodiff"
                                      select="$html-list[@number = $issue?number
                                                         and @spec = $spec?dir
                                                         and (@html = 'autodiff.html'
                                                              or @html = $key || '-autodiff.html')]"/>
                        <xsl:if test="$autodiff">
                          <span class="diffs">
                            <xsl:text> (</xsl:text>
                            <a href="https://qt4cg.org/pr/{$issue?number}/{$spec?dir}/{$autodiff/@html}">
                              <xsl:text>DeltaXML diff</xsl:text>
                            </a>
                            <xsl:text>)</xsl:text>
                          </span>
                        </xsl:if>
                      </li>
<!--
                      <li><ul><xsl:for-each select="$files"><li>{serialize(.)}</li></xsl:for-each></ul></li>
-->
                    </xsl:for-each>
                  </ul>
                </div>
              </xsl:for-each>

<!--
            <xsl:for-each-group select="$html-list[not(@html = '')]" group-by="@number">
              <xsl:sort select="xs:integer(@number)" order="descending"/>


                <ul>
                  <xsl:for-each-group select="current-group()" group-by="@spec">
                    <xsl:sort select="@spec"/>
                    <li>{current-group()[1]/@number/string()}, {current-group()[1]/@spec/string()},
                    {current-group()/@html ! string(.)}</li>
                  </xsl:for-each-group>
                </ul>
              </div>
            </xsl:for-each-group>
-->
            </div>
          </section>
        </section>
      </main>
    </body>
  </html>
</xsl:template>

<xsl:template name="show-specs">
  <xsl:param name="html-list" as="element()*"/>

  <ul>
    <xsl:for-each
        select="$html-list[@html='Overview.html' or @html='xpath-40.html' or @html='xquery-40.html']">
      <xsl:sort select="@spec"/>
      <xsl:call-template name="show-spec">
        <xsl:with-param name="html-list" select="$html-list"/>
        <xsl:with-param name="spec" select="@spec"/>
        <xsl:with-param name="html" select="@html"/>
      </xsl:call-template>
    </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template name="show-spec">
  <xsl:param name="html-list" as="element()*"/>
  <xsl:param name="spec" as="xs:string"/>
  <xsl:param name="html" as="xs:string"/>
    
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$spec = 'xpath-datamodel-40'">XQuery and XPath Data Model 4.0</xsl:when>
      <xsl:when test="$spec = 'xpath-functions-40'">XPath and XQuery Functions and Operators 4.0</xsl:when>
      <xsl:when test="$html = 'xquery-40.html'">XQuery 4.0: An XML Query Language</xsl:when>
      <xsl:when test="$html = 'xpath-40.html'">XML Path Language (XPath) 4.0</xsl:when>
      <xsl:when test="$spec = 'xslt-40'">XSL Transformations (XSLT) Version 4.0</xsl:when>
      <xsl:when test="$spec = 'xslt-xquery-serialization-40'">XSLT and XQuery Serialization 4.0</xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="autodiff" as="element()?">
    <xsl:choose>
      <xsl:when test="$spec = 'xpath-datamodel-40'
                      or $spec = 'xpath-functions-40'
                      or $spec = 'xslt-40'
                      or $spec = 'xslt-xquery-serialization-40'">
        <xsl:sequence select="$html-list[@spec = $spec and @html = 'autodiff.html']"/>
      </xsl:when>
      <xsl:when test="$html = 'xquery-40.html'">
        <xsl:sequence select="$html-list[@spec = $spec and @html = 'xpath-40-autodiff.html']"/>
      </xsl:when>
      <xsl:when test="$html = 'xpath-40.html'">
        <xsl:sequence select="$html-list[@spec = $spec and @html = 'xpath-40-autodiff.html']"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="line" select="$html-list[@spec = $spec and @html = $html]"/>
  <li>
    <a href="https://qt4cg.org/pr/{$line/@number}/{$line/@spec}/{$line/@html}">{$title}</a>
    <xsl:if test="$autodiff">
      <span class="diffs">
        <xsl:text> (</xsl:text>
        <a href="https://qt4cg.org/pr/{$line/@number}/{$line/@spec}/{$autodiff/@html}">
          <xsl:text>DeltaXML diff</xsl:text>
        </a>
        <xsl:text>)</xsl:text>
      </span>
    </xsl:if>
  </li>


</xsl:template>

</xsl:stylesheet>
