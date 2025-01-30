<?xml version="1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:f="http://www.w3.org/2016/local-functions"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               exclude-result-prefixes="xs f"
               version="2.0">

<!--
   ====================================================================== -->

  <xsl:preserve-space elements="*"/>

  <xsl:strip-space elements="
   abstract arg attribute authlist author back bibref blist body case col
   colgroup component constant constraint constraintnote copyright def
   definitions descr div div1 div2 div3 div4 div5 ednote enum enumerator
   example exception footnote front gitem glist graphic group header
   htable htbody inform-div1 interface issue item itemizedlist langusage
   listitem member method module note notice ol olist orderedlist orglist
   param parameters prod prodgroup prodrecap proto pubdate pubstmt raises
   reference resolution returns revisiondesc scrap sequence slist
   sourcedesc spec specref status struct table tbody tfoot thead tr
   typedef ul ulist union vc vcnote wfc wfcnote"/>

  <xsl:param name="validity.hacks" select="1"/>
  <xsl:param name="show.diff.markup.string" select="'0'" as="xs:string"/>
  <xsl:param name="show.diff.markup" select="xs:integer($show.diff.markup.string)" as="xs:integer"/>
  <xsl:param name="additional.css"/>
  <xsl:param name="additional.css.2"/>
<!-- 2010-12-23: Jim added the following inclusion of $additional.css.diff,
                 which will be non-empty only when diffs are being done -->
  <xsl:param name="additional.css.diff"/>
  <xsl:param name="additional.title"/>
  <xsl:param name="called.by.diffspec" select="0" as="xs:integer"/>
  <xsl:param name="show.ednotes" select="1"/>
  <xsl:param name="tabular.examples" select="0"/>
  <xsl:param name="toc.level" select="5"/>
  <xsl:param name="use-local-css" select="0"/>
  <xsl:param name="back.to.top.link" select="0"/>

  <xsl:param name="pull-request" select="()"/>
  <xsl:param name="branch-name" select="()"/>

  <xsl:key name="ids" match="*[@id]" use="@id"/>
  <xsl:key name="specrefs" match="specref" use="@ref"/>
  <xsl:key name="divids" match="div1|div2|div3|div4|div5|div6" use="@id"/>

<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />

<xsl:variable name="fo31" select="doc('../build/etc/FO31.xml')"/>

<!--
  <xsl:output method="html"
       encoding="utf-8"
       doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
       indent="no"/>
-->

  <!-- not handled:
    attribute:   unhandled IDL stuff
    case:        unhandled IDL stuff
    component:   unhandled IDL stuff
    constant:    unhandled IDL stuff
    copyright:   boilerplate notice always used instead
    definitions: unhandled IDL stuff
    descr:       unhandled IDL stuff
    enum:        unhandled IDL stuff
    enumerator:  unhandled IDL stuff
    exception:   unhandled IDL stuff
    group:       unhandled IDL stuff
    interface:   unhandled IDL stuff
    method:      unhandled IDL stuff
    module:      unhandled IDL stuff
    param:       unhandled IDL stuff
    parameters:  unhandled IDL stuff
    raises:      unhandled IDL stuff
    reference:   unhandled IDL stuff
    returns:     unhandled IDL stuff
    sequence:    unhandled IDL stuff
    struct:      unhandled IDL stuff
    typedef:     unhandled IDL stuff
    typename:    unhandled IDL stuff
    union:       unhandled IDL stuff

    Warning!
    Only handles statuses of NOTE, WD, and REC.
    -->

  <!-- Output a warning for unhandled elements! -->
  <xsl:template match="*">
    <xsl:message>
      <xsl:text>No template matches </xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>.</xsl:text>
    </xsl:message>

    <span style="font-color:red" disallowed="fix-this"> <!-- Deliberately invalid HTML, to be picked up if anyone tries to publish this -->
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>

  <!-- Template for the root node.  Creation of <html> element could
       go here, but that doesn't feel right. -->
  <xsl:template match="/">
    <xsl:if test="//prod[@num] and //prod[not(@num)]">
      <xsl:message terminate="yes">
        <xsl:text>Manually and automatically numbered productions </xsl:text>
        <xsl:text>cannot coexist.</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:comment>
      <xsl:text>{xmlspec} </xsl:text>
      <xsl:text>XSLT Processor: </xsl:text>
      <xsl:value-of select="system-property('xsl:vendor')"/>
      <xsl:if test="system-property('xsl:version') = '2.0'">
        <xsl:value-of select="system-property('xsl:product-name')"/>
        <xsl:value-of select="system-property('xsl:product-version')"/>
      </xsl:if>
<!--
      <xsl:comment>$show.diff.markup = <xsl:value-of select="$show.diff.markup"/></xsl:comment>
      <xsl:message>$show.diff.markup = <xsl:value-of select="$show.diff.markup"/></xsl:message>
-->
    </xsl:comment>
  </xsl:template>

  <!-- abstract: appears only in header -->
  <!-- format as a second-level div -->
  <!-- called in enforced order from header's template -->
  <xsl:template match="abstract">
    <div>
      <xsl:text>&#10;</xsl:text>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'abstract'"/>
        </xsl:call-template>
        <xsl:text>Abstract</xsl:text>
      </h2>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- affiliation: follows a name in author and member -->
  <!-- put it in parens with a leading space -->
  <xsl:template match="affiliation">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- arg: appears only in proto -->
  <!-- argument in function prototype -->
  <!-- output argument type, italicized as placeholder; separate the
       list with commas and spaces -->
  <xsl:template match="arg">
    <xsl:if test="preceding-sibling::arg">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <var>
      <xsl:value-of select="@type"/>
    </var>
    <xsl:if test="@occur = 'opt'">
      <xsl:text>?</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- att: attribute name -->
  <!-- used lots of places -->
  <!-- format as monospaced code -->
  <xsl:template match="att">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- attribute: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- attval: attribute name -->
  <!-- used lots of places -->
  <!-- format as quoted string -->
  <xsl:template match="attval">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <!-- authlist: list of authors (editors, really) -->
  <!-- called in enforced order from header's template, in <dl>
       context -->
  <xsl:template match="authlist">
    <dt>
      <xsl:text>Editor</xsl:text>
      <xsl:if test="count(author) > 1">
        <xsl:text>s</xsl:text>
      </xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- author: an editor of a spec -->
  <!-- only appears in authlist -->
  <!-- called in <dl> context -->
  <xsl:template match="author">
    <!--
    <xsl:comment>xmlspec, match="author"</xsl:comment>
    -->
    <dd>
      <xsl:apply-templates/>
      <xsl:if test="@role = '2e'">
        <xsl:text> - Second Edition</xsl:text>
      </xsl:if>
    </dd>
  </xsl:template>

  <!-- back: back matter for the spec -->
  <!-- make a <div> for neatness -->
  <!-- affects numbering of div1 children -->
  <xsl:template match="back">
    <div class="back">
      <xsl:apply-templates/>
      <xsl:call-template name="autogenerated-appendices"/>
    </div>
  </xsl:template>

  <!-- bibl: bibliographic entry -->
  <!-- only appears in blist -->
  <!-- called with <dl> context -->
  <!-- if there's a key, use it in the <dt>, otherwise use the ID -->
  <!-- if there's an href, add a ref in parens at the end of the text -->
  <xsl:template match="bibl">
    <dt class="label">
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
    </dt>
    <dd>
      <xsl:apply-templates/>
      <xsl:if test="@href">
        <xsl:text>  (See </xsl:text>
        <xsl:value-of select="@href"/>
        <xsl:text>.)</xsl:text>
      </xsl:if>
    </dd>
  </xsl:template>

  <!-- bibref: reference to a bibliographic entry -->
  <!-- make a link to the bibl -->
  <!-- if the bibl has a key, put it in square brackets; otherwise use
       the bibl's ID -->
  <xsl:template match="bibref">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @ref)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:choose>
        <xsl:when test="key('ids', @ref)/@key">
          <xsl:value-of select="key('ids', @ref)/@key"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ref"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </a>
  </xsl:template>

  <!-- blist: list of bibliographic entries -->
  <!-- set up the list and process children -->
  <xsl:template match="blist">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <!-- bnf: un-marked-up BNF productions -->
  <!-- preformatted within a table cell -->
  <!-- scrap provides <table> context -->
  <xsl:template match="bnf">
    <tbody>
      <tr>
        <td>
          <xsl:if test="@diff and $show.diff.markup != 0">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <pre>
            <xsl:apply-templates/>
          </pre>
        </td>
      </tr>
    </tbody>
  </xsl:template>

  <!-- body: the meat of the spec -->
  <!-- create a TOC and then go to work -->
  <!-- (don't forget the TOC for the back matter and a pointer to end
       notes) -->
  <xsl:template match="body">
    <xsl:if test="$toc.level &gt; 0">
      <nav id="toc">
        <xsl:text>&#10;</xsl:text>
        <xsl:call-template name="finder"/> <!-- Used for F+O spec -->
        <h2>
          <xsl:call-template name="anchor">
            <xsl:with-param name="conditional" select="0"/>
            <xsl:with-param name="default.id" select="'contents'"/>
          </xsl:call-template>
          <xsl:text>Table of Contents</xsl:text>
          <span class="expalltoc collapsed">&#x2009;▶</span>
        </h2>
        <ol class="toc">
          <xsl:apply-templates select="div1|../back/inform-div1|../back/div1" mode="toc"/>
          <xsl:call-template name="autogenerated-appendices-toc"/>
        </ol>

        <xsl:if test="//footnote[not(ancestor::table)]">
          <p class="toc">
            <a href="#endnotes">
              <xsl:text>End Notes</xsl:text>
            </a>
          </p>
        </xsl:if>
      </nav>
      <hr/>
    </xsl:if>
    <div class="body">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template name="finder">
    <!-- overridden in F+O spec -->
  </xsl:template>

  <xsl:template name="autogenerated-appendices">
    <!-- there are none by default -->
  </xsl:template>

  <xsl:template name="autogenerated-appendices-toc">
    <!-- there are none by default -->
  </xsl:template>

  <!-- caption: see table -->

  <!-- case: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- code: generic computer code -->
  <!-- output as HTML <code> for monospaced formatting -->
  <xsl:template match="code">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- col: see table -->

  <!-- colgroup: see table -->

  <!-- com: formal production comment -->
  <!-- can appear in prod or rhs -->
  <xsl:template match="com">   
    <td style="text-align: right;" class="prodComment">
        <xsl:text>/* </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> */</xsl:text>
    </td>     
  </xsl:template>

  <!-- constraint: a note in a formal production -->
  <!-- refers to a constraint note -->
  <xsl:template match="constraint">
    <!-- MHK 2024-09-14 - this is not used -->
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="@diff and $show.diff.markup != 0">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>[Constraint: </xsl:text>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr style="vertical-align:baseline;">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="@diff and $show.diff.markup != 0">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="@diff"/>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="key('ids', @def)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>[Constraint: </xsl:text>
              <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
              <xsl:text>]</xsl:text>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- constraintnote: note constraining a formal production -->
  <!-- see also constraintnote/head -->
  <xsl:template match="constraintnote">
    <div class="constraint">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- copyright: notice for this document-->
  <!-- right now, a boilerplate copyright notice is inserted by the
       template for header; this may need to be changed -->

  <!-- day: day of month of spec -->
  <!-- only used in pudate; called directly from header template -->
  <xsl:template match="day">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- def: glossary definition -->
  <!-- already in <dl> context from glist -->
  <xsl:template match="def">
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- definitions: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- descr: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- div[n]: structural divisions -->
  <!-- make an HTML div -->
  <!-- see also div[n]/head -->
  <xsl:template match="div1|div2|div3|div4|div5">
    <xsl:variable name="class" select="local-name(.)"/>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@role">
            <xsl:sequence select="$class || ' ' || @role"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$class"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- ednote: editors' note -->
  <xsl:template match="ednote">
    <xsl:if test="$show.ednotes != 0">
      <table class="ednote">
        <xsl:attribute name="caption">
          <xsl:text>Editorial note</xsl:text>
          <xsl:if test="name">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="name"/>
          </xsl:if>
        </xsl:attribute>
        <tr>
          <td style="text-align: left; vertical-align:top; width: 50%;">
            <b>
              <xsl:text>Editorial note</xsl:text>
              <xsl:if test="name">
                <xsl:text>: </xsl:text>
                <xsl:apply-templates select="name"/>
              </xsl:if>
            </b>
          </td>
          <td style="text-align: right; vertical-align:top; width: 50%;">
            <xsl:choose>
              <xsl:when test="date">
                <xsl:apply-templates select="date"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
         <tr style="text-align: left; vertical-align: top;">
          <td colspan="2">
            <xsl:apply-templates select="edtext"/>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="date">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="edtext">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- edtext: text of an editors' note -->
  <!-- ednote is currently hidden -->

  <!-- el: an XML element -->
  <!-- present as preformatted text, no markup -->
  <!-- Chris's personal preference is to put pointy-brackets around
       this, but he seems to be in the minority -->
  <xsl:template match="el">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <!-- email: an email address for an editor -->
  <!-- only occurs in author -->
  <xsl:template match="email">
    <xsl:text> </xsl:text>
    <a href="{@href}">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&gt;</xsl:text>
    </a>
  </xsl:template>

  <!-- emph: in-line emphasis -->
  <!-- equates to HTML <em> -->
  <!-- the role attribute could be used for multiple kinds of
       emphasis, but that would not be kind -->
  <xsl:template match="emph">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="quote/emph">
    <em><xsl:apply-templates/></em>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- rfc2119: identifies RFC 2119 keywords -->
  <xsl:template match="rfc2119">
    <span class="verb"><xsl:value-of select="lower-case(.)"/></span>
  </xsl:template>

  <!-- enum: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- enumerator: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- example: what it seems -->
  <!-- block-level with title -->
  <!-- see also example/head -->
  <xsl:template match="example">
    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="$tabular.examples = 0">exampleOuter</xsl:when>
        <xsl:otherwise>example</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{$class}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="example/head">
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="$tabular.examples = 0">
        <div class="exampleHeader">
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select=".."/>
            <xsl:with-param name="conditional" select="0"/>
          </xsl:call-template>
          <xsl:if test="not(starts-with(., 'Example:') or starts-with(., 'Examples:'))">
            <xsl:text>Example: </xsl:text>
          </xsl:if>
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <h5>
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select=".."/>
            <xsl:with-param name="conditional" select="0"/>
          </xsl:call-template>

          <xsl:if test="not(starts-with(., 'Example:') or starts-with(., 'Examples:'))">
            <xsl:text>Example: </xsl:text>
          </xsl:if>
          <xsl:apply-templates/>
        </h5>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- eg: a literal example -->
  <!-- present as preformatted text -->
  <xsl:template match="eg">
    <xsl:param name="pre.class" select="()" as="xs:string?"/>
    <xsl:variable name="content">
      <xsl:call-template name="anchor"/>
      <pre>
        <xsl:if test="$pre.class">
          <xsl:attribute name="class" select="$pre.class"/>
        </xsl:if>
        <xsl:if test="@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="@diff"/>
          </xsl:attribute>
        </xsl:if>

        <!-- Remove trailing whitespace if we can... -->
        <xsl:apply-templates select="node()[position() lt last()]"/>
        <xsl:variable name="last-node" select="node()[last()]"/>
        <xsl:choose>
          <xsl:when test="$last-node/self::text()">
            <xsl:value-of select="replace($last-node, '\s+$', '')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$last-node"/>
          </xsl:otherwise>
        </xsl:choose>
      </pre>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$tabular.examples = 0">
        <div class="exampleInner">
          <xsl:copy-of select="$content"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <table class="eg" cellpadding="5" border="1"
               bgcolor="#99ffff" width="100%">
          <caption>Example</caption>
          <tr>
            <td>
              <xsl:copy-of select="$content"/>
            </td>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- exception: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- footnote: format as endnote, actually -->
  <xsl:template match="footnote">
    <xsl:variable name="this-note-id">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <sup>
      <xsl:text>[</xsl:text>
      <a id="FN-ANCH-{$this-note-id}"
         href="#{$this-note-id}">
        <xsl:apply-templates select="." mode="number-simple"/>
      </a>
      <xsl:text>]</xsl:text>
    </sup>
  </xsl:template>

  <!-- front: front matter for the spec -->
  <!-- make a div for cleanliness -->
  <xsl:template match="front">
    <div class="front">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- This stylesheet gets loaded while constructing the inputs for database.xml.
       We make that not raise an error; the cross reference is unnecessary. -->
  <xsl:variable name="database"
                as="document-node()?"
                select="if (doc-available('../build/etc/database.xml'))
                        then doc('../build/etc/database.xml')
                        else ()"/>
  <xsl:variable name="FO40uri" select="'https://qt4cg.org/specifications/xpath-functions-40/'"/>
  <xsl:variable name="XT40uri" select="'https://qt4cg.org/specifications/xslt-40/'"/>

  <!-- Function: name of a function -->
  <!-- format as HTML <code> for monospaced presentation -->
  <xsl:template match="function[empty($database)] | xfunction[empty($database)]"
                priority="10">
    <code>
      <xsl:apply-templates/>
    </code>
  </xsl:template>

  <xsl:template match="function|xfunction">
    <xsl:variable name="fid" select="normalize-space(.)"/>
    <xsl:variable name="fname"
                  select="if (contains($fid, '#')) then substring-before($fid, '#') else $fid"/>
    <xsl:variable name="prefix"
                  select="if (contains($fname, ':')) then substring-before($fname, ':') else 'fn'"/>
    <xsl:variable name="name"
                  select="if (contains($fname, ':')) then substring-after($fname, ':') else $fname"/>

    <xsl:variable name="id-prefix" as="xs:string">
      <xsl:choose>
        <xsl:when test="$prefix = 'fn'">func-</xsl:when>
        <xsl:when test="$prefix = 'array'">func-array-</xsl:when>
        <xsl:when test="$prefix = 'map'">func-map-</xsl:when>
        <xsl:when test="$prefix = 'math'">func-math-</xsl:when>
        <xsl:when test="$prefix = 'op'">func-op-</xsl:when>
        <xsl:otherwise>
          <xsl:message select="'Unexpected function prefix: ' || $prefix || ':'"/>
          <xsl:sequence select="'func-'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="targets" select="key('divids', $id-prefix || $name, $database)"/>
    <xsl:variable name="target"
                  select="($targets[ancestor::document-summary/@uri = $FO40uri],
                           $targets[ancestor::document-summary/@uri = $XT40uri])[1]"/>
    <xsl:variable name="target-uri" select="$target/ancestor::document-summary/@uri/string()"/>

    <xsl:choose>
      <xsl:when test="empty($target-uri)">
        <xsl:message select="'Cannot find unique function: ' || $prefix || ':' || $name"/>
        <xsl:for-each select="$target" expand-text="yes">
          <xsl:message>   {ancestor::document-summary/@uri/string()}</xsl:message>
        </xsl:for-each>
        <code><xsl:apply-templates/></code>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="spec" select="tokenize($target-uri, '/')[last() - 1]"/>
        <xsl:variable name="same-spec"
                      select="contains(base-uri(.), '/'||$spec||'/')"/>
        <a href="{if ($same-spec) then '' else $target-uri||'Overview.html'}#{$id-prefix}{$name}">
          <code>
            <xsl:apply-templates/>
          </code>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--
  <xsl:variable name="fname" select="string(.)"/>
  <xsl:variable name="link" select="translate(if (contains($fname, '#')) then substring-before($fname, '#') else $fname, ':', '-')"/>  
  <a href="#func-{$link}"><code><xsl:apply-templates/></code></a>
</xsl:template>
-->

  <!-- gitem: glossary list entry -->
  <!-- just pass children through for <dd>/<dt> formatting -->
  <xsl:template match="gitem">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- glist: glossary list -->
  <!-- create <dl> and handle children -->
  <xsl:template match="glist">
    <xsl:if test="$validity.hacks = 1 and local-name(..) = 'p'">
      <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
    </xsl:if>
    <dl>
      <xsl:apply-templates/>
    </dl>
    <xsl:if test="$validity.hacks = 1 and local-name(..) = 'p'">
      <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- graphic: external illustration -->
  <!-- reference external graphic file with alt text -->
  <xsl:template match="graphic">
    <img src="{@source}">
      <xsl:if test="@alt">
        <xsl:attribute name="alt">
          <xsl:value-of select="@alt"/>
        </xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <!-- group: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- head: title for a variety of constructs -->

  <!-- constraintnotes have different types, but they're
       non-enumerated; nothing is done with them right now -->
  <xsl:template match="constraintnote/head">
    <p class="prefix">
      <xsl:if test="../@id">
        <a id="{../@id}"/>
      </xsl:if>
      <b><xsl:text>Constraint: </xsl:text><xsl:apply-templates/></b>
    </p>
  </xsl:template>

  <xsl:template match="div1/head">
    <xsl:text>&#10;</xsl:text>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="div2/head">
    <xsl:text>&#10;</xsl:text>
    <h3>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>

  <xsl:template match="div3/head">
    <xsl:text>&#10;</xsl:text>
    <h4>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>

  <xsl:template match="div4/head">
    <xsl:text>&#10;</xsl:text>
    <h5>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h5>
  </xsl:template>

  <xsl:template match="div5/head">
    <xsl:text>&#10;</xsl:text>
    <h6>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
    </h6>
  </xsl:template>

  <xsl:template match="inform-div1/head">
    <xsl:text>&#10;</xsl:text>
    <h2>
      <xsl:call-template name="anchor">
        <xsl:with-param name="conditional" select="0"/>
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates select=".." mode="divnum"/>
      <xsl:apply-templates/>
      <xsl:text> (Non-Normative)</xsl:text>
    </h2>
  </xsl:template>
  
  <xsl:template match="div1/head/text() | div2/head/text() | div3/head/text() | div4/head/text() | inform-div1/head/text()">
    <!-- insert a link to self, to make the ID value visible for the benefit of anyone wanting to create a link -->
    <a href="#{../../@id}" style="text-decoration: none">
      <xsl:next-match/>
    </a>
  </xsl:template>

  <xsl:template match="issue/head">
    <p class="prefix">
      <b><xsl:apply-templates/></b>
    </p>
  </xsl:template>
  
  <xsl:template match="scrap/head[child::node()]">
    <xsl:text>&#10;</xsl:text>
    <h5>
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select=".."/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </h5>   
  </xsl:template>

  <xsl:template match="scrap/head[not(child::node())]">
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select=".."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="vcnote/head">
    <p class="prefix">
      <xsl:if test="../@id">
        <a id="{../@id}"/>
      </xsl:if>
      <b><xsl:text>Validity constraint: </xsl:text><xsl:apply-templates/></b>
    </p>
  </xsl:template>

  <xsl:template match="wfcnote/head">
    <p class="prefix">
      <xsl:if test="../@id">
        <a id="{../@id}"/>
      </xsl:if>
      <b><xsl:text>Well-formedness constraint: </xsl:text><xsl:apply-templates/></b>
    </p>
  </xsl:template>

  <!-- header: metadata about the spec -->
  <!-- pull out information into standard W3C layout -->
  <xsl:template match="header">
    <div class="head">
      <xsl:if test="not(/spec/@role='editors-copy')">
        <p>
          <a href="https://www.w3.org/">
            <img src="https://www.w3.org/StyleSheets/TR/2016/logos/W3C"
              alt="W3C" height="48" width="72"/>
          </a>
	  <xsl:choose>
	    <xsl:when test="/spec/@w3c-doctype='memsub'">
	      <a href='https://www.w3.org/Submission/'>
		<img alt='Member Submission'
		     src='https://www.w3.org/Icons/member_subm'/>
	      </a>
	    </xsl:when>
	    <xsl:when test="/spec/@w3c-doctype='teamsub'">
	      <a href='https://www.w3.org/2003/06/TeamSubmission'>
		<img alt='Team Submission'
		     src='https://www.w3.org/Icons/team_subm'/>
	      </a>
	    </xsl:when>
	  </xsl:choose>
        </p>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
      <h1>
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="title[1]"/>
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'title'"/>
        </xsl:call-template>

        <xsl:apply-templates select="title"/>
        <xsl:if test="version">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="version"/>
        </xsl:if>
      </h1>
      <xsl:if test="subtitle">
        <xsl:text>&#10;</xsl:text>
        <h2>
          <xsl:call-template name="anchor">
            <xsl:with-param name="node" select="subtitle[1]"/>
            <xsl:with-param name="conditional" select="0"/>
            <xsl:with-param name="default.id" select="'subtitle'"/>
          </xsl:call-template>
          <xsl:apply-templates select="subtitle"/>
        </h2>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="w3c-doctype[1]"/>
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'w3c-doctype'"/>
        </xsl:call-template>

        <xsl:apply-templates select="w3c-doctype"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="pubdate"/>
      </h2>
      <dl>
        <xsl:apply-templates select="publoc"/>
        <xsl:apply-templates select="latestloc"/>
        <xsl:apply-templates select="prevlocs"/>
        <xsl:apply-templates select="latestloc-major"/>
        <xsl:apply-templates select="latestloc-tech"/>
        <xsl:apply-templates select="prevrec"/>
        <xsl:apply-templates select="authlist"/>
      </dl>

      <!-- output the errataloc and altlocs -->
      <xsl:apply-templates select="errataloc"/>
      <xsl:apply-templates select="preverrataloc"/>
      <xsl:apply-templates select="translationloc"/>
      <xsl:apply-templates select="altlocs"/>

      <xsl:choose>
        <xsl:when test="copyright">
          <xsl:apply-templates select="copyright"/>
        </xsl:when>
        <xsl:otherwise>
          <p class="copyright">
            <a href="https://www.w3.org/Consortium/Legal/ipr-notice#Copyright">
              <xsl:text>Copyright</xsl:text>
            </a>
            <xsl:text>&#xa0;&#xa9;&#xa0;</xsl:text>
            <xsl:apply-templates select="pubdate/year"/>
            <xsl:text>&#xa0;</xsl:text>
            <a href="https://www.w3.org/">
              <abbr title="World Wide Web Consortium">W3C</abbr>
            </a>
            <sup>&#xae;</sup>
            <xsl:text> (</xsl:text>
            <a href="https://www.csail.mit.edu/">
              <abbr title="Massachusetts Institute of Technology">MIT</abbr>
            </a>
            <xsl:text>, </xsl:text>
            <a href="https://www.ercim.eu/">
              <abbr title="European Research Consortium for Informatics and Mathematics">ERCIM</abbr>
            </a>
            <xsl:text>, </xsl:text>
            <a href="https://www.keio.ac.jp/">Keio</a>
            <xsl:text>, </xsl:text>
            <a href="http://ev.buaa.edu.cn/">Beihang</a>
<!--            <xsl:text>), All Rights Reserved. W3C </xsl:text>   -->
            <xsl:text>). W3C </xsl:text>
            <a href="https://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>
            <xsl:text>, </xsl:text>
            <a href="https://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a>
            <xsl:text> and </xsl:text>
            <a href="https://www.w3.org/Consortium/Legal/copyright-documents">document use</a>
            <xsl:text> rules apply.</xsl:text>
          </p>
        </xsl:otherwise>
      </xsl:choose>
      <hr/>
    </div>
    <xsl:apply-templates select="notice"/>
    <xsl:apply-templates select="abstract"/>
    <xsl:apply-templates select="status"/>
    <xsl:apply-templates select="revisiondesc"/>
  </xsl:template>

  <xsl:template match="pubdate">
    <xsl:choose>
      <xsl:when test="empty(*) or (day='01' and month='January' and year='2000')">
        <xsl:sequence select="format-dateTime(current-dateTime(), '[D1] [MNn] [Y0000]')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="day">
          <xsl:apply-templates select="day"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="month"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="year"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="revisiondesc">
    <!-- suppressed by default -->
  </xsl:template>

  <xsl:template match="copyright">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="copyright/p">
    <p class="copyright">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- inform-div1: non-normative back matter top-level division -->
  <!-- treat like div1 except add "(Non-Normative)" to title -->
  <xsl:template match="inform-div1">
    <div class="div1">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- interface: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- issue: open issue before the Working Group -->
  <!-- maintain an ID for linking to it -->
  <!-- currently generates boilerplate head plus optional head child
       element; this should probably be cleaned up to only use the
       head if it's present -->
  <xsl:template match="issue">
    <div class="issue">
      <p class="prefix">
        <xsl:if test="@id">
          <a id="{@id}"/>
        </xsl:if>
        <b>
          <xsl:text>Issue (</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>):</xsl:text>
        </b>
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

  <!-- item: generic list item -->
  <xsl:template match="item">
    <li>
      <xsl:if test="@role">
        <xsl:attribute name="class" select="@role"/>
      </xsl:if>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- kw: keyword -->
  <!-- make it bold -->
  <xsl:template match="kw">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <!-- label: term for defintion in glossary entry -->
  <!-- already in <dl> context from glist -->
  <xsl:template match="label">
    <dt class="label">
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
      <xsl:call-template name="anchor"/>

      <xsl:apply-templates/>
    </dt>
  </xsl:template>

  <!-- language: -->
  <!-- langusage: -->
  <!-- identify language usage within a spec; not actually formatted -->

  <!-- latestloc: latest location for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="latestloc">
    <dt>Latest version:</dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- lhs: left-hand side of formal productions -->
  <!-- make a table row with the lhs and the corresponding other
       pieces in this crazy mixed-up content model -->
  <xsl:template match="lhs">
    
      <!--<td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="../@id">
          <a id="{../@id}"/>
        </xsl:if>
        <xsl:apply-templates select="ancestor::prod" mode="number"/>
<!-\-
  This could be done right here, but XT goes into deep space when the
  node to be numbered isn't the current node and level="any":
          <xsl:number count="prod" level="any" from="spec"
            format="[1]"/>
  -\->
        <!-\-<xsl:text>&#xa0;&#xa0;&#xa0;</xsl:text>-\->
      </td>-->
      <td>
        <xsl:if test="../@id">
          <a id="{../@id}"/>
        </xsl:if>
        <!--<xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>-->

        <xsl:variable name="id-parts" select="tokenize(../@id, '-')"/>
        <xsl:choose>
          <!-- For a principal production in the document body, make a link to the appendix ... -->
          <xsl:when test="$id-parts[1] = 'doc'
                          and id('prod-' || substring-after(../@id,'doc-'))">
            <code>
              <a href="#prod-{substring-after(../@id, 'doc-')}">
                <xsl:apply-templates/>
              </a>
            </code>
          </xsl:when>
          <!-- For a subsidiary production in the document body, make a link to the appendix ... -->
          <xsl:when test="$id-parts[1] = 'doc'
                          and $id-parts[3] = ../../prod[1]/lhs[1]
                          and id('prod-' || $id-parts[2] || '-' || string(.))">
            <!-- for example: doc-xpath40-SequenceType-ItemType links to prod-xpath40-ItemType -->
            <code>
              <a href="#prod-{$id-parts[2]}-{.}">
                <xsl:apply-templates/>
              </a>
            </code>
          </xsl:when>
          <!-- For a production in the appendix corresponding to a principal production in the
            document body, make a link to the inline version ... -->
          <xsl:when test="starts-with(../@id,'prod-')
                          and id(concat('doc-',substring-after(../@id,'prod-')))">
            <code>
              <a href="#{concat('doc-',substring-after(../@id,'prod-'))}">
                <xsl:apply-templates/>
              </a>
            </code>
          </xsl:when>
          <xsl:otherwise>
            <code><xsl:apply-templates/></code>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:text>::=</xsl:text>
      </td>
      <!--<xsl:apply-templates
        select="following-sibling::*[1][name()='rhs']"/>-->
  </xsl:template>

  <!-- loc: a Web location -->
  <!-- outside the header, it's a normal cross-reference -->
  <xsl:template match="loc">
    <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
    </xsl:if>
    <xsl:if test="@rel">
        <xsl:attribute name="rel">
          <xsl:value-of select="@rel"/>
        </xsl:attribute>
    </xsl:if>
    <xsl:if test="starts-with(@href, '#')">
      <xsl:if test="not(key('ids', substring-after(@href, '#')))">
        <xsl:message terminate="yes">
          <xsl:text>Internal loc href to </xsl:text>
          <xsl:value-of select="@href"/>
          <xsl:text>, but that ID does not exist in this document.</xsl:text>
        </xsl:message>
      </xsl:if>
    </xsl:if>

    <a href="{@href}">
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <!-- member: member of an organization -->
  <!-- appears only in orglist, which creates <ul> context -->
  <xsl:template match="member">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- method: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- module: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- month: month of spec -->
  <!-- only used in pudate; called directly from header template -->
  <xsl:template match="month">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- name: name of an editor or organization member -->
  <!-- only appears in author and member -->
  <!-- just output text -->
  <xsl:template match="name">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- dedication -->
  <xsl:template match="note[contains-token(@role, 'dedication')]">
    <div class="dedication">
      <xsl:sequence select="@id"/>
      <h3>Dedication</h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- note: a note about the spec -->
  <xsl:template match="note">
    <div class="note">
      <p class="prefix">
        <b>Note:</b>
      </p>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- notice: a front-matter advisory about the spec's status -->
  <!-- make sure people notice it -->
  <xsl:template match="notice">
    <div class="notice">
      <p class="prefix">
        <b>NOTICE:</b>
      </p>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- nt: production non-terminal -->
  <!-- make a link to the non-terminal's definition -->
  <xsl:template match="nt">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @def)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="child::node()">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="tokenize(@def, '-')[last()]"/>
        </xsl:otherwise>
      </xsl:choose>     
    </a>
  </xsl:template>

  <!-- ====================================================================== -->
  <!-- OrderedList Numeration -->

  <xsl:template name="list.numeration">
    <xsl:variable name="depth" select="count(ancestor::olist)"/>
    <xsl:choose>
      <xsl:when test="$depth mod 5 = 0">ar</xsl:when>
      <xsl:when test="$depth mod 5 = 1">la</xsl:when>
      <xsl:when test="$depth mod 5 = 2">lr</xsl:when>
      <xsl:when test="$depth mod 5 = 3">ua</xsl:when>
      <xsl:when test="$depth mod 5 = 4">ur</xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- olist: an ordered list -->
  <xsl:template match="olist">
    <xsl:variable name="numeration">
      <xsl:call-template name="list.numeration"/>
    </xsl:variable>

    <ol class="enum{$numeration}">
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <!-- orglist: a list of an organization's members -->
  <xsl:template match="orglist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <!-- p: a standard paragraph -->
  <xsl:template match="p">
    <p>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@role">
        <xsl:attribute name="class">
          <xsl:value-of select="@role"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!-- p role="closetermdef": indicates the end of an open term definition -->
  <xsl:template match="p[@role='closetermdef']">
    <p>]</p>
  </xsl:template>

  <xsl:template match="p[contains-token(@role, 'type-hierarchy-figure')]">
    <div class="{@role}">
      <div class="hier">
        <xsl:apply-templates select="ulist[1]"/>
      </div>
      <div class="legend">
        <p>Legend:</p>
        <xsl:apply-templates select="* except ulist[1]"/>
      </div>
    </div>
  </xsl:template>

  <!-- param: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- parameters: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- phrase: semantically meaningless markup hanger -->
  <!-- role attributes may be used to request different formatting,
       which isn't currently handled -->
  <xsl:template match="phrase">
    <!--
    <xsl:comment>
      <xsl:text>* This is xmlspec, match="phrase".  show.diff.markup = </xsl:text>
      <xsl:value-of select="$show.diff.markup"/>
    </xsl:comment>
    -->
    <span>
      <xsl:if test="@role">
        <xsl:attribute name="class">
          <xsl:value-of select="@role"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- prevlocs: previous locations for this spec -->
  <!-- called in a <dl> context from header -->
  <xsl:template match="prevlocs">
    <dt>
      <xsl:text>Previous versions</xsl:text>
      <xsl:if test="count(loc) &gt; 1">s</xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- prod: a formal grammar production -->
  <!-- if not in a prodgroup, needs a <tbody> -->
  <!-- has a weird content model; makes a table but there are no
       explicit rules; many different things can start a new row -->
  <!-- process the first child in each row, and it will process the
       others -->
  <xsl:template match="prod">
    <tbody>
      <tr style="vertical-align:baseline;">
        <xsl:apply-templates select="lhs, rhs"/>
      </tr>
      <xsl:for-each select="com|constraint|vc|wfc">
        <tr>
          <td/>
          <td/>
          <xsl:apply-templates select="."/>
        </tr>
      </xsl:for-each>
<!--        select="lhs |
                rhs[preceding-sibling::*[1][not(self::lhs)]] |
                (com|constraint|vc|wfc)[preceding-sibling::*[1][not(self::rhs)]]"/>-->
    </tbody>
  </xsl:template>

  <xsl:template match="prodgroup/prod">
    <tr style="vertical-align:baseline;">
      <xsl:apply-templates select="lhs, rhs"/>
    </tr>
    <xsl:for-each select="com|constraint|vc|wfc">
        <tr>
          <td/>
          <td/>
          <xsl:apply-templates select="."/>
        </tr>
      </xsl:for-each>
    <!--<xsl:apply-templates
      select="lhs |
              rhs[preceding-sibling::*[1][not(self::lhs)]] |
              (com|constraint|vc|wfc)[preceding-sibling::*[1][not(self::rhs)]]"/>-->
  </xsl:template>

  <!-- prodgroup: group of formal productions -->
  <!-- create one <tbody> for each group -->
  <xsl:template match="prodgroup">
    <tbody>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>

  <!-- prodrecap: reiteration of a prod -->
  <!-- process the prod in another node that will never generate a
       <tbody> or a number, plus links the lhs to the original
       production -->
  <!--<xsl:template match="prodrecap">
    <tbody>
      <xsl:apply-templates select="key('ids', @ref)" mode="ref"/>
    </tbody>
  </xsl:template>-->

  <!--<xsl:template match="processing-instruction('specprod')">
    <xsl:if test="contains(., 'production-recap')"/>
    <table class="scrap">
      <!-\-<caption>Grammar Rules</caption> -\->
      <tbody>
        <xsl:apply-templates select="//prod" mode="ref"/>
      </tbody>
    </table>
  </xsl:template>-->

  <!-- proto: function prototype -->
  <!-- type and name of the function, with arguments in parens -->
  <xsl:template match="proto">
    <p>
      <em><xsl:value-of select="@return-type"/></em>
      <xsl:text> </xsl:text>
      <b><xsl:value-of select="@name"/></b>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
    </p>
  </xsl:template>

  <!-- pubdate: date of spec -->
  <!-- called directly from header -->

  <!-- publoc: location of current version of spec -->
  <!-- called from header in <dl> context -->
  <xsl:template match="publoc">
    <xsl:variable name="uri">
      <xsl:apply-templates select="loc/node()"/>
    </xsl:variable>
    <xsl:variable name="uri" select="string($uri)"/>

    <xsl:variable name="expected"
                  select="starts-with($uri, 'https://qt4cg.org/specifications/')"/>

    <xsl:variable name="href" as="xs:string?">
      <xsl:choose>
        <xsl:when test="$expected and exists($pull-request)">
          <xsl:sequence select="replace($uri, '/specifications', '/pr/'||$pull-request)"/>
        </xsl:when>
        <xsl:when test="$expected and exists($branch-name)">
          <xsl:sequence select="replace($uri, '/specifications', '/branch/'||$branch-name)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <dt>This version:</dt>
    <dd>
      <xsl:choose>
        <xsl:when test="exists($href)">
          <a href="{$href}/">
            <xsl:sequence select="$href"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </dd>
  </xsl:template>

  <xsl:template match="altlocs">
    <p>
      <xsl:text>This document is also available </xsl:text>
      <xsl:text>in these non-normative formats: </xsl:text>
      <xsl:for-each select="loc">
        <xsl:if test="position() &gt; 1">
          <xsl:if test="last() &gt; 2">
            <xsl:text>, </xsl:text>
          </xsl:if>
          <xsl:if test="last() = 2">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:if test="position() = last() and position() &gt; 1">and&#160;</xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>

<!-- 2014-01-31: Jim revised the text for errataloc per email from Ian Jacobs 2014-01-21 -->
  <xsl:template match="errataloc">
    <p>
      <xsl:text>Please check the </xsl:text>
      <a href="{@href}"><strong>errata</strong></a>
      <xsl:text> for any errors or issues reported since publication.</xsl:text>
    </p>
  </xsl:template>

  <xsl:template match="preverrataloc">
    <p>
      <xsl:text>The </xsl:text>
      <a href="{@href}">previous errata</a>
      <xsl:text> for this document, are also available.</xsl:text>
    </p>
  </xsl:template>

  <xsl:template match="translationloc">
    <p>See also <a href="{@href}"><strong>translations</strong></a>.</p>
  </xsl:template>

  <!-- pubstmt: statement of publication -->
  <!-- not currently output -->

  <!-- quote: a quoted string or phrase -->
  <!-- it would be nice to use HTML <q> elements, but browser support
       is abysmal -->
  <xsl:template match="quote">
    <xsl:text>“</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>”</xsl:text>
  </xsl:template>

  <!-- raises: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- reference: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- resolution: resolution of an issue -->
  <xsl:template match="resolution">
    <p class="prefix">
      <b>
        <xsl:if test="@role='partial'">Partial </xsl:if>
        <xsl:text>Resolution:</xsl:text>
      </b>
    </p>
    <xsl:apply-templates/>
  </xsl:template>


  <!--<xsl:template name="rhs-comment">
     <xsl:choose>
       <xsl:when test="following-sibling::*[1][self::com | self::constraint | self::vc | self::wfc]">
         <xsl:apply-templates
           select="following-sibling::*[1][self::com | self::constraint | self::vc | self::wfc]"/>
       </xsl:when>
       <xsl:otherwise>
         <td></td>
       </xsl:otherwise>
     </xsl:choose>
  </xsl:template>-->

  <!-- returns: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- revisiondesc: description of spec revision -->
  <!-- used for internal tracking; not formatted -->

  <!-- rhs: right-hand side of a formal production -->
  <!-- make a table cell; if it's not the first after an LHS, make a
       new row, too -->
  <xsl:template match="rhs">   
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <code><xsl:apply-templates/></code>
      </td> 
  </xsl:template>

  <!-- role: part played by a member of an organization -->
  <xsl:template match="role">
    <xsl:text> (</xsl:text>
    <i><xsl:apply-templates/></i>
    <xsl:text>) </xsl:text>
  </xsl:template>

  <!-- scrap: series of formal grammar productions -->
  <!-- set up a <table> and handle children -->
  <xsl:template match="scrap">
    <xsl:apply-templates select="head"/>
    <table class="scrap">
      <!--<caption>Grammar Rules</caption>-->
      <xsl:apply-templates select="bnf | prod | prodgroup"/>
    </table>
  </xsl:template>

  <!-- sequence: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- sitem: simple list item -->
  <!-- just make one paragraph with <br>s between items -->
  <xsl:template match="sitem">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sitem[position() &gt; 1]" priority="2">
    <br/>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- slist: simple list -->
  <!-- using a <blockquote> to indent the list is very wrong, but it works -->
  <xsl:template match="slist">
    <blockquote>
      <p>
        <xsl:apply-templates/>
      </p>
    </blockquote>
  </xsl:template>

  <!-- source: the source of an issue -->
  <xsl:template match="source">
    <p>
      <b>Source</b>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- sourcedesc: description of spec preparation -->
  <!-- used for tracking the source, but not formatted -->

  <!-- spec: the specification itself -->
  <xsl:template match="spec">
    <html>
      <xsl:call-template name="make-lang-attribute"/>
      <xsl:call-template name="make-head"/>     
      <body>
        <xsl:call-template name="starting-banner"/>
        <xsl:apply-templates/>
        <xsl:call-template name="footnotes"/>
        <xsl:if test="$back.to.top.link">
          <!-- Recommended by Pubrules -->
          <p role="navigation" id="back-to-top"><a href="#title"><abbr title="Back to top">↑</abbr></a></p>
        </xsl:if>
        <xsl:call-template name="make-script"/>
        <script src="js/toc.js"></script>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="make-lang-attribute">
    <xsl:if test="header/langusage/language">
      <xsl:attribute name="lang">
        <xsl:value-of select="header/langusage/language/@id"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="make-head">
    <head>
      <!--<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>-->
      <title>
        <xsl:apply-templates select="header/title"/>
        <xsl:if test="header/version">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="header/version"/>
        </xsl:if>
        <!-- 2016-12-08: Andy removed additional title because it breaks pubrules
                       : title and h1 must be the same text -->
        <!-- xsl:if test="$additional.title != ''">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="$additional.title"/>
        </xsl:if -->
      </title>
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
      <xsl:call-template name="css"/>
      <xsl:call-template name="additional-head"/>
    </head>
  </xsl:template>
  
  <xsl:template name="starting-banner">
    <!-- Here to be overridden -->
  </xsl:template>
  
  <xsl:template name="make-script">
    <script src="https://www.w3.org/scripts/TR/2016/fixup.js"/>
  </xsl:template>
  
  <xsl:template name="footnotes">
    <xsl:if test="//footnote[not(ancestor::table)]">
      <hr/>
      <div class="endnotes">
        <xsl:text>&#xA;</xsl:text>
        <h3>
          <xsl:call-template name="anchor">
            <xsl:with-param name="conditional" select="0"/>
            <xsl:with-param name="default.id" select="'endnotes'"/>
          </xsl:call-template>
          <xsl:text>End Notes</xsl:text>
        </h3>
        <dl>
          <xsl:apply-templates select="//footnote[not(ancestor::table)]" mode="notes"/>
        </dl>
      </div>
    </xsl:if>
  </xsl:template>
  
  
  <!-- Specref -->

  <!-- specref: reference to another part of teh current specification -->
  <xsl:template match="specref">
    <xsl:param name="target" select="key('ids', @ref)[1]"/>

    <xsl:choose>
      <xsl:when test="not($target)">
      	<xsl:message>
      	  <xsl:text>specref to non-existent ID: </xsl:text>
      	  <xsl:value-of select="@ref"/>
	      </xsl:message>
      </xsl:when>
      <xsl:when test="local-name($target)='issue'
                      or starts-with(local-name($target), 'div')
                      or starts-with(local-name($target), 'inform-div')
                      or local-name($target) = 'vcnote'
                      or local-name($target) = 'prod'
                      or local-name($target) = 'example'
                      or local-name($target) = 'label'
		      or $target/self::item[parent::olist]">
        <xsl:apply-templates select="$target" mode="specref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unsupported specref to </xsl:text>
          <xsl:value-of select="local-name($target)"/>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="@ref"/>
          <xsl:text>] </xsl:text>
          <xsl:text> (Contact stylesheet maintainer).</xsl:text>
        </xsl:message>
        <b>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @ref)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>???</xsl:text>
          </a>
        </b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="item" mode="specref">
    <xsl:variable name="items" select="ancestor-or-self::item[parent::olist]"/>

    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>

      <!--
      <xsl:value-of select="count($items)"/>
      <xsl:text>;</xsl:text>
      -->

      <xsl:for-each select="$items">
	<xsl:variable name="number" select="count(preceding-sibling::item)+1"/>
	<xsl:variable name="numeration">
	  <!-- this is related to, but not the same as, list.numeration -->
	  <xsl:choose>
	    <xsl:when test="count(ancestor::olist) mod 5 = 1">ar</xsl:when>
	    <xsl:when test="count(ancestor::olist) mod 5 = 2">la</xsl:when>
	    <xsl:when test="count(ancestor::olist) mod 5 = 3">lr</xsl:when>
	    <xsl:when test="count(ancestor::olist) mod 5 = 4">ua</xsl:when>
	    <xsl:when test="count(ancestor::olist) mod 5 = 0">ur</xsl:when>
	  </xsl:choose>
	</xsl:variable>

	<xsl:choose>
	  <xsl:when test="$numeration = 'la'">
	    <xsl:number value="$number" format="a"/>
	  </xsl:when>
	  <xsl:when test="$numeration = 'lr'">
	    <xsl:number value="$number" format="i"/>
	  </xsl:when>
	  <xsl:when test="$numeration = 'ua'">
	    <xsl:number value="$number" format="A"/>
	  </xsl:when>
	  <xsl:when test="$numeration = 'ur'">
	    <xsl:number value="$number" format="I"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$number"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text>.</xsl:text>

	<!--
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$number"/>
	<xsl:text>;</xsl:text>
	<xsl:value-of select="$numeration"/>
	<xsl:text>)</xsl:text>
	-->

      </xsl:for-each>

    </a>
  </xsl:template>

  <xsl:template match="issue" mode="specref">
    <xsl:text>[</xsl:text>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>
      <b>
        <xsl:text>Issue </xsl:text>
        <xsl:apply-templates select="." mode="number"/>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="head" mode="text"/>
      </b>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="div1|div2|div3|div4|div5" mode="specref">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>
      <b>
        <xsl:apply-templates select="." mode="divnum"/>
        <xsl:apply-templates select="head" mode="text"/>
      </b>
    </a>
  </xsl:template>

  <xsl:template match="inform-div1" mode="specref">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target"/>
      </xsl:attribute>
      <b>
        <xsl:apply-templates select="." mode="divnum"/>
        <xsl:apply-templates select="head" mode="text"/>
      </b>
    </a>
  </xsl:template>

  <xsl:template match="vcnote" mode="specref">
    <b>
      <xsl:text>[VC: </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target"/>
        </xsl:attribute>
        <xsl:apply-templates select="head" mode="text"/>
      </a>
      <xsl:text>]</xsl:text>
    </b>
  </xsl:template>

  <xsl:template match="prod" mode="specref">
    <b>
      <xsl:text>[PROD: </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target"/>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="number-simple"/>
      </a>
      <xsl:text>]</xsl:text>
    </b>
  </xsl:template>

  <xsl:template match="label" mode="specref">
    <b>
      <xsl:text>[</xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </a>
      <xsl:text>]</xsl:text>
    </b>
  </xsl:template>

  <xsl:template match="example" mode="specref">
    <xsl:apply-templates select="head" mode="specref"/>
  </xsl:template>

  <xsl:template match="example/head" mode="specref">
    <xsl:variable name="id">
      <xsl:call-template name="object.id">
        <xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>

    <a href="#{$id}">
      <xsl:text>Example</xsl:text>
    </a>
  </xsl:template>

  <!-- /Specref -->

  <!-- status: the status of the spec -->
  <xsl:template match="status">
    <div>
      <xsl:text>&#10;</xsl:text>
      <h2>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
          <xsl:with-param name="default.id" select="'status'"/>
        </xsl:call-template>
        <xsl:text>Status of this Document</xsl:text>
      </h2>
      <xsl:if test="/spec/@role='editors-copy'">
        <p><strong>This document is an editors' copy that has
        no official standing.</strong></p>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- struct: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- sub: subscript -->
  <xsl:template match="sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <!-- subtitle: secondary title of spec -->
  <!-- handled directly within header -->
  <xsl:template match="title">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- sup: superscript -->
  <xsl:template match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>

  <!-- table: the HTML table model adopted wholesale; note however that we -->
  <!-- do this such that the XHTML stylesheet will do the right thing. -->
  <xsl:template match="caption|col|colgroup|tfoot|thead|tr|tbody">
    <xsl:element name="{local-name(.)}">
      <xsl:call-template name="style-attributes"/>
      <xsl:apply-templates select="@*[not(f:is-style-attribute(.))]" mode="table-attributes"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- td/th are special -->
  <xsl:template match="td|th">
    <xsl:element name="{local-name(.)}">
      <xsl:call-template name="style-attributes"/>
      <xsl:call-template name="cell-attributes"/>
        
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="cell-attributes">
    <xsl:for-each select="@*">
      <!-- Wait: some of these aren't HTML attributes after all... -->
      <xsl:choose>
        <xsl:when test="local-name(.) = 'role'">
          <xsl:attribute name="class">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="f:is-style-attribute(.)"/>
        <xsl:when test="local-name(.) = 'diff'"/>
        <xsl:when test="local-name(.) = 'at'"/>
        <xsl:when test="local-name(.) = 'colspan' and . = 1"/>
        <xsl:when test="local-name(.) = 'rowspan' and . = 1"/>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- but table is special, to handle footnotes -->
  <xsl:template match="table">
    <xsl:call-template name="anchor"/>
    <table>
      <xsl:call-template name="style-attributes"/>
      <xsl:apply-templates select="@*[not(f:is-style-attribute(.))]" mode="table-attributes"/>
      <xsl:if test="@summary">
        <caption><xsl:value-of select="@summary"/></caption>
      </xsl:if>
      <xsl:apply-templates/>

      <xsl:if test=".//footnote">
        <tbody>
          <tr>
            <td>
              <xsl:apply-templates select=".//footnote" mode="table.notes"/>
            </td>
          </tr>
        </tbody>
      </xsl:if>
    </table>
  </xsl:template>
  
  <xsl:template name="style-attributes">
    <xsl:choose>
      <xsl:when test="@style | @class">
        <xsl:copy-of select="@style | @class"/>
      </xsl:when>
      <xsl:when test="@*[f:is-style-attribute(.)]">
        <xsl:attribute name="style">
          <xsl:for-each select="@*[f:is-style-attribute(.)]">
            <xsl:if test="position() gt 1">; </xsl:if>
            <xsl:apply-templates select="." mode="style-attribute"/>
          </xsl:for-each>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="f:is-style-attribute" as="xs:boolean">
    <xsl:param name="att" as="attribute(*)"/>
    <xsl:variable name="n" select="local-name($att)"/>
    <xsl:sequence select="namespace-uri($att) = '' and $n = ('class', 'style', 'border', 'width', 'cellspacing', 'padding', 'cellpadding', 'align', 'valign')"/>
  </xsl:function>
  
  <xsl:function name="f:units" as="xs:string">
    <xsl:param name="value" as="xs:string"/>
    <xsl:sequence select="if ($value castable as xs:integer) then concat($value, 'px') else $value"/>
  </xsl:function>
  
  <xsl:template match="@border" mode="style-attribute">border:<xsl:value-of select="f:units(.)"/> solid</xsl:template>
  <xsl:template match="@width" mode="style-attribute">width:<xsl:value-of select="f:units(.)"/></xsl:template>
  <xsl:template match="@align" mode="style-attribute">text-align:<xsl:value-of select="."/></xsl:template>
  <xsl:template match="@valign" mode="style-attribute">vertical-align:<xsl:value-of select="."/></xsl:template>
  <xsl:template match="@cellspacing" mode="style-attribute">border-spacing:<xsl:value-of select="."/></xsl:template>
  <xsl:template match="@padding" mode="style-attribute">padding:<xsl:value-of select="f:units(.)"/></xsl:template>
  <xsl:template match="@cellpadding" mode="style-attribute">padding:<xsl:value-of select="f:units(.)"/></xsl:template>

  <!-- attributes of table elements: role becomes class -->
  <xsl:template match="@role" mode="table-attributes">
    <xsl:attribute name="class">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <!-- attributes of table elements: in general, copy the attributes unchanged -->
  <xsl:template match="@*" mode="table-attributes">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- attributes of table elements: some attributes are discarded -->
  <xsl:template match="@diff | @at | @id | @xml:id | @summary |
                       @border | @width | @padding | @cellpadding | @cellspacing |
                       td/@colspan[.='1'] | th/@rowspan[.='1'] | td/@rowspan[.='1'] | th/@rowspan[.='1']" 
                       mode="table-attributes">
    <!-- no-op -->
  </xsl:template>

  <!-- term: the actual mention of a term within a termdef -->
  <xsl:template match="term">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <!-- termdef: sentence or phrase defining a term -->
  <xsl:template match="termdef">
    <xsl:text>[</xsl:text>
    <a id="{@id}" title="{@term}">
      <xsl:text>Definition</xsl:text>
    </a>
    <xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="not(@open='true')">
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- termref: reference to a defined term -->
  <xsl:template match="termref">
    <a title="{key('ids', @def)/@term}">
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="key('ids', @def)"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- tfoot: see table -->
  <!-- th: see table -->
  <!-- thead: see table -->

  <!-- title: title of the specification -->
  <!-- called directly within header -->

  <!-- titleref: reference to the title of any work -->
  <!-- if a URL is given, link it -->
  <xsl:template match="titleref">
    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <cite>
            <xsl:apply-templates/>
          </cite>
        </a>
      </xsl:when>
      <xsl:when test="ancestor::bibl/@href">
        <a href="{ancestor::bibl/@href}">
          <cite>
            <xsl:apply-templates/>
          </cite>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <cite>
          <xsl:apply-templates/>
        </cite>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- tr: see table -->

  <!-- typedef: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- typename: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- ulist: unordered list -->
  <xsl:template match="ulist">
    <ul>
      <xsl:if test="@role">
        <xsl:attribute name="class" select="@role"/>
      </xsl:if>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <!-- union: -->
  <!-- IDL stuff isn't handled yet -->

  <!-- var: a variable -->
  <xsl:template match="var">
    <var>
      <xsl:apply-templates/>
    </var>
  </xsl:template>
  
  <xsl:template match="var[matches(., '[A-Z][0-9]')]">
    <var>
      <xsl:value-of select="substring(., 1, 1)"/>
      <sub><xsl:value-of select="substring(., 2, 1)"/></sub>
    </var>
  </xsl:template>
  
  <xsl:template match="var[contains(., '/')]">
    <var>
      <xsl:value-of select="substring-before(., '/')"/>
      <sub><xsl:value-of select="substring-after(., '/')"/></sub>
    </var>
  </xsl:template>
  
  <xsl:template match="var[matches(., '[A-Z]''')]">
    <var><xsl:value-of select="translate(., '''', '&#x2032;')"/></var>
  </xsl:template>  

  <!-- vc: validity check reference in a formal production -->
  <xsl:template match="vc">
    <!-- MHK 2024-09-14 - this is not used -->
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="@diff and $show.diff.markup != 0">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>[VC: </xsl:text>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr style="vertical-align:baseline;">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="@diff and $show.diff.markup != 0">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="@diff"/>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="key('ids', @def)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>[VC: </xsl:text>
              <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
              <xsl:text>]</xsl:text>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- vcnote: validity check note after a formal production -->
  <xsl:template match="vcnote">
    <div class="constraint">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- version: version of this spec -->
  <!-- called directly from header -->
  <xsl:template match="version">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- w3c-designation: canonical name for this spec -->
  <!-- not used for formatting -->

  <!-- w3c-doctype: type of document the specification is -->
  <!-- used by header template to select CSS stylesheet for output
       HTML -->
  <xsl:template match="w3c-doctype">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- wfc: well-formedness check reference in a formal production -->
  <xsl:template match="wfc">
    <!-- MHK 2024-09-14 - this is not used -->
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][name()='rhs']">
        <td>
          <xsl:if test="@diff and $show.diff.markup != 0">
            <xsl:attribute name="class">
              <xsl:text>diff-</xsl:text>
              <xsl:value-of select="@diff"/>
            </xsl:attribute>
          </xsl:if>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="key('ids', @def)"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:text>[WFC: </xsl:text>
            <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
            <xsl:text>]</xsl:text>
          </a>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <tr style="vertical-align:baseline;">
          <td/><td/><td/><td/>
          <td>
            <xsl:if test="@diff and $show.diff.markup != 0">
              <xsl:attribute name="class">
                <xsl:text>diff-</xsl:text>
                <xsl:value-of select="@diff"/>
              </xsl:attribute>
            </xsl:if>
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="href.target">
                  <xsl:with-param name="target" select="key('ids', @def)"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:text>[WFC: </xsl:text>
              <xsl:apply-templates select="key('ids', @def)/head" mode="text"/>
              <xsl:text>]</xsl:text>
            </a>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- wfcnote: well-formedness check note after formal production -->
  <xsl:template match="wfcnote">
    <div class="constraint">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- xnt: external non-terminal -->
  <!-- xspecref: external specification reference -->
  <!-- xtermref: external term reference -->
  <!-- just link to URI provided -->
  <xsl:template match="xnt | xspecref | xtermref">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- year: year of spec -->
  <!-- only used in pudate; called directly from header template -->
  <xsl:template match="year">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Silly HTML elements used for pasting stuff in; shouldn't ever
       show up in a spec, but they're easy to handle and you just
       never know. -->
  <xsl:template match="a|div|em|h1|h2|h3|h4|h5|h6|li|ol|pre|ul">
    <xsl:element name="{local-name(.)}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- legacy XML spec stuff -->
  <xsl:template match="htable">
    <table>     
      <xsl:copy-of select="@*"/>
      <caption>HTML table</caption>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="htbody">
    <tbody>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>
  <xsl:template match="key-term">
    <b><xsl:apply-templates/></b>
  </xsl:template>
  <xsl:template match="statusp">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- legacy DocBook stuff -->
  <xsl:template match="itemizedlist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="listitem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="orderedlist">
    <ol>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- mode: divnum -->
  <xsl:template mode="divnum" match="div1">
    <xsl:number format="1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back/div1 | inform-div1">
    <xsl:number count="div1 | inform-div1" format="A "/>
  </xsl:template>

  <xsl:template mode="divnum"
    match="front/div1 | front//div2 | front//div3 | front//div4 | front//div5"/>

  <xsl:template mode="divnum" match="div2">
    <xsl:number level="multiple" count="div1 | div2" format="1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div2">
    <xsl:number level="multiple" count="div1 | div2 | inform-div1"
      format="A.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="div3">
    <xsl:number level="multiple" count="div1 | div2 | div3"
      format="1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div3">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | inform-div1" format="A.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="div4">
    <xsl:number level="multiple" count="div1 | div2 | div3 | div4"
      format="1.1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div4">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | inform-div1"
      format="A.1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="div5">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | div5" format="1.1.1.1.1 "/>
  </xsl:template>

  <xsl:template mode="divnum" match="back//div5">
    <xsl:number level="multiple"
      count="div1 | div2 | div3 | div4 | div5 | inform-div1"
      format="A.1.1.1.1 "/>
  </xsl:template>

  <!-- mode: notes -->
  <xsl:template mode="notes" match="footnote">
    <xsl:variable name="this-note-id">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <dt>
      <xsl:text>[</xsl:text>
      <a id="{$this-note-id}" href="#FN-ANCH-{$this-note-id}">
        <xsl:apply-templates select="." mode="number-simple"/>
      </a>
      <xsl:text>]</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <!-- mode: table.notes -->
  <xsl:template match="footnote" mode="table.notes">
    <xsl:apply-templates mode="table.notes"/>
  </xsl:template>

  <xsl:template match="footnote/p[1]" mode="table.notes">
    <xsl:variable name="this-note-id">
      <xsl:choose>
        <xsl:when test="../@id">
          <xsl:value-of select="../@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(parent::*)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p class="table.footnote">
      <sup>
        <a id="{$this-note-id}" href="#FN-ANCH-{$this-note-id}">
          <xsl:apply-templates select="parent::footnote" mode="number-simple"/>
          <xsl:text>.</xsl:text>
        </a>
      </sup>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- mode: number -->
  <xsl:template mode="number" match="prod">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="." mode="number-simple"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template mode="number" match="issue">
    <xsl:number level="single" format="1"/>
  </xsl:template>

  <xsl:template mode="number" match="prod[@diff='add']">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates select="preceding::prod[not(@diff='add')][1]"
      mode="number-simple"/>
<!--
  Once again, this could be done right here, but XT won't hear of it.
    <xsl:number level="any" count="prod[not(@diff='add')]"/>
  -->
    <xsl:number level="any" count="prod[@diff='add']"
      from="prod[not(@diff='add')]" format="a"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- mode: number-simple -->
  <xsl:template mode="number-simple" match="prod">
    <!-- Using @num and auto-numbered productions is forbidden. -->
    <xsl:choose>
      <xsl:when test="@num">
        <xsl:value-of select="@num"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="any" count="prod[not(@diff='add')]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="number-simple" match="footnote">
    <xsl:number level="any" format="1"/>
  </xsl:template>

  <!--<!-\- mode: ref -\->
  <xsl:template match="lhs" mode="ref">
    <tr style="vertical-align:baseline;">
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="ancestor::prod" mode="number"/>
        <xsl:text>&#xa0;&#xa0;&#xa0;</xsl:text>
      </td>
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="../@id">
            <a href="#{../@id}">
              <code><xsl:apply-templates/></code>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <code><xsl:apply-templates/></code>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:if test="ancestor-or-self::*/@diff and $show.diff.markup != 0">
          <xsl:attribute name="class">
            <xsl:text>diff-</xsl:text>
            <xsl:value-of select="ancestor-or-self::*/@diff"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:text>::=</xsl:text>
      </td>
      <xsl:apply-templates
        select="following-sibling::*[1][name()='rhs']"/>
    </tr>
  </xsl:template>-->

  <!--<xsl:template mode="ref" match="prod">
    <xsl:apply-templates select="lhs" mode="ref"/>
    <xsl:apply-templates
      select="rhs[preceding-sibling::*[1][name()!='lhs']] |
              com[preceding-sibling::*[1][name()!='rhs']] |
              constraint[preceding-sibling::*[1][name()!='rhs']] |
              vc[preceding-sibling::*[1][name()!='rhs']] |
              wfc[preceding-sibling::*[1][name()!='rhs']]"/>
  </xsl:template>-->

  <!-- mode: text -->
  <!-- most stuff processes just as text here, but some things should
       be hidden -->
  <xsl:template mode="text" match="ednote | footnote"/>

  <!-- mode: toc -->
  <xsl:template mode="toc" match="div1">
    <xsl:variable name="more-toc" select="$toc.level gt 1 and div2"/>
    <li>
      <details>
        <summary>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="secno">
              <xsl:apply-templates select="." mode="divnum"/>
            </span>
            <span>
              <xsl:call-template name="toc-entry-class"/>
              <xsl:apply-templates select="head" mode="text"/>
            </span>
          </a>
          <xsl:if test="$more-toc">
            <span class="exptoc collapsed">&#x2009;▶</span>
          </xsl:if>
        </summary>
        <xsl:if test="$more-toc">
          <ol class="toc">
            <xsl:apply-templates select="div2" mode="toc"/>
          </ol>
        </xsl:if>
      </details>
    </li>
  </xsl:template>

  <xsl:template mode="toc" match="div2">
    <xsl:variable name="more-toc" select="$toc.level gt 2 and div3"/>
    <li>
      <details>
        <summary>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="secno">
              <xsl:apply-templates select="." mode="divnum"/>
            </span>
            <span>
              <xsl:call-template name="toc-entry-class"/>
              <xsl:apply-templates select="head" mode="text"/>
            </span>
          </a>
          <xsl:if test="$more-toc">
            <span class="exptoc">&#x2009;▶</span>
          </xsl:if>
        </summary>
        <xsl:if test="$more-toc">
          <ol class="toc">
            <xsl:apply-templates select="div3" mode="toc"/>
          </ol>
        </xsl:if>
      </details>
    </li>
  </xsl:template>

  <xsl:template mode="toc" match="div3">
    <xsl:variable name="more-toc" select="$toc.level gt 3 and div4"/>
    <li>
      <details>
        <summary>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="secno">
              <xsl:apply-templates select="." mode="divnum"/>
            </span>
            <span>
              <xsl:call-template name="toc-entry-class"/>
              <xsl:apply-templates select="head" mode="text"/>
            </span>
          </a>
          <xsl:if test="$more-toc">
            <span class="exptoc">&#x2009;▶</span>
          </xsl:if>
        </summary>
        <xsl:if test="$more-toc">
          <ol class="toc">
            <xsl:apply-templates select="div4" mode="toc"/>
          </ol>
        </xsl:if>
      </details>
    </li>
  </xsl:template>

  <xsl:template mode="toc" match="div4">
    <xsl:variable name="more-toc" select="$toc.level gt 4 and div5"/>
    <li>
      <details>
        <summary>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="secno">
              <xsl:apply-templates select="." mode="divnum"/>
            </span>
            <span>
              <xsl:call-template name="toc-entry-class"/>
              <xsl:apply-templates select="head" mode="text"/>
            </span>
          </a>
          <xsl:if test="$more-toc">
            <span class="exptoc">&#x2009;▶</span>
          </xsl:if>
        </summary>
        <xsl:if test="$more-toc">
          <ol class="toc">
            <xsl:apply-templates select="div5" mode="toc"/>
          </ol>
        </xsl:if>
      </details>
    </li>
  </xsl:template>

  <xsl:template mode="toc" match="div5">
    <xsl:variable name="more-toc" select="$toc.level gt 5 and div6"/>
    <li>
      <details>
        <summary>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="secno">
              <xsl:apply-templates select="." mode="divnum"/>
            </span>
            <span>
              <xsl:call-template name="toc-entry-class"/>
              <xsl:apply-templates select="head" mode="text"/>
            </span>
          </a>
          <xsl:if test="$more-toc">
            <span class="exptoc">&#x2009;▶</span>
          </xsl:if>
        </summary>
        <xsl:if test="$more-toc">
          <xsl:apply-templates select="div6" mode="toc"/>
        </xsl:if>
      </details>
    </li>
  </xsl:template>

  <xsl:template mode="toc" match="div6">
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="target" select="."/>
        </xsl:call-template>
      </xsl:attribute>
      <span class="secno">
        <xsl:apply-templates select="." mode="divnum"/>
      </span>
      <span>
        <xsl:call-template name="toc-entry-class"/>
        <xsl:apply-templates select="head" mode="text"/>
      </span>
    </a>
  </xsl:template>

  <xsl:template mode="toc" match="inform-div1">
    <xsl:variable name="more-toc" select="$toc.level gt 1 and div2"/>
    <li>
      <details>
        <summary>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="target" select="."/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="secno">
              <xsl:apply-templates select="." mode="divnum"/>
            </span>
            <span>
              <xsl:call-template name="toc-entry-class"/>
              <xsl:apply-templates select="head" mode="text"/>
            </span>
          </a>
          <xsl:text> (Non-Normative)</xsl:text>
          <xsl:if test="$more-toc">
            <span class="exptoc">&#x2009;▶</span>
          </xsl:if>
        </summary>
        <xsl:if test="$more-toc">
          <ol class="toc">
            <xsl:apply-templates select="div2" mode="toc"/>
          </ol>
        </xsl:if>
      </details>
    </li>
  </xsl:template>

  <xsl:template name="toc-entry-class">
    <xsl:variable name="isnew"
                  select="if ((self::div2 or self::div3 or self::div4 or self::div5)
                              and starts-with(@id, 'func-'))
                          then not(exists(key('ids', @id, $fo31)))
                          else false()"/>

    <xsl:variable name="classes" as="xs:string*">
      <xsl:sequence select="'content'"/>
      <xsl:sequence select="@role/string()"/>
      <xsl:choose>
        <xsl:when test="$isnew">
          <xsl:sequence select="'toc-new'"/>
        </xsl:when>
        <xsl:when test="child::changes">
          <xsl:sequence select="'toc-chg'"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:attribute name="class" select="string-join($classes, ' ')"/>
  </xsl:template>

  <xsl:template name="css">
    <link rel="stylesheet" type="text/css" href="css/w3c-base.css"/>

    <link rel="stylesheet" href="css/qtspecs.css"/>
    <xsl:if test="normalize-space($additional.css) != ''">
      <xsl:for-each select="tokenize($additional.css, '\s+')">
        <link rel="stylesheet" href="css/{.}"/>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="normalize-space($additional.css.diff) != ''">
      <xsl:for-each select="tokenize($additional.css.diff, '\s+')">
        <link rel="stylesheet" href="css/{.}"/>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="normalize-space($additional.css.2) != ''">
      <xsl:for-each select="tokenize($additional.css.2, '\s+')">
        <link rel="stylesheet" href="css/{.}"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="additional-head">
    <!-- nop -->
  </xsl:template>

  <xsl:template name="href.target">
    <xsl:param name="target" select="."/>

    <xsl:text>#</xsl:text>

    <xsl:choose>
      <xsl:when test="$target/@id">
        <xsl:value-of select="$target/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($target)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- ================================================================= -->

<xsl:template name="object.id">
  <xsl:param name="node" select="."/>
  <xsl:param name="default.id" select="''"/>

  <xsl:choose>
    <!-- can't use the default ID if it's used somewhere else in the document! -->
    <xsl:when test="$default.id != '' and not(key('ids', $default.id))">
      <xsl:value-of select="$default.id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="conditional" select="1"/>
  <xsl:param name="default.id" select="''"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="default.id" select="$default.id"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$conditional = 0 or $node/@id">
    <a id="{$id}"/>
  </xsl:if>
</xsl:template>

<!-- ================================================================= -->

</xsl:transform>
