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

[Device-Mapper](Feature/iSCSI-Multipath#Device-Mapper) Multipath (DM-Multipath) is a Linux native multipath tool, which allows to configure multiple I/O paths between server nodes and storage arrays into a single device.
Each multipath device has a World Wide Identifier (WWID), which is guaranteed to be globally unique and unchanging. By default, the name of a multipath device is set to its WWID

##### Configuration of Multipath

The configuration of the multipath service is being done on each host and it is the user responsibility to configure it at multipath.conf
Some of the attributes being configured among many others are

*   path_selector algorithm which determines which path to use for every I/O operation to the storage (round-robin, queue length, service time)
*   path_grouping_policy - failover, multibus, group by
*   checker_timeout - The timeout to use for path checkers that issue SCSI commands with an explicit timeout, in seconds. The default value is taken from sys/block/sdx/device/timeout

##### Device-Mapper

The Device-Mapper is a Linux kernel framework which used for mapping block devices onto higher-level virtual block devices. In the Linux kernel, the device-mapper is a generic framework to map one block device into another. Device mapper works by passing data from a virtual block device (provided by the device mapper itself) to another block device.

### Owner

*   Name:
*   Email:

### Current status

*   Merged to 3.4 branch

### Detailed Description

The iSCSI multipath is an entity managed under the Data Center.
At the moment the Data Center is attached with iSCSI storage, the user can configure the iSCSI bond with the appropriate networks.
The User can choose which networks the iSCSI multipath will be assembled from.
it can be empty, with no networks configured in it, or configured with one or more networks related to the Data Center.
Once the iSCSI multipath is configured with networks all the Hosts in the Data Center will connect to the iSCSI Storage Domain through this iSCSI bond the user configured.
The path selection for the connection to the iSCSI storage will be configured by the multipath.conf in each host.

### User Experience

For the user to start using the iSCSI bond, it will need to do the following:

1.  Add an iSCSI Storage to the Data Center
2.  Make sure the Data Center contains networks.
3.  Go to the Data Center main tab and choose the specific Data Center
4.  At the sub tab choose "iSCSI Bond"
5.  Press the "new" button to add a new iSCSI Bond
6.  Configure the networks you want to add to the new iSCSI Bond.

Once a new iSCSI bond is configured, The Hosts in the Data Center connects to the iSCSI storage using the networks configured in the bond.

### Comments and Discussion

*   Refer to [Talk: iSCSIMultiPath](Talk: iSCSIMultiPath)

<Category:Feature> <Category:Template>
