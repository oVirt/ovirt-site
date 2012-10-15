---
title: OVirt 3.2 release-management
category: release
authors: aglitke, alonbl, amureini, danken, dneary, doron, fabiand, jboggs, liran.zelkha,
  lpeer, mburns, mkolesni, tjelinek, vbellur
wiki_category: Releases
wiki_title: OVirt 3.2 release-management
wiki_revision_count: 39
wiki_last_updated: 2013-06-04
---

# OVirt 3.2 release-management

## Timeline

*   General availability: **December 12th**
    -   Beta release: **November 14th**
    -   Feature freeze: **November 14th**
    -   Test Day: **November 19th**

## Release Criteria (DRAFT)

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
    -   [ Make network a main tab](Feature/NetworkMainTab)
    -   [ Import of existing gluster clusters](Features/Gluster Import Existing Cluster)
    -   Bootstrap improvements
    -   [ SLA is a target for inclusion (MOM)](SLA-mom)
    -   CAC support in user portal for spice
    -   VM creation base on pre-defined profiles (instance types)
    -   libvdsm preview
    -   Storage live migration (needs to be checked)
    -   [ Sync network](SetupNetworks_SyncNetworks)
    -   [ nwfilter](Features/Design/Network/NetworkFiltering)
    -   webadmin: allow column resizing & sorting in grid (bz 767924)
    -   [ port mirroring](Features/PortMirroring)
    -   user level api
    -   automatic storage domain upgrade
    -   Japanese localization
*   Node
    -   TUI redesign
        -   make it easier for plugins to be designed/written
        -   make it work in resolution other than 80x20
        -   (possibly) add mouse support
    -   automation work -- refactor git repo to make standard python tools work
    -   glusterfs client support
    -   full plugin support including example plugins (snmp, cim)
    -   general stability/cleanup

<Category:Releases> [Category:Release management](Category:Release management)
