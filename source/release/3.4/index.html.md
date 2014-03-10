---
title: OVirt 3.4 Release Notes
category: documentation
authors: bproffitt, derez, knesenko, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.4 Release Notes
wiki_revision_count: 28
wiki_last_updated: 2014-07-21
---

# OVirt 3.4 Release Notes

DRAFT DRAFT DRAFT

The oVirt Project is pleased to announce the availability of its fifth formal release, oVirt 3.4.

oVirt is an open source alternative to VMware vSphere, and provides an excellent KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3 release notes](oVirt 3.3 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## What's New in 3.4?

### Hosted Engine

*   oVirt 3.4 features [hosted engine](Hosted_Engine_Howto), which enables oVirt engine to be run as a virtual machine (VM) on the host it manages. Hosted engine solves the chicken-and-the egg problem for users: the basic challenge of deploying and running an oVirt engine inside a VM. This clustered solution enables users to configure multiple hosts to run the hosted engine, ensuring the engine still runs in the event of any one host failure.

### Enhanced Gluster Support

*   [Gluster Volume Asynchronous Tasks Management](Features/Gluster Volume Asynchronous Tasks Management) enables users to re-balance volumes and remove bricks In Gluster operations/rebalance and remove bricks in Gluster volumes.

### Preview: PPC64

*   [Engine Support for PPC64](Features/Engine_support_for_PPC64) will add PPC64 architecture awareness to the ovirt-engine code, which currently makes various assumptions based on the x86 architecture. When specifying virtual machine devices, for example, what is suitable for x86 architecture may not be for POWER (or may not be available yet).
*   [VDSM Support for PPC64](Features/Vdsm_for_PPC64) introduces the capability of managing KVM on IBM POWER processors via oVirt. Administrators will be able to perform management functionalities such as adding or activating KVM, creating clusters of KVM and performing VM lifecycle management on any IBM POWER host.
    -   <div class="alert alert-info">
        Migration is still a work in progress for KVM on IBM POWER processor.

        </div>

### Preview: Hot-plug CPUs

oVirt 3.4 adds a preview of a [Hot-plug CPU](Hot_plug_cpu) feature that enables administrators to ensure customer's service-level agreements are being met, the full utilization of spare hardware, and the capability to dynamically to scale vertically, down or up, a system's hardware according to application needs without restarting the virtual machine.

### Other Enhancements

#### Virt

*   [Guest Agents for openSUSE](Feature/GuestAgentOpenSUSE) and [Ubuntu](Feature/GuestAgentUbuntu) provide ovirt-guest-agent packages for these Linux distributions.
*   [SPICE Proxy](Features/Spice_Proxy) lets the users define a proxy that will be used by SPICE client to connect to the guest. It is useful when the user (e.g., using user portal) is outside of the network where the hypervisors reside.
*   [SSO Method Control](Features/SSO_Method_Control) enables users to switch between various SSO methods in the UI. The first version of the patch only allows switching between guest agent SSO (current approach) and disabling SSO.
*   [Init Persistent](Features/vm-init-persistent) allows persistent use of Windows Sysprep and Cloud-Init data to the Database. By persisting the data, administrators can create a template with VM-Init data that will enable initialize VMs with relevant data.
*   [Guest Reboot](Features/Guest_Reboot) enable users to restart VMs with single command.
*   [Template Versioning](Features/Template_Versions) enables adding new versions to existing templates, by either selecting a VM and using it to create a new version of a template or by editing a template, and when saving, selecting Save As Version.

#### Infra

*   [oVirt Engine SNMP Traps](Features/engine-snmp) extends events notifier capabilities and enables oVirt to generate SNMP traps out of system events to integrate oVirt with generic monitoring systems.
*   [Authentication & Directory rewrites](Features/Authentication-Rewrite) allow re-implementation of Authentication and Directory support within oVirt, which is currently based on Kerberos and "internal" user for authentication, and on LDAP and the database (for internal domains).

#### Networking

*   [Network Labels](Features/NetworkLabels) provides the ability to label networks and to use that label on the host's interfaces, so the label abstracts the networks from the physical interface/bond (which can be labelled with one or more labels).
*   [Predictable vNIC Order](Feature/Predictable_vNIC_Order) resolves the usual mess in MAC address and PCI address mapping when adding a virtual NIC to an oVirt guest by making in-guest order of NICs predictable, depending their visual order.
*   [OpenStack Neutron integration](Features/Detailed_OSN_Integration) will give users the ability to use various technologies that OpenStack Neutron provides for its networks, such as IPAM, L3 routing, and security groups, as well as the capability to use technologies not natively supported in oVirt for VM networks.
    -   <div class="alert alert-info">
        This feature still does not include migration for security groups, which will be added in an upcoming release during the 3.4 release cycle.

        </div>

*   [Adding iproute2 support](Feature/NetworkReloaded), creating a network backend from iproute2 tools, following the internal API.
    -   <div class="alert alert-info">
        This feature is still partially implemented, and will be completed in an upcoming release during the 3.4 release cycle.

        </div>

*   [Multi-Host Network Configuration](Features/MultiHostNetworkConfiguration) allows the administrator to modify a network (i.e., VLAN-id or MTU) that is already provisioned by the hosts and to apply the network changes to all of the hosts within the datacenter to which the network is assigned. The feature will be enabled for 3.1 datacenters and above, regardless of cluster level in order to avoid inconsistency between hosts network configuration in various clusters.

#### Storage

*   [Read Only Disk for Engine](Features/Read_Only_Disk) gives Engine the read-only disk capability already found in VDSM.
*   [Single-disc Snapshot](Features/Single_Disk_Snapshot) enables the creation of a customized snapshot, allowing the user to select from which disks to take a snapshot.

#### SLA & Scheduling

*   [VM Affinity](Features/VM-Affinity) makes it possible to apply Affinity and Anti-Affinity rules to VMs to manually dictate scenarios in which VMs should run together on the same, or separately on different hypervisor hosts.
*   [Power off capacity added to power policy](Features/HostPowerManagementPolicy) enables hosts to be shutdown and have the Engine clear the host to migrate all VMs elsewhere.
*   [Even VM distribution based on VM count per host](Features/Even_VM_Count_Distribution) provides a cluster policy that evenly distributes VMs based on VM count.
*   [High Availability VM Reservation](Features/HA_VM_reservation) serves as a mechanism to ensure appropriate capacity exists within a cluster for HA VMs in the event the host they currently resides on fails unexpectedly.
*   [Self Hosted Engine Maintenance Flows](Features/Self_Hosted_Engine_Maintenance_Flows) reports additional information about the hosted engine system to the engine, allowing the engine to control the hosted engine maintenance modes.

#### UX Enhancements

*   [UI Refresh Synchronization](Features/Design/UIRefreshSynchronization) solves UI consistency issues related to the UI not being updated when certain actions/events happen by centralizing the refresh logic.
*   [Lower Resolution Support](Features/Design/UIRefreshSynchronization) repairs the issue of lower resolutions causing the tab bar and action menu wrap overlapping other UI elements by adding a scrollable tab bar for the tabs and a cascading menu bar for the action menu.

<Category:Documentation> <Category:Releases>
