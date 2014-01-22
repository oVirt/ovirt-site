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

### A brief about multipath linux

[Device-Mapper](Feature/iSCSI-Multipath#Device-Mapper) Multipath (DM-Multipath) is a Linux native multipath tool, which allows to [configure](Feature/iSCSI-Multipath#Configuration_of_Multipath) multiple I/O paths between server nodes and storage arrays into a single device.
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

The iSCSI multipath Bond is an entity managed under the Data Center.
Once the Data Center has iSCSI storage attached to it, the user can configure an iSCSI bond with an appropriate networks.
The User choose which networks the iSCSI multipath Bond will be assembled from.
The iSCSI bond can be empty, with no networks configured in it, or it can be configured with one or more networks related to the Data Center.
Once the iSCSI multipath is configured with networks all the Hosts in the Data Center will connect to the iSCSI Storage Domain through this iSCSI bond the user configured.
The path selection for the connection to the iSCSI storage will be configured by the multipath.conf in each host.

### Permissions

Every user with permissions on the Data Center, can add/change or remove iSCSI Bond.

### iSCSI Bond behaviour

*   Each Data Center with iSCSI storage can have one or more iSCSI Bonds. The iSCSI bond is not obligated.
*   Each iSCSI bond can be configured with any of the networks configured in the Data Center. There is no obligation regarding the number of networks in an iSCSI Bond.
*   iSCSI Bond name should be a unique name in the Data Center.
*   Once a network is being removed from a Data Center it should be automatically removed from the iSCSI Bond
*   Once a Data Center is being removed all the iSCSI Bonds should be removed as well.
*   Once a network is being added to the iSCSI Bond, all the Hosts connected to the iSCSI storage which contains the added network should connect to the storage with the new network as well.
*   Once a Host gets activate in the iSCSI Data Center it should connect to the iSCSI storage with all the networks available in the iSCSI Bond
*   If the Host does not contain any of the networks configured in the iSCSI bond it should connect to the storage iSCSI with its default network
*   If the Host does contain the networks configured in the iSCSI bond and it does not succeed to connect to the iSCSI storage with them then the Host should become non operational.

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
