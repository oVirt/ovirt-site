---
title: RSDL schema
authors: michael pasternak
---

# RSDL Schema

	<xs:element name="detailedLinks" type="DetailedLinks"/>
	   <xs:complexType name="DetailedLinks">
	     <xs:sequence>
	       <xs:annotation>
	         <xs:appinfo>
	           <jaxb:property name="links"/>
	         </xs:appinfo>
	       </xs:annotation>
	       <xs:element type="DetailedLink" name="link" maxOccurs="unbounded"/>
	     </xs:sequence>
	   </xs:complexType>
	   <xs:element name="link" type="Link"/>
	   <xs:complexType name="Link">
	     <xs:attribute name="href" type="xs:string"/>
	     <xs:attribute name="rel" type="xs:string"/>
	   </xs:complexType>
	   <xs:element name="url" type="Url"/>
	   <xs:complexType name="Url">
	     <xs:sequence>
	       <xs:element ref="parameters_set" maxOccurs="unbounded" minOccurs="0">
	         <xs:annotation>
	           <xs:appinfo>
	             <jaxb:property name="ParametersSets"/>
	           </xs:appinfo>
	         </xs:annotation>
	       </xs:element>
	     </xs:sequence>
	   </xs:complexType>
	   <xs:element name="body" type="Body"/>
	   <xs:complexType name="Body">
	     <xs:sequence>
	       <xs:element name="type" type="xs:string" minOccurs="1" maxOccurs="1"/>
	       <xs:element ref="parameters_set" maxOccurs="unbounded" minOccurs="0">
	         <xs:annotation>
	           <xs:appinfo>
	             <jaxb:property name="ParametersSets"/>
	           </xs:appinfo>
	         </xs:annotation>
	       </xs:element>
	     </xs:sequence>
	     <xs:attribute name="required" type="xs:boolean">
	                 <xs:annotation>
	           <xs:appinfo>
	             <jaxb:property generateIsSetMethod="false"/>
	           </xs:appinfo>
	         </xs:annotation>
	     </xs:attribute>
	   </xs:complexType>
	   <xs:element name="request" type="Request"/>
	   <xs:complexType name="Request">
	     <xs:sequence>
	       <xs:element name="http_method" type="HttpMethod" minOccurs="1" maxOccurs="1"/>
	       <xs:element ref="headers" minOccurs="0" maxOccurs="1"/>
	       <xs:element ref="url" minOccurs="0" maxOccurs="1"/>
	       <xs:element ref="body" minOccurs="0" maxOccurs="1"/>
	     </xs:sequence>
	   </xs:complexType>
	   <xs:simpleType name="HttpMethod">
	     <xs:restriction base="xs:string">
	       <xs:enumeration value="GET"/>
	       <xs:enumeration value="POST"/>
	       <xs:enumeration value="PUT"/>
	       <xs:enumeration value="DELETE"/>
	       <xs:enumeration value="OPTIONS"/>
	     </xs:restriction>
	   </xs:simpleType>
	   <xs:element name="response" type="Response"/>
	   <xs:complexType name="Response">
	     <xs:sequence>
	       <xs:element name="type" type="xs:string" minOccurs="1" maxOccurs="1"/>
	     </xs:sequence>
	   </xs:complexType>
	   <xs:element name="parameter" type="Parameter"/>
	   <xs:complexType name="Parameter">
	     <xs:complexContent>
	       <xs:extension base="BaseResource">
	         <xs:sequence>
	               <xs:element name="value" type="xs:string" minOccurs="1" maxOccurs="1"/>
	               <xs:element ref="parameters_set" minOccurs="0" maxOccurs="1"/>
	         </xs:sequence>
	         <xs:attribute name="required" type="xs:boolean">
	           <xs:annotation>
	             <xs:appinfo>
	               <jaxb:property generateIsSetMethod="false"/>
	             </xs:appinfo>
	           </xs:annotation>
	         </xs:attribute>
	         <xs:attribute name="type" type="xs:string"/>
	         <xs:attribute name="context" type="xs:string"/>
	       </xs:extension>
	     </xs:complexContent>
	   </xs:complexType>
	   <xs:element name="header" type="Header"/>
	   <xs:complexType name="Header">
	     <xs:complexContent>
	       <xs:extension base="BaseResource">
	         <xs:sequence>
	           <xs:element name="value" type="xs:string" minOccurs="1" maxOccurs="1"/>
	         </xs:sequence>
	        <xs:attribute name="required" type="xs:boolean">
	         <xs:annotation>
	           <xs:appinfo>
	             <jaxb:property generateIsSetMethod="false"/>
	           </xs:appinfo>
	         </xs:annotation>
	        </xs:attribute>
	       </xs:extension>
	     </xs:complexContent>
	   </xs:complexType>
	   <xs:element name="headers" type="Headers"/>
	   <xs:complexType name="Headers">
	     <xs:sequence>
	       <xs:element ref="header" maxOccurs="unbounded">
	         <xs:annotation>
	           <xs:appinfo>
	             <jaxb:property name="Headers"/>
	           </xs:appinfo>
	         </xs:annotation>
	       </xs:element>
	     </xs:sequence>
	   </xs:complexType>
	   <xs:element name="parameters_set" type="ParametersSet"/>
	   <xs:complexType name="ParametersSet">
	     <xs:sequence>
	       <xs:element ref="parameter" maxOccurs="unbounded" minOccurs="0">
	         <xs:annotation>
	           <xs:appinfo>
	             <jaxb:property name="Parameters"/>
	           </xs:appinfo>
	         </xs:annotation>
	       </xs:element>
	     </xs:sequence>
	   </xs:complexType>
	   <xs:element name="schema" type="Schema"/>
	   <xs:complexType name="Schema">
	     <xs:complexContent>
	       <xs:extension base="Link">
	         <xs:sequence>
	           <xs:element name="name" type="xs:string" minOccurs="0" maxOccurs="1"/>
	           <xs:element name="description" type="xs:string" minOccurs="0" maxOccurs="1"/>
	         </xs:sequence>
	       </xs:extension>
	     </xs:complexContent>
	   </xs:complexType>
	   <xs:element name="general_metadata" type="GeneralMetadata"/>
	   <xs:complexType name="GeneralMetadata">
	     <xs:complexContent>
	       <xs:extension base="DetailedLink">
	         <xs:sequence>
	           <xs:element name="name" type="xs:string" minOccurs="0" maxOccurs="1"/>
	           <xs:element name="description" type="xs:string" minOccurs="0" maxOccurs="1"/>
	         </xs:sequence>
	       </xs:extension>
	     </xs:complexContent>
	   </xs:complexType>
	   <xs:element name="rsdl" type="RSDL"/>
	   <xs:complexType name="RSDL">
	      <xs:sequence>
	        <xs:element name="description" type="xs:string" minOccurs="0"/>
	        <xs:element type="Version" name="version" minOccurs="0" maxOccurs="1" />
	        <xs:element ref="schema" minOccurs="0" maxOccurs="1" />
	        <xs:element type="GeneralMetadata" name="general" minOccurs="0" maxOccurs="1"/>
	        <xs:element type="DetailedLinks" name="links" minOccurs="0"/>
	      </xs:sequence>
	      <xs:attribute name="href" type="xs:string"/>
	      <xs:attribute name="rel" type="xs:string"/>
	   </xs:complexType>
