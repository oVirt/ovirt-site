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

2.  Override current Floppy/CD attachment options:
    -   Add a Payload option, in which you choose whether to pass the payload via CD or floppy (the passing method)
    -   In floppy allow to attach a payload
    -   In CD allow to attach a payload
    -   Once a payload is chosen (either via CD or floppy), it will override the floppy/CD attachment

3.  Add a payload in addition to the current Floppy/CD attachment options:
    -   Add a Payload option, in which you choose whether to pass the payload via CD or floppy (the passing method)
    -   In floppy allow to attach a payload
    -   In CD allow to attach a payload
    -   Both the payload and the attachment are used

Notes:

1.  The payload data will be encoded using base64 encoding. The engine will decode the data, and payload it via the required method
2.  The may be multiple payloads, and multiple passing options at the same time
3.  All payloads will be passed in the same method
4.  We will currently focus on the CD/floppy passing methods
5.  With either options, the engine and VDSM API will be general enough to allow adding other passing methods in the future
6.  The Modelling of this feature will include OVF schema changes as well

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
