<?xml version="1.0" encoding="UTF-8"?>
<scm:schema xmlns=""
            xmlns:scm="http://ns.saxonica.com/schema-component-model"
            generatedAt="2026-02-09T15:02:45.350333Z"
            xsdVersion="1.1"
            dmk="TGljZW5zb3I9U2F4b25pY2EKTGljZW5zZWU9Tm9ybSBUb3ZleS1XYWxzaApDb21wYW55PVNheG9uaWNhCkVtYWlsPW5vcm1Ac2F4b25pY2EuY29tClByb2R1Y3RDb2RlPURFClR5cGU9aW5kaXZpZHVhbApFZGl0aW9uPUVFClNBVD15ZXMKU0FRPXllcwpTQVY9eWVzCklzc3VlZD0yMDI2LTAxLTEyClNlcmllcz1OClNlcmlhbD1OMDEzOTc1ClVzZXI9UDAwMDEKRXZhbHVhdGlvbj1ubwpFeHBpcmF0aW9uPTIwMjctMDEtMTIKVXBncmFkZURheXM9MzY1Ck1haW50ZW5hbmNlRGF5cz0zNjUKU2lnbmF0dXJlMjAyND1FRTM3MkM3QUZGQTc4MDVBRjJCODdCNjRCRjUwOEEwMjQ1MTYyN0RDQjQ0QjNFQzVCRkYwQjNCNTlCMjE1RDc5NjE0N0YyRUEzMzYzMTcwNTg1OTI0RjExNDJEQzlEM0VDOTg1QUFBODZCOTVCMzE0MzVBQkEyMjI0MDY2MjcwNApTaWduYXR1cmU9MzAyQzAyMTQ2NkNCMUNCNzlGQzNFNkE2MzQwMjk1Q0E0NDcxQjRCMTRDOEU5NTMwMDIxNDI2N0QxMzBFQjcwRUM2M0RFMEY4NkIxQjgwMUVENkZFMEI2NDU2MEQK">
   <scm:simpleType id="C0"
                   name="occurrence-indicator"
                   targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                   base="#string"
                   variety="atomic"
                   primitiveType="#string">
      <scm:enumeration value="?"/>
      <scm:enumeration value="*"/>
      <scm:enumeration value="+"/>
   </scm:simpleType>
   <scm:simpleType id="C1" base="#string" variety="atomic" primitiveType="#string">
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
   <scm:simpleType id="C2"
                   name="NCName-or-ellipsis"
                   targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                   base="#anySimpleType"
                   variety="union"
                   memberTypes="#NCName C3"/>
   <scm:simpleType id="C4"
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
      <scm:enumeration value="add"/>
      <scm:enumeration value="chg"/>
      <scm:enumeration value="del"/>
   </scm:simpleType>
   <scm:simpleType id="C6" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="xpath-expression"/>
      <scm:enumeration value="xquery-function"/>
      <scm:enumeration value="dm-primitive"/>
      <scm:enumeration value="xquery-expression"/>
   </scm:simpleType>
   <scm:simpleType id="C7"
                   base="#anySimpleType"
                   variety="list"
                   itemType="#positiveInteger"/>
   <scm:simpleType id="C8" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="XQuery"/>
      <scm:enumeration value="XPath"/>
   </scm:simpleType>
   <scm:simpleType id="C9" base="#anySimpleType" variety="list" itemType="C1"/>
   <scm:simpleType id="C3" base="#string" variety="atomic" primitiveType="#string">
      <scm:enumeration value="..."/>
   </scm:simpleType>
   <scm:simpleType id="C10"
                   base="#anySimpleType"
                   variety="list"
                   itemType="#positiveInteger"/>
   <scm:simpleType id="C11"
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
   <scm:element id="C12"
                name="record-description"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C13"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C14"
                name="expression"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C15"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C16"
                name="summary"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C17"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C18"
                name="properties"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C19"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C20"
                name="see-also"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C21"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C22"
                name="opermap"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C23"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C24"
                name="variable"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C25"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C26"
                name="postamble"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C27"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C28"
                name="record-type"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C29"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C30"
                name="example"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C31"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C32"
                name="changes"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C33"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C34"
                name="error-result"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C35"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C36"
                name="arg"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C37"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C38"
                name="result"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C39"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C40"
                name="version"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C41"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C42"
                name="history"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C43"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C44"
                name="test"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C45"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C46"
                name="errors"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C47"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C48"
                name="proto"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C49"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C50"
                name="field"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C51"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C52"
                name="examples"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C53"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C54"
                name="signatures"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C55"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C56"
                name="rules"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C57"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C58"
                name="functions"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C59"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C60"
                name="notes"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C61"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C62"
                name="equivalent"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C63"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C64"
                name="property"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C65"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C66"
                name="options"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C67"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C68"
                name="function"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C69"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:element id="C70"
                name="global-variables"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C71"
                global="true"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C72"
                  name="space"
                  targetNamespace="http://www.w3.org/XML/1998/namespace"
                  type="#NCName"
                  global="true"
                  inheritable="false"/>
   <scm:attributeGroup id="C73"
                       name="diff-markup"
                       targetNamespace="http://www.w3.org/xpath-functions/spec/namespace">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
   </scm:attributeGroup>
   <scm:complexType id="C13"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C76"/>
      <scm:attributeUse required="false" inheritable="false" ref="C77"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C78"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C78" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C78" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C78" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C15"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C72"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementWildcard minOccurs="0" maxOccurs="1" ref="C79"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C79" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C17"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C80"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C80" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C19"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C81"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C64"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C64" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C64" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C21"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="empty">
      <scm:attributeUse required="false" inheritable="false" ref="C82"/>
      <scm:attributeUse required="false" inheritable="false" ref="C83"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C23"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="true" inheritable="false" ref="C84"/>
      <scm:attributeUse required="false" inheritable="false" ref="C85"/>
      <scm:attributeUse required="true" inheritable="false" ref="C86"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C87"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C87" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C87" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C25"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C88"/>
      <scm:attributeUse required="true" inheritable="false" ref="C89"/>
      <scm:attributeUse required="true" inheritable="false" ref="C90"/>
      <scm:attributeUse required="false" inheritable="false" ref="C91"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C27"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C92"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C92" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C92" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C29"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C93"/>
      <scm:attributeUse required="true" inheritable="false" ref="C94"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C16"/>
            <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C50"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C50" to="1"/>
            <scm:edge term="C16" to="2"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C50" to="3"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C50" to="1"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C50" to="3"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C31"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C95"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C44"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C44" to="1"/>
            <scm:edge term="C95" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C44" to="1"/>
            <scm:edge term="C95" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C33"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C96"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C96" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C96" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C96" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C35"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="empty">
      <scm:attributeUse required="false" inheritable="false" ref="C97"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C37"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="empty">
      <scm:attributeUse required="true" inheritable="false" ref="C98"/>
      <scm:attributeUse required="false" inheritable="false" ref="C99"/>
      <scm:attributeUse required="false" inheritable="false" ref="C100"/>
      <scm:attributeUse required="false" inheritable="false" ref="C101"/>
      <scm:attributeUse required="false" inheritable="false" ref="C102"/>
      <scm:attributeUse required="false" inheritable="false" ref="C103"/>
      <scm:attributeUse required="false" inheritable="false" ref="C104"/>
      <scm:attributeUse required="false" inheritable="false" ref="C105"/>
      <scm:attributeUse required="false" inheritable="false" ref="C106"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true"/>
      </scm:finiteStateMachine>
      <scm:assertion nsContext="fos=http://www.w3.org/xpath-functions/spec/namespace vc=http://www.w3.org/2007/XMLSchema-versioning xs=~"
                     test="count((@return-type, @return-type-ref)) le 1"
                     defaultNamespace=""
                     xml:base="file:/Volumes/Saxonica/src/qt4cg/qtspecs/specifications/xpath-functions-40/src/fos.xsd"/>
   </scm:complexType>
   <scm:complexType id="C39"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C107"/>
      <scm:attributeUse required="false" inheritable="false" ref="C108"/>
      <scm:attributeUse required="false" inheritable="false" ref="C109"/>
      <scm:attributeUse required="false" inheritable="false" ref="C110"/>
      <scm:attributeUse required="false" inheritable="false" ref="C111"/>
      <scm:attributeUse required="false" inheritable="false" ref="C112"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementWildcard minOccurs="0" maxOccurs="unbounded" ref="C113"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C113" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C113" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C41"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="false" inheritable="false" ref="C114"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementWildcard minOccurs="0" maxOccurs="unbounded" ref="C115"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C115" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C115" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C43"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C40"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C40" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C40" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C40" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C45"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C116"/>
      <scm:attributeUse required="false" inheritable="false" ref="C117"/>
      <scm:attributeUse required="false" inheritable="false" ref="C118"/>
      <scm:attributeUse required="false" inheritable="false" ref="C119"/>
      <scm:attributeUse required="false" inheritable="false" ref="C120"/>
      <scm:attributeUse required="false" inheritable="false" ref="C121" default="XPath">
         <scm:default lexicalForm="XPath">
            <scm:item type="#string" value="XPath"/>
         </scm:default>
      </scm:attributeUse>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C14"/>
            <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
               <scm:choice>
                  <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C38"/>
                  <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C34"/>
               </scm:choice>
            </scm:modelGroupParticle>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C122"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C26"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C14" to="1"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C38" to="2"/>
            <scm:edge term="C34" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C26" to="3"/>
            <scm:edge term="C122" to="4"/>
         </scm:state>
         <scm:state nr="3" final="true"/>
         <scm:state nr="4" final="true">
            <scm:edge term="C26" to="3"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C47"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C123"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C123" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C123" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C123" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C49"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C124"/>
      <scm:attributeUse required="false" inheritable="false" ref="C125"/>
      <scm:attributeUse required="false" inheritable="false" ref="C126"/>
      <scm:attributeUse required="false" inheritable="false" ref="C127"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C36"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C36" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C36" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
      <scm:assertion nsContext="fos=http://www.w3.org/xpath-functions/spec/namespace vc=http://www.w3.org/2007/XMLSchema-versioning xs=~"
                     test="count((@return-type, @return-type-ref)) eq 1"
                     defaultNamespace=""
                     xml:base="file:/Volumes/Saxonica/src/qt4cg/qtspecs/specifications/xpath-functions-40/src/fos.xsd"/>
   </scm:complexType>
   <scm:complexType id="C51"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C128"/>
      <scm:attributeUse required="true" inheritable="false" ref="C129"/>
      <scm:attributeUse required="true" inheritable="false" ref="C130"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C131"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C131" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C53"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C132"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C30"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C24"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C30" to="1"/>
            <scm:edge term="C24" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C30" to="2"/>
            <scm:edge term="C24" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C30" to="2"/>
            <scm:edge term="C24" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C55"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C48"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C48" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C48" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C48" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C57"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:choice>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C133"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C66"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C12"/>
         </scm:choice>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C66" to="1"/>
            <scm:edge term="C12" to="1"/>
            <scm:edge term="C133" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C66" to="2"/>
            <scm:edge term="C12" to="2"/>
            <scm:edge term="C133" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C66" to="2"/>
            <scm:edge term="C12" to="2"/>
            <scm:edge term="C133" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C59"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C70"/>
            <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C28"/>
            <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C68"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C68" to="1"/>
            <scm:edge term="C28" to="2"/>
            <scm:edge term="C70" to="3"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C68" to="4"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C68" to="1"/>
            <scm:edge term="C28" to="2"/>
         </scm:state>
         <scm:state nr="3">
            <scm:edge term="C68" to="1"/>
            <scm:edge term="C28" to="2"/>
         </scm:state>
         <scm:state nr="4" final="true">
            <scm:edge term="C68" to="4"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C61"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C134"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C134" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C134" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C134" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C63"
                    base="#string"
                    derivationMethod="extension"
                    abstract="false"
                    variety="simple"
                    simpleType="#string">
      <scm:attributeUse required="false" inheritable="false" ref="C135"/>
      <scm:attributeUse required="false" inheritable="false" ref="C136" default="true">
         <scm:default lexicalForm="true">
            <scm:item type="#boolean" value="true"/>
         </scm:default>
      </scm:attributeUse>
      <scm:attributeUse required="false" inheritable="false" ref="C137"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
   </scm:complexType>
   <scm:complexType id="C65"
                    base="C4"
                    derivationMethod="extension"
                    abstract="false"
                    variety="simple"
                    simpleType="C4">
      <scm:attributeUse required="false" inheritable="false" ref="C138"/>
   </scm:complexType>
   <scm:complexType id="C67"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C139"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C139" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C139" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C139" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C69"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C140"/>
      <scm:attributeUse required="false" inheritable="false" ref="C141"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C54"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C22"/>
            <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C18"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C16"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C56"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C62"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C46"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C60"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C52"/>
            <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C20"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C32"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C42"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C54" to="1"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C16" to="2"/>
            <scm:edge term="C22" to="3"/>
            <scm:edge term="C18" to="4"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C56" to="5"/>
         </scm:state>
         <scm:state nr="3">
            <scm:edge term="C16" to="2"/>
            <scm:edge term="C18" to="4"/>
         </scm:state>
         <scm:state nr="4">
            <scm:edge term="C16" to="2"/>
            <scm:edge term="C18" to="4"/>
         </scm:state>
         <scm:state nr="5" final="true">
            <scm:edge term="C52" to="6"/>
            <scm:edge term="C42" to="7"/>
            <scm:edge term="C20" to="8"/>
            <scm:edge term="C46" to="9"/>
            <scm:edge term="C62" to="10"/>
            <scm:edge term="C32" to="11"/>
            <scm:edge term="C60" to="12"/>
         </scm:state>
         <scm:state nr="6" final="true">
            <scm:edge term="C42" to="7"/>
            <scm:edge term="C20" to="8"/>
            <scm:edge term="C32" to="11"/>
         </scm:state>
         <scm:state nr="7" final="true"/>
         <scm:state nr="8" final="true">
            <scm:edge term="C42" to="7"/>
            <scm:edge term="C20" to="8"/>
            <scm:edge term="C32" to="11"/>
         </scm:state>
         <scm:state nr="9" final="true">
            <scm:edge term="C52" to="6"/>
            <scm:edge term="C42" to="7"/>
            <scm:edge term="C20" to="8"/>
            <scm:edge term="C32" to="11"/>
            <scm:edge term="C60" to="12"/>
         </scm:state>
         <scm:state nr="10" final="true">
            <scm:edge term="C52" to="6"/>
            <scm:edge term="C42" to="7"/>
            <scm:edge term="C20" to="8"/>
            <scm:edge term="C46" to="9"/>
            <scm:edge term="C32" to="11"/>
            <scm:edge term="C60" to="12"/>
         </scm:state>
         <scm:state nr="11" final="true">
            <scm:edge term="C42" to="7"/>
         </scm:state>
         <scm:state nr="12" final="true">
            <scm:edge term="C52" to="6"/>
            <scm:edge term="C42" to="7"/>
            <scm:edge term="C20" to="8"/>
            <scm:edge term="C32" to="11"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C71"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="0" maxOccurs="unbounded" ref="C24"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C24" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C24" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:attribute id="C74"
                  name="diff"
                  type="C5"
                  global="false"
                  inheritable="false"/>
   <scm:attribute id="C75"
                  name="at"
                  type="#NMTOKEN"
                  global="false"
                  inheritable="false"/>
   <scm:attribute id="C76"
                  name="id"
                  type="#ID"
                  global="false"
                  inheritable="false"
                  containingComplexType="C13"/>
   <scm:attribute id="C77"
                  name="extensible"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C13"/>
   <scm:element id="C78"
                name="option"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C142"
                global="false"
                containingComplexType="C13"
                nillable="false"
                abstract="false"/>
   <scm:wildcard id="C79"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C80"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C81"
                  name="arity"
                  type="#nonNegativeInteger"
                  global="false"
                  inheritable="false"
                  containingComplexType="C19"/>
   <scm:attribute id="C82"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C21"/>
   <scm:attribute id="C83"
                  name="prefix"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C21"/>
   <scm:attribute id="C84"
                  name="operator"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C23"/>
   <scm:attribute id="C85"
                  name="other-operators"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C23"/>
   <scm:attribute id="C86"
                  name="types"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C23"/>
   <scm:wildcard id="C87"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C88"
                  name="as"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C89"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C90"
                  name="id"
                  type="#ID"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:attribute id="C91"
                  name="select"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C25"/>
   <scm:wildcard id="C92"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C93"
                  name="id"
                  type="#ID"
                  global="false"
                  inheritable="false"
                  containingComplexType="C29"/>
   <scm:attribute id="C94"
                  name="extensible"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C29"/>
   <scm:wildcard id="C95"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:element id="C96"
                name="change"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C143"
                global="false"
                containingComplexType="C33"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C97"
                  name="error-code"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C35"/>
   <scm:attribute id="C98"
                  name="name"
                  type="C2"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C99"
                  name="type"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C100"
                  name="required"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C101"
                  name="type-ref"
                  type="#IDREF"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C102"
                  name="type-ref-occurs"
                  type="C0"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C103"
                  name="default"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C104"
                  name="note"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C105"
                  name="usage"
                  type="C11"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C106"
                  name="example"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C37"/>
   <scm:attribute id="C107"
                  name="allow-permutation"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C39"/>
   <scm:attribute id="C108"
                  name="approx"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C39"/>
   <scm:attribute id="C109"
                  name="ignore-prefixes"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C39"/>
   <scm:attribute id="C110"
                  name="normalize-space"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C39"/>
   <scm:attribute id="C111"
                  name="narrative"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C39"/>
   <scm:attribute id="C112"
                  name="as"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C39"/>
   <scm:wildcard id="C113"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C114"
                  name="version"
                  type="#decimal"
                  global="false"
                  inheritable="false"
                  containingComplexType="C41"/>
   <scm:wildcard id="C115"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C116"
                  name="use"
                  type="#IDREFS"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:attribute id="C117"
                  name="default-collation"
                  type="#anyURI"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:attribute id="C118"
                  name="implicit-timezone"
                  type="#duration"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:attribute id="C119"
                  name="schema-aware"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:attribute id="C120"
                  name="xslt-version"
                  type="#decimal"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:attribute id="C121"
                  name="spec"
                  type="C8"
                  global="false"
                  inheritable="false"
                  containingComplexType="C45"/>
   <scm:element id="C122"
                name="test-assertion"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C144"
                global="false"
                containingComplexType="C45"
                nillable="false"
                abstract="false"/>
   <scm:wildcard id="C123"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C124"
                  name="name"
                  type="#Name"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:attribute id="C125"
                  name="return-type"
                  type="#anySimpleType"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:attribute id="C126"
                  name="return-type-ref"
                  type="#IDREF"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:attribute id="C127"
                  name="return-type-ref-occurs"
                  type="C0"
                  global="false"
                  inheritable="false"
                  containingComplexType="C49"/>
   <scm:attribute id="C128"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C51"/>
   <scm:attribute id="C129"
                  name="required"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C51"/>
   <scm:attribute id="C130"
                  name="type"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C51"/>
   <scm:element id="C131"
                name="meaning"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C51"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C132"
                  name="role"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C53"/>
   <scm:wildcard id="C133"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C134"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C135"
                  name="style"
                  type="C6"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C136"
                  name="covers-error-cases"
                  type="#boolean"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C137"
                  name="arity"
                  type="#nonNegativeInteger"
                  global="false"
                  inheritable="false"
                  containingComplexType="C63"/>
   <scm:attribute id="C138"
                  name="dependency"
                  type="C9"
                  global="false"
                  inheritable="false"
                  containingComplexType="C65"/>
   <scm:element id="C139"
                name="option"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C145"
                global="false"
                containingComplexType="C67"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C140"
                  name="name"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C69"/>
   <scm:attribute id="C141"
                  name="prefix"
                  type="#NCName"
                  global="false"
                  inheritable="false"
                  containingComplexType="C69"/>
   <scm:complexType id="C142"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C146"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C147"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C148"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C149"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C150"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C151"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C152"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C147" to="1"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C148" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C151" to="3"/>
            <scm:edge term="C150" to="4"/>
            <scm:edge term="C152" to="5"/>
            <scm:edge term="C149" to="6"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C152" to="5"/>
         </scm:state>
         <scm:state nr="4" final="true">
            <scm:edge term="C151" to="3"/>
            <scm:edge term="C152" to="5"/>
         </scm:state>
         <scm:state nr="5" final="true"/>
         <scm:state nr="6" final="true">
            <scm:edge term="C151" to="3"/>
            <scm:edge term="C150" to="4"/>
            <scm:edge term="C152" to="5"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C143"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="false" inheritable="false" ref="C153"/>
      <scm:attributeUse required="false" inheritable="false" ref="C154"/>
      <scm:attributeUse required="false" inheritable="false" ref="C155"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C156"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C156" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C156" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C156" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C144"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C157"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C157" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true"/>
      </scm:finiteStateMachine>
      <scm:assertion nsContext="fos=http://www.w3.org/xpath-functions/spec/namespace vc=http://www.w3.org/2007/XMLSchema-versioning xs=~"
                     test="local-name(*) eq 'result'"
                     defaultNamespace=""
                     xml:base="file:/Volumes/Saxonica/src/qt4cg/qtspecs/specifications/xpath-functions-40/src/fos.xsd"/>
   </scm:complexType>
   <scm:complexType id="C145"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:attributeUse required="true" inheritable="false" ref="C158"/>
      <scm:attributeUse required="false" inheritable="false" ref="C74"/>
      <scm:attributeUse required="false" inheritable="false" ref="C75"/>
      <scm:modelGroupParticle minOccurs="1" maxOccurs="1">
         <scm:sequence>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C159"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C160"/>
            <scm:elementParticle minOccurs="1" maxOccurs="1" ref="C161"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C162"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C163"/>
            <scm:elementParticle minOccurs="0" maxOccurs="1" ref="C164"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C159" to="1"/>
            <scm:edge term="C160" to="2"/>
         </scm:state>
         <scm:state nr="1">
            <scm:edge term="C160" to="2"/>
         </scm:state>
         <scm:state nr="2">
            <scm:edge term="C161" to="3"/>
         </scm:state>
         <scm:state nr="3" final="true">
            <scm:edge term="C164" to="4"/>
            <scm:edge term="C162" to="5"/>
            <scm:edge term="C163" to="6"/>
         </scm:state>
         <scm:state nr="4" final="true"/>
         <scm:state nr="5" final="true">
            <scm:edge term="C164" to="4"/>
            <scm:edge term="C163" to="6"/>
         </scm:state>
         <scm:state nr="6" final="true">
            <scm:edge term="C164" to="4"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:attribute id="C146"
                  name="key"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C142"/>
   <scm:element id="C147"
                name="meaning"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C142"
                nillable="false"
                abstract="false"/>
   <scm:element id="C148"
                name="type"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C142"
                nillable="false"
                abstract="false"/>
   <scm:element id="C149"
                name="required"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#boolean"
                global="false"
                containingComplexType="C142"
                nillable="false"
                abstract="false"/>
   <scm:element id="C150"
                name="default"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C142"
                nillable="false"
                abstract="false"/>
   <scm:element id="C151"
                name="default-description"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C142"
                nillable="false"
                abstract="false"/>
   <scm:element id="C152"
                name="values"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C165"
                global="false"
                containingComplexType="C142"
                nillable="false"
                abstract="false"/>
   <scm:attribute id="C153"
                  name="date"
                  type="#date"
                  global="false"
                  inheritable="false"
                  containingComplexType="C143"/>
   <scm:attribute id="C154"
                  name="issue"
                  type="C7"
                  global="false"
                  inheritable="false"
                  containingComplexType="C143"/>
   <scm:attribute id="C155"
                  name="PR"
                  type="C10"
                  global="false"
                  inheritable="false"
                  containingComplexType="C143"/>
   <scm:wildcard id="C156"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:wildcard id="C157"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="http://www.w3.org/2010/09/qt-fots-catalog"/>
   <scm:attribute id="C158"
                  name="key"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C145"/>
   <scm:element id="C159"
                name="applies-to"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C145"
                nillable="false"
                abstract="false"/>
   <scm:element id="C160"
                name="meaning"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C145"
                nillable="false"
                abstract="false"/>
   <scm:element id="C161"
                name="type"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C145"
                nillable="false"
                abstract="false"/>
   <scm:element id="C162"
                name="default"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#string"
                global="false"
                containingComplexType="C145"
                nillable="false"
                abstract="false"/>
   <scm:element id="C163"
                name="default-description"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="#anyType"
                global="false"
                containingComplexType="C145"
                nillable="false"
                abstract="false"/>
   <scm:element id="C164"
                name="values"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C166"
                global="false"
                containingComplexType="C145"
                nillable="false"
                abstract="false"/>
   <scm:complexType id="C165"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C167"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C167" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C167" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C167" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C166"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="element-only">
      <scm:elementParticle minOccurs="1" maxOccurs="unbounded" ref="C168"/>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0">
            <scm:edge term="C168" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C168" to="2"/>
         </scm:state>
         <scm:state nr="2" final="true">
            <scm:edge term="C168" to="2"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:element id="C167"
                name="value"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C169"
                global="false"
                containingComplexType="C165"
                nillable="false"
                abstract="false"/>
   <scm:element id="C168"
                name="value"
                targetNamespace="http://www.w3.org/xpath-functions/spec/namespace"
                type="C170"
                global="false"
                containingComplexType="C166"
                nillable="false"
                abstract="false"/>
   <scm:complexType id="C169"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="true" inheritable="false" ref="C171"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C172"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C172" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C172" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:complexType id="C170"
                    base="#anyType"
                    derivationMethod="restriction"
                    abstract="false"
                    variety="mixed">
      <scm:attributeUse required="true" inheritable="false" ref="C173"/>
      <scm:modelGroupParticle minOccurs="0" maxOccurs="unbounded">
         <scm:sequence>
            <scm:elementWildcard minOccurs="1" maxOccurs="1" ref="C174"/>
         </scm:sequence>
      </scm:modelGroupParticle>
      <scm:finiteStateMachine initialState="0">
         <scm:state nr="0" final="true">
            <scm:edge term="C174" to="1"/>
         </scm:state>
         <scm:state nr="1" final="true">
            <scm:edge term="C174" to="1"/>
         </scm:state>
      </scm:finiteStateMachine>
   </scm:complexType>
   <scm:attribute id="C171"
                  name="value"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C169"/>
   <scm:wildcard id="C172"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
   <scm:attribute id="C173"
                  name="value"
                  type="#string"
                  global="false"
                  inheritable="false"
                  containingComplexType="C170"/>
   <scm:wildcard id="C174"
                 processContents="skip"
                 constraint="enumeration"
                 namespaces="##local"/>
</scm:schema>
<?Σ aefa2481?>
<?Σ2 6af7b37c337ee9a6055935221b85c6104808b2bda09a287ea516da2b745f3eca?>
