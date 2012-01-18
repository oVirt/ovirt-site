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

The purpose of the feature is to allow passing a payload to a guest upon startup.

### Owner

*   Name: [ Shahar Havivi](User:Shaharh)
*   Email: <shavivi@redhat.com>

### Current status

*   In progress of defining the requirements

### Detailed Description

There are many cases in which there is a need to pass a payload to a VM. For example, running windows sysprep, external management of installation of 3rd party products, and etc. The purpose of the feature is to allow adding such a payload externally, specify the payload method (CD, floppy), specify when this data has to be available, and etc.

The payload options are:

1.  Availability
    -   Permenant payload - payload which will be available in the guest at all times
    -   Temporary payload - via "run-once" - will be available only when running the guest via the run-once option
    -   No payloads - the VM won't get any payload upon startup/run-once

2.  Payload passing method
    -   Floppy
    -   CD
    -   In the future also injection and payload via private IP

Notes:

1.  The payload data will be encoded using base64 encoding. The engine will decode the data, and payload it via the required method.
2.  The may be multiple payloads
3.  All payloads will be passed in the same method

### User work-flows

The Administrator and User Portal should allow the following operations in edit VM:

1.  Enable/Disable payload
2.  Once enabled
    -   Choose payload method
        -   Floppy
        -   CD
    -   For each payload
    -   Choose the path
    -   Provide the base64 data

### Benefit to oVirt

The VM payload feature will ease the installation of third party products, mainly in a cloud environment.

### Dependencies / Related Features

Affected oVirt projects:

*   VDSM
*   API
*   CLI
*   SDK
*   Engine
*   Webadmin
*   User Portal

### Documentation / External references

*   <http://lists.ovirt.org/pipermail/engine-devel/2012-January/000423.html>

### Comments and Discussion

<Category:Feature> <Category:Template>
