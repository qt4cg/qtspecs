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

<xsl:output method="html" version="5.0" encoding="utf-8" indent="no"/>
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
      <div class="ribbon">
        <nav>
          <a href="../index.html">Grammar Explorer</a>
        </nav>
      </div>
      <main>
        <h1>{$display-name} Grammar</h1>

        <xsl:apply-templates select="$xml-grammar"/>
      </main>
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

  <table class="grammar">
    <tbody>
      <xsl:apply-templates select="$productions[@name=$name]"/>
      <xsl:for-each select="distinct-values($productions/@name/string())">
        <!-- Q: group character classes and append to the end of the list? -->
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
    <td class="rule">
      <code id="{$name}">
        <a href="{$name}.html">
          <xsl:value-of select="$name"/>
        </a>
      </code>
    </td>
    <td class="assign">
      <code>::=</code>
    </td>
    <td class="rhs">
      <xsl:call-template name="m:sequence">
        <xsl:with-param name="parens" select="false()"/>
      </xsl:call-template>
    </td>
  </tr>

  <xsl:result-document href="{$name}.html">
    <html>
      <head>
        <title>{$display-name} Grammar: {$name}</title>
        <link rel="stylesheet" href="grammar.css"/>
      </head>
      <body>
        <div class="ribbon">
          <nav>
            <a href="index.html#{$name}">Grammar</a>
          </nav>
        </div>
        <header>
          <h1>{$display-name} <code><xsl:value-of select="$name"/></code></h1>
        </header>
        <main>
        <table>
          <tbody>
            <tr>
              <td class="rule">
                <code>
                  <xsl:value-of select="$name"/>
                </code>
              </td>
              <td class="assign"><code>::=</code></td>
              <td class="rhs">
                <xsl:call-template name="m:sequence">
                  <xsl:with-param name="parens" select="false()"/>
                  <xsl:with-param name="relative" select="false()" tunnel="true"/>
                </xsl:call-template>
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
        </main>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<xsl:template match="g:ref">
  <xsl:param name="relative" as="xs:boolean?" tunnel="true"/>
    <xsl:choose>
      <xsl:when test="$relative = false()">
        <a class="ref" href="{@name}.html">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a class="ref relative" href="#{@name}">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
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
    <span class="paren opening">(</span>
    <xsl:call-template name="m:choice"/>
    <span class="paren closing">)</span>
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
  <code class="bracket opening">
    <xsl:text>[</xsl:text>
    <xsl:if test="../g:complement">
      <xsl:text>^</xsl:text>
    </xsl:if>
  </code>
  <span class="charClass">
    <xsl:apply-templates/>
  </span>
  <code class="bracket closing">]</code>
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
    <code class="char">
      <xsl:text>&amp;#x</xsl:text>
      <xsl:value-of select="@value"/>
      <xsl:text>;</xsl:text>
      <xsl:sequence select="f:show-char(@value)"/>
    </code>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>

<xsl:template match="g:charCodeRange">
  <span class="charCodeRange">
    <code class="char">
      <xsl:text>&amp;#x</xsl:text>
      <xsl:value-of select="@minValue"/>
      <xsl:text>;</xsl:text>
      <xsl:sequence select="f:show-char(@minValue)"/>
    </code>
    <code class="rangeDash"><xsl:text>–</xsl:text></code>
    <code class="char">
      <xsl:text>&amp;#x</xsl:text>
      <xsl:value-of select="@maxValue"/>
      <xsl:text>;</xsl:text>
      <xsl:sequence select="f:show-char(@maxValue)"/>
    </code>
  </span>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="g:charRange">
  <span class="charCodeRange">
    <code class="char">
      <xsl:value-of select="@minChar"/>
    </code>
    <code class="rangeDash"><xsl:text>–</xsl:text></code>
    <code class="char">
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
    <span class="paren opening">(</span>
  </xsl:if>

  <xsl:for-each select="*">
    <xsl:if test="position() gt 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>

  <xsl:if test="$parens and count(*) gt 1">
    <span class="paren closing">)</span>
  </xsl:if>
</xsl:template>

<xsl:template name="m:choice">
  <xsl:for-each select="*">
    <xsl:if test="position() gt 1"><code class="choicePipe"> | </code></xsl:if>
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
  <xsl:variable name="current" select="( scrap/prod[lhs=$name]
                                       | scrap/prodgroup/prod[lhs=$name]
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

<xsl:function name="f:hex-to-decimal" as="xs:integer">
  <xsl:param name="hex" as="xs:string"/>

  <xsl:variable name="zero" select="string-to-codepoints('0')"/>
  <xsl:variable name="nine" select="string-to-codepoints('9')"/>
  <xsl:variable name="A" select="string-to-codepoints('A')"/>

  <xsl:iterate select="reverse(string-to-codepoints(upper-case($hex)))">
    <xsl:param name="decimal" select="0" as="xs:integer"/>
    <xsl:param name="power" select="1"/>

    <xsl:on-completion select="$decimal"/>
    
    <xsl:variable name="digit" select="if (. gt $nine) then (. - $A + 10) else . - $zero"/>

    <xsl:next-iteration>
      <xsl:with-param name="decimal" select="$decimal + ($digit * $power)"/>
      <xsl:with-param name="power" select="$power * 16"/>
    </xsl:next-iteration>
  </xsl:iterate>
</xsl:function>

<xsl:function name="f:show-char">
  <xsl:param name="hex" as="xs:string"/>

  <xsl:variable name="decimal" select="f:hex-to-decimal($hex)"/>
  <xsl:if test="f:show($decimal)">
    <span class="ch">
      <xsl:value-of select="codepoints-to-string($decimal)"/>
    </span>
  </xsl:if>
</xsl:function>

<xsl:function name="f:show" as="xs:boolean">
  <xsl:param name="decimal" as="xs:integer"/>

  <!-- What a hack! But it was easy to generate. -->
  <xsl:choose>
    <!-- Avoid "not a character" and other specials -->
    <xsl:when test="$decimal = (65529, 65530, 65531, 65532, 65533, 65534, 65535)">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <!-- Avoid combining characters -->
    <xsl:when test="$decimal = (1471, 1476, 1648, 2364, 2381, 2492, 2494,
                                2495, 2519, 2562, 2620, 2622, 2623, 2748, 2876,
                                3031, 3415, 3633, 3761, 3893, 3895, 3897, 3902,
                                3903, 3991, 4025, 8417, 12441, 12442)">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 768 and $decimal le 837">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 864 and $decimal le 865">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1155 and $decimal le 1158">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1425 and $decimal le 1441">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1443 and $decimal le 1465">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1467 and $decimal le 1469">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1473 and $decimal le 1474">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1611 and $decimal le 1618">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1750 and $decimal le 1756">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1757 and $decimal le 1759">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1760 and $decimal le 1764">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1767 and $decimal le 1768">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 1770 and $decimal le 1773">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2305 and $decimal le 2307">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2366 and $decimal le 2380">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2385 and $decimal le 2388">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2402 and $decimal le 2403">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2433 and $decimal le 2435">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2496 and $decimal le 2500">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2503 and $decimal le 2504">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2507 and $decimal le 2509">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2530 and $decimal le 2531">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2624 and $decimal le 2626">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2631 and $decimal le 2632">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2635 and $decimal le 2637">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2672 and $decimal le 2673">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2689 and $decimal le 2691">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2750 and $decimal le 2757">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2759 and $decimal le 2761">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2763 and $decimal le 2765">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2817 and $decimal le 2819">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2878 and $decimal le 2883">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2887 and $decimal le 2888">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2891 and $decimal le 2893">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2902 and $decimal le 2903">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 2946 and $decimal le 2947">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3006 and $decimal le 3010">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3014 and $decimal le 3016">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3018 and $decimal le 3021">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3073 and $decimal le 3075">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3134 and $decimal le 3140">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3142 and $decimal le 3144">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3146 and $decimal le 3149">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3157 and $decimal le 3158">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3202 and $decimal le 3203">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3262 and $decimal le 3268">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3270 and $decimal le 3272">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3274 and $decimal le 3277">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3285 and $decimal le 3286">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3330 and $decimal le 3331">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3390 and $decimal le 3395">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3398 and $decimal le 3400">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3402 and $decimal le 3405">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3636 and $decimal le 3642">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3655 and $decimal le 3662">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3764 and $decimal le 3769">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3771 and $decimal le 3772">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3784 and $decimal le 3789">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3864 and $decimal le 3865">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3953 and $decimal le 3972">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3974 and $decimal le 3979">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3984 and $decimal le 3989">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 3993 and $decimal le 4013">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 4017 and $decimal le 4023">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 8400 and $decimal le 8412">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="$decimal ge 12330 and $decimal le 12335">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="true()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:template match="*">
  <xsl:message select="'Unsupported:', local-name(.)"/>
</xsl:template>

</xsl:stylesheet>
