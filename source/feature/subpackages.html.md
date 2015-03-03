---
title: subpackages
category: feature
authors: dougsland
wiki_category: Feature
wiki_title: Features/Node/subpackages
wiki_revision_count: 10
wiki_last_updated: 2015-03-06
feature_name: subpackages
feature_modules: node
feature_status: Patch Pending Review
---

# subpackages

## oVirt Node subpackages

### Summary

This feature split all sources of oVirt Node into subpackages instead one big rpm.

### Owner

*   Name: [ Douglas Schilling Landgraf](User:dougsland)

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

Build ovirt node project and it should generate the following rpms: ovirt-node-plugin-snmp-logic, ovirt-node-plugin-cim-logic, ovirt-node-lib, ovirt-node-lib-config, ovirt-node- cli-tools, ovirt-node-tui-installer, ovirt-node-tui-setup, ovirt-node-lib-legacy. In the end, you could install the 'core' of ovirt-node, like: ovirt-node-lib and ovirt-node-lib-config without the tui subpackages.

### Documentation / External references

<https://gerrit.ovirt.org/#/c/38295/7> <https://bugzilla.redhat.com/show_bug.cgi?id=1191419>

### Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

<Category:Feature> <Category:Node>
