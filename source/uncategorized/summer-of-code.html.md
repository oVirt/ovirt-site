---
title: Summer of Code
authors: bproffitt, danken, fsimonce, mlipchuk, nsoffer
wiki_title: Summer of Code
wiki_revision_count: 20
wiki_last_updated: 2015-03-24
---

# Summer of Code

## Ideas for Google Summer of Code 2014

For more information about Google Summer of Code please refer to the official page[1](https://developers.google.com/open-source/soc/).

<iframe width="640" src="//youtube.com/embed/QVnN34YGz8s" frameborder="0" allowfullscreen="true"> </iframe>

### **Idea:** oVirt virtual disks advanced integration with libvirt

**Description:** oVirt is the KVM virtualization management application for large data centers. Today oVirt supports many advanced features and is looking to enhance these by fine grained control of virtual disk capabilities such as 'discard', 'eio' behavior, 'cache' type and more. These capabilities would be exposed through Rest API and web interfaces.

**Expected results:** It should be possible for the user to configure the mentioned advanced disk capabilities per storage, virtual machine and disk.

**Knowledge Prerequisite:** Python, libvirt/QEMU (bonus), Java/JBoss (bonus)

**Mentor:** Federico Simoncelli

### **Idea:** oVirt virt-sparsify integration

**Description:** When using virtualization, the ability to manage disk space is critical. One of the key components for achieving this is thin provisioning. However, once storage space has been allocated it is difficult to reclaim it after the virtual machine has no more need for it (e.g. user has deleted files). This project is about integrating oVirt with a utility called virt-sparsify that is able to reclaim such space and free up valuable resources.

**Expected results:** When the disk image is not in use it should be possible for the user to try and reclaim some unused space.

**Knowledge Prerequisite:** Python, libvirt/QEMU (bonus), Java/JBoss (bonus)

**Mentor:** Federico Simoncelli
