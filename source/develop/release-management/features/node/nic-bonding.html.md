---
title: NIC Bonding
category: feature
authors: fabiand
---

# NIC Bonding

## Summary

This feature will allow Node to create NIC bonds, either through the UI or using kernel arguments.

## Owner

*   Name: Fabian Deutsch (fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

## Current status

*   Status: **Done**
*   Last updated: ,

## Detailed Description

Node will honors dracut's bonding syntax and will create (and persist) bonds accordingly. The syntax is:

    bond=<bondname>[:<bondslaves>:[:<options>]]

This syntax will be represented in three new config keys:

    OVIRT_BOND_NAME
    OVIRT_BOND_SLAVES
    OVIRT_BOND_OPTIONS

The created bond device can then be modified like any other device (e.g. a VLAN can be assigned)

The introduction of bonds opens up a wider range of network configruations which can be setup using the setup UI, e.g.:

    direct layout
    -------------
    bond0     slaves=ens1, ens2
    bond0.42  slaves=ens1, ens2

    bridged layout
    --------------
    brbond0   bridge-slave=bond0
    brbond0   bridge-slave=bond0.42

## Benefit to oVirt

Just another step in offering some enhanced networking stuff in Node.

## Dependencies / Related Features

*   Affected Packages
    -   ovirt-node
    -   vdsm (possibly)

## Testing

Cover all methods for creating and removing bonds.

| Test                              | Steps                                                                                                                | Expected Result                                                                    | Status | Version |
|-----------------------------------|----------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|--------|---------|
| Auto-install                      | Create a bond using `bond=bond0:eth1,eth2 BOOTIF=bond0 storage_init`                                                 | bond0 device is created, persisted and used during auto-install.                   |        |         |
| Auto-install with vlan            | Create a bond with vlan using `bond=bond0:eth1,eth2 vlan=42 BOOTIF=bond0 storage_init`                               | bond0 and vlan devices are created, persisted and used during auto-install         |        |         |
| Auto-install with bridge          | Create a bond and bridge using `bond=bond0:eth1,eth2 network_layout=bridged BOOTIF=bond0 storage_init`               | bond0 and bridge devices are created, persisted and used during auto-install       |        |         |
| Auto-install with bridge and vlan | Create a bond, bridge and vlan using `bond=bond0:eth1,eth2 network_layout=bridged vlan=42 BOOTIF=bond0 storage_init` | bond0, bridge and vlan devices are created, persisted and used during auto-install |        |         |

## Documentation / External references

*   <https://bugzilla.redhat.com/show_bug.cgi?id=831318>




