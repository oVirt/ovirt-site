# Administrative Tasks

* [Shutting down a virtual machine](Shutting_down_a_virtual_machine)
* [Pausing a virtual machine](Pausing_a_virtual_machine)
* [Rebooting a Virtual Machine](Rebooting_a_Virtual_Machine)
* [Removing a virtual machine](Removing_a_virtual_machine)
* [Cloning a Virtual Machine](Cloning_a_Virtual_Machine)

## Updating Virtual Machine Guest Agents and Drivers

* [Updating the Guest Agents and Drivers on Red Hat Enterprise Linux](Updating_the_Guest_Agents_and_Drivers_on_Red_Hat_Enterprise_Linux)
* [Updating the Red Hat Enterprise Virtualization Guest Tools](Updating_the_Red_Hat_Enterprise_Virtualization_Guest_Tools)

<!-- end section -->

* [Viewing Satellite Errata](Viewing_Satellite_Errata)

## Virtual Machines and Permissions

* [Data center cluster entities](Data_center_cluster_entities)
* [Data center storage entities](Data_center_storage_entities)
* [Virtual Machine User Roles Explained](Virtual_Machine_User_Roles_Explained)
* [Assigning virtual machines to users](Assigning_virtual_machines_to_users)
* [Removing Access to Virtual Machines from Users](Removing_Access_to_Virtual_Machines_from_Users)

## Snapshots

* [Creating a snapshot of a virtual machine](Creating_a_snapshot_of_a_virtual_machine)
* [Using a snapshot to restore a virtual machine](Using_a_snapshot_to_restore_a_virtual_machine)
* [Creating a virtual machine from a snapshot](Creating_a_virtual_machine_from_a_snapshot)
* [Deleting a snapshot](Deleting_a_snapshot)

## Host Devices

* [Adding Host Devices to a Virtual Machine](Adding_Host_Devices_to_a_Virtual_Machine)
* [Removing Host Devices from a Virtual Machine](Removing_Host_Devices_from_a_Virtual_Machine)
* [Pinning a VM to Another Host](Pinning_a_VM_to_Another_Host)

## Affinity Groups

Virtual machine affinity allows you to define sets of rules that specify whether certain virtual machines run together on the same host or run separately on different hosts. This allows you to create advanced workload scenarios for addressing challenges such as strict licensing requirements and workloads demanding high availability.

Virtual machine affinity is applied to virtual machines by adding virtual machines to one or more affinity groups. An affinity group is a group of two or more virtual machines for which a set of identical parameters and conditions apply. These parameters include positive (run together) affinity that ensures the virtual machines in an affinity group run on the same host, and negative (run independently) affinity that ensures the virtual machines in an affinity group run on different hosts.

A further set of conditions can then be applied to these parameters. For example, you can apply hard enforcement, which is a condition that ensures the virtual machines in the affinity group run on the same host or different hosts regardless of external conditions, or soft enforcement, which is a condition that indicates a preference for virtual machines in an affinity group to run on the same host or different hosts when possible.

The combination of an affinity group, its parameters, and its conditions is known as an affinity policy. Affinity policies are applied to running virtual machines immediately, without having to restart.

**Note:** Affinity groups are applied to virtual machines on the cluster level. When a virtual machine is moved from one cluster to another, that virtual machine is removed from all affinity groups in the source cluster.

**Important:** Affinity groups will only take effect when the `VmAffinityGroups` filter module or weights module is enabled in the scheduling policy applied to clusters in which affinity groups are defined. The `VmAffinityGroups` filter module is used to implement hard enforcement, and the `VmAffinityGroups` weights module is used to implement soft enforcement.

* [Creating an Affinity Group](Creating_an_Affinity_Group)
* [Editing an Affinity Group](Editing_an_Affinity_Group)
* [Removing an Affinity Group](Removing_an_Affinity_Group)

## Exporting and Importing Virtual Machines and Templates

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the [Importing Existing Storage Domains](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide#sect-Importing_Existing_Storage_Domains) section in the *Red Hat Virtualization Administration Guide* for information on importing storage domains.

Virtual machines and templates stored in Open Virtual Machine Format (OVF) can be exported from and imported to data centers in the same or different Red Hat Virtualization environment.

To export or import virtual machines and templates, an active export domain must be attached to the data center containing the virtual machine or template to be exported or imported. An export domain acts as a temporary storage area containing two directories for each exported virtual machine or template. One directory contains the OVF files for the virtual machine or template. The other directory holds the disk image or images for the virtual machine or template.

There are three stages to exporting and importing virtual machines and templates:

1. Export the virtual machine or template to an export domain.

2. Detach the export domain from one data center, and attach it to another. You can attach it to a different data center in the same Red Hat Virtualization environment, or attach it to a data center in a separate Red Hat Virtualization environment that is managed by another installation of the Red Hat Virtualization Manager.

    **Note:** An export domain can only be active in one data center at a given time. This means that the export domain must be attached to either the source data center or the destination data center.

3. Import the virtual machine or template into the data center to which the export domain is attached.

When you export or import a virtual machine or template, properties including basic details such as the name and description, resource allocation, and high availability settings of that virtual machine or template are preserved. Specific user roles and permissions, however, are not preserved during the export process. If certain user roles and permissions are required to access the virtual machine or template, they will need to be set again after the virtual machine or template is imported.

You can also use the V2V feature to import virtual machines from other virtualization providers, such as Xen or VMware, or import Windows virtual machines. V2V converts virtual machines so that they can be hosted by Red Hat Virtualization. For more information on installing and using V2V, see [Converting Virtual Machines from Other Hypervisors to KVM with virt-v2v](https://access.redhat.com/articles/1351473).

**Important:** Virtual machines must be shut down before being exported or imported.

* [Performing an exportimport of virtual resources](Performing_an_exportimport_of_virtual_resources)
* [Exporting individual virtual machines to the export domain](Exporting_individual_virtual_machines_to_the_export_domain)
* [Importing the virtual machine into the destination data center](Importing_the_virtual_machine_into_the_destination_data_center)
* [Importing a Virtual Machine from a VMware Provider](Importing_a_Virtual_Machine_from_a_VMware_Provider)
* [Importing a Virtual Machine from Xen](Importing_a_Virtual_Machine_from_Xen)

## Migrating Virtual Machines Between Hosts

Live migration provides the ability to move a running virtual machine between physical hosts with no interruption to service. The virtual machine remains powered on and user applications continue to run while the virtual machine is relocated to a new physical host. In the background, the virtual machine's RAM is copied from the source host to the destination host. Storage and network connectivity are not altered.

* [Live migration prerequisites](Live_migration_prerequisites)
* [Optimizing Live Migration](Optimizing_Live_Migration)
* [Automatic virtual machine migration](Automatic_virtual_machine_migration)
* [Preventing automatic migration of a virtual machine](Preventing_automatic_migration_of_a_virtual_machine)
* [Manually migrating virtual machines](Manually_migrating_virtual_machines)
* [Setting migration priority](Setting_migration_priority)
* [Cancelling ongoing virtual machine migrations](Cancelling_ongoing_virtual_machine_migrations)
* [Event and Log Notification upon Automatic Migration of Highly Available Virtual Servers](Event_and_Log_Notification_upon_Automatic_Migration_of_Highly_Available_Virtual_Servers)

## Improving Uptime with Virtual Machine High Availability

* [What is high availability](What_is_high_availability)
* [Why use high availability](Why_use_high_availability)
* [High availability considerations](High_availability_considerations)
* [Configuring a highly available virtual machine](Configuring_a_highly_available_virtual_machine)

## Other Virtual Machine Tasks

* [Enabling SAP monitoring for a virtual machine from the Administration Portal](Enabling_SAP_monitoring_for_a_virtual_machine_from_the_Administration_Portal)

### Configuring Red Hat Enterprise Linux 5.4 and Higher Virtual Machines to use SPICE

SPICE is a remote display protocol designed for virtual environments, which enables you to view a virtualized desktop or server. SPICE delivers a high quality user experience, keeps CPU consumption low, and supports high quality video streaming.

Using SPICE on a Linux machine significantly improves the movement of the mouse cursor on the console of the virtual machine. To use SPICE, the X-Windows system requires additional QXL drivers. The QXL drivers are provided with Red Hat Enterprise Linux 5.4 and newer. Older versions are not supported. Installing SPICE on a virtual machine running Red Hat Enterprise Linux significantly improves the performance of the graphical user interface.

**Note:** Typically, this is most useful for virtual machines where the user requires the use of the graphical user interface. System administrators who are creating virtual servers may prefer not to configure SPICE if their use of the graphical user interface is minimal.

* [Configuring qxl drivers on virtual machines](Configuring_qxl_drivers_on_virtual_machines)
* [Configuring a virtual machines tablet and mouse to use SPICE](Configuring_a_virtual_machines_tablet_and_mouse_to_use_SPICE)

<!-- end ### section -->

* [KVM virtual machine timing management](KVM_virtual_machine_timing_management)
