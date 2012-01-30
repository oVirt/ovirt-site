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
    -   Permanent payload - payload which will be available in the guest at all times
    -   Temporary payload - via "run-once" - will be available only when running the guest via the run-once option
    -   No payloads - the VM won't get any payload upon startup/run-once

2.  Payload passing method
    -   Floppy
    -   CD
    -   In the future also injection and payload via private IP

There are a few options to model that:

1.  Use current Floppy/CD attachment options:
    -   In floppy allow to attach either sysprep or payload
    -   In CD allow to attach either an ISO, or a payload
    -   There will be a single attachment or payload per device type (floppy, CD)

2.  Add a payload in addition to the current Floppy/CD attachment options:
    -   Add a Payload option, in which you choose whether to pass the payload via CD or floppy (the passing method)
    -   In floppy allow to attach a payload
    -   In CD allow to attach a payload
    -   Both the payload and the attachment are used
    -   There may be multiple payloads, and multiple passing options at the same time
    -   There will be a single attachment and/or multiple payloads per device type (floppy, CD)
    -   In case Windows sysprep is used, we must make sure it gets the first floppy (drive "A:")

After the upstream discussions, the chosen model is the second one.

Notes:

1.  The payload data will be encoded using base64 encoding.
2.  All payloads will be passed in the current VDSM create verb
3.  With either options, the engine API and VDSM API will be general enough to allow adding other passing methods in the future
4.  The Modelling of this feature will include OVF schema changes as well
5.  For now we will limit the content of the file to 1024K. In the future we might use a NFS share in cases in which the content is bigger. if the content of the file is bigger the 512K it will pass an nfs share for vdsm to fetch the file/s

### Design Notes

VDSM verb:

       { 'iso': [{'filename': 'content' }, {'filename': 'content'}],
        'floppy': [{'filename': 'content' }, {'filename': 'content'}],
        'sysprep': {'filename': 'content' },
        'network': '...' } 
       

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
