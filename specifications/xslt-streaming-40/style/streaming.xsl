<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0"
                expand-text="yes">
  <xsl:import href="../../../style/xsl-query-2016.xsl"/>

  <xsl:param name="additional.css" select="'xslt-xquery-serialization-40.css'"/>
  
  <xsl:template match="elcode">
    <a href="../../xslt-40/Overview.html#{.}">{.}</a>
  </xsl:template>
  
<!-- ==================================================================== -->

<!-- Handling of errors is closely based on xslt.xsl -->
  
  <xsl:template match="processing-instruction('error-summary')">
    <xsl:if test="exists(//error[@type='static'][not(ancestor::*[@diff='del'])])">
      <p><b>Static errors</b></p>
      <dl>
        <xsl:apply-templates select="//error[@type='static'][not(ancestor::*[@diff='del'])]" mode="summary">
          <xsl:sort select="@code"/>
        </xsl:apply-templates>
      </dl>
    </xsl:if>
    
      <xsl:if test="exists(//error[@type='type'][not(ancestor::*[@diff='del'])])">
        <p><b>Type errors</b></p>
        <dl>
          <xsl:apply-templates select="//error[@type='type'][not(ancestor::*[@diff='del'])]" mode="summary">
            <xsl:sort select="@code"/>
          </xsl:apply-templates>
        </dl>
      </xsl:if>
    
      <xsl:if test="exists(//error[@type='dynamic'][not(ancestor::*[@diff='del'])])">
        <p><b>Dynamic errors</b></p>
        <dl>
        <xsl:apply-templates select="//error[@type='dynamic'][not(ancestor::*[@diff='del'])]" mode="summary">
          <xsl:sort select="@code"/>
        </xsl:apply-templates>
        </dl>
      </xsl:if>
      
      <xsl:if test="//error[@type='serialization'][not(ancestor::*[@diff='del'])]">
        <p><b>Serialization errors</b></p>
        <dl>
        <xsl:apply-templates select="//error[@type='serialization'][not(ancestor::*[@diff='del'])]" mode="summary">
          <xsl:sort select="@code"/>
        </xsl:apply-templates>
        </dl>
      </xsl:if>
      
      <xsl:if test="//error[not(@type)]">
        <p><b>Unclassified errors</b></p>
        <dl>
        <xsl:apply-templates select="//error[not(@type)]" mode="summary">
          <xsl:sort select="@code"/>
        </xsl:apply-templates>
        </dl>
      </xsl:if>
</xsl:template>

<xsl:template match="error">
  <!-- uri is specified only for xerrorref; make no ID -->
  <xsl:param name="uri" select="''"/>
  <xsl:variable name="spec" select="replace(@spec, '30', '')"/>
  <xsl:variable name="spec" select="replace($spec, '31', '')"/>
  <xsl:variable name="label" select="concat($spec, @class, @code)"/>

  <xsl:choose>
    <xsl:when test="$uri = ''">
      <a id="err-{$label}">
	     <span class="error">[ERR <xsl:value-of select="$label"/>] </span>
      </a>
      <xsl:apply-templates select="p/child::node()"/>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$uri}#ERR{$spec}{@class}{@code}" title="{$label}">
	     <span class="error">[ERR <xsl:value-of select="$label"/>] </span>
      </a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="error.action">
<xsl:param name="omode" select="'body'"/>
<xsl:if test="$omode='body'">
<xsl:apply-templates/>
</xsl:if>
</xsl:template>

<xsl:template match="error" mode="summary">
  <xsl:variable name="label" select="concat(@spec, @class, @code)"/>
<dt><a href="#err-{$label}"><span class="error">ERR <xsl:value-of select="$label"/></span></a></dt>
<dd><p><xsl:apply-templates select="p/node()">
    <xsl:with-param name="omode" select="'summary'"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="p/error.action" mode="action"/></p></dd>
</xsl:template>

<xsl:template match="error.action" mode="action">
<br/><i>&#xa0;&#xa0;&#xa0;&#xa0;Action: </i><xsl:apply-templates/>
</xsl:template>

<xsl:template match="error.extra">
<xsl:param name="omode" select="'body'"/>
<xsl:if test="$omode='summary'">
<xsl:text/> [<xsl:apply-templates/>] <xsl:text/>
</xsl:if>
</xsl:template>

<xsl:template match="errorref[not(@spec) or @spec='XT']">
  <span class="error">
      <xsl:text>[see </xsl:text>
      <a href="#err-XT{@class}{@code}">ERR XT<xsl:value-of select="concat(@class, @code)"/></a>
      <xsl:text>]</xsl:text>
  </span>
</xsl:template>
  
<!-- ==================================================================== -->
  
  <!-- Generate the table of built-in functions and their streamability -->
  
  <xsl:template match="/">
    <xsl:variable name="expanded">
      <xsl:apply-templates select="." mode="preprocess"/>
    </xsl:variable>
    <xsl:apply-templates select="$expanded/*"/>
  </xsl:template>
  
  <xsl:mode name="preprocess" on-no-match="shallow-copy"/>
  
  <xsl:template match="processing-instruction('built-in-function-streamability')" mode="preprocess">
      <xsl:copy-of select="transform( map{
          'stylesheet-location': 'function-streamability.xsl',
          'initial-template': QName('http://www.w3.org/1999/XSL/Transform', 'initial-template')       
        })?output"/>
  </xsl:template>


<!-- ==================================================================== -->

<!-- changed templates to auto generate an appendix with a list
     of links to open issues. -->
<xsl:template name="autogenerated-appendices-toc"/>

<xsl:template name="autogenerated-appendices"/>

  <xsl:template match="processing-instruction('schema-for-params')">
    <pre>
      <xsl:sequence
         select="unparsed-text('../src/schema-for-serialization-parameters.xsd')"/>
    </pre>
  </xsl:template>

</xsl:stylesheet>
