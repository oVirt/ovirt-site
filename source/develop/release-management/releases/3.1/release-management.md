---
title: oVirt 3.1 release management
category: release
authors:
  - dneary
  - mburns
  - mgoldboi
  - oschreib
  - quaid
  - ykaul
---

# oVirt 3.1 release management

## Second Release

**Version 3.1**

### Timeline

*   General Availability **2012-Aug-08**.
    -   Release Candidate **2012-Aug-01**.
    -   Test Day **2012-Jun-14**.
    -   Feature Freeze (Branching day) **2012-Jun-07**.

### Release Criteria (WORK IN PROGRESS)

#### General

*   All sources must be available on ovirt.org

#### MUST

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

#### SHOULD

*   **SHOULD**:

### Gaps

### Open issues

