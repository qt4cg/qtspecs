<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0" expand-text="true">
    <xsl:import href="../../xpath-functions-40/style/xpath-functions.xsl"/>


    <xsl:template name="finder"
        xmlns:fos="http://www.w3.org/xpath-functions/spec/namespace"
        exclude-result-prefixes="fos">
        <xsl:variable name="spec" select="./root()"/>
        
        <xsl:variable name="catalog" select="$expath-catalog"/>
        <!--<xsl:variable name="catalog" select="doc('../src/function-catalog.xml')"/>-->
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
                    <!--<xsl:for-each select="$catalog//fos:function[@prefix = 'fn']">
                        <xsl:sort select="upper-case(@prefix||':'||@name)"/>
                        <option value="{@prefix}:{@name}&#8291;"/>
                    </xsl:for-each>-->
                    <xsl:for-each select="$catalog//fos:function[@prefix != 'fn']">
                        <xsl:sort select="upper-case(@prefix||':'||@name)"/>
                        <option value="{@prefix}:{@name}&#8291;"/>
                    </xsl:for-each>
                </datalist>
            </div>
        </div>   
    </xsl:template>
    
    <xsl:template
        match="code[matches(., '^(bin|file):[-a-zA-Z0-9]+(#[0-9]+)?$')][not(@role = 'example')]">
        <!--<xsl:variable name="raw-name">
            <xsl:choose>
                <xsl:when test="contains(., '(')">
                    <xsl:value-of
                        select="concat(substring-before(., ':'), '-', substring-before(substring-after(., ':'), '('))"
                    />
                </xsl:when>
                <xsl:when test="contains(., '#')">
                    <xsl:value-of
                        select="concat(substring-before(., ':'), '-', substring-before(substring-after(., ':'), '#'))"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(., ':', '-')"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <xsl:variable name="name" select="normalize-space($raw-name)"/>-->
        <xsl:variable name="name" select="normalize-space(translate(., ':', '-'))"/>

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
                <xsl:when test="key('ids', $name)">
                    <xsl:value-of select="$name"/>
                </xsl:when>
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

        <xsl:variable name="is-descendant" select="exists(ancestor::*[@id = $target-id])"/>

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
        <xsl:if test="$defined = 0 and $strikeout.missing.functions != 0">
          <xsl:attribute name="class">strikeout</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </code>
            </xsl:otherwise>
        </xsl:choose>
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
            <a name="ERR{$spec}{$class}{$code}"/>
            <xsl:text>{$expath-prefix}:</xsl:text>
            <xsl:value-of select="concat( $class, $code)"/>
            <xsl:if test="@label">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="@label"/>
            </xsl:if>
        </dt>
        <dd>
            <xsl:apply-templates/>
        </dd>
    </xsl:template>
    
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
            <xsl:text>{$expath-prefix}:</xsl:text>
            <!--<xsl:value-of select="$spec"/>-->
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
    
    <!-- From xmlspec-2016.xsl -->
    
    <xsl:template name="toc-entry-class">
        <xsl:variable name="isnew"
            select="if ((self::div2 or self::div3 or self::div4 or self::div5)
            and starts-with(@id, 'func-'))
            then not(exists(key('ids', @id, $fo31)))
            else false()"/>
        <xsl:variable name="isnew" select="false()"/>
        
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
    
</xsl:stylesheet>
