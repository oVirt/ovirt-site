---
title: oVirt 3.4 release management
category: release
authors:
  - bproffitt
  - danken
  - sandrobonazzola
---

# oVirt 3.4 release management

## Timeline

*' These are tentative planning dates and may change*'

*   General availability: **2014-03-27**
    -   RC2 Build: **\1**
    -   oVirt 3.4 Third Test Day **\1**
    -   RC Build: **\1**
    -   Beta 3 release: **\1**
    -   oVirt 3.4 Second Test Day **\1**
    -   Beta 2 release: **2014-02-07**
    -   oVirt 3.4 Test Day **\1**
    -   Beta release: **2014-01-22**
    -   Branching / Feature freeze: **2014-01-15**
    -   Alpha release: **2014-01-09**

## Tracker Bug

*   [Tracker - 1024889](https://bugzilla.redhat.com/show_bug.cgi?id=1024889)

## Release Criteria (WIP)

### General

*   All sources must be available on ovirt.org

### MUST

*   **MUST**: No blockers on the lower level components - libvirt, lvm,device-mapper,qemu-kvm, Jboss, postgres, iscsi-initiator
*   **MUST**: All image related operations work - copy, move, import, export, snapshot (vm and template)
*   **MUST**: Ovirt/host installation should work flawlessly (w/o SSL)
*   **MUST**: Fully operational flow (define DC hierarchy so you can run vm) with GUI/CLI/Python-API/REST-API
*   **MUST**: vm life-cycle is working flawlessly (start,suspend,resume,stop,migrate)
*   **MUST**: Upgrade from previous release
*   **MUST**: ovirt-node full cycle (register, approve and running VM, reboot and verify things still work)
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
*   **MUST**: No regressions from 3.3 Release
*   **MUST**: Have release announcement for front page of ovirt.org and for mailing lists

### SHOULD

*   **SHOULD**: Can run full cycle with gluster storage
*   **SHOULD**: have updated installation guide available
*   **SHOULD**: Scheduling API.
*   **SHOULD**: MoM integration- ballooning.
*   **SHOULD**: Alerts when balloon not supported by guest
*   **SHOULD**: (scheduling API first) VM affinity
*   **SHOULD**: (scheduling API first) VM not getting minimum guaranteed memory

