---
title: REST-Api
category: api
authors:
  - jhernand
  - michael pasternak
  - moolit
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

      GET http(s)://server:port/api/vms

*   To retrieve specific resource, use GET.

      GET http(s)://server:port/api/vms/xxx

      curl -v -u "user@domain:password" -H "Content-type: application/xml" -X GET http(s)://server:port/api/vms/xxx

*   To create a resource, use POST.

      POST http(s)://server:port/api/vms
<vm>`...`</vm>

      curl -v -u "user@domain:password" 
      -H "Content-type: application/xml" 
      -d 
` '`<vm>
`  `<name>`my_new_vm`</name>
`  `<cluster><name>`cluster_name`</name></cluster>
`  `<template><name>`template_name`</name></template>
       `</vm>`' 'http(s)://server:port/api/vms'

*   To update the resource, use PUT.

      PUT http(s)://server:port/api/vms/xxx 
<vm><name>`aaa`</name></vm>

      echo "`<vm><name>`new_name`</name></vm>`" >  /tmp/upload.xml
      curl -v -u "user@domain:password" 
       -H "Content-type: application/xml" 
       -T /tmp/upload.xml 
       'http(s)://server:port/api/vms/xxx'

*   To remove the resource, use DELETE.

      DELETE http(s)://server:port/api/vms/xxx

      curl -v -u "user@domain:password" -X DELETE http(s)://server:port/api/vms/xxx

### [RSDL](/develop/release-management/features/infra/rsdl.html) (RESTful Service Description Language)

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

*NOTE:* That if you have a environment that's utilizing SSO and the domain name includes a space, you'll likely find this form of the above command easier to deal with:

    url="https://ovirt.example.com/ovirt-engine/api"
    user="admin"
    password="******"
    dom-"My Directory"
    
    curl \
    --insecure \
    --header "Accept: application/xml" \
    --user "${user}@${dom}:${password}" \
    "${url}/vms"

#### How can I run a custom script using cloud-init?

The custom script has to be included in the `initialization` section of the request, outside of the `cloud-init` tag:

    <action>
      <vm>
        <initialization>
          <cloud_init>...</clod_init>
          <custom_script><![CDATA[your script]]></custom_script>
        </initialization>
        </vm>
    </action>

Unfortunatelly this won't work in 3.4, because the `custom_script` element is ignored when combined with the `cloud_init` element. Instead of that the custom script has to be included in the content of the first `file` element of the `cloud_init` element. This is probably a [bug](https://bugzilla.redhat.com/1138564), so to avoid future breakages it is good idea to include the custom script in both places:

    #!/bin/sh -x

    url="https://fedora.example.com/ovirt-engine/api"
    user="admin@internal"
    password="******"

    curl \
    --insecure \
    --request POST \
    --header "Accept: application/xml" \
    --header "Content-Type: application/xml" \
    --user "${user}:${password}" \
    --data '
    <action>
      <vm>
        <initialization>
          <cloud_init>
            <host>
              <address>myhost.mydomain.com</address>
              </host>
            <users>
              <user>
                <user_name>root</user_name>
                <password>mypassword</password>
              </user>
            </users>
            <network_configuration>
              <nics>
                <nic>
                  <name>eth0</name>
                  <boot_protocol>static</boot_protocol>
                  <network>
                    <ip address="192.168.122.31" netmask="255.255.255" gateway="192.168.122.1"/>
                  </network>
                  <on_boot>true</on_boot>
                </nic>
              </nics>
              <dns>
                <servers>
                  <host>
                    <address>192.168.122.1</address>
                  </host>
                </servers>
                <search_domains>
                  <host>
                    <address>mydomain.com</address>
                  </host>
                </search_domains>
              </dns>
            </network_configuration>
            <files>
              <file>
                <name>ignored</name>
                <content><![CDATA[runcmd:
     - echo "I was here!" > /iwashere.txt
    ]]></content>
                <type>plaintext</type>
              </file>
            </files>
          </cloud_init>
          <custom_script><![CDATA[runcmd:
     - echo "I was here!" > /iwashere.txt
    ]]></custom_script>
        </initialization>
      </vm>
    </action>
    ' \
    "${url}/vms/480225cf-0cbd-4166-b9ca-3857b124618a/start"

Take into account that this custom script is not a shell script, but just a fragment of the cloud-init configuration file, and will be copied as is. If what you want is to run a shell command you will have to use the `runcmd` option of cloud-init, as described [here](http://cloudinit.readthedocs.org/en/latest/topics/examples.html#run-commands-on-first-boot).

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

