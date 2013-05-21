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
    -   **Current blocker list:**
    -   ...
*   **MUST**: All image related operations work - copy, move, import, export, snapshot (vm and template)
*   **MUST**: Ovirt/host installation should work flawlessly (w/o SSL)
*   **MUST**: Fully operational flow (define DC hierarchy so you can run vm) with GUI/CLI/Python-API/REST-API
*   **MUST**: vm life-cycle is working flawlessly (start,suspend,resume,stop,migrate)
*   **MUST**: Upgrade from previous release
    -   **Features/bug list:**
    -   [Features/Node_upgrade_tool](Features/Node_upgrade_tool) - Status:
    -   [Bug #916728: Upgrade from 3.1 to 3.2 fails](//bugzilla.redhat.com/show_bug.cgi?id=916728)
    -   [Bug #963275: Need upgrade process from 3.2 to 3.3](//bugzilla.redhat.com/show_bug.cgi?id=963275)
    -   ...
*   **MUST**: ovirt-node full cycle (register, approve and running VM)
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

### Virt

*   [Features/RAM Snapshots](Features/RAM Snapshots)
*   [Features/noVNC console](Features/noVNC console)
*   [Features/GlusterFS_Storage_Domain](Features/GlusterFS_Storage_Domain)

### Infra

*   [Features/Device Custom Properties](Features/Device Custom Properties)
*   [Features/ExternalTasks](Features/ExternalTasks)
*   [Features/Supervdsm_service](Features/Supervdsm_service): <http://gerrit.ovirt.org/#/c/11051/> - Tested, Waiting for reviews and comments

### Networking

*   [Features/Migration Network](Features/Migration Network)
*   [Features/Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)
*   [Features/Quantum_Integration](Features/Quantum_Integration)
*   [Feature/NetworkReloaded](Feature/NetworkReloaded) reimplementation of configNetwork in vdsm. Should have zero (0) effect on users, but required for future support for ovs/NM
*   [Features/Multiple Gateways](Features/Multiple Gateways) configure more gateways on host, on top of the default one.
*   [Features/Network Labels](Features/Network Labels)
*   [Features/Network Security Groups](Features/Network Security Groups)

### Storage

*   [Online Virtual Drive Resize](Features/Online_Virtual_Drive_Resize)
*   [Virtio-SCSI](Features/Virtio-SCSI)
*   [ Read Only Disks ](Features/Read_Only_Disk) (Work in Progress)
*   [Edit Connection Properties](Features/Edit_Connection_Properties)
*   Adding VDSM hook for hotplug a disk
*   Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability

### SLA & Scheduling

*   [Features/oVirt_scheduler](Features/oVirt_scheduler) Wrapping scheduling functionalities as a separate package
*   [Features/Scheduling_API](Features/Scheduling_API) (depends on [Features/oVirt_scheduler](Features/oVirt_scheduler)) exposing user-level scheduling API
*   [Features/Watchdog_engine_support](Features/Watchdog_engine_support)

### Gluster

*   [Features/Gluster Hooks Management](Features/Gluster Hooks Management) Managing gluster hooks from console
    -   Status : In Progress
    -   gerrit :
        -   <http://gerrit.ovirt.org/#/q/project:ovirt-engine+branch:master+topic:gluster-hooks,n,z>
        -   <http://gerrit.ovirt.org/#/c/14145>
*   [Features/Gluster Services Management](Features/Gluster Services Management) Reimplement services tab for gluster cluster. Allow start/stop of services.
    -   Status: In Progress
    -   gerrit:
        -   <http://gerrit.ovirt.org/#/c/11094/>
        -   <http://gerrit.ovirt.org/#/q/project:ovirt-engine+branch:master+topic:gluster-services,n,z>

### Node

*   [Universal Node Image](Features/Universal Image) make the ovirt-node image generic for use with non-oVirt Projects
*   [Node VDSM Plugin](Features/Node vdsm plugin) extract all vdsm and oVirt Engine specific code from ovirt-node into a plugin
*   oVirt Node works on a different asynchronous release schedule from the rest of oVirt.
    -   At the time of the oVirt 3.3 release, the current version of ovirt-node will be 3.0.0.
    -   Feature for oVirt node 3.0.0 can be found on the [oVirt Node 3.0.0 release page](Node_3.0_release-management)

### Integration

*   [Features/Otopi_Infra_Migration](Features/Otopi_Infra_Migration) A complete re-write of engine-setup, engine-cleanup, engine-upgrade and AIO plugin using otopi.
*   [Features/Self_Hosted_Engine](Features/Self_Hosted_Engine) The ability to run the Engine as a VM on the hosts that are managed by this Engine, in an HA configuration, when the Engine VM can start on any of the hosts.

### UX

*   User Portal performance improvements for IE8
    -   <http://gerrit.ovirt.org/#/c/11975/>
    -   <http://gerrit.ovirt.org/#/c/12104/>
    -   <http://gerrit.ovirt.org/#/c/10509/>
    -   <http://gerrit.ovirt.org/#/c/10579/>
    -   <http://gerrit.ovirt.org/#/c/12213/>
    -   <http://gerrit.ovirt.org/#/c/12301/>
    -   <http://gerrit.ovirt.org/#/c/12340/>
    -   <http://gerrit.ovirt.org/#/c/12524/>
*   Frontend Clean-up/Refactoring (at least partial/first phase) [Features/Design/FrontendRefactor](Features/Design/FrontendRefactor)
*   Upgrade GWT(P) dependencies

<Category:Releases> [Category:Release management](Category:Release management)
