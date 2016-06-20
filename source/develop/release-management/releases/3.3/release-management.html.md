---
title: oVirt 3.3 release-management
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

# oVirt 3.3 release-management

## Timeline

*' These are tentative planning dates and may change*'

*   General availability: **2013-09-04**
    -   Beta release: **2013-07-18**
    -   Feature freeze: **2013-07-17**
    -   [ oVirt 3.3 Test Day:](OVirt_3.3_TestDay) **2013-07-24**
    -   RC Build: **2013-08-14**

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
*   **MUST**: Have release announcement for front page of ovirt.org and for mailing lists

### SHOULD

*   **SHOULD**: Can run full cycle with gluster storage
*   **SHOULD**: have updated installation guide available
*   **SHOULD**: Scheduling API.
*   **SHOULD**: MoM integration- ballooning.
*   **SHOULD**: Alerts when balloon not supported by guest
*   **SHOULD**: (scheduling API first) VM affinity
*   **SHOULD**: (scheduling API first) VM not getting minimum guaranteed memory

## Features Status Table

| Functional team | Feature                                                                                                                                | Release priority       | Owner                                                                                                | Status                                                      | Target date   | Test page                                                                                                                  | Remarks                                                                                                                                                                                                        |
|-----------------|----------------------------------------------------------------------------------------------------------------------------------------|------------------------|------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|---------------|----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Virt            | [RAM Snapshots](Features/RAM Snapshots)                                                                                     | ?                      | [ Arik Hadas](User:ahadas)                                                                | Green                                                       | June 25th     | <http://www.ovirt.org/Features/RAM_Snapshots#Testing>                                                                      | Merged                                                                                                                                                                                                         |
| Virt            | [noVNC console](Features/noVNC console)                                                                                     | ?                      | [ Frantisek Kobzik](User:FKobzik)                                                         | Green                                                       | ?             | <http://www.ovirt.org/Features/noVNC_console#Testing>                                                                      |                                                                                                                                                                                                                |
| Virt            | [Non Plugin RDP Invocation](Features/Non_plugin_console_invocation)                                                         | ?                      | [ Frantisek Kobzik](User:FKobzik)                                                         | Green                                                       | ?             | <http://www.ovirt.org/Features/Non_plugin_console_invocation#RDP>                                                          |                                                                                                                                                                                                                |
| Virt            | [Instance Types - VM Dialog Redesing](Features/Instance Types)                                                              | ?                      | [ Tomas Jelinek](User:tjelinek) [ Omer Frenkel](User:ofrenkel)                 | Green                                                       | Jun 25th      | <http://www.ovirt.org/Features/Instance_Types#Testing>                                                                     | will be there partially - only redesigned Edit VM dialog and typeahead listboxes                                                                                                                               |
| Virt            | [OS Info](OS_info)                                                                                                          | ?                      | [ Roy Golan](User:rgolan)                                                                 | Green                                                       | Jun 23rd      | <http://wiki.ovirt.org/OS_info#Testing>                                                                                    |                                                                                                                                                                                                                |
| Virt            | [Redesigned Display Options dialog](Features/Console_connection_settings_dialog_in_portals)                                 | ?                      | [ Frantisek Kobzik](User:fkobzik)                                                         | Green                                                       |               | ?                                                                                                                          |                                                                                                                                                                                                                |
| Virt            | [EmulatedMachine](Features/EmulatedMachine)                                                                                 | ?                      | [ Roy Golan](User:rgolan)                                                                 | Green                                                       | June 27th     | <http://www.ovirt.org/Cluster_emulation_modes#Testing>                                                                     | automatically use the right emulated machine type for QEMU. On review                                                                                                                                          |
| Virt            | [SPICE HTML5 client integration](Features/SpiceHTML5)                                                                       | ?                      | [ Frantisek Kobzik](User:fkobzik)                                                         | Green                                                       | June 25th     | <http://www.ovirt.org/Features/SpiceHTML5#Testing>                                                                         |                                                                                                                                                                                                                |
| Virt            | [GlusterFS Storage Domain](Features/GlusterFS_Storage_Domain)                                                               | Must                   | Deepak C Shetty (vdsm) & Sharad Mishra (engine)                                                      | Green                                                       |               | <http://www.ovirt.org/Features/GlusterFS_Storage_Domain#Testing>                                                           |                                                                                                                                                                                                                |
| Virt            | [Cloud-Init Integration](Features/Cloud-Init_Integration)                                                                   | ?                      | [Greg Padgett](User:Gpadgett) [ Omer Frenkel](User:ofrenkel)                   | Green                                                       | Jul 25        | <http://www.ovirt.org/Features/Cloud-Init_Integration#Testing>                                                             | Only available with UI, no REST implementation yet.                                                                                                                                                            |
| Infra           | [Device Custom Properties](Features/Device Custom Properties)                                                               | must                   | [ Martin Perina](User:mperina) - infra [ Assaf Muller](User:amuller) - network | Green                                                       | 2013-06-03    | ?                                                                                                                          | This feature is spread over infra network and storage. The infra aspect is covered by Martin, the network part is covered by Assaf and the storage part is not covered ATM. Infra and Networks parts are done. |
| Infra           | [Async task manager changes](Features/AsyncTaskManagerChanges_3.3)                                                          | should                 | [ Yair Zaslavsky](User:Yair Zaslavsky)                                                    | Green - Merged                                              | 2013-07-03    | <http://www.ovirt.org/Features/AsyncTaskManagerChanges_3.3#Testing>                                                        |                                                                                                                                                                                                                |
| Infra           | [ExternalTasks](Features/ExternalTasks)                                                                                     | Must                   | [ Eli Mesika](User:emesika)                                                               | Green                                                       | 2013-07-14    | | [Features/ExternalTasks#Testing](Features/ExternalTasks#Testing)                                             | Merged                                                                                                                                                                                                         |
| Infra           | [Supervdsm service](Features/Supervdsm_service)                                                                             | Should                 | [ Yaniv Bronhaim](User:ybronhei)                                                          | Green                                                       | 2013-06-03    | <http://www.ovirt.org/Features/Supervdsm_service>                                                                          | Submitted upstream, missing backport to rhev                                                                                                                                                                   |
| Infra           | [SSH Soft Fencing](Automatic_Fencing#Automatic_Fencing_in_oVirt_3.3)                                                        | Should                 | [ Martin Perina](User:mperina)                                                            | Green                                                       | 2013-07-02    | <http://www.ovirt.org/Automatic_Fencing#Testing>                                                                           | Merged                                                                                                                                                                                                         |
| Infra           | [Java SDK](Features/Java_SDK)                                                                                               | Must                   | [ Michael Pasternak](User:Michael pasternak)                                              | Green - Merged                                              |               | <http://www.ovirt.org/Features/Java_SDK_3.3#Testing>                                                                       | Merged                                                                                                                                                                                                         |
| Infra           | [SSH Abilities](Features/Ssh_Abilities)                                                                                     | Should                 | [ Yaniv Bronhaim](User:ybronhei)                                                          | Green                                                       | 2013-07-17    | <http://www.ovirt.org/Features/Ssh_Abilities#Testing>                                                                      | Merged                                                                                                                                                                                                         |
| Networking      | [Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)                                         | Must                   | [ Moti Asayag](User:masayag)                                                              | Green                                                       | 2013-06-03    | [Features/Normalized_ovirtmgmt_Initialization#Testing](Features/Normalized_ovirtmgmt_Initialization#Testing) |                                                                                                                                                                                                                |
| Networking      | [Migration Network](Features/Migration Network)                                                                             | Must                   | [ Alona Kaplan](User:alkaplan)                                                            | Green                                                       | Now           | [Features/Migration_Network#Testing](Features/Migration_Network#Testing)                                      |                                                                                                                                                                                                                |
| Networking      | [Quantum Integration](Features/Quantum_Integration)                                                                         | Must                   | [ Michael Kolesnik](User:mkolesni)                                                        | Green                                                       | 2013-06-16    | [Features/Quantum_Integration#Testing](Features/Quantum_Integration#Testing)                                  | ?                                                                                                                                                                                                              |
| Networking      | [NetworkReloaded](Feature/NetworkReloaded)                                                                                  | Optional - see comment | [ Antoni Segura Puimedon](User:asegurap)                                                  | Orange - In progress, partially merged                      | ?             | ?                                                                                                                          | This feature is mostly about code refactoring and enabling a pluggable network configuration implementation. This feature should not hold back the release.                                                    |
| Networking      | [Multiple Gateways](Features/Multiple Gateways)                                                                             | Must                   | [ Assaf Muller](User:amuller)                                                             | mostly done (though selinux kills dhcp support for multigw) | 2013-06-09    | [Features/Multiple_Gateways#Testing](Features/Multiple_Gateways#Testing)                                      |                                                                                                                                                                                                                |
| Storage         | [Virtio-SCSI support](Features/Virtio-SCSI)                                                                                 | Optional               | [Daniel Erez](User:derez)                                                                 | Green                                                       | ?             | [Features/Virtio-SCSI#Testing](Features/Virtio-SCSI#Testing)                                                   |                                                                                                                                                                                                                |
| Storage         | [Read Only Disks](Features/Read_Only_Disk)                                                                                  | Optional               | [Vered Volansky](User:vvolansk)                                                           | Orange - In progress, not submitted                         | ?             | ?                                                                                                                          |                                                                                                                                                                                                                |
| Storage         | [Manage Storage Connections](Features/Manage_Storage_Connections)                                                           | Must                   | [Alissa Bonas](User:abonas)                                                               | Orange - Work in Progress, partially merged                 | 2013-06-30    | [Features/Manage_Storage_Connections#Testing](Features/Manage_Storage_Connections#Testing)                   |                                                                                                                                                                                                                |
| Storage         | [Adding VDSM hooks for hotplugging/unplugging a disk](Features/Disk_Hooks)                                                  | Optional               | [Vered Volansky](User:vvolansk)                                                           | Green                                                       |               |                                                                                                                            |                                                                                                                                                                                                                |
| Storage         | [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](Features/MoveAsCopyAndDelete) | Optional               | [Liron Aravot](User:laravot)                                                              | Green                                                       |               |                                                                                                                            | Done                                                                                                                                                                                                           |
| Storage         | [Backup and Restore API for Independent Software Vendors](Features/Backup-Restore_API_Integration)                          | Optional               | Deepak C Shetty (vdsm) & Sharad Mishra (engine)                                                      | Red - Work in Progress                                      | ?             | ?                                                                                                                          | Still in the early stages of development                                                                                                                                                                       |
| Storage         | Allow resign/force re-election of SPM                                                                                                  | Optional               | [Tal Nisan](User:tal)                                                                     | ?                                                           | ?             | ?                                                                                                                          |                                                                                                                                                                                                                |
| Storage         | [Disks Block Alignment](Features/DiskAlignment)                                                                             | Optional               | [Federico Simoncelli](User:fsimonce)                                                      | Orange - In progress                                        |               |                                                                                                                            | VDSM patches merged, Engine/Webadmin in review                                                                                                                                                                 |
| SLA             | [oVirt scheduler](Features/oVirt_scheduler)                                                                                 | Must                   | [Gilad Chaplik](User:GChaplik)                                                            | Green                                                       | 15/7/2013     |                                                                                                                            |                                                                                                                                                                                                                |
| SLA             | [Scheduling API](Features/Scheduling_API)                                                                                   | Must                   | [Gilad Chaplik](User:GChaplik)                                                            | orange - in review                                          |               | ?                                                                                                                          |                                                                                                                                                                                                                |
| SLA             | [Network QoS](Features/Design/Network_QoS)                                                                                  | Must                   | [Ofri Masad](User:OMasad)                                                                 | Green                                                       |               | ?                                                                                                                          |                                                                                                                                                                                                                |
| SLA             | [Watchdog engine support](Features/Watchdog_engine_support)                                                                 | Must                   | [lhornyak@redhat.com](User:LHornyak)                                                      |                                                             |               | [Test cases](Features/Watchdog engine support#Test_cases)                                                       |                                                                                                                                                                                                                |
| SLA             | [Trusted compute pools](Trusted_compute_pools)                                                                              | Must                   | <User:OMasad>                                                                                        |                                                             |               | [Trusted_compute_pools#Test_cases](Trusted_compute_pools#Test_cases)                                        |                                                                                                                                                                                                                |
| Gluster         | [Gluster Hooks Management](Features/Gluster Hooks Management)                                                               | Should                 | [Sahina Bose](User:Sahina)                                                                | Green                                                       | 17/06/2013    | [Gluster Hooks Management Testing](Features/Gluster Hooks Management#Test_Cases)                                |                                                                                                                                                                                                                |
| Node            | [Universal Node Image](Features/Universal Image)                                                                            | Must                   | mburns@redhat.com                                                                                    | Green                                                       | Now           | ?                                                                                                                          |                                                                                                                                                                                                                |
| Node            | [Node VDSM Plugin](Features/Node vdsm plugin)                                                                               | Must                   | mburns                                                                                               | Green                                                       | 2013-05-31    | [Features/Node_vdsm_plugin#Testing](Features/Node_vdsm_plugin#Testing)                                       |                                                                                                                                                                                                                |
| Integration     | [Otopi Infra Migration](Features/Otopi_Infra_Migration)                                                                     | Must                   | [ Sandro Bonazzola](User:SandroBonazzola)                                                 | Green                                                       | 29/6/2013     | [Test cases](Features/Otopi_Infra_Migration#Basic_Testing)                                                      |                                                                                                                                                                                                                |
| UX              | User Portal performance improvements for IE8                                                                                           | Must                   | vszocs@redhat.com, awels@redhat.com                                                                  | Green                                                       | Now           | N/A                                                                                                                        |                                                                                                                                                                                                                |
| UX              | [Branding Support](Feature/Branding)                                                                                        | Should                 | awels@redhat.com                                                                                     | Green                                                       | June 11, 2013 | N/A                                                                                                                        |                                                                                                                                                                                                                |

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
*   [Features/Cloud-Init_Integration](Features/Cloud-Init_Integration)

### Infra

*   [Features/Device Custom Properties](Features/Device Custom Properties)
*   [Features/ExternalTasks](Features/ExternalTasks)
*   [Features/Supervdsm_service](Features/Supervdsm_service)
*   [Features/Java_SDK](Features/Java_SDK)
*   [Features/Ssh_Abilities](Features/Ssh_Abilities)

### Networking

*   [Features/Migration Network](Features/Migration Network)
*   [Features/Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)
*   [Features/Quantum_Integration](Features/Quantum_Integration)
*   [Feature/NetworkReloaded](Feature/NetworkReloaded) reimplementation of configNetwork in vdsm. Should have zero (0) effect on users, but required for future support for ovs/NM
*   [Features/Multiple Gateways](Features/Multiple Gateways) configure more gateways on host, on top of the default one.

### Storage

*   [Enable online virtual drive resize](Features/Online_Virtual_Drive_Resize)
*   [Virtio-SCSI support](Features/Virtio-SCSI)
*   [ Read Only Disks ](Features/Read_Only_Disk)
*   [Edit Connection Properties](Features/Edit_Connection_Properties)
*   [Adding VDSM hooks for hotplugging/unplugging a disk](Features/Disk_Hooks)
*   [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](Features/MoveAsCopyAndDelete)
*   [Backup and Restore API for Independent Software Vendors](Features/Backup-Restore_API_Integration)
*   Allow resign/force re-election of SPM
*   [Disks Block Alignment](Features/DiskAlignment)
*   [Integration with Glance](Features/Glance_Integration)

### SLA & Scheduling

*   [Features/oVirt_scheduler](Features/oVirt_scheduler) Wrapping scheduling functionalities as a separate package
*   [Features/Scheduling_API](Features/Scheduling_API) (depends on [Features/oVirt_scheduler](Features/oVirt_scheduler)) exposing user-level scheduling API
*   [Features/Watchdog_engine_support](Features/Watchdog_engine_support)
*   [Features/Network_QoS](Features/Network_QoS)
*   [Trusted_compute_pools](Trusted_compute_pools)

### Gluster

*   [Features/Gluster Hooks Management](Features/Gluster Hooks Management) Managing gluster hooks from console
    -   Status : In Progress
    -   gerrit :
        -   <http://gerrit.ovirt.org/#/q/project:ovirt-engine+branch:master+topic:gluster-hooks,n,z>
        -   <http://gerrit.ovirt.org/#/c/14145>

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
*   Upgrade Google Web Toolkit & related framework versions

<Category:Releases> [Category:Release management](Category:Release management)
