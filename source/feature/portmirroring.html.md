---
title: PortMirroring
category: feature
authors: moti, ovedo, shaharh
wiki_category: Feature
wiki_title: Features/PortMirroring
wiki_revision_count: 16
wiki_last_updated: 2012-11-19
---

# Port Mirroring

## Promiscuous Mode

### Summary

The purpose of the feature is to allow monitoring (mirroring and redirecting) network traffic to a specific VM

### Owner

*   Name: [ Shahar Havivi](User:Shaharh)
*   Email: <shavivi@redhat.com>

### Current status

*   vdsm patch sent (mirror mode only): <http://gerrit.ovirt.org/#change,956>
*   In progress of defining the requirements

### Detailed Description

this feature have two modes: mirror and redirect mirror mode is the ability to send all VMs traffic of a specific network to a single VM redirect is the ability to redirect all the traffic of VMs in a network to a single VM and it will decide to forward it or to a abort, common use case is a Firewall.

### Design Notes

engine: still need to figure the security validation for adding a promisc mode, currently engine have the ability to validate the security for a specific VM but not for a VM interface

### User work-flows

### Benefit to oVirt

### Documentation / External references

### Comments and Discussion

<Category:Feature> <Category:Template>
