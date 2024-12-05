<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0" expand-text="true">
    <!--<xsl:import href="../../../xpath-functions-40/style/xpath-functions.xsl"/>-->

    <xsl:import href="../../style/expath-functions.xsl"/>
    
    <xsl:variable name="expath-catalog" select="doc('../src/function-catalog.xml')"/>
    
    <xsl:variable name="expath-prefix" select="'file'"/>
    
</xsl:stylesheet>
