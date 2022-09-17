<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">

<!-- This is a cheap and cheerful identity transform that sets up
     the doctype system correctly for the grammar file. -->

<xsl:output method="xml" encoding="utf-8" indent="no"
            doctype-system="../../specifications/grammar-40/grammar.dtd"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="/" name="xsl:initial-template">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
