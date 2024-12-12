<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://www.w3.org/qtspecs/build/functions"
  exclude-result-prefixes="my xs"
  version="2.0"
>
  
  <!-- Modified version of xsl-query.xsl produced November 2016 to produce HTML5 -->

  <xsl:import href="xmlspec-2016.xsl"/>

  <xsl:param name="show-markup" select="'0'"/>
  <xsl:variable name="show.diff.markup" as="xs:integer"
                select="$show-markup cast as xs:integer"/>
  <xsl:param name="called.by.diffspec" select="0" as="xs:integer"/>
  <!-- Taken from F&O 3.0 and Serialization 3.0 -->
  <xsl:param name="diff.baseline" select="''" as="xs:string"/>
  <xsl:param name="diff.baseline.date" select="()" as="xs:string?"/>
  <xsl:param name="diff.baseline.description" select="'a previous version'"/>
  <xsl:param name="additional.css"/>
  <xsl:param name="additional.css.2"/>

  <xsl:param name="chg-color" select="'#ffff99'"/>
  <xsl:param name="add-color" select="'#99ff99'"/>
  <xsl:param name="del-color" select="'#ff9999'"/>
  <xsl:param name="off-color" select="'#ffffff'"/>

  <xsl:param name="additional.css.diff">
    <xsl:if test="xs:integer($show.diff.markup) != 0">
      <xsl:sequence select="'showdiff.css'"/>
    </xsl:if>
  </xsl:param>

  <xsl:param name="additional.title">
    <xsl:if test="$show.diff.markup != 0">
      <xsl:text>Review Version</xsl:text>
    </xsl:if>
  </xsl:param>

  <!-- Should we be pedantic about things? Ideally, turn this on
       and fix the warnings reported before final publication. -->
  <xsl:param name="pedantic" select="'false'"/>

  <xsl:output method="xml" indent="no" encoding="utf-8" version="1.0"/>

  <xsl:key name="error" match="error" use="concat(@class,@code)"/>
  <xsl:key name="bibrefs" match="bibref" use="@ref"/>


  <xsl:param name="specdoc" select="'XX'"/>

  <xsl:variable name="default.specdoc">
    <xsl:choose>
      <xsl:when test="$specdoc != 'XX'">
        <xsl:value-of select="$specdoc"/>
        <xsl:message>specdoc is <xsl:value-of select="$specdoc"/> (override)</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Data Model') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'DM'"/>
        <xsl:message>specdoc is DM</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Functions and Operators') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'FO'"/>
        <xsl:message>specdoc is FO</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XPath') and
                      contains(/spec/header/title, '2.0')">
        <xsl:value-of select="'XP'"/>
        <xsl:message>specdoc is XP</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XML Query Language') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'XQ'"/>
        <xsl:message>specdoc is XQ</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Formal Semantics') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'FS'"/>
        <xsl:message>specdoc is FS</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XQueryX') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'XQX'"/>
        <xsl:message>specdoc is XQX</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Serialization') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'SER'"/>
        <xsl:message>specdoc is SER</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XML Query') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'XQR'"/>
        <xsl:message>specdoc is XQR</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XML Query') and
                      contains(/spec/header/title, 'Use Cases')">
        <xsl:value-of select="'XQUC'"/>
        <xsl:message>specdoc is XQUC</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Data Model') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'DM11'"/>
        <xsl:message>specdoc is DM11</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Functions and Operators') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'FO11'"/>
        <xsl:message>specdoc is FO11</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XPath') and
                      contains(/spec/header/title, '2.1')">
        <xsl:value-of select="'XP21'"/>
        <xsl:message>specdoc is XP21</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XQuery') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'XQ11'"/>
        <xsl:message>specdoc is XQ11</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Formal Semantics') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'FS11'"/>
        <xsl:message>specdoc is FS11</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XQueryX') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'XQX11'"/>
        <xsl:message>specdoc is XQX11</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Serialization') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'SER11'"/>
        <xsl:message>specdoc is SER11</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Data Model') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'DM30'"/>
        <xsl:message>specdoc is DM30</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Functions and Operators') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'FO30'"/>
        <xsl:message>specdoc is FO30</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XPath') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XP30'"/>
        <xsl:message>specdoc is XP30</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XQuery') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQ30'"/>
        <xsl:message>specdoc is XQ30</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XQueryX') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQX30'"/>
        <xsl:message>specdoc is XQX30</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Serialization') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'SER30'"/>
        <xsl:message>specdoc is SER30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XML Query') and
                      contains(/spec/header/title, 'Requirements') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'XQR11'"/>
        <xsl:message>specdoc is XQR11</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XQuery') and
                      contains(/spec/header/title, 'Use Cases') and
                      contains(/spec/header/title, '1.1')">
        <xsl:value-of select="'XQUC11'"/>
        <xsl:message>specdoc is XQUC11</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Full Text') and
                      contains(/spec/header/title, '1.0') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'FTR'"/>
        <xsl:message>specdoc is FTR</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Full Text') and
                      contains(/spec/header/title, '1.0') and
                      contains(/spec/header/title, 'Use Cases')">
        <xsl:value-of select="'FTUC'"/>
        <xsl:message>specdoc is FTUC</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Full Text') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'FT'"/>
        <xsl:message>specdoc is FT</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Update Facility') and
                      contains(/spec/header/title, '1.0') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'XQUR'"/>
        <xsl:message>specdoc is XQUR</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Update Facility') and
                      contains(/spec/header/title, '1.0') and
                      contains(/spec/header/title, 'Use Cases')">
        <xsl:value-of select="'XQUU'"/>
        <xsl:message>specdoc is XQUU</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Update Facility') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'XQU'"/>
        <xsl:message>specdoc is XQU</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Scripting Extension') and
                      contains(/spec/header/title, '1.0') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'SXR'"/>
        <xsl:message>specdoc is SXR</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Scripting Extension') and
                      contains(/spec/header/title, '1.0') and
                      contains(/spec/header/title, 'Use Cases')">
        <xsl:value-of select="'SXU'"/>
        <xsl:message>specdoc is SXU</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Scripting Extension') and
                      contains(/spec/header/title, '1.0')">
        <xsl:value-of select="'SX'"/>
        <xsl:message>specdoc is SX</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XSLT') and
                      contains(/spec/header/title, '2.0')">
        <xsl:value-of select="'XSLT'"/>
        <xsl:message>specdoc is XSLT</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Data Model') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'DM30'"/>
        <xsl:message>specdoc is DM30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Functions and Operators') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'FO30'"/>
        <xsl:message>specdoc is FO30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XPath') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XP30'"/>
        <xsl:message>specdoc is XP30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XQuery') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQ30'"/>
        <xsl:message>specdoc is XQ30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Formal Semantics') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'FS30'"/>
        <xsl:message>specdoc is FS30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XQueryX') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQX30'"/>
        <xsl:message>specdoc is XQX30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Serialization') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'SER30'"/>
        <xsl:message>specdoc is SER30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XML Query') and
                      contains(/spec/header/title, 'Requirements') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQR30'"/>
        <xsl:message>specdoc is XQR30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XQuery') and
                      contains(/spec/header/title, 'Use Cases') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQUC30'"/>
        <xsl:message>specdoc is XQUC30</xsl:message>
      </xsl:when>


      <xsl:when test="contains(/spec/header/title, 'Data Model') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'DM31'"/>
        <xsl:message>specdoc is DM31</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Functions and Operators') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'FO31'"/>
        <xsl:message>specdoc is FO31</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XPath') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'XP31'"/>
        <xsl:message>specdoc is XP31</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XQuery') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'XQ31'"/>
        <xsl:message>specdoc is XQ31</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XQueryX') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'XQX31'"/>
        <xsl:message>specdoc is XQX31</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Serialization') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'SER31'"/>
        <xsl:message>specdoc is SER31</xsl:message>
      </xsl:when>
      
      <xsl:when test="contains(/spec/header/title, 'Data Model') and
        contains(/spec/header/title, '4.0')">
        <xsl:value-of select="'DM40'"/>
        <xsl:message>specdoc is DM40</xsl:message>
      </xsl:when>
      
      <xsl:when test="contains(/spec/header/title, 'Functions and Operators') and
        contains(/spec/header/title, '4.0')">
        <xsl:value-of select="'FO40'"/>
        <xsl:message>specdoc is FO40</xsl:message>
      </xsl:when>
      
      <xsl:when test="contains(/spec/header/title, 'XPath') and
        contains(/spec/header/title, '4.0')">
        <xsl:value-of select="'XP40'"/>
        <xsl:message>specdoc is XP40</xsl:message>
      </xsl:when>
      
      <xsl:when test="contains(/spec/header/title, 'XQuery') and
        contains(/spec/header/title, '4.0')">
        <xsl:value-of select="'XQ40'"/>
        <xsl:message>specdoc is XQ40</xsl:message>
      </xsl:when>
      
      <xsl:when test="contains(/spec/header/title, 'XQueryX') and
        contains(/spec/header/title, '4.0')">
        <xsl:value-of select="'XQX40'"/>
        <xsl:message>specdoc is XQX40</xsl:message>
      </xsl:when>
      
      <xsl:when test="contains(/spec/header/title, 'Serialization') and
        contains(/spec/header/title, '4.0')">
        <xsl:value-of select="'SER40'"/>
        <xsl:message>specdoc is SER40</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'XML Query') and
                      contains(/spec/header/title, 'Requirements') and
                      contains(/spec/header/title, '3.1')">
        <xsl:value-of select="'XQRUC31'"/>
        <xsl:message>specdoc is XQRUC31</xsl:message>
      </xsl:when>


      <xsl:when test="contains(/spec/header/title, 'Full Text') and
                      contains(/spec/header/title, '3.0') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'FT30RU'"/>
        <xsl:message>specdoc is FT30RU</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Full Text') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'FT30'"/>
        <xsl:message>specdoc is FT30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Update Facility') and
                      contains(/spec/header/title, '3.0') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'XQU30RU'"/>
        <xsl:message>specdoc is XQU30RU</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Update Facility') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XQU30'"/>
        <xsl:message>specdoc is XQU30</xsl:message>
      </xsl:when>

      <xsl:when test="contains(/spec/header/title, 'Scripting Extension') and
                      contains(/spec/header/title, '3.0') and
                      contains(/spec/header/title, 'Requirements')">
        <xsl:value-of select="'SX30RU'"/>
        <xsl:message>specdoc is SX30RU</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'Scripting Extension') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'SX30'"/>
        <xsl:message>specdoc is SX30</xsl:message>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, 'XSLT') and
                      contains(/spec/header/title, '3.0')">
        <xsl:value-of select="'XSLT30'"/>
        <xsl:message>specdoc is XSLT30</xsl:message>
      </xsl:when>

        <xsl:otherwise>
        <xsl:message>Title: <xsl:value-of select="/spec/header/title"/></xsl:message>
        <xsl:message terminate="yes">
          <xsl:text>xsl-query.xsl says: Failed to determine which specdoc this is: use specdoc parameter!</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ====================================================================== -->

  <!-- Generate a comment that identifies as much as we can about the XSLT processor being used -->
  <xsl:template match="/">
    <xsl:variable name="XSLTprocessor">
      <xsl:text>{xsl-query} </xsl:text>
      <xsl:text>XSLT Processor: </xsl:text>
      <xsl:value-of select="system-property('xsl:vendor')"/>
      <xsl:if test="system-property('xsl:version') = '2.0'">
        <xsl:text> </xsl:text>
        <xsl:value-of select="system-property('xsl:product-name')"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:if>
    </xsl:variable>
    <!--
    <xsl:message>
      <xsl:value-of select="$XSLTprocessor"/>
    </xsl:message>
    -->
    <xsl:comment>
      <xsl:value-of select="$XSLTprocessor"/>
    </xsl:comment>
<!--
<xsl:comment>$show.diff.markup = <xsl:value-of select="$show.diff.markup"/></xsl:comment>
<xsl:message>$show.diff.markup = <xsl:value-of select="$show.diff.markup"/></xsl:message>
-->
    <xsl:apply-imports/>
  </xsl:template>

  <xsl:template match="br">
    <br/>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Automatic glossaries -->

  <xsl:template match="processing-instruction('glossary')">
    <dl>
      <xsl:for-each select="//termdef[not(ancestor-or-self::*[@diff][1][@diff='del'])]">
        <xsl:sort select="@term" data-type="text" order="ascending" lang="en"/>
        <dt>
          <a href="#{@id}"><xsl:value-of select="@term"/></a>
        </dt>
        <dd>
          <p>
            <xsl:apply-templates/>
          </p>
          <xsl:if test="@open='true'">
            <xsl:variable name="close" select="../following-sibling::p[@role='closetermdef'][1]"/>
            <xsl:apply-templates select="../following-sibling::*[$close >> .]"/>
          </xsl:if>
        </dd>
      </xsl:for-each>
    </dl>
  </xsl:template>

  <!--<xsl:template match="termdef" mode="glossary-list">
    <xsl:variable name="diff_governor" select="ancestor-or-self::*[@diff][1]"/>
    <xsl:variable name="diff_effect" select="my:diff-markup-effect($diff_governor)"/>
    <xsl:choose>
      <xsl:when test="$diff_effect eq 'delete'">
      </xsl:when>

      <xsl:when test="$diff_effect eq 'normal'">
        <dt>
          <a id="GL{@id}"/>
          <xsl:value-of select="@term"/>
        </dt>
        <dd>
          <p>
            <xsl:apply-templates/>
          </p>
          <xsl:if test="@open='true'">
            <xsl:variable name="close" select="../following-sibling::p[@role='closetermdef'][1]"/>
            <xsl:apply-templates select="../following-sibling::*[$close >> .]"/>
          </xsl:if>
        </dd>
      </xsl:when>

      <xsl:when test="$diff_effect eq 'highlight'">
        <dt class="diff-{$diff_governor/@diff}">
          <a id="GL{@id}"/>
          <xsl:value-of select="@term"/>
        </dt>
        <dd class="diff-{$diff_governor/@diff}">
          <p>
            <xsl:apply-templates/>
          </p>
          <xsl:apply-templates select="$diff_governor/@at">
            <xsl:with-param name="put-in-p" select="true()"/>
          </xsl:apply-templates>
        </dd>
      </xsl:when>

    </xsl:choose>
  </xsl:template>-->

  <!-- ====================================================================== -->
  <!-- Automatic lists of impl def/dep features -->

  <xsl:template match="processing-instruction('imp-def-feature')">
    <ol>
      <xsl:apply-templates select="//imp-def-feature" mode="imp-def"/>
    </ol>
  </xsl:template>

  <xsl:template match="processing-instruction('imp-dep-feature')">
    <ol>
      <xsl:apply-templates select="//imp-dep-feature" mode="imp-def"/>
    </ol>
  </xsl:template>

  <xsl:template match="imp-def-feature|imp-dep-feature" mode="imp-def">
    <xsl:variable name="div" select="(ancestor::div1|ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5)[last()]"/>
    <li>
      <xsl:apply-templates/>
      <xsl:text> (See </xsl:text>
      <xsl:apply-templates select="$div" mode="specref"/>
      <xsl:text>)</xsl:text>
    </li>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Error Markup -->

  <xsl:template match="error" name="make-error-ref">
    <xsl:param name="uri" select="''"/>

    <xsl:variable name="spec">
      <xsl:choose>
        <xsl:when test="@spec">
          <xsl:value-of select="replace(@spec, '3[0|1]', '')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($default.specdoc,1,2)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="@class">
          <xsl:value-of select="@class"/>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="code">
      <xsl:choose>
        <xsl:when test="@code">
          <xsl:value-of select="@code"/>
        </xsl:when>
        <xsl:otherwise>??</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="@type">
          <xsl:value-of select="@type"/>
        </xsl:when>
        <xsl:otherwise>??</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="label">
      <!-- CREATES LABEL IN XQUERY STYLE -->
      <xsl:text>err:</xsl:text>
      <xsl:value-of select="$spec"/>
      <xsl:value-of select="$class"/>
      <xsl:value-of select="$code"/>
    </xsl:variable>

    <xsl:text>[</xsl:text>

    <a href="{$uri}#ERR{$spec}{$class}{$code}" title="{$label}">
      <!-- ??? 
    <xsl:if test="@label and $spec != $default.specdoc">
      <xsl:text>Error: </xsl:text>
      <xsl:value-of select="$spec"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    -->
      <xsl:value-of select="$label"/>
    </a>

    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="errorref">
    <xsl:variable name="error" select="key('error', concat(@class,@code))"/>

    <xsl:choose>
      <xsl:when test="$error">
        <xsl:apply-templates select="$error[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Error: errorref </xsl:text>
          <xsl:value-of select="concat(@class,@code)"/>
          <xsl:text> not found.</xsl:text>
        </xsl:message>
        <span class="markup-error">
          <xsl:text>[ERROR errorref </xsl:text>
          <xsl:value-of select="concat(@class,@code)"/>
          <xsl:text> NOT FOUND]</xsl:text>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="error-list">
    <dl>
      <xsl:apply-templates mode="error-list"/>
    </dl>
  </xsl:template>

  <xsl:template match="processing-instruction('error-list')">
    <dl>
      <xsl:apply-templates select="//error" mode="error-list"/>
    </dl>
  </xsl:template>

  <xsl:template match="error" mode="error-list">
    <xsl:variable name="spec">
      <xsl:choose>
        <xsl:when test="@spec">
          <xsl:value-of select="@spec"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($default.specdoc,1,2)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
 <!--
    <xsl:message><xsl:value-of select="'@spec:', @spec, '$spec:', $spec"/></xsl:message>
-->

    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="@class">
          <xsl:value-of select="@class"/>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="code">
      <xsl:choose>
        <xsl:when test="@code">
          <xsl:value-of select="@code"/>
        </xsl:when>
        <xsl:otherwise>??</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="@type">
          <xsl:value-of select="@type"/>
        </xsl:when>
        <xsl:otherwise>??</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="label">
      <xsl:choose>
        <xsl:when test="@label">
          <xsl:value-of select="@label"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$spec"/>
          <xsl:value-of select="$class"/>
          <xsl:value-of select="$code"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <dt>
      <a id="ERR{$spec}{$class}{$code}"/>
      <xsl:text>err:</xsl:text>
      <xsl:value-of select="concat($spec, $class, $code)"/>
      <xsl:if test="@label">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="@label"/>
      </xsl:if>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Imp def/dep markup -->

  <xsl:template match="imp-def-feature"/>
  <xsl:template match="imp-dep-feature"/>

  <!-- ====================================================================== -->
  <!-- Cross-spec references -->

  <xsl:template match="xspecref">
    <xsl:variable name="ref" select="@ref"/>
    <xsl:variable name="doc" select="document(concat('../build/etc/', @spec, '.xml'))"/>
    <xsl:variable name="div" select="$doc//*[@id=$ref]"/>
    <xsl:variable name="nt" select="($doc//*[@def=$ref])[1]"/>
    <xsl:variable name="uri" select="replace($doc/document-summary/@uri, '^http:', 'https:')"/>
    <xsl:variable name="shortSpec" select="replace(@spec, '40$', '')"/>
    <xsl:choose>
      <xsl:when test="$div">
        <xsl:variable name="linktext">
          <xsl:choose>
            <xsl:when test="$div/self::prod">
              <xsl:value-of select="$div"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Section </xsl:text>
              <xsl:value-of select="$div/head"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$uri">
            <a href="{$uri}#{$ref}">
              <xsl:sequence select="$linktext"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$linktext"/>
          </xsl:otherwise>
        </xsl:choose>
        <sup>
          <small>
            <xsl:value-of select="$shortSpec"/>
          </small>
        </sup>
      </xsl:when>
      <xsl:when test="$nt">
        <xsl:choose>
          <xsl:when test="$uri">
            <a href="{$uri}#{$ref}">
              <xsl:value-of select="string($nt)"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string($nt)"/>
          </xsl:otherwise>
        </xsl:choose>
        <sup>
          <small>
            <xsl:value-of select="$shortSpec"/>
          </small>
        </sup>
      </xsl:when>
      <xsl:when test="node()">
        <xsl:choose>
          <xsl:when test="$uri">
            <a href="{$uri}#{$ref}">
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
        <sup>
          <small>
            <xsl:value-of select="$shortSpec"/>
          </small>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Error: cannot resolve </xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text> in </xsl:text>
          <xsl:value-of select="@spec"/>
          <xsl:text> at id=</xsl:text>
          <xsl:value-of select="(ancestor::*/@id)[last()]"/>
        </xsl:message>
        <span class='markup-error'>
          <xsl:text>[TITLE OF </xsl:text>
          <xsl:value-of select="@spec"/>
          <xsl:text> SPEC, TITLE OF </xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text> SECTION]</xsl:text>
          <xsl:apply-templates/>
          <sup>
            <small>
              <xsl:value-of select="@spec"/>
            </small>
          </sup>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xnt[not(@spec)]" priority="2">
    <!-- if there's no @spec, don't try to load a document ... -->
    <xsl:call-template name="process-xnt"/>
  </xsl:template>

  <xsl:template match="xnt">
    <xsl:variable name="ref" select="normalize-space(@ref)"/>
    <xsl:variable name="doc" select="document(concat('../build/etc/', @spec, '.xml'))"/>
    <!-- 2023-04-06, ndw changed extract.xsl to store the prod elements, not the nt elements
         in the /etc files. There can be many nt's but they are all supposed to point to a
         production. I don't know why the nt's were being put in the etc files instead of
         the productions. Note that we still have to look for nt's as well because old
         etc files (e.g., for XML 1.0) are still coded the old way. 

         There's also some variation in how xnt is coded. The @ref is supposed to be the
         ID value referenced, but sometimes it's just the name of the nonterminal. 
         Since we can work out the ID from the name, let's not fuss at the authors
         about that...
    -->
    <xsl:variable name="nt" select="($doc//prod[@id=$ref], $doc//prod[.=$ref], $doc//nt[@def=$ref])[1]"/>
    <xsl:variable name="uri" select="replace($doc/document-summary/@uri, '^http:', 'https:')"/>
    <xsl:variable name="shortSpec" select="replace(@spec, '40$', '')"/>
    <xsl:choose>
      <xsl:when test="contains(@spec, 'XP') and not($nt)">
        <!-- XP and XQ are a special case -->
        <xsl:variable name="ref2" select="concat('doc-xpath40-',@ref)"/>
        <xsl:variable name="nt2" select="$doc//nt[@def=$ref2]"/>
        <xsl:choose>
          <xsl:when test="$uri">
            <a href="{$uri}#{$ref2}">
              <xsl:call-template name="process-xnt">
                <xsl:with-param name="doc" select="$doc"/>
                <xsl:with-param name="nt" select="$nt2"/>
              </xsl:call-template>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="process-xnt">
              <xsl:with-param name="doc" select="$doc"/>
              <xsl:with-param name="nt" select="$nt2"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <sup>
          <small>
            <xsl:value-of select="$shortSpec"/>
          </small>
        </sup>
      </xsl:when>
      <xsl:when test="contains(@spec, 'XQ') and not($nt)">
        <!-- XP and XQ are a special case -->
        <xsl:variable name="ref2" select="concat('doc-xquery40-',@ref)"/>
        <xsl:variable name="nt2" select="$doc//nt[@def=$ref2]"/>

        <xsl:choose>
          <xsl:when test="$uri">
            <a href="{$uri}#{$ref2}">
              <xsl:call-template name="process-xnt">
                <xsl:with-param name="doc" select="$doc"/>
                <xsl:with-param name="nt" select="$nt2"/>
              </xsl:call-template>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="process-xnt">
              <xsl:with-param name="doc" select="$doc"/>
              <xsl:with-param name="nt" select="$nt2"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <sup>
          <small>
            <xsl:value-of select="$shortSpec"/>
          </small>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$uri">
            <a href="{$uri}#{$ref}">
              <xsl:call-template name="process-xnt">
                <xsl:with-param name="doc" select="$doc"/>
                <xsl:with-param name="nt" select="$nt"/>
              </xsl:call-template>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="process-xnt">
              <xsl:with-param name="doc" select="$doc"/>
              <xsl:with-param name="nt" select="$nt"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <sup>
          <small>
            <xsl:value-of select="$shortSpec"/>
          </small>
        </sup>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="process-xnt">
    <xsl:param name="doc"/>
    <xsl:param name="nt"/>

    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="not($nt)">
        <xsl:message>
          <xsl:text>Error: cannot resolve xnt </xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text> in </xsl:text>
          <xsl:value-of select="@spec"/>
          <xsl:text> at id=</xsl:text>
          <xsl:value-of select="(ancestor::*/@id)[last()]"/>
        </xsl:message>
        <span class="markup-error">
          <xsl:text>[NT </xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text> IN </xsl:text>
          <xsl:value-of select="@spec"/>
          <xsl:text>]</xsl:text>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="node()">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nt"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="termref">
    <a title="{key('ids', @def)/@term}" class="termref">
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @def)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test=". = ''">
          <xsl:value-of select="key('ids', @def)/@term"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="xtermref">
    <xsl:variable name="href" select="@href"/>
    <xsl:choose>
      <xsl:when test="$href">
        <xsl:apply-imports/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="ref" select="@ref"/>
        <xsl:variable name="doc" select="document(concat('../build/etc/', @spec, '.xml'))"/>
        <xsl:variable name="termdef" select="$doc//termdef[@id=$ref]"/>
        <xsl:variable name="uri" select="replace($doc/document-summary/@uri, '^http:', 'https:')"/>
        <xsl:variable name="shortSpec" select="replace(@spec, '40$', '')"/>

        <xsl:choose>
          <xsl:when test="not($termdef)">
            <xsl:message>
              <xsl:text>Error: cannot resolve xtermref </xsl:text>
              <xsl:value-of select="@ref"/>
              <xsl:text> in </xsl:text>
              <xsl:value-of select="@spec"/>
              <xsl:text> at id=</xsl:text>
              <xsl:value-of select="(ancestor::*/@id)[last()]"/>
            </xsl:message>
            <span class="markup-error">
              <xsl:text>[TERMDEF </xsl:text>
              <xsl:value-of select="@ref"/>
              <xsl:text> IN </xsl:text>
              <xsl:value-of select="@spec"/>
              <xsl:text>]</xsl:text>
              <xsl:apply-templates/>
            </span>
          </xsl:when>
          <xsl:when test="node()">
            <xsl:choose>
              <xsl:when test="$uri">
                <a href="{$uri}#{$ref}">
                  <xsl:apply-templates/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
            <sup>
              <small>
                <xsl:value-of select="$shortSpec"/>
              </small>
            </sup>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$uri">
                <a href="{$uri}#{$ref}">
                  <xsl:value-of select="$termdef/@term"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$termdef/@term"/>
              </xsl:otherwise>
            </xsl:choose>
            <sup>
              <small>
                <xsl:value-of select="$shortSpec"/>
              </small>
            </sup>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:variable name="implied_spec_version_for_xerrorref">
    <xsl:choose>
      <xsl:when test="contains(/spec/header/title, '3.1') or contains(/spec/header/version, '3.1')">
        <xsl:value-of select="'31'"/>
      </xsl:when>
      <xsl:when test="contains(/spec/header/title, '3.0') or contains(/spec/header/version, '3.0')">
        <xsl:value-of select="'30'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="xerrorref">
    <xsl:variable name="ref" select="@code"/>
    <xsl:variable name="class" select="@class"/>
    <xsl:variable name="spec" select="
      if (string-length(@spec) eq 2) then
        (: It would be better if we didn't have this special case,
           but unfortunately it's relied on rather widely now. :)
        concat(@spec, $implied_spec_version_for_xerrorref)
      else
        @spec
    "/>
    <xsl:variable name="doc" select="document(concat('../build/etc/', $spec, '.xml'))"/>
    <xsl:variable name="error" select="$doc//error[@code=$ref and @class=$class]"/>
    <xsl:variable name="uri" select="replace($doc/document-summary/@uri, '^http:', 'https:')"/>

    <!--
  <xsl:message>
    <xsl:text>xerrorref: </xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>; </xsl:text>
    <xsl:value-of select="$class"/>
    <xsl:text>; </xsl:text>
    <xsl:value-of select="@spec"/>
    <xsl:text>; </xsl:text>
    <xsl:value-of select="$error"/>
  </xsl:message>
  -->

    <xsl:choose>
      <xsl:when test="not($error)">
        <xsl:message>
          <xsl:text>Error: cannot resolve xerrorref </xsl:text>
          <xsl:value-of select="concat(@class,@code)"/>
          <xsl:text> at id=</xsl:text>
          <xsl:value-of select="(ancestor::*/@id)[last()]"/>
        </xsl:message>
        <span class="markup-error">
          <xsl:text>[ERROR </xsl:text>
          <xsl:value-of select="concat(@class,@code)"/>
          <xsl:text> IN </xsl:text>
          <xsl:value-of select="$spec"/>
          <xsl:text>]</xsl:text>
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test="node()">
        <xsl:apply-templates/>
        <sup>
          <small>
            <xsl:value-of select="$spec"/>
          </small>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$error">
          <xsl:with-param name="uri" select="$uri"/>
        </xsl:apply-templates>
        <sup>
          <small>
            <xsl:value-of select="$spec"/>
          </small>
        </sup>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- nt: production non-terminal -->
  <!-- make a link to the non-terminal's definition -->
  <xsl:template match="nt">
    <!-- Something has changed about how productions are linked
         in the xslt 4.0 spec. I'm not sure exactly what.
         This is a total hack. -->
    <xsl:variable name="prod-def" select="string(@def)"/>
    <xsl:variable name="doc-def"
                  select="if (starts-with($prod-def, 'prod-'))
                          then 'doc-' || substring($prod-def, 6)
                          else $prod-def"/>
    <xsl:variable name="target"
                  select="if (key('ids', $prod-def))
                          then key('ids', $prod-def)
                          else key('ids', $doc-def)"/>

    <xsl:if test="not($target)">
      <xsl:message>
        <xsl:text>Error: cannot resolve nt: </xsl:text>
        <xsl:value-of select="@def"/>
      </xsl:message>
      <span class="markup-error">
        <xsl:text>[ERROR: no </xsl:text>
        <xsl:value-of select="@def"/>
        <xsl:text>]</xsl:text>
      </span>
    </xsl:if>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="$target"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="child::node()">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="tokenize($prod-def, '-')[last()]"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>


  <!-- ====================================================================== -->

  <xsl:template match="bibl" name="bibl">
    <xsl:variable name="xsl-query" select="document('../build/etc/xsl-query-bibl.xml')"/>
    <xsl:variable name="tr" select="document('../build/etc/tr.xml')"/>
    <xsl:variable name="rfc" select="document('../build/etc/rfc.xml')"/>
    <xsl:variable name="id" select="@id"/>

    <xsl:if test="$pedantic != 'false' and count(key('bibrefs', @id)) = 0">
      <xsl:message>
        <xsl:text>Warning: no reference to bibliography entry "</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>"</xsl:text>
      </xsl:message>
    </xsl:if>

    <dt class="label">
      <span>
        <xsl:if test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@id">
          <a id="{@id}"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="@key">
            <xsl:value-of select="@key"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@id"/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </dt>
    <dd>
      <div>
        <xsl:if test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="not(node()) and $xsl-query//bibl[@id=$id]">
            <xsl:apply-templates select="$xsl-query//bibl[@id=$id]/node()"/>
          </xsl:when>
          <xsl:when test="not(node()) and $tr//bibl[@id=$id]">
            <!--* <xsl:apply-templates select="$tr//bibl[@id=$id]/node()"/> *-->
            <!--* <xsl:apply-templates select="$tr//bibl[@id=$id][not(preceding-sibling::bibl[@id=$id])]/node()"/> *-->
            <xsl:apply-templates select="($tr//bibl[@id=$id])[1]/node()"/>
          </xsl:when>
          <xsl:when test="not(node()) and $rfc//bibl[@id=$id]">
            <xsl:apply-templates select="$rfc//bibl[@id=$id]/node()"/>
          </xsl:when>
          <xsl:when test="not(node())">
            <xsl:message>Error: no <xsl:value-of select="$id"/> known!</xsl:message>
            <span class="markup-error">
              <xsl:text>ERROR: NO </xsl:text>
              <xsl:value-of select="$id"/>
              <xsl:text> KNOWN!</xsl:text>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </dd>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- Extracted out of xmlspec.xsl so that it can go back to being the base
     stylesheet! -->

  <xsl:template match="loc">
    <xsl:if test="starts-with(@href, '#')">
      <xsl:if test="@role and @role != 'force'">
        <xsl:if test="not(key('ids', substring-after(@href, '#')))">
          <xsl:message terminate="yes">
            <xsl:text>Internal loc href to </xsl:text>
            <xsl:value-of select="@href"/>
            <xsl:text>, but that ID does not exist in this document.</xsl:text>
          </xsl:message>
        </xsl:if>
      </xsl:if>
    </xsl:if>
    <!-- ==================================================================== -->
    <!-- JM/2014-09-06 - Added support for optional id attribute              -->
    <xsl:choose>
      <xsl:when test="@id">
        <a id="{@id}" href="{@href}">
          <xsl:if test="@rel">
            <xsl:attribute name="rel">
              <xsl:value-of select="@rel"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="count(child::node())=0">
              <xsl:value-of select="@href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@href}">
          <xsl:if test="@rel">
            <xsl:attribute name="rel">
              <xsl:value-of select="@rel"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="count(child::node())=0">
              <xsl:value-of select="@href"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="author/loc" priority="100">
    <xsl:text>, via </xsl:text>
    <a href="{@href}">
      <xsl:value-of select="@href"/>
    </a>
  </xsl:template>

  <!-- notes: a series of notes about the spec -->
  <!-- note is defined in xmlspec -->
  <xsl:template match="notes">
    <div class="note">
      <p class="prefix">
        <b>Notes:</b>
      </p>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="issue/head">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="issue">
    <div class="issue">
      <p class="title">
        <xsl:if test="@id">
          <a id="{@id}"/>
        </xsl:if>
        <b>
          <xsl:text>Issue: </xsl:text>
          <xsl:value-of select="@id"/>
        </b>
        <xsl:text>, priority: </xsl:text>
        <xsl:value-of select="@priority"/>
        <xsl:text>, status: </xsl:text>
        <xsl:value-of select="@status"/>
      </p>

      <xsl:apply-templates/>

      <xsl:if test="not(resolution)">
        <p class="prefix">
          <b>
            <xsl:text>Resolution:</xsl:text>
          </b>
        </p>
        <p>None recorded.</p>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="processing-instruction('issues-toc')">
    <table summary="Issues TOC">
      <thead>
        <tr>
          <th class="issue-toc-head" style="text-align:left;">Issue</th>
          <th class="issue-toc-head" style="text-align:left;">Priority</th>
          <th class="issue-toc-head" style="text-align:left;">Status</th>
          <th class="issue-toc-head" style="text-align:left;">ID</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="following::issue[@status != 'closed']">
          <tr>
            <td>
              <xsl:value-of select="count(preceding::issue[@status != 'closed'])+1"/>
              <xsl:text>: </xsl:text>
              <xsl:value-of select="head"/>
              <xsl:text> (</xsl:text>
              <a href="#{@id}">
                <xsl:value-of select="@id"/>
              </a>
              <xsl:text>)</xsl:text>
            </td>
            <td>
              <xsl:value-of select="@priority"/>
            </td>
            <td>
              <xsl:value-of select="@status"/>
            </td>
            <td>
              <xsl:value-of select="@id"/>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:template match="div1|div2|div3|div4|div5|inform-div1">
    <xsl:if test="not(@id)">
      <xsl:message>
        <xsl:text>Warning: </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text> has no id: </xsl:text>
        <xsl:value-of select="head"/>
      </xsl:message>
    </xsl:if>
    <xsl:apply-imports/>
  </xsl:template>

  <!-- ====================================================================== -->

  <!-- Stylesheet for @diff markup in XMLspec -->
  <!-- Author: Norman Walsh (Norman.Walsh@East.Sun.COM) -->
  <!-- Date Created: 2000.07.21 -->

  <!-- Modified by MHK to do differencing since a baseline. The @diff value
     is compared to the $baseline parameter using XPath rules (we use string
     comparison, available only in XPath 2.0) -->

  <!-- This stylesheet is copyright (c) 2000 by its authors.  Free
     distribution and modification is permitted, including adding to
     the list of authors and copyright holders, as long as this
     copyright notice is maintained. -->

  <!-- This stylesheet attempts to implement the XML Specification V2.1
     DTD.  Documents conforming to earlier DTDs may not be correctly
     transformed.

     This stylesheet supports the use of change-markup with the @diff
     attribute. If you use @diff, you should always use this stylesheet.
     If you want to turn off the highlighting of differences, use this
     stylesheet, but set show.diff.markup to 0.

     Using the original xmlspec stylesheet with @diff markup will cause
     @diff=del text to be presented.
-->

  <!-- ChangeLog:
    
     10 Nov 2016: Carine Bournez and Michael Kay
       - modified to produce HTML5 (notably combining individual styling attributes
         such as width and valign into a single style attribute: mainly affects tables)
       - renamed as xsl-query-2016 so that the original remains available, e.g. for
         republishing older specs.
       - some rationalisation between this stylesheet and the base xmlspec-2016 stylesheet.  

     15 July 2008: Michael Kay
       - modified to handle the diff markup generated by the stylesheet that
         applies errata to create a 2nd edition spec from a 1st edition spec
       - applies highlighting to entries in the table of contents
       - some other enhancements such as handling of list items and table cells
       - no longer imports xslt.xsl. It is now generic across all the specs;
         it should be INCLUDED by a stylesheet that also IMPORTS the spec-specific
         stylesheet

     17 Sep 2002: Michael Kay
       - parameterized the colors
       - added extra CSS styles for XSLT
     16 Sep 2002: Michael Kay
       - modified to ignore diff markup if the @at attribute
         is before the baseline given as a parameter. Requires
		 XSLT 2.0 to do string comparison.
     25 Sep 2000: (Norman.Walsh@East.Sun.COM)
       - Use inline diff markup (as opposed to block) for name and
         affiliation
       - Handle @diff='del' correctly in bibl and other list-contexts.
     14 Aug 2000: (Norman.Walsh@East.Sun.COM)
       - Support additional.title param
     27 Jul 2000: (Norman.Walsh@East.Sun.COM)
       - Fix HTML markup problem with diff'd authors in authlist
     26 Jul 2000: (Norman.Walsh@East.Sun.COM)
       - Update pointer to latest xmlspec-stylesheet.
     21 Jul 2000: (Norman.Walsh@East.Sun.COM)
       - Initial version
-->


  <!-- ==================================================================== -->
  
  <xsl:template name="starting-banner">
    <xsl:if test="$show.diff.markup != 0">
      <div>
        <p>The presentation of this document has been augmented to
          identify changes from <xsl:value-of select="$diff.baseline.description"/>. Three kinds of changes
          are highlighted: <span class="diff-add">new, added text</span>,
          <span class="diff-chg">changed text</span>, and
          <span class="diff-del">deleted text</span>.</p>
        <xsl:if test="exists($diff.baseline.date)">
          <p>The baseline for changes is the publication dated
            <xsl:value-of select="format-date(xs:date($diff.baseline.date), '[D] [MNn] [Y]')"/>.</p>
        </xsl:if>
        <hr/>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- Taken from F&O 3.0 and Serialization 3.0 -->
  <xsl:template match="*[my:diff-markup-effect(.) eq 'delete']" priority="2"/>

  <xsl:template match="*[my:diff-markup-effect(.) eq 'delete']" mode="text" priority="2"/>

  <xsl:template match="*[my:diff-markup-effect(.) eq 'delete']" mode="toc" priority="2"/>

  <!-- Taken from F&O 3.0 and Serialization 3.0 -->
  <xsl:template match="*[my:diff-markup-effect(.) eq 'highlight']" priority="3">
    <!--
    <xsl:message><xsl:value-of select="'diff=', @diff, 'at=', @at, '$diff.baseline=', $diff.baseline"/></xsl:message>
    -->
    <xsl:call-template name="diff-markup">
      <xsl:with-param name="diff" select="string(@diff)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="diff-markup">
    <xsl:param name="diff">off</xsl:param>
    <!-- Taken from F&O 3.0 and Serialization 3.0 -->
    <xsl:param name="in-errorref" select="false()" tunnel="yes"/>
    <xsl:choose>

      <!--
        In this <xsl:choose>, most of the alternatives involve
        wrapping a <span> or <div> element around <xsl:next-match/>.
        However, in some cases, that would (and did) produce invalid HTML
        (e.g., when next-match generates dd, li, td, or tr).
        This alternative addresses those cases.

        The approach here is to save the result of
        <xsl-next-match/> and make a tweaked copy of it,
        without introducing a <span> or <div>.
      -->
      <xsl:when test="
        self::publoc | self::latestloc | self::prevlocs |
        self::authlist | self::author |
        self::item |
        self::bibl |
        self::gitem | self::label | self::def |
        self::tr | self::th | self::td
      ">
        <xsl:variable name="diffclass" select="concat('diff-', $diff)"/>

        <xsl:variable name="original" select="."/>

        <xsl:variable name="trans" as="node()*">
          <xsl:next-match/>
        </xsl:variable>

        <xsl:for-each select="$trans">
          <xsl:choose>

            <xsl:when test="
                self::dt
                and
                local-name($original)=('publoc','latestloc','prevlocs','authlist')
            ">
              <!--
                This is just fixed text
                ("This version", "Latest version", "Previous versions", "Editors"),
                so it presumably hasn't changed, so don't highlight it.
              -->
              <xsl:copy-of select="."/>
            </xsl:when>

            <xsl:when test="self::dt | self::dd | self::li | self::th | self::td">
              <xsl:copy>
                <xsl:call-template name="ensure-class-name">
                  <xsl:with-param name="class-name" select="$diffclass"/>
                </xsl:call-template>
                <xsl:copy-of select="@*[name(.) != 'class'] | node()"/>
                <xsl:if test="not(self::dt)">
                  <xsl:apply-templates select="$original/@at"/>
                </xsl:if>
                <!-- (Putting the @at-thing in a <dt> doesn't look right.) -->
              </xsl:copy>
            </xsl:when>

            <xsl:when test="self::tr">
              <xsl:copy>
                <xsl:call-template name="ensure-class-name">
                  <xsl:with-param name="class-name" select="$diffclass"/>
                </xsl:call-template>
                <!-- Put the at-thing in the tr's last td -->
                <xsl:for-each select="@*[name(.) != 'class'] | node()">
                  <xsl:choose>
                    <xsl:when test=". is ../td[last()]">
                      <xsl:copy>
                        <xsl:copy-of select="@* | node()"/>
                        <xsl:apply-templates select="$original/@at"/>
                      </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:copy-of select="."/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
              <xsl:message>WARNING: diff-markup: don't know how to handle <xsl:value-of select="local-name(.)"/></xsl:message>
            </xsl:otherwise>

          </xsl:choose>
        </xsl:for-each>
      </xsl:when>

      <!-- simpler cases ... -->

      <!-- Taken from F&O 3.0 and Serialization 3.0 -->
      <xsl:when test="self::error and $in-errorref">
        <xsl:next-match/>
      </xsl:when>

      <xsl:when test="ancestor-or-self::phrase">
        <span class="diff-{$diff}">
          <xsl:next-match/>
          <xsl:apply-templates select="@at"/>
        </span>
      </xsl:when>

      <xsl:when test="ancestor::p and not(self::p)">
        <span class="diff-{$diff}">
          <xsl:next-match/>
          <xsl:apply-templates select="@at"/>
        </span>
      </xsl:when>

      <xsl:when test="ancestor-or-self::affiliation">
        <span class="diff-{$diff}">
          <xsl:next-match/>
        </span>
      </xsl:when>

      <xsl:when test="ancestor-or-self::name">
        <span class="diff-{$diff}">
          <xsl:next-match/>
        </span>
      </xsl:when>

      <xsl:when test="ancestor-or-self::header">
        <div class="diff-{$diff}">
          <xsl:next-match/>
          <xsl:apply-templates select="@at">
            <xsl:with-param name="put-in-p" select="true()"/>
          </xsl:apply-templates>
        </div>
      </xsl:when>

      <xsl:otherwise>
        <div class="diff-{$diff}">
          <xsl:next-match/>
          <xsl:apply-templates select="@at">
            <xsl:with-param name="put-in-p" select="true()"/>
          </xsl:apply-templates>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ensure-class-name">
    <xsl:param name="class-name" required="yes"/>
    <!--
      Create a 'class' attribute
      that copies the 'class' attribute (if any) of the current node,
      and adds $class-name if it's not already there.
    -->
    <xsl:attribute name='class'>
      <xsl:choose>

        <xsl:when test="not(@class)">
          <!-- Current node doesn't have a class attr. -->
          <xsl:value-of select="$class-name"/>
        </xsl:when>

        <xsl:otherwise>
          <!-- Node already has a class attr. -->
          <!-- Check whether its value already contains $class-name. -->
          <xsl:choose>
            <xsl:when test="tokenize(@class, '\s+') = $class-name">
              <!-- It does, so just copy the current value. -->
              <xsl:value-of select="@class"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- It doesn't, so add $class-name to the current value. -->
              <xsl:value-of select="concat($class-name, ' ', @class)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@at">
    <xsl:param name="put-in-p" select="false()"/>
    <xsl:variable name="atval" select="string(.)"/>
    <xsl:if test="matches($atval, 'E[0-9]+')">
      <xsl:variable name="content" select="concat(' [', $atval, ']')"/>
      <xsl:choose>
        <xsl:when test="$put-in-p">
          <p style="text-align:right;">
            <xsl:value-of select="$content"/>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================= -->

  <!-- Taken from F&O 3.0 and Serialization 3.0 -->
  <!-- highlight leaf entries in the table of contents for sections containing a change -->
  <xsl:template match="
      *
        [$show.diff.markup != 0]
        [descendant-or-self::*
          [
            my:diff-markup-effect(.) eq 'highlight'
            and
            (
              ancestor-or-self::*
                [contains(name(), 'div')]
                [number(substring-after(name(), 'div')) le $toc.level]
                [1]
              is
              current()
            )
          ]
        ]"
      mode="toc">
    <!--<div class="diff-chg">-->
    <xsl:apply-imports>
      <xsl:with-param name="toc-change" select="true()" tunnel="yes"/>
    </xsl:apply-imports>
    <!--</div>-->
  </xsl:template>

  <xsl:template match="*" mode="toc">
    <xsl:apply-imports>
      <xsl:with-param name="toc-change" select="false()" tunnel="yes"/>
    </xsl:apply-imports>
  </xsl:template>

  <!-- Taken from F&O 3.0 and Serialization 3.0 -->
  <!-- Highlight the headings of changed sections in the TOC -->
  <xsl:template match="head" mode="text">
    <xsl:param name="toc-change" tunnel="yes" select="false()"/>
    <xsl:choose>
      <xsl:when test="$toc-change">
        <span class="diff-chg">
          <xsl:apply-templates mode="toc"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
          <xsl:apply-templates mode="toc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Taken from F&O 3.0 and Serialization 3.0 -->
  <!-- Avoid change-marking an error just because the errorref is diffed -->
  <xsl:template match="errorref" priority="10">
    <xsl:next-match>
      <xsl:with-param name="in-errorref" select="true()" tunnel="yes"/>
    </xsl:next-match>
  </xsl:template>


<!-- 2014-01-31: Jim added these templates, including overrides of templates in xmlspec.xsl -->

  <!-- prevlocs: previous locations for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="prevlocs">
    <dt>
      <xsl:text>Previous version</xsl:text>
      <xsl:if test="count(loc) &gt; 1"><xsl:text>s</xsl:text></xsl:if>
      <xsl:if test="@doc">
        <xsl:text> of </xsl:text>
        <xsl:value-of select="@doc"/>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:for-each select="loc">
        <xsl:apply-templates select="."/>
        <xsl:if test="position() &lt; last()">
          <br />
        </xsl:if>
      </xsl:for-each>
<!--
      <xsl:apply-templates/>
-->
    </dd>
  </xsl:template>

  <!-- latestloc: latest location for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="latestloc">
    <dt>
      <xsl:text>Latest version</xsl:text>
      <xsl:if test="@doc">
        <xsl:text> of </xsl:text>
        <xsl:value-of select="@doc"/>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>


  <!-- latestloc-major and -tech: latest location for this major version and this technology -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="latestloc-major | latestloc-tech">
    <dt>
      <xsl:text>Most recent version</xsl:text>
      <xsl:if test="@doc">
        <xsl:text> of </xsl:text>
        <xsl:value-of select="@doc"/>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>


  <!-- prevrec: previous Recommendation for this technology -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="prevrec">
    <dt>
      <xsl:text>Most recent Recommendation of </xsl:text>
      <xsl:value-of select="@doc"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>
  
  
  <!-- ================================================================= -->
  
  <!-- HTML5 requires text to be in NFC; sometimes the source XML isn't, in which case this markup causes it to be normalized -->
  
  <xsl:template match="phrase[@role = 'normalize-nfc']">
    <xsl:value-of select="normalize-unicode(., 'NFC')"/>
  </xsl:template>
  
  <!-- recognize graphic role="full-width" -->
  
  <xsl:template match="graphic[@role='full-width']">
    <img src="{@source}" style="width:100%">
      <xsl:if test="@alt">
        <xsl:attribute name="alt">
          <xsl:value-of select="@alt"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <!-- ================================================================= -->

  <xsl:function name="my:diff-markup-effect" as="xs:string">
    <xsl:param name="el" as="element()?"/>
    <!--
      Given element $el,
      looking at its 'diff' and 'at' attributes (if any),
      and knowing the globals $show.diff.markup and $diff.baseline,
      return a string that indicates what should be done with the element:
      'normal'        : transform as if diff markup didn't exist.
      'delete'        : transform to nothing.
      'diff-highlight': transform with modifications that will highlight changes.
    -->
    <xsl:choose>

      <xsl:when test="empty($el)">
        <!--
          The caller looked for an ancestor or descendant with @diff,
          and didn't find one.
        -->
        <xsl:sequence select="'normal'"/>
      </xsl:when>

      <xsl:when test="$show.diff.markup = 0">
        <!--
          'Execute' all diff markup (regardless of @at).
          (Suppress deleted content, and let everything else through.)
        -->
        <xsl:choose>
          <xsl:when test="$el/@diff = 'del'">
            <xsl:sequence select="'delete'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="'normal'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <!--
          In the document being generated, highlight diffs.
          For diffs marked with @at,
          highlight those that occur "after" $diff.baseline,
          and execute the others.
        -->
        <xsl:choose>

          <xsl:when test="empty($el/@diff)">
            <!-- This node does not have diff markup. -->
            <xsl:sequence select="'normal'"/>
          </xsl:when>

          <xsl:when test="
              $el/@at
              and
              string($el/@at) le $diff.baseline
          ">
            <!--
              This node has diff markup,
              but that markup occurred "before" the baseline,
              so execute it.
            -->
            <xsl:choose>
              <xsl:when test="$el/@diff = 'del'">
                <xsl:sequence select="'delete'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="'normal'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <!--
              This node has diff markup
              that occurred "after" the baseline,
              so highlight it.
            -->
            <xsl:sequence select="'highlight'"/>
          </xsl:otherwise>

        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="example">
    <xsl:if test="preceding-sibling::*[1][self::example]">
      <p>&#xa0;</p>
    </xsl:if>
    <div class="{if (@diff and $show.diff.markup=1) then 'example-chg' else 'example'}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="char">
    <xsl:if test="not(matches(., '^U\+[0-9A-F]{4,6}$'))">
      <xsl:message>*** Content of char element is invalid: <xsl:value-of select="."/>. Should match 'U\+[0-9A-F]{4,6}'.</xsl:message>
    </xsl:if>
    <xsl:variable name="codepoint" select="my:parse-hex(substring(., 3), 0)" as="xs:integer"/>
    <span class="unicode-codepoint">
      <xsl:value-of select="."/>
    </span>
    
    <xsl:if test="$char-names(.)">
      <xsl:text> (</xsl:text>
      <span class="unicode-name">
        <xsl:value-of select="$char-names(.)"/>
      </span>
      <xsl:if test="my:is-printable-character($codepoint)">
        <xsl:text>, </xsl:text>
        <code><xsl:value-of select="codepoints-to-string($codepoint)"/></code>
      </xsl:if>
      <xsl:text>) </xsl:text>
    </xsl:if>
 
  </xsl:template>
  
  <xsl:function name="my:is-printable-character" as="xs:boolean">
    <xsl:param name="cp" as="xs:integer"/>
    <xsl:sequence select="not($cp = (0 to 32, 127 to 160, 768 to 879, 8232))"/>
  </xsl:function>
  
  <xsl:function name="my:parse-hex" as="xs:integer">
    <xsl:param name="hex"/>
    <xsl:param name="num"/>
    <xsl:variable name="MSB" select="translate(substring($hex, 1, 1), 'abcdef', 'ABCDEF')"/>
    <xsl:variable name="value" select="string-length(substring-before('0123456789ABCDEF', $MSB))"/>
    <xsl:variable name="result" select="16 * $num + $value"/>
    <xsl:choose>
      <xsl:when test="string-length($hex) > 1">
        <xsl:sequence select="my:parse-hex(substring($hex, 2), $result)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:variable name="char-names" as="map(xs:string, xs:string)" select="json-doc('character-names.json')"/>
  
  <xsl:template match="changes">
    <div class="changes">
      <p class="changesHeading">
        <xsl:text>Changes in 4.0</xsl:text>
        <xsl:variable name="next" select="../(following::*|descendant::*)[child::changes][1]"/>
        <xsl:if test="$next">
          <xsl:text>&#xa0;</xsl:text>
          <a href="#{$next/@id}">⬇</a>
        </xsl:if>
        <xsl:variable name="prior" select="../(preceding::*|ancestor::*)[child::changes][last()]"/>
        <xsl:if test="$prior">
          <xsl:text>&#xa0;</xsl:text>
          <a href="#{$prior/@id}">⬆</a>
        </xsl:if>
      </p>
      <ol>
        <xsl:apply-templates select="change"/>
      </ol>
    </div>
  </xsl:template>
  
  <xsl:template match="change">
    <li>
      <p>
        <xsl:apply-templates/>
        <xsl:if test="@*">
          <i xsl:expand-text="yes">
            <xsl:text>&#xa0;&#xa0;[</xsl:text>
            <xsl:variable name="issues" select="tokenize(@issue)"/>
            <xsl:if test="exists($issues)">
              <xsl:value-of select="if (count($issues) gt 1) then 'Issues ' else 'Issue '"/>
              <xsl:for-each select="$issues">
                <xsl:if test="position() != 1">&#xa0;</xsl:if>
                <a href="https://github.com/qt4cg/qtspecs/issues/{.}">{.}</a>
              </xsl:for-each>
            </xsl:if>
            <xsl:text>&#xa0;</xsl:text>
            <xsl:variable name="PRs" select="tokenize(@PR)"/>
            <xsl:if test="exists($PRs)">
              <xsl:value-of select="if (count($PRs) gt 1) then 'PRs ' else 'PR '"/>
              <xsl:for-each select="$PRs">
                <xsl:if test="position() != 1">&#xa0;</xsl:if>
                <a href="https://github.com/qt4cg/qtspecs/pull/{.}">{.}</a>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="@date">&#xa0;{format-date(@date, '[D] [MNn] [Y]')}</xsl:if>
            <xsl:text>]</xsl:text>
          </i>
        </xsl:if>
      </p>
    </li>
  </xsl:template>
  
  <xsl:template match="processing-instruction('change-log')" expand-text="yes">
    <ol>
      <xsl:for-each-group select="//change" group-by="(@PR, @issue, generate-id())[1]">
        <xsl:sort select="number(@PR)"/>
        <xsl:sort select="number(@issue)"/>
        <li>
          <xsl:choose>
            <xsl:when test="@PR">
              <p>PR <a href="https://github.com/qt4cg/qtspecs/pull/{@PR}">{@PR}&#xa0;</a></p>
            </xsl:when>
          </xsl:choose>
          <xsl:for-each-group select="current-group()" group-adjacent="normalize-space(.)">
            <p>
              <xsl:apply-templates/>
            </p>
            <xsl:for-each select="current-group()">
              <p>See <xsl:apply-templates select="ancestor::*[@id][1]" mode="specref"/></p>
            </xsl:for-each>
          </xsl:for-each-group>
        </li>
      </xsl:for-each-group>
    </ol>
  </xsl:template>
  
 

</xsl:stylesheet>
