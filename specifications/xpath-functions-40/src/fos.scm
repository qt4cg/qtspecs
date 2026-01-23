<?xml version="1.0" encoding="UTF-8"?>
<scm:schema xmlns=""
            xmlns:scm="http://ns.saxonica.com/schema-component-model"
            generatedAt="2026-01-23T11:18:53.845013Z"
            xsdVersion="1.1"
            dmk="TGljZW5zb3I9U2F4b25pY2EKTGljZW5zZWU9Tm9ybSBUb3ZleS1XYWxzaApDb21wYW55PVNheG9uaWNhCkVtYWlsPW5vcm1Ac2F4b25pY2EuY29tClByb2R1Y3RDb2RlPURFClR5cGU9aW5kaXZpZHVhbApFZGl0aW9uPUVFClNBVD15ZXMKU0FRPXllcwpTQVY9eWVzCklzc3VlZD0yMDI2LTAxLTEyClNlcmllcz1OClNlcmlhbD1OMDEzOTc1ClVzZXI9UDAwMDEKRXZhbHVhdGlvbj1ubwpFeHBpcmF0aW9uPTIwMjctMDEtMTIKVXBncmFkZURheXM9MzY1Ck1haW50ZW5hbmNlRGF5cz0zNjUKU2lnbmF0dXJlMjAyND1FRTM3MkM3QUZGQTc4MDVBRjJCODdCNjRCRjUwOEEwMjQ1MTYyN0RDQjQ0QjNFQzVCRkYwQjNCNTlCMjE1RDc5NjE0N0YyRUEzMzYzMTcwNTg1OTI0RjExNDJEQzlEM0VDOTg1QUFBODZCOTVCMzE0MzVBQkEyMjI0MDY2MjcwNApTaWduYXR1cmU9MzAyQzAyMTQ2NkNCMUNCNzlGQzNFNkE2MzQwMjk1Q0E0NDcxQjRCMTRDOEU5NTMwMDIxNDI2N0QxMzBFQjcwRUM2M0RFMEY4NkIxQjgwMUVENkZFMEI2NDU2MEQK">
   <scm:simpleType id="C0"
                   name="operand-usage"
                   targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                   base="#NCName"
                   variety="atomic"
                   primitiveType="#string">
      <scm:enumeration value="inspection"/>
      <scm:enumeration value="absorption"/>
      <scm:enumeration value="navigation"/>
      <scm:enumeration value="transmission"/>
   </scm:simpleType>
   <scm:simpleType id="C1" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="XQuery"/>
      <scm:enumeration value="XPath"/>
   </scm:simpleType>
   <scm:simpleType id="C2" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="available-collections"/>
      <scm:enumeration value="default-place"/>
      <scm:enumeration value="environment-variables"/>
      <scm:enumeration value="known-function-signatures"/>
      <scm:enumeration value="decimal-formats"/>
      <scm:enumeration value="available-documents"/>
      <scm:enumeration value="default-language"/>
      <scm:enumeration value="namespaces"/>
      <scm:enumeration value="implicit-timezone"/>
      <scm:enumeration value="available-uri-collections"/>
      <scm:enumeration value="executable-base-uri"/>
      <scm:enumeration value="character-maps"/>
      <scm:enumeration value="schema-definitions"/>
      <scm:enumeration value="default-calendar"/>
      <scm:enumeration value="collations"/>
      <scm:enumeration value="static-base-uri"/>
   </scm:simpleType>
   <scm:simpleType id="C3"
                   base="#anySimpleType"
                   variety="list"
                   itemType="#positiveInteger"/>
   <scm:simpleType id="C4"
                   name="NCName-or-ellipsis"
                   targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                   base="#anySimpleType"
                   variety="union"
                   memberTypes="#NCName C5"/>
   <scm:simpleType id="C6"
                   base="#anySimpleType"
                   variety="list"
                   itemType="#positiveInteger"/>
   <scm:simpleType id="C7"
                   name="occurrence-indicator"
                   targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                   base="#string"
                   variety="atomic"
                   primitiveType="#string">
      <scm:enumeration value="?"/>
      <scm:enumeration value="*"/>
      <scm:enumeration value="+"/>
   </scm:simpleType>
   <scm:simpleType id="C8" base="#anySimpleType" variety="list" itemType="C2"/>
   <scm:simpleType id="C9" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="xpath-expression"/>
      <scm:enumeration value="xquery-function"/>
      <scm:enumeration value="dm-primitive"/>
      <scm:enumeration value="xquery-expression"/>
   </scm:simpleType>
   <scm:simpleType id="C10"
                   name="property-type"
                   targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                   base="#string"
                   variety="atomic"
                   primitiveType="#string">
      <scm:enumeration value="focus-independent"/>
      <scm:enumeration value="special-streaming-rules"/>
      <scm:enumeration value="focus-dependent"/>
      <scm:enumeration value="variadic"/>
      <scm:enumeration value="context-independent"/>
      <scm:enumeration value="nondeterministic"/>
      <scm:enumeration value="deterministic"/>
      <scm:enumeration value="nondeterministic-wrt-ordering"/>
      <scm:enumeration value="higher-order"/>
      <scm:enumeration value="context-dependent"/>
   </scm:simpleType>
   <scm:simpleType id="C5" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="..."/>
   </scm:simpleType>
   <scm:simpleType id="C11"
                   base="#string"
                   variety="atomic"
                   primitiveType="#string">
      <scm:enumeration value="add"/>
      <scm:enumeration value="chg"/>
      <scm:enumeration value="del"/>
   </scm:simpleType>
   <scm:element id="C12"
                name="errors"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C13"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C14"
                name="proto"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C15"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C16"
                name="field"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C17"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C18"
                name="examples"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C19"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C20"
                name="version"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C21"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C22"
                name="history"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C23"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C24"
                name="test"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C25"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C26"
                name="property"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C27"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C28"
                name="options"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C29"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C30"
                name="function"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C31"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C32"
                name="global-variables"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C33"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C34"
                name="signatures"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C35"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C36"
                name="rules"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C37"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C38"
                name="functions"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C39"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C40"
                name="notes"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C41"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C42"
                name="equivalent"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C43"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C44"
                name="properties"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C45"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C46"
                name="variable"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C47"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C48"
                name="opermap"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C49"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C50"
                name="postamble"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C51"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C52"
                name="record-type"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C53"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C54"
                name="record-description"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C55"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C56"
                name="expression"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C57"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C58"
                name="summary"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C59"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C60"
                name="error-result"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C61"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C62"
                name="arg"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C63"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C64"
                name="result"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C65"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C66"
                name="example"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C67"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C68"
                name="changes"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C69"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C70"
                  name="space"
                  targetNamespace="http://www.w3.org/XML/1998/namespace"
                  type="#NCName"
                  global="true"
                  inheritable="false"/>
   <scm:attributeGroup id="C71"
                       name="diff-markup"
                       targetNamespace="http://www.w3.org/xpath-functions/spec/namespace">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
   </scm:attributeGroup>
   <scm:complexType id="C13"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C74"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C74" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C74" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C74" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C15"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C75"/>
      <scm:attributeUse required="false" inheritable="false" ref="C76"/>
      <scm:attributeUse required="false" inheritable="false" ref="C77"/>
      <scm:attributeUse required="false" inheritable="false" ref="C78"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C62"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C62" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C62" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
      <scm:assertion nsContext="fos=http://www.w3.org/xpath-functions/spec/namespace vc=http://www.w3.org/2007/XMLSchema-versioning xs=~"
                     test="count((@return-type, @return-type-ref)) eq 1"
                     defaultNamespace=""
                     xml:base="file:/Volumes/Saxonica/src/qt4cg/qtspecs/specifications/xpath-functions-40/src/fos.xsd"/>
   </scm:complexType>
   <scm:complexType id="C17"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C79"/>
      <scm:attributeUse required="true" inheritable="false" ref="C80"/>
      <scm:attributeUse required="true" inheritable="false" ref="C81"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C82"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C82" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C19"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C83"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C66"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C46"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C66" to="1"/>
            <scm:edge term="C46" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C66" to="2"/>
            <scm:edge term="C46" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C66" to="2"/>
            <scm:edge term="C46" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C21"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C84"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementWildcard minOccurs="0" maxOccurs="unbounded" ref="C85"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C85" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C85" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C23"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C20"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C20" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C20" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C20" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C25"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C86"/>
      <scm:attributeUse required="false" inheritable="false" ref="C87"/>
      <scm:attributeUse required="false" inheritable="false" ref="C88"/>
      <scm:attributeUse required="false" inheritable="false" ref="C89"/>
      <scm:attributeUse required="false" inheritable="false" ref="C90"/>
      <scm:attributeUse required="false" inheritable="false" ref="C91" default="XPath">
         <scm:default lexicalForm="XPath">
            <scm:item type="#string" value="XPath"/>
         </scm:default>
      </scm:attributeUse>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C56"/>
            <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
               <scm:choice>
                  <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C64"/>
                  <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C60"/>
               </scm:choice>
            </scm:modelGroupParticle>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C92"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C50"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C56" to="1"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C60" to="2"/>
            <scm:edge term="C64" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C92" to="3"/>
            <scm:edge term="C50" to="4"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C50" to="4"/>
         </scm:state>
         <scm:state nr="4" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C27"
                    base="C10"
                    derivationMethod="extension"
                    abstract="false"
                    variety="simple"
                    simpleType="C10">
      <scm:attributeUse required="false" inheritable="false" ref="C93"/>
   </scm:complexType>
   <scm:complexType id="C29"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C94"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C94" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C94" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C94" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C31"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C95"/>
      <scm:attributeUse required="false" inheritable="false" ref="C96"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C34"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C48"/>
            <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C44"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C58"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C36"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C42"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C12"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C40"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C18"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C68"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C22"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C34" to="1"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C58" to="2"/>
            <scm:edge term="C44" to="3"/>
            <scm:edge term="C48" to="4"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C36" to="5"/>
         </scm:state>
         <scm:state nr="3">
            <scm:edge term="C58" to="2"/>
            <scm:edge term="C44" to="3"/>
         </scm:state>
         <scm:state nr="4">
            <scm:edge term="C58" to="2"/>
            <scm:edge term="C44" to="3"/>
         </scm:state>
         <scm:state nr="5" final="true">
            <scm:edge term="C22" to="6"/>
            <scm:edge term="C18" to="7"/>
            <scm:edge term="C68" to="8"/>
            <scm:edge term="C40" to="9"/>
            <scm:edge term="C12" to="10"/>
            <scm:edge term="C42" to="11"/>
         </scm:state>
         <scm:state nr="6" final="true"/>
         <scm:state nr="7" final="true">
            <scm:edge term="C22" to="6"/>
            <scm:edge term="C68" to="8"/>
         </scm:state>
         <scm:state nr="8" final="true">
            <scm:edge term="C22" to="6"/>
         </scm:state>
         <scm:state nr="9" final="true">
            <scm:edge term="C22" to="6"/>
            <scm:edge term="C18" to="7"/>
            <scm:edge term="C68" to="8"/>
         </scm:state>
         <scm:state nr="10" final="true">
            <scm:edge term="C22" to="6"/>
            <scm:edge term="C18" to="7"/>
            <scm:edge term="C68" to="8"/>
            <scm:edge term="C40" to="9"/>
         </scm:state>
         <scm:state nr="11" final="true">
            <scm:edge term="C22" to="6"/>
            <scm:edge term="C18" to="7"/>
            <scm:edge term="C68" to="8"/>
            <scm:edge term="C40" to="9"/>
            <scm:edge term="C12" to="10"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C33"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C46"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C46" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C46" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C35"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C14"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C14" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C14" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C14" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C37"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C97"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C28"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C54"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C28" to="1"/>
            <scm:edge term="C54" to="1"/>
            <scm:edge term="C97" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C28" to="2"/>
            <scm:edge term="C54" to="2"/>
            <scm:edge term="C97" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C28" to="2"/>
            <scm:edge term="C54" to="2"/>
            <scm:edge term="C97" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C39"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C32"/>
            <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C52"/>
            <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C30"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C30" to="1"/>
            <scm:edge term="C52" to="2"/>
            <scm:edge term="C32" to="3"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C30" to="4"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C30" to="1"/>
            <scm:edge term="C52" to="2"/>
         </scm:state>
         <scm:state nr="3">
            <scm:edge term="C30" to="1"/>
            <scm:edge term="C52" to="2"/>
         </scm:state>
         <scm:state nr="4" final="true">
            <scm:edge term="C30" to="4"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C41"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C98"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C98" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C98" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C98" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C43"
                    base="#string"
                    derivationMethod="extension"
                    abstract="false"
                    variety="simple"
                    simpleType="#string">
      <scm:attributeUse required="false" inheritable="false" ref="C99"/>
      <scm:attributeUse required="false" inheritable="false" ref="C100" default="true">
         <scm:default lexicalForm="true">
            <scm:item type="#boolean" value="true"/>
         </scm:default>
      </scm:attributeUse>
      <scm:attributeUse required="false" inheritable="false" ref="C101"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
   </scm:complexType>
   <scm:complexType id="C45"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C102"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C26"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C26" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C26" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C47"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C103"/>
      <scm:attributeUse required="true" inheritable="false" ref="C104"/>
      <scm:attributeUse required="true" inheritable="false" ref="C105"/>
      <scm:attributeUse required="false" inheritable="false" ref="C106"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C49"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="true" inheritable="false" ref="C107"/>
      <scm:attributeUse required="false" inheritable="false" ref="C108"/>
      <scm:attributeUse required="true" inheritable="false" ref="C109"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C110"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C110" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C110" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C51"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C111"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C111" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C111" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C53"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C112"/>
      <scm:attributeUse required="true" inheritable="false" ref="C113"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C58"/>
            <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C16"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C58" to="1"/>
            <scm:edge term="C16" to="2"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C16" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C16" to="3"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C16" to="3"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C55"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C114"/>
      <scm:attributeUse required="false" inheritable="false" ref="C115"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C116"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C116" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C116" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C116" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C57"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C70"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementWildcard minOccurs="0" maxOccurs="1" ref="C117"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C117" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C59"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C118"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C118" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C61"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="empty">
      <scm:attributeUse required="false" inheritable="false" ref="C119"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C63"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="empty">
      <scm:attributeUse required="true" inheritable="false" ref="C120"/>
      <scm:attributeUse required="false" inheritable="false" ref="C121"/>
      <scm:attributeUse required="false" inheritable="false" ref="C122"/>
      <scm:attributeUse required="false" inheritable="false" ref="C123"/>
      <scm:attributeUse required="false" inheritable="false" ref="C124"/>
      <scm:attributeUse required="false" inheritable="false" ref="C125"/>
      <scm:attributeUse required="false" inheritable="false" ref="C126"/>
      <scm:attributeUse required="false" inheritable="false" ref="C127"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
      <scm:assertion nsContext="fos=http://www.w3.org/xpath-functions/spec/namespace vc=http://www.w3.org/2007/XMLSchema-versioning xs=~"
                     test="count((@return-type, @return-type-ref)) le 1"
                     defaultNamespace=""
                     xml:base="file:/Volumes/Saxonica/src/qt4cg/qtspecs/specifications/xpath-functions-40/src/fos.xsd"/>
   </scm:complexType>
   <scm:complexType id="C65"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C128"/>
      <scm:attributeUse required="false" inheritable="false" ref="C129"/>
      <scm:attributeUse required="false" inheritable="false" ref="C130"/>
      <scm:attributeUse required="false" inheritable="false" ref="C131"/>
      <scm:attributeUse required="false" inheritable="false" ref="C132"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementWildcard minOccurs="0" maxOccurs="1" ref="C133"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C133" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C67"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C134"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C24"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C24" to="1"/>
            <scm:edge term="C134" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C24" to="1"/>
            <scm:edge term="C134" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C69"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C135"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C135" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C135" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C135" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:attribute id="C72"
                  name="diff"
                  type="C11"
                  global="false"
                  inheritable="false"/>
   <scm:attribute id="C73"
                  name="at"
                  type="#NMTOKEN"
                  global="false"
                  inheritable="false"/>
   <scm:wildcard id="C74"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C75"
                  name="name"
                  type="#Name"
                  global="false"
                  inheritable="false"
                  containingComplexType="C15"/>
   <scm:attribute id="C76"
                  name="return-type"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C15"/>
   <scm:attribute id="C77"
                  name="return-type-ref"
                  type="#IDREF"
                  global="false"
                  inheritable="false"
                  containingComplexType="C15"/>
   <scm:attribute id="C78"
                  name="return-type-ref-occurs"
                  type="C7"
                  global="false"
                  inheritable="false"
                  containingComplexType="C15"/>
   <scm:attribute id="C79"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C17"/>
   <scm:attribute id="C80"
                  name="required"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C17"/>
   <scm:attribute id="C81"
                  name="type"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C17"/>
   <scm:element id="C82"
                name="meaning"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C17"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C83"
                  name="role"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C19"/>
   <scm:attribute id="C84"
                  name="version"
                  type="#decimal"
                  global="false"
                  inheritable="false"
                  containingComplexType="C21"/>
   <scm:wildcard id="C85"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C86"
                  name="use"
                  type="#IDREFS"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C87"
                  name="default-collation"
                  type="#anyURI"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C88"
                  name="implicit-timezone"
                  type="#duration"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C89"
                  name="schema-aware"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C90"
                  name="xslt-version"
                  type="#decimal"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C91"
                  name="spec"
                  type="C1"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:element id="C92"
                name="test-assertion"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C136"
                global="false"
                containingComplexType="C25"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C93"
                  name="dependency"
                  type="C8"
                  global="false"
                  inheritable="false"
                  containingComplexType="C27"/>
   <scm:element id="C94"
                name="option"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C137"
                global="false"
                containingComplexType="C29"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C95"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C31"/>
   <scm:attribute id="C96"
                  name="prefix"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C31"/>
   <scm:wildcard id="C97"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C98"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C99"
                  name="style"
                  type="C9"
                  global="false"
                  inheritable="false"
                  containingComplexType="C43"/>
   <scm:attribute id="C100"
                  name="covers-error-cases"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C43"/>
   <scm:attribute id="C101"
                  name="arity"
                  type="#nonNegativeInteger"
                  global="false"
                  inheritable="false"
                  containingComplexType="C43"/>
   <scm:attribute id="C102"
                  name="arity"
                  type="#nonNegativeInteger"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:attribute id="C103"
                  name="as"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C47"/>
   <scm:attribute id="C104"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C47"/>
   <scm:attribute id="C105"
                  name="id"
                  type="#ID"
                  global="false"
                  inheritable="false"
                  containingComplexType="C47"/>
   <scm:attribute id="C106"
                  name="select"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C47"/>
   <scm:attribute id="C107"
                  name="operator"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:attribute id="C108"
                  name="other-operators"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:attribute id="C109"
                  name="types"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:wildcard id="C110"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C111"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C112"
                  name="id"
                  type="#ID"
                  global="false"
                  inheritable="false"
                  containingComplexType="C53"/>
   <scm:attribute id="C113"
                  name="extensible"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C53"/>
   <scm:attribute id="C114"
                  name="id"
                  type="#ID"
                  global="false"
                  inheritable="false"
                  containingComplexType="C55"/>
   <scm:attribute id="C115"
                  name="extensible"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C55"/>
   <scm:element id="C116"
                name="option"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C138"
                global="false"
                containingComplexType="C55"
                nillable="false"
                abstract="false"/>
   <scm:wildcard id="C117"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C118"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C119"
                  name="error-code"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C61"/>
   <scm:attribute id="C120"
                  name="name"
                  type="C4"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C121"
                  name="type"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C122"
                  name="required"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C123"
                  name="type-ref"
                  type="#IDREF"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C124"
                  name="type-ref-occurs"
                  type="C7"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C125"
                  name="default"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C126"
                  name="usage"
                  type="C0"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C127"
                  name="example"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C128"
                  name="allow-permutation"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C65"/>
   <scm:attribute id="C129"
                  name="approx"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C65"/>
   <scm:attribute id="C130"
                  name="ignore-prefixes"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C65"/>
   <scm:attribute id="C131"
                  name="normalize-space"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C65"/>
   <scm:attribute id="C132"
                  name="as"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C65"/>
   <scm:wildcard id="C133"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C134"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:element id="C135"
                name="change"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C139"
                global="false"
                containingComplexType="C69"
                nillable="false"
                abstract="false"/>
   <scm:complexType id="C136"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C140"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C140" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
      <scm:assertion nsContext="fos=http://www.w3.org/xpath-functions/spec/namespace vc=http://www.w3.org/2007/XMLSchema-versioning xs=~"
                     test="local-name(*) eq 'result'"
                     defaultNamespace=""
                     xml:base="file:/Volumes/Saxonica/src/qt4cg/qtspecs/specifications/xpath-functions-40/src/fos.xsd"/>
   </scm:complexType>
   <scm:complexType id="C137"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C141"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C142"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C143"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C144"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C145"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C146"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C147"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C143" to="1"/>
            <scm:edge term="C142" to="2"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C144" to="3"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C143" to="1"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C145" to="4"/>
            <scm:edge term="C147" to="5"/>
            <scm:edge term="C146" to="6"/>
         </scm:state>
         <scm:state nr="4" final="true">
            <scm:edge term="C147" to="5"/>
            <scm:edge term="C146" to="6"/>
         </scm:state>
         <scm:state nr="5" final="true"/>
         <scm:state nr="6" final="true">
            <scm:edge term="C147" to="5"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C138"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C148"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C149"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C150"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C151"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C152"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C153"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C154"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C149" to="1"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C150" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C151" to="3"/>
            <scm:edge term="C154" to="4"/>
            <scm:edge term="C152" to="5"/>
            <scm:edge term="C153" to="6"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C154" to="4"/>
            <scm:edge term="C152" to="5"/>
            <scm:edge term="C153" to="6"/>
         </scm:state>
         <scm:state nr="4" final="true"/>
         <scm:state nr="5" final="true">
            <scm:edge term="C154" to="4"/>
            <scm:edge term="C153" to="6"/>
         </scm:state>
         <scm:state nr="6" final="true">
            <scm:edge term="C154" to="4"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C139"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C155"/>
      <scm:attributeUse required="false" inheritable="false" ref="C156"/>
      <scm:attributeUse required="false" inheritable="false" ref="C157"/>
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C73"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C158"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C158" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C158" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C158" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:wildcard id="C140"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="http://www.w3.org/2010/09/qt-fots-catalog"/>
   <scm:attribute id="C141"
                  name="key"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C137"/>
   <scm:element id="C142"
                name="applies-to"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C137"
                nillable="false"
                abstract="false"/>
   <scm:element id="C143"
                name="meaning"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C137"
                nillable="false"
                abstract="false"/>
   <scm:element id="C144"
                name="type"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C137"
                nillable="false"
                abstract="false"/>
   <scm:element id="C145"
                name="default"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C137"
                nillable="false"
                abstract="false"/>
   <scm:element id="C146"
                name="default-description"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C137"
                nillable="false"
                abstract="false"/>
   <scm:element id="C147"
                name="values"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C159"
                global="false"
                containingComplexType="C137"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C148"
                  name="key"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C138"/>
   <scm:element id="C149"
                name="meaning"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C138"
                nillable="false"
                abstract="false"/>
   <scm:element id="C150"
                name="type"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C138"
                nillable="false"
                abstract="false"/>
   <scm:element id="C151"
                name="required"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#boolean"
                global="false"
                containingComplexType="C138"
                nillable="false"
                abstract="false"/>
   <scm:element id="C152"
                name="default"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C138"
                nillable="false"
                abstract="false"/>
   <scm:element id="C153"
                name="default-description"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C138"
                nillable="false"
                abstract="false"/>
   <scm:element id="C154"
                name="values"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C160"
                global="false"
                containingComplexType="C138"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C155"
                  name="date"
                  type="#date"
                  global="false"
                  inheritable="false"
                  containingComplexType="C139"/>
   <scm:attribute id="C156"
                  name="issue"
                  type="C6"
                  global="false"
                  inheritable="false"
                  containingComplexType="C139"/>
   <scm:attribute id="C157"
                  name="PR"
                  type="C3"
                  global="false"
                  inheritable="false"
                  containingComplexType="C139"/>
   <scm:wildcard id="C158"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:complexType id="C159"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C161"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C161" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C161" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C161" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C160"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C162"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C162" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C162" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C162" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:element id="C161"
                name="value"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C163"
                global="false"
                containingComplexType="C159"
                nillable="false"
                abstract="false"/>
   <scm:element id="C162"
                name="value"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C164"
                global="false"
                containingComplexType="C160"
                nillable="false"
                abstract="false"/>
   <scm:complexType id="C163"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="true" inheritable="false" ref="C165"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C166"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C166" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C166" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C164"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="true" inheritable="false" ref="C167"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C168"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C168" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C168" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:attribute id="C165"
                  name="value"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C163"/>
   <scm:wildcard id="C166"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C167"
                  name="value"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C164"/>
   <scm:wildcard id="C168"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
</scm:schema>
<?Σ 9352a0ea?>
<?Σ2 b0544f3514a4c3c5212aa791dd3ae9766047096b13e7f6a05daae43a228b764b?>
