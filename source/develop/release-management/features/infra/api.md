---
title: Api
category: feature
authors: michael pasternak
toc: true
---

# Api

### Description

oVirt api package provides Application programming interface for the oVirt engine.

### REST Concept

*   Client–server
*   Stateless
*   Cacheable
*   Uniform interface
*   Identification of resources
*   Manipulation of resources through representations
*   Self-descriptive
*   Hypermedia as the engine of application state

### oVirt-API URI structure

oVirt API follows collection/resource patten: `http(s)://server:port/api/vms/xxx-xxx/disks/yyy-yyy`

1. protocol
2. server details
3. entry point (base resource)
4. collection
5. resource
6. sub-collection
7. sub-resource

### oVirt-API How-to (the methods)

* To list all collection resources, use GET.
  ```javascript
  GET http(s)://server:port/api/vms
  ```

* To retrieve specific resource, use GET.
  ```javascript
  GET http(s)://server:port/api/vms/xxx
  ```
  ```console
  $ curl -v -u "user@domain:password" -H "Content-type: application/xml" -X GET http(s)://server:port/api/vms/xxx
  ```

* To create a resource, use POST.
  ```javascript
  POST http(s)://server:port/api/vms
  <vm>`...`</vm>
  ```
  ```console
  $ curl -v -u "user@domain:password"  -H "Content-type: application/xml" \
  -d '<vm>
    <name>my_new_vm</name>
    <cluster><name>cluster_name</name></cluster>
    <template><name>template_name</name></template>
  </vm>' 'http(s)://server:port/api/vms'
  ```

* To update the resource, use PUT.
  ```javascript
  PUT http(s)://server:port/api/vms/xxx
  <vm><name>aaa</name></vm>
  ```
  ```console
  $ echo "<vm><name>new_name</name></vm>" >  /tmp/upload.xml
  $ curl -v -u "user@domain:password" -H "Content-type: application/xml" -T /tmp/upload.xml 'http(s)://server:port/api/vms/xxx'
  ```

* To remove the resource, use DELETE.
  ```javascript
  DELETE http(s)://server:port/api/vms/xxx
  ```
  ```console
  $ curl -v -u "user@domain:password" -X DELETE http(s)://server:port/api/vms/xxx
  ```

### [RSDL](/develop/release-management/features/infra/rsdl.html) (RESTful Service Description Language)

RSDL (RESTful Service Description Language) is a machine and human readable XML description of HTTP-based web applications (typically REST web services),
it models the resource/s provided by a service, the relationships between them, parameters that has to be supplied for the certain operation,
specifies if parameter/s has to be mandated and describes possible overloads as parameters sets, RSDL is intended to simplify the reuse of
web services that are based on the HTTP architecture of the Web.
It is platform and language independent and aims to promote reuse of applications beyond the basic use in a web browser by both humans and machines

## Repository

*   <https://github.com/oVirt/ovirt-engine>

(restapi is one of the engine modules located under `ovirt/ovirt-engine/backend/manager/modules/restapi/`)

## Maintainers

Michael Pasternak: <mishka8520@yahoo.com>, Juan Hernandez: <juan.hernandez@redhat.com>

