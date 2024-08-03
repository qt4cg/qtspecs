<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="3.0"
  xmlns:g="http://www.w3.org/2001/03/XPath/grammar"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  default-mode="leading-tokens" 
  expand-text="yes"
  xpath-default-namespace="http://www.w3.org/2001/03/XPath/grammar"  >
    
    
    <xsl:key name="productions-by-name" match="production|token" use="@name"/>
   
    
    <xsl:function name="g:leading-tokens" as="xs:string*">
        <xsl:param name="production" as="element(*)"/>
        <xsl:param name="already-known" as="xs:string*"/>
        <xsl:param name="already-visited" as="element(*)*"/>
        <xsl:variable name="first" select="$production[1]"/>
        <xsl:variable name="v" select="$already-visited | $production"/>
        <!--<xsl:message>LT {name($production)} {$production/@name} {string($production)}</xsl:message>-->
        <xsl:choose>
            <xsl:when test="$already-visited intersect $production"/>
            <xsl:when test="$production[@if='fulltext']"/>
            <xsl:when test="$first[self::string]">
                <xsl:sequence select="distinct-values(($already-known, if ($first castable as xs:NCName) then 'NCName' else string($first)))"/>
            </xsl:when>
            <xsl:when test="$first[self::ref]">
                <xsl:variable name="target" select="key('productions-by-name', $first/@name, root($production))"/>
                <xsl:choose>
                    <xsl:when test="$target/@name = ('DirectConstructor', 'StringConstructor', 'StringTemplate')">
                        <xsl:sequence select="distinct-values(($already-known, $target/@name))"/>
                    </xsl:when>
                    <xsl:when test="$target[self::token][count(*)=1][child::string]">
                        <!--<xsl:sequence select="distinct-values(($already-known, string($target/string)))"/>-->
                    </xsl:when>
                    <xsl:when test="$target[self::token]">
                        <xsl:sequence select="distinct-values(($already-known, $target/@name))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="distinct-values(($already-known, g:leading-tokens($target/*[1], $already-known, $v)))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$first[self::optional or self::zeroOrMore]">
                <xsl:sequence select="distinct-values(($already-known, 
                                                         g:leading-tokens($first/*[1], $already-known, $v),
                                                         g:leading-tokens($first/following-sibling::*[1], $already-known, $v)))"/>
            </xsl:when>
            <xsl:when test="$first[self::oneOrMore]">
                <xsl:sequence select="g:leading-tokens($first/*[1], $already-known, $already-visited)"/>
            </xsl:when>
            <xsl:when test="$first[self::choice]">
                <xsl:sequence select="fold-left($first/*, $already-known,
                    function($known, $next){g:leading-tokens($next, $known, $v)}) => distinct-values()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$already-known"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="/">
        <out>
            <xsl:for-each select="g:leading-tokens(//production[@name='RelativePathExpr']/*[1], (), ())">
                <xsl:sort lang="en"/>
                <token>{.}</token>
            </xsl:for-each>
        </out>
    </xsl:template>
    
    <xsl:output indent="yes"/>
 
 

</xsl:stylesheet>