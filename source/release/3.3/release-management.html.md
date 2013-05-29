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
wiki_warnings: table-style
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

## Features Status Table

| Functional team | Feature                                                                                                                                | Release priority       | Owner                                                                                                | Status                                 | Target date | Test page                                                                                                                  | Remarks                                                                                                                                                                     |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------|------------------------|------------------------------------------------------------------------------------------------------|----------------------------------------|-------------|----------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Virt            | [RAM Snapshots](Features/RAM Snapshots)                                                                                     | ?                      | [ Arik Hadas](User:ahadas)                                                                | Orange - In progress, , see comment    | ?           | ?                                                                                                                          | vdsm part was pushed, engine part is still on progress - handling memory snapshots on export/import operations remained, REST part didn't start                             |
| Virt            | [noVNC console](Features/noVNC console)                                                                                     | ?                      | |[ Frantisek Kobzik](User:FKobzik)                                                        | Orange                                 | ?           | ?                                                                                                                          | ?                                                                                                                                                                           |
| Virt            | [Non Plugin RDP Invocation](Features/Non Plugin RDP Invocation)                                                             | ?                      | |[ Frantisek Kobzik](User:FKobzik)                                                        | Green                                  | ?           | ?                                                                                                                          | TODO - wiki page.                                                                                                                                                           |
| Virt            | [Instance Types](Features/Instance Types)                                                                                   | ?                      | [ Tomas Jelinek](User:tjelinek) [ Omer Frenkel](User:ofrenkel)                 | Red                                    | ?           | ?                                                                                                                          | UI and Engine in progress, update instance type with running vms still not implemented, no rest api                                                                         |
| Virt            | [GlusterFS Storage Domain](Features/GlusterFS_Storage_Domain)                                                               | ?                      | ?                                                                                                    | ?                                      | ?           | ?                                                                                                                          |                                                                                                                                                                             |
| Infra           | [Device Custom Properties](Features/Device Custom Properties)                                                               | must                   | [ Martin Perina](User:mperina) - infra [ Assaf Muller](User:amuller) - network | Orange - In progress, , see comment    | 2013-06-03  | ?                                                                                                                          | This feature is spread over infra network and storage. The infra aspect is covered by Martin, the network part is covered by Assaf and the storage part is not covered ATM. |
| Infra           | [Async task manager changes](Features/AsyncTaskManagerChanges_3.3)                                                          | should                 | [ Yair Zaslavsky](User:Yair Zaslavsky)                                                    | Orange - In progress, , see comment    | ?           | ?                                                                                                                          | The patch is still under review upstream.                                                                                                                                   |
| Infra           | [ExternalTasks](Features/ExternalTasks)                                                                                     | Must                   | [ Eli Mesika](User:emesika)                                                               | Orange - In progress, not submitted    | ?           | | [Features/ExternalTasks#Testing](Features/ExternalTasks#Testing)                                             | Only backend side done, Missing API implementation and testing                                                                                                              |
| Infra           | [Supervdsm service](Features/Supervdsm_service)                                                                             | Should                 | [ Yaniv Bronhaim](User:ybronhei)                                                          | Orange - In progress, not submitted    | 2013-06-03  | <http://www.ovirt.org/Features/Supervdsm_service>                                                                          | All implemented, waiting for final reviews                                                                                                                                  |
| Networking      | [Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)                                         | Must                   | [ Moti Asayag](User:masayag)                                                              | Orange - In progress, partially merged | 2013-06-03  | [Features/Normalized_ovirtmgmt_Initialization#Testing](Features/Normalized_ovirtmgmt_Initialization#Testing) |                                                                                                                                                                             |
| Networking      | [Migration Network](Features/Migration Network)                                                                             | Must                   | [ Alona Kaplan](User:alkaplan)                                                            | Green                                  | Now         | [Features/Migration_Network#Testing](Features/Migration_Network#Testing)                                      |                                                                                                                                                                             |
| Networking      | [Quantum Integration](Features/Quantum_Integration)                                                                         | Must                   | [ Michael Kolesnik](User:mkolesni)                                                        | Orange - In progress, partially merged | 2013-06-16  | ?                                                                                                                          | ?                                                                                                                                                                           |
| Networking      | [NetworkReloaded](Feature/NetworkReloaded)                                                                                  | Optional - see comment | [ Antoni Segura Puimedon](User:asegurap)                                                  | Orange - In progress, partially merged | ?           | ?                                                                                                                          | This feature is mostly about code refactoring and enabling a pluggable network configuration implementation. This feature should not hold back the release.                 |
| Networking      | [Multiple Gateways](Features/Multiple Gateways)                                                                             | Must                   | [ Assaf Muller](User:amuller)                                                             | Red - no code written                  | 2013-06-09  | [Features/Multiple_Gateways#Testing](Features/Multiple_Gateways#Testing)                                      |                                                                                                                                                                             |
| Networking      | [Network Labels](Features/Network Labels)                                                                                   | Optional - see comment | ?                                                                                                    | Red - feature not defined properly     | ?           | ?                                                                                                                          | I suggest we postpone this feature as we are not clear on the scope yet.                                                                                                    |
| Networking      | [Network Security Groups](Features/Network Security Groups)                                                                 | Optional - see comment | ?                                                                                                    | Red - feature not defined properly     | ?           | ?                                                                                                                          | I suggest we postpone this feature as we are not clear on the scope yet.                                                                                                    |
| Storage         | [Virtio-SCSI support](Features/Virtio-SCSI)                                                                                 | Optional               | [Daniel Erez](User:derez)                                                                 | Orange - In progress, not submitted    | ?           | [Features/Virtio-SCSI#Testing](Features/Virtio-SCSI#Testing)                                                   |                                                                                                                                                                             |
| Storage         | [Read Only Disks](Features/Read_Only_Disk)                                                                                  | Optional               | [Vered Volansky](User:vvolansk)                                                           | Orange - In progress, not submitted    | ?           | ?                                                                                                                          |                                                                                                                                                                             |
| Storage         | [Edit Connection Properties](Features/Edit_Connection_Properties)                                                           | Must                   | [Alissa Bonas](User:abonas)                                                               | Red - Work in Progress                 | 2013-06-30  | ?                                                                                                                          |                                                                                                                                                                             |
| Storage         | [Adding VDSM hooks for hotplugging/unplugging a disk](Features/Disk_Hooks)                                                  | Optional               | [Vered Volansky](User:vvolansk)                                                           | Green                                  |             |                                                                                                                            |                                                                                                                                                                             |
| Storage         | [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](Features/MoveAsCopyAndDelete) | Optional               | [Liron Aravot](User:laravot)                                                              | Orange                                 |             |                                                                                                                            | The code is ready but not integrated yet                                                                                                                                    |
| Storage         | [Backup and Restore API for Independent Software Vendors](Features/Backup-Restore_API_Integration)                          | Optional               | Developed by IBM                                                                                     | Red - Work in Progress                 | ?           | ?                                                                                                                          | IBM guys are working on this feature, need to verify their status                                                                                                           |
| Storage         | Allow resign/force re-election of SPM                                                                                                  | Optional               | [Tal Nisan](User:tal)                                                                     | ?                                      | ?           | ?                                                                                                                          |                                                                                                                                                                             |
| SLA             | [oVirt scheduler](Features/oVirt_scheduler)                                                                                 | Must                   | [Gilad Chaplik](User:GChaplik)                                                            | red - in progress                      | 1/7/2013    | ?                                                                                                                          |                                                                                                                                                                             |
| SLA             | [Scheduling API](Features/Scheduling_API)                                                                                   | Must                   | [Gilad Chaplik](User:GChaplik)                                                            | red - in progress                      | 1/7/2013    | ?                                                                                                                          |                                                                                                                                                                             |
| SLA             | [Network QoS](Features/Design/Network_QoS)                                                                                  | Must                   | [Ofri Masad](User:OMasad)                                                                 | red - in design                        | 16/6/2013   | ?                                                                                                                          |                                                                                                                                                                             |
| SLA             | [Watchdog engine support](Features/Watchdog_engine_support)                                                                 | Must                   | [lhornyak@redhat.com](User:LHornyak)                                                      | orange - rest api missing              | ?           | [Test cases](Features/Watchdog engine support#Test_cases)                                                       |                                                                                                                                                                             |
| Gluster         | [Gluster Hooks Management](Features/Gluster Hooks Management)                                                               | Should                 | sabose@redhat.com                                                                                    | orange                                 | 31/05/2013  | ?                                                                                                                          | Patches are under review upstream                                                                                                                                           |
| Gluster         | [Gluster Swift Management](Features/Gluster Swift Management)                                                               | Should                 | sabose@redhat.com                                                                                    | orange                                 | 31/05/2013  | ?                                                                                                                          | Gluster Swift configuration will not be covered in this release                                                                                                             |
| Node            | [Universal Node Image](Features/Universal Image)                                                                            | Must                   | mburns@redhat.com                                                                                    | Green                                  | Now         | ?                                                                                                                          |                                                                                                                                                                             |
| Node            | [Node VDSM Plugin](Features/Node vdsm plugin)                                                                               | Must                   | mburns                                                                                               | Green                                  | 2013-05-31  | [Features/Node_vdsm_plugin#Testing](Features/Node_vdsm_plugin#Testing)                                       |                                                                                                                                                                             |
| Integration     | [Otopi Infra Migration](Features/Otopi_Infra_Migration)                                                                     | Must                   | [ sbonazzo@redhat.com](User:SandroBonazzola)                                              | Orange                                 | 30/5/2013   | ?                                                                                                                          | Does not support upgrade from previous installations                                                                                                                        |
| Integration     | [Self Hosted Engine](Features/Self_Hosted_Engine)                                                                           | Should                 | sbonazzo@redhat.com                                                                                  | Red                                    | 20/6/2013   | ?                                                                                                                          |                                                                                                                                                                             |
| UX              | User Portal performance improvements for IE8                                                                                           | Must                   | ?                                                                                                    | Green                                  | Now         | ?                                                                                                                          |                                                                                                                                                                             |
| UX              | Branding Support                                                                                                                       | Should                 | awels@redhat.com                                                                                     | Red                                    | 31/06/2013  | ?                                                                                                                          | Code complete, just needs final review and final dev testing before handing to QA                                                                                           |
| UX              | [FrontendRefactor](Features/Design/FrontendRefactor)                                                                        | Should                 | awels@redhat.com                                                                                     | Red                                    | ?           | ?                                                                                                                          |                                                                                                                                                                             |

### Feature Table Mapping

#### Release priority:

*   Must - feature absense will delay the release
*   Should - feature absense won't delay the release

#### Status mapping:

    * Red  - Feature isn't in code base yet.

    * Orange  -  Feature is in code base but not completed yet.

    * Green  - Feature is in code base and ready for testing.

#### Target Date

date complete feature is merged in code base

#### Test Page

base description on how to test the new feature - should be relevant for test day

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

*   [Enable online virtual drive resize](Features/Online_Virtual_Drive_Resize)
*   [Virtio-SCSI support](Features/Virtio-SCSI)
*   [ Read Only Disks ](Features/Read_Only_Disk)
*   [Edit Connection Properties](Features/Edit_Connection_Properties)
*   [Adding VDSM hooks for hotplugging/unplugging a disk](Features/Disk_Hooks)
*   [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](Features/MoveAsCopyAndDelete)
*   [Backup and Restore API for Independent Software Vendors](Features/Backup-Restore_API_Integration)
*   Allow resign/force re-election of SPM

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
*   [Features/Gluster Swift Management](Features/Gluster Swift Management) Enable administrator to manage gluster swift related services
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

*   (MUST) [Features/Otopi_Infra_Migration](Features/Otopi_Infra_Migration) A complete re-write of engine-setup, engine-cleanup, engine-upgrade and AIO plugin using otopi.
*   (SHOULD) [Features/Self_Hosted_Engine](Features/Self_Hosted_Engine) The ability to run the Engine as a VM on the hosts that are managed by this Engine, in an HA configuration, when the Engine VM can start on any of the hosts.

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
*   Branding support
    -   <http://gerrit.ovirt.org/#/c/13181/>
*   Frontend Clean-up/Refactoring (at least partial/first phase) [Features/Design/FrontendRefactor](Features/Design/FrontendRefactor)
*   Upgrade GWT(P) dependencies

<Category:Releases> [Category:Release management](Category:Release management)
