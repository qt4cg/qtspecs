<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
   xmlns="http://www.w3.org/2010/09/qt-fots-catalog"
   xpath-default-namespace="http://www.w3.org/xpath-functions/spec/namespace"
   expand-text="yes">
   
   <!-- Generate KeywordArguments test set to test calls to system functions using keyword arguments -->
   
   <!-- Run against the function-catalog.xml source document -->
   
   <xsl:output method="xml" indent="yes"/>
   <xsl:strip-space elements="*"/>
   
   <xsl:template match="/">
     <xsl:comment> ************************************************** </xsl:comment>
     <xsl:text>&#10;</xsl:text>
     <xsl:comment> * This file is generated automatically by the    * </xsl:comment>
     <xsl:text>&#10;</xsl:text>
     <xsl:comment> * qtspecs build process. It is committed to the  * </xsl:comment>
     <xsl:text>&#10;</xsl:text>
     <xsl:comment> * test repository automatically. Any changes you * </xsl:comment>
     <xsl:text>&#10;</xsl:text>
     <xsl:comment> * make to this file will be lost on the next     * </xsl:comment>
     <xsl:text>&#10;</xsl:text>
     <xsl:comment> * build. Have a nice day. The cake is a lie.     * </xsl:comment>
     <xsl:comment> ************************************************** </xsl:comment>
     <xsl:text>&#10;</xsl:text>

      <test-set name="misc-BuiltInKeywords">
         <description>Tests for keyword argument names to built-in functions: 4.0 proposal</description>        
         <dependency type="spec" value="XP40+ XQ40+"/>
         <xsl:comment>Generated using generate-keyword-test-set.xsl from function-catalog.xml on {current-date()}</xsl:comment>
         <environment name="ka">
            <namespace prefix="math" uri="http://www.w3.org/2005/xpath-functions/math"/>
            <decimal-format name="data" decimal-separator="." grouping-separator=","/>
            <source role=".">
               <content><![CDATA[<doc attribute="attr_val"><e/></doc>]]></content>
            </source>
         </environment>
         <xsl:apply-templates select="//function"/>
      </test-set>      
   </xsl:template>
   
   <xsl:template match="function[@prefix='op', 'xs']"/>
   
   <!-- Exclude functions that are either (a) difficult to test, or (b) not yet agreed / implemented -->
   <xsl:template match="function[@name=('error', 'concat', 'truncate', 'transform', 'json', 'differences', 
      'foot', 'load-xquery-module', 'parts', 'stack-trace', 'group-by', 'substitute', 'collection', 'uri-collection',
      'items-ending-where', 'items-starting-where', 'slice', 'random-number-generator', 'replace')]" priority="5"/>
   
   <xsl:template match="function[@prefix='array'][@name=('replace', 'slice', 'from-sequence', 'of', 'partition')]" priority="6"/>
   
   <xsl:template match="function[@prefix='map'][@name=('replace')]" priority="6"/>
   
   <xsl:template match="function">
      <xsl:apply-templates select=".//proto"/>
   </xsl:template>
   
   <xsl:template match="proto">
      <xsl:variable name="prefix" select="(../../@prefix, 'fn')[1]"/>
      <test-case name="Keywords-{$prefix}-{../../@name}-{count(preceding-sibling::*)+1}">
         <description>Test of keyword arguments in static function call</description>
         <created by="generate-keyword-test-set.xsl" on="{current-date()}"/>
         <environment ref="ka"/>
         <test>
            <xsl:text>let $x := </xsl:text>
            <!--<xsl:if test="../..//property[.='focus-dependent']">
               <xsl:text>/doc/e!</xsl:text>
            </xsl:if>-->
            <xsl:text>{if (..//@default='.') then "/doc!" else ""}{$prefix}:{../../@name}(</xsl:text>
            <xsl:for-each select="arg">
               <xsl:if test="position() != 1">, </xsl:if>
               <xsl:text>{@name} := </xsl:text>
               <xsl:apply-templates select="@type"/>
            </xsl:for-each>
            <xsl:text>)</xsl:text>
            <xsl:text>
            return </xsl:text>
            <xsl:if test="not(starts-with(@return-type, 'function(') or ../../@name = 'random-number-generator')">
               <!-- we can't compare functions using deep-equal, nor any other way; so skip this part of the test -->
               <xsl:text>fn:deep-equal($x, </xsl:text>
               <!--<xsl:if test="../..//property[.='focus-dependent']">
                  <xsl:text>/doc/e!</xsl:text>
               </xsl:if>-->
               <xsl:text>{if (..//@default='.') then "/doc!" else ""}{$prefix}:{../../@name}(</xsl:text>
               <xsl:for-each select="arg">
                  <xsl:if test="position() != 1">, </xsl:if>
                  <xsl:apply-templates select="@type"/>
               </xsl:for-each>
               <xsl:text>)) and </xsl:text>
            </xsl:if>
            <xsl:text>$x instance of </xsl:text>
            <xsl:apply-templates select="@return-type"/>
         </test>
         <result>
            <assert-true/>
         </result>
      </test-case>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'item()') or starts-with(., 'xs:string') or starts-with(., 'xs:anyAtomicType')]" priority="5">
      <xsl:text>"abc"</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'item()*') or starts-with(., 'xs:string*') or starts-with(., 'xs:anyAtomicType*')]" priority="7">
      <xsl:text>("abc", "def")</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:numeric') 
      or starts-with(., 'xs:integer') 
      or starts-with(., 'xs:double')
      or starts-with(., 'xs:nonNegativeInteger')]" priority="5">
      <xsl:text>1</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:numeric*') 
      or starts-with(., 'xs:integer*') 
      or starts-with(., 'xs:double*')
      or starts-with(., 'xs:nonNegativeInteger*')]" priority="7">
      <xsl:text>(42, 43)</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:QName')]" priority="5">
      <xsl:text>fn:QName('uri', 'local')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:boolean')]" priority="5">
      <xsl:text>2=2</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:yearMonthDuration')]" priority="5">
      <xsl:text>xs:yearMonthDuration('P1Y')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:dayTimeDuration') or starts-with(., 'xs:duration')]" priority="5">
      <xsl:text>xs:dayTimeDuration('P1D')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:date')]" priority="5">
      <xsl:text>current-date()</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:time')]" priority="5">
      <xsl:text>current-time()</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:dateTime')]" priority="6">
      <xsl:text>current-dateTime()</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:gYear')]" priority="5">
      <xsl:text>xs:gYear('2022')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:gYearMonth')]" priority="5">
      <xsl:text>xs:gYear('2022-10')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:gMonth')]" priority="5">
      <xsl:text>xs:gYear('-10')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:gMonthDay')]" priority="5">
      <xsl:text>xs:gYear('-10-04')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:gDay')]" priority="5">
      <xsl:text>xs:gYear('--04')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:hexBinary')]" priority="5">
      <xsl:text>xs:hexBinary('')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:base64Binary')]" priority="5">
      <xsl:text>xs:base64Binary('')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'map(')]" priority="5">
      <xsl:text>map{{}}</xsl:text>
   </xsl:template>
   
   <xsl:template match="(@type|@return-type)[starts-with(., 'item-type(rng)')]" priority="5">
      <xsl:text>record(
   number   as xs:double,
   next     as (function() as record(number, next, permute, *)),
   permute  as (function(item()*) as item()*),
   *)</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'array(')]" priority="5">
      <xsl:text>[1,2,3]</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'xs:NOTATION')]" priority="5">
      <xsl:text>()</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'element(') or starts-with(., 'node()')]" priority="5">
      <xsl:text>/doc</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'function(')]" priority="5">
      <xsl:text>fn:boolean#1</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[matches(., 'function\(item\(\)[*+?]?\).*')]" priority="8">
      <xsl:text>fn:boolean#1</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[matches(., 'function\(item\(\)[*+?]?,\s*item\(\)[*+?]?\).*')]" priority="8">
      <xsl:text>fn:deep-equal#2</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'function(xs:anyAtomicType, item()*)')]" priority="8">
      <xsl:text>fn:deep-equal#2</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'function(xs:string, xs:string*)')]" priority="8">
      <xsl:text>fn:contains#2</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[starts-with(., 'union(')]" priority="8">
      <xsl:text>'data'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'collation']" priority="12">
      <xsl:text>fn:default-collation()</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'encoding']" priority="12">
      <xsl:text>'utf-8'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'form']" priority="12">
      <xsl:text>'nfc'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'picture']" priority="12">
      <xsl:text>'0.0'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'flags']" priority="12">
      <xsl:text>'x'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'calendar']" priority="12">
      <xsl:text>'AD'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'positions']" priority="12">
      <xsl:text>(1, 2)</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'timezone']" priority="12">
      <xsl:text>xs:dayTimeDuration('-PT5H')</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'base']" priority="12">
      <xsl:text>'http://example.com/'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'operator']" priority="12">
      <xsl:text>','</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'json']" priority="12">
      <xsl:text>'[42, 43]'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'href']" priority="12">
      <xsl:text>'BuiltInKeywords.xml'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'href'][../../@name='json-doc']" priority="13">
      <xsl:text>'JSONTestSuite/test_parsing/y_number.json'</xsl:text>
   </xsl:template>
   
   <xsl:template match="*[@name = 'arguments']/@type" priority="80">
      <xsl:text>[22]</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'input'][../../@name=('boolean', 'not')]" priority="12">
      <xsl:text>42</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'value'][../../@name='parse-ietf-date']" priority="12">
      <xsl:text>'Wed, 06 Jun 1994 07:29:35 GMT'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'value'][../../@name='parse-xml']" priority="12">
      <xsl:text>'&lt;a/>'</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'node'][../../@name='xml-to-json']" priority="12">
      <xsl:text>()</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../@name = 'options'][../../@name='serialize']" priority="12">
      <xsl:text>map{{}}</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type[../../@name=('sum', 'zero-or-one', 'exactly-one', 'avg')]" priority="12">
      <xsl:text>0</xsl:text>
   </xsl:template>
   
   <xsl:template match="@type" priority="2">
      <xsl:text>'{.}'</xsl:text>
   </xsl:template>
   
   <!--<xsl:template match="@type" priority="100">
      <xsl:message>matching function={../../@name} arg={../@name} type={.} </xsl:message>
      <xsl:next-match/>
   </xsl:template>-->
   
   <xsl:template match="@return-type">{.}</xsl:template>
   
   <xsl:template match="@return-type[.='map(union(xs:NCName, enum('''')), xs:anyURI)']">map(*)</xsl:template>

   
</xsl:stylesheet>
