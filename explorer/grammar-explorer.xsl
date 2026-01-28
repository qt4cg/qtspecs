<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="https://qt4cg.org/ns/functions"
                xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
                xmlns:m="https://qt4cg.org/ns/modes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

<xsl:output method="xml" encoding="utf-8" indent="no"/>
<xsl:strip-space elements="*"/>

<xsl:param name="grammar" as="xs:string" select="'xpath40'"/>

<xsl:variable name="xml-grammar" as="element()">
  <xsl:apply-templates select="doc(resolve-uri(config/@grammar, base-uri(config)))/g:grammar"
                       mode="m:subset"/>
</xsl:variable>

<xsl:variable name="display-name"
              select="$xml-grammar/g:language[@id=$grammar]/@display-name/string()"/>

<xsl:variable name="specifications" xmlns="">
  <xsl:for-each select="/config/specification">
    <specification title="{@title}" href="{@href}">
      <xsl:sequence select="doc(resolve-uri(@src, base-uri(.)))/*"/>
    </specification>
  </xsl:for-each>
</xsl:variable>

<xsl:template match="/">
  <html>
    <head>
      <title>{$display-name} Grammar index</title>
      <link rel="stylesheet" href="grammar.css"/>
    </head>
    <body>
      <h1>{$display-name} Grammar</h1>

      <xsl:apply-templates select="$xml-grammar"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="g:grammar">
  <xsl:apply-templates select="g:start"/>
</xsl:template>

<xsl:template match="g:start">
  <xsl:variable name="name" select="@name"/>

  <xsl:variable name="productions"
                select="$xml-grammar/g:production|$xml-grammar/g:token"/>

  <table>
    <tbody>
      <xsl:apply-templates select="$productions[@name=$name]"/>
      <xsl:for-each select="distinct-values($productions/@name/string())">
        <xsl:sort select="upper-case(.)"/>
        <xsl:if test=". != $name">
          <xsl:variable name="pname" select="."/>
          <xsl:apply-templates select="$productions[@name = $pname]"/>
        </xsl:if>
      </xsl:for-each>
    </tbody>
  </table>
</xsl:template>

<xsl:template match="g:production|g:token">
  <xsl:variable name="name" select="@name/string()"/>

  <tr>
    <td>
      <code id="{$name}">
        <a href="{$name}.html">
          <xsl:value-of select="$name"/>
        </a>
      </code>
    </td>
    <td>
      <code>::=</code>
    </td>
    <td>
      <span class="rhs">
        <xsl:call-template name="m:sequence">
          <xsl:with-param name="parens" select="false()"/>
        </xsl:call-template>
      </span>
    </td>
  </tr>

  <xsl:result-document href="{$name}.html">
    <html>
      <head>
        <title>{$display-name} Grammar: {$name}</title>
        <link rel="stylesheet" href="grammar.css"/>
      </head>
      <body>
        <nav>
          <a href="index.html#{$name}">Grammar</a>
        </nav>
        <header>
          <h1>{$display-name} <code><xsl:value-of select="$name"/></code></h1>
        </header>
        <table>
          <tbody>
            <tr>
              <td>
                <code>
                  <xsl:value-of select="$name"/>
                </code>
              </td>
              <td>::=</td>
              <td>
                <span class="rhs">
                  <xsl:call-template name="m:sequence">
                    <xsl:with-param name="parens" select="false()"/>
                    <xsl:with-param name="relative" select="false()" tunnel="true"/>
                  </xsl:call-template>
                </span>
              </td>
            </tr>
          </tbody>
        </table>

        <xsl:variable name="parents" select="$xml-grammar//g:production[.//g:ref[@name=$name]]
                                             |$xml-grammar//g:token[.//g:ref[@name=$name]]"/>

        <xsl:if test="not(empty($parents))">
          <h2>Appears in productions:</h2>
          <ul>
            <xsl:for-each select="$parents">
              <xsl:sort select="upper-case(@name)"/>
              <li>
                <a href="{@name}.html"><code><xsl:value-of select="@name"/></code></a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>

        <xsl:variable name="specs" select="$specifications/*[.//prod[lhs = $name]]"/>
        <xsl:if test="not(empty($specs))">
          <h2>Appears in specifications:</h2>
          <xsl:for-each select="$specs">
            <xsl:sort select="upper-case(@title)"/>
            <div>
              <h3><xsl:value-of select="@title"/></h3>
              <xsl:apply-templates select="." mode="m:sections">
                <xsl:with-param name="spechref" select="@href" tunnel="yes"/>
                <xsl:with-param name="name" select="$name"/>
              </xsl:apply-templates>
            </div>
          </xsl:for-each>
        </xsl:if>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<xsl:template match="g:ref">
  <xsl:param name="relative" as="xs:boolean?" tunnel="true"/>
  <code>
    <xsl:choose>
      <xsl:when test="$relative = false()">
        <a href="{@name}.html">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="#{@name}">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </code>
</xsl:template>

<xsl:template match="g:optional">
  <span class="optional">
    <xsl:call-template name="m:sequence"/>
    <span class="occur">?</span>
  </span>
</xsl:template>

<xsl:template match="g:zeroOrMore">
  <span class="zeroOrMore">
    <xsl:call-template name="m:sequence"/>
    <span class="occur">*</span>
  </span>
</xsl:template>

<xsl:template match="g:oneOrMore">
  <span class="oneOrMore">
    <xsl:call-template name="m:sequence"/>
    <span class="occur">+</span>
  </span>
</xsl:template>

<xsl:template match="g:choice">
  <span class="choice">
    <span class="paren oparen">(</span>
    <xsl:call-template name="m:choice"/>
    <span class="paren cparen">)</span>
  </span>
</xsl:template>

<xsl:template match="g:sequence">
  <span class="sequence">
    <xsl:call-template name="m:sequence"/>
  </span>
</xsl:template>

<xsl:template match="g:string">
  <span class="string">
    <xsl:text>"</xsl:text>
    <code>
      <xsl:value-of select="."/>
    </code>
    <xsl:text>"</xsl:text>
  </span>
</xsl:template>

<xsl:template match="g:complement">
  <span class="complement">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="g:charClass">
  <code>
    <xsl:text>[</xsl:text>
    <xsl:if test="../g:complement">
      <xsl:text>^</xsl:text>
    </xsl:if>
  </code>
  <span class="charClass">
    <xsl:apply-templates/>
  </span>
  <code>]</code>
</xsl:template>

<xsl:template match="g:char">
  <span class="char">
    <code>
      <xsl:apply-templates/>
    </code>
  </span>
</xsl:template>

<xsl:template match="g:charCode">
  <span class="charCode">
    <code>
      <xsl:text>&amp;#x</xsl:text>
      <xsl:value-of select="@value"/>
      <xsl:text>;</xsl:text>
    </code>
  </span>
</xsl:template>

<xsl:template match="g:charCodeRange">
  <span class="charCodeRange">
    <code>
      <xsl:text>&amp;#x</xsl:text>
      <xsl:value-of select="@minValue"/>
      <xsl:text>;</xsl:text>
    </code>
    <xsl:text>-</xsl:text>
    <code>
      <xsl:text>&amp;#x</xsl:text>
      <xsl:value-of select="@maxValue"/>
      <xsl:text>;</xsl:text>
    </code>
  </span>
</xsl:template>

<xsl:template match="g:charRange">
  <span class="charCodeRange">
    <code>
      <xsl:value-of select="@minChar"/>
    </code>
    <xsl:text>-</xsl:text>
    <code>
      <xsl:value-of select="@maxChar"/>
    </code>
  </span>
</xsl:template>

<!-- ============================================================ -->

<xsl:mode name="m:subset" on-no-match="shallow-copy"/>
<xsl:template match="*" mode="m:subset">
  <xsl:if test="f:applies(.)">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="m:subset"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="m:sequence">
  <xsl:param name="parens" as="xs:boolean" select="true()"/>

  <xsl:if test="$parens and count(*) gt 1">
    <span class="paren oparen">(</span>
  </xsl:if>

  <xsl:for-each select="*">
    <xsl:if test="position() gt 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>

  <xsl:if test="$parens and count(*) gt 1">
    <span class="paren cparen">)</span>
  </xsl:if>
</xsl:template>

<xsl:template name="m:choice">
  <xsl:for-each select="*">
    <xsl:if test="position() gt 1"> | </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="specification" mode="m:sections">
  <xsl:param name="name" as="xs:string"/>
  <xsl:variable name="div1" select=".//div1[.//prod[lhs=$name]], .//inform-div1[.//prod[lhs=$name]]"/>
  <xsl:if test="exists($div1)">
    <ul class="toc">
      <xsl:apply-templates select="$div1" mode="m:sections">
        <xsl:with-param name="prefix" select="''"/>
        <xsl:with-param name="name" select="$name"/>
      </xsl:apply-templates>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="m:sections">
  <xsl:param name="prefix" as="xs:string"/>
  <xsl:param name="name" as="xs:string"/>
  <xsl:param name="spechref" as="xs:string" tunnel="yes"/>

  <!-- The XSLT spec has an un-headed div2; so special case... -->
  <xsl:variable name="current" select="(scrap/prod[lhs=$name]
                                       |scrap/prodgroup/prod[lhs=$name]
                                       | div1[not(head)]//prod[lhs=$name]
                                       | div2[not(head)]//prod[lhs=$name]
                                       | div3[not(head)]//prod[lhs=$name]
                                       | div4[not(head)]//prod[lhs=$name]
                                       | div5[not(head)]//prod[lhs=$name]
                                       | div6[not(head)]//prod[lhs=$name])[1]"/>

  <xsl:variable name="divs" as="element()*">
    <xsl:choose>
      <xsl:when test="self::div1|self::inform-div1">
        <xsl:sequence select="div2[head and .//prod[lhs=$name]]"/>
      </xsl:when>
      <xsl:when test="self::div2">
        <xsl:sequence select="div3[head and .//prod[lhs=$name]]"/>
      </xsl:when>
      <xsl:when test="self::div3">
        <xsl:sequence select="div4[head and .//prod[lhs=$name]]"/>
      </xsl:when>
      <xsl:when test="self::div4">
        <xsl:sequence select="div5[head and .//prod[lhs=$name]]"/>
      </xsl:when>
      <xsl:when test="self::div5">
        <xsl:sequence select="div6[head and .//prod[lhs=$name]]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="number" as="xs:string">
    <xsl:number/>
  </xsl:variable>

  <xsl:variable name="number"
                select="if ($prefix = '') then $number else $prefix || '.' || $number"/>

  <li>
    <span>
      <xsl:choose>
        <xsl:when test="exists($current)">
          <a href="{$spechref}#{$current/@id}">
            <xsl:sequence select="$number"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="head"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$number"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="head"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="exists($divs)">
        <ul>
          <xsl:apply-templates select="$divs" mode="m:sections">
            <xsl:with-param name="prefix" select="$number"/>
            <xsl:with-param name="name" select="$name"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </span>
  </li>
</xsl:template>

<!--
<xsl:template match="div1|inform-div1" mode="m:sections">
  <xsl:param name="name" as="xs:string"/>

  <xsl:variable name="div2" select="div2[.//prod[lhs=$name]]"/>
  <xsl:if test="exists($div2)">
    <ul>
      <xsl:for-each select="$div2">
        <li>
          <xsl:value-of select="head"/>
          <xsl:apply-templates select="div2" mode="m:sections">
            <xsl:with-param name="name" select="$name"/>
          </xsl:apply-templates>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template match="div2" mode="m:sections">
  <xsl:param name="name" as="xs:string"/>

  <xsl:variable name="div3" select="div3[.//prod[lhs=$name]]"/>
  <xsl:if test="exists($div3)">
    <ul>
      <xsl:for-each select="$div3">
        <li>
          <xsl:value-of select="head"/>
          <xsl:apply-templates select="div3" mode="m:sections">
            <xsl:with-param name="name" select="$name"/>
          </xsl:apply-templates>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template match="div3" mode="m:sections">
  <xsl:param name="name" as="xs:string"/>

  <xsl:variable name="div4" select="div4[.//prod[lhs=$name]]"/>
  <xsl:if test="exists($div4)">
    <ul>
      <xsl:for-each select="$div4">
        <li>
          <xsl:value-of select="head"/>
          <xsl:apply-templates select="div4" mode="m:sections">
            <xsl:with-param name="name" select="$name"/>
          </xsl:apply-templates>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template match="div4" mode="m:sections">
  <xsl:param name="name" as="xs:string"/>

  <xsl:variable name="div5" select="div5[.//prod[lhs=$name]]"/>
  <xsl:if test="exists($div5)">
    <ul>
      <xsl:for-each select="$div5">
        <li>
          <xsl:value-of select="head"/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>
-->

<!-- ============================================================ -->

<xsl:function name="f:applies" as="xs:boolean">
  <xsl:param name="element" as="element()"/>
  <xsl:sequence select="(empty($element/@if) or contains-token($element/@if, $grammar))
                        and not(contains-token($element/@not-if, $grammar))"/>
</xsl:function>

<!-- ============================================================ -->

<xsl:template match="*">
  <xsl:message select="'Unsupported:', local-name(.)"/>
</xsl:template>

</xsl:stylesheet>
