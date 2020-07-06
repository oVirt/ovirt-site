---
title: oVirt 3.3 release-management
category: release
authors: abonas, amuller, amureini, arik, awels, danken, derez, dneary, doron, dpkshetty,
  ecohen, emesika, fkobzik, fsimonce, gpadgett, knarra, laravot, lhornyak, lpeer,
  mburns, mgoldboi, michael pasternak, mkolesni, moti, mperina, mskrivan, netbulae,
  ofrenkel, ofri, oschreib, prasanth, roy, sahina, sandrobonazzola, sgotliv, tjelinek,
  vered, vszocs, yair zaslavsky, ybronhei
---

# oVirt 3.3 release-management

## Timeline

*' These are tentative planning dates and may change*'

*   General availability: **2013-09-04**
    -   Beta release: **2013-07-18**
    -   Feature freeze: **2013-07-17**
    -   [oVirt 3.3 Test Day:](/develop/release-management/releases/3.3/testday/) **2013-07-24**
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
    -   [Features/Node_upgrade_tool](/develop/release-management/features/node/upgrade-tool/) - Status:
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
| Virt            | [RAM Snapshots](/develop/release-management/features/virt/ram-snapshots/)                                                                                     | ?                      | Arik Hadas (ahadas)                                                                | Green                                                       | June 25th     | [Features/RAM Snapshots#Testing](/develop/release-management/features/virt/ram-snapshots/#testing)                                                                      | Merged                                                                                                                                                                                                         |
| Virt            | [noVNC console](/develop/release-management/features/virt/novnc-console/)                                                                                     | ?                      | Frantisek Kobzik (FKobzik)                                                         | Green                                                       | ?             | [Features/noVNC console#Testing](/develop/release-management/features/virt/novnc-console/#testing)                                                                      |                                                                                                                                                                                                                |
| Virt            | [Non Plugin RDP Invocation](/develop/release-management/features/virt/non-plugin-console-invocation/)                                                         | ?                      | Frantisek Kobzik (FKobzik)                                                         | Green                                                       | ?             | [Features/Non plugin console invocation#RDP](/develop/release-management/features/virt/non-plugin-console-invocation/#rdp)                                                          |                                                                                                                                                                                                                |
| Virt            | [Instance Types - VM Dialog Redesing](/develop/release-management/features/virt/instance-types/)                                                              | ?                      | Tomas Jelinek (tjelinek) Omer Frenkel (ofrenkel)                 | Green                                                       | Jun 25th      | [Features/Instance Types#Testing](/develop/release-management/features/virt/instance-types/#testing)                                                                     | will be there partially - only redesigned Edit VM dialog and typeahead listboxes                                                                                                                               |
| Virt            | [OS Info](/develop/release-management/features/virt/os-info/)                                                                                                          | ?                      | Roy Golan (rgolan)                                                                 | Green                                                       | Jun 23rd      | [OS info#Testing](/develop/release-management/features/virt/os-info/#testing)                                                                                    |                                                                                                                                                                                                                |
| Virt            | [Redesigned Display Options dialog](/develop/release-management/features/virt/console-connection-settings-dialog-in-portals/)                                 | ?                      | Frantisek Kobzik (fkobzik)                                                         | Green                                                       |               | ?                                                                                                                          |                                                                                                                                                                                                                |
| Virt            | [EmulatedMachine](Features/EmulatedMachine)                                                                                 | ?                      | Roy Golan (rgolan)                                                                 | Green                                                       | June 27th     | [Cluster emulation modes#Testing](/develop/release-management/features/virt/cluster-emulation-modes/#testing)                                                                     | automatically use the right emulated machine type for QEMU. On review                                                                                                                                          |
| Virt            | [SPICE HTML5 client integration](/develop/release-management/features/virt/spicehtml5/)                                                                       | ?                      | Frantisek Kobzik (fkobzik)                                                         | Green                                                       | June 25th     | [Features/SpiceHTML5#Testing](/develop/release-management/features/virt/spicehtml5/#testing)                                                                         |                                                                                                                                                                                                                |
| Virt            | [GlusterFS Storage Domain](/develop/release-management/features/storage/glusterfs-storage-domain/)                                                               | Must                   | Deepak C Shetty (vdsm) & Sharad Mishra (engine)                                                      | Green                                                       |               | [Features/GlusterFS Storage Domain#Testing](/develop/release-management/features/storage/glusterfs-storage-domain/#testing)                                                           |                                                                                                                                                                                                                |
| Virt            | [Cloud-Init Integration](/develop/release-management/features/cloud/cloud-init-integration/)                                                                   | ?                      | Greg Padgett (Gpadgett) Omer Frenkel (ofrenkel)                   | Green                                                       | Jul 25        | [Features/Cloud-Init Integration#Testing](/develop/release-management/features/cloud/cloud-init-integration/#testing)                                                             | Only available with UI, no REST implementation yet.                                                                                                                                                            |
| Infra           | [Device Custom Properties](/develop/release-management/features/network/device-custom-properties/)                                                               | must                   | Martin Perina (mperina) - infra Assaf Muller (amuller) - network | Green                                                       | 2013-06-03    | ?                                                                                                                          | This feature is spread over infra network and storage. The infra aspect is covered by Martin, the network part is covered by Assaf and the storage part is not covered ATM. Infra and Networks parts are done. |
| Infra           | [Async task manager changes](/develop/release-management/features/infra/asynctaskmanagerchanges-3.3/)                                                          | should                 | Yair Zaslavsky (Yair Zaslavsky)                                                    | Green - Merged                                              | 2013-07-03    | [Features/AsyncTaskManagerChanges 3.3#Testing](/develop/release-management/features/infra/asynctaskmanagerchanges-3.3/#testing)                                                        |                                                                                                                                                                                                                |
| Infra           | [ExternalTasks](/develop/release-management/features/infra/externaltasks/)                                                                                     | Must                   | Eli Mesika (emesika)                                                               | Green                                                       | 2013-07-14    | | [Features/ExternalTasks#Testing](/develop/release-management/features/infra/externaltasks/#testing)                                             | Merged                                                                                                                                                                                                         |
| Infra           | [Supervdsm service](/develop/release-management/features/vdsm/supervdsm-service/)                                                                             | Should                 | Yaniv Bronhaim (ybronhei)                                                          | Green                                                       | 2013-06-03    | [Features/Supervdsm service](/develop/release-management/features/vdsm/supervdsm-service/)                                                                          | Submitted upstream, missing backport to rhev                                                                                                                                                                   |
| Infra           | [SSH Soft Fencing](/develop/developer-guide/engine/automatic-fencing/#automatic-fencing-in-ovirt-3.3)                                                        | Should                 | Martin Perina (mperina)                                                            | Green                                                       | 2013-07-02    | [Automatic Fencing#Testing](/develop/developer-guide/engine/automatic-fencing/#testing)                                                                           | Merged                                                                                                                                                                                                         |
| Infra           | [Java SDK](Features/Java_SDK)                                                                                               | Must                   | Michael Pasternak (Michael pasternak)                                              | Green - Merged                                              |               | </Features/Java_SDK_3.3#Testing>                                                                       | Merged                                                                                                                                                                                                         |
| Infra           | [SSH Abilities](/develop/release-management/features/infra/ssh-abilities/)                                                                                     | Should                 | Yaniv Bronhaim (ybronhei)                                                          | Green                                                       | 2013-07-17    | [Features/Ssh Abilities#Testing](/develop/release-management/features/infra/ssh-abilities/#testing)                                                                      | Merged                                                                                                                                                                                                         |
| Networking      | [Normalized ovirtmgmt Initialization](/develop/release-management/features/network/normalized-ovirtmgmt-initialization/)                                         | Must                   | Moti Asayag (masayag)                                                              | Green                                                       | 2013-06-03    | [Features/Normalized_ovirtmgmt_Initialization#Testing](/develop/release-management/features/network/normalized-ovirtmgmt-initialization/#testing) |                                                                                                                                                                                                                |
| Networking      | [Migration Network](/develop/release-management/features/network/migration-network/)                                                                             | Must                   | Alona Kaplan (alkaplan)                                                            | Green                                                       | Now           | [Features/Migration_Network#Testing](/develop/release-management/features/network/migration-network/#testing)                                      |                                                                                                                                                                                                                |
| Networking      | [Quantum Integration](/develop/release-management/features/network/osn-integration/)                                                                         | Must                   | Michael Kolesnik (mkolesni)                                                        | Green                                                       | 2013-06-16    | [Features/Quantum_Integration#Testing](/develop/release-management/features/network/osn-integration/#testing)                                  | ?                                                                                                                                                                                                              |
| Networking      | [NetworkReloaded](/develop/release-management/features/network/networkreloaded/)                                                                                  | Optional - see comment | Antoni Segura Puimedon (asegurap)                                                  | Orange - In progress, partially merged                      | ?             | ?                                                                                                                          | This feature is mostly about code refactoring and enabling a pluggable network configuration implementation. This feature should not hold back the release.                                                    |
| Networking      | [Multiple Gateways](/develop/release-management/features/network/multiple-gateways/)                                                                             | Must                   | Assaf Muller (amuller)                                                             | mostly done (though selinux kills dhcp support for multigw) | 2013-06-09    | [Features/Multiple_Gateways#Testing](/develop/release-management/features/network/multiple-gateways/#testing)                                      |                                                                                                                                                                                                                |
| Storage         | [Virtio-SCSI support](/develop/release-management/features/storage/virtio-scsi/)                                                                                 | Optional               | Daniel Erez (derez)                                                                 | Green                                                       | ?             | [Features/Virtio-SCSI#Testing](/develop/release-management/features/storage/virtio-scsi/#testing)                                                   |                                                                                                                                                                                                                |
| Storage         | [Read Only Disks](/develop/release-management/features/storage/read-only-disk/)                                                                                  | Optional               | Vered Volansky (vvolansk)                                                           | Orange - In progress, not submitted                         | ?             | ?                                                                                                                          |                                                                                                                                                                                                                |
| Storage         | [Manage Storage Connections](/develop/release-management/features/storage/manage-storage-connections/)                                                           | Must                   | Alissa Bonas (abonas)                                                               | Orange - Work in Progress, partially merged                 | 2013-06-30    | [Features/Manage_Storage_Connections#Testing](/develop/release-management/features/storage/manage-storage-connections/#testing)                   |                                                                                                                                                                                                                |
| Storage         | [Adding VDSM hooks for hotplugging/unplugging a disk](/develop/release-management/features/storage/disk-hooks/)                                                  | Optional               | Vered Volansky (vvolansk)                                                           | Green                                                       |               |                                                                                                                            |                                                                                                                                                                                                                |
| Storage         | [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](/develop/release-management/features/storage/moveascopyanddelete/) | Optional               | Liron Aravot (laravot)                                                              | Green                                                       |               |                                                                                                                            | Done                                                                                                                                                                                                           |
| Storage         | [Backup and Restore API for Independent Software Vendors](/develop/release-management/features/storage/backup-restore-api-integration/)                          | Optional               | Deepak C Shetty (vdsm) & Sharad Mishra (engine)                                                      | Red - Work in Progress                                      | ?             | ?                                                                                                                          | Still in the early stages of development                                                                                                                                                                       |
| Storage         | Allow resign/force re-election of SPM                                                                                                  | Optional               | Tal Nisan (tal)                                                                     | ?                                                           | ?             | ?                                                                                                                          |                                                                                                                                                                                                                |
| Storage         | [Disks Block Alignment](/develop/release-management/features/storage/diskalignment/)                                                                             | Optional               | Federico Simoncelli (fsimonce)                                                      | Orange - In progress                                        |               |                                                                                                                            | VDSM patches merged, Engine/Webadmin in review                                                                                                                                                                 |
| SLA             | [oVirt scheduler](/develop/release-management/features/sla/ovirtscheduler/)                                                                                 | Must                   | Gilad Chaplik (GChaplik)                                                            | Green                                                       | 15/7/2013     |                                                                                                                            |                                                                                                                                                                                                                |
| SLA             | [Scheduling API](Features/Scheduling_API)                                                                                   | Must                   | Gilad Chaplik (GChaplik)                                                            | orange - in review                                          |               | ?                                                                                                                          |                                                                                                                                                                                                                |
| SLA             | [Network QoS](/develop/release-management/features/network/network-qos-detailed-design/)                                                                                  | Must                   | Ofri Masad (OMasad)                                                                 | Green                                                       |               | ?                                                                                                                          |                                                                                                                                                                                                                |
| SLA             | [Watchdog engine support](/develop/release-management/features/engine/watchdog-engine-support/)                                                                 | Must                   | lhornyak@redhat.com (LHornyak)                                                      |                                                             |               | [Test cases](/develop/release-management/features/engine/watchdog-engine-support/#test-cases)                                                       |                                                                                                                                                                                                                |
| SLA             | [Trusted compute pools](/develop/release-management/features/sla/trusted-compute-pools/)                                                                              | Must                   | <User:OMasad>                                                                                        |                                                             |               | [Trusted_compute_pools#Test_cases](/develop/release-management/features/sla/trusted-compute-pools/#test-cases)                                        |                                                                                                                                                                                                                |
| Gluster         | [Gluster Hooks Management](/develop/release-management/features/gluster/gluster-hooks-management/)                                                               | Should                 | Sahina Bose (Sahina)                                                                | Green                                                       | 17/06/2013    | [Gluster Hooks Management Testing](/develop/release-management/features/gluster/gluster-hooks-management/#test-cases)                                |                                                                                                                                                                                                                |
| Node            | [Universal Node Image](/develop/release-management/features/node/universal-image/)                                                                            | Must                   | mburns@redhat.com                                                                                    | Green                                                       | Now           | ?                                                                                                                          |                                                                                                                                                                                                                |
| Node            | [Node VDSM Plugin](/develop/release-management/features/vdsm/vdsm-plugin/)                                                                               | Must                   | mburns                                                                                               | Green                                                       | 2013-05-31    | [Features/Node_vdsm_plugin#Testing](/develop/release-management/features/vdsm/vdsm-plugin/#testing)                                       |                                                                                                                                                                                                                |
| Integration     | [Otopi Infra Migration](/develop/release-management/features/integration/otopi-infra-migration/)                                                                     | Must                   | [Sandro Bonazzola](https://github.com/sandrobonazzola)                                                 | Green                                                       | 29/6/2013     | [Test cases](/develop/release-management/features/integration/otopi-infra-migration/#basic-testing)                                                      |                                                                                                                                                                                                                |
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

*   [Features/RAM Snapshots](/develop/release-management/features/virt/ram-snapshots/)
*   [Features/noVNC console](/develop/release-management/features/virt/novnc-console/)
*   [Features/GlusterFS_Storage_Domain](/develop/release-management/features/storage/glusterfs-storage-domain/)
*   [Features/Cloud-Init_Integration](/develop/release-management/features/cloud/cloud-init-integration/)

### Infra

*   [Features/Device Custom Properties](/develop/release-management/features/network/device-custom-properties/)
*   [Features/ExternalTasks](/develop/release-management/features/infra/externaltasks/)
*   [Features/Supervdsm_service](/develop/release-management/features/vdsm/supervdsm-service/)
*   [Features/Java_SDK](Features/Java_SDK)
*   [Features/Ssh_Abilities](/develop/release-management/features/infra/ssh-abilities/)

### Networking

*   [Features/Migration Network](/develop/release-management/features/network/migration-network/)
*   [Features/Normalized ovirtmgmt Initialization](/develop/release-management/features/network/normalized-ovirtmgmt-initialization/)
*   [Features/Quantum_Integration](/develop/release-management/features/network/osn-integration/)
*   [Feature/NetworkReloaded](/develop/release-management/features/network/networkreloaded/) reimplementation of configNetwork in vdsm. Should have zero (0) effect on users, but required for future support for ovs/NM
*   [Features/Multiple Gateways](/develop/release-management/features/network/multiple-gateways/) configure more gateways on host, on top of the default one.

### Storage

*   [Enable online virtual drive resize](/develop/release-management/features/storage/online-virtual-drive-resize/)
*   [Virtio-SCSI support](/develop/release-management/features/storage/virtio-scsi/)
*   [Read Only Disks](/develop/release-management/features/storage/read-only-disk/)
*   [Edit Connection Properties](Features/Edit_Connection_Properties)
*   [Adding VDSM hooks for hotplugging/unplugging a disk](/develop/release-management/features/storage/disk-hooks/)
*   [Separating "Move" vm operation to "Copy" and "Delete" operations to improve VM availability](/develop/release-management/features/storage/moveascopyanddelete/)
*   [Backup and Restore API for Independent Software Vendors](/develop/release-management/features/storage/backup-restore-api-integration/)
*   Allow resign/force re-election of SPM
*   [Disks Block Alignment](/develop/release-management/features/storage/diskalignment/)
*   [Integration with Glance](/develop/release-management/features/storage/glance-integration/)

### SLA & Scheduling

*   [Features/oVirt_scheduler](/develop/release-management/features/sla/ovirtscheduler/) Wrapping scheduling functionalities as a separate package
*   [Features/Scheduling_API](Features/Scheduling_API) (depends on [Features/oVirt_scheduler](/develop/release-management/features/sla/ovirtscheduler/)) exposing user-level scheduling API
*   [Features/Watchdog_engine_support](/develop/release-management/features/engine/watchdog-engine-support/)
*   [Features/Network_QoS](/documentation/sla/network-qos/)
*   [Trusted_compute_pools](/develop/release-management/features/sla/trusted-compute-pools/)

### Gluster

*   [Features/Gluster Hooks Management](/develop/release-management/features/gluster/gluster-hooks-management/) Managing gluster hooks from console
    -   Status : In Progress
    -   gerrit :
        -   <http://gerrit.ovirt.org/#/q/project:ovirt-engine+branch:master+topic:gluster-hooks,n,z>
        -   <http://gerrit.ovirt.org/#/c/14145>

### Node

*   [Universal Node Image](/develop/release-management/features/node/universal-image/) make the ovirt-node image generic for use with non-oVirt Projects
*   [Node VDSM Plugin](/develop/release-management/features/vdsm/vdsm-plugin/) extract all vdsm and oVirt Engine specific code from ovirt-node into a plugin
*   oVirt Node works on a different asynchronous release schedule from the rest of oVirt.
    -   At the time of the oVirt 3.3 release, the current version of ovirt-node will be 3.0.0.
    -   Feature for oVirt node 3.0.0 can be found on the [oVirt Node 3.0.0 release page](/develop/projects/node/3.0-release-management/)

### Integration

*   (MUST) [Features/Otopi_Infra_Migration](/develop/release-management/features/integration/otopi-infra-migration/) A complete re-write of engine-setup, engine-cleanup, engine-upgrade and AIO plugin using otopi.
*   (SHOULD) [Features/Self_Hosted_Engine](/develop/release-management/features/engine/self-hosted-engine/) The ability to run the Engine as a VM on the hosts that are managed by this Engine, in an HA configuration, when the Engine VM can start on any of the hosts.

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
*   Frontend Clean-up/Refactoring (at least partial/first phase) [Features/Design/FrontendRefactor](/develop/release-management/features/ux/frontendrefactor/)
*   Upgrade Google Web Toolkit & related framework versions

