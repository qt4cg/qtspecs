<?xml version='1.0'?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fos="http://www.w3.org/xpath-functions/spec/namespace"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="fos xs">

	<xsl:output method="xml" doctype-system="../../../schema/xsl-query.dtd"/>

	<!-- This stylesheet expects to take xpath-functions.xml as its principal input,
     and to write xpath-functions-expanded.xml as its output. It takes a secondary
     input from function-catalog.xml -->
	
	<!-- It is also used to expand the function definitions in the XSLT specification,
		using a different function catalog -->

	<xsl:param name="function-catalog" select="'function-catalog.xml'"/>
	<xsl:variable name="fosdoc" select="document($function-catalog, /)"/>
	
	<xsl:variable name="isFO" select="contains(/spec/header/title, 'Functions and Operators')" as="xs:boolean"/>

	<xsl:template match="/">
		<xsl:for-each select="1 to 20">
			<xsl:comment>DO NOT EDIT: GENERATED BY merge-function-specs.xsl</xsl:comment>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*" mode="#default summary">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction('doc')">
	<pre class="small">
      <xsl:variable name="doc" select="unparsed-text(resolve-uri(concat('../src/', string(.)), base-uri(/)), 'iso-8859-1')"/>
      <xsl:value-of select="translate($doc, '&#xD;', '')"/>
    </pre>
	</xsl:template>
	
	<xsl:template match="processing-instruction()">
		<xsl:copy/>
	</xsl:template>

	<xsl:function name="fos:get-function" as="element(fos:function)?">
		<xsl:param name="prefix" as="xs:string"/>
		<xsl:param name="local" as="xs:string"/>
		<xsl:variable name="fspec"
			select="$fosdoc/fos:functions/fos:function
		[@name=$local][(@prefix, 'fn')[1]=$prefix]"/>
		<xsl:if test="empty($fspec)">
			<xsl:message>Function not found in catalog: <xsl:value-of select="$prefix, $local"
					separator=":"/></xsl:message>
		</xsl:if>
		<xsl:if test="exists($fspec[2])">
			<xsl:message>Duplicate function found in catalog: <xsl:value-of select="$prefix, $local"
				separator=":"/></xsl:message>
		</xsl:if>
		<xsl:sequence select="$fspec"/>
	</xsl:function>

	<xsl:template match="head[processing-instruction('function')]">
		<xsl:variable name="lexname" select="processing-instruction('function')/normalize-space(.)"/>
		<xsl:variable name="fspec"
			select="fos:get-function(substring-before($lexname, ':'), substring-after($lexname,':'))"/>
		<head>
			<xsl:value-of select="$lexname"/>
		</head>
		<glist>
			<gitem>
				<label>Summary</label>
				<def>
					<xsl:copy-of select="$fspec/fos:summary/(@diff, @at)"/>
					<xsl:apply-templates select="$fspec/fos:summary/node()" mode="summary"/>
				</def>
			</gitem>
			<xsl:if test="$fspec/fos:opermap">
				<gitem>
					<label>Operator Mapping</label>
					<def>
						<p>
							<xsl:copy-of select="$fspec/fos:opermap/(@diff, @at)"/>
							<xsl:copy-of select="$fspec/fos:opermap/node()" copy-namespaces="no"/>
						</p>
					</def>
				</gitem>
			</xsl:if>
			<gitem>
				<label>Signature<xsl:value-of select="'s'[$fspec/fos:signatures/fos:proto[2]]"
					/></label>
				<def>
					<xsl:copy-of select="$fspec/fos:signatures/(@diff, @at)"/>
					<xsl:apply-templates select="$fspec/fos:signatures/fos:proto"/>
				</def>
			</gitem>
			<xsl:if test="$fspec/fos:properties">
				<gitem>
					<label>Properties</label>
					<def>
						<xsl:copy-of select="$fspec/fos:properties/(@diff, @at)"/>
						<xsl:for-each select="$fspec/fos:properties">
							<p>
								<xsl:choose>
									<xsl:when test="last() = 1">
										<xsl:text>This function is </xsl:text>
									</xsl:when>
									<xsl:otherwise> <xsl:text>The </xsl:text>
										<xsl:number value="@arity" format="w"/>
										<xsl:text>-argument form of this function is </xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:for-each select="fos:property[not(. = 'special-streaming-rules')]">
									<xsl:call-template name="make-property-termref"/>
									<xsl:if test="position() != last()">, </xsl:if>
									<xsl:if test="position() = last() - 1"> and </xsl:if>
								</xsl:for-each>
								<xsl:text>. </xsl:text>
								<xsl:apply-templates select="fos:property/@dependency"/>
							</p>
						</xsl:for-each>
					</def>
				</gitem>
			</xsl:if>
			<gitem>
				<label>Rules</label>
				<def>
					<xsl:copy-of select="$fspec/fos:rules/(@diff, @at)"/>
					<xsl:apply-templates select="$fspec/fos:rules/node()"/>
				</def>
			</gitem>
			<xsl:if test="$fspec/fos:errors">
				<gitem>
					<label>Error Conditions</label>
					<def>
						<xsl:copy-of select="$fspec/fos:errors/(@diff, @at)"/>
						<xsl:copy-of select="$fspec/fos:errors/node()" copy-namespaces="no"/>
					</def>
				</gitem>
			</xsl:if>
			<xsl:if test="$fspec/fos:notes">
				<gitem>
					<label>Notes</label>
					<def>
						<xsl:copy-of select="$fspec/fos:notes/(@diff, @at)"/>
						<xsl:apply-templates select="$fspec/fos:notes/node()" mode="make-note"/>
					</def>
				</gitem>
			</xsl:if>
			<xsl:if test="$fspec/fos:examples">
				<gitem>
					<label>Examples</label>
					<def role="example">
						<xsl:copy-of select="$fspec/fos:examples/(@diff, @at)"/>
						<xsl:apply-templates select="$fspec/fos:examples/node()"/>
					</def>
				</gitem>
			</xsl:if>
			<xsl:if test="$fspec/fos:history">
				<gitem>
					<label>History</label>
					<def role="example"><p>
						<xsl:apply-templates select="$fspec/fos:history/fos:version/node()"/>
					</p></def>
				</gitem>
			</xsl:if>
		</glist>
	</xsl:template>
	
	<xsl:template match="*" mode="make-note">
		<xsl:copy copy-namespaces="no">
			<xsl:attribute name="role" select="'note'"/>
			<xsl:copy-of select="node()" copy-namespaces="no"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="make-property-termref">
		<xsl:choose>
			<xsl:when test="$isFO">
				<!-- Functions and Operators spec -->
				<termref def="dt-{.}"><xsl:value-of select="."/></termref>
			</xsl:when>
			<xsl:otherwise>
				<!-- Typically the XSLT spec -->
				<xtermref spec="FO30" ref="dt-{.}"><xsl:value-of select="."/></xtermref>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template match="@dependency"> It depends on 
		<xsl:value-of select="replace(translate(string-join(tokenize(., '\s+'), ', and '), '-', ' '), 'uri', 'URI')"/>.
	</xsl:template>

	<xsl:template match="fos:proto">
		<xsl:variable name="isOp" as="xs:boolean" select="exists(../../fos:opermap)"/>
		<example role="signature">
			<xsl:variable name="prefix" select="../../@prefix"/>
			<proto name="{@name}" return-type="{@return-type}"
				isOp="{if ($isOp) then 'yes' else 'no'}"
				prefix="{if ($prefix) then $prefix else if ($isOp) then 'op' else 'fn'}">
				<xsl:copy-of select="@diff, @at"/>
				<xsl:apply-templates/>
			</proto>
		</example>
	</xsl:template>

	<xsl:template match="fos:arg">
		<arg name="{@name}" type="{@type}">
			<xsl:copy-of select="@diff, @at, @default"/>
		</arg>
	</xsl:template>
	
	<xsl:template match="fos:arg[@type='record']">
		<!-- Capture the details of the record into a JSON structure which we squeeze into the @type attribute -->
		<arg name="{@name}" role="record">
			<xsl:attribute name="type">
				<xsl:variable name="fields" as="map(*)*">
					<xsl:for-each select="fos:record/fos:field">
						<xsl:sequence select="map{'name':string(@name), 'type':string(@type), 'required':xs:boolean(@required)}"/>
					</xsl:for-each>
					<xsl:sequence select="map{'extensible':xs:boolean(fos:record/@extensible)}"/>
				</xsl:variable>
				<xsl:value-of select="serialize(array{$fields}, map{'method':'json'})"/>
			</xsl:attribute>
			<xsl:copy-of select="@diff, @at, @default"/>
		</arg>
	</xsl:template>

	<xsl:template match="fos:example">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="fos:variable">
		<eg>
			<xsl:copy-of select="@diff, @at"/>
			<xsl:value-of select="concat('let $', @name, ' := ')"/>
			<xsl:if test="@select">
					<xsl:value-of select="@select"/>
			</xsl:if>
			<xsl:if test="child::node()">
					<xsl:apply-templates/>
			</xsl:if>
		</eg>		
	</xsl:template>

	<xsl:template match="fos:test">
		<p>
			<xsl:copy-of select="@diff, @at"/>
			<xsl:choose>
				<xsl:when test="fos:preamble">
					<xsl:copy-of select="fos:preamble/node()" copy-namespaces="no"/>
				</xsl:when>
				<xsl:otherwise>The expression </xsl:otherwise>
			</xsl:choose>
			<code>
				<xsl:choose>
					<xsl:when test="fos:expression/@xml:space='preserve'">
						<xsl:value-of select="translate(fos:expression, ' ', '&#xa0;')"/>
					</xsl:when>
                                        <xsl:when test="fos:expression/eg">
                                          <xsl:apply-templates select="fos:expression/node()"/>
                                        </xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fos:expression"/>
					</xsl:otherwise>
				</xsl:choose>
			</code>
			<xsl:choose>
				<xsl:when test="fos:result[2]">
					<xsl:text> returns one of the following: </xsl:text>
					<xsl:for-each select="fos:result">
						<xsl:if test="position() ne 1">
							<xsl:text> or </xsl:text>
						</xsl:if>
						<code>
							<xsl:value-of select="."/>
						</code>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="fos:result[@normalize-space='true']">
					<xsl:text> returns (with whitespace added for legibility):</xsl:text>
				</xsl:when>
				<xsl:when test="fos:result">
					<xsl:text> returns </xsl:text>
					<xsl:if test="fos:result/@allow-permutation='true'">
						<xsl:text>some permutation of </xsl:text>
					</xsl:if>
                                        <xsl:choose>
                                          <xsl:when test="fos:result/eg">
                                            <xsl:apply-templates select="fos:result/node()"/>
                                          </xsl:when>
                                          <xsl:otherwise>
					    <code>
					      <xsl:value-of select="fos:result"/>
					    </code>
                                          </xsl:otherwise>
                                        </xsl:choose>
					<xsl:if test="fos:result/@approx='true'">
						<xsl:text> (approximately)</xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:when test="fos:error-result">
					<xsl:text> raises error </xsl:text>
					<code>
						<xsl:value-of select="fos:error-result/@error-code"/>
					</code>
				</xsl:when>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="fos:result[@normalize-space='true']"/>
				<xsl:when test="fos:postamble">
					<xsl:text>. </xsl:text>
					<emph>
						<xsl:text>(</xsl:text>
						<xsl:copy-of select="fos:postamble/node()" copy-namespaces="no"/>
						<xsl:text>)</xsl:text>
						<xsl:if test="not(ends-with(fos:postamble, '.'))">.</xsl:if>
					</emph>
				</xsl:when>
				<xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
		</p>
		<xsl:if test="fos:result[@normalize-space='true']">
			<eg><xsl:value-of select="fos:result"/></eg>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="summary">
		<xsl:value-of select="replace(., 'Summary: ', '')"/>
	</xsl:template>

	<xsl:template match="processing-instruction('local-function-index')">
		<table class="index">
			<thead>
				<tr>
					<th>Function</th>
					<th>Meaning</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each
					select="following-sibling::*[starts-with(local-name(), 'div')][head/processing-instruction()]">
					<xsl:variable name="lexname" select="string(head/processing-instruction())"/>
					<xsl:variable name="fspec"
						select="fos:get-function(substring-before($lexname,':'), substring-after($lexname,':'))"/>
					<tr>
						<td style="white-space:nowrap; vertical-align:top">
							<code style="padding-right: 10px">
								<xsl:value-of select="$lexname"/>
							</code>
						</td>
						<td>
							<xsl:apply-templates select="$fspec/fos:summary/*/node()" mode="summary"
							/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	
	<!-- remove dummy termdefs used in XSLT to ensure no dangling references -->
	<xsl:template match="p[termdef[@role='placemarker']]"/>
	
	<!-- Handle option parameter specifications -->
	
	<xsl:template match="fos:options">
		<table style="border-collapse: collapse">
			<xsl:copy-of select="@diff, @at"/>
			<thead>
				<tr style="border-top: 2px solid black; border-bottom: 2px solid black">
					<th style="text-align:left; padding-right: 10px; ">Key</th>
					<xsl:if test="fos:option/fos:applies-to">
						<th style="text-align:left; padding-right: 10px; ">Applies to</th>
					</xsl:if>
					<xsl:if test="exists(.//fos:values)">
						<th style="text-align:left; padding-right: 10px; ">Value</th>
					</xsl:if>
					<th style="text-align:left">
						<!--<xsl:if test="exists(.//fos:values)">
							<xsl:attribute name="colspan">2</xsl:attribute>
						</xsl:if>-->
						<xsl:text>Meaning</xsl:text>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="fos:option"/>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="fos:option">
		<tr>
			<xsl:copy-of select="@diff, @at"/>
			<td style="white-space:nowrap; padding-right: 10px; vertical-align:top; border-bottom: 2px solid black" 
				rowspan="{1 + count(fos:values/fos:value)}">
				<code><xsl:value-of select="@key"/></code>
			</td>
			<xsl:if test="../fos:option/fos:applies-to">
				<td style="white-space:nowrap; padding-right: 10px; vertical-align:top; border-bottom: 2px solid black" 
					rowspan="{1 + count(fos:values/fos:value)}">
					<xsl:value-of select="fos:applies-to"/>
				</td>
			</xsl:if>
			<xsl:variable name="thickness" select="if (exists(fos:values)) then '1' else '2'"/>
			<td style="vertical-align:top; border-bottom: {$thickness}px solid black">
				<xsl:if test="exists(..//fos:values)">
					<xsl:attribute name="colspan">2</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="fos:meaning/node()"/>
				<ulist>
					<item><p><term>Type: </term><code><xsl:value-of select="fos:type"/></code></p></item>
					<xsl:if test="fos:default">
						<item><p><term>Default: </term><code><xsl:value-of select="fos:default"/></code></p></item>
					</xsl:if>
				</ulist>
			</td>
		</tr>

		<xsl:for-each select="fos:values/fos:value">
			<xsl:variable name="thickness" select="if (position()=last()) then '2' else '1'"/>
			<tr>
				<td style="white-space:nowrap; padding-right: 10px; vertical-align:top; border-bottom: {$thickness}px solid black">
					<code><xsl:value-of select="@value"/></code>
				</td>
				<td style="vertical-align:top; border-bottom: {$thickness}px solid black">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>

	</xsl:template>
	
	<xsl:template match="fos:history|fos:version"/>
	
</xsl:stylesheet>
