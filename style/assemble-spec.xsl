<?xml version="1.0" encoding="utf-8"?>

<!--
 * Copyright (c) 2002 World Wide Web Consortium,
 * (Massachusetts Institute of Technology, Institut National de
 * Recherche en Informatique et en Automatique, Keio University). All
 * Rights Reserved. This program is distributed under the W3C's Software
 * Intellectual Property License. This program is distributed in the
 * hope that it will be useful, but WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.
 * See W3C License http://www.w3.org/Consortium/Legal/ for more details.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0"
  xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="g xlink xs"
  xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:param name="spec" select="'xpath'"/>
  <xsl:param name="not-spec" select="''"/>
  <xsl:param name="grammar-file" select="'xpath-grammar.xml'"/>
  <xsl:param name="grammar-map-file-name">grammar-map.xml</xsl:param>

  <!-- xsl:variable name="grammar" select="document($grammar-file)"/ -->
  <xsl:variable name="sourceTree" select="/"/>
  <xsl:variable name="prodrecaps" select="//prodrecap[not(parent::*/@role='example')]"/>

  <!-- Generate a comment that identifies as much as we can about the XSLT processor being used -->
  <xsl:template match="/" priority="100">
    <xsl:variable name="XSLTprocessor">
      <xsl:text>{assemble-spec} </xsl:text>
      <xsl:text>XSLT Processor: </xsl:text>
      <xsl:value-of select="system-property('xsl:vendor')"/>
      <xsl:if test="system-property('xsl:version') = '2.0'">
        <xsl:text> </xsl:text>
        <xsl:value-of select="system-property('xsl:product-name')"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:if>
    </xsl:variable>
    <!--<xsl:message><xsl:value-of select="$XSLTprocessor"/></xsl:message>-->
    <xsl:comment><xsl:value-of select="$XSLTprocessor"/></xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="@*|node()[not(self::g:*)]" priority="-10000">
    <xsl:if test="self::node()[not(normalize-space($not-spec)=@role)]">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:include href="grammar2spec.xsl"/>

  <xsl:template name="get-gfn">
    <!-- Assumes predrecap context -->
    <xsl:variable name="k" select="@orig"/>
    <xsl:choose>
      <xsl:when test="$k">
        <xsl:variable name="gfn" select="document($grammar-map-file-name,.)//*[string(@name)=string($k)]"/>
        <xsl:value-of select="$gfn"/>
        <!--
        <xsl:message>
          <xsl:text>grammar file: </xsl:text><xsl:value-of select="$gfn"/>
          <xsl:text>, k: '</xsl:text><xsl:value-of select="$k"/><xsl:text>'</xsl:text>
        </xsl:message>
        -->
      </xsl:when>
      <xsl:when test="@at">
        <!--
        <xsl:message>
          <xsl:text>grammar file: </xsl:text><xsl:value-of select="@at"/>
          <xsl:text>, @at</xsl:text>
        </xsl:message>
        -->
        <xsl:value-of select="@at"/>
      </xsl:when>
      <xsl:otherwise>
        <!--
        <xsl:message>
          <xsl:text>grammar file: </xsl:text><xsl:value-of select="$grammar-file"/>
          <xsl:text>, global</xsl:text>
        </xsl:message>
        -->
        <xsl:value-of select="$grammar-file"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="prodrecap[@id='DefinedLexemes' or @role='DefinedLexemes']">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="$grammar/g:grammar">
      <xsl:call-template name="add-terminals"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="prodrecap[@id='LocalTerminalSymbols' or @role='LocalTerminalSymbols']">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>

    <xsl:for-each select="$grammar/g:grammar">
      <xsl:call-template name="add-terminals">
        <xsl:with-param name="do-local-terminals" select="true()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="prodrecap[@id='BNF-Grammar-prods' or @role='BNF-Grammar-prods']">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>

    <xsl:for-each select="$grammar/g:grammar">
      <xsl:call-template name="add-non-terminals">
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  
  
  <!-- Handle a general prodrecap -->
  <!-- MHK 2025-01-19: We now decide which productions
       to include in each scrap algorithmically. The logic is basically to include all productions
       in the subtree of this one that are not themselves principal productions, where a principal
       production is one that appears in its own scrap. -->
  
  <xsl:template match="prodrecap">

    <xsl:variable name="debugging" select="false()"/>
    
    <!-- Avoid generating duplicate IDs for productions used as examples -->
    <xsl:variable name="in-example" select="../@role='example'" as="xs:boolean"/>
    
    <!-- Normally there should not be more than one prodrecap for the same production.
         But if it happens, generate distinct names to avoid DTD invalidity -->
    
    <xsl:variable name="duplicate" as="xs:integer" 
      select="count(preceding::prodrecap[@ref=current()/@ref][not(../@role='example')]) + 1"/>

    <xsl:if test="$duplicate != 1">
      <xsl:message expand-text="1">*** Duplicate prodrecap {@ref} ***</xsl:message>
    </xsl:if>
    
    <xsl:variable name="id-prefix" as="xs:string">
      <xsl:choose>
        <xsl:when test="$in-example">example-</xsl:when>
        <xsl:when test="$duplicate != 1"><xsl:value-of select="'x'||$duplicate||'-'"/></xsl:when>
        <xsl:otherwise><xsl:sequence select="''"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$debugging">
      <xsl:comment>
        DEBUG: template match="prodrecap" starting
        $spec = '<xsl:value-of select="$spec"/>'
        @id   = '<xsl:value-of select="@id"/>'
        @ref  = '<xsl:value-of select="@ref"/>'
        @role = '<xsl:value-of select="@role"/>'
      </xsl:comment>
    </xsl:if>

    <xsl:variable name="name" select="@ref" as="attribute(ref)"/>

    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>

    <xsl:for-each select="$grammar"> 
      <!-- switch context to the grammar document -->
      <xsl:call-template name="show-prod">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="id-prefix" select="$id-prefix" tunnel="yes"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>



  <!-- This template "fills in" a paragraph in the EBNF section of document source files -->
  <xsl:template match="phrase[@role='defined-tokens-delimiting']">
    <!--
    <xsl:message>DEBUG: Starting template phrase[@role='defined-tokens-delimiting']. </xsl:message>
    -->
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <!--
    <xsl:message>DEBUG: template phrase[...delimiting] ~~ $fn = <xsl:value-of select="$fn"/>. </xsl:message>
    -->
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="$grammar">
      <xsl:call-template name="show-defined-tokens">
        <xsl:with-param name="type" select="'delimiting'"/>
      </xsl:call-template>
    </xsl:for-each>
    <!--
    <xsl:message>DEBUG: Exiting template phrase[@role='defined-tokens-delimiting']. </xsl:message>
    -->
  </xsl:template>

  <!-- This template "fills in" a paragraph in the EBNF section of document source files -->
  <xsl:template match="phrase[@role='defined-tokens-nondelimiting']">
    <!--
    <xsl:message>DEBUG: Starting template phrase[@role='defined-tokens-nondelimiting']. </xsl:message>
    -->
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <!--
    <xsl:message>DEBUG: template phrase[...nondelimiting] ~~ $fn = <xsl:value-of select="$fn"/>. </xsl:message>
    -->
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="$grammar">
      <xsl:call-template name="show-defined-tokens">
        <xsl:with-param name="type" select="'nondelimiting'"/>
      </xsl:call-template>
    </xsl:for-each>
    <!--
    <xsl:message>DEBUG: Exiting template phrase[@role='defined-tokens-nondelimiting']. </xsl:message>
    -->
  </xsl:template>
  
  <!-- This template "fills in" a paragraph in the EBNF section of document source files -->
  <xsl:template match="phrase[@role='literal-terminals']">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="$grammar">
      <xsl:call-template name="show-defined-tokens">
        <xsl:with-param name="type" select="'literal-terminals'"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!-- This template "fills in" a paragraph in the EBNF section of document source files -->
  <xsl:template match="phrase[@role='variable-terminals']">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="$grammar">
      <xsl:call-template name="show-defined-tokens">
        <xsl:with-param name="type" select="'variable-terminals'"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!-- This template "fills in" a paragraph in the EBNF section of document source files -->
  <xsl:template match="phrase[@role='complex-terminals']">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="$grammar">
      <xsl:call-template name="show-defined-tokens">
        <xsl:with-param name="type" select="'complex-terminals'"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!--========= Language phrase substitution ========== -->

  <!--* MSM adds this to handle errataloc, 2007-01-16.  I hope it's
      * correct... *-->
  <xsl:template match="errataloc[@role='spec-conditional']/@href">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$spec='xpath'">
          <xsl:text>http://www.w3.org/XML/2007/qt-errata/xpath20-errata.html</xsl:text>
        </xsl:when>
        <xsl:when test="$spec='xquery'">
          <xsl:text>http://www.w3.org/XML/2007/qt-errata/xquery-errata.html</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <!--* MSM adds this to handle translations, 2007-01-16.  I hope it's
      * correct... *-->
  <xsl:template match="translationloc[@role='spec-conditional']/@href">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="$spec='xpath'">
          <xsl:text>http://www.w3.org/2003/03/Translations/byTechnology?technology=xpath20</xsl:text>
        </xsl:when>
        <xsl:when test="$spec='xquery'">
          <xsl:text>http://www.w3.org/2003/03/Translations/byTechnology?technology=xquery</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="termdef">
    <xsl:choose>
      <xsl:when test="starts-with(@id,'xpath-')
                      or starts-with(@id,'xpath21-')
                      or starts-with(@id,'xpath30-')
                      or starts-with(@id,'xpath40-')">
        <xsl:message>Cleaning up termdef: <xsl:value-of select="@id"/></xsl:message>
        <termdef>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="id">
            <xsl:value-of select="substring(@id,7)"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </termdef>
      </xsl:when>
      <xsl:otherwise>
        <termdef>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </termdef>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="nt[@def]">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>

    <nt>
      <xsl:attribute name="def">
        <xsl:variable name="def" select="@def"/>
        <xsl:choose>
          <xsl:when test="$def = $prodrecaps/@ref">doc-</xsl:when>
          <xsl:otherwise>prod-</xsl:otherwise>
        </xsl:choose>

        <xsl:if test="true()">
          <xsl:value-of select="$spec"/>
          <xsl:text>-</xsl:text>
        </xsl:if>
        <xsl:value-of select="@def"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:comment expand-text="1">$spec = {$spec}</xsl:comment>
    </nt>
  </xsl:template>

  <xsl:template match="g:description/code">
    <code>
      <xsl:for-each select="@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </code>
  </xsl:template>

  <xsl:template match="g:description/nt">
    <nt>
      <xsl:for-each select="@*">
        <xsl:copy/>
      </xsl:for-each>
      <xsl:apply-templates/>
    </nt>
  </xsl:template>

</xsl:stylesheet>

