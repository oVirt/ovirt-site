---
title: Online Virtual Drive Resize
category: feature
authors: derez, fsimonce, sgotliv
wiki_category: Feature
wiki_title: Features/Online Virtual Drive Resize
wiki_revision_count: 13
wiki_last_updated: 2014-07-13
---

# Enable Online Virtual Drive Resize

### Summary

This feature allows oVirt users to resize virtual disks while they are in use by one or more virtual machines without the need of pausing, hibernating or rebooting the guests. The virtual disk is disk seen by the guest operating system and should not be confused with the hardware storage (storage domain) which already support online extension.

### Owner

*   Feature owner: Sean Cohen <scohen@redhat.com>
*   Engine Component owner: Sergey Gotliv <sgotliv@redhat.com>
*   VDSM Component owner: Federico Simoncelli <fsimonce@redhat.com>

### Current Status

*   QEMU
    -   must support the online resizing of virtual disks: **Done**
*   Libvirt
    -   libvirt needs to expose an API to use such capability: **Done**
*   VDSM
    -   changes to block devices (new SPM API call): **Done**
    -   additional API call to passthrough to libvirt: **Done**
*   oVirt engine
    -   need to create a new command to coordinate the entire flow (call to SPM and then call to VM): **Done**
*   oVirt GUI
    -   need to expose the new functionality: **Done**
*   Rest API
    -   need to expose the new functionality: **Done**
*   QEMU-GA
    -   support for notifying the guest and updating the size of the visible disk: **To be integrated**

### Limitations

*   Shrinking of the virtual drive currently is not supported
*   Floating disk, the disk which is not attached to any VM, is not supported

# Detailed Description

1.  A request from oVirt Engine is sent to the SPM to extend the image. The scope of this request is mainly to extend the Logical Volume where the image resides and to update the metadata. The extension relevant only when the image is RAW and resides on a block device. Most of the time this call can be optimized out or would be treated as a NO-OP on the SPM. In the case of a RAW image on a file domain a “truncate” commad could be issued on the image to add additional sparse space at the end but we expect the QEMU process to do this anyway as part of its implementation. A preallocated RAW file can be extended using a non-sparse dd command to add zeroes at the end of the image (this is for consistence even if preallocating data on NFS doesn't guarantee that the space is actually reserved).
2.  The oVirt Engine polls the extendImage status. Generally this task is expected to complete quite quickly (NO-OP or lvm command to extend a volume). The only case which might take a long time to complete is preallocating the space on file domains.
3.  The extendImage task is completed with success.
4.  A resizeVmImage is sent to the HSM where the virtual machine is running. This command is used to notify the request to extend the image seen by the virtual machine.
5.  The request of extending the virtual image is passed to libvirt as it's the layered interface on top of the QEMU process (virtual machine)
6.  The request to extend the virtual image is passed by libvirt to QEMU. QEMU is in charge of truncating the file when relevant, changing the QCOW header of the image (if applicable) to reflect the new size and update all its internal structures (including the ones reporting the disk size to the guest).
7.  Once the extension is successfully updated on disk (QCOW) and in the internal representation of the QEMU process an optional (in terms of libvirt API) request to the guest agent is delivered to notify the change and to update the guest OS

![`OnlineVirtualDiskResizeDiagram1.png`](OnlineVirtualDiskResizeDiagram1.png "OnlineVirtualDiskResizeDiagram1.png")

### Dependencies / Related Features and Projects

*   

### Documentation / External references

*   <http://libvirt.org/html/libvirt-libvirt.html#virDomainBlockResize>

### Comments and Discussion

### Future Work

*   Adding ability to extend size of the floating disks.

<Category:Feature>
