---
title: VMPayload
category: feature
authors: ovedo, shahar, shaharh, vered
---

# VM Payload

## Summary

The purpose of the feature is to allow passing a payload to a guest upon startup.

## Owner

*   Name: Shahar Havivi (Shaharh)
*   Email: <shavivi@redhat.com>

## Current status

*   In progress of defining the requirements

## Detailed Description

There are many cases in which there is a need to pass a payload to a VM. For example, running windows sysprep, external management of installation of 3rd party products, etc. The purpose of the feature is to allow adding such a payload externally, specify the payload method (CD, floppy), specify when this data has to be available, etc.

The payload options are:

1.  Availability
    -   Permanent payload - payload which will be available in the guest at all times
    -   Temporary payload - via "run-once" - will be available only when running the guest via the run-once option
    -   No payloads - the VM won't get any payload upon startup/run-once

2.  Payload passing method
    -   Floppy
    -   CD
    -   In the future also libguestfs injection and payload downloaded via private IP

**Implementation notes:**

1.  **backend, frontend:** only one payload per vm
2.  **backend, forntend:** For now we will limit the content of the file to 16K.
3.  **backend, frontend:** add support to run-once
4.  **backend, frontend:** add support to add/edit VM
5.  **backend, frontend:** add GetVmPayloadQuery() (needed because there is no persistence to payload in VmBase)
6.  **backend:** The Modelling of this feature will include OVF schema changes as well
7.  **backend:** payload will be as cdrom/floppy device, if we use payload-cdrom we don't allow regular cdrom
8.  **backend:** add 3 fields to VM class (not persistence) payload_type, payload_filename, payload_content
9.  **bacnend:** payload will be present as a cdrom/floppy device with the payload data in the specParams (and will be persist to db)
10. **backend:** change cd will be enabled on the payload-cdrom (which will be the only cdrom)
11. **vdsm:** will parse the device and create temp cdrom/floppy file-system file.
12. **vdsm:** will remove the payload data when returning the vmStats to backend
13. **vdsm:** on migration will have the same devices
14. **vdsm:** on destroy will delete the temp file-system
15. **bacnend:** the file names should be passed in Unicode
16. **backend:**The payload data will be encoded using base64 encoding
17. **vdsm:** should re-encode them as utf8 when writing them to disk

## API Design

This is an example for the API for this feature, the vm_paload element will work in add/edit VM and for Run-VM actions

         <vm>
         ...
           <payloads>
               <payload type='cdrom'>
                   <files>
                       <file>
                            <name>my.txt</name>
                            <content>some content</content>
                      </file>
                   </files>
               </payload>
           </payloads>
        </vm>
       

## Design Notes

vmPayload is passed in the create params:

       'vmPayload': { 'cdrom': [{'filename': 'content' }, {'filename': 'content'}],
        'floppy': [{'filename': 'content' }, {'filename': 'content'}],
        'sysprep': {'filename': 'content' },
        'network': '...' }
       

## User work-flows

The Administrator and User Portal should allow the following operations in edit VM:

1.  Enable/Disable payload
2.  Once enabled
    -   Choose payload method
        -   Floppy
        -   CD
    -   For each payload
    -   Choose the path
    -   Provide the base64 data

## Benefit to oVirt

The VM payload feature will ease the installation of third party products, mainly in a cloud environment.

## Dependencies / Related Features

Affected oVirt projects:

*   VDSM
*   API
*   CLI
*   SDK
*   Engine
*   Webadmin
*   User Portal

## Documentation / External references

*   <https://lists.ovirt.org/pipermail/engine-devel/2012-January/000423.html>


