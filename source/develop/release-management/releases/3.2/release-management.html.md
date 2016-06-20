---
title: oVirt 3.2 release-management
category: release
authors: aglitke, alonbl, amureini, danken, dneary, doron, fabiand, jboggs, liran.zelkha,
  lpeer, mburns, mkolesni, tjelinek, vbellur
wiki_category: Releases
wiki_title: OVirt 3.2 release-management
wiki_revision_count: 39
wiki_last_updated: 2013-06-04
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
    -   [ UI plugins](Features/UIPlugins)
    -   [ Make network a main tab](Feature/NetworkMainTab) - stretch goal for 3.2
    -   [ Import of existing gluster clusters](Features/Gluster Import Existing Cluster)
    -   [Bootstrap improvements](Features/Bootstrap_Improvements)
    -   [PKI improvments](Features/PKI Improvements)
    -   [ SLA is a target for inclusion (MOM)](SLA-mom)
    -   [ Improving Quota for 3.2](Features/Quota-3.2)
    -   [ Integrate smartcard support](Features/Smartcard support)
    -   [ Display Address Override](Features/Display Address Override)
    -   VM creation base on pre-defined profiles (instance types)
    -   [ libvdsm preview](Features/libvdsm)
    -   [ Storage live migration](Features/Design/StorageLiveMigration) on multiple disks
    -   [ Sync network](SetupNetworks_SyncNetworks)
    -   [ nwfilter](Features/Design/Network/NetworkFiltering)
    -   webadmin: allow column resizing & sorting in grid (bz 767924)
    -   [ port mirroring](Features/PortMirroring)
    -   user level api
    -   automatic storage domain upgrade
    -   Japanese localization
    -   [ Unidirectional Gluster Geo-replication support](Features/Gluster_Geo_Replication)
    -   [ Support for asynchronous Gluster volume tasks](Features/Gluster_Volume_Asynchronous_Tasks_Management)
    -   [ Gluster Volume Performance Statistics](Features/Gluster_Volume_Performance_Statistics)
    -   [ Configuration sync with Gluster CLI](Features/Gluster_Sync_Configuration_With_CLI)
    -   [ Monitoring Gluster Volumes and Bricks](Features/GlusterVolumeAdvancedDetails)
    -   [ Performance and Scalability](Features/Performance_And_Scalability)
*   Node
    -   [ TUI redesign](Features/TUIredesign)
    -   [ Node automation](Features/NodeAutomation) work -- refactor git repo to make standard python tools work
    -   [ glusterfs client support](Node_Glusterfs_Support)
    -   [Full plugin support ](Features/Plugins) Including example plugins (snmp, cim)

<Category:Releases> [Category:Release management](Category:Release management)
