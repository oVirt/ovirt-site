---
title: NIC Bonding
category: feature
authors: fabiand
wiki_category: Feature
wiki_title: Features/Node/NIC Bonding
wiki_revision_count: 7
wiki_last_updated: 2013-09-09
---

# NIC Bonding

### Summary

This feature will allow Node to create NIC bonds, either through the UI or using kernel arguments.

### Owner

*   Name: [ Fabian Deutsch](User:fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

### Current status

*   Status: **In Progress**
*   Last updated: ,

### Detailed Description

Node will honors dracut's bonding syntax and will create (and persist) bonds accordingly. The syntax is:

    bond=<bondname>[:<bondslaves>:[:<options>]]

This syntax will be represented in three new config keys:

    OVIRT_BOND_NAME
    OVIRT_BOND_SLAVES
    OVIRT_BOND_OPTIONS

The created bond device can then be modified like any other device (e.g. a VLAN can be assigned)

### Benefit to oVirt

Just another step in offering some enhanced networking stuff in Node.

### Dependencies / Related Features

*   Affected Packages
    -   ovirt-node
    -   vdsm (possibly)

### Testing

Cover all methods for creating and removing bonds.

| Test         | Steps                                                                | Expected Result                                                 | Status | Version |
|--------------|----------------------------------------------------------------------|-----------------------------------------------------------------|--------|---------|
| Auto-install | Create a bond using `bond=bond0:eth1,eth2 BOOTIF=bond0 storage_init` | bond0 device is created, persisted and used during auto-install |        |         |

### Documentation / External references

*   <https://bugzilla.redhat.com/show_bug.cgi?id=831318>

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Urwid TUI](Talk:Urwid TUI)

<Category:Feature> <Category:Template> <Category:Node>
