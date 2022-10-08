<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="html:head/html:script">
  <!-- replace script with a new bit of styling -->
  <link rel="stylesheet" href="/css/autodiff.css"/>
</xsl:template>

<xsl:template match="html:body">
  <copy>
    <xsl:apply-templates select="@*, node()"/>
    <script src="/js/scroll.js"/>
  </copy>
</xsl:template>

<xsl:template match="html:body/html:div[contains(@style, 'position:fixed')]">
  <div style="position:fixed; clear:both; top:0px">
    <p>
      <a class="button" onclick="view('old')">
        View Old
      </a>
      <a class="button" onclick="view('new')">
        View New
      </a>
      <a class="button" onclick="view('both')">
        View Both
      </a>
      <a class="button" onclick="scroll_to('prev')">
        Previous
      </a>
      <a class="button" onclick="scroll_to('next')">
        Next
      </a>
      <span class="autoshow" id="__autodiff__"></span>
    </p>
  </div>
</xsl:template>

</xsl:stylesheet>
