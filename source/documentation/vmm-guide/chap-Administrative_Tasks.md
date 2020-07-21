---
title: Administrative Tasks
---

# Chapter 6: Administrative Tasks

## Shutting Down a Virtual Machine

**Shutting Down a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Shutdown**.

3. Optionally in the Administration Portal, enter a **Reason** for shutting down the virtual machine in the **Shut down Virtual Machine(s)** confirmation window. This allows you to provide an explanation for the shutdown, which will appear in the logs and when the virtual machine is powered on again.

    **Note:** The virtual machine shutdown **Reason** field will only appear if it has been enabled in the cluster settings. For more information, see "Explanation of Settings and Controls in the New Cluster and Edit Cluster Windows" in the [Administration Guide](/documentation/administration_guide/).

4. Click **OK** in the **Shut down Virtual Machine(s)** confirmation window.

The virtual machine shuts down gracefully and the **Status** of the virtual machine changes to `Down`.

## Suspending a Virtual Machine

Suspending a virtual machine is equal to placing that virtual machine into **Hibernate** mode.

**Suspending a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Suspend**.

The **Status** of the virtual machine changes to `Suspended`.

## Rebooting a Virtual Machine

**Rebooting a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Reboot**.

3. Click **OK** in the **Reboot Virtual Machine(s)** confirmation window.

The **Status** of the virtual machine changes to `Reboot In Progress` before returning to `Up`.

## Removing a Virtual Machine

    **Important:** The **Remove** button is disabled while virtual machines are running; you must shut down a virtual machine before you can remove it.

**Removing Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines** and select the virtual machine to remove.

2. Click **Remove**.

3. Optionally, select the **Remove Disk(s)** check box to remove the virtual disks attached to the virtual machine together with the virtual machine. If the **Remove Disk(s)** check box is cleared, then the virtual disks remain in the environment as floating disks.

4. Click **OK**.

## Cloning a Virtual Machine

You can clone virtual machines without having to create a template or a snapshot first.

  **Important:** The **Clone VM** button is disabled while virtual machines are running; you must shut down a virtual machine before you can clone it.

**Cloning Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines** and select the virtual machine to clone.

2. Click **More Actions** &rarr; **Clone VM**.

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

3. In the Administration or VM Portal, if the virtual machine is running, use the **Change CD** button to attach the latest `ovirt-tools-setup.iso` file to each of your virtual machines. If the virtual machine is powered off, click the *Run Once** button and attach the ISO as a CD.

4. Select the CD Drive containing the updated ISO and execute the `ovirt-ToolsSetup.exe` file.

## Viewing Foreman Errata for a Virtual Machine

Errata for each virtual machine can be viewed after the oVirt virtual machine has been configured to receive errata information from the Foreman server.

**Viewing Foreman Errata**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

2. Click **Errata**.

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
| NetworkAdmin | Network Administrator | Possesses administrative permissions for all operations on a specific logical network. Can configure and manage networks attached to virtual machines. To configure port mirroring on a virtual machine network, apply the **NetworkAdmin** role on the network and the **UserVmManager** role on the virtual machine. |

### Virtual Machine User Roles Explained

The table below describes the user roles and privileges applicable to virtual machine users. These roles allow access to the VM Portal for managing and accessing virtual machines, but they do not confer any permissions for the Administration Portal.

**oVirt System User Roles**

| Role | Privileges | Notes |
|-
| UserRole | Can access and use virtual machines and pools. | Can log in to the VM Portal and use virtual machines and pools. |
| PowerUserRole | Can create and manage virtual machines and templates. | Apply this role to a user for the whole environment with the **Configure** window, or for specific data centers or clusters. For example, if a PowerUserRole is applied on a data center level, the PowerUser can create virtual machines and templates in the data center. Having a **PowerUserRole** is equivalent to having the **VmCreator**, **DiskCreator**, and **TemplateCreator** roles. |
| UserVmManager | System administrator of a virtual machine. | Can manage virtual machines and create and use snapshots. A user who creates a virtual machine in the VM Portal is automatically assigned the UserVmManager role on the machine. |
| UserTemplateBasedVm | Limited privileges to only use Templates. | Level of privilege to create a virtual machine by means of a template. |
| VmCreator | Can create virtual machines in the VM Portal. | This role is not applied to a specific virtual machine; apply this role to a user for the whole environment with the **Configure** window. When applying this role to a cluster, you must also apply the **DiskCreator** role on an entire data center, or on specific storage domains. |
| VnicProfileUser | Logical network and network interface user for virtual machines. | If the **Allow all users to use this Network** option was selected when a logical network is created, **VnicProfileUser** permissions are assigned to all users for the logical network. Users can then attach or detach virtual machine network interfaces to or from the logical network. |

### Assigning Virtual Machines to Users

If you are creating virtual machines for users other than yourself, you have to assign roles to the users before they can use the virtual machines. Note that permissions can only be assigned to existing users. See "Users and Roles" in the [Administration Guide](/documentation/administration_guide/) for details on creating user accounts.

The VM Portal supports three default roles: User, PowerUser and UserVmManager. However, customized roles can be configured via the Administration Portal. The default roles are described below.

* A **User** can connect to and use virtual machines. This role is suitable for desktop end users performing day-to-day tasks.

* A **PowerUser** can create virtual machines and view virtual resources. This role is suitable if you are an administrator or manager who needs to provide virtual resources for your employees.

* A **UserVmManager** can edit and remove virtual machines, assign user permissions, use snapshots and use templates. It is suitable if you need to make configuration changes to your virtual environment.

When you create a virtual machine, you automatically inherit **UserVmManager** privileges. This enables you to make changes to the virtual machine and assign permissions to the users you manage, or users who are in your Identity Management (IdM) or RHDS group. See the [Administration Guide](/documentation/administration_guide/) for more information.

**Assigning Permissions to Users**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Permissions** tab.

4. Click **Add**.

5. Enter a name, or user name, or part thereof in the **Search** text box, and click **Go**. A list of possible matches display in the results list.

6. Select the check box of the user to be assigned the permissions.

5. Select **UserRole** from the **Role to Assign** drop-down list.

8. Click **OK**.

The user's name and role display in the list of users permitted to access this virtual machine.

    **Note:** If a user is assigned permissions to only one virtual machine, single sign-on (SSO) can be configured for the virtual machine. With single sign-on enabled, when a user logs in to the VM Portal, and then connects to a virtual machine through, for example, a SPICE console, users are automatically logged in to the virtual machine and do not need to type in the user name and password again. Single sign-on can be enabled or disabled on a per virtual machine basis. See [Configuring Single Sign-On for Virtual Machines](/documentation/vmm-guide/chap-Additional_Configuration/#configuring-single-sign-on-for-virtual-machines) for more information on how to enable and disable single sign-on for virtual machines.

### Removing Access to Virtual Machines from Users

**Removing Access to Virtual Machines from Users**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click **Permissions**.

3. Click **Remove**. A warning message displays, asking you to confirm removal of the selected permissions.

4. To proceed, click **OK**. To abort, click **Cancel**.

## Snapshots

### Creating a Snapshot of a Virtual Machine

A snapshot is a view of a virtual machine's operating system and applications on any or all available disks at a given point in time. Take a snapshot of a virtual machine before you make a change to it that may have unintended consequences. You can use a snapshot to return a virtual machine to a previous state.

**Creating a Snapshot of a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Snapshots** tab and click **Create**.

4. Enter a description for the snapshot.

5. Select **Disks to include** using the check boxes.

    **Note:** If no disks are selected, a partial snapshot of the virtual machine, without a disk, is created. You can preview this snapshot to view the configuration of the virtual machine. Note that committing a partial snapshot will result in a virtual machine without a disk.

6. Use the **Save Memory** check box to denote whether to include the virtual machine's memory in the snapshot.

7. Click **OK**.

The virtual machine's operating system and applications on the selected disk(s) are stored in a snapshot that can be previewed or restored. The snapshot is created with a status of `Locked`, which changes to `Ok`. When you click on the snapshot, its details are shown on the **General**, **Disks**, **Network Interfaces**, and **Installed Applications** drop-down views in the **Snapshots** tab.

### Using a Snapshot to Restore a Virtual Machine

A snapshot can be used to restore a virtual machine to its previous state.

**Using Snapshots to Restore Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Snapshots** tab to list the available snapshots.

4. Select a snapshot to restore in the left side-pane. The snapshot details display in the right side-pane.

5. Click the **Preview** drop-down menu button and select **Custom**.

6. Use the check boxes to select the **VM Configuration**, **Memory**, and disk(s) you want to restore, then click **OK**. This allows you to create and restore from a customized snapshot using the configuration and disk(s) from multiple snapshots.

  The status of the snapshot changes to `Preview Mode`. The status of the virtual machine briefly changes to `Image Locked` before returning to `Down`.

7. Start the virtual machine; it runs using the disk image of the snapshot.

8. Click **Commit** to permanently restore the virtual machine to the condition of the snapshot. Any subsequent snapshots are erased.

   Alternatively, click the **Undo** button to deactivate the snapshot and return the virtual machine to its previous state.

### Creating a Virtual Machine from a Snapshot

You have created a snapshot from a virtual machine. Now you can use that snapshot to create another virtual machine.

**Creating a virtual machine from a snapshot**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Snapshots** tab to list the available snapshots.

4. Select a snapshot in the list displayed and click **Clone**.

5. Enter the **Name** and **Description** for the virtual machine.

6. Click **OK**.

After a short time, the cloned virtual machine appears in the **Virtual Machines** tab in the navigation pane with a status of `Image Locked`. The virtual machine will remain in this state until oVirt completes the creation of the virtual machine. A virtual machine with a preallocated 20 GB hard drive takes about fifteen minutes to create. Sparsely-allocated virtual disks take less time to create than do preallocated virtual disks.

When the virtual machine is ready to use, its status changes from `Image Locked` to `Down` in **Compute** &rarr; **Virtual Machines**.

### Deleting a Snapshot

You can delete a virtual machine snapshot and permanently remove it from your oVirt environment. This operation is supported on a running virtual machine and does not require the virtual machine to be in a down state.

    **Important:** When you delete a snapshot from an image chain, there must be enough free space in the storage domain to temporarily accommodate both the original volume and the newly merged volume. Otherwise, snapshot deletion will fail and you will need to export and re-import the volume to remove snapshots. This is due to the data from the two volumes being merged in the resized volume and the resized volume growing to accommodate the total size of the two merged images.

    * If the snapshot being deleted is contained in a base image, the volume subsequent to the volume containing the snapshot being deleted is extended to include the base volume.

    * If the snapshot being deleted is contained in a QCOW2 (thin provisioned), non-base image hosted on internal storage, the successor volume is extended to include the volume containing the snapshot being deleted.

**Deleting a Snapshot**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Snapshots** tab to list the snapshots for that virtual machine.

4. Select the snapshot to delete.

5. Click **Delete**.

6. Click **OK**.

## Host Devices

### Adding a Host Device to a Virtual Machine

Virtual machines can be directly attached to the host devices for improved performance if a compatible host has been configured for direct device assignment. Host devices are devices that are physically plugged into the host, including SCSI (for example tapes, disks, changers), PCI (for example NICs, GPUs, and HBAs), and USB (for example mice, cameras, and disks).

**Adding Host Devices to a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Host Devices** tab to list the host devices already attached to this virtual machine.

   A virtual machine can only have devices attached from the same host. If a virtual machine has attached devices from one host, and you attach a device from another host, the attached devices from the previous host will be automatically removed.

   Attaching host devices to a virtual machine requires the virtual machine to be in a `Down` state. If the virtual machine is running, the changes will not take effect until after the virtual machine has been shut down.

4. Click **Add device** to open the **Add Host Devices** window.

5. Use the **Pinned Host** drop-down menu to select a host.

6. Use the **Capability** drop-down menu to list the `pci`, `scsi`, or `usb_device` host devices.

7. Select the check boxes of the devices to attach to the virtual machine from the **Available Host Devices** pane and click the directional arrow button to transfer these devices to the **Host Devices to be attached** pane, creating a list of the devices to attach to the virtual machine.

8. When you have transferred all desired host devices to the **Host Devices to be attached** pane, click **OK** to attach these devices to the virtual machine and close the window.

These host devices will be attached to the virtual machine when the virtual machine is next powered on.

### Removing Host Devices from a Virtual Machine

Remove a host device from a virtual machine to which it has been directly attached using the details pane of the virtual machine.

If you are removing all host devices directly attached to the virtual machine in order to add devices from a different host, you can instead add the devices from the desired host, which will automatically remove all of the devices already attached to the virtual machine.

**Removing a Host Device from a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Host Devices** tab to list the host devices attached to the virtual machine.

4. Select the host device to detach from the virtual machine, or hold `Ctrl` to select multiple devices, and click **Remove device** to open the **Remove Host Device(s)** window.

5. Click **OK** to confirm and detach these devices from the virtual machine.

### Pinning a Virtual Machine to Another Host

You can use the **Host Devices** tab in the details pane of a virtual machine to pin it to a specific host.

If the virtual machine has any host devices attached to it, pinning it to another host will automatically remove the host devices from the virtual machine.

**Pinning a Virtual Machine to a Host**

1. Click a virtual machine name and click the **Host Devices** tab.

2. Click **Pin to another host** to open the **Pin VM to Host** window.

3. Use the **Host** drop-down menu to select a host.

4. Click **OK** to pin the virtual machine to the selected host.

## Affinity Groups

Virtual machine affinity allows you to define sets of rules that specify whether certain virtual machines run together on the same host or on hosts in a group, or run separately on different hosts. This allows you to create advanced workload scenarios for addressing challenges such as strict licensing requirements and workloads demanding high availability, and failover and failback for disaster recovery.

Virtual machine affinity is applied to virtual machines by adding virtual machines to one or more affinity groups. An affinity group is a group of two or more virtual machines for which a set of identical parameters and conditions apply. These parameters include positive (run together) affinity that ensures the virtual machines in an affinity group run on the same host or hosts in a group, and negative (run independently) affinity that ensures the virtual machines in an affinity group run on different hosts.

    **Important:** In order for affinity groups to take effect, a scheduling policy must be applied to the clusters in which the affinity groups are applied. This scheduling policy must have the ``VmAffinityGroups`` and `VmToHostsAffinityGroups` filter or weight modules enabled for affinity groups. For affinity labels, the scheduling policy must have the `Label` filter module enabled.

A further set of conditions can then be applied to these parameters in the associated scheduling policy.

* Hard enforcement - ensures that virtual machines in the affinity group run on a specified host or hosts in a group regardless of external conditions. The filter modules in the scheduling policy implement hard enforcement.

* Soft enforcement - indicates a preference for virtual machines in an affinity group to run on the specified host or hosts in a group when possible. The the weights modules in the scheduling policy implement soft enforcement.

The combination of an affinity group, its parameters, and its conditions is known as an affinity policy. Affinity policies are applied to running virtual machines immediately, without having to restart.

    **Note:** Affinity groups are applied to virtual machines on the cluster level. When a virtual machine is moved from one cluster to another, that virtual machine is removed from all affinity groups in the source cluster.

### Creating an Affinity Group

You can create new affinity groups in the Administration Portal.

**Creating Affinity Groups**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Affinity Groups** tab.

4. Click **New**.

5. Enter a **Name** and **Description** for the affinity group.

6. From the **VM Affinity Rule** drop-down, select **Positive** to apply positive affinity or **Negative** to apply negative affinity. Select **Disable** to disable the affinity rule.

7. Select the **Enforcing** check box to apply hard enforcement, or ensure this check box is cleared to apply soft enforcement.

8. Use the drop-down list to select the virtual machines to be added to the affinity group. Use the **+** and **-** buttons to add or remove additional virtual machines.

9. Click **OK**.

### Editing an Affinity Group

**Editing Affinity Groups**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Affinity Groups** tab.

4. Click **Edit**.

5. Change the **VM Affinity Rule** drop-down and **Enforcing** check box to the preferred values and use the **+** and **-** buttons to add or remove virtual machines to or from the affinity group.

6. Click **OK**.

### Removing an Affinity Group

**Removing Affinity Groups**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click the virtual machine’s name to go to the details view.

3. Click the **Affinity Groups** tab.

4. Click **Remove**.

5. Click **OK**.

The affinity policy that applied to the virtual machines that were members of that affinity group no longer applies.

## Affinity Labels

You can create and modify affinity labels in the Administration Portal.

Affinity labels are used to set hard (Enforced) positive affinity between virtual machines and hosts. See the Affinity Groups section for more information about affinity hardness and polarity.

Labels function identically to a hard positive affinity group, but simplify configuration in certain use cases. For example, if you have virtual machines that require specific host hardware, you can use affinity labels to ensure that those virtual machines run on the required hosts. If you use software that is license-limited to a certain number of physical machines, you can use affinity labels to ensure that virtual machines running that software are limited to the required physical hosts.

    **Warning:** Affinity labels are a subset of affinity groups and can conflict with them. If there is a conflict, the virtual machine will not start.

### Creating an Affinity Label

You can create affinity labels from the details view of a virtual machine, host, or cluster. This procedure uses the cluster details view.

**Creating an Affinity Label**

1. Click **Compute** &rarr; **Clusters** and select the appropriate cluster.

2. Click the cluster’s name to go to the details view.

3. Click the **Affinity Labels** tab.

4. Click **New**.

5. Enter a **Name** for the affinity label.

6. Use the drop-down lists to select the virtual machines and hosts to be associated with the label. Use the **+** button to add additional virtual machines and hosts.

7. Click **OK**.

### Editing an Affinity Label

You can edit affinity labels from the details view of a virtual machine, host, or cluster. This procedure uses the cluster details view.

**Editing an Affinity Label**

1. Click **Compute** &rarr; **Clusters** and select the appropriate cluster.

2. Click the cluster’s name to go to the details view.

3. Click the **Affinity Labels** tab.

4. Select the label you want to edit.

5. Click **Edit**.

6. Use the **+** and **-** buttons to add or remove virtual machines and hosts to or from the affinity label.

7. Click OK.

### Removing an Affinity Label

You can remove affinity labels only from the details view of a cluster.

**Removing an Affinity Label**

1. Click **Compute** &rarr; **Clusters** and select the appropriate cluster.

2. Click the cluster’s name to go to the details view.

3. Click the **Affinity Labels** tab.

4. Select the label you want to remove.

5. Click **Edit**.

6. Use the **-** buttons to remove all virtual machines and hosts from the label.

7. Click **OK**.

8. Click **Delete**.

9. Click **OK**.

## Exporting and Importing Virtual Machines and Templates

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the "Importing Existing Storage Domains" section in the [Administration Guide](/documentation/administration_guide/) for information on importing storage domains.

Virtual machines and templates can be exported from and imported to data centers in the same or different oVirt environment. You can export or import virtual machines by using an export domain, or by using a oVirt host. Templates can only be imported or exported using an export domain.

When you export or import a virtual machine or template, properties including basic details such as the name and description, resource allocation, and high availability settings of that virtual machine or template are preserved.

The permissions and user roles of virtual machines and templates are included in the OVF files, so that when a storage domain is detached from one data center and attached to another, the virtual machines and templates can be imported with their original permissions and user roles. In order for permissions to be registered successfully, the users and roles related to the permissions of the virtual machines or templates must exist in the data center before the registration process.

You can also use the V2V feature to import virtual machines from other virtualization providers, such as Xen or VMware, or import Windows virtual machines. V2V converts virtual machines so that they can be hosted by oVirt.

**Important:** Virtual machines must be shut down before being exported or imported.

### Exporting a Virtual Machine to the Export Domain

Export a virtual machine to the export domain so that it can be imported into a different data center. Before you begin, the export domain must be attached to the data center that contains the virtual machine to be exported.

**Warning:** The virtual machine must be shut down before being exported.

**Exporting a Virtual Machine to the Export Domain**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **More Actions** &rarr; **Export to Export Domain**.

3. Optionally select the following check boxes:

    * **Force Override**: overrides existing images of the virtual machine on the export domain.

    * **Collapse Snapshots**: creates a single export volume per disk. This option removes snapshot restore points and includes the template in a template-based virtual machine, and removes any dependencies a virtual machine has on a template. For a virtual machine that is dependent on a template, either select this option, export the template with the virtual machine, or make sure the template exists in the destination data center.

        **Note:** When you create a virtual machine from a template by clicking **Compute** &rarr; **Templates** and clicking **New VM**, you will see two storage allocation options in the **Storage Allocation** section in the **Resource Allocation** tab:

        * If **Clone** was selected, the virtual machine is not dependent on the template. The template does not have to exist in the destination data center.

        * If **Thin** was selected, the virtual machine is dependent on the template, so the template must exist in the destination data center or be exported with the virtual machine. Alternatively, select the **Collapse Snapshots** check box to collapse the template disk and virtual machine disk into a single disk.

        To check which option was selected, select a virtual machine and click the **General** tab in the details pane.

4. Click **OK**.

The export of the virtual machine begins. The virtual machine displays in **Compute** &rarr; **Virtual Machines** with an `Image Locked` status while it is exported. Depending on the size of your virtual machine hard disk images, and your storage hardware, this can take up to an hour. Use the **Events** tab to view the progress. When complete, the virtual machine has been exported to the export domain and displays on the **VM Import** tab of the export domain's details pane.

### Importing a Virtual Machine from the Export Domain

You have a virtual machine on an export domain. Before the virtual machine can be imported to a new data center, the export domain must be attached to the destination data center.

**Importing a Virtual Machine into the Destination Data Center**

1. Click **Storage** &rarr; **Domains**, and select the export domain. The export domain must have a status of `Active`.

2. Click the export domain’s name to go to the details view.

3. Click the **VM Import** tab to list the available virtual machines to import.

4. Select one or more virtual machines to import and click **Import**.

5. Select the **Target Cluster**.

6. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

7. Click the virtual machine to be imported and click on the **Disks** sub-tab. From this tab, you can use the **Allocation Policy** and **Storage Domain** drop-down lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and can also select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

8. Click **OK** to import the virtual machines.

   The **Import Virtual Machine Conflict** window opens if the virtual machine exists in the virtualized environment.

   Choose one of the following radio buttons:

    * **Don't import**

    * **Import as cloned** and enter a unique name for the virtual machine in the **New Name** field.

9. Optionally select the **Apply to all** check box to import all duplicated virtual machines with the same suffix, and then enter a suffix in the **Suffix to add to the cloned VMs** field.

10. Click **OK**.

    **Important:** During a single import operation, you can only import virtual machines that share the same architecture. If any of the virtual machines to be imported have a different architecture to that of the other virtual machines to be imported, a warning will display and you will be prompted to change your selection so that only virtual machines with the same architecture will be imported.

### Importing a Virtual Machine from a VMware Provider

Import virtual machines from a VMware vCenter provider to your oVirt environment. You can import from a VMware provider by entering its details in the **Import Virtual Machine(s)** window during each import operation, or you can add the VMware provider as an external provider, and select the preconfigured provider during import operations. To add an external provider, see "Adding a VMware Instance as a Virtual Machine Provider" in the [Administration Guide](/documentation/administration_guide/).

oVirt uses V2V to convert VMware virtual machines to the correct format before they are imported. You must install the `virt-v2v` package on a least one Enterprise Linux 7 host before proceeding. This package is available in the base `rhel-7-server-rpms` repository.

The `virt-v2v` package must be installed on at least one host (referred to in this procedure as the proxy host). The `virt-v2v` package is available by default on oVirt Node and is installed on Enterprise Linux hosts as a dependency of VDSM when added to the oVirt environment. Red Hat Enterprise Linux hosts must be Enterprise Linux 7.2 or later.

    **Note:** The `virt-v2v` package is not available on the ppc64le architecture and these hosts cannot be used as proxy hosts.

    **Warning:** The virtual machine must be shut down before being imported. Starting the virtual machine through VMware during the import process can result in data corruption.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **Note:** If the import fails, refer to the relevant log file in **/var/log/vdsm/import/** and to **/var/log/vdsm/vdsm.log** on the proxy host for details.

**Importing a Virtual Machine from VMware**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click **More Actions** &rarr; **Import** to open the **Import Virtual Machine(s)** window.

3. Select **VMware** from the **Source** list.

4. If you have configured a VMware provider as an external provider, select it from the **External Provider** list. Verify that the provider credentials are correct. If you did not specify a destination data center or proxy host when configuring the external provider, select those options now.

5. If you have not configured a VMware provider, or want to import from a new VMware provider, provide the following details:

    i. Select from the list the **Data Center** in which the virtual machine will be available.

    ii. Enter the IP address or fully qualified domain name of the VMware vCenter instance in the **vCenter** field.

    iii. Enter the IP address or fully qualified domain name of the host from which the virtual machines will be imported in the **ESXi** field.

    iv. Enter the name of the data center and the cluster in which the specified ESXi host resides in the **Data Center** field.

    v. If you have exchanged the SSL certificate between the ESXi host and the Engine, leave **Verify server's SSL certificate** checked to verify the ESXi host's certificate. If not, uncheck the option.

    vi. Enter the **Username** and **Password** for the VMware vCenter instance. The user must have access to the VMware data center and ESXi host on which the virtual machines reside.

    vii. Select a host in the chosen data center with `virt-v2v` installed to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the VMware vCenter external provider.

6. Click **Load** to generate a list of the virtual machines on the VMware provider.

7. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list. Click **Next**.

    **Note:** If a virtual machine's network device uses the driver type e1000 or rtl8139, the virtual machine will use the same driver type after it has been imported to oVirt.

    If required, you can change the driver type to VirtIO manually after the import. To change the driver type after a virtual machine has been imported, see [Editing network interfaces](/documentation/vmm-guide/chap-Editing_Virtual_Machines.html/#editing-a-network-interface). If the network device uses driver types other than e1000 or rtl8139, the driver type is changed to VirtIO automatically during the import. The **Attach VirtIO-drivers** option allows the VirtIO drivers to be injected to the imported virtual machine files so that when the driver is changed to VirtIO, the device will be properly detected by the operating system.

    **The Import Virtual Machine(s) Window**

    ![](/images/vmm-guide/7325.png)

8. Select the **Cluster** in which the virtual machines will reside.

9. Select a **CPU Profile** for the virtual machines.

10. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

11. Select the **Clone** check box to change the virtual machine name and MAC addresses, and clone all disks, removing all snapshots. If a virtual machine appears with a warning symbol beside its name or has a tick in the **VM in System** column, you must clone the virtual machine and change its name.

12. Click on each virtual machine to be imported and click on the **Disks** sub-tab. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

13. If you selected the **Clone** check box, change the name of the virtual machine in the **General** sub-tab.

14. Click **OK** to import the virtual machines.

The CPU type of the virtual machine must be the same as the CPU type of the cluster into which it is being imported. To view the cluster’s **CPU Type** in the Administration Portal:

1. Click **Compute** &rarr; **Clusters**.

2. Select a cluster.

3. Click **Edit**.

4. Click the **General** tab.

If the CPU type of the virtual machine is different, configure the imported virtual machine’s CPU type:

1. Click **Compute** &rarr; **Virtual Machines**.

2. Select the virtual machine.

3. Click **Edit**.

4. Click the **System** tab.

5. Click the **Advanced Parameters** arrow.

6. Specify the **Custom CPU Type** and click **OK**.

### Exporting a Virtual Machine to a Host

You can export a virtual machine to a specific path or mounted NFS shared storage on a host in the oVirt data center. The export will produce an Open Virtual Appliance (OVA) package.

**Warning:** The virtual machine must be shut down before being exported.

**Exporting a Virtual Machine to a Host**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **More Actions** &rarr; **Export to OVA**.

3. Select the host from the **Host** drop-down list.

4. Enter the absolute path to the export directory in the **Directory** field.

5. Optionally change the default name of the file in the **Name** field.

6. Click **OK**.

The status of the export can be viewed in the **Events** tab.

## Importing a Virtual Machine from a Host

Import an Open Virtual Appliance (OVA) file into your oVirt environment. You can import the file from any oVirt host in the data center.

    **Important:** Currently, only oVirt and VMware OVAs can be imported. KVM and Xen are not supported.

    The import process uses virt-v2v. Only virtual machines running operating systems compatible with virt-v2v can be successfully imported.

**Importing an OVA File**

1. Copy the OVA file to a host in your cluster, in a file system location such as **var/tmp**.

  **Note:** The location can be a local directory or a remote nfs mount, as long as it has sufficient space and is accessible to the qemu user (UID 36).

2. Ensure that the OVA file has permissions allowing read/write access to the **qemu** user (UID 36) and the **kvm** group (GID 36):

        # chown 36:36 path_to_OVA_file/file.OVA

3. Click **Compute** &rarr; **Virtual Machines**.

4. Click **More Actions** &rarr; **Import** to open the **Import Virtual Machine(s)** window.

  i. Select **Virtual Appliance (OVA)** from the **Source** list.

  ii. Select a host from the **Host** list.

  iii. In the **Path** field, specify the absolute path of the OVA file.

  iv. Click **Load** to list the virtual machine to be imported.

  v. Select the virtual machine from the **Virtual Machines on Source** list, and use the arrows to move it to the **Virtual Machines to Import** list.

5. Click **Next**.

  i. Select the **Storage Domain** for the virtual machine.

  ii. Select the **Target Cluster** where the virtual machines will reside.

  iii. Select the **CPU Profile** for the virtual machines.

  iv. Select the **Allocation Policy** for the virtual machines.

  v. Optionally, select the **Attach VirtIO-Drivers** check box and select the appropriate image on the list to add VirtIO drivers.

  vi. Select the **Allocation Policy** for the virtual machines.

  vii. Select the virtual machine, and on the **General** tab select the **Operating System**.

  vii. On the **Network Interfaces** tab, select the **Network Name** and **Profile** Name.

  ix. Click the **Disks** tab to view the **Alias**, **Virtual Size**, and **Actual Size** of the virtual machine.

6. Click **OK** to import the virtual machines.

### Importing a Virtual Machine from a Xen Host

Import virtual machines from Xen on Enterprise Linux 5 to your oVirt environment. oVirt uses V2V to import QCOW2 or raw virtual machine disk formats.

The `virt-v2v` package must be installed on at least one host (referred to in this procedure as the proxy host). The `virt-v2v` package is available by default on oVirt Node and is installed on Enterprise Linux hosts as a dependency of VDSM when added to the oVirt environment. Enterprise Linux hosts must be Enterprise Linux 7.2 or later.

    **Warning:** If you are importing a Windows virtual machine from a Xen host and you are using VirtIO devices, install the VirtIO drivers before importing the virtual machine. If the drivers are not installed, the virtual machine may not boot after import.

    The VirtIO drivers can be installed from the **virtio-win.iso** or the **rhev-tools-setup.iso**.

    If you are not using VirtIO drivers, review the configuration of the virtual machine before first boot to ensure that VirtIO devices are not being used.

    **Note:** The `virt-v2v` package is not available on the ppc64le architecture and these hosts cannot be used as proxy hosts.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **Note:** If the import fails, refer to the relevant log file in **/var/log/vdsm/import/** and to **/var/log/vdsm/vdsm.log** on the proxy host for details.

**Importing a Virtual Machine from Xen**

1. Shut down the virtual machine. Starting the virtual machine through Xen during the import process can result in data corruption.

2. Enable public key authentication between the proxy host and the Xen host:

    i. Log in to the proxy host and generate SSH keys for the **vdsm** user.

            # sudo -u vdsm ssh-keygen

    ii. Copy the **vdsm** user's public key to the Xen host.

            # sudo -u vdsm ssh-copy-id root@xenhost.example.com

    iii. Log in to the Xen host to verify that the login works correctly.

            # sudo -u vdsm ssh root@xenhost.example.com

3. Log in to the Administration Portal.

4. Click **Compute** &rarr; **Virtual Machines**.

5. Click **More Actions** &rarr; **Import** to open the **Import Virtual Machine(s)** window.

6. Select the **Data Center** that contains the proxy host.

7. Select **XEN (via RHEL)** from the **Source** drop-down list.

8. Optionally, select a Xen provider **External Provider** from the drop-down list. The URI will be pre-filled with the correct URI.

9. Enter the **URI** of the Xen host. The required format is pre-filled; you must replace `<hostname>` with the host name of the Xen host.

10. Select the proxy host from the **Proxy Host** drop-down list.

11. Click **Load** to list the virtual machines on the Xen host that can be imported.

12. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list.

    **Note:** Due to current limitations, Xen virtual machines with block devices do not appear in the **Virtual Machines on Source** list, and cannot be imported to oVirt.

13. Click **Next**.

14. Select the **Cluster** in which the virtual machines will reside.

15. Select a **CPU Profile** for the virtual machines.

16. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and select the storage domain on which the disk will be stored.

    **Note**: The target storage domain must be a file-based domain. Due to current limitations, specifying a block-based domain causes the V2V operation to fail.

17. If a virtual machine appears with a warning symbol beside its name, or has a tick in the **VM in System** column, select the **Clone** check box to clone the virtual machine.

**Note:** Cloning a virtual machine changes its name and MAC addresses and clones all of its disks, removing all snapshots.

18. Click **OK** to import the virtual machines.

The CPU type of the virtual machine must be the same as the CPU type of the cluster into which it is being imported. To view the cluster’s **CPU Type** in the Administration Portal:

1. Click **Compute** &rarr; **Clusters**.

2. Select a cluster.

3. Click **Edit**.

4. Click the **General** tab.

If the CPU type of the virtual machine is different, configure the imported virtual machine’s CPU type:

1. Click **Compute** &rarr; **Virtual Machines**.

2. Select the virtual machine.

3. Click **Edit**.

4. Click the **System** tab.

5. Click the **Advanced Parameters** arrow.

6. Specify the **Custom CPU Type** and click **OK**.

**Importing a Block-Based Virtual Machine from a Xen Host**

1. Enable public key authentication between the proxy host and the Xen host:

  i. Log in to the proxy host and generate SSH keys for the **vdsm** user.

          # sudo -u vdsm ssh-keygen

  ii. Copy the **vdsm** user’s public key to the Xen host.

          # sudo -u vdsm ssh-copy-id root@xenhost.example.com

  iii. Log in to the Xen host to verify that the login works correctly.

          # sudo -u vdsm ssh root@xenhost.example.com

2. Attach an export domain.

3. On the proxy host, copy the virtual machine from the Xen host:

        # virt-v2v-copy-to-local -ic xen+ssh://root@xenhost.example.com vmname

4. Convert the virtual machine to libvirt XML and move the file to your export domain:

        # virt-v2v -i libvirtxml vmname.xml -o rhev -of raw -os storage.example.com:/exportdomain

5. In the Administration Portal, click **Storage** &rarr; **Domains**, click the export domain’s name, and click the **VM Import** tab in the details view to verify that the virtual machine is in your export domain.

6. Import the virtual machine into the destination data domain. See the “Importing a Virtual Machine from the Export Domain” section above.

### Importing a Virtual Machine from a KVM Host

Import virtual machines from KVM to your oVirt environment. oVirt converts KVM virtual machines to the correct format before they are imported. You must enable public key authentication between the KVM host and at least one host in the destination data center (this host is referred to in the following procedure as the proxy host).

    **Warning:** The virtual machine must be shut down before being imported. Starting the virtual machine through VMware during the import process can result in data corruption.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **Note:** If the import fails, refer to the relevant log file in **/var/log/vdsm/import/** and to **/var/log/vdsm/vdsm.log** on the proxy host for details.

**Importing a Virtual Machine from KVM**

1. Enable public key authentication between the proxy host and the KVM host:

  i. Log in to the proxy host and generate SSH keys for the **vdsm** user.

          # sudo -u vdsm ssh-keygen

  ii. Copy the **vdsm** user’s public key to the KVM host. The proxy host’s **known_hosts** file will also be updated to include the host key of the KVM host.

          # sudo -u vdsm ssh-copy-id root@kvmhost.example.com

  iii. Log in to the KVM host to verify that the login works correctly.

          # sudo -u vdsm ssh root@kvmhost.example.com

2. Log in to the Administration Portal.

3. Click **Compute** &rarr; **Virtual Machines**.

4. Click **More Actions** &rarr; **Import** to open the **Import Virtual Machine(s)** window.

5. Select the **Data Center** that contains the proxy host.

6. Select **KVM (via Libvirt)** from the **Source** drop-down list.

7. Optionally, select a KVM provider **External Provider** from the drop-down list. The URI will be pre-filled with the correct URI.

8. Enter the **URI** of the KVM host in the following format:

        qemu+ssh://root@kvmhost.example.com/system

9. Keep the **Requires Authentication** check box selected.

10. Enter `root` in the **Username** field.

11. Enter the **Password** of the KVM host’s root user.

12. Select the **Proxy Host** from the drop-down list.

13. Click **Load** to list the virtual machines on the KVM host that can be imported.

14. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list.

15. Click **Next**.

16. Select the **Cluster** in which the virtual machines will reside.

17. Select a **CPU Profile** for the virtual machines.

18. Optionally, select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

19. Optionally, select the **Clone** check box to change the virtual machine name and MAC addresses, and clone all disks, removing all snapshots. If a virtual machine appears with a warning symbol beside its name or has a tick in the **VM in System** column, you must clone the virtual machine and change its name.

20. Click on each virtual machine to be imported and click on the **Disks** sub-tab. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thin provisioned or preallocated, and select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

    **Note:** The target storage domain must be a file-based domain. Due to current limitations, specifying a block-based domain causes the operation to fail.

21. If you selected the **Clone** check box, change the name of the virtual machine in the **General** tab.

22. Click **OK** to import the virtual machines.

The CPU type of the virtual machine must be the same as the CPU type of the cluster into which it is being imported. To view the cluster’s **CPU Type** in the Administration Portal:

1. Click **Compute** &rarr; **Clusters**.

2. Select a cluster.

3. Click **Edit**.

4. Click the **General** tab.

If the CPU type of the virtual machine is different, configure the imported virtual machine’s CPU type:

1. Click **Compute** &rarr; **Virtual Machines**.

2. Select the virtual machine.

3. Click **Edit**.

4. Click the **System** tab.

5. Click the **Advanced Parameters** arrow.

6. Specify the **Custom CPU Type** and click **OK**.

## Migrating Virtual Machines Between Hosts

Live migration provides the ability to move a running virtual machine between physical hosts with no interruption to service. The virtual machine remains powered on and user applications continue to run while the virtual machine is relocated to a new physical host. In the background, the virtual machine’s RAM is copied from the source host to the destination host. Storage and network connectivity are not altered.

**Note:** A virtual machine that is using a vGPU cannot be migrated to a different host.

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

Live migration is performed using the management network. Each live migration event is limited to a maximum transfer speed of 30 MBps, and the number of concurrent migrations supported is also limited by default. Despite these measures, concurrent migrations have the potential to saturate the management network. It is recommended that separate logical networks are created for storage, display, and virtual machine data to minimize the risk of network saturation.

**Configuring Virtual Machines with SR-IOV-Enabled vNICs to Reduce Network Outage during Migration**

Virtual machines with vNICs that are directly connected to a virtual function (VF) of an SR-IOV-enabled host NIC can be further configured to reduce network outage during live migration:

* Ensure that the destination host has an available VF.

* Set the **Passthrough** and **Migratable** options in the passthrough vNIC’s profile.

* Enable hotplugging for the virtual machine’s network interface.

* Ensure that the virtual machine has a backup VirtIO vNIC, in addition to the passthrough vNIC, to maintain the virtual machine’s network connection during migration.

* Set the VirtIO vNIC’s `No Network Filter` option before configuring the bond.

* Add both vNICs as subordinate to an `active-backup` bond on the virtual machine, with the passthrough vNIC as the primary interface.

  The bond and vNIC profiles can have one of the following configurations:

  * **Recommended:** The bond is not configured with `fail_over_mac=active` and the VF vNIC is the primary slave.

  * Disable the VirtIO vNIC profile’s MAC-spoofing filter to ensure that traffic passing through the VirtIO vNIC is not dropped because it uses the VF vNIC MAC address.

  * The bond is configured with `fail_over_mac=active`.

    This failover policy ensures that the MAC address of the bond is always the MAC address of the active slave. During failover, the virtual machine’s MAC address changes, with a slight disruption in traffic.

### Optimizing Live Migration

Live virtual machine migration can be a resource-intensive operation. The following two options can be set globally for every virtual machine in the environment, at the cluster level, or at the individual virtual machine level to optimize live migration.

The **Auto Converge migrations** option allows you to set whether auto-convergence is used during live migration of virtual machines. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine.

The **Enable migration compression** option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern.

Both options are disabled globally by default.

**Configuring Auto-convergence and Migration Compression for Virtual Machine Migration**

1. Configure the optimization settings at the global level:

    i. Enable auto-convergence at the global level:

            # engine-config -s DefaultAutoConvergence=True

    ii. Enable migration compression at the global level:

            # engine-config -s DefaultMigrationCompression=True

    iii. Restart the `ovirt-engine` service to apply the changes:

            # systemctl restart ovirt-engine.service

2. Configure the optimization settings at the cluster level:

    i. Click **Compute** &rarr; **Clusters** and select a cluster.

    ii. Click **Edit**.

    iii. Click the **Migration Policy** tab.

    iv. From the **Auto Converge migrations** list, select **Inherit from global setting**, **Auto Converge**, or **Don't Auto Converge**.

    v. From the **Enable migration compression** list, select **Inherit from global setting**, **Compress**, or **Don't Compress**.

    vi. Click **OK**.

3. Configure the optimization settings at the virtual machine level:

    i. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

    ii. Click **Edit**.

    iii. Click the **Host** tab.

    iv. From the **Auto Converge migrations** list, select **Inherit from cluster setting**, **Auto Converge**, or **Don't Auto Converge**.

    v. From the **Enable migration compression** list, select **Inherit from cluster setting**, **Compress**, or **Don't Compress**.

    vi. Click **OK**.

### Guest Agent Hooks

Hooks are scripts that trigger activity within a virtual machine when key events occur:

* Before migration

* After migration

* Before hibernation

* After hibernation

The hooks configuration base directory is **/etc/ovirt-guest-agent/hooks.d** on Linux systems and **C:\Program Files\Redhat\RHEV\Drivers\Agent** on Windows systems.

Each event has a corresponding subdirectory: `before_migration` and `after_migration`. All files or symbolic links in that directory will be executed.

The executing user on Linux systems is `ovirtagent`. If the script needs `root` permissions, the elevation must be executed by the creator of the hook script.

The executing user on Windows systems is the `System Service` user.

### Automatic Virtual Machine Migration

oVirt Engine automatically initiates live migration of all virtual machines running on a host when the host is moved into maintenance mode. The destination host for each virtual machine is assessed as the virtual machine is migrated, in order to spread the load across the cluster.

The Engine automatically initiates live migration of virtual machines in order to maintain load balancing or power saving levels in line with scheduling policy. While no scheduling policy is defined by default, it is recommended that you specify the scheduling policy which best suits the needs of your environment. You can also disable automatic, or even manual, live migration of specific virtual machines where required.

### Preventing Automatic Migration of a Virtual Machine

oVirt Engine allows you to disable automatic migration of virtual machines. You can also disable manual migration of virtual machines by setting the virtual machine to run only on a specific host.

The ability to disable automatic migration and require a virtual machine to run on a particular host is useful when using application high availability products.

**Preventing Automatic Migration of Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Use the **Start Running On** adio buttons to specify whether the virtual machine should run on any host in the cluster, or a specific host or group of hosts.

    **Warning:** Explicitly assigning a virtual machine to one specific host and disabling migration is mutually exclusive with oVirt high availability. Virtual machines that are assigned to one specific host can only be made highly available using third-party high availability products. This restriction does not apply to virtual machines that are assigned to multiple specific hosts.

    **Important:** If the virtual machine has host devices directly attached to it, and a different host is specified, the host devices from the previous host will be automatically removed from the virtual machine.

5. Select **Allow manual migration only** or **Do not allow migration** from the **Migration Options** drop-down list.

6. Optionally, select the **Use custom migration downtime** check box and specify a value in milliseconds.

7. Click **OK**.

### Manually Migrating Virtual Machines

A running virtual machine can be live migrated to any host within its designated host cluster. Live migration of virtual machines does not cause any service interruption. Migrating virtual machines to a different host is especially useful if the load on a particular host is too high. For live migration prerequisites, see the "Live migration prerequisites" section.

    **Note:** When you place a host into maintenance mode, the virtual machines running on that host are automatically migrated to other hosts in the same cluster. You do not need to manually migrate these virtual machines.

    **Note:** Live migrating virtual machines between different clusters is generally not recommended.

**Manually Migrating Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Migrate**.

3. Use the radio buttons to select whether to **Select Host Automatically** or to **Select Destination Host**, specifying the host using the drop-down list.

    **Note:** When the **Select Host Automatically** option is selected, the system determines the host to which the virtual machine is migrated according to the load balancing and power management rules set up in the scheduling policy.

4. Click **OK**.

During migration, progress is shown in the **Migration** progress bar. Once migration is complete the **Host** column will update to display the host the virtual machine has been migrated to.

### Setting Migration Priority

oVirt Engine queues concurrent requests for migration of virtual machines off of a given host. The load balancing process runs every minute. Hosts already involved in a migration event are not included in the migration cycle until their migration event has completed. When there is a migration request in the queue and available hosts in the cluster to action it, a migration event is triggered in line with the load balancing policy for the cluster.

You can influence the ordering of the migration queue by setting the priority of each virtual machine; for example, setting mission critical virtual machines to migrate before others. Migrations will be ordered by priority; virtual machines with the highest priority will be migrated first.

**Setting Migration Priority**

1.  Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Select the **High Availability** tab.

4. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list.

5. Click **OK**.

### Canceling Ongoing Virtual Machine Migrations

A virtual machine migration is taking longer than you expected. You'd like to be sure where all virtual machines are running before you make any changes to your environment.

**Canceling Ongoing Virtual Machine Migrations**

1. Select the migrating virtual machine. It is displayed in **Compute** &rarr; **Virtual Machines** with a status of **Migrating from**.

2. Click **More Actions** &rarr; **Cancel Migration**.

The virtual machine status returns from **Migrating from** to **Up**.

### Event and Log Notification upon Automatic Migration of Highly Available Virtual Servers

When a virtual server is automatically migrated because of the high availability function, the details of an automatic migration are documented in the **Events** tab and in the engine log to aid in troubleshooting, as illustrated in the following examples:

**Notification in the Events Tab of the Web Admin Portal**

Highly Available `Virtual_Machine_Name` failed. It will be restarted automatically.

`Virtual_Machine_Name` was restarted on Host `Host_Name`

**Notification in the Engine engine.log**

This log can be found on the oVirt Engine at **/var/log/ovirt-engine/engine.log**:

Failed to start Highly Available VM. Attempting to restart. VM Name: `Virtual_Machine_Name`, VM Id:`Virtual_Machine_ID_Number`

## Improving Uptime with Virtual Machine High Availability

### What is High Availability?

High availability is recommended for virtual machines running critical workloads. A highly available virtual machine is automatically restarted, either on its original host or another host in the cluster, if its process is interrupted, such as in the following scenarios:

* A host becomes non-operational due to hardware failure.

* A host is put into maintenance mode for scheduled downtime.

* A host becomes unavailable because it has lost communication with an external storage resource.

A highly available virtual machine is not restarted if it is shut down cleanly, such as in the following scenarios:

* The virtual machine is shut down from within the guest.

* The virtual machine is shut down from the Manager.

* The host is shut down by an administrator without being put in maintenance mode first.

With storage domains V4 or later, virtual machines have the additional capability to acquire a lease on a special volume on the storage, enabling a virtual machine to start on another host even if the original host loses power. The functionality also prevents the virtual machine from being started on two different hosts, which may lead to corruption of the virtual machine disks.

With high availability, interruption to service is minimal because virtual machines are restarted within seconds with no user intervention required. High availability keeps your resources balanced by restarting guests on a host with low current resource utilization, or based on any workload balancing or power saving policies that you configure. This ensures that there is sufficient capacity to restart virtual machines at all times.

**High Availability and Storage I/O Errors**

If a storage I/O error occurs, the virtual machine is paused. You can define how the host handles highly available virtual machines after the connection with the storage domain is reestablished; they can either be resumed, ungracefully shut down, or remain paused.

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

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **High Availability** tab.

4. Select the **Highly Available** check box to enable high availability for the virtual machine.

5. Select the storage domain to hold the virtual machine lease, or select **No VM Lease** to disable the functionality, from the **Target Storage Domain for VM Lease** drop-down list. See the “What is High Availability?” section above for more information about virtual machine leases.

    **Important:** This functionality is only available on storage domains that are V4 or later.

6. Select **AUTO_RESUME**, **LEAVE_PAUSED**, or **KILL** from the **Resume Behavior** drop-down list. If you defined a virtual machine lease, **KILL** is the only option available.

7. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.

8. Click **OK**.

## Other Virtual Machine Tasks

### Enabling SAP Monitoring

Enable SAP monitoring on a virtual machine through the Administration Portal.

**Enabling SAP Monitoring on Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **Custom Properties** tab.

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

There are two relevant parameters for time drift on hosts: `EnableHostTimeDrift` and `HostTimeDriftInSec`. `EnableHostTimeDrift`, with a default value of false, can be enabled to receive alert notifications of host time drift. The `HostTimeDriftInSec` parameter is used to set the maximum allowable drift before alerts start being sent.

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


**Prev:** [Chapter 5: Editing Virtual Machines](chap-Editing_Virtual_Machines) <br>
**Next:** [Chapter 7: Templates](chap-Templates)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-administrative_tasks)
