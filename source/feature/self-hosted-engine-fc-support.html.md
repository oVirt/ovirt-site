---
title: Self Hosted Engine FC Support
category: feature
authors: sandrobonazzola, stirabos
wiki_category: Feature|Self Hosted Engine FC Support
wiki_title: Features/Self Hosted Engine FC Support
wiki_revision_count: 22
wiki_last_updated: 2015-05-06
feature_name: Self Hosted Engine FC Support
feature_modules: ovirt-hosted-engine-setup
feature_status: design
---

# Self Hosted Engine FC Support

### Summary

This feature enable the user to use FC storage for Hosted Engine data domain.

### Owner

*   Name: [ Simone Tiraboschi](User:Stirabos)
*   Email: <stirabos@redhat.com>

### Detailed Description

##### UX changes

Using an existing FC storage:

tbd

##### Config files changes

tbd

##### VDSM commands involved

tbd

The rest is quite similar to NFS storage.

### Benefit to oVirt

Users will be able to use FC storage as data domain for Hosted Engine.

### Dependencies / Related Features

*   A tracker bug has been created for tracking issues:

### Documentation / External references

#### Development environment

The feature can be developed and tested in a simplified environment without the need of a real SAN using FCoE in VN2VN mode (FCoE Direct End-Node to End-Node) on a nested environment.

##### Prerequisites

Two virtual machine with two VirtIO network adapter for each node. The first one (eth0) will be used for generic network traffic, the second one (eth1) will be dedicated to FCoE. The first virtual machine will be used to export a block device as a virtual SAN, the second one will connect to it and it will be used for hosted-engine.

On both the hosts, install the required FCoE utilities:

      yum install lldpad fcoe-utils

###### virtIO issue

libhbalinux currently doesn't detect correctly a VirtIO interface cause it scans the system using sysfs to look for PCI adapter. A recent patch [1] uses libudev instead of a direct scan of sysfs and so it than works also with VirtIO devices. The patch hasn't still been merged and so it should manually be applied to libhbalinux than libhbalinux , libHBAAPI and fcoe-utils should be rebuilt. [1] <http://lists.open-fcoe.org/pipermail/fcoe-devel/2014-October/012358.html> After that fcoe-utils seams to correctly work also on VirtIO interfaces.

Activate eth1 interface, don't assign any ipadress to it

      ifconfig eth1 up

Create FCoE interface

      fcoeadm -m vn2vn -c eth1

Just being a test environment for development purposes DCB is not really needed so no really need to customize /etc/fcoe/cfg-eth1 and start lldpad.

Check the result

      [root@f20t2 ~]# fcoeadm -i
          Description:      Virtio network device
          Revision:         00
          Manufacturer:     Red Hat, Inc
          Serial Number:    Unknown
          Driver:           Unknown 1
          Number of Ports:  1
              Symbolic Name:     fcoe v0.1 over eth1
              OS Device Name:    host3
              Node Name:         0x1000001A4A4FBD29
              Port Name:         0x2000001A4A4FBD29
              FabricName:        0x0000000000000000
              Speed:             Unknown
              Supported Speed:   Unknown
              MaxFrameSize:      1452
              FC-ID (Port ID):   0x00BD29
              State:             Online

The interface should be Online

The same on the second host:

      [root@f20t3 ~]# ifconfig eth1 up
      [root@f20t3 ~]# fcoeadm -m vn2vn -c eth1
      [root@f20t3 ~]#  fcoeadm -i
          Description:      Virtio network device
          Revision:         00
          Manufacturer:     Red Hat, Inc
          Serial Number:    Unknown
          Driver:           Unknown 1
          Number of Ports:  1
              Symbolic Name:     fcoe v0.1 over eth1
              OS Device Name:    host3
              Node Name:         0x1000001A4A4FBD2B
              Port Name:         0x2000001A4A4FBD2B
              FabricName:        0x0000000000000000
              Speed:             Unknown
              Supported Speed:   Unknown
              MaxFrameSize:      1452
              FC-ID (Port ID):   0x00BD2B
              State:             Online

##### Prerequisites

### Testing

Test plan still to be created

### Contingency Plan

Currently all the changes required for this feature are in a single patch. If it won't be ready it won't be merged.

### Release Notes

      ==Self Hosted Engine FC Support==
`Hosted Engine has now added support for `[`FC` `storage`](Features/Self_Hosted_Engine_FC_Support)

### Comments and Discussion

*   Refer to [Talk:Self Hosted Engine FC Support](Talk:Self Hosted Engine FC Support)

[Self Hosted Engine FC Support](Category:Feature) [Self Hosted Engine FC Support](Category:oVirt 3.6 Proposed Feature)
