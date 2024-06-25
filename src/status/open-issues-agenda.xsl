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

<xsl:output method="text" encoding="utf-8"/>

<xsl:param name="issues.json" select="'qtspecs-issues.json'"/>

<xsl:variable name="issue-list" select="array:flatten(parse-json(unparsed-text($issues.json)))"/>
<xsl:variable name="issues" as="map(xs:integer, map(*))">
  <xsl:map>
    <xsl:for-each select="$issue-list">
      <xsl:map-entry key="xs:integer(.?number)" select="."/>
    </xsl:for-each>
  </xsl:map>
</xsl:variable>

<xsl:template name="xsl:initial-template">
  <xsl:variable name="propose-close" as="xs:integer*">
    <xsl:for-each select="$issue-list">
      <xsl:variable name="issue" select="."/>
      <xsl:variable name="pr" select="map:contains($issue, 'pull_request')"/>

      <xsl:if test="not($pr) and $issue?state='open'
                    and f:has-label($issue, 'Propose Closing with No Action')">
        <xsl:sequence select="xs:integer($issue?number)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="propose-merge" as="xs:integer*">
    <xsl:for-each select="$issue-list">
      <xsl:variable name="issue" select="."/>
      <xsl:variable name="pr" select="map:contains($issue, 'pull_request')"/>

      <xsl:if test="$pr and $issue?state='open'
                    and f:has-label($issue, 'Propose Merge without Discussion')">
        <xsl:sequence select="xs:integer($issue?number)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="blocked" as="xs:integer*">
    <xsl:for-each select="$issue-list">
      <xsl:variable name="issue" select="."/>
      <xsl:variable name="pr" select="map:contains($issue, 'pull_request')"/>

      <xsl:if test="$pr and $issue?state='open'
                    and (f:has-label($issue, 'Blocked')
                         or f:has-label($issue, 'Revise'))">
        <xsl:sequence select="xs:integer($issue?number)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="xslt" as="xs:integer*">
    <xsl:for-each select="$issue-list">
      <xsl:variable name="issue" select="."/>

      <xsl:if test="$issue?state='open' and f:has-label($issue, 'XSLT')
                    and not(f:has-label($issue, 'XQuery') or f:has-label($issue, 'XPath'))">
        <xsl:sequence select="xs:integer($issue?number)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="prg-required" as="xs:integer*">
    <xsl:for-each select="$issue-list">
      <xsl:variable name="issue" select="."/>

      <xsl:if test="$issue?state='open'
                    and f:has-label($issue, 'PRG-required')">
        <xsl:sequence select="xs:integer($issue?number)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="requires-confirmation" as="xs:integer*">
    <xsl:for-each select="$issue-list">
      <xsl:variable name="issue" select="."/>

      <xsl:if test="$issue?state='open'
                    and f:has-label($issue, 'Requires confirmation')
                    and not(f:has-label($issue, 'XSLT'))">
        <xsl:sequence select="xs:integer($issue?number)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="special" as="xs:integer*"
                select="distinct-values(($requires-confirmation, $propose-close, $propose-merge,
                                         $blocked, $xslt))"/>

  <xsl:variable name="substantive" as="xs:integer*">
    <xsl:variable name="full-list" as="xs:integer*">
      <xsl:for-each select="$issue-list">
        <xsl:variable name="issue" select="."/>
        <xsl:variable name="pr" select="map:contains($issue, 'pull_request')"/>

        <xsl:if test="$pr and $issue?state='open'">
          <xsl:sequence select="xs:integer($issue?number)"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="$full-list[not(. = $special)]"/>
  </xsl:variable>

  <xsl:text>** Review of open pull requests and issues&#10;</xsl:text>
  <xsl:text>:PROPERTIES:&#10;</xsl:text>
  <xsl:text>:CUSTOM_ID: open-pull-requests&#10;</xsl:text>
  <xsl:text>:END:&#10;&#10;</xsl:text>

  <xsl:if test="exists($blocked)">
    <xsl:text>*** Blocked&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: blocked&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>
    <xsl:text>The following PRs are open but have merge conflicts or comments which&#10;</xsl:text>
    <xsl:text>suggest they aren’t ready for action.&#10;&#10;</xsl:text>
    <xsl:sequence select="f:pr-list($blocked)"/>
  </xsl:if>

  <xsl:if test="exists($propose-merge)">
    <xsl:text>*** Merge without discussion&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: merge-without-discussion&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>
    <xsl:text>The following PRs are editorial, small, or otherwise appeared to be&#10;</xsl:text>
    <xsl:text>uncontroversial when the agenda was prepared. The chairs propose that&#10;</xsl:text>
    <xsl:text>these can be merged without discussion. If you think discussion is&#10;</xsl:text>
    <xsl:text>necessary, please say so.&#10;&#10;</xsl:text>
    <xsl:sequence select="f:pr-list($propose-merge)"/>
  </xsl:if>

  <xsl:if test="exists($propose-close)">
    <xsl:text>*** Close without action&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: close-without-action&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>
    <xsl:text>It has been proposed that the following issues be closed without action.&#10;</xsl:text>
    <xsl:text>If you think discussion is necessary, please say so.&#10;&#10;</xsl:text>
    <xsl:sequence select="f:issue-list($propose-close)"/>
  </xsl:if>

  <xsl:if test="exists($xslt)">
    <xsl:text>*** XSLT focused&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: xslt-focused&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>

    <xsl:variable name="prs" select="$xslt[map:contains(map:get($issues,.), 'pull_request')]"/>
    <xsl:variable name="iss" select="$xslt[not(. = $prs)
                                     and f:has-label(map:get($issues,.), 'Requires confirmation')]"/>
    <xsl:variable name="v40" select="$xslt[not(. = $prs)
                                     and f:has-label(map:get($issues,.), 'Propose for V4.0')]"/>

    <xsl:if test="exists($prs)">
      <xsl:text>The following PRs appear to be candidates for a future XSLT-focused&#10;</xsl:text>
      <xsl:text>meeting.&#10;&#10;</xsl:text>
      <xsl:sequence select="f:pr-list($prs)"/>
    </xsl:if>

    <xsl:if test="exists($iss)">
      <xsl:text>These issues identify the XSLT-focused changes that have been made to&#10;</xsl:text>
      <xsl:text>the specifications but which have not been established by the&#10;</xsl:text>
      <xsl:text>community group as the status quo.&#10;&#10;</xsl:text>
      <xsl:sequence select="f:issue-list($iss)"/>
    </xsl:if>

    <xsl:if test="exists($v40)">
      <xsl:text>The following XSLT issues are labeled “proposed for V4.0”.&#10;&#10;</xsl:text>
      <xsl:sequence select="f:issue-list($v40)"/>
    </xsl:if>
  </xsl:if>

  <xsl:if test="exists($substantive)">
    <xsl:text>*** Substantive PRs&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: substantive&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>
    <xsl:text>The following substantive PRs were open when this agenda was prepared.&#10;&#10;</xsl:text>
    <xsl:sequence select="f:pr-list($substantive)"/>
  </xsl:if>

  <xsl:if test="exists($requires-confirmation)">
    <xsl:text>*** Requires confirmation&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: requires-confirmation&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>
    <xsl:text>The following issues are labeled “requires confirmation”.&#10;&#10;</xsl:text>
    <xsl:sequence select="f:issue-list($requires-confirmation)"/>
  </xsl:if>

  <xsl:if test="exists($prg-required)">
    <xsl:text>*** Required for V4.0&#10;</xsl:text>
    <xsl:text>:PROPERTIES:&#10;</xsl:text>
    <xsl:text>:CUSTOM_ID: required-40&#10;</xsl:text>
    <xsl:text>:END:&#10;&#10;</xsl:text>
    <xsl:text>The following issues are labeled “required for V4.0”.&#10;&#10;</xsl:text>
    <xsl:sequence select="f:issue-list($prg-required)"/>
  </xsl:if>
</xsl:template>

<xsl:function name="f:has-label" as="xs:boolean">
  <xsl:param name="issue" as="map(*)"/>
  <xsl:param name="label" as="xs:string"/>

  <xsl:variable name="labels" as="xs:string*">
    <xsl:if test="map:contains($issue, 'labels')">
      <xsl:for-each select="array:flatten($issue?labels)">
        <xsl:sequence select=".?name"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:sequence select="$label = $labels"/>
</xsl:function>

<xsl:function name="f:pr-list">
  <xsl:param name="list" as="xs:integer+"/>

  <xsl:for-each select="$list">
    <xsl:text>+ PR [[https://qt4cg.org/dashboard/#pr-{.}][#{.}]]: </xsl:text>
    <xsl:sequence select="map:get($issues, .)?title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:function>

<xsl:function name="f:issue-list">
  <xsl:param name="list" as="xs:integer+"/>

  <xsl:for-each select="$list">
    <xsl:text>+ Issue [[https://github.com/qt4cg/qtspecs/issues/{.}][#{.}]]: </xsl:text>
    <xsl:sequence select="map:get($issues, .)?title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:function>

</xsl:stylesheet>
