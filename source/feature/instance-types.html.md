---
title: Instance Types
category: feature
authors: acathrow, ofrenkel, tjelinek
wiki_category: Feature
wiki_title: Features/Instance Types
wiki_revision_count: 132
wiki_last_updated: 2015-01-12
---

# Instance Types

### Summary

Enhancing oVirt template model to allow for more flexible options in creating virtual machines targeted at improving self service for the private cloud use cases.

*   Allow administrators to define hardware profiles (“Instance Types” or “Flavours”)
*   Allow administrators to define and publish images (similar to amazon AMIs or OpenStack images)
*   Allow administrators and users, based on permissions, to create virtual machines from pre-defined images and hardware profiles.

### Owner

*   Name: [Omer Frenkel](User:ofrenkel)
*   Email: <ofrenkel@redhat.com>
*   PM Requirements : [Andrew Cathrow](User:ACathrow)
*   Email: <acathrow@redhat.com>

### Current status

*   Target Release: 3.3
*   Status: under design and discussion.

### Detailed Description

In oVirt 3.1 the template definition includes both the hardware configuration and the image To support more cloud use cases we wish to separate the hardware configuration of the virtual machine from the actual image type.

In a *cloud* use case the typical flow involves a user selecting the hardware configuration (for example “Small” and the image (eg. RHEL 6.3 Web server”).

The current model used by oVirt forces a user to select a template that includes both the hardware configuration and the image type.

#### Background

In many cloud platforms the following concepts and terminology are used:

**Instance Type (or flavor)**
Used to describe the hardware configuration of the virtual machines.
For example “medium” including 1 virtual CPU and 4GB of memory.

**Image**
Used to describe the virtual machine disk image. (Amazon uses the term AMI) This is the based operating system image including applications. The image is stateless, any changes made to the image.
For example “Windows 2008R2 with SQLServer”

**Volume**
Used to describe a persistent disk that is attached to a virtual machine. Volumes are optional - a virtual machine might run in a completely stateless fashion with no attached volumes.

In these environments when provisioning a virtual machine a user picks an instance type/flavor and an image, combining the two to create running instance.

Typically the image is stateless, when the virtual machine is stopped all changes are lost. A user can add volumes to the virtual machines, which are persistent disks typically used as a data disk.

#### Design

The following table enumerates all the fields involved and also how they are related to the entities. The specific columns means:

*   **Avail**: available for the entity
*   **Comm**: comment for the entity
*   **Perms**: new permissions needed
*   **Adv Only**: the new VM dialog will contain a button "Advanced Options". If the field is marked as Adv Only: Y than it is visible only after clicking this button
*   **Basic User**: if the user is not an admin user, only the fields which are marked as Basic User: Y will be editable for him
*   **Marked**: if Y, it means the field is "special" and if the user changes it, the instance type will change to "custom"
*   **On Create**: default value when creating the VM

If a value in a line is a 'D', it means it is deprecated.

| Field name                | Description                                  | Template | Image | Instance Type | VM    |
|---------------------------|----------------------------------------------|----------|-------|---------------|-------|
|                           |                                              | Avail    | Comm  | Avail         | Perms |
| vm_guid                  | Internal unique ID                           | Y        |       | Y             |       |
| vm_name                  | name set by user for vm and template         | N        |       | Y             |       |
| mem_size_mb             | Memory Size                                  | Y        |       | N             |       |
| vmt_guid                 | Internal link to template object             | N        |       | N             |       |
| OS                        | Operating System Type                        | Y        |       | Y             |       |
| description               | description set by user for vm and template  | Y        |       | Y             |       |
| vds_group_id            | vm cluster                                   | Y        |       | N             |       |
| domain                    | directory services domain                    | Y        |       | N             |       |
| creation_date            | internal. creation date                      | N        |       | N             |       |
| num_of_monitors         | number of monitors                           | Y        |       | N             |       |
| is_initialized           | internal. mark if vm was syspreped           | N        |       | N             |       |
| is_auto_suspend         | legacy from auto-suspend feature, not in use | D        |       | D             |       |
| num_of_sockets          | umber of sockets                             | Y        |       | N             |       |
| cpu_per_socket          | cpu per socket                               | Y        |       | N             |       |
| usb_policy               | usb policy                                   | Y        |       | N             |       |
| time_zone                | time zone                                    | Y        |       | N             |       |
| is_stateless             | stateless flag                               | Y        |       | N             |       |
| fail_back                | legacy from fail-back feature, not in use    | D        |       | D             |       |
| dedicated_vm_for_vds   | specific host for running vm                 | Y        |       | N             |       |
| auto_startup             | HA                                           | Y        |       | N             |       |
| vm_type                  | vm type (server/desktop)                     | Y        |       | N             |       |
| nice_level               | vm nice level                                | Y        |       | N             |       |
| default_boot_sequence   | boot sequence                                | Y        |       | N             |       |
| default_display_type    | display type                                 | Y        |       | N             |       |
| priority                  | priority                                     | Y        |       | N             |       |
| iso_path                 | cd                                           | Y        |       | Y             |       |
| origin                    | internal. where the vm was created           | N        |       | N             |       |
| initrd_url               | boot params                                  | Y        |       | Y             |       |
| kernel_url               | boot params                                  | Y        |       | Y             |       |
| kernel_params            | boot params                                  | Y        |       | Y             |       |
| migration_support        | migration support options                    | Y        |       | N             |       |
| userdefined_properties   | custom properties                            | Y        |       | Y             |       |
| min_allocated_mem       | memory guaranteed                            | Y        |       | N             |       |
| child_count              | internal. for template, not in use?          | N        |       | N             |       |
| quota_id                 | link to quota                                | N        |       | N             |       |
| allow_console_reconnect | allow reconnect to console                   | Y        |       | N             |       |
| cpu_pinning              | cpu pinning                                  | N        |       | N             |       |
| is_smartcard_enabled    | smartcard enabled                            | Y        |       | N             |       |
| payload                   | payload (device, not in vm_static)          | Y        |       | N             |       |
| storage domain            |                                              |          |       |               |       |
| thin/clone                |                                              |          |       |               |       |
| sysprep                   |                                              |          |       |               |       |
| soundcard                 | payload (device, not in vm_static)          | N        |       | N             |       |
| Balloon                   | payload (device, not in vm_static)          | N        |       | N             |       |
| network interface         | binding of NIC to logical network            | N        |       | N             |       |
| instance_type_id        | internal. link to vm's instance type         | N        |       | N             |       |
| image_type_id           | internal. link to vm's image type            | N        |       | N             |       |
| host_cpu_flags          | use host cpu flags                           | N        |       | N             |       |
| db_generation            | internal                                     | N        |       | N             |       |
| is_delete_protected     | protection from accidental deletion          | Y        |       | N             |       |
| is_disabled              | disabled-template (for templates only)       | N        |       | N             |       |

**Instance Types (Flavors)**
Expose a new top level entity with the API and GUI for *Instance Type*
This entity will represent the hardware profile for a virtual machine.
An Instance type should have a name and description (the period should be supported in the name).

We should support leaving the logical network empty, since this may be overridden by the user when the virtual machine is deployed.
 Virtual disks should not be included in the instance configuration.
 A user should be able to create an instance type using a dialog similar to the *new server/desktop* dialog. Here a user should be able to define their instance configuration.
 A new set of permissions should be created:
\* Create Instance

*   Instance Owner -
*   Can delegate Instance owner or VMuser permission
    -   Can Add/Remove disks
    -   Can Add/Remove NICS
    -   Edit instance (VM) for a limited set of parameters (outlined below in new VM flow)

**Predefined Instance Types**
A set of predefined instance types should be created.
For consistency we should use the default OpenStack sizes.
A user should be allowed to edit but not delete predefined instance types
The administrator should be able to disable instance types.

| Name      | Memory | vCPUs |
|-----------|--------|-------|
| m1.tiny   | 512 MB | 1     |
| m1.small  | 2 GB   | 1     |
| m1.medium | 4 GB   | 2     |
| m1.large  | 8 GB   | 2     |
| m1.xlarge | 16 GB  | 4     |

**Extra Instance Metadata**
 Within the design of the instance entity we should bear in mind that in the future we may need to incorporate elements from the SLA/QoS work.
None of these are appropriate for the 3.2 release.
 For example adding quality of service parameters.
As a point of reference OpenStack includes parameters such as “rxtx quota” that allows the administrator to cap the maximum amount of network I/O permitting (for example an ISP capping a customer to 5GB).
Other use cases include specifying storage I/O priorty, network capping and throttling.

**Templates (Images)**
The existing template mechanism can be used to handle *image types*.

**Permissions**
A new permission *Create instance* should be added
This permission will allow a user to create a new virtual machine from an existing instance.
This permission will *not* permit a user to edit the virtual machines instance configuration only to use an existing instance definition.

#### User workflow

*   Change VM tab to expose “New VM” button that replaces the existing “New Server” and “New Desktop”

<!-- -->

*   When the user selects New VM they are prompted with a dialog where they enter for following details
    -   Data Center
    -   Cluster
        -   **TBD : Do we combined Data Center and Cluster to a single field ?**
    -   Virtual Machine name
    -   Description
    -   Instance type
    -   Template / Image Type
    -   Stateless Image (default is not stateless).
        \* Provide a cluster setting allowing configuration of the default image state handling - eg. stateful or stateless
        -   Note: The stateless setting is for the image (template disks) not for the whole virtual machine.

For example: A template has a 10GB disk containing the operating system. If the user specifies that the image is stateless then the template disk will be treated as stateless, however if the user adds another disk (aka a volume to the virtual machine that disk will be treated as stateful.

*   Selecting blank template should be supported.
*   -   This allows users to have no image disk and rely either on diskless images (eg PXE based) or boot from an attached volume.

<!-- -->

*   On the next dialog(s) the user should be able to override some of the configuration options within the Instance type including :
    -   Optimized for desktop or server workload
*   All configuration options listed below (including # monitors) should be supported for servers and desktops
    -   Console type (spice/vnc/etc)
    -   Number of monitors
    -   USB Support
    -   Smartcard
    -   Soundcard - including type
    -   High availability (including priority) for both server and desktop workloads
    -   **Question : Should any other options should be added based on SLA work?**
    -   User data (VM Payload)
    -   Boot from network
    -   For each network defined on the instance the user should be prompted to set the logical network.
    -   **Question: Should we have a default network define per cluster?**

<!-- -->

*   On the final dialog the user should be presented with an advanced button that launches the traditional new virtual machine dialog
    -   This option will only be available if a user has the permission to create a virtual machine not the (new) permission to create an instance.

In the advanced view the user should be able to override all settings of the virtual machine
Any advanced changes (outside of the basic overrides described) will change the instance type to “Custom ..” to indicate that the virtual machine is not based on one of the define instance types.
 On selecting finish the virtual machine will be created
Based on permissions the user should be able to add disks (volumes) and nics to the virtual machine using the existing disks and networks sub-tabs.
 We should prevent adding and removing logical networks?
We should we prevent editing or removing template disks?
 **Runtime**

When a virtual machine is run the complete configuration should be constructed in the following method:
\* The instance type is used to provide the hardware configuration for the VM.

*   -   This setting should be applied at runtime not at configuration time
    -   If an instance type is updated (eg. added 2GB of memory) then the next time this VM is launched it should pickup the new instance configuration

\* The operating system type and disks are taken from the template

*   -   No other settings from the template are used
    -   If the VM is set to be stateless then the disks from the template are set to be stateless.
    -   Note: For stateless disks the image are applied at run time not at the time that the virtual machine was define.
    -   If a template is updated then the next time a stateless VM is run from this template then the image will be updated

<!-- -->

*   Extra disks that are defined at the VM level are added to the VM.

 We should allow changing the instance type on a VM that is down
\* for example: changing vm from instance type 'medium' to 'large' or to 'custom' (which allow user editing all fields)
\* this sounds reasonable but there is a problem with some fields which are defined in instance-type,
if we have defaults for server and desktops (clone disks vs. thin allocation),
changing instance type will not take affect on this.

#### REST API

TBD as soon as the specific requirements will be clarified

<Category:Feature> <Category:Template>
