<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="4.0"
   xmlns:fos="http://www.w3.org/xpath-functions/spec/namespace"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xpath-default-namespace="http://www.w3.org/xpath-functions/spec/namespace"
   expand-text="yes">
   
   <!-- Generate an XQuery module that tests the examples in the spec against
        the executable "formal specifications" of those functions that have such a
        specification -->
   
   <!-- Run against the function-catalog.xml source document -->
   
   <xsl:output method="text"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="NL" select="char(10)"/>
   <xsl:mode on-no-match="deep-skip"/>
   
   <xsl:template match="/">
      <xsl:text>xquery version "4.0";{$NL}{$NL}</xsl:text>
      <xsl:text>(: This file is generated automatically by the
   qtspecs build process. Any changes you 
   make to this file will be lost on the next build. Have a nice day. :){$NL}{$NL}</xsl:text>
      
      <xsl:text>declare namespace dm="http://www.w3.org/qt4/datamodel";{$NL}{$NL}</xsl:text>
      <xsl:text>declare namespace array="http://dummy/array";{$NL}{$NL}</xsl:text>
      <xsl:text>declare namespace array0="http://www.w3.org/2005/xpath-functions/array";{$NL}{$NL}</xsl:text>
      <xsl:text>declare namespace map="http://dummy/map";{$NL}{$NL}</xsl:text>
      <xsl:text>declare namespace map0="http://www.w3.org/2005/xpath-functions/map";{$NL}{$NL}</xsl:text>
      
      <xsl:text>declare function dm:iterate-array($array as array(*), $action as fn(item()*, xs:integer) as item()*) {{
      array0:for-each($array, $action)
}};</xsl:text>
      
      <xsl:text>declare function dm:array-append($array as array(*), $member as item()*) {{
      array0:append($array, $member)
}};</xsl:text>
      
      <xsl:text>declare function dm:iterate-map($map as map(*), $action as fn(xs:anyAtomicType, item()*) as item()*) {{
      map0:for-each($map, $action)
}};</xsl:text>
      
      <xsl:text>declare function dm:map-put($map as map(*), $key as xs:anyAtomicType, $value as item()*) {{
      map0:put($map, $key, $value)
}};</xsl:text>
      
      <xsl:apply-templates select="//fos:function[@prefix=('array', 'map')]"/>
      <xsl:text>element result {{</xsl:text>
      <xsl:apply-templates select="//fos:test"/>
      <xsl:text>()}}</xsl:text>

 
   </xsl:template>
   
   <xsl:template match="fos:function[fos:equivalent]">
      <xsl:apply-templates select="fos:equivalent"/>
   </xsl:template>
   
   <xsl:template match="fos:function[not(fos:equivalent)]" name="redirect">
      <xsl:text>{fos:sig(.)} {{ {$NL}{$NL}</xsl:text>
      <xsl:text>    {@prefix}0:{@name}( </xsl:text>
      <xsl:value-of select="fos:signatures/fos:proto[1]/fos:arg ! ('$' || @name)" separator=", "/>
      <xsl:text>){$NL} }};{$NL}</xsl:text>
   </xsl:template>
   
   <xsl:template match="fos:function[@name='get' and @prefix='array']" priority="100">
      <!-- Special case for now because Saxon can't handle the default value of the @fallback arg -->
      <xsl:text>declare function array:get($array as array(*), $index as xs:integer, $fallback as item()* := ()) {{ 
         array0:get($array, $index, $fallback)
}};{$NL}{$NL} </xsl:text>
   </xsl:template>
   
   
   <xsl:function name="fos:sig" as="xs:string">
      <xsl:param name="fn" as="element(fos:function)"/>
      <xsl:value-of>
         <xsl:text>declare function {$fn/@prefix}:{$fn/@name} ({$NL}</xsl:text>
         <xsl:for-each select="$fn/fos:signatures[1]/fos:proto[last()]/fos:arg">
            <xsl:variable name="not-last" select="exists(following-sibling::fos:arg)"/>
            <xsl:text>   ${@name} as {@type}{if (@default) then (' := ' || @default) else ()}{','[$not-last]}{$NL}</xsl:text>
         </xsl:for-each>
         <xsl:text>) </xsl:text>
      </xsl:value-of>
   </xsl:function>
   
   
   <xsl:template match="fos:equivalent[@style='xquery-function']">
      <xsl:value-of select="."/>
      <xsl:text>{$NL}{$NL}</xsl:text>
   </xsl:template>
   
   <xsl:template match="fos:equivalent[@style=('xquery-expression', 'xpath-expression', 'dm-primitive')]">
      <xsl:text>{fos:sig(..)} {{ {$NL}{$NL}</xsl:text>
      <xsl:value-of select="replace(., '(\n)', '$1        ')"/>
      <xsl:text>}};{$NL}{$NL}</xsl:text>
   </xsl:template>
   
   <xsl:template match="fos:test[ancestor::fos:function//fos:equivalent]">
      <xsl:variable name="this" select="."/>
      <xsl:variable name="desc" select="ancestor::fos:function/(@prefix || ':' || @name || '#') 
                                          || generate-id()"/>
      <xsl:text>(: {$desc} :){$NL}</xsl:text>
      <xsl:for-each select="tokenize(@use)">
         <xsl:variable name="var" select="$this/ancestor::fos:function/fos:examples/fos:variable[@id=current()]"/>
         <xsl:assert test="exists($var)">Failed to find declaration of variable ${.}</xsl:assert>
         <xsl:text>let ${$var/@name} as {$var/@as otherwise 'item()*'} := {$var/@select} return{$NL}</xsl:text>
      </xsl:for-each>
      <xsl:text>let $result := {fos:expression}
         return 
            if (deep-equal($result, ({fos:result}))) 
            then () 
            else 'failed {$desc} actual = ' || serialize($result, {{'method':'adaptive'}}) || char(10), {$NL}{$NL}</xsl:text>
   </xsl:template>
   
   <!-- Tests temporarily excluded because not implemented in Saxon -->
   <xsl:template match="fos:function[@prefix='array'][@name='sort']//fos:test" priority="100"/>
   
   
   
</xsl:stylesheet>
