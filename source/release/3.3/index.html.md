---
title: OVirt 3.3 release notes
category: documentation
authors: alonbl, dneary, doron, fsimonce, jbrooks, lvernia, mburns, michael pasternak,
  mkolesni, yair zaslavsky
wiki_category: Documentation
wiki_title: OVirt 3.3 release notes
wiki_revision_count: 35
wiki_last_updated: 2013-10-02
---

# OVirt 3.3 release notes

*This is the page where we are creating the draft release notes for the upcoming oVirt 3.3 release. The features listed here are from the oVirt 3.3 [ release planning page](oVirt 3.3 release-management), and require checking to ensure that they will be included in the release, as well as short descriptions.*

The oVirt Project is pleased to announce the availability of its fourth formal release, oVirt 3.3.

## What's New in 3.3?

The oVirt 3.3 release includes these notable changes.

#### Virt

*   [Features/RAM Snapshots](Features/RAM Snapshots)
*   [Features/noVNC console](Features/noVNC console)
*   [Features/GlusterFS_Storage_Domain](Features/GlusterFS_Storage_Domain)
*   [Features/Cloud-Init_Integration](Features/Cloud-Init_Integration)

#### Infra

*   [Features/Device Custom Properties](Features/Device Custom Properties)
*   [Features/ExternalTasks](Features/ExternalTasks)
*   [Features/Supervdsm_service](Features/Supervdsm_service)
*   [Features/Java_SDK](Features/Java_SDK)
*   [Features/Ssh_Abilities](Features/Ssh_Abilities)

#### Networking

*   [Features/Migration Network](Features/Migration Network)
*   [Features/Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization)
*   [Features/Quantum_Integration](Features/Quantum_Integration)
*   [Feature/NetworkReloaded](Feature/NetworkReloaded) reimplementation of configNetwork in vdsm. Should have zero (0) effect on users, but required for future support for ovs/NM
*   [Features/Multiple Gateways](Features/Multiple Gateways) configure more gateways on host, on top of the default one.

#### Storage

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

#### SLA & Scheduling

*   [Features/oVirt_scheduler](Features/oVirt_scheduler) Wrapping scheduling functionalities as a separate package
*   [Features/Scheduling_API](Features/Scheduling_API) (depends on [Features/oVirt_scheduler](Features/oVirt_scheduler)) exposing user-level scheduling API
*   [Features/Watchdog_engine_support](Features/Watchdog_engine_support)
*   [Features/Network_QoS](Features/Network_QoS)
*   [Trusted_compute_pools](Trusted_compute_pools)

#### Gluster

*   [Features/Gluster Hooks Management](Features/Gluster Hooks Management) Managing gluster hooks from console
    -   Status : In Progress
    -   gerrit :
        -   <http://gerrit.ovirt.org/#/q/project:ovirt-engine+branch:master+topic:gluster-hooks,n,z>
        -   <http://gerrit.ovirt.org/#/c/14145>

#### Node

*   [Universal Node Image](Features/Universal Image) make the ovirt-node image generic for use with non-oVirt Projects
*   [Node VDSM Plugin](Features/Node vdsm plugin) extract all vdsm and oVirt Engine specific code from ovirt-node into a plugin
*   oVirt Node works on a different asynchronous release schedule from the rest of oVirt.
    -   At the time of the oVirt 3.3 release, the current version of ovirt-node will be 3.0.0.
    -   Feature for oVirt node 3.0.0 can be found on the [oVirt Node 3.0.0 release page](Node_3.0_release-management)

#### Integration

*   (MUST) [Features/Otopi_Infra_Migration](Features/Otopi_Infra_Migration) A complete re-write of engine-setup, engine-cleanup, engine-upgrade and AIO plugin using otopi.
*   (SHOULD) [Features/Self_Hosted_Engine](Features/Self_Hosted_Engine) The ability to run the Engine as a VM on the hosts that are managed by this Engine, in an HA configuration, when the Engine VM can start on any of the hosts.

#### UX

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

### Deep dives

In anticipation of the 3.3 release, a number of deep dive presentations into 3.3 features are being prepared.

*   Deep Dive Into Host Power Management ![ slides](PM-deep-dive.odp  "fig: slides") [recording](https://sas.elluminate.com/p.jnlp?psid=2013-07-29.0638.M.0095240B0C736D2B11BF860A1F0376.vcr&sid=819)
*   OpenStack Glance (Image) Integration Deep Dive ![Slides](Ovirt-2013-glance-integration-deep-dive.pdf "fig:Slides") [Recording](https://sas.elluminate.com/p.jnlp?psid=2013-07-30.0631.M.46676CB153495B16DF1807973906F0.vcr&sid=819)
*   OpenStack Neutron (Network) Integration Deep Dive ![](Ovirt-neutron-integration-deep-dive-2013.pdf "fig:Ovirt-neutron-integration-deep-dive-2013.pdf") [Recording](https://sas.elluminate.com/p.jnlp?psid=2013-07-31.0603.M.EE511E1083BCFC4B7C7A2454800447.vcr&sid=819)

<Category:Releases> [Category:Release management](Category:Release management) <Category:Documentation>
