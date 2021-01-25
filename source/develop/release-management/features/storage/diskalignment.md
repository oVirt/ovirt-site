---
title: DiskAlignment
authors: fsimonce
feature_name: Disk Alignment
feature_status: Obsolete
---

**Note**: this feature is now obsolete. It was introduced in oVirt 3.3 and dropped in oVirt 4.4 [(Bug #1533086)](https://bugzilla.redhat.com/show_bug.cgi?id=1533086)



# Disks Block Alignment

This page describes the Disk Block Alignment feature. The main scope of this feature is to provide a way in oVirt to find the virtual disks with misaligned partitions. For more information on this matter please refer to the [virt-alignment-scan](http://libguestfs.org/virt-alignment-scan.1.html) tool.
The NetApp document that summarises the problem used to be at: `http://media.netapp.com/documents/tr-3747.pdf` but is not available anymore.

> When older operating systems install themselves, the partitioning tools place partitions at a sector misaligned with the underlying storage (commonly the first partition starts on sector 63). Misaligned partitions can result in an operating system issuing more I/O than should be necessary.

# Phases

1.  Provide a way to determine if the partitions of a virtual disk are aligned to the underlying device blocks
2.  Provide a way to automatically align a misaligned partitions

# Phase 1 - Find and Report Misaligned Disks

## Mockups

It will be possible to trigger the Disk Alignment scan both from the Disks main tab and the Disk subtab in the Virtual Machine main tab.

![](/images/wiki/DiskAlignmentMock1.png) ![](/images/wiki/DiskAlignmentMock2.png)

## Implementations Details

A new XML-RPC call (Engine-VDSM) will be introduced:

    scanDiskAlignment(vmId, driveSpecs)

**vmId** is the UUID of the VM that is attached to the disk or a blank UUID in case of a floating disk. In the future the **vmId** can be used to identify a running VM and execute the scan through a guest agent in those cases where it's impossible to do it concurrently (e.g. COW disk format). The **driveSpecs** parameter is in the same format used when starting a VM on a VDSM host:

    driveSpecs = {
        'poolID':   `<poolID>`,
        'domainID': `<domainID>`,
        'imageID':  `<imageID>`,
        'volumeID': `<volumeID>`,
    }

Or for direct LUNs:

    driveSpecs = {
        'GUID': `<GUID>`,
    }

The expected information returned in case of success are:

    alignmentInfo = {
        'status': {'message': 'Done', 'code': 0},
        'alignment': {
           '/dev/sda1': True,
           '/dev/sda2': True,
    }}

The result (with the scan execution timestamp) is stored in the `base_disks` table (as other similar properties such as the `bootable` and `shareable` flags).
