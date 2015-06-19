---
title: REST API Developer Guidelines
category: api
authors: mkolesni
wiki_title: REST API Developer Guidelines
wiki_revision_count: 1
wiki_last_updated: 2012-08-20
---

# REST API Developer Guidelines

## Basics: API definitions

### Engine API classes

#### Location

backend/manager/modules/common/

#### Purpose

These entities serve the engine internally, and define an API which clients (REST API, web clients) interact by.

There are essentially two main types of classes which are important to know:

1.  "Business entities" which represent entities within the system, such as a VM.
2.  "Parameters" which represent a command's API, and may contain "Business entities".

#### Change policy

Changes can be made, as long as all clients are updated to work with the changed API.

### REST API definitions

#### Location

backend/manager/modules/restapi/interface/definition/

#### Purpose

These are the antities which compose the REST API and represent what is exposed externally to whoever consumes the REST API.

The two classes of common entities are exposed by two distinct files:

1.  api.xsd is an XSD schema which defines the API's "business entities" which are resources (per the REST definition) plus some basic elements & fields which are exposed.
2.  rsdl_metadata_v-3.1.yaml is a YAML file which defines additional metadata on the exposed API, such as which parameters are optional and which are mandatory, headers, etc.

Java classes are auto-generated from the api.xsd file, so essentially changes should be made to that file and not the generated java class.

**Note:** If the project doesn't compile in your IDE, make sure this folder is on the classpath:

backend/manager/modules/restapi/interface/definition/target/generated-sources/xjc

#### Change policy

Additions are OK. Other changes (rename, move, delete a resource or resource field) are NOT OK, since the API will be broken. Essentially, other than addition, if something was in the API and got released, it would be very difficult to change (since we don't know the clients, and can't force the change upon them).

## Basics: Mapping

### Mapping resources to/from XML

The mapping is done automatically by JAXB, according to api.xsd.

Links are generated per resource according to the public methods which are marked with one of these annotations:

*   javax.ws.rs.GET
    -   Expected request body: None
    -   Returned response body: According to defined resource type

<!-- -->

*   javax.ws.rs.POST
    -   Expected request body: According to defined resource type
    -   Returned response body: According to defined resource type

<!-- -->

*   javax.ws.rs.PUT
    -   Expected request body: According to defined resource type
    -   Returned response body: According to defined resource type

<!-- -->

*   javax.ws.rs.DELETE
    -   Expected request body: ID
    -   Returned response body: None

<!-- -->

*   org.ovirt.engine.api.model.Actionable
    -   Should come together with POST
    -   Expected request body: According to defined resource type (Action, which contains parameters)
    -   Returned response body: Should be same as request body, with status indicator set to indicate success

### Mapping business entities to/from resources

Mapping of this kind is done via Mappers framework, which allows a 1:1 mapping to/from 2 distinct classes.

Mappers are always called according to the API resource involved + "Mapper" extension.

For example, to see how a Tag resource gets mapped you need to look for TagMapper class.

The mapper contains public static methods annotated with org.ovirt.engine.api.restapi.types.Mapping which designate the source and destination java class.

The return value of the method is always the destination type, and the source is sent as 1st parameter.

The 2nd parameter sent is a "template" of the destination type - if sent it will be modified in the mapping and returned mapped, otherwise a new instance of the target type will be returned.
