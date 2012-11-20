---
title: Trusted compute pools
category: feature
authors: dave chen, gwei3, lhornyak
wiki_category: Feature
wiki_title: Trusted compute pools
wiki_revision_count: 56
wiki_last_updated: 2013-10-11
---

# Trusted Compute Pools

### Summary

Trusted Compute Pools provide a way for Administrator to deploy VMs on trusted hosts.

### Owner

*   Name: [ Gang Wei](User:gwei3)

<!-- -->

*   Email: <gang.wei@intel.com>

### Current status

*   Still in design phase
*   Last updated date: Nov 20, 2012

### Detailed Description

The feature will allow data center administrator to build trusted computing pools based on H/W-based security features, such as Intel Trusted Execution Technology (TXT). Combining attestation done by a separate entity (i.e. "remote attestation"), the administrator can ensure that verified measurement of software be running in hosts, thus they can establish the foundation for the secure enterprise stack. Such remote attestation services can be developed by using SDK provided by OpenAttestation project.

Remote Attestation server performs host verification through following steps:

1. Hosts boot with Intel TXT technology enabled

2. The hosts' BIOS, hypervisor and OS are measured

3. These measured data is sent to Attestation server when challenged by attestation server

4. Attestation server verifies those measurements against good/known database to determine hosts' trustworthiness

### Benefit to oVirt

This is a new feature, it will bring higher security level for data center managed with oVirt.

### Dependencies / Related Features

None.

### Documentation / External references

*   <https://github.com/OpenAttestation/OpenAttestation.git>
*   <http://en.wikipedia.org/wiki/Trusted_Execution_Technology>

### Comments and Discussion

*   Refer to [Talk:Trusted compute pools](Talk:Trusted compute pools)

<Category:Feature>
