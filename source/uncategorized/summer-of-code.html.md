---
title: Summer of Code
authors: bproffitt, danken, fsimonce, mlipchuk, nsoffer
wiki_title: Summer of Code
wiki_revision_count: 20
wiki_last_updated: 2015-03-24
---

# Summer of Code

__FORCETOC__

For more information about Google Summer of Code please refer to the official page[1](https://developers.google.com/open-source/soc/).

## Google Summer of Code Video Introduction

<iframe width="640" src="//youtube.com/embed/QVnN34YGz8s" frameborder="0" allowfullscreen="true"> </iframe>

## Ideas for Google Summer of Code 2014

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

### **Idea:** oVirt unify rpc solutions

**Description:** ovirt-engine uses XMLRPC or JSONRPC for communicating with VDSM. The JSONRPC server is using JSON schema for bridging between rpc calls and existing API classes. However, the bridge is not used to bridge the XMLRPC calls to the API, resulting in duplicate code and documentaion, and never ending synchronization between the different rpc solutions. This project is about unifing the rpc solutions so all of them will use the bridge and the schema, and duplication and manual synching is avoided.

**Expected results:** All rpc calls should use the bridge, and documentation and input and output types apear once and only once.

**Knowledge Prerequisite:** Python

**Mentor:** Nir Soffer

### **Idea:** Gerrit add potential reviewers

**Description:** In the open source world, when a contributor want to contribute a code to a project, he/she must gets the acknowledgement of the project maintainers for your code.
Most of the time, the review process is being done by gerrit, a web based code review and project management for Git based projects.
When the contributor submit the patch in Gerrit, he/she should add reviewers so the review process will take place, but sometimes the contributor can't be sure which reviewers will be best to add for the patch.
The contributor will sometime use the blame function to check which contributor changed most of the module recently, or any other method he thinks will be best.
The proposed project is to add to the git-review, a command-line tool for Git, an option for adding a potential reviewers to the contributor's patch.
After the contributor will submit his patch, he can use the git-review to add a potential reviewers by a specific method he will choose (blame on changed code, blame on module...)

**Expected results:** The user will add the potential reviewers he will think will be best to review his patch.

**Knowledge Prerequisite:** Python, git-review, git, gerrit

**Mentor:** Maor Lipchuk
