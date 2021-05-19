---
title: Editing Floating Disks
category: feature
authors: sleviim
---

# Editing Floating Disks

## Summary

Currently, editing disks is only applicable for VM disks.

This feature enables the user to edit a floating disk, and also to extend its size.

### Owner

*   Shani Leviim (<sleviim@redhat.com>)

### Detailed Description

Before this feature, only VM disks were editable (from 'VMs' -> 'Disk' sub-tab).
Therefore, for editing a disk, regardless of the required changed parameter (VM dependent or not), it first should be attached to a VM.

It is now possible editing disks from the 'Disks' tab, and also from the REST API, without prior attaching those disks to VMs, so they can remain floating.

### User Experience

A new 'Edit' button was added to the 'Disks' tab:

![](/images/wiki/edit-floating-disks-button.png)


Once the popup shows up, the user can edit the disk's non-VM
dependent parameters, (such as it's alias and description), and also to extend its size:

![](/images/wiki/edit-floating-image-disk.png)

### REST

A disk can be updated using the REST API.

In order to edit a disk, the following request should be sent:

```XML
PUT /ovirt-engine/api/disks/123
```

Each disk type has different characteristics that can be edited:

* For Image disks: ```provisioned_size, alias, description, wipe_after_delete, shareable, backup``` and ```disk_profile```.
* For LUN disks: ```alias, description``` and ```shareable```.
* For Cinder and Managed Block disks: ```provisioned_size, alias``` and ```description```.
* For VM attached disks, the ```qcow_version``` can also be edited.

For example, editing an image disk:

```XML
<disk>
  <alias>mydisk-new-alias</alias>
  <description>mydisk-new-desc</description>
  <shareable>true</shareable>
</disk>
```
