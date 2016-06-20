---
title: oVirt 3.5 release-management
category: release
authors: sandrobonazzola
wiki_category: Releases
wiki_title: OVirt 3.5 release-management
wiki_revision_count: 45
wiki_last_updated: 2014-11-05
---

# oVirt 3.5 release-management

## Timeline

*   General availability: **2014-10-17** (Fri)
    -   RC5 Build: **2014-10-09** (Thu)
    -   RC4 Build: **2014-10-02** (Thu)
    -   RC3 Build: **2014-09-24** (Wed)
    -   [oVirt 3.5 Third Test Day](OVirt_3.5_TestDay): **2014-09-17** (Wed)
    -   RC2 Build: **2014-09-11** (Thu)
    -   Build refresh: *' 2014-08-22*' (Fri)
    -   RC1 Build: *' 2014-08-05*' (Tue)
    -   [oVirt 3.5 Second Test Day](OVirt_3.5_TestDay): **2014-07-29** (Tue)
    -   Second Beta release: **2014-07-23** (Wed)
    -   [oVirt 3.5 First Test Day](OVirt_3.5_TestDay): **2014-07-01** (Tue)
    -   Branching - Beta release: **2014-06-30** (Mon)
    -   Feature freeze: **2014-06-15** (Sun)
    -   Second Alpha release: **2014-06-06** (Fri)
    -   Alpha release: **2014-05-20** (Tue)

**More details on test days, etc. to come in the next few weeks**

### Nightly Builds

Nightly builds are available from oVirt snapshots repositories:

[`http://resources.ovirt.org/pub/ovirt-3.5-snapshot-static/`](http://resources.ovirt.org/pub/ovirt-3.5-snapshot-static/)
[`http://resources.ovirt.org/pub/ovirt-3.5-snapshot/`](http://resources.ovirt.org/pub/ovirt-3.5-snapshot/)

## Features Status Table

To try and improve 3.5 planning over the wiki approach in 3.3, this google doc <http://goo.gl/4SuYdE> has been created.

## Tracker Bug

*   - Tracker: oVirt 3.5 release

## Release Criteria

### General

*   All sources must be available on ovirt.org

### MUST

*   **MUST**: No blockers on the lower level components - libvirt, lvm,device-mapper,qemu-kvm, Jboss, postgres, iscsi-initiator
    -   **Current blocker list:**
    -   ...
*   **MUST**: All image related operations work - copy, move, import, export, snapshot (vm and template)
*   **MUST**: Ovirt/host installation should work flawlessly (w/o SSL)
*   **MUST**: Fully operational flow (define DC hierarchy so you can run vm) with GUI/CLI/Python-API/REST-API
*   **MUST**: vm life-cycle is working flawlessly (start,suspend,resume,stop,migrate)
*   **MUST**: Upgrade from previous release
    -   **Features/bug list:**
    -   ...
*   **MUST**: ovirt-node full cycle (register, approve and running VM, reboot and verify things still work)
    -   See [Node test procedure](Node test procedure)
*   **MUST**: No known data corruptors
    -   **Current list of data corruptors:**
    -   ...
*   **MUST**: Can define NFS, iSCSI, FC and local based storage domains
    -   See [storage test procedure](storage test procedure)
*   **MUST**: Can define VLAN based networks, bond interfaces, and have VLANs over bonded interfaces
*   **MUST**: Can authenticate users against at least one external LDAP server
*   **MUST**: Can run multiple VMs
*   **MUST**: Can connect to VMs using SPICE
*   **MUST**: VM watchdog support
*   **MUST**: Predictable host timeouts for HA fencing
*   **MUST**: MoM integration- KSM verification
*   **MUST**: Have Release Notes with feature specific information
*   **MUST**: Have updated quick start guide available
*   **MUST**: No regressions from 3.4 Release
*   **MUST**: Have release announcement for front page of ovirt.org and for mailing lists

### SHOULD

*   **SHOULD**: Can run full cycle with gluster storage
*   **SHOULD**: have updated installation guide available
*   **SHOULD**: Scheduling API.
*   **SHOULD**: MoM integration- ballooning.
*   **SHOULD**: Alerts when balloon not supported by guest
*   **SHOULD**: (scheduling API first) VM affinity
*   **SHOULD**: (scheduling API first) VM not getting minimum guaranteed memory

## Alpha Release Criteria

### General

*   All sources must be available on ovirt.org

### MUST

*   It must be possible to install oVirt Engine on a clean host for supported OS
*   It must be possible to run a VM on one host with supported OS

<Category:Releases> [Category:Release management](Category:Release management)
