---
title: Hosted Engine configuration on shared storage
category: feature
authors: sandrobonazzola
wiki_category: Feature|Hosted Engine configuration on shared storage
wiki_title: Features/Hosted Engine configuration on shared storage
wiki_revision_count: 1
wiki_last_updated: 2015-04-15
feature_name: Hosted Engine configuration on shared storage
feature_modules: all
feature_status: QA
---

# Hosted Engine configuration on shared storage

### Summary

Move Hosted Engine configuration to shared storage

### Owner

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

### Detailed Description

*   Move the VM configuration from vm.conf to an ovf stored in OVF_STORE image
*   Move broker.conf to shared storage (maybe within OVF_STORE image too
*   An upgrade path must move the existing configuration to shared storage

### Benefit to oVirt

*   Will allow to deploy additional hosts from Web UI more easily.
*   Will allow to avoid to manually copy configuration changes to all the host in the hosted engine cluster

### Dependencies / Related Features

*   ovirt-hosted-engine-setup and ovirt-hosted-engine-ha must be adapted to the new configuration location
*   ovirt-engine must be adapted to be aware of the OVF_STORE changes
*   A tracker bug has been created for tracking issues:

### Documentation / External references

<tbd>

### Testing

<tbd>

### Contingency Plan

*   The configuration will still remain on the hosts and related patches will be reverted.

### Release Notes

      == Hosted Engine ==
      Hosted Engine configuration has been moved to its shared storage allowing to centralize any configuration change without the need of manually copy the configuration to all the hosts in its cluster.

### Comments and Discussion

*   Refer to [Talk:Hosted Engine configuration on shared storage](Talk:Hosted Engine configuration on shared storage)

[Hosted Engine configuration on shared storage](Category:Feature) [Hosted Engine configuration on shared storage](Category:oVirt 3.6 Proposed Feature) [Hosted Engine configuration on shared storage](Category:oVirt 3.6 Feature) [Hosted Engine configuration on shared storage](Category:Integration)
