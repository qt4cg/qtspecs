<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0"
  xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  default-mode="leading-tokens" 
  expand-text="yes"
  xpath-default-namespace="http://www.w3.org/2001/03/XPath/grammar"  >
   
   <!-- This stylesheet is designed to be run against xpath-grammar.xsl.
      It outputs a list of the tokens that can start a RelativePathExpr,
      which is used, with a little manual massaging, in the XPath/XQuery
      appendix defining the leading-lone-slash constraint. -->
   
   <!-- The stylesheet is not run automatically as part of the build -->
    
    
    <xsl:key name="productions-by-name" match="production|token" use="@name"/>
   
    <xsl:function name="g:leading-tokens" as="xs:string*">
        <xsl:param name="production" as="element(*)"/>
        <xsl:param name="already-visited" as="element(*)*"/>
        <xsl:variable name="first" select="$production"/>
        <xsl:variable name="v" select="$already-visited | $production"/>
        <!--<xsl:message>LT {name($production)} {$production/@name} {string($production)}</xsl:message>-->
        <xsl:choose>
            <xsl:when test="$already-visited intersect $production"/>
            <xsl:when test="$production[@if='fulltext']"/>
            <xsl:when test="$production[self::string]">
                <xsl:sequence select="if ($production castable as xs:NCName) then 'NCName' else string($first)"/>
            </xsl:when>
           <xsl:when test="$production[self::sequence]">
                <xsl:sequence select="g:leading-tokens($first/*[1], $v)"/>
            </xsl:when>
            <xsl:when test="$production[self::ref]">
                <xsl:variable name="target" select="key('productions-by-name', $production/@name, root($production))"/>
                <xsl:choose>
                    <xsl:when test="$target/@name = ('DirectConstructor', 'StringConstructor', 'StringTemplate')">
                        <xsl:sequence select="$target/@name"/>
                    </xsl:when>
                    <xsl:when test="$target[self::token][count(*)=1][child::string]">
                        <!--<xsl:sequence select="distinct-values(($already-known, string($target/string)))"/>-->
                    </xsl:when>
                    <xsl:when test="$target[self::token]">
                        <xsl:sequence select="$target/@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="g:leading-tokens($target/*[1], $v)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$production[self::optional or self::zeroOrMore]">
                <xsl:sequence select="g:leading-tokens($production/*[1], $v),
                                      $production/following-sibling::*[1] ! g:leading-tokens(., $v)"/>
            </xsl:when>
            <xsl:when test="$production[self::oneOrMore]">
                <xsl:sequence select="g:leading-tokens($production/*[1], $already-visited)"/>
            </xsl:when>
            <xsl:when test="$production[self::choice]">
               <xsl:for-each select="$production/*">
                   <xsl:sequence select="g:leading-tokens(., $v)"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="/">
        <out>
            <xsl:for-each select="distinct-values(g:leading-tokens(//production[@name='RelativePathExpr']/*[1], ()))">
                <xsl:sort lang="en"/>
                <token>{.}</token>
            </xsl:for-each>
        </out>
    </xsl:template>
    
    <xsl:output indent="yes"/>
 
 

</xsl:stylesheet>