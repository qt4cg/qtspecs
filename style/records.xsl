<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:local="http://www.w3.org/xpath-functions/build/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.w3.org/2016/local-functions"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:template match="record">
  <xsl:variable name="id" select="(@id, ../@id)[1]"/>
  <div class="record">
    <xsl:if test="$id ne ''">
      <xsl:attribute name="id" select="$id"/>
      <div class="title">
        <code class="return-type-ref">
          <xsl:value-of select="$id"/>
        </code>
        <xsl:text>:</xsl:text>
      </div>
    </xsl:if>
    <table class="record" border="0">
      <tr>
        <td colspan="2">
          <code>record(</code>
        </td>
      </tr>
      <xsl:for-each select="arg">
        <tr class="arg">
          <td>
            <code>
              <xsl:if test="@occur">
                <xsl:attribute name="class" select="@occur"/>
              </xsl:if>
              <xsl:value-of select="@name"/>
              <xsl:if test="@occur = 'opt'">?</xsl:if>
            </code>
          </td>
          <td>
            <xsl:if test="@type">
              <code class="as">as&#160;</code>
              <code>
                <xsl:value-of select="@type"/>
              </code>
            </xsl:if>
            <xsl:if test="@type-ref">
              <code class="as">as&#160;</code>
              <a href="#{@type-ref}">
                <xsl:value-of select="@type-ref"/>
              </a>
            </xsl:if>
            <xsl:if test="not(position() = last())">,</xsl:if>
          </td>
        </tr>
      </xsl:for-each>
      <tr>
        <td colspan="2">
          <code>)</code>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="arg">
  <xsl:if test="preceding-sibling::arg">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@name = '...'">
      <span class="varargs">...</span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="@name"/>
      <xsl:if test="@type">
        <code class="as">&#160;as&#160;</code>
        <xsl:apply-templates select="@type" mode="render-type"/>  
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<!-- The default font used for W3C specs doesn't display Greek letters nicely, so we cheat -->
<xsl:template match="arg/@name[matches(.,'^\p{IsGreek}+$')]" priority="9">
  <code class="arg">$</code><span style="font-family:Times; font-style:italic"><xsl:value-of select="."/></span>
</xsl:template>
  
<xsl:template match="arg/@name" priority="8">
  <xsl:param name="small" tunnel="yes" as="xs:string" select="''"/>
  <code class="{$small}arg">$<xsl:value-of select="."/></code>
</xsl:template>
  
<xsl:template match="@type">
  <code class="type">
    <xsl:value-of select="."/>
    <xsl:if test="../@emptyOk='yes'">?</xsl:if>
  </code>
</xsl:template>
  
<xsl:template match="arg" mode="tabular">
  <xsl:param name="small" tunnel="yes" select="''"/>
  <td style="vertical-align:baseline">
    <xsl:choose>
      <xsl:when test="@name = '...'">
        <span class="varargs">...</span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </td>

  <td style="vertical-align:baseline">
    <xsl:if test="@name != '...'">
      <code class="{$small}as">&#160;as&#160;</code>
      <!--<code class="{$small}type">
        <xsl:value-of select="@type"/>
        <xsl:if test="@emptyOk='yes'">?</xsl:if>
      </code>-->
      <xsl:apply-templates select="@type" mode="render-type"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="following-sibling::arg">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>)</xsl:text>
        <code class="{$small}as">&#160;as&#160;</code>
	<xsl:choose>
	  <xsl:when test="parent::proto/@returnVaries = 'yes'">
	    <code class="return-varies">
	      <xsl:value-of select="parent::proto/@return-type"/>
	      <xsl:if test="parent::proto/@returnEmptyOk='yes'">?</xsl:if>
	    </code>
	  </xsl:when>
	  <xsl:otherwise>
	    <code class="{$small}return-type">
	      <xsl:apply-templates select="parent::proto/@return-type" mode="render-type"/>
	      <xsl:if test="parent::proto/@returnEmptyOk='yes'">?</xsl:if>
	    </code>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </td>
</xsl:template>

</xsl:stylesheet>
