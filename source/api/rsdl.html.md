---
title: RSDL
category: api
authors: michael pasternak
wiki_category: Api
wiki_title: RSDL
wiki_revision_count: 13
wiki_last_updated: 2013-09-23
---

# RSDL

__TOC__

## Description

RSDL (RESTful Service Description Language) is a machine and human readable XML description of HTTP-based web applications (typically REST web services), it models the resource/s provided by a service, the relationships between them, parameters that has to be supplied for the certain operation, specifies if parameter/s has to be mandated and describes possible overloads as parameters sets, RSDL is intended to simplify the reuse of web services that are based on the HTTP architecture of the Web. It is platform and language independent and aims to promote reuse of applications beyond the basic use in a web browser by both humans and machines.

Unlike WADL, it's concentrates in describing URIs as stand along entry points in to the application which can be invoked in a different way, what is makes it human-readable and easily consumed by both humans and machines, (for more details see [link title](http://www.example.com)).

## Concept

### self descriptive

RSDL represents different URIs as stand along entry points in to the application, following resource URIs, one can figure out what methods available for the given resources and how the can be consumed.

### machine-readable

each URI in RSDL contains all necessary info to generate HTTP request from it, that can be consumed easy accessing this URI internals.

### human-readable

each URI in RSDL contains "rel" and "description" describing the meaning of the given operation on the certain URI, humans can easily fetch all available operations for the given collection/resource simply by locating different descriptors with same URI.

## Format

`   `<rsdl rel="rsdl" href="/api?rsdl">
`       `<description></description>
`       `<version revision="0" build="0" minor="0" major="0"/>
`       `<schema rel="schema" href="/api?schema">
`           `<name>`api.xsd`</name>
`           `<description></description>
`       `</schema>
`       `<general rel="*" href="/*">
`           `<request>
`               `<headers>
                         

<header required="true|false">
`                       `<name></name>
`                       `<description></description>
`                       `<value></value>
                         

</header>
                        ...
`               `</headers>
`               `<url>
`                   `<parameters_set>
`                       `<parameter context="query|matrix" type="xs:string" required="true|false">
`                           `<name></name>
`                           `<value></value>
`                       `</parameter>
                         ...
`                   `</parameters_set>
                         ...
`           `</request>
`           `<name></name>
`           `<description></description>
`       `</general>
`       `<links>
`           `<link rel="get|..." href="/api/xxx">
`               `<request>
`                   `<http_method>`GET|POST|PUT|DELETE|...`</http_method>
`                   `<headers>
                             

<header required="true|false">
`                           `<name></name>
`                           `<value></value>
                             

</header>
                             ...
`                   `</headers>
`                   `<url>
`                       `<parameters_set>
`                           `<parameter context="query|matrix" type="" required="true|false">
`                               `<name></name>
`                               `<value></value>
`                           `</parameter>
                                 ...
`                       `</parameters_set>
                             ...
`                   `</url>
                         

<body>
`                       `<type>`...`</type>
`                       `<parameters_set>
`                           `<parameter type="" required="true|false">
`                               `<name>`FQ-name-to-parameter`</name>
`                           `</parameter>
                                 ...
`                       `</parameters_set>
                             ...
                         

</body>
`               `</request>
`               `<response>
`                   `<type></type>
                         ...
`               `</response>
`           `</link>
                 ...
`       `</links>
`   `</rsdl>

### Components

#### uri

#### request

#### response

### XML schema

## Usage

### examples

### generated code

## Maintainer

Michael Pasternak: mpastern@redhat.com

<Category:Api>
