---
title: oVirt engine tools
authors: abonas, adahms, knesenko, lveyde, moti, roy, yair zaslavsky
wiki_title: OVirt engine tools
wiki_revision_count: 17
wiki_last_updated: 2015-06-18
---

# oVirt engine tools

Engine tools are mainly standlone java programs wrapped-up by scripts and mostly using the engine libraries

## Tools list

1.  engine-manage-domains
2.  engine-config
3.  engine-notifier
4.  engine-iso-uploader
5.  engine-logcollector
6.  generate-ssh-keys
7.  store-utils.sh

### Tools description

### engine-manage-domains

Using this tool it is possible to add new authentication domains to serve as resource for users authenticating to oVirt engine.

**How to get the tool**:
The tool is installed when engine is installed.

**How to configure the tool:**
You can edit the configuration located at /etc/ovirt-engine/engine-manage-domains/engine-manage-domains.conf

**How to run the tool:**
Running basic example:
'engine-manage-domains add --domain=<MY_DOMAIN> --provider=<ad/ipa/oldap/itds/rhds> --user=<USERNAME>'

### engine-config

Using this tool it is possible to alter engine's configuration

**How to get the tool:**
The tool is installed when engine is installed.

**How to configure the tool:**
You can edit the configuration located at /etc/ovirt-engine/engine-config/engine-config.conf

**How to run the tool:**
Running basic example:'
'engine-config -l' - will show you list of properties that can be alttered 'engine-config-g <property_name>' - will show you the value of a property 'engine-config-s <property_name>=<property_value>' - will alter the value of a property

### ovirt-iso-uploader

The ovirt-iso-uploader can be used to list the names of ISO storage domains (not the images stored in those domains) and upload files to storage domains. The upload operation supports multiple files (separated by spaces) and wildcarding. The engine-iso-uploader will, by default, attempt to interact with the REST API.

 **How to get the uploader:**
The uploader is pulled in by ovirt-engine when the engine is installed via rpm.

In case it didn't :

'yum install ovirt-iso-uploader'

In developer environment when not installing the engine via rpm, the uploader's rpm can be downloaded and installed from here (latest stable):

[`http://resources.ovirt.org/pub/ovirt-3.5/rpm/`](http://resources.ovirt.org/pub/ovirt-3.5/rpm/)

 **How to configure the uploader:**
1. First, make sure the ovirt-engine is running and that it has an ISO domain that is up.
2. The uploader has several configuration options which can be seen by doing
'man engine-iso-uploader'

The basic/minimal parameters that need to be filled prior to running the uploader are user and host:port of the engine. Those parameters should be configured in:
'/etc/ovirt-engine/isouploader.conf'

**How to run the uploader:**
Basic running examples:
List available ISO domains: 'engine-iso-uploader list'
Upload ISO or VFD image to the ISO domain: 'engine-iso-uploader -i <ISO Domain Name> upload <ISO/VFD file name>'

### engine-image-uploader

Using the engine-image-uploader command, you can list export storage domains and upload virtual machines in Open Virtualization Format (OVF) to a oVirt Engine. The tool only supports OVF (ova) files created by oVirt.
 **How to get the uploader:**
The uploader is pulled in by ovirt-engine when the engine is installed via rpm.

In case it didn't :

'yum install ovirt-image-uploader'

In developer environment when not installing the engine via rpm, the uploader's rpm can be downloaded and installed from here (latest stable):

[`http://resources.ovirt.org/pub/ovirt-3.5/rpm/`](http://resources.ovirt.org/pub/ovirt-3.5/rpm/)

 **How to configure the uploader:**
1. First, make sure the ovirt-engine is running and that it has an export domain that is up.
2. The uploader has several configuration options which can be seen by doing
'man engine-image-uploader'

The basic/minimal parameters that need to be filled prior to running the uploader are user,password and host:port of the engine. Those parameters should be configured in:
'/etc/ovirt-engine/imageuploader.conf'

**How to run the uploader:**
Running basic example:
'engine-image-uploader -e <exportDomainName> --name <howToCallTheApplianceInOvirt> upload <ova/ovf file name>'

### ovirt-log-collector

The engine-log-collector command gathers data from many different components (logs, databases, and environmental information) associated with an instance of a oVirt Enterprise Virtualization Engine Manager. The tool is intended to be run from the Linux system on which the is running as the root user.

### Tools TODO

1.  Standardize the usage of all tools and make them consistent
2.  Create common infrastructure both for Java programs and for the wrapping scripts e.g. functions to fulfill classpath dependencies, etc.
3.  Use comon paths for all
4.  Use a single logger library (apache-commons-logging)
