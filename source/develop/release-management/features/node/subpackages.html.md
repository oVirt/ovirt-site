---
title: subpackages
category: feature
authors: dougsland
feature_name: subpackages
feature_modules: node
feature_status: Merged/Done
---

# subpackages

## oVirt Node subpackages

### Summary

This feature split all sources of oVirt Node into subpackages instead one big rpm.

### Owner

*   Name: Douglas Schilling Landgraf (dougsland)

<!-- -->

*   Email: dougsland AT redhat DOT com
*   IRC: dougsland

### Detailed Description

The goal is install only packages needed to integrate oVirt Node with others project like Cockpit (for example).

### Benefit to oVirt

As all source will be splitted by RPM, we could drop the current TUI code and add the dependecy to cockpit as default interface to users.

### Dependencies / Related Features

[ `Cockpit`](Features/Node/Cockpit)`.`

### Testing

The ovirt-node project will generate the bellow rpms and the ovirt-node-lib and ovirt-node-lib-config (the 'core' of ovirt-node) must be installed **without** the dependency of **ovirt-node-tui-installer** and **ovirt-node-tui-setup**.

*   ovirt-node-plugin-snmp-logic
*   ovirt-node-plugin-cim-logic
*   ovirt-node-lib
*   ovirt-node-lib-config
*   ovirt-node- cli-tools
*   ovirt-node-tui-installer
*   ovirt-node-tui-setup
*   ovirt-node-lib-legacy

**Example of testing**:

*   Install CentOS6
*   Downloaded the new ovirt-node packages (listed above) to EL6 platform
*   Install ovirt-node-lib and ovirt-node-lib-config and via yum and their depedency (no need any tui package)

### Documentation / External references

<https://gerrit.ovirt.org/#/c/38295/7> <https://bugzilla.redhat.com/show_bug.cgi?id=1191419>

### Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

