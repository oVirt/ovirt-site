---
title: VMPayload
category: feature
authors: ovedo, shahar, shaharh, vered
wiki_category: Feature
wiki_title: Features/VMPayload
wiki_revision_count: 25
wiki_last_updated: 2014-04-29
---

# VM Payload

### Summary

The purpose of the feature is to allow a guest to get a payload upon startup.

### Owner

*   Name: [ Oved Ourfali](User:Ovedo)

Include you email address that you can be reached should people want to contact you about helping with your feature, status is requested, or technical issues need to be resolved

*   Email: <ovedo@redhat.com>

### Current status

*   In progress of defining the requirements

### Detailed Description

There are many cases in which there is a need to add some payload to a VM. For example, running windows sysprep, external management of installation of 3rd party products in the VM, and etc. The purpose of the feature is to allow adding such a payload externally, specify the payload method (ISO, floppy), specify when this data has to be available, and etc.

The payload options are:

1.  Availability
    -   Permenant payload - payload which will be available in the guest at all times
    -   Temporary payload - via "run-once" - will be available only when running the guest via the run-once option
    -   No payloads - the VM won't get any payload upon startup/run-once

2.  Payload methods
    -   Floppy
    -   ISO
    -   In the future also injection and payload via private IP

Notes:

1.  The payload data will be encoded using base64 encoding. The engine will decode the data, and payload it via the required method.
2.  The payload may consist of one or more files, all will be available via the same payload method

### Benefit to oVirt

The VM payload feature will ease the installation of third party products, mainly in a cloud environment.

### Dependencies / Related Features

Affected oVirt projects:

*   API
*   CLI
*   SDK
*   Engine-core
*   Webadmin
*   User Portal

### Documentation / External references

*   <http://lists.ovirt.org/pipermail/engine-devel/2012-January/000423.html>

### Comments and Discussion

<Category:Feature> <Category:Template>
