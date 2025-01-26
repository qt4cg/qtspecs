<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   " ">
<!ENTITY bsp   " ">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0"
  xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="g xs">
  <!-- $Id: grammar2spec.xsl,v 1.108 2016/06/29 14:56:59 mdyck Exp $ -->

  <!-- * Copyright (c) 2002 World Wide Web Consortium,
       * (Massachusetts Institute of Technology, Institut National de
       * Recherche en Informatique et en Automatique, Keio University). All
       * Rights Reserved. This program is distributed under the W3C's Software
       * Intellectual Property License. This program is distributed in the
       * hope that it will be useful, but WITHOUT ANY WARRANTY; without even
       * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
       * PURPOSE.
       * See W3C License http://www.w3.org/Consortium/Legal/ for more details.
       * -->

  <!-- FileName: grammar2spec.xsl -->
  <!-- Creator: Scott Boag -->
  <!-- Purpose: Transforms documents that conform to grammar.dtd to
       a document that conforms to xmlspec.dtd, in particular
       the prod elements. -->


  <xsl:output method="xml" indent="no"
              doctype-system = "../../../schema/xsl-query.dtd" />

  <!-- Specifies the desired grammar subset for many targets. -->
  
  <xsl:param name="tokens-file" select="'tokens.xml'"/>
  
  <xsl:param name="is-xslt30" select="false()"/>

  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->

  <!--
    For the purposes of this stylesheet, a "definition" is:
      - a g:production,
      - a child of g:level (g:binary, g:prefix, g:postfix, g:primary), or
      - a g:token.
    (Normally, one might refer to these all as "productions", but that might
    be misconstrued to only refer to g:production elements.)

    A definition is "visible" if:
      - it does not have @show='no', and
      - if it's a g:token,
        - it has @inline='false', and
        - it does not have @visible='false'.

    Visible definitions are the ones that can be referenced to pull EBNF into
    specifications.

    The following keys collect all (and only) the visible definitions of a given
    grammar (i.e., whichever grammar contains the context node when the key()
    function is called).
  -->

  <xsl:key name="visible_nonterminal_defns"
    match="g:*[
            self::g:production
            or parent::g:level
           ][not(@show='no')]"
    use="''"/>

  <xsl:key name="visible_nonterminal_defns_by_name"
    match="g:*[
            self::g:production
            or parent::g:level
           ][not(@show='no')]"
    use="@name"/>

  <xsl:key name="visible_terminal_defns"
    match="
      g:token[
        @inline='false'
        and not(@visible='false')
        and not(@show='no')
      ]"
    use="''"/>

  <xsl:key name="visible_terminal_defns_by_name"
    match="
      g:token[
        @inline='false'
        and not(@visible='false')
        and not(@show='no')
      ]"
    use="@name"/>

  <!--
    In the above 2 xsl:keys, "and not(@visible='false')" is there for
    when this stylesheet is used with grammar-10/xpath-grammar.xml,
    which still has 'visible' attributes.
    (In grammar-30, they've been phased out.)
  -->

  <xsl:key name="defns_by_name" match="g:token
                             |g:production
                             |g:exprProduction/g:level/*"
    use="@name"/>

  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->

  <!-- Generate a comment that identifies as much as we can about the XSLT processor being used -->
  <xsl:template match="/">
    <xsl:variable name="XSLTprocessor">
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

  <!-- When processing the g:grammar as input, this template wraps the
       productions in a minimal xmlspec document. -->
  <xsl:template match="g:grammar">
    <spec>
      <header>
        <title>XPath/XQuery Grammar</title>
        <w3c-designation>Scratch Document</w3c-designation>
        <w3c-doctype>Scratch Document</w3c-doctype>
        <pubdate>
          <month>March</month>
          <year>2003</year>
        </pubdate>
        <publoc>http://www.w3.org/Style/XSL/Group/xpath2-tf/xpath-grammar.xml</publoc>
        <authlist>
          <author>
            <name>Scott Boag</name>
          </author>
        </authlist>
        <status><p>scratch</p></status>
        <abstract><p>dummy</p></abstract>
        <langusage><language>english</language></langusage>
        <revisiondesc><p>1.0</p></revisiondesc>
      </header>
      <body>
        <div1>
          <head>BNF</head>
          <scrap>
            <head>NAMED TERMINALS</head>
            <xsl:call-template name="add-terminals"/>
          </scrap>
          <scrap>
            <head>NON-TERMINALS</head>
            <xsl:call-template name="add-non-terminals"/>
          </scrap>
        </div1>
      </body>
    </spec>
  </xsl:template>

  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
  <!--
    This section includes the templates that are invoked from outside this
    stylesheet (marked with "EXPORT"), plus some of their "helper" templates.
  -->

  <!-- EXPORT -->
  <xsl:template name="show-defined-tokens">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type = 'literal-terminals'">
        <xsl:call-template name="show-literal-terminals"/>
      </xsl:when>
      <xsl:when test="$type = 'variable-terminals'">
        <xsl:call-template name="show-variable-terminals"/>
      </xsl:when>
      <xsl:when test="$type = 'complex-terminals'">
        <xsl:call-template name="show-complex-terminals"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="show-dt">
          <xsl:with-param name="type" select="$type"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>   
  </xsl:template>
  
  <xsl:template name="show-literal-terminals">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:variable name="ordinary-rules" select="$grammar//(g:production|g:exprProduction)[not(@whitespace-spec='explicit')][not(@show='no')]"/>
    <xsl:variable name="inline-tokens" select="$grammar//g:token[not(@inline='false')][not(@delimiter-type='hide')][@name=$ordinary-rules//g:ref/@name]"/>
    <xsl:variable name="tokens" select="distinct-values(($ordinary-rules|$inline-tokens)//g:string)"/>
    <xsl:for-each select="$tokens">
      <xsl:sort select="matches(., '[-A-Za-z]+')"/>
      <xsl:sort select="lower-case(.)"/>
      <code><xsl:value-of select="."/></code>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="show-variable-terminals">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:for-each select="Q{grammar2spec}variable-terminals($grammar)">
      <xsl:sort select="@name" lang="en"/>
      <xsl:choose>
        <xsl:when test="@name = 'NCName'">
          <code><xsl:value-of select="@name"/></code>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="prefix" select="'prod'"/>
          <!--<nt def="{$prefix}-{($grammar//g:language)[1]/@id}-{@name}"><xsl:value-of select="@name"/></nt>
          --><nt def="{$prefix}-{$spec}-{@name}"><xsl:value-of select="@name"/></nt>
        
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="show-complex-terminals">
    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>
    <xsl:variable name="variable-terminals" select="Q{grammar2spec}variable-terminals($grammar)"/>
    <xsl:variable name="ordinary-rules" select="$grammar//g:production[not(@whitespace-spec='explicit')][not(@show='no')]"/>
    <xsl:for-each select="Q{grammar2spec}variable-terminals($grammar)">
      <xsl:sort select="@name" lang="en"/>
      <xsl:variable name="indirect-references" select="Q{grammar2spec}transitive-closure(., 
        function($node){$grammar//g:production[@name = $node//g:ref/@name]}) except ."/>
      <!--<xsl:message select="@name || ': ' || string-join($indirect-references/@name, ', ')"></xsl:message>-->
      <xsl:if test="$indirect-references intersect $ordinary-rules">
        <!--<code><xsl:value-of select="@name"/></code>-->
        <xsl:variable name="prefix" select="if (@name = 'NCName') then 'doc' else 'prod'"/>
        <nt def="{$prefix}-{$spec}-{@name}"><xsl:value-of select="@name"/></nt>
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:function name="Q{grammar2spec}variable-terminals" as="node()*">
    <xsl:param name="grammar" as="document-node()"/>
    <xsl:variable name="ordinary-rules" select="$grammar//g:production
      [not(@whitespace-spec='explicit')]
      [not(@show='no')]"/>
    <xsl:variable name="unordinary-rules" select="$grammar//g:production[not(@exposition-name)] except $ordinary-rules"/>
    <xsl:variable name="inline-tokens" select="$grammar//g:token
      (:[not(@inline='false')]:)
      [not(@delimiter-type='hide')]
      [not(g:string and count(*)=1)]
      [@name=$ordinary-rules//g:ref/@name]"/>
    
    <xsl:sequence select="($unordinary-rules|$inline-tokens)[@name = $ordinary-rules//g:ref/@name]"/>
  </xsl:function>
  
  <xsl:function name="Q{grammar2spec}transitive-closure" as="node()*">
    <xsl:param name="start" as="node()*"/>
    <xsl:param name="step" as="function(node()) as node()*"/>
    <xsl:variable name="next-iteration" select="$start / $step(.)"/>
    <xsl:sequence select="if (empty($next-iteration except $start)) 
                          then $start 
                          else Q{grammar2spec}transitive-closure($start | $next-iteration, $step)"/>
  </xsl:function>

  <xsl:template name="show-dt">
    <xsl:param name="type"/>

    <xsl:variable name="fn"><xsl:call-template name="get-gfn"/></xsl:variable>
    <xsl:variable name="grammar" select="document($fn,.)"/>

    <xsl:for-each select="document($tokens-file,.)/token-list/token[@type = $type]">
      <xsl:sort select="@expo-name"/>
      <xsl:sort select="lower-case(.)"/>
      <xsl:choose>
        <xsl:when test="@expo-name and string-length(.) = 0">
          <xsl:variable name="expo-name" select="@expo-name"/>
          <xsl:for-each select="$grammar">
            <xsl:call-template name="add-nt-link">
              <xsl:with-param name="docprod_part" select="'prod-'"/>
              <xsl:with-param name="symbol_ename" select="$expo-name"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="c" select="substring(self::node(), 1, 1)"/>
          <code><xsl:value-of select="."/></code>
          <xsl:text> </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

  </xsl:template>

  <!-- ===================================================================== -->

  

  <!-- Try to apply a space-delimited list of references to tokens. -->
  <xsl:template name="apply-refs">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="string" select="''"/>
    <xsl:param name="delimiters" select="' &#x9;&#10;'"/>
    <xsl:param name="count" select="0"/>

    <xsl:variable name="delimiter" select="substring($delimiters, 1, 1)"/>

    <xsl:choose>
      <xsl:when test="not($delimiter)">
        <xsl:variable name="ref" select="(/g:grammar//g:ref[$string=@name]|/g:grammar//g:xref[$string=@name])[1]"/>
        <xsl:choose>
          <xsl:when test="$ref">
            <xsl:choose>
              <xsl:when test="$string=normalize-space('Prefix') or $string=normalize-space('LocalPart')">
                <!-- no action? -->
              </xsl:when>
              <xsl:when test="key('defns_by_name', $string)">
                <xsl:for-each select="$ref">
                  <xsl:call-template name="g:ref">
                    <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
                    <xsl:with-param name="docprod_part" select="'prod-'"/>
                    <xsl:with-param name="conn-cur" select="$conn-top"/>
                    <xsl:with-param name="conn-new" select="$conn-top"/>
                    <xsl:with-param name="show-no-shows" select="true()"/>
                  </xsl:call-template>
                </xsl:for-each>
                <!-- br/ -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:message>
                  <xsl:text>"</xsl:text>
                  <xsl:value-of select="$string"/>
                  <xsl:text>"</xsl:text>
                  <xsl:text> is not used in transition table!!!!</xsl:text>
                </xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- Note that in particular is can occur in the case of ExprCommentStart etc.,
                 where there is no other reference to it.  I can also occur in the case of
                 tokens that are not referenced by mistake.  There may be a way of testing
                 for this case.  -->
            <xsl:value-of select="$string"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:when>
      <xsl:when test="contains($string, $delimiter)">
        <xsl:if test="not(starts-with($string, $delimiter))">
          <xsl:call-template name="apply-refs">
            <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
            <xsl:with-param name="string" select="substring-before($string, $delimiter)"/>
            <xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
            <xsl:with-param name="count" select="$count+1"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="apply-refs">
          <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
          <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
          <xsl:with-param name="delimiters" select="$delimiters"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-refs">
          <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
          <xsl:with-param name="string" select="$string"/>
          <xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ===================================================================== -->

  <!-- EXPORT -->
  <xsl:template name="add-non-terminals">
    <xsl:for-each select="key('visible_nonterminal_defns', '')">
      <xsl:sort select="@name" lang="en"/>
      <xsl:call-template name="make-prod">
        <xsl:with-param name="id-generator" 
                        select="function($name) {'prod-' || $spec || '-' || $name}"/>
        <!--<xsl:with-param name="result_id_docprod_part" select="'prod-'"/>-->
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- EXPORT -->
  <xsl:template name="add-terminals">
    <xsl:param name="xml-only" select="false()"/>
    <xsl:param name="do-local-terminals" select="false()"/>

    <xsl:for-each select="key('visible_terminal_defns', '')[(@is-local-to-terminal-symbol='yes')=$do-local-terminals]">
      <xsl:if test="not($xml-only) or @is-xml='yes'">
        <xsl:call-template name="make-prod">
          <xsl:with-param name="id-generator" 
                        select="function($name) {'prod-' || $spec || '-' || $name}"/>
          <!--<xsl:with-param name="result_id_docprod_part" select="'prod-'"/>-->
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Show a "scrap": a production rule followed by selected production
       rules from its subtree. Changed (MHK, Jan 2025) to expand the subtree of
       productions automatically, rather than relying on all the desired
       `prodrecap` elements being listed explicitly in the source. -->
  
  <xsl:template name="show-prod">
    <!-- The production name -->
    <xsl:param name="name"/>
    <!-- A prefix, such as 'example-' to be added to the generated id to make it unique -->
    <xsl:param name="id-prefix" as="xs:string" tunnel="yes" select="''"/>

    <xsl:variable name="production" select="key('defns_by_name', $name)
                            [not(@alias-for and not(@inline='false'))]"/>

    <xsl:if test="not($production)">
      <xsl:message>
        WARNING!! production with name="<xsl:value-of select="$name"/>" not found
      </xsl:message>
    </xsl:if>
    
    <!-- Get all referenced productions, recursively, stopping at productions that
         have their own scrap elsewhere in the document -->
    
    <xsl:variable name="descendants" as="element(*)*">
      <xsl:apply-templates select="$production" mode="gather-sub-productions">
        <xsl:with-param name="subtree-root" select="$production" tunnel="yes"/>
        <xsl:with-param name="depth" select="0"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <!-- Eliminate duplicates -->
    
    <xsl:variable name="included-descendants" as="element(*)*">
       <xsl:for-each-group select="$descendants" group-by="@name">
         <xsl:sequence select="current-group()[1]"/>
       </xsl:for-each-group>
    </xsl:variable>

    <!-- Make the leading production rule -->
    <xsl:for-each select="$production">
      <xsl:call-template name="make-prod">
        <xsl:with-param name="id-generator" 
                        select="function($name) {$id-prefix || 'doc-' || $spec || '-' || $name}"/>
      </xsl:call-template>
    </xsl:for-each>
    
    <!-- Make the production rules for subsidiary rules in the grammar (in tree-walking order) -->
    <xsl:for-each select="$included-descendants[not(. is $production)]">
      <xsl:variable name="scrap-root-name" select="$name" as="xs:string"/>
      <xsl:call-template name="make-prod">
        <xsl:with-param name="id-generator" 
                        select="function($name) {$id-prefix || 'doc-' || $spec || '-' || $scrap-root-name || '-' || $name}"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Mode gather-sub-productions is used to recursively search for descendant productions
       to be included in a scrap. -->
  
  <xsl:mode name="gather-sub-productions" on-no-match="deep-skip"/>
  
  <xsl:template match="g:production | g:token[.//g:ref][not(@inline='true')][not(@is-xml='yes')]" mode="gather-sub-productions" as="element(*)*">
      <xsl:param name="subtree-root" as="element(*)" tunnel="yes"/>
      <xsl:param name="depth" as="xs:integer"/>
      <xsl:variable name="this" select="."/>

      <xsl:if test="$depth lt 6 and not(@if[not(contains(., $spec) or ($spec = 'shared'))])">
          <xsl:variable name="refs" as="xs:string*" 
                        select="$this//g:ref[not(@node-type='void')]/@name"/>
          <xsl:variable name="children" 
                        select="for $name in $refs 
                                return key('defns_by_name', $name, root($this))[not(@show='no')]"
                        as="element(*)*"/>
          <xsl:sequence select="$this"/>

          <xsl:variable name="descendants" as="element(*)*">
            <!-- Include children of this production if either (a) this is the top-level
                 production of a scrap, or (b) the children are not themselves top-level
                 productions in a different scrap -->
            <xsl:apply-templates select="$children[$depth eq 0 or not($this/@name = $prodrecaps/@ref)]"
                                 mode="#current">
              <xsl:with-param name="depth" select="$depth + 1"/>
            </xsl:apply-templates> 
          </xsl:variable>

          <xsl:sequence select="$descendants"/>
      </xsl:if>
  </xsl:template>
  
  <!--<xsl:template match="g:level/*" mode="gather-sub-productions" as="element(*)*">
      <xsl:param name="subtree-root" as="element(*)" tunnel="yes"/>
      <xsl:param name="depth" as="xs:integer"/>
      <xsl:variable name="this" select="."/>
      <xsl:if test="$depth lt 6">
          <xsl:variable name="refs" as="xs:string*" 
                select="$this/../following-sibling::g:level[1]/*/@name, 
                        $this//g:ref[not(@node-type='void')]/@name"/>
          <xsl:variable name="children" 
                        select="for $name in $refs 
                                return key('defns_by_name', $name, root($this))[not(@show='no')][@is-binary='yes' or not(@node-type='void')]"/>
          <xsl:sequence select="$this"/>
          <xsl:apply-templates select="$children[$depth eq 0 or not(@name = $prodrecaps/@ref)]"
                               mode="#current">
            <xsl:with-param name="depth" select="$depth + 1"/>
          </xsl:apply-templates>       
      </xsl:if>
  </xsl:template>-->
  
  <xsl:template match="g:token" mode="gather-sub-productions" as="element(*)?">
      <xsl:param name="subtree-root" as="element(*)" tunnel="yes"/>
      <xsl:param name="depth" as="xs:integer"/>
      <xsl:if test="$depth lt 10 and (child::g:charClass or $subtree-root[@whitespace-spec='explicit']) and not(@inline='true')">
         <xsl:sequence select="."/>
      </xsl:if>
  </xsl:template>
  
  <xsl:template match="g:ref[@unfold='yes']" mode="gather-sub-productions" as="element(*)?">
      <xsl:param name="subtree-root" as="element(*)" tunnel="yes"/>
      <xsl:param name="depth" as="xs:integer"/>
      <xsl:variable name="this" select="."/>
      <xsl:apply-templates select="key('defns_by_name', $this/@name)">
         <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
  </xsl:template>
  
  <!-- Make a production rule -->

  <xsl:template name="make-prod">
    <!-- A function to generate an ID for the production rule, given the production name -->
    <xsl:param name="id-generator" as="function(xs:string) as xs:string"/>
    <!-- A prefix to be used to make the ID unique, for example 'example-' -->
    <xsl:param name="id-prefix" as="xs:string" tunnel="yes" select="''"/>
    
    <xsl:variable name="base_language_id" select="$spec"/>
    <xsl:variable name="result_id_lang_part" select="concat($base_language_id, '-')"/>

    <xsl:text>&#xA;</xsl:text>
    <prod>
      <xsl:variable name="expo-name" select="if (@exposition-name) then @exposition-name else @name"/>     
      <xsl:variable name="result_id_symbol_part" select="$expo-name"/>
      
      <xsl:attribute name="id" select="$id-prefix || $id-generator($expo-name)"/>

      <xsl:call-template name="add-role-attribute"/>
      
      <lhs>
        <xsl:call-template name="add-role-attribute"/>
        <xsl:value-of select="$expo-name"/>
      </lhs>

      <rhs>
        <xsl:choose>
          <xsl:when test="@xhref">
            <xnt ref="{substring-after(@xhref, '#')}" spec="XML">
              <xsl:attribute name="spec">
                <xsl:choose>
                  <xsl:when test="contains(@xhref, 'REC-xml-names')">
                    <xsl:text>Names</xsl:text>
                  </xsl:when>
                  <xsl:when test="contains(@xhref, 'REC-xml#')">
                    <xsl:text>XML</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:message terminate="yes" expand-text="1"
                      >Can't figure out spec for: {@xhref}</xsl:message>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:text>[</xsl:text>
              <xsl:value-of select="@xhref"/>
              <xsl:text>]</xsl:text>
            </xnt>
          </xsl:when>

          <xsl:otherwise>
            <xsl:call-template name="wrap-with-rhs-group">
              <xsl:with-param name="wrapper-name" select="'rhs-group'"/>
              <xsl:with-param name="content">
                <xsl:apply-templates select="."/>
                <xsl:if test="@subtract-reg-expr">
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="@subtract-reg-expr"/>
                </xsl:if>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

      </rhs>

      <!--
        Production annotations.  Specifically:
          - extra-grammatical constraints (A.1.2),
          - grammar notes (A.1.3), and
          - whitespace annotations (A.2.4.2).

        In documents up to and including the 3.0 series,
        these annotations were omitted from the EBNF
        in the main body of the doc "to increase readability".

        But from 3.1 we show the annotations in the main body too.
        See Bug 29702.
      -->
      <xsl:if test="ends-with($base_language_id, '40') (: always true nowadays :)">
        <xsl:if test="@whitespace-spec">
          <xsl:call-template name="do-whitespace-comment"/>
        </xsl:if>
        <xsl:if test="@xgc-id">
          <!-- com -->
            <xsl:call-template name="apply-gns">
              <xsl:with-param name="string" select="@xgc-id"/>
              <xsl:with-param name="is-xgc" select="true()"/>
            </xsl:call-template>
          <!-- /com -->
        </xsl:if>
        <xsl:if test="@comment-id">
          <!-- com -->
            <xsl:call-template name="apply-gns">
              <xsl:with-param name="string" select="@comment-id"/>
            </xsl:call-template>
          <!-- /com -->
        </xsl:if>
      </xsl:if>
    </prod>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="make-absolute-nt-number">
    <!-- This is a leftover from when productions were numbered -->
    <!--
      Returns a number (positive integer or NaN).
    -->
    <xsl:param name="name" select="@ref"/>

    <xsl:choose>

      <xsl:when test="key('visible_terminal_defns_by_name', $name)">
        <xsl:for-each select="/g:grammar">
          <xsl:for-each select="key('visible_terminal_defns', '')">
            <xsl:if test="normalize-space(@name)=normalize-space($name)">
              <xsl:value-of select="position()+count(key('visible_nonterminal_defns', ''))"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>

      <xsl:when test="key('visible_nonterminal_defns_by_name', $name)">
        <xsl:for-each select="/g:grammar">
          <xsl:for-each select="key('visible_nonterminal_defns', '')">
            <xsl:if test="normalize-space(@name)=normalize-space($name)">
              <xsl:value-of select="position()"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>

      <xsl:otherwise>
        <xsl:message>
          template name="make-absolute-nt-number": No definition found for name '<xsl:value-of select="$name"/>'!
        </xsl:message>
        <xsl:value-of select="number('NaN')"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

  <xsl:template name="do-whitespace-comment">
    <com>
      <loc href="#ws-{@whitespace-spec}">
        <xsl:text>ws: </xsl:text>
        <xsl:value-of select="@whitespace-spec"/>
      </loc>
    </com>
  </xsl:template>

  <!-- Try and apply a space delimited list of references to tokens. -->
  <xsl:template name="apply-gns">
    <xsl:param name="string" select="''"/>
    <xsl:param name="delimiter" select="' '"/>
    <xsl:param name="count" select="0"/>
    <xsl:param name="is-xgc" select="false()"/>

    <xsl:choose>
      <xsl:when test="contains($string, $delimiter)">
        <xsl:variable name="token" select="substring-before($string, $delimiter)"/>
        <com>
          <loc href="#parse-note-{$token}">
            <xsl:text>gn: </xsl:text>
            <xsl:value-of select="$token"/>
          </loc>
        </com>
        <xsl:call-template name="apply-gns">
          <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
          <xsl:with-param name="delimiter" select="$delimiter"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$is-xgc">
        <!-- constraint def="parse-note-{$string}"/ -->
        <com>
          <loc href="#parse-note-{$string}">
            <xsl:text>xgs: </xsl:text>
            <xsl:value-of select="$string"/>
          </loc>
        </com>
      </xsl:when>
      <xsl:otherwise>
        <com>
          <loc href="#parse-note-{$string}">
            <xsl:text>gn: </xsl:text>
            <xsl:value-of select="$string"/>
          </loc>
        </com>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
  <!--
    This section includes "match" templates, arranged in a roughly top-down
    order.
  -->

  <xsl:template match="g:production">
    <xsl:param name="docprod_part"/>
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="exp-prod"
      select="/g:grammar/g:exposition-production[@name=$name]"/>
    <xsl:choose>
      <xsl:when test="$exp-prod and $docprod_part = 'doc-'">
        <xsl:for-each select="$exp-prod">
          <xsl:call-template name="g:group">
            <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
            <xsl:with-param name="conn-cur" select="$conn-top"/>
            <xsl:with-param name="docprod_part" select="$docprod_part"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="g:group">
          <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
          <xsl:with-param name="conn-cur" select="$conn-top"/>
          <xsl:with-param name="docprod_part" select="$docprod_part"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- -->

  <!--<xsl:template match="g:exprProduction">
    <xsl:param name="docprod_part"/>
    <xsl:for-each select="g:level[1]/*">
      <xsl:if test="position()!=1">
        <xsl:call-template name="linebreak"/>
        <xsl:text>|&nbsp;&nbsp;</xsl:text>
      </xsl:if>
      <xsl:call-template name="output-spec-based-next">
        <xsl:with-param name="docprod_part" select="$docprod_part"/>
        <xsl:with-param name="level-list" select=".. | ../following-sibling::g:level"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>-->

  <!--<xsl:template match="g:postfix">
    <xsl:param name="docprod_part"/>
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:variable name="left-name" select="(../following-sibling::g:level/*/@name)[1]"/>
    <xsl:call-template name="add-nt-link">
      <xsl:with-param name="docprod_part" select="if ($left-name = $prodrecaps/@ref) then 'doc-' else 'prod-'"/>
      <xsl:with-param name="symbol_ename" select="$left-name"/>
    </xsl:call-template>
    <xsl:text>&nbsp;</xsl:text>
    <xsl:text>(&nbsp;</xsl:text>
    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
      <xsl:with-param name="conn-cur" select="$conn-seq"/>
    </xsl:call-template>
    <xsl:text>&nbsp;)</xsl:text>

    <xsl:choose>
      <xsl:when test="@prefix-seq-type">
        <xsl:value-of select="@prefix-seq-type"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <!--<xsl:template match="g:prefix" name="g:prefix">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>
    <xsl:variable name="next-name" select="following-sibling::*/@name"/>
    <xsl:variable name="right-name" select="../following-sibling::g:level/*/@name"/>
    <xsl:variable name="should-paren" select="g:sequence"/>
    <xsl:if test="$should-paren">
      <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
      <xsl:with-param name="conn-cur" select="$conn-seq"/>
    </xsl:call-template>
    <xsl:if test="$should-paren">
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@prefix-seq-type">
        <xsl:value-of select="@prefix-seq-type"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&nbsp;</xsl:text>

    <xsl:call-template name="output-spec-based-next">
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
  </xsl:template>-->

  <!--<xsl:template match="g:binary">
    <xsl:param name="docprod_part"/>
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:call-template name="output-spec-based-next">
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
    <xsl:text>&nbsp;(&nbsp;</xsl:text>
    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
      <xsl:with-param name="conn-cur" select="$conn-seq"/>
    </xsl:call-template>
    <xsl:text>&nbsp;&nbsp;</xsl:text>
    <xsl:call-template name="output-spec-based-next">
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
    <xsl:text>&nbsp;)</xsl:text>
    <xsl:choose>
      <xsl:when test="@prefix-seq-type">
        <xsl:value-of select="@prefix-seq-type"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <!--<xsl:template match="g:primary">
    <xsl:param name="docprod_part"/>
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:variable name="is-not-last" select="boolean(../following-sibling::g:level)"/>
    <xsl:if test="$is-not-last">
      <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="conn-cur" select="$conn-top"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>

    <xsl:if test="$is-not-last">
      <xsl:text>) | </xsl:text>
      <xsl:call-template name="output-spec-based-next">
        <xsl:with-param name="docprod_part" select="$docprod_part"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>-->

  <!--<xsl:template match="g:next">
    <xsl:param name="docprod_part"/>
    <!-\- The assumption is this we're in a exprProduction,
         in a prefix, primary, etc., and want to call the next level. -\->
    <!-\- xsl:variable name="name" select="ancestor::g:exprProduction/@name"/ -\->
    <xsl:variable name="name" select="ancestor::g:level/following-sibling::g:level/*/@name"/>

    <xsl:call-template name="add-nt-link">
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
      <xsl:with-param name="symbol_ename" select="$name"/>
    </xsl:call-template>
  </xsl:template>-->

  <xsl:template match="g:token">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>

    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="conn-cur" select="$conn-top"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
 
  </xsl:template>

  <!-- -->

  <xsl:template match="g:choice">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>
    <xsl:param name="conn-cur" select="$conn-none"/>
    <xsl:param name="conn-new" select="$conn-seq"/>
    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
      <xsl:with-param name="conn-new" select="$conn-or"/>
      <xsl:with-param name="conn-cur" select="$conn-cur"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="g:sequence">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>
    <xsl:param name="conn-cur" select="$conn-none"/>
    <xsl:param name="conn-new" select="$conn-seq"/>

    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
      <xsl:with-param name="conn-new" select="$conn-seq"/>
      <xsl:with-param name="conn-cur" select="$conn-cur"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="g:optional">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>
    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
    <xsl:text>?</xsl:text>
  </xsl:template>

  <xsl:template match="g:zeroOrMore" expand-text="yes">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>

    <xsl:if test="@subtract-reg-expr or @separator">
      <xsl:text>(</xsl:text>
    </xsl:if>

    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
    
    <xsl:choose>
      <xsl:when test="@separator"> ** "{@separator}")</xsl:when>
      <xsl:otherwise>
        <xsl:text>*</xsl:text>
    
        <xsl:if test="@subtract-reg-expr">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="@subtract-reg-expr"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="g:oneOrMore" expand-text="yes">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>

    <xsl:if test="@subtract-reg-expr or @separator">
      <xsl:text>(</xsl:text>
    </xsl:if>

    <xsl:call-template name="g:group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="docprod_part" select="$docprod_part"/>
    </xsl:call-template>
    
    <xsl:choose>
      <xsl:when test="@separator"> ++ "{@separator}")</xsl:when>
      <xsl:otherwise>
        <xsl:text>+</xsl:text>
    
        <xsl:if test="@subtract-reg-expr">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="@subtract-reg-expr"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- -->

  <xsl:template match="g:complement">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:text>[^</xsl:text>
    <xsl:apply-templates select="g:charClass/*">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
    </xsl:apply-templates>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="g:charClass">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:variable name="isSeq" select="count(g:*)&gt;1 and (parent::g:oneOrMore or parent::g:zeroOrMore) and count(parent::*/*) = 1"/>
    <xsl:if test="$isSeq">
      <xsl:text>[</xsl:text>
    </xsl:if>
    <xsl:for-each select="g:*">

      <xsl:apply-templates select=".">
        <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      </xsl:apply-templates>

      <!-- xsl:if test="last() != position()"><xsl:text> |&nbsp;</xsl:text></xsl:if -->
    </xsl:for-each>
    <xsl:if test="$isSeq">
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="g:charClass[g:charRange]">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:variable name="isSeq"
      select="count(g:*)>1 and (parent::g:oneOrMore or parent::g:zeroOrMore) and count(parent::*/*) = 1"/>
    <xsl:text>[</xsl:text>
    <xsl:for-each select="g:*">

      <xsl:apply-templates select=".">
        <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      </xsl:apply-templates>

    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>


  <xsl:template match="g:charClass[count(g:char) > 1]">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:text>[</xsl:text>
    <xsl:for-each select="g:*">
      <!-- xsl:text>"</xsl:text -->
      <xsl:apply-templates select=".">
        <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="g:charCode">
    <xsl:text>#x</xsl:text>
    <xsl:value-of select="translate(@value, 'abcdef', 'ABCDEF')"/>
  </xsl:template>

  <xsl:template match="g:charCodeRange">
    <xsl:text>#x</xsl:text>
    <xsl:value-of select="translate(@minValue, 'abcdef', 'ABCDEF')"/>
    <xsl:text>-#x</xsl:text>
    <xsl:value-of select="translate(@maxValue, 'abcdef', 'ABCDEF')"/>
  </xsl:template>

  <xsl:template match="g:charRange">
    <xsl:value-of select="@minChar"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@maxChar"/>
  </xsl:template>

  <xsl:template match="g:sequence/g:char[not(@complement='yes')]">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:call-template name="wrap-with-rhs-group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="content">
        <xsl:call-template name="add-string"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="g:char">
    <xsl:if test="@complement='yes'">
      <xsl:text>~</xsl:text>
    </xsl:if>
    <!-- bit of a hack here... -->
    <xsl:if test="../@subtract-reg-expr">
      <xsl:text>(</xsl:text>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@force-quote='single'">
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:when test="@force-quote='double'">
        <xsl:text>"</xsl:text>
      </xsl:when>
    </xsl:choose>

    <xsl:value-of select="."/>

    <xsl:choose>
      <xsl:when test="@force-quote='single'">
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:when test="@force-quote='double'">
        <xsl:text>"</xsl:text>
      </xsl:when>
    </xsl:choose>


    <!-- bit of a hack here... -->
    <xsl:if test="../@subtract-reg-expr">
      <xsl:text> - </xsl:text>
      <xsl:value-of select="../@subtract-reg-expr"/>
      <xsl:text>)</xsl:text>
    </xsl:if>

  </xsl:template>

  <xsl:template match="g:emph">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- -->

  <xsl:template match="g:string">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:call-template name="wrap-with-rhs-group">
      <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
      <xsl:with-param name="content">
        <xsl:call-template name="add-string"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="g:ref|g:xref" name="g:ref">
    <xsl:param name="docprod_part"/>
    <xsl:param name="conn-cur" select="$conn-none"/>
    <xsl:param name="conn-new" select="$conn-seq"/>
    <xsl:param name="show-no-shows" select="false()"/>
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="tname" select="@name"/>

    <xsl:variable name="deref" select="key('defns_by_name', $tname)"/>

    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="$deref/@exposition-name">
          <xsl:value-of select="$deref/@exposition-name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$tname"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="needs-exposition-parens"
      select="@needs-exposition-parens='yes'"/>

    <xsl:if test="$show-no-shows or not(@show = 'no')">
      <xsl:if test="@subtract-reg-expr">
        <xsl:text>(</xsl:text>
      </xsl:if>

        <xsl:variable name="deref2" select="key('defns_by_name',$name)"/>
        <xsl:variable name="inlineable_token" select="$deref2[self::g:token and not(@inline='false')]"/>

        <xsl:choose>
          <xsl:when test="not($inlineable_token)">
            <xsl:call-template name="add-nt-link">
              <xsl:with-param name="docprod_part" select="if ($name = $prodrecaps/@ref) then 'doc-' else 'prod-'"/>
              <xsl:with-param name="symbol_ename" select="$name"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="wrap-with-rhs-group">
              <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
              <xsl:with-param name="content">
                <xsl:choose>
                  <xsl:when test="$needs-exposition-parens">
                    <xsl:text>(</xsl:text>
                  </xsl:when>
                </xsl:choose>
                <xsl:for-each select="$inlineable_token">
                  <xsl:call-template name="g:group">
                    <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
                    <xsl:with-param name="docprod_part" select="if ($name = $prodrecaps/@ref) then 'doc-' else 'prod-'"/>
                    <xsl:with-param name="conn-new" select="$conn-seq"/>
                    <xsl:with-param name="conn-cur" select="$conn-seq"/>
                  </xsl:call-template>
                </xsl:for-each>
                <xsl:choose>
                  <xsl:when test="$needs-exposition-parens">
                    <xsl:text>)</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>


      <!-- bit of a hack here... -->
      <xsl:if test="@subtract-reg-expr">
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@subtract-reg-expr"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
  <!--
    This section includes various low-level named templates.
  -->

  <xsl:variable name="conn-none" select="0"/>
  <xsl:variable name="conn-or" select="1"/>
  <xsl:variable name="conn-seq" select="2"/>
  <xsl:variable name="conn-top" select="3"/>

  <xsl:template name="g:group">
    <xsl:param name="wrapper-name" select="'rhs-group'"/>
    <xsl:param name="docprod_part"/>
    <xsl:param name="conn-cur" select="$conn-none"/>
    <xsl:param name="conn-new" select="$conn-seq"/>
    <xsl:variable name="isExpo" select="$docprod_part = 'doc-'"/>

    <xsl:variable name="group" select="*[not(@show='no')]"/>
    <xsl:choose>
      <xsl:when test="count($group)>1
          and $conn-new != $conn-cur
          and $conn-cur != $conn-top">
        <xsl:text>(</xsl:text>
        <xsl:call-template name="g:group">
          <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
          <xsl:with-param name="docprod_part" select="$docprod_part"/>
          <xsl:with-param name="conn-new" select="$conn-new"/>
          <xsl:with-param name="conn-cur" select="$conn-new"/>
        </xsl:call-template>
        <xsl:text>)</xsl:text>
      </xsl:when>
      <xsl:when test="count($group)>1">
        <xsl:for-each select="$group">
          <xsl:if test="position() != 1">
            <xsl:choose>
              <xsl:when test="$conn-new=$conn-seq"><xsl:text>&bsp;&bsp;</xsl:text></xsl:when>
              <xsl:when test="../@break[.='true']"><xsl:call-template name="linebreak"/>|&nbsp;&nbsp;</xsl:when>
              <xsl:otherwise><xsl:text>&bsp;&bsp;|&nbsp;&nbsp;</xsl:text></xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:apply-templates select=".">
            <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
            <xsl:with-param name="docprod_part" select="$docprod_part"/>
            <xsl:with-param name="conn-new" select="$conn-new"/>
            <xsl:with-param name="conn-cur" select="$conn-new"/>
          </xsl:apply-templates>
          <xsl:if test="not($isExpo)">
            <xsl:call-template name="add-lookahead-notation"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$group">
          <xsl:with-param name="wrapper-name" select="$wrapper-name"/>
          <xsl:with-param name="docprod_part" select="$docprod_part"/>
          <xsl:with-param name="conn-new" select="$conn-new"/>
          <xsl:with-param name="conn-cur" select="$conn-cur"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-lookahead-notation">
    <xsl:param name="lh" select="@lookahead"/>
    <xsl:param name="option" select="."/>
    <xsl:param name="choice" select="parent::g:choice"/>
    <xsl:if test="false() and $lh">
      <xsl:if test="not($choice) or not(generate-id($choice/*[position()=last()]) = generate-id($option))">
        <xsl:choose>
          <xsl:when test="$lh = 1">
            <sup>
              <xsl:text>CC</xsl:text>
            </sup>
          </xsl:when>
          <xsl:otherwise>
            <sup>
              <xsl:text>L</xsl:text>
              <xsl:value-of select="$lh"/>
            </sup>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="output-spec-based-next">
    <xsl:param name="docprod_part"/>
    <xsl:param name="level-list" select="../following-sibling::g:level"/>
    <xsl:param name="left-name" select="($level-list/*)[1]/@name"/>
    <xsl:choose>
      <xsl:when test="$left-name[1]/../@if[not(contains(., 'xquery') and contains(., 'xpath'))]
                      and $spec='shared'">
        <xsl:for-each select="$left-name[position() &lt; 3]">

          <xsl:variable name="which-spec">
            <xsl:choose>
              <xsl:when test="contains(../@if, 'xquery') and contains(../@if, 'xpath')">
                <xsl:choose>
                  <xsl:when test="position()=1">
                    <xsl:text>xquery</xsl:text>
                  </xsl:when>
                  <xsl:when test="position()=2">
                    <xsl:text>xpath</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(../@if, 'xquery')">
                <xsl:text>xquery</xsl:text>
              </xsl:when>
              <xsl:when test="contains(../@if, 'xpath')">
                <xsl:text>xpath</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="position()=1">
                    <xsl:text>xquery</xsl:text>
                  </xsl:when>
                  <xsl:when test="position()=2">
                    <xsl:text>xpath</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <!--
            Note that there isn't any reference to the variable just defined.
            Many years ago (in xpath-query-src/grammar2spec.xsl), it was
            (in effect) passed to the following invocation of 'add-nt-link'.
            Maybe that should be reinstated.
          -->

          <xsl:call-template name="add-nt-link">
            <!--<xsl:with-param name="docprod_part" select="$docprod_part"/>-->
            <xsl:with-param name="docprod_part" select="if (. = $prodrecaps/@ref) then 'doc-' else 'prod-'"/>                   
            <xsl:with-param name="symbol_ename" select="."/>
          </xsl:call-template>

          <xsl:if test="not(position()=last())">
            <xsl:text>&nbsp;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="add-nt-link">
          <!--<xsl:with-param name="docprod_part" select="$docprod_part"/>-->
          <xsl:with-param name="docprod_part" select="if (. = $prodrecaps/@ref) then 'doc-' else 'prod-'"/>                   
          <xsl:with-param name="symbol_ename" select="$left-name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-nt-link">
    <xsl:param name="docprod_part"/>
    <xsl:param name="symbol_ename"/>
    <xsl:param name="which-spec" select="ancestor-or-self::*[@if][1]/@if[contains(., $spec) or ($spec = 'shared')]"/>

    <xsl:if test="not($symbol_ename) or $symbol_ename=''">
      <xsl:message>In a call to add-nt-link, value passed to symbol_ename is empty!</xsl:message>
    </xsl:if>

    <!--
    <xsl:message>DEBUG: Starting template add-nt-link. </xsl:message>
    <xsl:message>DEBUG: ~~ $symbol_ename = <xsl:value-of select="$symbol_ename"/>. </xsl:message>
    <xsl:message>DEBUG: ~~ $spec = <xsl:value-of select="$spec"/>. </xsl:message>
    <xsl:message>DEBUG: ~~ $which-spec = <xsl:value-of select="local-name($which-spec)"/> and $which-spec/@if = <xsl:value-of select="$which-spec/@if"/>. </xsl:message>
    -->

    <nt>
      <!--
        Note that, for a specification that defines a language *extension*
        (e.g., Update or Full Text), /g:grammar/g:language will yield two
        (or more) element nodes, one for the base language and one for the
        extension. In such a case, /g:grammar/g:language/@id will also yield
        multiple nodes. Generally, it suffices to use the first, so we
        apply the predicate [1]. (With an XSLT 1.0 processor, the predicate
        wasn't necessary, since stringifying a node-set only stringifies
        the doc-order-first of its nodes.)
      -->
      <xsl:variable name="lang-id" select="$spec (:(/g:grammar/g:language/@id)[1]:)"/>
      <!--
      <xsl:message>DEBUG: ~~ $lang-id = <xsl:value-of select="$lang-id"/>. </xsl:message>
      -->

      <xsl:variable name="idref_lang_part" select="$lang-id || '-'"/>

      <xsl:variable name="docprod_part_adjusted">
        <xsl:choose>
          <xsl:when test="local-name(.) = 'xref' or $is-xslt30">
            <!--
              A reference to a symbol in another grammar.

              The assumptions seem to be that:
              (a) the other grammar does not appear in the appendix, so there
                  is no 'prod-' production for the referenced symbol, but
              (b) there is a 'doc-' production for it.
              So use 'doc-' instead of 'prod-' for the docprod_part.

              This is a hack for FS, whose formal-grammar.xml
              has the only uses of g:xref in qtspecs, and
              for which the above assumptions are partially true.
              
              Also use "doc-" for the XSLT 3.0 pattern grammar, which does
              not appear in an appendix.
            -->
            <xsl:text>doc-</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$docprod_part"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="idref_docprod_part">
        <xsl:choose>
          <xsl:when test="$docprod_part_adjusted = 'doc-'">
            <!-- Test to see if there is a prodrecap with this name.
                 If not, then link directly to the BNF in the
                 appendix.
                 -->
            <xsl:for-each select="$sourceTree">
              <xsl:choose>
                <xsl:when test="$prodrecaps[@id=$symbol_ename] or $is-xslt30">
                  <xsl:text>doc-</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>prod-</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>

          <xsl:otherwise>
            <!-- assert: $docprod_part_adjusted = 'prod-' -->
            <xsl:text>prod-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:attribute name="def">
        <xsl:value-of select="$idref_docprod_part"/>
        <xsl:value-of select="$idref_lang_part"/>
        <xsl:value-of select="$symbol_ename"/>
      </xsl:attribute>

      <xsl:call-template name="add-role-attribute">
        <xsl:with-param name="which-spec" select="$which-spec"/>
      </xsl:call-template>

      <xsl:value-of select="$symbol_ename"/>
      <xsl:comment expand-text="1">$idref_lang_part = {$idref_lang_part}</xsl:comment>
    </nt>
    <!--
    <xsl:message>DEBUG: Exiting template add-nt-link. </xsl:message>
    -->
  </xsl:template>

  <xsl:template name="wrap-with-rhs-group">
    <xsl:param name="content"/>
    <xsl:param name="wrapper-name" select="'rhs-group'"/>

    <xsl:choose>
      <xsl:when test="normalize-space($spec)!=normalize-space('shared')">
        <xsl:copy-of select="$content"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="which-spec"
          select="ancestor-or-self::*[@if][1]/@if[contains(., $spec)
                  or ($spec = 'shared')]"/>
        <xsl:choose>
          <xsl:when test="$which-spec and (contains($which-spec, 'xpath')
                          or contains($which-spec, 'xquery'))">
            <xsl:element name="{$wrapper-name}">
              <xsl:call-template name="add-role-attribute">
                <xsl:with-param name="which-spec" select="$which-spec"/>
              </xsl:call-template>
              <xsl:copy-of select="$content"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$content"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-role-attribute">
    <xsl:param name="which-spec" select="ancestor-or-self::*[@if][1]/@if[contains(., $spec) or ($spec = 'shared')]"/>
    <xsl:param name="default-class" select="''"/>

    <xsl:choose>
      <xsl:when test="$spec='shared'">
        <xsl:choose>
          <xsl:when test="$which-spec[ancestor::g:grammar]
                          and ((not(contains($which-spec, 'xpath')) and contains($which-spec, 'xquery'))
                          or  (not(contains($which-spec, 'xquery')) and contains($which-spec, 'xpath')))">
            <xsl:attribute name="role">
              <xsl:choose>
                <xsl:when test="contains($which-spec, 'xquery')">
                  <xsl:text>xquery</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>xpath</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <!-- xsl:attribute name="role">
              <xsl:text>shared</xsl:text>
            </xsl:attribute -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$default-class">
        <!-- xsl:attribute name="role">
          <xsl:value-of select="$default-class"/>
        </xsl:attribute -->
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-string">
    <xsl:choose>
      <xsl:when test="contains(.,'&quot;')">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:when test='contains(.,"&apos;")'>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="linebreak">
    <br/>
  </xsl:template>

</xsl:stylesheet>

