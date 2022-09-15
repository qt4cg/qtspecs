<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:import href="../../xpath-functions-40/style/merge-function-specs.xsl"/>

    <xsl:param name="built-in-streamability-expanded"
               select="'../build/built-in-streamability-expanded.xml'"/>
    
    <xsl:template match="/">
<!--
        <xsl:message select="'Transforming ' || base-uri(.)"/>
        <xsl:message select="'With ' || static-base-uri()"/>
-->
        <xsl:apply-imports/>
    </xsl:template>
    
    <xsl:template match="processing-instruction('built-in-function-streamability')">
        <xsl:copy-of select="doc($built-in-streamability-expanded)"/>
    </xsl:template>
    
</xsl:stylesheet>
