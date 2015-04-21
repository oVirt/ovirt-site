---
title: Hosted engine VM management
category: feature
authors: roy, sandrobonazzola
wiki_category: Feature|Hosted engine VM management
wiki_title: Hosted engine VM management
wiki_revision_count: 18
wiki_last_updated: 2015-04-22
feature_name: Hosted engine VM management enhancements
feature_modules: api,engine,hosted-engine-setup,vdsm
feature_status: Design & research
---

# Hosted engine VM management enhancements

### Summary

Allow editing the Hosted engine VM, storage domain, disks, networks etc

### Owner

Roy Golan rgolan@redhat.com Sandro Bonazzola sbonazzo@redhat.com

### Detailed Description

Managing the hosted-engine engine VM is a non trivial taks and mostly manual today. if the engine Vm needs tuning, or some addition(add a device), one must reach all the hosted engine capable hosts and alter the local /etc/ovirt-hosted-engine/vm.conf instances. Although visible in the UI, the engine-VM have most of the provisioning actions blocked, as the VM is a external or foreign VM to the setup, as we don't manage its Storage Domains, Disks, Data-Center and Networks.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in case the feature won't be ready on time

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
