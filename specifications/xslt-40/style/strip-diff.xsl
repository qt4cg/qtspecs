<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">
  
  <!-- Remove diff markup from source document -->
  
  <!-- Note: suppress expansion of attribute defaults, eg XLink attributes -->

  
  <xsl:output method="xml" encoding="utf-8" indent="yes" cdata-section-elements="eg"/>

  <xsl:preserve-space elements="*"/>
  
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xsl:template match="*[@diff='del']"/>
  
  <xsl:template match="*[@diff=('add', 'chg')]" priority="3">
    <xsl:copy>
      <xsl:copy-of select="@* except (@diff, @at)"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="phrase[@diff=('add', 'chg')]" priority="4">
      <xsl:apply-templates/>
  </xsl:template>

 
  

</xsl:stylesheet>
