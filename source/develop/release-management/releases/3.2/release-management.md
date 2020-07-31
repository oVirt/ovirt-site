---
title: oVirt 3.2 release-management
category: release
authors: aglitke, alonbl, amureini, danken, dneary, doron, fabiand, jboggs, liran.zelkha,
  lpeer, mburns, mkolesni, tjelinek, vbellur
---

# oVirt 3.2 release-management

## Timeline

*   General availability: **2013-02-14**
    -   Beta release: **2013-01-24**
    -   Feature freeze: **2013-01-14**
    -   Test Day: **2013-01-29**

## Tracker Bug

*   [Tracker - 881006](https://bugzilla.redhat.com/show_bug.cgi?id=881006)

## Release Criteria

Tracker bug: <https://bugzilla.redhat.com/881006>

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
*   **MUST**: Have Release Notes with feature specific information
*   **MUST**: Have updated quick start guide available
*   **MUST**: No regressions from 3.1 Release

### SHOULD

*   **SHOULD**: Can run full cycle with gluster storage
*   **SHOULD**: have updated installation guide available

## Features

Features being considered for inclusion/already in master:

*   Primarily a bug fix release (list of bugs would be useful)
*   Engine
    -   UI plugins
    -   [Make network a main tab](/develop/release-management/features/network/networkmaintab.html) - stretch goal for 3.2
    -   [Import of existing gluster clusters](/develop/release-management/features/gluster/gluster-import-existing-cluster.html)
    -   [Bootstrap improvements](/develop/release-management/features/infra/bootstrap-improvements.html)
    -   [PKI improvments](/develop/release-management/features/infra/pki-improvements.html)
    -   [SLA is a target for inclusion (MOM)](/develop/release-management/features/sla/sla-mom.html)
    -   [Improving Quota for 3.2](/develop/release-management/features/sla/quota-3.2.html)
    -   [Integrate smartcard support](/develop/release-management/features/virt/smartcard-support.html)
    -   [Display Address Override](/develop/release-management/features/virt/display-address-override.html)
    -   VM creation base on pre-defined profiles (instance types)
    -   [libvdsm preview](/develop/release-management/features/vdsm/libvdsm.html)
    -   [Storage live migration](/develop/release-management/features/storage/storagelivemigration.html) on multiple disks
    -   Sync network
    -   [nwfilter](/develop/release-management/features/network/networkfiltering.html)
    -   webadmin: allow column resizing & sorting in grid (bz 767924)
    -   [port mirroring](/develop/release-management/features/network/portmirroring.html)
    -   user level api
    -   automatic storage domain upgrade
    -   Japanese localization
    -   [Unidirectional Gluster Geo-replication support](/develop/release-management/features/gluster/gluster-geo-replication.html)
    -   [Support for asynchronous Gluster volume tasks](/develop/release-management/features/gluster/gluster-volume-asynchronous-tasks-management.html)
    -   [Gluster Volume Performance Statistics](/develop/release-management/features/gluster/gluster-volume-performance-statistics.html)
    -   [Configuration sync with Gluster CLI](/develop/release-management/features/gluster/gluster-sync-configuration-with-cli.html)
    -   [Monitoring Gluster Volumes and Bricks](/develop/release-management/features/gluster/glustervolumeadvanceddetails.html)
    -   [Performance and Scalability](/develop/release-management/features/sla/performance-and-scalability.html)
*   Node
    -   TUI redesign
    -   [Node automation](/develop/release-management/features/node/nodeautomation.html) work -- refactor git repo to make standard python tools work
    -   [glusterfs client support](/develop/release-management/features/node/glusterfs-support.html)
    -   Full plugin support
