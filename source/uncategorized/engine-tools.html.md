---
title: OVirt engine tools
authors: abonas, adahms, knesenko, moti, roy, yair zaslavsky
wiki_title: OVirt engine tools
wiki_revision_count: 12
wiki_last_updated: 2014-08-11
---

# OVirt engine tools

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

### ovirt-iso-uploader

The ovirt-iso-uploader can be used to list the names of ISO storage domains (not the images stored in those domains) and upload files to storage domains. The upload operation supports multiple files (separated by spaces) and wildcarding. The engine-iso-uploader will, by default, attempt to interact with the REST API.

### ovirt-image-upload

Using the engine-image-uploader command, you can list export storage domains and upload virtual machines in Open Virtualization Format (OVF) to a oVirt Engine. The tool only supports OVF files created by oVirt.

### ovirt-log-collector

The engine-log-collector command gathers data from many different components (logs, databases, and environmental information) associated with an instance of a oVirt Enterprise Virtualization Engine Manager. The tool is intended to be run from the Linux system on which the is running as the root user.

### Tools TODO

1.  standardize all tools usage and make it consistent
2.  create common infra both for java programs and for the wrapping scripts e.g functions to fulfill classpath dependencies etc.
3.  use comon paths for all
4.  Use a single logger library (apache-commons-logging)
