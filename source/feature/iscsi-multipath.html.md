---
title: iSCSI-Multipath
category: feature
authors: mlipchuk, sandrobonazzola, sgotliv
wiki_category: Feature|iSCSI Multipath
wiki_title: Feature/iSCSI-Multipath
wiki_revision_count: 28
wiki_last_updated: 2014-12-15
feature_name: iSCSI Multipath
feature_modules: storage
feature_status: Released
---

# iSCSI MultiPath

### Summary

iSCSI multipath feature enables the user to configure the iSCSI multipath from oVirt, by specifying specific networks to be used by the multipath with that configuration the user can configure the Hosts to connect to the iSCSI server through this specific networks.

#### A brief regarding multipath linux

      (see `[`Device-Mapper`](Features//iSCSI-Multipath#Device-Mapper)`.) Multipath (DM-Multipath) is a Linux native multipath tool, which allows you to configure multiple I/O paths between server nodes and storage arrays into a single device.
      Each multipath device has a World Wide Identifier (WWID), which is guaranteed to be globally unique and unchanging. By default, the name of a multipath device is set to its WWID

##### Device-Mapper

The Device-Mapper is a Linux kernel framework which used for mapping block devices onto higher-level virtual block devices. In the Linux kernel, the device-mapper is a generic framework to map one block device into another. Device mapper works by passing data from a virtual block device (provided by the device mapper itself) to another block device.

### Owner

*   Name:
*   Email:

### Current status

*   Merged to 3.4 branch

### Detailed Description

### Installation flow

### API

### Comments and Discussion

*   Refer to [Talk: iSCSIMultiPath](Talk: iSCSIMultiPath)

<Category:Feature> <Category:Template>
