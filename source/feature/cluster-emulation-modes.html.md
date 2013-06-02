---
title: Cluster emulation modes
category: feature
authors: ofrenkel, roy, sandrobonazzola
wiki_category: Feature
wiki_title: Cluster emulation modes
wiki_revision_count: 16
wiki_last_updated: 2014-12-15
---

# Cluster emulation mode

### Summary

This feature will enable per cluster emulation mode. EmulatedMachine is a property passed to QEMU as -M flag and Instead of a system-wide config value
 a cluster could have a specific value which all host must comply to. If the cluster has no value set, the first host that is active
must comply to a configurable list of values and then set it thereafter.

### Owner

*   Name: [ Roy Golan](User:rgolan)
*   Email: <rgolan@redhat.com>

### Current status

*   Draft Design
*   Last updated: ,
*   Target Release: 3.3

### Detailed Description

We want to keep the cluster homogeneous but be able to have different types cross-cluster i.e one cluster to be RHELs and another to be Fedora based.
to achieve that we need a config value, per version with a list of supported emulation types, order by priority:

#### new Config value

ClusterEmulationModes(3.0,"rhel6.2.0, pc-1.0") ClusterEmulationModes(3.1,"rhel6.3.0, pc-1.0") ClusterEmulationModes(3.2,"rhel6.4.0, pc-1.0") ClusterEmulationModes(3.3,"rhel6.4.0, pc-1.0")

==== New Host emulated

#### Cluster field

A cluster entity will be added by a new field - emulatedMachine.
The default is NULL which means the value would be set once a host during the first refresh would have
its reported emulatedMachines list match against the Config Value
 consider this pseudo-code:

      if cluster.emulationMode == NULL
       for val in Config.ClusterEmulationMode(3.3)
          if HOST.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
