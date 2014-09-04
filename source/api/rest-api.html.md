---
title: REST-Api
category: api
authors: jhernand, michael pasternak, moolit
wiki_category: Api
wiki_title: REST-Api
wiki_revision_count: 6
wiki_last_updated: 2014-09-05
---

# REST-Api

__TOC__

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

oVirt API follows collection/resource patten:

      http(s)://server:port/api/vms/xxx-xxx/disks/yyy-yyy

1. protocol

2. server details

3. entry point (base resource)

4. collection

5. resource

6. sub-collection

7. sub-resource

### oVirt-API How-to (the methods)

*   To list all collection resources, use GET.

      GET http(s)://server:port/api/vms

*   To retrieve specific resource, use GET.

      GET http(s)://server:port/api/vms/xxx

      curl -v -u "user@domain:password" -H "Content-type: application/xml" -X GET http(s)://server:port/api/vms/xxx

*   To create a resource, use POST.

      POST http(s)://server:port/api/vms
<vm>`...`</vm>

      curl -v -u "user@domain:password" 
      -H "Content-type: application/xml" 
      -d 
` '`<vm>
`  `<name>`my_new_vm`</name>
`  `<cluster><name>`cluster_name`</name></cluster>
`  `<template><name>`template_name`</name></template>
       `</vm>`' 'http(s)://server:port/api/vms'

*   To update the resource, use PUT.

      PUT http(s)://server:port/api/vms/xxx 
<vm><name>`aaa`</name></vm>

      echo "`<vm><name>`new_name`</name></vm>`" >  /tmp/upload.xml
      curl -v -u "user@domain:password" 
       -H "Content-type: application/xml" 
       -T /tmp/upload.xml 
       'http(s)://server:port/api/vms/xxx'

*   To remove the resource, use DELETE.

      DELETE http(s)://server:port/api/vms/xxx

      curl -v -u "user@domain:password" -X DELETE http(s)://server:port/api/vms/xxx

### [RSDL](RSDL) (RESTful Service Description Language)

RSDL (RESTful Service Description Language) is a machine and human readable XML description of HTTP-based web applications (typically REST web services), it models the resources provided by a service, the relationships between them, parameters that have to be supplied for certain operation, specifies if parameters are mandatory and describes possible overloads as parameters sets, RSDL is intended to simplify the reuse of web services that are based on the HTTP architecture of the Web. It is platform and language independent and aims to promote reuse of applications beyond the basic use in a web browser by both humans and machines

## FAQ

#### How can I use the RESTAPI from a simple shell script?

You can use any tool that is capable of sending HTTP requests, like `curl`, `wget` or even `nc`. Most of the examples in this page use `curl`. To get the list of VMs, for example:

    url="https://ovirt.example.com/ovirt-engine/api"
    user="admin@internal"
    password="******"

    curl \
    --insecure \
    --header "Accept: application/xml" \
    --user "${user}:${password}" \
    "${url}/vms"

#### Where can I find network and IO statiscs for virtual machines?

The statistics, in general, are avaialble in the `statistics` subresource of the corresponding object. For example, the statistics for the network interface of a virtual machine are available in `vms/{vm:id}/nics/{nic:id}/statitics`. Currently we have there the following statistics:

*   `data.current.rx` - Receive data rate
*   `data.current.tx` - Transmit data rate
*   `errors.total.rx` - Total transmit errors
*   `errors.total.tx` - Total transmit errors

For disk IO the statistics are located in the disk resource, either inside global disks collection `disks/{disk:id}/statistics` or inside the collection of disks of a specific VM `vms/{vm:id}/disks/{disk:id}/statistics`. Currently we have the following statistics for disks:

*   `data.current.read` - Read data rate
*   `data.current.write` - Write data rate
*   `disk.read.latency` - Read latency
*   `disk.write.latency` - Write latency
*   `disk.flush.latency` - Flush latency

## Repository

*   <git://gerrit.ovirt.org/ovirt-engine> (restapi is one of the engine modules located under ovirt/ovirt-engine/backend/manager/modules/restapi/)

## Maintainer

Michael Pasternak: mpastern@redhat.com

<Category:Api>
