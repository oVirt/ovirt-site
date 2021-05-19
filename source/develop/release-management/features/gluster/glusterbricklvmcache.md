---
title: LVMCache configuration for gluster brick provisioning
category: feature
authors: dchaplyg, sabose
---

# LVMCache configuration for gluster brick provisioning

## Summary

This feature is about allowing the user to configure lvmcache on gluster bricks for better performance incase the server has SSDs or faster devices.

## Owner

*   Name: [Denis Chaplygin](https://github.com/akashihi)

## Current status

*   Target Release: 4.2
*   Status: Planning
*   Last updated: February 01, 2018


## Detailed Description

Gluster bricks are directories on the server with a local filesystem that supports extended attributes. While provisiong bricks from oVirt engine, an xfs filesystem is created on logical volumes as per best practices. While creating bricks on SSD devices would be ideal for performance, this is often not practical due to cost factors. In such cases, on servers that have smaller SSD devices, an [lvmcache](http://man7.org/linux/man-pages/man7/lvmcache.7.html) can be used to improve the performance of the slower LV housing the gluster bricks.

Currently gluster brick pirovisioning from engine is limited to a single brick created from one or more storage device(s). [This flow](glusterhostdiskmanagement.html) uses python-blivet APIs to configure LVM on the node and create a brick mount point. There's already a feature planned to make this more flexible [Support for multiple GlusterFS bricks on a block device(s)](gluster-multiple-bricks-per-storage.html). The idea is to move away from using python-blivet in favour of Ansible playbooks for brick provisioning.

## Proposed User Flow

### Changes to brick creation flow

Add an option to configure and select a device to be used as lvmcache

![](/images/wiki/CreateBrickChanges.png)


## Implementation Details


### Change to StorageDevice entity

StorageDevice entity will have the following additional properties

*   cacheDevicePath
*   cacheDeviceType (-if this is returned from vdsm)
*   cacheSize
*   cacheMode

Table storage_device will have the corresponding additional columns.


### Change to CreateBrickCommand

The CreateBrickCommand will be changed to execute an Ansible playbook based on the parameters passed. The playbook will create LV, cache LV and mount the brick.

Ansible playbook will internally use gdeploy to run the brick creation. (? till gluster ansible modules are available - otherwise we could add dependency on gdeploy to provide the gluster ansible modules)

### Change to REST API

There is no REST API available to create brick based on storage devices of host. These APIs need to be added.

New API:

      PUT /clusters/{cluster:id}/hosts/{host:id}/brickdevices/add


