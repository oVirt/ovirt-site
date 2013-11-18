---
title: Hot plug cpu
category: feature
authors: adahms, roy, sven
wiki_category: Feature
wiki_title: Hot plug cpu
wiki_revision_count: 33
wiki_last_updated: 2015-02-04
---

# Hot plug cpu

### Summary

This feature will allow to hot plug cpus to a running VM from ovirt engine UI and REST api.

### Owner

*   Name: [ Roy Golan](User:MyUser)
*   Email: rgolan@redhat.com

### Current status

*   1st draft of wiki and VDSM code
*   Last updated: ,

### Detailed Description

Historically, CPU and memory hot add and remove capabilities were thought of as server hardware RAS features. However, the concepts of CPU and memory hot add and remove are both common and necessary for Virtualized environments. Virtual CPUs and virtual memory assigned to a virtual machine (VM) need to be be added or removed from a running guest in order to meet either the workload's demands or to maintain the SLA associated with the workload. It is also desired for the rapid reconfiguration of a guest once a workload has been completed or migrated and an administrator wants to reconfigure the VM without having to re-boot the VM.

### Benefit to oVirt

this feature will enable this powerful use cases:

*   allow admins the ability to ensure customer's SLA are being met
*   allow utilizing spare hardware - its common to see systems overdimentioned x3 for an average max load
*   allow dynamically to scale vertically, down or up, a system hardware according to needs \*without restarting\* the VM

### Dependencies / Related Features

KVM support for hot plug libvirt support for hotattach device

### Documentation / External references

OS support matrix for hot add/remove CPU - TODO

### Testing

TODO

### Comments and Discussion

*   Refer to [Talk:Hot plug cpu](Talk:Hot plug cpu)

<Category:Feature> <Category:Template>
