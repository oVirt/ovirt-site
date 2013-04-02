---
title: OVirt 3.3 release-management
category: release
authors: abonas, amuller, amureini, arik, awels, danken, derez, dneary, doron, dpkshetty,
  ecohen, emesika, fkobzik, fsimonce, gpadgett, knarra, laravot, lhornyak, lpeer,
  mburns, mgoldboi, michael pasternak, mkolesni, moti, mperina, mskrivan, netbulae,
  ofrenkel, ofri, oschreib, prasanth, roy, sahina, sandrobonazzola, sgotliv, tjelinek,
  vered, vszocs, yair zaslavsky, ybronhei
wiki_category: Releases
wiki_title: OVirt 3.3 release-management
wiki_revision_count: 220
wiki_last_updated: 2013-08-27
---

# OVirt 3.3 release-management

## Timeline

*' These are tentative planning dates and may change*'

*   General availability: **2013-07-01**
    -   Beta release: **2013-05-31**
    -   Feature freeze: **2013-05-31**
    -   Test Day: **2013-06-05**
    -   RC Build: **2013-06-14**

## Tracker Bug

*   [Tracker - 918494](https://bugzilla.redhat.com/show_bug.cgi?id=918494)

## Release Criteria

Tracker bug: <https://bugzilla.redhat.com/918494>

### General

*   All sources must be available on ovirt.org

### MUST

*   **MUST**: No blockers on the lower level components - libvirt, lvm,device-mapper,qemu-kvm, Jboss, postgres, iscsi-initiator
*   **MUST**: All image related operations work - copy, move, import, export, snapshot (vm and template)
*   **MUST**: Ovirt/host installation should work flawlessly (w/o SSL)
*   **MUST**: Fully operational flow (define DC hierarchy so you can run vm) with GUI/CLI/Python-API/REST-API
*   **MUST**: vm life-cycle is working flawlessly (start,suspend,resume,stop,migrate)
*   **MUST**: Upgrade from previous release
*   **MUST**: ovirt-node full cycle (register, approve and running VM)
*   **MUST**: No known data corruptors
*   **MUST**: Can define NFS, iSCSI, FC and local based storage domains
*   **MUST**: Can define VLAN based networks, bond interfaces, and have VLANs over bonded interfaces
*   **MUST**: Can authenticate users against at least one external LDAP server
*   **MUST**: Can run multiple VMs
*   **MUST**: Can connect to VMs using SPICE
*   **MUST**: VM watchdog support
*   **MUST**: Predictable host timeouts for HA fencing
*   **MUST**: MoM integration- KSM verification
*   **MUST**: Have Release Notes with feature specific information
*   **MUST**: Have updated quick start guide available
*   **MUST**: No regressions from 3.1 Release

### SHOULD

*   **SHOULD**: Can run full cycle with gluster storage
*   **SHOULD**: have updated installation guide available
*   **SHOULD**: Scheduling API.
*   **SHOULD**: MoM integration- ballooning.
*   **SHOULD**: Alerts when balloon not supported by guest
*   **SHOULD**: (scheduling API first) VM affinity
*   **SHOULD**: (scheduling API first) VM not getting minimum guaranteed memory

## Features

Features being considered for inclusion/already in master:

### Infra

*   [Features/Device Custom Properties](Features/Device Custom Properties)

### Networking

*   [Features/Migration Network](Features/Migration Network)
*   [Features/Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)
*   [Features/DirectHostAddress](Features/DirectHostAddress)
*   [Features/Quantum_Integration](Features/Quantum_Integration)
*   [Feature/NetworkReloaded](Feature/NetworkReloaded) reimplementation of configNetwork in vdsm. Should have zero (0) effect on users, but required for future support for ovs/NM
*   [Features/Multiple Gateways](Features/Multiple Gateways) configure more gateways on host, on top of the default one.
*   [Features/Device Custom Properties](Features/Device Custom Properties) per-device custom properties

<Category:Releases> [Category:Release management](Category:Release management)
