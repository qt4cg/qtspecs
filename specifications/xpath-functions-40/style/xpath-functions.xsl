<?xml version="1.0"?>

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
                xmlns:local="http://www.w3.org/xpath-functions/build/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.w3.org/2016/local-functions"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="xpath-functions-base.xsl"/>

<xsl:param name="strikeout.missing.functions" select="0"/>

<xsl:param name="additional.css" select="'xpath-functions-40.css'"/>

<xsl:param name="toc.level" select="5"/>

<xsl:key name="id" match="*" use="@id"/>

<xsl:template name="finder"
              xmlns:fos="http://www.w3.org/xpath-functions/spec/namespace"
              exclude-result-prefixes="fos">
  <xsl:variable name="spec" select="./root()"/>

  <xsl:variable name="catalog" select="doc('../src/function-catalog.xml')"/>
  <xsl:variable name="prefixes" select="('fn', 'array', 'map', 'math', 'op')"/>
  <xsl:variable name="body" select="."/>
  <div id="function-finder">
    <div class="ffheader">FUNCTION FINDER</div>
    <div>
      <span>Function search: <input id="select-fn" list="fn-list" type="text"/>
      <xsl:text> </xsl:text>
      <button id="help-select-fn-button">?</button>
      </span>
      <p id="help-select-fn" style="display:none;">Type a function name, or press down arrow for a list.</p>
      <datalist id="fn-list">
        <!-- put the fn: functions first -->
        <xsl:for-each select="$catalog//fos:function[@prefix = 'fn']">
          <xsl:sort select="upper-case(@prefix||':'||@name)"/>
          <option value="{@prefix}:{@name}&#8291;"/>
        </xsl:for-each>
        <xsl:for-each select="$catalog//fos:function[@prefix != 'fn']">
          <xsl:sort select="upper-case(@prefix||':'||@name)"/>
          <option value="{@prefix}:{@name}&#8291;"/>
        </xsl:for-each>
      </datalist>
    </div>
  </div>   
</xsl:template>

<xsl:template name="additional-head">
  <script src="js/fo-datalist.js"></script>
</xsl:template>

<!-- Determine the HTML anchor name for the specification of a function -->
<xsl:function name="local:target-id" as="xs:string">
  <xsl:param name="lex" as="xs:string"/>
  <xsl:variable name="prefix" select="substring-before($lex, ':')"/>
  <xsl:variable name="lname" select="substring-after($lex, ':')"/>
  <xsl:choose>
    <xsl:when test="$prefix='op'"><xsl:sequence select="concat('func-',$lname)"/></xsl:when>
    <xsl:when test="$prefix='fn'"><xsl:sequence select="concat('func-',$lname)"/></xsl:when>
    <xsl:when test="$prefix='map'"><xsl:sequence select="concat('func-map-',$lname)"/></xsl:when>
    <xsl:when test="$prefix='array'"><xsl:sequence select="concat('func-array-',$lname)"/></xsl:when>
    <xsl:when test="$prefix='math'"><xsl:sequence select="concat('func-math-',$lname)"/></xsl:when>
    <xsl:otherwise>???</xsl:otherwise>
  </xsl:choose>
</xsl:function>  

<!--<xsl:template match="change">
  <xsl:apply-templates/>
</xsl:template> -->

<xsl:template match="specref">
  <xsl:variable name="target" select="key('ids', @ref)[1]"/>

  <xsl:choose>
    <xsl:when test="local-name($target)='issue'">
      <xsl:if test="$target/@status != 'closed'">
        <xsl:apply-imports/>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- The following template numbers and formats issues in the issues list -->

<xsl:template match="issue[@status='closed']" priority="2">
  <!-- nop -->
</xsl:template>

<xsl:template match="issue">
  <div class="issue">
    <h3>
      <xsl:call-template name="anchor"/>
      <xsl:text>Issue </xsl:text>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:if test="@status = 'closed'">
        <xsl:text> [Closed] </xsl:text>
      </xsl:if>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="head"/>
      (<xsl:value-of select="@id"/>)
    </h3>

    <div class="issueBody">

      <xsl:apply-templates select="*[local-name(.) != 'head']"/>

      <xsl:if test="not(resolution)">
        <p class="prefix">
          <b>
            <xsl:text>Resolution:</xsl:text>
          </b>
        </p>
        <p>None recorded.</p>
      </xsl:if>

      <xsl:if test="@status != 'closed'">
        <xsl:choose>
          <xsl:when test="key('specrefs', @id)">
            <p>
              <xsl:text>This issue occurs in </xsl:text>
              <xsl:for-each select="key('specrefs', @id)">
                <xsl:variable name="div" select="(ancestor::div5
                                                 |ancestor::div4
                                                 |ancestor::div3
                                                 |ancestor::div2
                                                 |ancestor::div1)[last()]"/>
                <xsl:if test="position() &gt; 1">, </xsl:if>
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="target" select="$div"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:apply-templates select="$div" mode="divnum"/>
                  <xsl:apply-templates select="$div/head" mode="text"/>
                </a>
              </xsl:for-each>
            </p>
          </xsl:when>
          <xsl:otherwise>
            <p>This issue is not referenced!</p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </div>
  </div>
</xsl:template>

<xsl:template match="inform-div1//issue/table[1]">
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="ancestor::issue/@id">
        <xsl:value-of select="ancestor::issue/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id(ancestor::issue)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <table summary="Issue Summary">
    <xsl:apply-templates/>
  </table>
  <h4>
    <a id="{$id}-desc"/>
    <xsl:text>Description:</xsl:text>
  </h4>
</xsl:template>

<xsl:template match="p/loc" priority="1">
  <xsl:choose>
    <xsl:when test="@role='internal'">
      <a href="{@href}">
        <xsl:apply-templates/>
        <xsl:text> (W3C-members only)</xsl:text>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <a href="{@href}"><xsl:apply-templates/></a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="edtext/loc" priority="1">
  <xsl:choose>
    <xsl:when test="@role='internal'">
      <a href="{@href}">
        <xsl:apply-templates/>
        <xsl:text> (W3C-members only)</xsl:text>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <a href="{@href}"><xsl:apply-templates/></a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
  <xsl:template match="example">
    <div class="example">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="example[@role='record']" priority="10">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="example[@role='record-description']" priority="10">
    <div class="record-description">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

<!-- Override proto and arg to print XQuery F/O-style prototypes -->

<xsl:template match="proto">
  <xsl:variable name="prefix">
    <xsl:choose>
      <xsl:when test="@prefix"><xsl:value-of select="@prefix"/>:</xsl:when>
      <xsl:when test="@isOp='yes'">op:</xsl:when>
      <xsl:when test="@isSchema='yes'">xs:</xsl:when>
      <xsl:when test="@isDatatype='yes'">xdt:</xsl:when>
      <xsl:when test="@isSpecial='yes'"></xsl:when>     
      <xsl:otherwise>fn:</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="proto">
    <xsl:choose>
      <xsl:when test="empty(arg)">
        <table class="proto" border="0">
          <tr class="name return-type">
	          <td colspan="3">
              <code class="function">
                <xsl:value-of select="$prefix"/>
                <xsl:value-of select="@name"/>
              </code>
              <xsl:text>(</xsl:text>
              <xsl:text>)</xsl:text>
              <code class="as">&#160;as&#160;</code>
              <xsl:choose>
                <xsl:when test="@returnVaries = 'yes'">
                  <code class="return-varies">
                    <xsl:value-of select="@return-type"/>
                    <xsl:if test="@returnEmptyOk='yes'">?</xsl:if>
                  </code>
                </xsl:when>
                <xsl:otherwise>
                  <code class="return-type">
                    <xsl:value-of select="@return-type"/>
                    <xsl:if test="@returnEmptyOk='yes'">?</xsl:if>
                  </code>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table class="proto" border="0">
          <tr class="name">
	          <td colspan="3">
              <code class="function">
                <xsl:value-of select="$prefix"/>
                <xsl:value-of select="@name"/>
              </code>
              <xsl:text>(</xsl:text>
            </td>
          </tr>

          <xsl:for-each select="arg">
            <xsl:variable name="last" select="position() eq last()"/>
            <tr class="arg">
              <td>
                <code>$<xsl:sequence select="@name/string()"/></code>
                <xsl:if test="not(@type) and not(@type-ref) and not($last)">,</xsl:if>
              </td>
              <td>
                <xsl:if test="@type">
                  <code class="as">as&#160;</code>
                  <code class="type"><xsl:apply-templates select="@type" mode="render-type"/></code>
                  <xsl:if test="not (@default) and not($last)">,</xsl:if>
                </xsl:if>
                <xsl:if test="@type-ref">
                  <code class="as">as&#160;</code>
                  <code>
                    <a href="#{@type-ref}">
                      <xsl:value-of select="@type-ref"/>                
                    </a>
                    <xsl:value-of select="@type-ref-occurs"/>    
                  </code>
                  <xsl:if test="not (@default) and not($last)">,</xsl:if>
                </xsl:if>
              </td>
              <td>
                <xsl:if test="@default">
                  <code class="assign">:= </code>
                  <code><xsl:sequence select="@default/string()"/></code>
                  <xsl:if test="not($last)">,</xsl:if>
                </xsl:if>
              </td>
            </tr>
          </xsl:for-each>

          <tr class="return-type">
	          <td colspan="3">
              <xsl:text>)</xsl:text>
              <code class="as">&#160;as&#160;</code>
              <code>
                <xsl:if test="@returnVaries = 'yes' or @return-type-ref">
                  <xsl:attribute name="class"
                                 select="if (@returnVaries = 'yes' and @return-type-ref)
                                         then 'return-varies return-type-ref'
                                         else if (@returnVaries = 'yes')
                                              then 'return-varies'
                                              else 'return-type-ref'"/>
                </xsl:if>

                <xsl:choose>
                  <xsl:when test="@return-type">
                    <xsl:apply-templates select="@return-type" mode="render-type"/>
                    <xsl:if test="@returnEmptyOk='yes'">?</xsl:if>
                  </xsl:when>
                  <xsl:when test="@return-type-ref">
                    <a href="#{replace(@return-type-ref, '[*+?]$', '')}">
                      <xsl:value-of select="@return-type-ref"/>
                    </a>
                    <xsl:value-of select="@return-type-ref-occurs"/>
                    <xsl:if test="@returnEmptyOk='yes'">?</xsl:if>
                  </xsl:when>
                  <!--<xsl:otherwise>
                    <xsl:apply-templates select="@return-type" mode="render-type"/>
                    <xsl:if test="@returnEmptyOk='yes'">?</xsl:if>
                  </xsl:otherwise>-->
                </xsl:choose>
              </code>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="record">
  <xsl:variable name="id" select="(@id, ../@id)[1]"/>
  <div class="record">
    <xsl:if test="$id ne ''">
      <xsl:attribute name="id" select="$id"/>
      <div class="title">
        <code class="return-type-ref">
          <xsl:value-of select="$id"/>
        </code>
        <xsl:text>:</xsl:text>
      </div>
    </xsl:if>
    <table class="record" border="0">
      <tr>
        <td colspan="2">
          <code>record(</code>
        </td>
      </tr>
      <xsl:for-each select="arg">
        <tr class="arg">
          <td>
            <code>
              <xsl:if test="@occur">
                <xsl:attribute name="class" select="@occur"/>
              </xsl:if>
              <xsl:value-of select="@name"/>
              <xsl:if test="@occur = 'opt'">?</xsl:if>
            </code>
          </td>
          <td>
            <xsl:if test="@type">
              <code class="as">as&#160;</code>
              <code>
                <xsl:value-of select="@type"/>
              </code>
            </xsl:if>
            <xsl:if test="@type-ref">
              <code class="as">as&#160;</code>
              <a href="#{@type-ref}">
                <xsl:value-of select="@type-ref"/>
              </a>
            </xsl:if>
            <xsl:if test="not(position() = last())">,</xsl:if>
          </td>
        </tr>
      </xsl:for-each>
      <tr>
        <td colspan="2">
          <code>)</code>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="arg">
  <xsl:if test="preceding-sibling::arg">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@name = '...'">
      <span class="varargs">...</span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="@name"/>
      <xsl:if test="@type">
        <code class="as">&#160;as&#160;</code>
        <xsl:apply-templates select="@type" mode="render-type"/>  
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
  <!-- The default font used for W3C specs doesn't display Greek letters nicely, so we cheat -->
  <xsl:template match="arg/@name[matches(.,'^\p{IsGreek}+$')]" priority="9">
    <code class="arg">$</code><span style="font-family:Times; font-style:italic"><xsl:value-of select="."/></span>
  </xsl:template>
  
  <xsl:template match="arg/@name" priority="8">
    <xsl:param name="small" tunnel="yes" as="xs:string" select="''"/>
    <code class="{$small}arg">$<xsl:value-of select="."/></code>
  </xsl:template>
  
  <xsl:template match="@type">
    <code class="type">
      <xsl:value-of select="."/>
      <xsl:if test="../@emptyOk='yes'">?</xsl:if>
    </code>
  </xsl:template>
  
  <!--<xsl:template match="@type[starts-with(., '[')]">
    <!-\- @type uses a microsyntax representing a record type -\->
    <xsl:variable name="structure" select="parse-json(.)?*"/>
    <code>record(</code>
    <br/>
    <xsl:for-each select="$structure[exists(?name)]">
      <xsl:text>&#xa0;&#xa0;&#xa0;</xsl:text>
      <code>
        <xsl:value-of select="?name"/>
        <xsl:if test="not(?required)">?</xsl:if>
        <xsl:text> as </xsl:text>
        <xsl:value-of select="?type"/>
        <xsl:if test="not(position()=last())">,</xsl:if>
      </code>
      <br/>
    </xsl:for-each>
    <xsl:if test="$structure[?extensible]">
      <xsl:text>&#xa0;&#xa0;&#xa0;*</xsl:text>  
    </xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:template>-->

<xsl:template match="arg" mode="tabular">
  <xsl:param name="small" tunnel="yes" select="''"/>
  <td style="vertical-align:baseline">
    <xsl:choose>
      <xsl:when test="@name = '...'">
        <span class="varargs">...</span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </td>

  <td style="vertical-align:baseline">
    <xsl:if test="@name != '...'">
      <code class="{$small}as">&#160;as&#160;</code>
      <!--<code class="{$small}type">
        <xsl:value-of select="@type"/>
        <xsl:if test="@emptyOk='yes'">?</xsl:if>
      </code>-->
      <xsl:apply-templates select="@type" mode="render-type"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="following-sibling::arg">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>)</xsl:text>
        <code class="{$small}as">&#160;as&#160;</code>
	<xsl:choose>
	  <xsl:when test="parent::proto/@returnVaries = 'yes'">
	    <code class="return-varies">
	      <xsl:value-of select="parent::proto/@return-type"/>
	      <xsl:if test="parent::proto/@returnEmptyOk='yes'">?</xsl:if>
	    </code>
	  </xsl:when>
	  <xsl:otherwise>
	    <code class="{$small}return-type">
	      <xsl:apply-templates select="parent::proto/@return-type" mode="render-type"/>
	      <xsl:if test="parent::proto/@returnEmptyOk='yes'">?</xsl:if>
	    </code>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </td>
</xsl:template>
  
  <xsl:template match="@*[starts-with(., '#')]" mode="render-type" priority="12">
    <a href="#id-record-{substring(., 2)}"><xsl:value-of select="substring(., 2)"/></a>
  </xsl:template>
  
  <xsl:template match="@*" mode="render-type" priority="11">
    <code><xsl:value-of select="."/></code>
  </xsl:template>

<xsl:template match="proto" mode="stringify">
  <xsl:value-of select="@name"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates mode="stringify"/>
  <xsl:text>)</xsl:text>
  <code class="as">&#160;as&#160;</code>
  <xsl:value-of select="@return-type"/>
</xsl:template>

<xsl:template match="arg" mode="stringify">
  <xsl:if test="preceding-sibling::arg">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:value-of select="@type"/>
  <xsl:text> $</xsl:text>
  <xsl:value-of select="@name"/>
</xsl:template>

<!-- Pretty print function signatures -->
  
  <xsl:template match="example[@role='signature']">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="def[@role='example']">
    <dd>
      <div class="example">
        <xsl:apply-templates/>
      </div>
    </dd>
  </xsl:template>
  
  <xsl:template match="olist[@role='note'] | ulist[@role='note']">
    <div class="note">
      <xsl:apply-imports/>
    </div>
  </xsl:template>
  
  <xsl:template match="eg">
    <xsl:variable name="max.line.length" select="max(for $t in tokenize(., '\n') return string-length(.))"/>
    <xsl:apply-imports>
      <xsl:with-param name="pre.class" select="'small'[$max.line.length gt 100]"/>
    </xsl:apply-imports>
  </xsl:template>
  
  <!-- Allow variables with subscripts in the form A/1 -->
  
  <xsl:template match="var[contains(., '/')]">
    <var>
      <xsl:value-of select="substring-before(., '/')"/>
      <sub><xsl:value-of select="substring-after(., '/')"/></sub>
    </var>
  </xsl:template>
  
  <!-- Allow primed variable names to be written A' -->
  
  <xsl:template match="var[matches(., '[A-Z]''')]">
    <var><xsl:value-of select="translate(., '''', '&#x2032;')"/></var>
  </xsl:template>  

<xsl:template match="code[matches(., '^(fn|op|math|map|array):[-a-zA-Z0-9]+(#[0-9]+)?$')][not(@role='example')]">
  <!-- Simplified 2016-09-20 in response to bug 29825; as a result much of the logic here is redundant -->
  <xsl:variable name="raw-name">
    <xsl:choose>
      <xsl:when test="starts-with(., 'fn:') or starts-with(., 'op:')">
        <xsl:choose>
          <xsl:when test="contains(.,'(')">
            <xsl:value-of select="substring-before(substring-after(.,':'),'(')"/>
          </xsl:when>
          <xsl:when test="contains(.,'#')">
            <xsl:value-of select="substring-before(substring-after(.,':'),'#')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-after(.,':')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="starts-with(., 'math:') or starts-with(., 'map:') or starts-with(., 'array:')">
        <xsl:choose>
          <xsl:when test="contains(.,'(')">
            <xsl:value-of select="concat(substring-before(.,':'), '-', substring-before(substring-after(.,':'),'('))"/>
          </xsl:when>
          <xsl:when test="contains(.,'#')">
            <xsl:value-of select="concat(substring-before(.,':'), '-', substring-before(substring-after(.,':'),'#'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(.,':','-')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="name" select="normalize-space($raw-name)"/>

  <!-- HACK: Note that we look for func-xpath-$name before func-$name. That's
       because in HTML, ID values are case-INsensitive, so fn:Name and fn:name
       have the same ID. We work around this, in the source, by identifing one
       of the functions with the ID "func-xpath-name" and the other with
       "func-name". This really ought to be handled better, maybe with a key
       based on the actual prototype... -->
  
  <!-- MHK 2011-06-07: as far as I can determine, the above-mentioned hack
       is no longer relevant - there are no names of the form func-xpath-name -
       but I have not removed it -->

  <xsl:variable name="target-id">
    <xsl:choose>
      <xsl:when test="key('ids', concat('func-xpath-', $name))">
        <xsl:value-of select="concat('func-xpath-', $name)"/>
      </xsl:when>
      <xsl:when test="key('ids', concat('func-', $name))">
        <xsl:value-of select="concat('func-', $name)"/>
      </xsl:when>
      <xsl:when test="key('ids', concat('dt-', $name))">
        <xsl:value-of select="concat('dt-', $name)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  
  <!--<xsl:message select="'name: ', $name, 'target-id: ', $target-id"/>-->

  <xsl:variable name="target" select="key('ids', $target-id)"/>

  <xsl:variable name="is-descendant" select="exists(ancestor::*[@id=$target-id])"/>

  <xsl:variable name="defined">
    <xsl:choose>
      <!-- special case for deleted functions -->
      <xsl:when test="$name = '' or @role = 'del'">1</xsl:when>
      <!-- special case for op:operation() used in numerics section -->
      <xsl:when test="$name = 'operation'">1</xsl:when>
      <!-- special case for the fn:match, fn:non-match, and fn:group elements used by analyze-string -->
      <xsl:when test="$name = ('group', 'match', 'non-match')">1</xsl:when>
      <xsl:when test="count($target) = 1">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$defined = 0">
    <xsl:message>
      <xsl:text>Warning: no definition of function/operator: "</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>" (</xsl:text>
      <xsl:value-of select="$target-id"/>
      <xsl:text>)</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="count($target) = 1 and not($is-descendant)">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="target" select="$target"/>
          </xsl:call-template>
        </xsl:attribute>
        <code>
          <xsl:apply-templates/>
        </code>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <code>
        <xsl:if test="$defined=0 and $strikeout.missing.functions != 0">
          <xsl:attribute name="class">strikeout</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </code>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- =====================  NOTES =============================== -->

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


<!-- ============ CREATE THE QUICK REFERENCE APPENDIX ===================== -->

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="key('ids', 'quickref')">
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="transformed">
        <xsl:apply-templates mode="transform"/>
      </xsl:variable>
      <xsl:apply-templates select="$transformed/spec"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="XSLTprocessor">
    <xsl:text>XSLT Processor: </xsl:text>
    <xsl:value-of select="system-property('xsl:vendor')"/>
    <xsl:if test="number(system-property('xsl:version')) ge 2.0">
      <xsl:text> </xsl:text>
      <xsl:value-of select="system-property('xsl:product-name')"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="system-property('xsl:product-version')"/>
    </xsl:if>
  </xsl:variable>
  <xsl:comment><xsl:value-of select="$XSLTprocessor"/></xsl:comment>
</xsl:template>

<xsl:template match="head/meta">
  <!-- nop -->
</xsl:template>

<xsl:template match="*" mode="transform">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="transform"/>
  </xsl:element>
</xsl:template>

<xsl:template match="back/inform-div1" mode="transform">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="transform"/>
  </xsl:element>

  <xsl:if test="not(following-sibling::inform-div1) and false()"> <!-- removed in this version -->
    <xsl:if test="/spec/body/div1[position() &gt; 1]">
      <inform-div1 id="quickref">
        <head>Function and Operator Quick Reference</head>

        <div2 id="quickref-section">
          <head>Functions and Operators by Section</head>

          <glist>
            <xsl:apply-templates select="/spec/body/div1[position() &gt; 1]"
                                 mode="quickref"/>
          </glist>
        </div2>

        <div2 id="quickref-alpha">
          <head>Functions and Operators Alphabetically</head>

          <xsl:apply-templates select="//proto[not(@role) or @role != 'example']"
                               mode="quickref">
	          <xsl:with-param name="include-sections" select="1"/>
            <xsl:sort select="@name" lang="en"/>
          </xsl:apply-templates>
        </div2>

      </inform-div1>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()" mode="transform">
  <xsl:copy/>
</xsl:template>

<xsl:template match="div1" mode="quickref">
  <xsl:if test=".//example[@role='signature']/proto[not(@role)
		or @role != 'example']">
    <gitem>
      <label>
	<xsl:apply-templates select="." mode="divnum"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="head"/>
      </label>
      <def>
        <xsl:choose>
          <xsl:when test="example[@role='signature']/proto[not(@role) or @role != 'example']">
            <xsl:apply-templates select="example[@role='signature']/proto[not(@role) or @role != 'example']"
                                 mode="quickref"/>
          </xsl:when>
          <xsl:when test="div2">
            <glist>
              <xsl:apply-templates select="div2" mode="quickref"/>
            </glist>
          </xsl:when>
        </xsl:choose>
      </def>
    </gitem>
  </xsl:if>
</xsl:template>

<xsl:template match="div2" mode="quickref">
  <xsl:if test=".//example[@role='signature']/proto[not(@role)
		or @role != 'example']">
    <gitem>
      <label>
	<xsl:apply-templates select="." mode="divnum"/>
	<xsl:text> </xsl:text>
        <xsl:value-of select="head"/>
      </label>
      <def>
        <xsl:choose>
          <xsl:when test="example[@role='signature']/proto[not(@role) or @role != 'example']">
            <xsl:apply-templates select="example[@role='signature']/proto[not(@role) or @role != 'example']"
                                 mode="quickref"/>
          </xsl:when>
          <xsl:when test="div3">
            <xsl:apply-templates select="div3" mode="quickref"/>
          </xsl:when>
        </xsl:choose>
      </def>
    </gitem>
  </xsl:if>
</xsl:template>

<xsl:template match="div3" mode="quickref">
  <xsl:apply-templates select=".//proto[not(@role)
			       or @role != 'example']" mode="quickref"/>
</xsl:template>

<xsl:template match="proto" mode="quickref">
  <!-- Note: this is generating xmlspec source for later processing; don't -->
  <!-- put <a>'s in here, they're implied by the <code>. -->
  <xsl:param name="include-sections" select="0"/>

  <xsl:variable name="prefix">
    <xsl:choose>
      <xsl:when test="@isOp='yes'">op:</xsl:when>
      <xsl:when test="@isSchema='yes'">xs:</xsl:when>
      <xsl:when test="@prefix"><xsl:value-of select="concat(@prefix,':')"/></xsl:when>
      <xsl:otherwise>fn:</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="protoref">
    <code class="function">
      <xsl:value-of select="$prefix"/>
      <xsl:value-of select="@name"/>
    </code>

    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
    <xsl:if test="@return-type != 'nil'">
      <code class="as">&#160;as&#160;</code>
      <code class="return-type">
        <xsl:value-of select="@return-type"/>
        <xsl:if test="@returnEmptyOk='yes'">?</xsl:if>
      </code>
    </xsl:if>

    <xsl:if test="$include-sections != 0">
      <xsl:variable name="div" select="(ancestor::div1|ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5)[last()]"/>
      <xsl:variable name="num">
	<xsl:apply-templates select="$div" mode="divnum"/>
      </xsl:variable>
      <xsl:text> (§</xsl:text>
      <loc href="#{$div/@id}">
	<!-- HACK -->
	<xsl:value-of select="substring-before($num, ' ')"/>
      </loc>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </div>
</xsl:template>
  
<!-- test for termdef and termref -->
<xsl:template match="termref">
  <a title="{key('ids', @def)/@term}" class="termref">
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="target" select="key('ids', @def)"/>
      </xsl:call-template>
    </xsl:attribute>
    <!--<span class="arrow">&#xB7;</span>-->
    <xsl:choose>
      <xsl:when test=". = ''">
        <xsl:value-of select="key('ids', @def)/@term"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <!--<span class="arrow">&#xB7;</span>-->
  </a>
</xsl:template>

<xsl:template match="termdef">
  <xsl:param name="suppress-ids" tunnel="yes" as="xs:boolean" select="false()"/>
  <span class="termdef">
    <xsl:if test="not($suppress-ids)">
      <a id="{@id}"/>
    </xsl:if>
    <xsl:text>[Definition]  </xsl:text>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- ====================================================================== -->
<!-- Special support for the casting tables -->

<xsl:template match="table[@role='casting']">
  <table class="casting">
    <xsl:call-template name="style-attributes"/>
    <xsl:apply-templates select="@*[not(f:is-style-attribute(.))]" mode="table-attributes"/>
    <xsl:apply-templates/>

    <!--<xsl:if test=".//footnote">
      <tbody>
        <tr>
          <td>
            <xsl:apply-templates select=".//footnote" mode="table.notes"/>
          </td>
        </tr>
      </tbody>
    </xsl:if>-->
  </table>
</xsl:template>

<xsl:template match="th[ancestor::table/@role='casting']">
  <th>
    <span class="cancast">
      <xsl:attribute name="title">
        <xsl:call-template name="datatype-expansion">
          <xsl:with-param name="abbrev" select="string(.)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </th>
</xsl:template>

<xsl:template match="td[ancestor::table/@role='casting']">
  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="normalize-space(.) = 'Y'">castY</xsl:when>
      <xsl:when test="normalize-space(.) = 'N'">castN</xsl:when>
      <xsl:when test="normalize-space(.) = 'M'">castM</xsl:when>
      <xsl:otherwise>castOther</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pos" select="count(preceding-sibling::*)+1"/>
  <xsl:variable name="row-head" select="preceding-sibling::th"/>
  <xsl:variable name="col-head" select="ancestor::table/thead/tr/th[$pos]"/>

  <td class="{$class}">
    <span class="cancast">
      <xsl:attribute name="title">
        <xsl:text>Cast </xsl:text>
        <xsl:call-template name="datatype-expansion">
          <xsl:with-param name="abbrev" select="string($row-head)"/>
        </xsl:call-template>
        <xsl:text> to </xsl:text>
        <xsl:call-template name="datatype-expansion">
          <xsl:with-param name="abbrev" select="string($col-head)"/>
        </xsl:call-template>
        <xsl:text>? </xsl:text>
        <xsl:choose>
          <xsl:when test="normalize-space(.) = 'Y'">Yes</xsl:when>
          <xsl:when test="normalize-space(.) = 'N'">No</xsl:when>
          <xsl:when test="normalize-space(.) = 'M'">Maybe</xsl:when>
          <xsl:otherwise>Unknown???</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </td>
</xsl:template>

<xsl:template name="datatype-expansion">
  <xsl:param name="abbrev" select="'?'"/>

  <xsl:choose>
    <xsl:when test="$abbrev = 'uA'">untypedAtomic</xsl:when>
    <xsl:when test="$abbrev = 'aST'">anySimpleType</xsl:when>
    <xsl:when test="$abbrev = 'str'">string</xsl:when>
    <xsl:when test="$abbrev = 'flt'">float</xsl:when>
    <xsl:when test="$abbrev = 'dbl'">double</xsl:when>
    <xsl:when test="$abbrev = 'dec'">decimal</xsl:when>
    <xsl:when test="$abbrev = 'int'">integer</xsl:when>
    <xsl:when test="$abbrev = 'dur'">duration</xsl:when>
    <xsl:when test="$abbrev = 'yMD'">yearMonthDuration</xsl:when>
    <xsl:when test="$abbrev = 'dTD'">dayTimeDuration</xsl:when>
    <xsl:when test="$abbrev = 'dT'">dateTime</xsl:when>
    <xsl:when test="$abbrev = 'tim'">time</xsl:when>
    <xsl:when test="$abbrev = 'dat'">date</xsl:when>
    <xsl:when test="$abbrev = 'gYM'">gYearMonth</xsl:when>
    <xsl:when test="$abbrev = 'gYr'">gYear</xsl:when>
    <xsl:when test="$abbrev = 'gMD'">gMonthDay</xsl:when>
    <xsl:when test="$abbrev = 'gDay'">gDay</xsl:when>
    <xsl:when test="$abbrev = 'gMon'">gMonth</xsl:when>
    <xsl:when test="$abbrev = 'bool'">boolean</xsl:when>
    <xsl:when test="$abbrev = 'b64'">base64Binary</xsl:when>
    <xsl:when test="$abbrev = 'hxB'">hexBinary</xsl:when>
    <xsl:when test="$abbrev = 'aURI'">anyURI</xsl:when>
    <xsl:when test="$abbrev = 'QN'">QName</xsl:when>
    <xsl:when test="$abbrev = 'NOT'">NOTATION</xsl:when>
    <xsl:otherwise><xsl:value-of select="$abbrev"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
  <xsl:template match="rfc2119">
    <span class="verb"><xsl:apply-templates/></span>
  </xsl:template>

<!-- ====================================================================== -->
<!-- Special support for the hierarchy tables and graphics -->

<xsl:template match="graphic">
  <xsl:choose>
    <xsl:when test="ends-with(@source, '.svg')">
      <!-- We have to embed the SVG because we want the links to work -->
      <xsl:variable name="svg"
                    select="doc('../../../build/type-hierarchy/'||@source)"/>
      <xsl:comment>SVG embedded so that links work</xsl:comment>
      <xsl:apply-templates select="$svg" mode="strip-svg"/>
    </xsl:when>
    <xsl:otherwise>
      <next-match/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:mode name="strip-svg" on-no-match="shallow-copy"/>

<xsl:template match="*:svg" mode="strip-svg">
  <xsl:element name="{local-name(.)}">
    <xsl:for-each select="@* except (@width|@height)">
      <xsl:attribute name="{local-name(.)}" select="string(.)"/>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="number(substring-before(@width, 'pt')) gt 800
                      or number(substring-before(@width, 'pt')) lt 500">
        <xsl:copy-of select="@width, @height"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="width" select="800"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="#current"/>
  </xsl:element>
</xsl:template>

<xsl:template match="*" mode="strip-svg">
  <xsl:element name="{local-name(.)}">
    <xsl:for-each select="@*">
      <xsl:attribute name="{local-name(.)}" select="string(.)"/>
    </xsl:for-each>
    <xsl:apply-templates mode="#current"/>
  </xsl:element>
</xsl:template>

<xsl:template match="comment()" mode="strip-svg"/>

<!--<xsl:template match="table[@role='hierarchy']">
  <table class="hierarchy">
    <xsl:for-each select="@*">
      <!-\- Wait: some of these aren't HTML attributes after all... -\->
      <xsl:if test="local-name(.) != 'diff'
                    and local-name(.) != 'role'">
        <xsl:copy/>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </table>
</xsl:template>-->

<!-- Special support for the hierarchy tables -->

<xsl:template match="table[@role='hierarchy']">
  <table class="hierarchy">
    <xsl:call-template name="style-attributes"/>
    <xsl:apply-templates select="@*[not(f:is-style-attribute(.))]" mode="table-attributes"/>   
    <xsl:apply-templates>
      <xsl:with-param name="max-depth" tunnel="yes" as="xs:integer" select="max(.//tr/count(td))"/>
    </xsl:apply-templates>
  </table>
</xsl:template>
  
  <xsl:template match="tr[ancestor::table/@role='hierarchy']">
    <!-- HTML5 requires all cells to be present -->
    <xsl:param tunnel="yes" name="max-depth" as="xs:integer" select="0"/>
    <tr>
      <xsl:apply-templates/>
      <xsl:for-each select="(count(td)+1) to $max-depth">
        <td>&#xa0;</td>
      </xsl:for-each>
    </tr>
  </xsl:template>

<xsl:template match="td[ancestor::table/@role='hierarchy']">

 <td class="castOther">
     <xsl:apply-templates/>
  </td>
</xsl:template>

<!-- ====================================================================== -->
  
  <!-- Add some error checking for bibref elements -->
  
  <xsl:template match="bibref[not(key('ids', @ref))]">
    <xsl:message>Warning: no bibl entry for reference <xsl:value-of select="@ref"/></xsl:message>
    <xsl:next-match/>
  </xsl:template>
  
<!-- Special support for Greek letters as variables. Needs a serifed italic font -->
  
<xsl:template match="var[matches(.,'^\p{IsGreek}+$')]">
  <span style="font-family:Times; font-style:italic"><xsl:value-of select="."/></span>
</xsl:template>
  
  <!-- Output checklist of implementation-defined features -->
  
  <xsl:template match="processing-instruction('imp-def-features')" priority="100">
    <ol>
      <xsl:for-each select="//termref[@def='implementation-defined'][not(.//ancestor::*[@diff='del'])]">
        <xsl:variable name="container" select="ancestor::*[not(ancestor::p)][1]"/>
        <xsl:variable name="section" select="ancestor::*[@id][head or @key][1]"/>
        <xsl:if test=". is ($container//termref[@def='implementation-defined'])[1]">
          <!-- avoid duplicates, see bug 27115 -->
          <li><p>
            <xsl:if test="not(matches(substring(normalize-space(string($container)),1,1), '[A-Z]'))">...</xsl:if>
            <xsl:apply-templates select="$container/node()[not(descendant::p)]">
              <xsl:with-param name="suppress-ids" select="true()" as="xs:boolean" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:if test="not(ends-with(normalize-space(string($container)), '.'))">...</xsl:if>
            (See <a href="#{$section/@id}"><xsl:value-of select="$section/(head, @key)[1]"/></a>.)</p></li>
        </xsl:if>
      </xsl:for-each>
    </ol>
  </xsl:template>
  
  <!-- Error list -->
  
  <xsl:template match="error-list">
    <xsl:variable name="error-list" select="."/>
    <dl>
      <xsl:for-each-group select="*, //errorref[not(ancestor-or-self::*[@diff][1][@diff='del'])]" group-by="concat(@class, @code)">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:choose>
          <xsl:when test="current-group()[self::error]">
            <xsl:apply-templates select="current-group()[self::error]" mode="error-list"/>
          </xsl:when>
          <xsl:otherwise>
            <dt>err:FO<xsl:value-of select="current-grouping-key()"/></dt>
            <dd>(No information available)</dd>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(current-group()[self::errorref])">
          <dt>err:FO<xsl:value-of select="current-grouping-key()"/></dt>
          <dd>(Error code unused?)</dd>
        </xsl:if>
      </xsl:for-each-group>
    </dl>
  </xsl:template>
  
  <xsl:template match="fos:*" xmlns:fos="http://www.w3.org/xpath-functions/spec/namespace" mode="transform">
    <xsl:message terminate="yes">Found <xsl:value-of select="name(.)"/> element which should not have been copied from the function catalog</xsl:message>
  </xsl:template>
  
  <xsl:template match="sup[matches(., '^[a-z]$')]">
    <sup><i><xsl:apply-templates/></i></sup>
  </xsl:template>

</xsl:stylesheet>
