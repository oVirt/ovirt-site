---
title: Instance Types
category: feature
authors:
  - acathrow
  - ofrenkel
  - tjelinek
---

# Instance Types

## Summary

Enhancing oVirt template model to allow for more flexible options in creating virtual machines targeted at improving self service for the private cloud use cases.

*   Allow administrators to define hardware profiles (“Instance Types” or “Flavours”)
*   Allow administrators to define and publish images (similar to amazon AMIs or OpenStack images)
*   Allow administrators and users, based on permissions, to create virtual machines from pre-defined images and hardware profiles.

## Owner

*   Name: Omer Frenkel (ofrenkel)
*   Email: <ofrenkel@redhat.com>
*   Name: Tomas Jelinek (TJelinek)
*   Email: <TJelinek@redhat.com>
*   PM Requirements : Andrew Cathrow (ACathrow)
*   Email: <acathrow@redhat.com>

## Current status

*   Target Release: 3.5
*   Status: instance types implemented, images on review

## Background

In oVirt 3.1 the template definition includes both the hardware configuration and the image To support more cloud use cases we wish to separate the hardware configuration of the virtual machine from the actual image type.

In a *cloud* use case the typical flow involves a user selecting the hardware configuration (for example “Small” and the image (eg. RHEL 6.3 Web server”).

The current model used by oVirt forces a user to select a template that includes both the hardware configuration and the image type.

In many cloud platforms the following concepts and terminology are used:

**Instance Type (or flavor)**
Used to describe the hardware configuration of the virtual machines.
For example “medium” including 1 virtual CPU and 4GB of memory. It will be a top-level entity (e.g. not bound to any DC/Cluster). It could be by default enabled/disabled and than this enable/disable overridden per cluster. For example an instance type named "Huge" could be by default disabled and enabled only for a one specific cluster.

**Image**
In case of oVirt the image is just a disk containing anything. The user can decide if create a new writable one (some providers call it volume) or attach an existing one (some providers call it image).

**Template**
The old template used in the oVirt until now.

**VM**
The VM is a combination of the triple instance type, image and template (while any of this three can be empty). For details on where the specific fields will come from please see the detailed table: [Instance Types Design](/develop/release-management/features/virt/instance-types.html#design)

## Design

The following table enumerates all the fields involved and also how they are related to the entities.

The specific columns means:

*   **Present**: this field is present on the entity for user editing
*   **Comm**: comment for the entity
*   **Perms**: new permissions needed
*   **Adv Only**: the new VM dialog will contain a button "Advanced Options". If the field is marked as Adv Only: Y than it is visible only after clicking this button
*   **Basic User**: The basic user is a user which has only the *Instance Creator* role (and not the *Vm Creator*). This user is meant only to create a VM from a non-custom (e.g. non empty) instance type and is allowed to edit only the fields marked as Basic User: Y
*   **Marked**: if Y, it means this field is crucial to the instance type definition and if the user changes it, the instance type will change to "custom" (e.g. the VM is not based on that instance type anymore). If a field with Marked: Y is changed on the instance type, it is changed also on all the VMs derived from the instance type. If the field with Marked: N is changed on the instance type, it is not changed on the VMs derived from this instance.
*   **On Create**: where the value is coming from when creating a VM (in order of precedence).

The specific values means:

*   **Y**: yes
*   **N**: no
*   **D**: deprecated
*   **Not in GUI**: not directly editable from GUI. Either not editable at all or gets the value indirectly (e.g. from to selected OS)
*   **Values for On Create**: *User* = user to fill it, *Instance* = copied from instance type, *Image* = copied from image, *empty* = empty

| Field name                | Description                                  | Template | Instance Type | VM      |
|---------------------------|----------------------------------------------|----------|---------------|---------|
|                           |                                              | Present  | Comm          | Present |
| vm_guid                   | Internal unique ID                           | N        |               | N       |
| vm_name                   | name set by user for vm and template         | Y        |               | Y       |
| mem_size_mb               | Memory Size                                  | Y        |               | Y       |
| vmt_guid                  | Internal link to template object             | N        |               | N       |
| OS                        | Operating System Type                        | Y        |               | N       |
| description               | description set by user for vm and template  | Y        |               | Y       |
| vds_group_id              | vm cluster                                   | Y        |               | N       |
| domain                    | directory services domain                    | D        |               | D       |
| creation_date             | internal. creation date                      | N        |               | N       |
| num_of_monitors           | number of monitors                           | Y        |               | Y       |
| is_initialized            | internal. mark if vm was syspreped           | N        |               | N       |
| is_auto_suspend           | legacy from auto-suspend feature, not in use | D        |               | D       |
| num_of_sockets            | umber of sockets                             | Y        |               | Y       |
| cpu_per_socket            | cpu per socket                               | Y        |               | Y       |
| usb_policy                | usb policy                                   | Y        |               | Y       |
| time_zone                 | time zone                                    | Y        |               | N       |
| is_stateless              | stateless flag                               | Y        |               | N       |
| fail_back                 | legacy from fail-back feature, not in use    | D        |               | D       |
| dedicated_vm_for_vds      | specific host for running vm                 | Y        |               | N       |
| auto_startup              | HA                                           | Y        |               | Y       |
| vm_type                   | vm type (server/desktop)                     | Y        |               | N       |
| nice_level                | vm nice level                                | D        |               | D       |
| default_boot_sequence     | boot sequence                                | Y        |               | Y       |
| default_display_type      | display type(SPICE, VNC)                     | Y        |               | Y       |
| priority                  | priority                                     | Y        |               | Y       |
| iso_path                  | cd                                           | Y        |               | N       |
| origin                    | internal. where the vm was created           | N        |               | N       |
| initrd_url                | boot params                                  | Y        |               | N       |
| kernel_url                | boot params                                  | Y        |               | N       |
| kernel_params             | boot params                                  | Y        |               | N       |
| migration_support         | migration support options                    | Y        |               | Y       |
| userdefined_properties    | custom properties                            | Y        |               | N       |
| predefined_properties     | custom properties                            | Y        |               | N       |
| min_allocated_mem         | memory guaranteed                            | Y        |               | Y       |
| child_count               | internal. for template, not in use?          | N        |               | N       |
| quota_id                  | link to quota                                | Y        |               | N       |
| allow_console_reconnect   | allow reconnect to console                   | Y        |               | N       |
| cpu_pinning               | cpu pinning                                  | N        |               | N       |
| is_smartcard_enabled      | smartcard enabled                            | Y        |               | Y       |
| payload                   | payload (device, not in vm_static)           | N        |               | N       |
| thin/clone                |                                              | N        |               | N       |
| soundcard                 | payload (device, not in vm_static)           | Y        |               | Y       |
| Balloon                   | payload (device, not in vm_static)           | N        |               | Y       |
| network interface         | binding of NIC to logical network            | N        |               | Y       |
| instance_type_id          | internal. link to vm's instance type         | N        |               | N       |
| image_type_id             | internal. link to vm's image type            | N        |               | N       |
| host_cpu_flags            | use host cpu flags                           | Y        |               | N       |
| db_generation             | internal                                     | N        |               | N       |
| is_delete_protected       | protection from accidental deletion          | Y        |               | N       |
| is_disabled               | disabled-template (for templates only)       | Y        |               | N       |
| vncKeyboardLayout         | VNC specific keyboard layout                 | Y        |               | N       |
| tunnelMigration           | use libvirt-to-libvirt communication         | N        |               | N       |
| migrationDowntime         | max downtime during migration                | Y        |               | Y       |
| watchdog                  | consists of model and action                 | Y        |               | Y       |
| sso method                | none or guest agent                          | Y        |               | N       |
| cpu allocation            |                                              | N        |               | N       |
| virtio-scsi               |                                              | N        |               | Y       |
| vm init                   | cloud-init or sysprep                        | N        |               | N       |

## Entities' Details

### VM

The "New Server" and "New Desktop" buttons in GUI will be replaced by a common **New VM** button with a combo box where you can choose from "Optimized for Server" and "Optimized for Desktop". The exact meaning this switch:

*   **Optimized for Server**:
    -   does not have soundcard
    -   the disk image is cloned
    -   is not stateless
*   **Optimized for Desktop**:
    -   has soundcard
    -   the image is used (thin allocation)
    -   is stateless

This are only the default values which will be present in the GUI - the user can change them.

### Image

Simply all the disks which can be attached to the VM and also the user can create new ones. It is going to be only a shortcut to the VM->Disks subtab

### Instance Types (Flavors)

A user should be able to create an instance type using a dialog similar to the **New VM** dialog. Here a user should be able to define their instance configuration.
For the exact editable field please see the table above.

**Predefined Instance Types**
A set of predefined instance types should be created.
For consistency we should use the default OpenStack sizes.
A user should be allowed to edit and delete predefined instance types
The administrator should be able to disable instance types.

| Name   | Memory | vCPUs |
|--------|--------|-------|
| tiny   | 512 MB | 1     |
| small  | 2 GB   | 1     |
| medium | 4 GB   | 2     |
| large  | 8 GB   | 2     |
| xlarge | 16 GB  | 4     |

**Extra Instance Metadata**
 Within the design of the instance entity we should bear in mind that in the future we may need to incorporate elements from the SLA/QoS work.
None of these are appropriate for the 3.5 release.
 For example adding quality of service parameters.
As a point of reference OpenStack includes parameters such as “rxtx quota” that allows the administrator to cap the maximum amount of network I/O permitting (for example an ISP capping a customer to 5GB).
Other use cases include specifying storage I/O priorty, network capping and throttling.

### Templates

The existing template mechanism can be used to handle *Images*.

## Edit VM Based on Instance Type

*   If field which is taken from instance type is changed, the VM gets detached from the instance type
*   The edit VM dialog shows the fields as they are currently configured on the VM (which may change after the restart of the VM). For example:
    -   A VM which is down is based on an instance type and it has e.g. 512 MB memory from it.
    -   The instance type gets changed increasing the memory to 1024 MB
    -   The edit VM is pressed
    -   The dialog shows that the VM is based on the instance type and it has 512 MB memory
    -   Than the dialog is closed and the VM is started and stopped again. Than the edit VM is pressed.
    -   The dialog now shows that the VM has 1024 MB memory and is still based on the same instance type

## Cluster Compatibility

Since the Instance Type is not attached to any cluster, there are no restrictions on any fields (e.g. the virtio RNG device can be picked for any instance type all the time). When building a VM on this instance type, the VM is already connected to a cluster. In case the cluster does not support some values taken from the instance type, this values are ignored and the user is still allowed to create a VM based on this instance type. For example:

*   Having an instance type with virtio RNG support enabled
*   If creating a VM on 3.4 cluster based on this instance type, a VM will be successfully created without the virtio RNG device and the VM will be connected to the instance type
*   If creating a VM on 3.5 cluster based on this instance type, a VM will be successfully created with the virtio RNG device and the VM will be connected to the instance type

## Example User Workflow

This is an example of the user workflow, how the new Instance Types approach would be used.

1: Create a new **Instance Type**: Under the configure (top right corner) a new side tab called "Instance Types" will be present. Under that a list of instance types with new/edit/delete buttons will be present (similar to the VM dialog). By pressing a "new" or "edit" button the user will be provided by the same dialog than on new/edit VM or template (with relevant fields only). 2: Create a new **Image**: In the *Virtual Machines* main tab select a VM, than click *Create Image* which will extract the image and the image specific configuration (similar to current *make template*) 3: Create a new VM: In *Virtual Machines* main tab click the "New VM" button. Select the data center, cluster, instance type, image and template. Assigns the logical network to network interfaces, than click OK. 4: Run the created VM 5: Edit *Instance Type* (e.g. added more memory to it) 6: The change is reflected also on the VM after restarting it (but this will be implemented as a separate feature - [Features/Edit Running VM](/develop/release-management/features/virt/edit-running-vm.html))

## Runtime

When a virtual machine is run the complete configuration should already been constructed
\* The instance type is used to provide the hardware configuration for the VM.

*   -   This setting should be applied at configuration not at runtime time
    -   If an instance type is updated (eg. added 2GB of memory) then the next time this VM is launched it should still run with the old configuration

\* The operating system type and disks are taken from the Image

*   -   If the VM is set to be stateless then the disks from the Image are set to be stateless
    -   Note: For stateless disks the images are applied at run time not at the time that the virtual machine was defined
    -   If an Image is updated then the next time a stateless VM is run from this Image then the image will be updated

<!-- -->

*   Extra disks that are defined at the VM level are added to the VM.

 We should allow changing the instance type on a VM that is down
\* for example: changing vm from instance type 'medium' to 'large' or to 'custom' (which allow user editing all fields)
\* this sounds reasonable but there is a problem with some fields which are defined in instance-type,
if we have defaults for server and desktops (clone disks vs. thin allocation),
changing instance type will not take affect on this.

## Permissions

New permission will be needed:

*   **Create Instance**: This permission will allow a user to create a new virtual machine from an existing instance type (but not edit the instance type itself). On the VM the user will not be allowed to use the "custom" instance type and will be able only edit the fields marked as "Basic User: Y" from the table above.

## User Interface

*   Templates:
    -   The templates should remain as-is

<!-- -->

*   Instance Types:
    -   In the "Configure" dialog the new side tab "Instance Types" should be added. It should contain a list of instnace types and the add/edit/remove buttons. If selected the subtab should contain the details of the instance type. The new/edit dialog should be similar to new/edit VM dialogs but with relevant fields only. See screenshots:

![](/images/wiki/ConfigureDialog.png)

![](/images/wiki/EditInstanceType.png)

*   Images:

In the new/edit VM dialog a new part will be added containing the attach and create buttons. They will invoke the create/attach disk dialogs.

![](/images/wiki/NoImage.png)

![](/images/wiki/WithTwo.png)

*   VM:
    -   The new/edit VM dialog will be enriched to contain also the instance type and image lists.
    -   All the fields which are bound to instance type (marked as "Marked: Y" in the table above) will have a "chain" image next to them. If the field will be the same as on the instance type, the chain will be joined. If the user choose to change this field, the chain will become separated and the instance type will change to "custom"
    -   If the user changes all the values back, the chain icon will again be joined and the instance type will move back to the one selected. See screenshots (this ones do not contain the "image" yet):

![](/images/wiki/NewVmGeneral.png)

![](/images/wiki/NewVmSystemJoined.png)

![](/images/wiki/NewVmSystemSeparated.png)

## REST API

TBD as soon as the specific requirements will be clarified

