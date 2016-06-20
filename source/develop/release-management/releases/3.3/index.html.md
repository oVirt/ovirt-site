---
title: oVirt 3.3 release notes
category: documentation
authors: alonbl, dneary, doron, fsimonce, jbrooks, lvernia, mburns, michael pasternak,
  mkolesni, yair zaslavsky
wiki_category: Documentation
wiki_title: OVirt 3.3 release notes
wiki_revision_count: 35
wiki_last_updated: 2013-10-02
---

# oVirt 3.3 release notes

The oVirt Project is pleased to announce the availability of its fourth formal release, oVirt 3.3.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## What's New in 3.3?

### OpenStack Integration

*   [Neutron Integration](Features/Quantum_Integration) adds support for using OpenStack Neutron as an external network provider, which can provide networking capabilities for consumption by oVirt hosts and/or virtual machines. For more information, watch this deep dive [presentation on oVirt / Neutron integration](http://www.youtube.com/watch?v=S16AfFylcHk).
*   [Glance Integration](Features/Glance_Integration) allows oVirt users to consume, export and share images with Glance. These images are exposed as oVirt Templates. For more information, watch this deep dive [presentation on oVirt / Glance integration](http://www.youtube.com/watch?v=_Nyi1xyiQnY).
*   [Cloud-Init Integration](Features/Cloud-Init_Integration) facilitates provisioning of virtual machines by enabling oVirt to perform initial setup (including networking, SSH keys, timezone, user data injection, and more) of guest instances configured with cloud-init.

### Enhanced Gluster Support

*   [GlusterFS Storage Domain](Features/GlusterFS_Storage_Domain) is a new storage domain and data center type which uses gluster as the storage backend. VMs created using this domain take advantage of QEMU's gluster block backend for improved performance.
    -   <div class="alert alert-info">
        This feature is currently only available on Fedora 19. We're working on a solution for EL6 and hope to have it available soon.

        </div>

*   [Gluster Hooks Management](Features/Gluster Hooks Management) allows users to manage Gluster hooks (Volume lifecycle extensions) from oVirt Engine. Read more about Gluster hooks at the [Gluster project site](http://www.gluster.org/community/documentation/index.php/Features/Hooks).

### More Extensibility Options

*   [oVirt Scheduler API](Features/Scheduling_API) allows users to implement their own private optimized schedulers y extending or modifying the default oVirt scheduler.
    -   <div class="alert alert-info">
        This feature is not included in oVirt 3.3, but will be added in an upcoming release during the 3.3 release cycle

        </div>

*   [Device Custom Properties](Features/Device Custom Properties) allow administrators to define special parameters per VM virtual device, and pass them down to vdsm hooks, as has previously been possible on a per VM basis. Device custom properties will allow, for instance, for users to connect vNICs to non-standard host networks.
*   [External Tasks Support](Features/ExternalTasks) makes it possible for a third-party plugin to inject tasks into oVirt Engine using the REST API, to change task statuses and allow them to be tracked from the UI.
*   [Backup-Restore API Integration](Features/Backup-Restore_API_Integration) provides the ability for ISVs to backup and restore VMs. A new set of APIs will be introduced in oVirt to facilitate taking full VM backup, as well as full or file level restore of VMs.
*   Support for Branding the oVirt Management Console
*   [Java-SDK](Features/Java_SDK) is an auto-generated software development kit for the oVirt engine api.
*   [Disk Hooks](Features/Disk_Hooks) adds VDSM hooking points before and after disk hot plug and hot unplug events, enabling the running of guest-level operations on the disks when they're plugged/unplugged.

### Other Enhancements

#### Virt

*   [RAM Snapshots](Features/RAM Snapshots) enable users to save (and later restore) the memory state of a VM when creating a live snapshot.
*   [noVNC console](Features/noVNC console) integration makes it possible to connect to VM consoles using the HTML 5 VNC client called "noVNC" in browsers supporting websockets and the HTML5 postMessage function (webkit browsers, Firefox, IE > 10).

#### Infra

*   [SuperVDSM Service](Features/Supervdsm_service) enables Vdsm to be run as an unprivileged daemon, thereby simplifying the handling of crashes and the process of re-establishing communication between Vdsm and Supervdsm after failures.
*   [Public Key SSH Authentication](Features/Ssh_Abilities) is now available as a means of conducting authentication for host-deploy and node upgrade operations, supplementing the existing user/password mechanism.
*   [Java SDK (Software Development Kit)](Features/JavaSDK) is now available.

#### Networking

*   [Migration Networks](Features/Migration Network) enable administrators to assign networks for carrying migration data.
*   [Normalized ovirtmgmt Initialization](Features/Normalized ovirtmgmt Initialization) involves generating the ovirtmgmt network based on DC definitions using the setupNetworks function, rather than during new host deployment.
*   [Feature/NetworkReloaded](Feature/NetworkReloaded) reimplementation of configNetwork in vdsm. Should have zero (0) effect on users, but required for future support for ovs/NM
*   [Multiple Gateways](Features/Multiple Gateways) allows users to define a gateway per logical network, where, previously, the gateway defined on the ovirtmgmt logical network had been treated as the host-wide default gateway.

#### Storage

*   [Online Virtual Drive Resize](Features/Online_Virtual_Drive_Resize) allows oVirt users to resize virtual disks while they are in use by one or more virtual machines without the need of pausing, hibernating or rebooting the guests.
*   [Virtio-SCSI](Features/Virtio-SCSI) is a new para-virtualized SCSI controller device which provides the same performance as the virtio-blk device, while improving scalability, supporting standard SCSI command sets and device naming, allowing for SCSI device passthrough.
*   [ Read Only Disk](Features/Read_Only_Disk) enables users to assign a read-only property to the VM-Disk relationship when adding/attaching a disk to a vm through the oVirt engine.
*   [Manage Storage Connections](Features/Edit_Connection_Properties) adds the ability to add, edit and delete storage connections. The new connection details must match those of the original connection. For example, an NFS storage connection cannot be edited to point to iSCSI.
*   [MoveAsCopyAndDelete](Features/MoveAsCopyAndDelete) splits disk moving operations in oVirt into separate copy and delete operations, where, previously, they had been carried out by vdsm in a single operation. This change improves availability and error-handling.
*   Allow resign/force re-election of SPM
*   [Disks Block Alignment](Features/DiskAlignment) provides a way in oVirt to find virtual disks with misaligned partitions.

#### SLA & Scheduling

*   [Features/oVirt_scheduler](Features/oVirt_scheduler) Wrapping scheduling functionalities as a separate package
*   [Watchdog Engine Support](Features/Watchdog_engine_support) adds support for watchdog devices to oVirt Engine.
*   [Network QoS](Features/Network_QoS) allows users to limit the inbound and outbound network traffic at the virtual NIC level.
*   [Trusted Compute Pools](Trusted_compute_pools) provide a way for administrators to deploy VMs on trusted hosts.

#### Node

*   [Universal Node Image](Features/Universal Image) converts the oVirt Node image into a generic image that can be customized for many different projects using Node Plugins.
*   [Node VDSM Plugin](Features/Node vdsm plugin) converts the generic oVirt Node image into an image customized use with oVirt Engine.
*   oVirt Node works on a different asynchronous release schedule from the rest of oVirt.
    -   At the time of the oVirt 3.3 release, the current version of ovirt-node will be 3.0.1.
    -   Feature for oVirt node 3.0.0 can be found on the [oVirt Node 3.0.0 release page](Node_3.0_release-management)

#### Integration

*   [Otopi Infra Migration](Features/Otopi_Infra_Migration) involves a complete rewrite of the engine-setup, engine-cleanup, engine-upgrade and All-in-One plugin using otopi.
*   [Self Hosted Engine](Features/Self_Hosted_Engine) enables administrators to run the Engine as a VM on the hosts that are managed by this Engine, in an HA configuration, when the Engine VM can start on any of the hosts.
    -   <div class="alert alert-info">
        This feature is not included in oVirt 3.3, but will be added in an upcoming release

        </div>

#### UX Enhancements

*   User Portal performance improvements for IE8
*   [Frontend Clean-up/Refactoring](Features/Design/FrontendRefactor)

### Deep dives

In anticipation of the 3.3 release, a number of deep dive presentations into 3.3 features are being prepared.

*   Deep Dive Into Host Power Management ![ slides](PM-deep-dive.odp  "fig: slides") [recording](https://sas.elluminate.com/p.jnlp?psid=2013-07-29.0638.M.0095240B0C736D2B11BF860A1F0376.vcr&sid=819)
*   OpenStack Glance (Image) Integration Deep Dive ![Slides](Ovirt-2013-glance-integration-deep-dive.pdf "fig:Slides") [Recording](https://sas.elluminate.com/p.jnlp?psid=2013-07-30.0631.M.46676CB153495B16DF1807973906F0.vcr&sid=819)
*   OpenStack Neutron (Network) Integration Deep Dive ![](Ovirt-neutron-integration-deep-dive-2013.pdf "fig:Ovirt-neutron-integration-deep-dive-2013.pdf") [Recording](https://sas.elluminate.com/p.jnlp?psid=2013-07-31.0603.M.EE511E1083BCFC4B7C7A2454800447.vcr&sid=819)
*   Async Task Manager changes for oVirt 3.3 Deep Dive ![](Async_task_mgr_23_july_2013_ovirt_final.odp "fig:Async_task_mgr_23_july_2013_ovirt_final.odp")
*   Network QoS / vNIC Profiles presentation ![](VNIC_Profiles.odp "fig:VNIC_Profiles.odp")
*   Scheduling in oVirt 3.3 deep dive ![](Scheduler-Deep-Dive-oVirt.pdf "fig:Scheduler-Deep-Dive-oVirt.pdf")
*   Hosted engine deep dive ![](Hosted Engine Deep Dive.pdf "fig:Hosted Engine Deep Dive.pdf")
*   Packaging ![](ovirt 3.3 - packaging.pdf "fig:ovirt 3.3 - packaging.pdf")

<Category:Documentation> <Category:Releases>
