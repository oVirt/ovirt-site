---
title: Administrative Tasks

---

# Chapter 6: Administrative Tasks

## Shutting Down a Virtual Machine

**Shutting Down a Virtual Machine**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click the shut down (![](/images/vmm-guide/5035.png)) button.

    Alternatively, right-click the virtual machine and select **Shutdown**.

3. Optionally in the Administration Portal, enter a **Reason** for shutting down the virtual machine in the **Shut down Virtual Machine(s)** confirmation window. This allows you to provide an explanation for the shutdown, which will appear in the logs and when the virtual machine is powered on again.

    **Note:** The virtual machine shutdown **Reason** field will only appear if it has been enabled in the cluster settings. For more information, see "Explanation of Settings and Controls in the New Cluster and Edit Cluster Windows" in the [Administration Guide](/documentation/admin-guide/administration-guide/).

4. Click **OK** in the **Shut down Virtual Machine(s)** confirmation window.

The virtual machine shuts down gracefully and the **Status** of the virtual machine changes to `Down`.

## Suspending a Virtual Machine

Suspending a virtual machine is equal to placing that virtual machine into *Hibernate* mode.

**Suspending a Virtual Machine**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click the Suspend (![](/images/vmm-guide/5036.png)) button.

    Alternatively, right-click the virtual machine and select **Suspend**.

The **Status** of the virtual machine changes to `Suspended`.

## Rebooting a Virtual Machine

**Rebooting a Virtual Machine**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click the Reboot (![](/images/vmm-guide/5037.png)) button.

    Alternatively, right-click the virtual machine and select **Reboot**.

3. Click **OK** in the **Reboot Virtual Machine(s)** confirmation window.

The **Status** of the virtual machine changes to `Reboot In Progress` before returning to `Up`.

## Removing a Virtual Machine

**Important:** The **Remove** button is disabled while virtual machines are running; you must shut down a virtual machine before you can remove it.

**Removing Virtual Machines**

1. Click the **Virtual Machines** tab and select the virtual machine to remove.

2. Click **Remove**.

3. Optionally, select the **Remove Disk(s)** check box to remove the virtual disks attached to the virtual machine together with the virtual machine. If the **Remove Disk(s)** check box is cleared, then the virtual disks remain in the environment as floating disks.

4. Click **OK**.

## Cloning a Virtual Machine

You can clone virtual machines without having to create a template or a snapshot first.

**Important:** The **Clone VM** button is disabled while virtual machines are running; you must shut down a virtual machine before you can clone it.

**Cloning Virtual Machines**

1. Click the **Virtual Machines** tab and select the virtual machine to clone.

2. Click **Clone VM**.

3. Enter a **Clone Name** for the new virtual machine.

4. Click **OK**.

## Updating Virtual Machine Guest Agents and Drivers

### Updating the Guest Agents and Drivers on Enterprise Linux

Update the guest agents and drivers on your Enterprise Linux virtual machines to use the latest version.

**Updating the Guest Agents and Drivers on Enterprise Linux**

1. Log in to the Enterprise Linux virtual machine.

2. Update the `ovirt-guest-agent-common` package:

        # yum update ovirt-guest-agent-common

3. Restart the service:

    * For Enterprise Linux 6

            # service ovirt-guest-agent restart

    * For Enterprise Linux 7

            # systemctl restart ovirt-guest-agent.service

### Updating the Guest Agents and Drivers on Windows

The guest tools comprise software that allows oVirt Engine to communicate with the virtual machines it manages, providing information such as the IP addresses, memory usage, and applications installed on those virtual machines. The guest tools are distributed as an ISO file that can be attached to guests. This ISO file is packaged as an RPM file that can be installed and upgraded from the machine on which the oVirt Engine is installed.

**Updating the Guest Agents and Drivers on Windows**

1. On the oVirt Engine, update the oVirt Guest Tools to the latest version:

        # yum update -y ovirt-guest-tools-iso*

2. Upload the ISO file to your ISO domain, replacing `[ISODomain]` with the name of your ISO domain:

        engine-iso-uploader --iso-domain=[ISODomain] upload /usr/share/ovirt-guest-tools-iso/ovirt-tools-setup.iso

    **Note:** The `ovirt-tools-setup.iso` file is a symbolic link to the most recently updated ISO file. The link is automatically changed to point to the newest ISO file every time you update the `ovirt-guest-tools-iso` package.

3. In the Administration or User Portal, if the virtual machine is running, use the **Change CD** button to attach the latest `ovirt-tools-setup.iso` file to each of your virtual machines. If the virtual machine is powered off, click the *Run Once** button and attach the ISO as a CD.

4. Select the CD Drive containing the updated ISO and execute the `ovirt-ToolsSetup.exe` file.

## Viewing Spacewalk Errata for a Virtual Machine

Errata for each virtual machine can be viewed after the oVirt virtual machine has been configured to receive errata information from the Spacewalk server.

**Viewing Spacewalk Errata**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Errata** tab in the details pane.

## Virtual Machines and Permissions

### Managing System Permissions for a Template

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A template administrator is a system administration role for templates in a data center. This role can be applied to specific virtual machines, to a data center, or to the whole virtualized environment; this is useful to allow different users to manage certain virtual resources.

The template administrator role permits the following actions:

* Create, edit, export, and remove associated templates.

* Import and export templates.

**Note:** You can only assign roles and permissions to existing users.

### Virtual Machines Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to virtual machine administration.

**oVirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| DataCenterAdmin | Data Center Administrator | Possesses administrative permissions for all objects underneath a specific data center except for storage. |
| ClusterAdmin | Cluster Administrator | Possesses administrative permissions for all objects underneath a specific cluster. |
| NetworkAdmin | Network Administrator | Possesses administrative permissions for all operations on a specific logical network. Can configure and manage networks attached to virtual machines. To configure port mirroring on a virtual machine network, apply the **NetworkAdmin** role on the network and the **UserVmEngine** role on the virtual machine. |

### Virtual Machine User Roles Explained

The table below describes the user roles and privileges applicable to virtual machine users. These roles allow access to the User Portal for managing and accessing virtual machines, but they do not confer any permissions for the Administration Portal.

**oVirt System User Roles**

| Role | Privileges | Notes |
|-
| UserRole | Can access and use virtual machines and pools. | Can log in to the User Portal and use virtual machines and pools. |
| PowerUserRole | Can create and manage virtual machines and templates. | Apply this role to a user for the whole environment with the **Configure** window, or for specific data centers or clusters. For example, if a PowerUserRole is applied on a data center level, the PowerUser can create virtual machines and templates in the data center. Having a **PowerUserRole** is equivalent to having the **VmCreator**, **DiskCreator**, and **TemplateCreator** roles. |
| UserVmEngine | System administrator of a virtual machine. | Can manage virtual machines and create and use snapshots. A user who creates a virtual machine in the User Portal is automatically assigned the UserVmEngine role on the machine. |
| UserTemplateBasedVm | Limited privileges to only use Templates. | Level of privilege to create a virtual machine by means of a template. |
| VmCreator | Can create virtual machines in the User Portal. | This role is not applied to a specific virtual machine; apply this role to a user for the whole environment with the **Configure** window. When applying this role to a cluster, you must also apply the **DiskCreator** role on an entire data center, or on specific storage domains. |
| VnicProfileUser | Logical network and network interface user for virtual machines. | If the **Allow all users to use this Network** option was selected when a logical network is created, **VnicProfileUser** permissions are assigned to all users for the logical network. Users can then attach or detach virtual machine network interfaces to or from the logical network. |

### Assigning Virtual Machines to Users

If you are creating virtual machines for users other than yourself, you have to assign roles to the users before they can use the virtual machines. Note that permissions can only be assigned to existing users. See "Users and Roles" in the [Administration Guide](/documentation/admin-guide/administration-guide/) for details on creating user accounts.

The User Portal supports three default roles: User, PowerUser and UserVmEngine. However, customized roles can be configured via the Administration Portal. The default roles are described below.

* A **User** can connect to and use virtual machines. This role is suitable for desktop end users performing day-to-day tasks.

* A **PowerUser** can create virtual machines and view virtual resources. This role is suitable if you are an administrator or manager who needs to provide virtual resources for your employees.

* A **UserVmEngine** can edit and remove virtual machines, assign user permissions, use snapshots and use templates. It is suitable if you need to make configuration changes to your virtual environment.

When you create a virtual machine, you automatically inherit **UserVmEngine** privileges. This enables you to make changes to the virtual machine and assign permissions to the users you manage, or users who are in your Identity Management (IdM) or RHDS group. See the [Administration Guide](/documentation/admin-guide/administration-guide/) for more information.

**Assigning Permissions to Users**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Permissions** tab on the details pane.

3. Click **Add**.

4. Enter a name, or user name, or part thereof in the **Search** text box, and click **Go**. A list of possible matches display in the results list.

5. Select the check box of the user to be assigned the permissions.

6. Select **UserRole** from the **Role to Assign** drop-down list.

7. Click **OK**.

The user's name and role display in the list of users permitted to access this virtual machine.

**Note:** If a user is assigned permissions to only one virtual machine, single sign-on (SSO) can be configured for the virtual machine. With single sign-on enabled, when a user logs in to the User Portal, and then connects to a virtual machine through, for example, a SPICE console, users are automatically logged in to the virtual machine and do not need to type in the user name and password again. Single sign-on can be enabled or disabled on a per virtual machine basis. See [Configuring Single Sign-On for Virtual Machines](sect-Configuring_Single_Sign-On_for_Virtual_Machines) for more information on how to enable and disable single sign-on for virtual machines.

### Removing Access to Virtual Machines from Users

**Removing Access to Virtual Machines from Users**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Permissions** tab on the details pane.

3. Click **Remove**. A warning message displays, asking you to confirm removal of the selected permissions.

4. To proceed, click **OK**. To abort, click **Cancel**.

## Snapshots

### Creating a Snapshot of a Virtual Machine

A snapshot is a view of a virtual machine's operating system and applications on any or all available disks at a given point in time. Take a snapshot of a virtual machine before you make a change to it that may have unintended consequences. You can use a snapshot to return a virtual machine to a previous state.

**Important:** Before taking a live snapshot of a virtual machine using OpenStack Volume (Cinder) disks, you must freeze and thaw the guest filesystem manually. This cannot be done with the Engine, and must be executed using the REST API.

**Creating a Snapshot of a Virtual Machine**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane and click **Create**.

    **Create snapshot**

    ![](/images/vmm-guide/5030.png)

3. Enter a description for the snapshot.

4. Select **Disks to include** using the check boxes.

5. Use the **Save Memory** check box to denote whether to include the virtual machine's memory in the snapshot.

6. Click **OK**.

**Note:** If you are taking a snapshot of a virtual machine with an OpenStack Volume (Cinder) disk, you must thaw the guest filesystem when the snapshot is complete using the REST API.

The virtual machine's operating system and applications on the selected disk(s) are stored in a snapshot that can be previewed or restored. The snapshot is created with a status of `Locked`, which changes to `Ok`. When you click on the snapshot, its details are shown on the **General**, **Disks**, **Network Interfaces**, and **Installed Applications** tabs in the right side-pane of the details pane.

### Using a Snapshot to Restore a Virtual Machine

A snapshot can be used to restore a virtual machine to its previous state.

**Using Snapshots to Restore Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane to list the available snapshots.

3. Select a snapshot to restore in the left side-pane. The snapshot details display in the right side-pane.

4. Click the drop-down menu beside **Preview** to open the **Custom Preview Snapshot** window.

    **Custom Preview Snapshot**

    ![](/images/vmm-guide/5031.png)

5. Use the check boxes to select the **VM Configuration**, **Memory**, and disk(s) you want to restore, then click **OK**. This allows you to create and restore from a customized snapshot using the configuration and disk(s) from multiple snapshots.

    **The Custom Preview Snapshot Window**

    ![](/images/vmm-guide/5032.png)

    The status of the snapshot changes to `Preview Mode`. The status of the virtual machine briefly changes to `Image Locked` before returning to `Down`.

6. Start the virtual machine; it runs using the disk image of the snapshot.

7. Click **Commit** to permanently restore the virtual machine to the condition of the snapshot. Any subsequent snapshots are erased.

8. Alternatively, click the **Undo** button to deactivate the snapshot and return the virtual machine to its previous state.

### Creating a Virtual Machine from a Snapshot

You have created a snapshot from a virtual machine. Now you can use that snapshot to create another virtual machine.

**Creating a virtual machine from a snapshot**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane to list the available snapshots.

3. Select a snapshot in the list displayed and click **Clone**.

4. Enter the **Name** and **Description** for the virtual machine.

    **Clone a Virtual Machine from a Snapshot**

    ![](/images/vmm-guide/6581.png)

5. Click **OK**.

After a short time, the cloned virtual machine appears in the **Virtual Machines** tab in the navigation pane with a status of `Image Locked`. The virtual machine will remain in this state until oVirt completes the creation of the virtual machine. A virtual machine with a preallocated 20 GB hard drive takes about fifteen minutes to create. Sparsely-allocated virtual disks take less time to create than do preallocated virtual disks.

When the virtual machine is ready to use, its status changes from `Image Locked` to `Down` in the **Virtual Machines** tab in the navigation pane.

### Deleting a Snapshot

You can delete a virtual machine snapshot and permanently remove it from your oVirt environment. This operation is supported on a running virtual machine and does not require the virtual machine to be in a down state.

**Important:** When you delete a snapshot from an image chain, one of three things happens:

* If the snapshot being deleted is contained in a RAW (preallocated) base image, a new volume is created that is the same size as the base image.

* If the snapshot being deleted is contained in a QCOW2 (thin provisioned) base image, the volume subsequent to the volume containing the snapshot being deleted is extended to the cumulative size of the successor volume and the base volume.

* If the snapshot being deleted is contained in a QCOW2 (thin provisioned), non-base image hosted on internal storage, the successor volume is extended to the cumulative size of the successor volume and the volume containing the snapshot being deleted.

The data from the two volumes is merged in the new or resized volume. The new or resized volume grows to accommodate the total size of the two merged images; the new volume size will be, at most, the sum of the two merged images. To delete a snapshot, you must have enough free space in the storage domain to temporarily accommodate both the original volume and the newly merged volume. Otherwise, snapshot deletion will fail and you will need to export and re-import the volume to remove snapshots.

**Deleting a Snapshot**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane to list the snapshots for that virtual machine.

    **Snapshot List**

    ![](/images/vmm-guide/5602.png)

3. Select the snapshot to delete.

4. Click **Delete**.

5. Click **OK**.

## Host Devices

### Adding a Host Device to a Virtual Machine

Virtual machines can be directly attached to the host devices for improved performance if a compatible host has been configured for direct device assignment.

**Adding Host Devices to a Virtual Machine**

1. Select a virtual machine and click the **Host Devices** tab in the details pane to list the host devices already attached to this virtual machine. A virtual machine can only have devices attached from the same host. If a virtual machine has attached devices from one host, and you attach a device from another host, the attached devices from the previous host will be automatically removed.

    Attaching host devices to a virtual machine requires the virtual machine to be in a `Down` state. If the virtual machine is running, the changes will not take effect until after the virtual machine has been shut down.

2. Click **Add device** to open the **Add Host Devices** window.

3. Use the **Pinned Host** dropdown menu to select a host.

4. Use the **Capability** dropdown menu to list the `pci`, `scsi`, or `usb_device` host devices.

5. Select the check boxes of the devices to attach to the virtual machine from the **Available Host Devices** pane and click the directional arrow button to transfer these devices to the **Host Devices to be attached** pane, creating a list of the devices to attach to the virtual machine.

6. When you have transferred all desired host devices to the **Host Devices to be attached** pane, click **OK** to attach these devices to the virtual machine and close the window.

These host devices will be attached to the virtual machine when the virtual machine is next powered on.

### Removing Host Devices from a Virtual Machine

Remove a host device from a virtual machine to which it has been directly attached using the details pane of the virtual machine.

If you are removing all host devices directly attached to the virtual machine in order to add devices from a different host, you can instead add the devices from the desired host, which will automatically remove all of the devices already attached to the virtual machine.

**Removing a Host Device from a Virtual Machine**

1. Select the virtual machine and click the **Host Devices** tab in the details pane to list the host devices attached to the virtual machine.

2. Select the host device to detach from the virtual machine, or hold **Ctrl** to select multiple devices, and click **Remove device** to open the **Remove Host Device(s)** window.

3. Click **OK** to confirm and detach these devices from the virtual machine.

### Pinning a Virtual Machine to Another Host

You can use the **Host Devices** tab in the details pane of a virtual machine to pin it to a specific host.

If the virtual machine has any host devices attached to it, pinning it to another host will automatically remove the host devices from the virtual machine.

**Pinning a Virtual Machine to a Host**

1. Select a virtual machine and click the **Host Devices** tab in the details pane.

2. Click **Pin to another host** to open the **Pin VM to Host** window.

3. Use the **Host** drop-down menu to select a host.

4. Click **OK** to pin the virtual machine to the selected host.

## Affinity Groups

Virtual machine affinity allows you to define sets of rules that specify whether certain virtual machines run together on the same host or run separately on different hosts. This allows you to create advanced workload scenarios for addressing challenges such as strict licensing requirements and workloads demanding high availability.

Virtual machine affinity is applied to virtual machines by adding virtual machines to one or more affinity groups. An affinity group is a group of two or more virtual machines for which a set of identical parameters and conditions apply. These parameters include positive (run together) affinity that ensures the virtual machines in an affinity group run on the same host, and negative (run independently) affinity that ensures the virtual machines in an affinity group run on different hosts.

A further set of conditions can then be applied to these parameters. For example, you can apply hard enforcement, which is a condition that ensures the virtual machines in the affinity group run on the same host or different hosts regardless of external conditions, or soft enforcement, which is a condition that indicates a preference for virtual machines in an affinity group to run on the same host or different hosts when possible.

The combination of an affinity group, its parameters, and its conditions is known as an affinity policy. Affinity policies are applied to running virtual machines immediately, without having to restart.

**Note:** Affinity groups are applied to virtual machines on the cluster level. When a virtual machine is moved from one cluster to another, that virtual machine is removed from all affinity groups in the source cluster.

**Important:** Affinity groups will only take effect when the `VmAffinityGroups` filter module or weights module is enabled in the scheduling policy applied to clusters in which affinity groups are defined. The `VmAffinityGroups` filter module is used to implement hard enforcement, and the `VmAffinityGroups` weights module is used to implement soft enforcement.

### Creating an Affinity Group

You can create new affinity groups in the Administration Portal.

**Creating Affinity Groups**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Affinity Groups** tab in the details pane.

3. Click **New**.

4. Enter a **Name** and **Description** for the affinity group.

5. Select the **Positive** check box to apply positive affinity, or ensure this check box is cleared to apply negative affinity.

6. Select the **Enforcing** check box to apply hard enforcement, or ensure this check box is cleared to apply soft enforcement.

7. Use the drop-down list to select the virtual machines to be added to the affinity group. Use the **+** and **-** buttons to add or remove additional virtual machines.

8. Click **OK**.

### Editing an Affinity Group

**Editing Affinity Groups**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Affinity Groups** tab in the details pane.

3. Click **Edit**.

4. Change the **Positive** and **Enforcing** check boxes to the preferred values and use the **+** and **-** buttons to add or remove virtual machines to or from the affinity group.

5. Click **OK**.

### Removing an Affinity Group

**Removing Affinity Groups**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Affinity Groups** tab in the details pane.

3. Click **Remove**.

4. Click **OK**.

The affinity policy that applied to the virtual machines that were members of that affinity group no longer applies.

## Exporting and Importing Virtual Machines and Templates

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the "Importing Existing Storage Domains" section in the [Administration Guide](/documentation/admin-guide/administration-guide/) for information on importing storage domains.

Virtual machines and templates stored in Open Virtual Machine Format (OVF) can be exported from and imported to data centers in the same or different oVirt environment.

To export or import virtual machines and templates, an active export domain must be attached to the data center containing the virtual machine or template to be exported or imported. An export domain acts as a temporary storage area containing two directories for each exported virtual machine or template. One directory contains the OVF files for the virtual machine or template. The other directory holds the disk image or images for the virtual machine or template.

There are three stages to exporting and importing virtual machines and templates:

1. Export the virtual machine or template to an export domain.

2. Detach the export domain from one data center, and attach it to another. You can attach it to a different data center in the same oVirt environment, or attach it to a data center in a separate oVirt environment that is managed by another installation of the oVirt Engine.

    **Note:** An export domain can only be active in one data center at a given time. This means that the export domain must be attached to either the source data center or the destination data center.

3. Import the virtual machine or template into the data center to which the export domain is attached.

When you export or import a virtual machine or template, properties including basic details such as the name and description, resource allocation, and high availability settings of that virtual machine or template are preserved. Specific user roles and permissions, however, are not preserved during the export process. If certain user roles and permissions are required to access the virtual machine or template, they will need to be set again after the virtual machine or template is imported.

You can also use the V2V feature to import virtual machines from other virtualization providers, such as Xen or VMware, or import Windows virtual machines. V2V converts virtual machines so that they can be hosted by oVirt.

**Important:** Virtual machines must be shut down before being exported or imported.

### Graphical Overview for Exporting and Importing Virtual Machines and Templates

This procedure provides a graphical overview of the steps required to export a virtual machine or template from one data center and import that virtual machine or template into another data center.

**Exporting and Importing Virtual Machines and Templates**

1. Attach the export domain to the source data center.

    **Attach Export Domain**

    ![](/images/vmm-guide/315.png)

2. Export the virtual machine or template to the export domain.

    **Export the Virtual Resource**

    ![](/images/vmm-guide/317.png)

3. Detach the export domain from the source data center.

    **Detach Export Domain**

    ![](/images/vmm-guide/316.png)

4. Attach the export domain to the destination data center.

    **Attach the Export Domain**

    ![](/images/vmm-guide/314.png)

5. Import the virtual machine or template into the destination data center.

    **Import the virtual resource**

    ![](/images/vmm-guide/318.png)

* [Exporting individual virtual machines to the export domain](Exporting_individual_virtual_machines_to_the_export_domain)

### Exporting a Virtual Machine to the Export Domain

Export a virtual machine to the export domain so that it can be imported into a different data center. Before you begin, the export domain must be attached to the data center that contains the virtual machine to be exported.

**Warning:** The virtual machine must be shut down before being exported.

**Exporting a Virtual Machine to the Export Domain**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Export**.

3. Optionally select the following check boxes:

    * **Force Override**: overrides existing images of the virtual machine on the export domain.

    * **Collapse Snapshots**: creates a single export volume per disk. This option removes snapshot restore points and includes the template in a template-based virtual machine, and removes any dependencies a virtual machine has on a template. For a virtual machine that is dependent on a template, either select this option, export the template with the virtual machine, or make sure the template exists in the destination data center.

        **Note:** When you create a virtual machine from a template, two storage allocation options are available under **New Virtual Machine** > **Resource Allocation** > **Storage Allocation**.

        * If **Clone** was selected, the virtual machine is not dependent on the template. The template does not have to exist in the destination data center.

        * If **Thin** was selected, the virtual machine is dependent on the template, so the template must exist in the destination data center or be exported with the virtual machine. Alternatively, select the **Collapse Snapshots** check box to collapse the template disk and virtual machine disk into a single disk.

        To check which option was selected, select a virtual machine and click the **General** tab in the details pane.

4. Click **OK**.

The export of the virtual machine begins. The virtual machine displays in the **Virtual Machines** results list with an `Image Locked` status while it is exported. Depending on the size of your virtual machine hard disk images, and your storage hardware, this can take up to an hour. Use the **Events** tab to view the progress. When complete, the virtual machine has been exported to the export domain and displays on the **VM Import** tab of the export domain's details pane.

### Importing a Virtual Machine into the Destination Data Center

You have a virtual machine on an export domain. Before the virtual machine can be imported to a new data center, the export domain must be attached to the destination data center.

**Importing a Virtual Machine into the Destination Data Center**

1. Click the **Storage** tab, and select the export domain in the results list. The export domain must have a status of `Active`.

2. Select the **VM Import** tab in the details pane to list the available virtual machines to import.

3. Select one or more virtual machines to import and click **Import**.

    **Import Virtual Machine**

    ![](/images/vmm-guide/6582.png)

4. Select the **Default Storage Domain** and **Cluster**.

5. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

6. Click the virtual machine to be imported and click on the **Disks** sub-tab. From this tab, you can use the **Allocation Policy** and **Storage Domain** drop-down lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and can also select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

7. Click **OK** to import the virtual machines.

8. The **Import Virtual Machine Conflict** window opens if the virtual machine exists in the virtualized environment.

    **Import Virtual Machine Conflict Window**

    ![](/images/vmm-guide/6583.png)

9. Choose one of the following radio buttons:

    * **Don't import**

    * **Import as cloned** and enter a unique name for the virtual machine in the **New Name** field.

10. Optionally select the **Apply to all** check box to import all duplicated virtual machines with the same suffix, and then enter a suffix in the **Suffix to add to the cloned VMs** field.

11. Click **OK**.

**Important:** During a single import operation, you can only import virtual machines that share the same architecture. If any of the virtual machines to be imported have a different architecture to that of the other virtual machines to be imported, a warning will display and you will be prompted to change your selection so that only virtual machines with the same architecture will be imported.

### Importing a Virtual Machine from a VMware Provider

Import virtual machines from a VMware vCenter provider to your oVirt environment. You can import from a VMware provider by entering its details in the **Import Virtual Machine(s)** window during each import operation, or you can add the VMware provider as an external provider, and select the preconfigured provider during import operations. To add an external provider, see "Adding a VMware Instance as a Virtual Machine Provider" in the [Administration Guide](/documentation/admin-guide/administration-guide/).

oVirt uses V2V to convert VMware virtual machines to the correct format before they are imported. You must install the `virt-v2v` package on a least one Enterprise Linux 7 host before proceeding. This package is available in the base `rhel-7-server-rpms` repository.

**Warning:** The virtual machine must be shut down before being imported. Starting the virtual machine through VMware during the import process can result in data corruption.

**Importing a Virtual Machine from VMware**

1. In the **Virtual Machines** tab, click **Import** to open the **Import Virtual Machine(s)** window.

    **The Import Virtual Machine(s) Window**

    ![](/images/vmm-guide/7324.png)

2. Select **VMware** from the **Source** list.

3. If you have configured a VMware provider as an external provider, select it from the **External Provider** list. Verify that the provider credentials are correct. If you did not specify a destination data center or proxy host when configuring the external provider, select those options now.

4. If you have not configured a VMware provider, or want to import from a new VMware provider, provide the following details:

    a. Select from the list the **Data Center** in which the virtual machine will be available.

    b. Enter the IP address or fully qualified domain name of the VMware vCenter instance in the **vCenter** field.

    c. Enter the IP address or fully qualified domain name of the host from which the virtual machines will be imported in the **ESXi** field.

    d. Enter the name of the data center and the cluster in which the specified ESXi host resides in the **Data Center** field.

    e. If you have exchanged the SSL certificate between the ESXi host and the Engine, leave **Verify server's SSL certificate** checked to verify the ESXi host's certificate. If not, uncheck the option.

    f. Enter the **Username** and **Password** for the VMware vCenter instance. The user must have access to the VMware data center and ESXi host on which the virtual machines reside.

    g. Select a host in the chosen data center with `virt-v2v` installed to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the VMware vCenter external provider.

5. Click **Load** to generate a list of the virtual machines on the VMware provider.

6. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list. Click **Next**.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **Note:** If a virtual machine's network device uses the driver type e1000 or rtl8139, the virtual machine will use the same driver type after it has been imported to oVirt.

    If required, you can change the driver type to VirtIO manually after the import. To change the driver type after a virtual machine has been imported, see [Editing network interfaces](Editing_network_interfaces1). If the network device uses driver types other than e1000 or rtl8139, the driver type is changed to VirtIO automatically during the import. The **Attach VirtIO-drivers** option allows the VirtIO drivers to be injected to the imported virtual machine files so that when the driver is changed to VirtIO, the device will be properly detected by the operating system.

    **The Import Virtual Machine(s) Window**

    ![](/images/vmm-guide/7325.png)

7. Select the **Cluster** in which the virtual machines will reside.

8. Select a **CPU Profile** for the virtual machines.

9. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

10. Select the **Clone** check box to change the virtual machine name and MAC addresses, and clone all disks, removing all snapshots. If a virtual machine appears with a warning symbol beside its name or has a tick in the **VM in System** column, you must clone the virtual machine and change its name.

11. Click on each virtual machine to be imported and click on the **Disks** sub-tab. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

    **Note:** The target storage domain must be a filed-based domain. Due to current limitations, specifying a block-based domain causes the V2V operation to fail.

12. If you selected the **Clone** check box, change the name of the virtual machine in the **General** sub-tab.

13. Click **OK** to import the virtual machines.

### Importing a Virtual Machine from a Xen Host

Import virtual machines from Xen on Enterprise Linux 5 to your oVirt environment. oVirt uses V2V to convert Xen virtual machines to the correct format before they are imported. You must install the `virt-v2v` package on at least one Enterprise Linux 7 host in the destination data center before proceeding (this host is referred to in the following procedure as the V2V host). The `virt-v2v` package is available in the base `rhel-7-server-rpms` repository.

**Warning:** The virtual machine must be shut down before being imported. Starting the virtual machine through Xen during the import process can result in data corruption.

**Importing a Virtual Machine from Xen**

1. Enable passwordless SSH between the V2V host and the Xen host:

    a. Log in to the V2V host and generate SSH keys for the `vdsm` user.

            # sudo -u vdsm ssh-keygen

    b. Copy the `vdsm` user's public key to the Xen host.

            # sudo -u vdsm ssh-copy-id root@xenhost.example.com

    c. Log in to the Xen host to add it to the V2V host's `known_hosts` file.

            # sudo -u vdsm ssh root@xenhost.example.com

    d. Exit the Xen host.

            # logout

2. Log in to the Administration Portal. In the **Virtual Machines** tab, click **Import** to open the **Import Virtual Machine(s)** window.

    **The Import Virtual Machine(s) Window**

    ![](/images/vmm-guide/ImportXenVM.png)

3. Select the **Data Center** that contains the V2V host.

4. Select **XEN (via RHEL)** from the **Source** drop-down list.

5. Enter the **URI** of the Xen host. The required format is pre-filled; you must replace `<hostname>` with the host name of the Xen host.  

6. Select the V2V host from the **Proxy Host** drop-down list.

7. Click **Load** to generate a list of the virtual machines on the Xen hypervisor.

8. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list.

    **Note:** Due to current limitations, Xen virtual machines with block devices do not appear in the **Virtual Machines on Source** list, and cannot be imported to oVirt.

9. Click **Next**.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **The Import Virtual Machine(s) Window**

    ![](/images/vmm-guide/7325.png)

10. Select the **Cluster** in which the virtual machines will reside.

11. Select a **CPU Profile** for the virtual machines.

12. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

13. Select the **Clone** check box to change the virtual machine name and MAC addresses, and clone all disks, removing all snapshots. If a virtual machine appears with a warning symbol beside its name or has a tick in the **VM in System** column, you must clone the virtual machine and change its name.

14. Click on each virtual machine to be imported and click on the **Disks** sub-tab. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

    **Note:** The target storage domain must be a filed-based domain. Due to current limitations, specifying a block-based domain causes the V2V operation to fail.

15. If you selected the **Clone** check box, change the name of the virtual machine in the **General** sub-tab.

16. Click **OK** to import the virtual machines.

## Migrating Virtual Machines Between Hosts

Live migration provides the ability to move a running virtual machine between physical hosts with no interruption to service. The virtual machine remains powered on and user applications continue to run while the virtual machine is relocated to a new physical host. In the background, the virtual machine's RAM is copied from the source host to the destination host. Storage and network connectivity are not altered.

### Live Migration Prerequisites

Live migration is used to seamlessly move virtual machines to support a number of common maintenance tasks. Ensure that your oVirt environment is correctly configured to support live migration well in advance of using it.

At a minimum, for successful live migration of virtual machines to be possible:n

* The source and destination host should both be members of the same cluster, ensuring CPU compatibility between them.

    **Note:** Live migrating virtual machines between different clusters is generally not recommended.

* The source and destination host must have a status of `Up`.

* The source and destination host must have access to the same virtual networks and VLANs.

* The source and destination host must have access to the data storage domain on which the virtual machine resides.

* There must be enough CPU capacity on the destination host to support the virtual machine's requirements.

* There must be enough RAM on the destination host that is not in use to support the virtual machine's requirements.

* The migrating virtual machine must not have the `cache!=none` custom property set.

In addition, for best performance, the storage and management networks should be split to avoid network saturation. Virtual machine migration involves transferring large amounts of data between hosts.

Live migration is performed using the management network. Each live migration event is limited to a maximum transfer speed of 30 MBps, and the number of concurrent migrations supported is also limited by default. Despite these measures, concurrent migrations have the potential to saturate the management network. It is recommended that separate logical networks are created for storage, display, and virtual machine data to minimize the risk of network saturation.

# Optimizing Live Migration

Live virtual machine migration can be a resource-intensive operation. The following two options can be set globally for every virtual machine in the environment, at the cluster level, or at the individual virtual machine level to optimize live migration.

The **Auto Converge migrations** option allows you to set whether auto-convergence is used during live migration of virtual machines. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine.

The **Enable migration compression** option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern.

Both options are disabled globally by default.

**Configuring Auto-convergence and Migration Compression for Virtual Machine Migration**

1. Configure the optimization settings at the global level:

    a. Enable auto-convergence at the global level:

            # engine-config -s DefaultAutoConvergence=True

    b. Enable migration compression at the global level:

            # engine-config -s DefaultMigrationCompression=True

    c. Restart the `ovirt-engine` service to apply the changes:

            # systemctl restart ovirt-engine.service

2. Configure the optimization settings at the cluster level:

    a. Select a cluster.

    b. Click **Edit**.

    c. Click the **Scheduling Policy** tab.

    d. From the **Auto Converge migrations** list, select **Inherit from global setting**, **Auto Converge**, or **Don't Auto Converge**.

    e. From the **Enable migration compression** list, select **Inherit from global setting**, **Compress**, or **Don't Compress**.

3. Configure the optimization settings at the virtual machine level:

    a. Select a virtual machine.

    b. Click **Edit**.

    c. Click the **Host** tab.

    d. From the **Auto Converge migrations** list, select **Inherit from cluster setting**, **Auto Converge**, or **Don't Auto Converge**.

    e. From the **Enable migration compression** list, select **Inherit from cluster setting**, **Compress**, or **Don't Compress**.

### Automatic Virtual Machine Migration

oVirt Engine automatically initiates live migration of all virtual machines running on a host when the host is moved into maintenance mode. The destination host for each virtual machine is assessed as the virtual machine is migrated, in order to spread the load across the cluster.

The Engine automatically initiates live migration of virtual machines in order to maintain load balancing or power saving levels in line with scheduling policy. While no scheduling policy is defined by default, it is recommended that you specify the scheduling policy which best suits the needs of your environment. You can also disable automatic, or even manual, live migration of specific virtual machines where required.

### Preventing Automatic Migration of a Virtual Machine

oVirt Engine allows you to disable automatic migration of virtual machines. You can also disable manual migration of virtual machines by setting the virtual machine to run only on a specific host.

The ability to disable automatic migration and require a virtual machine to run on a particular host is useful when using application high availability products.

**Preventing Automatic Migration of Virtual Machine**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

    **The Edit Virtual Machine Window**

    ![](/images/vmm-guide/7321.png)

3. Click the **Host** tab.

4. Use the **Start Running On** radio buttons to designate the virtual machine to run on **Any Host in Cluster** or a **Specific** host. If applicable, select a specific host or group of hosts from the list.

    **Warning:** Explicitly assigning a virtual machine to one specific host and disabling migration is mutually exclusive with oVirt high availability. Virtual machines that are assigned to one specific host can only be made highly available using third-party high availability products. This restriction does not apply to virtual machines that are assigned to multiple specific hosts.

    **Important:** If the virtual machine has host devices directly attached to it, and a different host is specified, the host devices from the previous host will be automatically removed from the virtual machine.

5. Select **Allow manual migration only** or **Do not allow migration** from the **Migration Options** drop-down list.

6. Optionally, select the **Use custom migration downtime** check box and specify a value in milliseconds.

7. Click **OK**.

### Manually Migrating Virtual Machines

A running virtual machine can be live migrated to any host within its designated host cluster. Live migration of virtual machines does not cause any service interruption. Migrating virtual machines to a different host is especially useful if the load on a particular host is too high. For live migration prerequisites, see the Live migration prerequisites section.

**Note:** When you place a host into maintenance mode, the virtual machines running on that host are automatically migrated to other hosts in the same cluster. You do not need to manually migrate these virtual machines.

**Note:** Live migrating virtual machines between different clusters is generally not recommended.

**Manually Migrating Virtual Machines**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click **Migrate**.

3. Use the radio buttons to select whether to **Select Host Automatically** or to **Select Destination Host**, specifying the host using the drop-down list.

    **Note:** When the **Select Host Automatically** option is selected, the system determines the host to which the virtual machine is migrated according to the load balancing and power management rules set up in the scheduling policy.

4. Click **OK**.

During migration, progress is shown in the **Migration** progress bar. Once migration is complete the **Host** column will update to display the host the virtual machine has been migrated to.

### Setting Migration Priority

oVirt Engine queues concurrent requests for migration of virtual machines off of a given host. The load balancing process runs every minute. Hosts already involved in a migration event are not included in the migration cycle until their migration event has completed. When there is a migration request in the queue and available hosts in the cluster to action it, a migration event is triggered in line with the load balancing policy for the cluster.

You can influence the ordering of the migration queue by setting the priority of each virtual machine; for example, setting mission critical virtual machines to migrate before others. Migrations will be ordered by priority; virtual machines with the highest priority will be migrated first.

**Setting Migration Priority**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Select the **High Availability** tab.

4. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list.

5. Click **OK**.

### Canceling Ongoing Virtual Machine Migrations

A virtual machine migration is taking longer than you expected. You'd like to be sure where all virtual machines are running before you make any changes to your environment.

**Canceling Ongoing Virtual Machine Migrations**

1. Select the migrating virtual machine. It is displayed in the **Virtual Machines** resource tab with a status of **Migrating from**.

2. Click **Cancel Migration**.

The virtual machine status returns from **Migrating from** to **Up**.

### Event and Log Notification upon Automatic Migration of Highly Available Virtual Servers

When a virtual server is automatically migrated because of the high availability function, the details of an automatic migration are documented in the **Events** tab and in the engine log to aid in troubleshooting, as illustrated in the following examples:

**Notification in the Events Tab of the Web Admin Portal**

Highly Available `Virtual_Machine_Name` failed. It will be restarted automatically.

`Virtual_Machine_Name` was restarted on Host `Host_Name`

**Notification in the Engine engine.log**

This log can be found on the oVirt Engine at `/var/log/ovirt-engine/engine.log`:

Failed to start Highly Available VM. Attempting to restart. VM Name: `Virtual_Machine_Name`, VM Id:`Virtual_Machine_ID_Number`

## Improving Uptime with Virtual Machine High Availability

### What is High Availability?

High availability means that a virtual machine will be automatically restarted if its process is interrupted. This happens if the virtual machine is terminated by methods other than powering off from within the guest or sending the shutdown command from the Engine. When these events occur, the highly available virtual machine is automatically restarted, either on its original host or another host in the cluster.

High availability is possible because the oVirt Engine constantly monitors the hosts and storage, and automatically detects hardware failure. If host failure is detected, any virtual machine configured to be highly available is automatically restarted on another host in the cluster.

With high availability, interruption to service is minimal because virtual machines are restarted within seconds with no user intervention required. High availability keeps your resources balanced by restarting guests on a host with low current resource utilization, or based on any workload balancing or power saving policies that you configure. This ensures that there is sufficient capacity to restart virtual machines at all times.

### Why Use High Availability?

High availability is recommended for virtual machines running critical workloads.

High availability can ensure that virtual machines are restarted in the following scenarios:

* When a host becomes non-operational due to hardware failure.

* When a host is put into maintenance mode for scheduled downtime.

* When a host becomes unavailable because it has lost communication with an external storage resource.

A high availability virtual machine is automatically restarted, either on its original host or another host in the cluster.

### High Availability Considerations

A highly available host requires a power management device and its fencing parameters configured. In addition, for a virtual machine to be highly available when its host becomes non-operational, it needs to be started on another available host in the cluster. To enable the migration of highly available virtual machines:

* Power management must be configured for the hosts running the highly available virtual machines.

* The host running the highly available virtual machine must be part of a cluster which has other available hosts.

* The destination host must be running.

* The source and destination host must have access to the data domain on which the virtual machine resides.

* The source and destination host must have access to the same virtual networks and VLANs.

* There must be enough CPUs on the destination host that are not in use to support the virtual machine's requirements.

* There must be enough RAM on the destination host that is not in use to support the virtual machine's requirements.

### Configuring a Highly Available Virtual Machine

High availability must be configured individually for each virtual machine.

**Configuring a Highly Available Virtual Machine**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **High Availability** tab.

    **The High Availability Tab**

    ![](/images/vmm-guide/7322.png)

4. Select the **Highly Available** check box to enable high availability for the virtual machine.

5. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.

6. Click **OK**.

## Other Virtual Machine Tasks

### Enabling SAP Monitoring

Enable SAP monitoring on a virtual machine through the Administration Portal.

**Enabling SAP Monitoring on Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Custom Properties** tab.

    **Enable SAP**

    ![](/images/vmm-guide/4672.png)

4. Select `sap_agent` from the drop-down list. Ensure the secondary drop-down menu is set to **True**.

    If previous properties have been set, select the plus sign to add a new property rule and select `sap_agent`.

5. Click **OK**.

### Configuring Enterprise Linux 5.4 and Higher Virtual Machines to use SPICE

SPICE is a remote display protocol designed for virtual environments, which enables you to view a virtualized desktop or server. SPICE delivers a high quality user experience, keeps CPU consumption low, and supports high quality video streaming.

Using SPICE on a Linux machine significantly improves the movement of the mouse cursor on the console of the virtual machine. To use SPICE, the X Window system requires additional QXL drivers. The QXL drivers are provided with Enterprise Linux 5.4 and newer. Older versions are not supported. Installing SPICE on a virtual machine running Enterprise Linux significantly improves the performance of the graphical user interface.

**Note:** Typically, this is most useful for virtual machines where the user requires the use of the graphical user interface. System administrators who are creating virtual servers may prefer not to configure SPICE if their use of the graphical user interface is minimal.

#### Installing and Configuring QXL Drivers

  You must manually install QXL drivers on virtual machines running Enterprise Linux 5.4 or higher. This is unnecessary for virtual machines running Enterprise Linux 6 or Enterprise Linux 7 as the QXL drivers are installed by default.

**Installing QXL Drivers**

1. Log in to a Enterprise Linux virtual machine.

2. Install the QXL drivers:

        # yum install xorg-x11-drv-qxl

You can configure QXL drivers using either a graphical interface or the command line. Perform only one of the following procedures.

**Configuring QXL drivers in GNOME**

1. Click **System**.

2. Click **Administration**.

3. Click **Display**.

4. Click the **Hardware** tab.

5. Click **Video Cards Configure**.

6. Select **qxl** and click **OK**.

7. Restart X-Windows by logging out of the virtual machine and logging back in.

**Configuring QXL drivers on the command line:**

1. Back up `/etc/X11/xorg.conf`:

        # cp /etc/X11/xorg.conf /etc/X11/xorg.conf.$$.backup

2. Make the following change to the Device section of `/etc/X11/xorg.conf`:

        Section  "Device"
        Identifier "Videocard0"
        Driver  "qxl"
        Endsection

#### Configuring a Virtual Machine's Tablet and Mouse to use SPICE

Edit the `/etc/X11/xorg.conf` file to enable SPICE for your virtual machine's tablet devices.

**Configuring a Virtual Machine's Tablet and Mouse to use SPICE**

1. Verify that the tablet device is available on your guest:

        # /sbin/lsusb -v | grep 'QEMU USB Tablet'

    If there is no output from the command, do not continue configuring the tablet.

2. Back up `/etc/X11/xorg.conf`:

        # cp /etc/X11/xorg.conf /etc/X11/xorg.conf.$$.backup

3. Make the following changes to `/etc/X11/xorg.conf`:

        Section "ServerLayout"
        Identifier     "single head configuration"
        Screen      0  "Screen0" 0 0
        InputDevice    "Keyboard0" "CoreKeyboard"
        InputDevice    "Tablet" "SendCoreEvents"
        InputDevice    "Mouse" "CorePointer"
        EndSection

        Section "InputDevice"
        Identifier  "Mouse"
        Driver      "void"
        #Option      "Device" "/dev/input/mice"
        #Option      "Emulate3Buttons" "yes"
        EndSection

        Section "InputDevice"
        Identifier  "Tablet"
        Driver      "evdev"
        Option      "Device" "/dev/input/event2"
        Option "CorePointer" "true"
        EndSection

4. Log out and log back into the virtual machine to restart X-Windows.

### KVM Virtual Machine Timing Management

Virtualization poses various challenges for virtual machine time keeping. Virtual machines which use the Time Stamp Counter (TSC) as a clock source may suffer timing issues as some CPUs do not have a constant Time Stamp Counter. Virtual machines running without accurate timekeeping can have serious affects on some networked applications as your virtual machine will run faster or slower than the actual time.

KVM works around this issue by providing virtual machines with a paravirtualized clock. The KVM `pvclock` provides a stable source of timing for KVM guests that support it.

Presently, only Enterprise Linux 5.4 and higher virtual machines fully support the paravirtualized clock.

Virtual machines can have several problems caused by inaccurate clocks and counters:

* Clocks can fall out of synchronization with the actual time which invalidates sessions and affects networks.

* Virtual machines with slower clocks may have issues migrating.

These problems exist on other virtualization platforms and timing should always be tested.

**Important:** The Network Time Protocol (NTP) daemon should be running on the host and the virtual machines. Enable the `ntpd` service and add it to the default startup sequence:

* For Enterprise Linux 6

        # service ntpd start
        # chkconfig ntpd on

* For Enterprise Linux 7

        # systemctl start ntpd.service
        # systemctl enable ntpd.service

Using the `ntpd` service should minimize the affects of clock skew in all cases.

The NTP servers you are trying to use must be operational and accessible to your hosts and virtual machines.

**Determining if your CPU has the constant Time Stamp Counter**

Your CPU has a constant Time Stamp Counter if the `constant_tsc` flag is present. To determine if your CPU has the `constant_tsc` flag run the following command:

    $ cat /proc/cpuinfo | grep constant_tsc

If any output is given your CPU has the `constant_tsc` bit. If no output is given follow the instructions below.

**Configuring hosts without a constant Time Stamp Counter**

Systems without constant time stamp counters require additional configuration. Power management features interfere with accurate time keeping and must be disabled for virtual machines to accurately keep time with KVM.

**Important:** These instructions are for AMD revision F CPUs only.

If the CPU lacks the `constant_tsc` bit, disable all power management features ([BZ#513138](https://bugzilla.redhat.com/show_bug.cgi?id=513138)). Each system has several timers it uses to keep time. The TSC is not stable on the host, which is sometimes caused by `cpufreq` changes, deep C state, or migration to a host with a faster TSC. Deep C sleep states can stop the TSC. To prevent the kernel using deep C states append "`processor.max_cstate=1`" to the kernel boot options in the `grub.conf` file on the host:

    term Enterprise Linux Server (2.6.18-159.el5)
            root (hd0,0)
     kernel /vmlinuz-2.6.18-159.el5 ro root=/dev/VolGroup00/LogVol00 rhgb quiet processor.max_cstate=1

Disable `cpufreq` (only necessary on hosts without the `constant_tsc`) by editing the `/etc/sysconfig/cpuspeed` configuration file and change the `MIN_SPEED` and `MAX_SPEED` variables to the highest frequency available. Valid limits can be found in the `/sys/devices/system/cpu/cpu*/cpufreq/scaling_available_frequencies` files.

**Using the `engine-config` tool to receive alerts when hosts drift out of sync.**

You can use the `engine-config` tool to configure alerts when your hosts drift out of sync.

There are 2 relevant parameters for time drift on hosts: `EnableHostTimeDrift` and `HostTimeDriftInSec`. `EnableHostTimeDrift`, with a default value of false, can be enabled to receive alert notifications of host time drift. The `HostTimeDriftInSec` parameter is used to set the maximum allowable drift before alerts start being sent.

Alerts are sent once per hour per host.

**Using the paravirtualized clock with Enterprise Linux virtual machines**

For certain Enterprise Linux virtual machines, additional kernel parameters are required. These parameters can be set by appending them to the end of the /kernel line in the /boot/grub/grub.conf file of the virtual machine.

**Note:** The process of configuring kernel parameters can be automated using the `ktune` package

The `ktune` package provides an interactive Bourne shell script, `fix_clock_drift.sh`. When run as the superuser, this script inspects various system parameters to determine if the virtual machine on which it is run is susceptible to clock drift under load. If so, it then creates a new `grub.conf.kvm` file in the `/boot/grub/` directory. This file contains a kernel boot line with additional kernel parameters that allow the kernel to account for and prevent significant clock drift on the KVM virtual machine. After running `fix_clock_drift.sh` as the superuser, and once the script has created the `grub.conf.kvm` file, then the virtual machine's current `grub.conf` file should be backed up manually by the system administrator, the new `grub.conf.kvm` file should be manually inspected to ensure that it is identical to `grub.conf` with the exception of the additional boot line parameters, the `grub.conf.kvm` file should finally be renamed `grub.conf`, and the virtual machine should be rebooted.

The table below lists versions of Enterprise Linux and the parameters required for virtual machines on systems without a constant Time Stamp Counter.

| Enterprise Linux | Additional virtual machine kernel parameters |
|-
| 5.4 AMD64/Intel 64 with the paravirtualized clock | Additional parameters are not required |
| 5.4 AMD64/Intel 64 without the paravirtualized clock | notsc lpj=n |
| 5.4 x86 with the paravirtualized clock | Additional parameters are not required |
| 5.4 x86 without the paravirtualized clock | clocksource=acpi_pm lpj=n |
| 5.3 AMD64/Intel 64 | notsc |
| 5.3 x86 | clocksource=acpi_pm |
| 4.8 AMD64/Intel 64 | notsc |
| 4.8 x86 | clock=pmtmr |
| 3.9 AMD64/Intel 64 | Additional parameters are not required |
| 3.9 x86 | Additional parameters are not required |


**Prev:** [Chapter 5: Editing Virtual Machines](../chap-Editing_Virtual_Machines) <br>
**Next:** [Chapter 7: Templates](../chap-Templates)
