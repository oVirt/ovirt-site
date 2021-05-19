---
title: RSDL
category: feature
authors: michael pasternak
toc: true
---

# RSDL


## Description

RSDL (RESTful Service Description Language) is a machine and human readable XML description of HTTP-based web applications (typically REST web services), it models the resource/s provided by a service, the relationships between them, parameters that has to be supplied for the certain operation, specifies if parameter/s has to be mandated and describes possible overloads as parameters sets, RSDL is intended to simplify the reuse of web services that are based on the HTTP architecture of the Web. It is platform and language independent and aims to promote reuse of applications beyond the basic use in a web browser by both humans and machines.

Unlike WADL, it's concentrates in describing URIs as stand along entry points in to the application which can be invoked in a different way, what is makes it human-readable and easily consumed by both humans and machines, (for more details see [RSDL wiki](http://en.wikipedia.org/wiki/RSDL)).

## Concept

### self descriptive

RSDL represents different URIs as stand along entry points in to the application, following resource URIs, one can figure out what methods available for the given resources and how the can be consumed.

### machine-readable

each URI in RSDL contains all necessary info to generate HTTP request from it, that can be consumed easy accessing this URI internals.

### human-readable

each URI in RSDL contains "rel" and "description" describing the meaning of the given operation on the certain URI, humans can easily fetch all available operations for the given collection/resource simply by locating different descriptors with same URI.

## Format
{% highlight xml %}
   <rsdl rel="rsdl" href="/api?rsdl">
       <description></description>
       <version revision="0" build="0" minor="0" major="0"/>
       <schema rel="schema" href="/api?schema">
           <name>api.xsd</name>
           <description></description>
       </schema>
       <general rel="*" href="/*">
           <request>
               <headers>
                   <header required="true|false">
                       <name></name>
                       <description></description>
                       <value></value>
                  </header>
                  ...
               </headers>
               <url>
                   <parameters_set>
                       <parameter context="query|matrix" type="xs:string" required="true|false">
                           <name></name>
                           <value></value>
                       </parameter>
                       ...
                   </parameters_set>
                   ...
           </request>
           <name></name>
           <description></description>
       </general>
       <links>
           <link rel="get|..." href="/api/xxx">
               <request>
                   <http_method>GET|POST|PUT|DELETE|...</http_method>
                   <headers>
                        <header required="true|false">
                           <name></name>
                           <value></value>
                        </header>
                        ...
                   </headers>
                   <url>
                       <parameters_set>
                           <parameter context="query|matrix" type="" required="true|false">
                               <name></name>
                               <value></value>
                           </parameter>
                           ...
                       </parameters_set>
                       ...
                   </url>
                   <body>
                       <type>...</type>
                       <parameters_set>
                           <parameter type="" required="true|false">
                               <name>FQ-name-to-parameter</name>
                           </parameter>
                           ...
                       </parameters_set>
                       ...
                  </body>
               </request>
               <response>
                   <type></type>
                   ...
               </response>
           </link>
           ...
       </links>
   </rsdl>
{% endhighlight %}



### Components

#### URI
{% highlight xml %}
   <links>
       <link rel="get|..." href="/api/xxx">
{% endhighlight %}

#### Request

{% highlight xml %}
   <request>
       <http_method>GET|POST|PUT|DELETE|...</http_method>
       <headers>
            <header required="true|false">
               <name></name>
               <value></value>
            </header>
            ...
       </headers>
       <url>
           <parameters_set>
               <parameter context="query|matrix" type="" required="true|false">
                   <name></name>
                   <value></value>
               </parameter>
               ...
           </parameters_set>
           ...
       </url>
       <body>
           <type>...</type>
           <parameters_set>
               <parameter type="" required="true|false">
                   <name>FQ-name-to-parameter</name>
               </parameter>
               ...
           </parameters_set>
           ...
       </body>
   </request>
{% endhighlight %}

#### Response

{% highlight xml %}
   <response>
       <type></type>
       ...
   </response>
{% endhighlight %}

### XML schema

{% highlight xml %}
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
{% endhighlight %}

[RSDL schema](/develop/release-management/features/infra/rsdl-schema.html)

## Usage

### Examples

#### List resources

{% highlight xml %}
       <link rel="get" href="/api/clusters">
           <request>
               <http_method>GET</http_method>
               <headers>
                  <header required="false">
                       <name>Filter</name>
                       <value>true|false</value>
                  </header>
               </headers>
               <url>
                   <parameters_set>
                       <parameter context="query" type="xs:string" required="false">
                           <name>search</name>
                           <value>search query</value>
                       </parameter>
                       <parameter context="matrix" type="xs:boolean" required="false">
                           <name>case_sensitive</name>
                           <value>true|false</value>
                       </parameter>
                       <parameter context="matrix" type="xs:int" required="false">
                           <name>max</name>
                           <value>max results</value>
                       </parameter>
                   </parameters_set>
               </url>
               <body/>
           </request>
           <response>
               <type>Clusters</type>
           </response>
       </link>
{% endhighlight %}

#### Get resource

{% highlight xml %}
       <link rel="get" href="/api/clusters/{cluster:id}">
           <request>
               <http_method>GET</http_method>
               <headers>
                  <header required="false">
                       <name>Filter</name>
                       <value>true|false</value>
                  </header>
               </headers>
               <body/>
           </request>
           <response>
               <type>Cluster</type>
           </response>
       </link>
{% endhighlight %}

#### Update resource

{% highlight xml %}
       <link rel="update" href="/api/clusters/{cluster:id}">
           <request>
               <http_method>PUT</http_method>
               <headers>
                  <header required="true">
                       <name>Content-Type</name>
                       <value>application/xml|json</value>
                  </header>
                  <header required="false">
                       <name>Correlation-Id</name>
                       <value>any string</value>
                  </header>
               </headers>
               <body>
                   <type>Cluster</type>
                   <parameters_set>
                       <parameter type="xs:string" required="false">
                           <name>cluster.name</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.description</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.cpu.id</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.version.major</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.version.minor</name>
                       </parameter>
                       <parameter type="xs:double" required="false">
                           <name>cluster.memory_policy.overcommit.percent</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.memory_policy.transparent_hugepages.enabled</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.scheduling_policy.policy</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.low</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.high</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.duration</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.error_handling.on_error</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.virt_service</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.gluster_service</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.threads_as_cores</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.tunnel_migration</name>
                       </parameter>
                   </parameters_set>
               </body>
           </request>
           <response>
               <type>Cluster</type>
           </response>
       </link>
{% endhighlight %}

#### Create resource

{% highlight xml %}
       <link rel="add" href="/api/clusters">
           <request>
               <http_method>POST</http_method>
               <headers>
                  <header required="true">
                       <name>Content-Type</name>
                       <value>application/xml|json</value>
                  </header>
                  <header required="false">
                       <name>Expect</name>
                       <value>201-created</value>
                  </header>
                  <header required="false">
                       <name>Correlation-Id</name>
                       <value>any string</value>
                  </header>
               </headers>
               <body>
                   <type>Cluster</type>
                   <parameters_set>
                       <parameter type="xs:string" required="true">
                           <name>cluster.data_center.id|name</name>
                       </parameter>
                       <parameter type="xs:string" required="true">
                           <name>cluster.name</name>
                       </parameter>
                       <parameter type="xs:int" required="true">
                           <name>cluster.version.major</name>
                       </parameter>
                       <parameter type="xs:int" required="true">
                           <name>cluster.version.minor</name>
                       </parameter>
                       <parameter type="xs:string" required="true">
                           <name>cluster.cpu.id</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.description</name>
                       </parameter>
                       <parameter type="xs:double" required="false">
                           <name>cluster.memory_policy.overcommit.percent</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.memory_policy.transparent_hugepages.enabled</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.scheduling_policy.policy</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.low</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.high</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.duration</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.error_handling.on_error</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.virt_service</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.gluster_service</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.threads_as_cores</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.tunnel_migration</name>
                       </parameter>
                   </parameters_set>
               </body>
           </request>
           <response>
               <type>Cluster</type>
           </response>
       </link>
{% endhighlight %}

#### Delete resource

{% highlight xml %}
       <link rel="delete" href="/api/clusters/{cluster:id}">
           <request>
               <http_method>DELETE</http_method>
               <headers>
                  <header required="false">
                       <name>Correlation-Id</name>
                       <value>any string</value>
                  </header>
               </headers>
               <url>
                   <parameters_set>
                       <parameter context="matrix" type="xs:boolean" required="false">
                           <name>async</name>
                           <value>true|false</value>
                       </parameter>
                   </parameters_set>
               </url>
               <body/>
           </request>
       </link>
{% endhighlight %}

### Code generation

#### RSDL URI descriptor

{% highlight xml %}
       <link rel="add" href="/api/clusters">
           <request>
               <http_method>POST</http_method>
               <headers>
                  <header required="true">
                       <name>Content-Type</name>
                       <value>application/xml|json</value>
                  </header>
                  <header required="false">
                       <name>Expect</name>
                       <value>201-created</value>
                  </header>
                  <header required="false">
                       <name>Correlation-Id</name>
                       <value>any string</value>
                  </header>
               </headers>
               <body>
                   <type>Cluster</type>
                   <parameters_set>
                       <parameter type="xs:string" required="true">
                           <name>cluster.data_center.id|name</name>
                       </parameter>
                       <parameter type="xs:string" required="true">
                           <name>cluster.name</name>
                       </parameter>
                       <parameter type="xs:int" required="true">
                           <name>cluster.version.major</name>
                       </parameter>
                       <parameter type="xs:int" required="true">
                           <name>cluster.version.minor</name>
                       </parameter>
                       <parameter type="xs:string" required="true">
                           <name>cluster.cpu.id</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.description</name>
                       </parameter>
                       <parameter type="xs:double" required="false">
                           <name>cluster.memory_policy.overcommit.percent</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.memory_policy.transparent_hugepages.enabled</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.scheduling_policy.policy</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.low</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.high</name>
                       </parameter>
                       <parameter type="xs:int" required="false">
                           <name>cluster.scheduling_policy.thresholds.duration</name>
                       </parameter>
                       <parameter type="xs:string" required="false">
                           <name>cluster.error_handling.on_error</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.virt_service</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.gluster_service</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.threads_as_cores</name>
                       </parameter>
                       <parameter type="xs:boolean" required="false">
                           <name>cluster.tunnel_migration</name>
                       </parameter>
                   </parameters_set>
               </body>
           </request>
           <response>
               <type>Cluster</type>
           </response>
       </link>
{% endhighlight %}

#### Generated code signature/s
{% highlight java %}
         /**
          * Adds Cluster object.
          * @param cluster {@link org.ovirt.engine.sdk.entities.Cluster}
          *    cluster.data_center.id|name
          *    cluster.name
          *    cluster.version.major
          *    cluster.version.minor
          *    cluster.cpu.id
          *    [cluster.description]
          *    [cluster.memory_policy.overcommit.percent]
          *    [cluster.memory_policy.transparent_hugepages.enabled]
          *    [cluster.scheduling_policy.policy]
          *    [cluster.scheduling_policy.thresholds.low]
          *    [cluster.scheduling_policy.thresholds.high]
          *    [cluster.scheduling_policy.thresholds.duration]
          *    [cluster.error_handling.on_error]
          *    [cluster.virt_service]
          *    [cluster.gluster_service]
          *    [cluster.threads_as_cores]
          *    [cluster.tunnel_migration]
          * @return
          *     {@link Cluster }
          * @throws ClientProtocolException
          *             Signals that HTTP/S protocol error has occurred.
          * @throws ServerException
          *             Signals that an oVirt api error has occurred.
          * @throws IOException
          *             Signals that an I/O exception of some sort has occurred.
          */
         public Cluster add(org.ovirt.engine.sdk.entities.Cluster cluster) throws 
                 ClientProtocolException, ServerException, IOException {
             
                 ....
         }

         /**
          * Adds Cluster object.
          * @param cluster {@link org.ovirt.engine.sdk.entities.Cluster}
          *    cluster.data_center.id|name
          *    cluster.name
          *    cluster.version.major
          *    cluster.version.minor
          *    cluster.cpu.id
          *    [cluster.description]
          *    [cluster.memory_policy.overcommit.percent]
          *    [cluster.memory_policy.transparent_hugepages.enabled]
          *    [cluster.scheduling_policy.policy]
          *    [cluster.scheduling_policy.thresholds.low]
          *    [cluster.scheduling_policy.thresholds.high]
          *    [cluster.scheduling_policy.thresholds.duration]
          *    [cluster.error_handling.on_error]
          *    [cluster.virt_service]
          *    [cluster.gluster_service]
          *    [cluster.threads_as_cores]
          *    [cluster.tunnel_migration]
          * @param expect
          *    [201-created]
          * @param correlationId
          *    [any string]
          * @return
          *     {@link Cluster }
          * @throws ClientProtocolException
          *             Signals that HTTP/S protocol error has occurred.
          * @throws ServerException
          *             Signals that an oVirt api error has occurred.
          * @throws IOException
          *             Signals that an I/O exception of some sort has occurred.
          */
         public Cluster add(org.ovirt.engine.sdk.entities.Cluster cluster, String expect, String correlationId) throws 
                 ClientProtocolException, ServerException, IOException {
                 ....
         }
{% endhighlight %}

## Repository

*   <git://gerrit.ovirt.org/ovirt-engine>

## Maintainer

Michael Pasternak
