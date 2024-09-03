<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
   xmlns="http://www.w3.org/2010/09/qt-fots-catalog"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xpath-default-namespace="http://www.w3.org/xpath-functions/spec/namespace"
   exclude-result-prefixes="#all"
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

      <test-set name="misc-BuiltInKeywords" covers-40="PR197">
         <description>Tests for keyword argument names to built-in functions</description>        
         <dependency type="spec" value="XP40+ XQ40+"/>
         <xsl:comment>Generated using generate-keyword-test-set.xsl from function-catalog.xml at {current-dateTime()}</xsl:comment>
         <environment name="ka">
            <namespace prefix="math" uri="http://www.w3.org/2005/xpath-functions/math"/>
            <decimal-format name="data" decimal-separator="." grouping-separator=","/>
            <source role="." file="BuiltInKeywords/simple-doc.xml"/>
         </environment>
         <xsl:apply-templates select="//function"/>
      </test-set>      
   </xsl:template>
   
   <xsl:template match="function[@prefix='op', 'xs']"/>
  
   
   <xsl:template match="function">
      <xsl:apply-templates select=".//proto"/>
   </xsl:template>
   
   
   
   <xsl:template match="proto">
      <xsl:variable name="prefix" select="(../../@prefix, 'fn')[1]"/>
      <test-case name="Keywords-{$prefix}-{../../@name}-{count(preceding-sibling::*)+1}">
         <description>Test of keyword arguments in {$prefix}:{../../@name}</description>
         <created by="generate-keyword-test-set.xsl" on="{adjust-date-to-timezone(current-date(), ())}"/>
         <environment ref="ka"/>
         <test>
            <xsl:text>{$prefix}:{../../@name}</xsl:text>
            <xsl:choose>
               <xsl:when test="empty(arg)">#0 </xsl:when>
               <xsl:otherwise>
                  <xsl:text>(</xsl:text>
                  <xsl:for-each select="arg">
                     <xsl:if test="position() != 1">, </xsl:if>
                     <xsl:text>{@name} := ?</xsl:text>
                  </xsl:for-each>
                  <xsl:text>) </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>instance of function(</xsl:text>
            <xsl:for-each select="arg">
              <xsl:if test="position() != 1">, </xsl:if>
              <xsl:text>{@type}</xsl:text>
            </xsl:for-each>
            <xsl:text>) as {(@return-type, 'item()*')[1]}</xsl:text>
         </test>
         <result>
            <assert-true/>
         </result>
      </test-case>
   </xsl:template>
   
 
   
   
</xsl:stylesheet>
