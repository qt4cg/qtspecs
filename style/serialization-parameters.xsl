<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sp="http://www.w3.org/xslt-xquery-serialization/spec/catalog"
    xmlns:e="http://www.w3.org/1999/XSL/Spec/ElementSyntax"
    exclude-result-prefixes="xs sp e"
    expand-text="yes"
    version="3.0">

  <xsl:variable name="sp:catalog" as="document-node()"
    select="doc(resolve-uri('../specifications/xslt-xquery-serialization-40/src/serialization-parameters.xml',
      static-base-uri()))"/>
  <xsl:variable name="sp:params" as="element(sp:param)*" select="$sp:catalog/sp:parameters/sp:param"/>

  <xsl:template match="processing-instruction('serialization-parameters')">
    <xsl:variable name="table" select="normalize-space(.)"/>
    <xsl:choose>
      <xsl:when test="$table = 'serialization'">
        <xsl:call-template name="sp:check-schema"/>
        <table role="medium no-code-break" border="1" summary="Serialization parameters">
          <col span="1" width="30%"/>
          <col span="1"/>
          <thead>
            <tr>
              <th align="left" rowspan="1" colspan="1">Serialization parameter name</th>
              <th align="left" rowspan="1" colspan="1">Permitted values for parameter</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="$sp:params[sp:values]">
              <tr>
                <xsl:sequence select="sp:diff(., sp:values)"/>
                <td rowspan="1" colspan="1" valign="top"><code>{ @name }</code></td>
                <td rowspan="1" colspan="1">
                  <xsl:copy-of select="sp:values/node()" copy-namespaces="no"/>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="$table = 'fn-serialize'">
        <table role="no-code-break data">
          <thead>
            <tr>
              <th>Parameter</th>
              <th>Required type</th>
              <th>Interpretation</th>
              <th>Default Value</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="$sp:params/sp:fn-serialize">
              <tr>
                <xsl:sequence select="sp:diff(.., .)"/>
                <td><code>{ ../@name }</code></td>
                <td><code>{ @type }</code></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="sp:interpretation">
                      <xsl:copy-of select="sp:interpretation/node()" copy-namespaces="no"/>
                    </xsl:when>
                    <xsl:when test="@type = 'xs:boolean?'">
                      <code>true</code> means <code>"yes"</code>,
                      <code>false</code> means <code>"no"</code>
                    </xsl:when>
                  </xsl:choose>
                </td>
                <td><xsl:sequence select="sp:default(.)"/></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="$table = 'xquery'">
        <table width="100%" border="1" role="small">
          <tbody>
            <tr>
              <th>Component</th>
              <th>Default initial value</th>
            </tr>
            <xsl:for-each select="$sp:params/sp:xquery">
              <tr>
                <xsl:sequence select="sp:diff(.., .)"/>
                <td>{ ../@name }</td>
                <td><xsl:sequence select="sp:default(.)"/></td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="$table = 'xslt'">
        <xsl:call-template name="sp:check-element-catalog"/>
        <table>
          <caption>Serialization Parameters defined by <elcode>xsl:output</elcode></caption>
          <thead>
            <tr>
              <th>Attribute</th>
              <th>Effect</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="$sp:params/sp:xslt">
              <tr>
                <xsl:sequence select="sp:diff(.., .)"/>
                <th><p>{ ../@name }</p></th>
                <td>
                  <xsl:choose>
                    <xsl:when test="sp:effect">
                      <xsl:copy-of select="sp:effect/node()" copy-namespaces="no"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <p>The default value is <xsl:sequence select="sp:default(.)"/>.</p>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="$table = 'xslt-list'">
        <xsl:for-each select="$sp:params">
          <xsl:if test="position() = last()">and </xsl:if>
          <code>
            <xsl:sequence select="sp:diff(., ())"/>
            <xsl:value-of select="(sp:xslt/@attribute, @name)[1]"/>
          </code>
          <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">Unknown serialization parameter table: { $table }</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:function name="sp:diff" as="attribute()*">
    <xsl:param name="param" as="element(sp:param)"/>
    <xsl:param name="host"  as="element()?"/>
    <xsl:sequence select="if ($host/@diff) then $host/(@diff, @at) else $param/(@diff, @at)"/>
  </xsl:function>

  <xsl:function name="sp:default" as="node()*">
    <xsl:param name="host" as="element()"/>
    <xsl:choose>
      <xsl:when test="$host/sp:default">
        <xsl:copy-of select="$host/sp:default/node()" copy-namespaces="no"/>
      </xsl:when>
      <xsl:when test="($host/@default, $host/../@default)">
        <code>{ ($host/@default, $host/../@default)[1] }</code>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">No default value for { $host/../@name }
          ({ local-name($host) })</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:template name="sp:check-schema">
    <xsl:variable name="schema"
      select="doc(resolve-uri('../specifications/xslt-xquery-serialization-40/src/schema-for-serialization-parameters.xsd',
        static-base-uri()))"/>
    <xsl:sequence select="sp:compare('schema-for-serialization-parameters.xsd', $sp:params/@name,
      $schema//xs:element[@substitutionGroup]/@name)"/>
  </xsl:template>

  <xsl:template name="sp:check-element-catalog">
    <xsl:variable name="catalog"
      select="doc(resolve-uri('../specifications/xslt-40/src/element-catalog.xml', static-base-uri()))"/>
    <xsl:variable name="output" select="$catalog//e:element-syntax[@name = 'output']/e:attribute/@name"/>
    <xsl:variable name="result" select="$catalog//e:element-syntax[@name = 'result-document']/e:attribute/@name"/>
    <xsl:sequence select="sp:compare('xsl:output', $sp:params/@name, $output)"/>
    <xsl:sequence select="sp:compare('xsl:result-document',
      $sp:params/(sp:xslt/@attribute, @name)[1], $result)"/>
  </xsl:template>

  <xsl:function name="sp:compare" as="empty-sequence()">
    <xsl:param name="target"   as="xs:string"/>
    <xsl:param name="expected" as="xs:string*"/>
    <xsl:param name="found"    as="xs:string*"/>
    <xsl:variable name="missing" select="$expected[not(. = $found)]"/>
    <xsl:if test="exists($missing)">
      <xsl:message terminate="yes">Serialization parameters missing in { $target }:
        { $missing }</xsl:message>
    </xsl:if>
  </xsl:function>
</xsl:stylesheet>
