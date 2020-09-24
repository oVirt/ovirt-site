---
title: REST API Creating a new BE
category: api
authors: emesika
---

# REST API - Adding a new BE

In this wiki we will introduce all the steps needed in the REST API side in order to add a new Business Entity
Examples on each step are based on work done in [patch](http://gerrit.ovirt.org/#/c/16159) for the Extrenal Tasks [RFE](/develop/release-management/features/infra/externaltasks.html)

## Creating BE in api.xsd

First, we will have do define the new BE in the api.xsd
This is a XML meta-data file that helps to generate the new BE classes.
In the example we will see a new *Job* entity and a new "Step" entity
There is an heirarchy between "Job" and "Step" , A "Job" can contain several tests.
Also, keep in mind that steps can be nested, we will get to that later.

The following is a type definition for all relevants parts that may appear in the URI
`/api/jobs`, `/api/jobs/<job_id>`, `/api/jobs/<job_id>/steps`, `/api/jobs/<job_id>/steps/<steps_id>`

```xml
<xs:element name="jobs" type="Jobs"/>
<xs:element name="job" type="Job"/>
<xs:element name="steps" type="Steps"/>
<xs:element name="step" type="Step"/>
```

This is the "Step"definition

```xml
<xs:complexType name="Step">
   <xs:annotation>
     <xs:appinfo>
        <jaxb:class name="Step"/>
     </xs:appinfo>
   </xs:annotation>
   <xs:complexContent>
     <xs:extension base="BaseResource">
       <xs:sequence>
         <xs:element name="parent_step" type="Step" minOccurs="0" maxOccurs="1"/>
         <xs:element name="job" type="Job" minOccurs="0" maxOccurs="1"/>
         <xs:element name="type" type="xs:string" minOccurs="0" maxOccurs="1"/>
         <xs:element name="number" type="xs:int" minOccurs="0" maxOccurs="1"/>
         <xs:element ref="status" minOccurs="0" maxOccurs="1"/>
         <xs:element name="start_time" type="xs:dateTime" minOccurs="0" maxOccurs="1"/>
         <xs:element name="end_time" type="xs:dateTime" minOccurs="0" maxOccurs="1"/>
         <xs:element name="external" type="xs:boolean" minOccurs="0" maxOccurs="1"/>
       </xs:sequence>
     </xs:extension>
   </xs:complexContent>
 </xs:complexType>
```

This is the "Step" collection definition

```xml
<xs:complexType name="Steps">
   <xs:complexContent>
     <xs:extension base="BaseResources">
       <xs:sequence>
         <xs:annotation>
           <xs:appinfo>
               <jaxb:property name="Steps"/>
           </xs:appinfo>
         </xs:annotation>
         <xs:element ref="step" minOccurs="0" maxOccurs="unbounded"/>
       </xs:sequence>
     </xs:extension>
   </xs:complexContent>
</xs:complexType>
```

This is the "job" definition

```xml
 <xs:complexType name="Job">
   <xs:annotation>
     <xs:appinfo>
        <jaxb:class name="Job"/>
     </xs:appinfo>
   </xs:annotation>
   <xs:complexContent>
     <xs:extension base="BaseResource">
       <xs:sequence>
         <xs:element ref="status" minOccurs="0" maxOccurs="1"/>
         <xs:element name="owner" type="User" minOccurs="0" maxOccurs="1"/>
         <xs:element name="start_time" type="xs:dateTime" minOccurs="0" maxOccurs="1"/>
         <xs:element name="end_time" type="xs:dateTime" minOccurs="0" maxOccurs="1"/>
         <xs:element name="last_updated" type="xs:dateTime" minOccurs="0" maxOccurs="1"/>
         <xs:element name="external" type="xs:boolean" minOccurs="0" maxOccurs="1"/>
         <xs:element name="auto_cleared" type="xs:boolean" minOccurs="0" maxOccurs="1"/>
       </xs:sequence>
     </xs:extension>
   </xs:complexContent>
 </xs:complexType>
```

This is the "Job" collection definition

```xml
 <xs:complexType name="Jobs">
   <xs:complexContent>
     <xs:extension base="BaseResources">
       <xs:sequence>
         <xs:annotation>
           <xs:appinfo>
               <jaxb:property name="Jobs"/>
           </xs:appinfo>
         </xs:annotation>
         <xs:element ref="job" minOccurs="0" maxOccurs="unbounded"/>
       </xs:sequence>
     </xs:extension>
   </xs:complexContent>
</xs:complexType>
```

## Working with nested entities (i.e disks under a vm , steps under a job etc.)

## Adding Mappers

### Adding tests

## Adding resource classes for single entity

### Adding tests

## Adding resource classed for entity collections

### Adding tests

## Enabling parameter passing in the URL

### Adding tests

## Handling root resources

## Adding Permissions

## Adding enums to capabilities

## Defining new BE API in the RSDL
