---
title: Templates
---

# Chapter 7: Templates

A template is a copy of a virtual machine that you can use to simplify the subsequent, repeated creation of similar virtual machines. Templates capture the configuration of software, configuration of hardware, and the software installed on the virtual machine on which the template is based. The virtual machine on which a template is based is known as the source virtual machine.

When you create a template based on a virtual machine, a read-only copy of the virtual machine's disk is created. This read-only disk becomes the base disk image of the new template, and of any virtual machines created based on the template. As such, the template cannot be deleted while any virtual machines created based on the template exist in the environment.

Virtual machines created based on a template use the same NIC type and driver as the original virtual machine, but are assigned separate, unique MAC addresses.

You can create a virtual machine directly from the **Templates** tab, as well as from the **Virtual Machines** tab. In the **Templates** tab, right-click the required template and select **New VM**. For more information on selecting the settings and controls for the new virtual machine see [Virtual Machine General settings explained](Virtual_Machine_General_settings_explained).

## Sealing Virtual Machines in Preparation for Deployment as Templates

This section describes procedures for sealing Linux virtual machines and Windows virtual machines. Sealing is the process of removing all system-specific details from a virtual machine before creating a template based on that virtual machine. Sealing is necessary to prevent the same details from appearing on multiple virtual machines created based on the same template. It is also necessary to ensure the functionality of other features, such as predictable vNIC order.

### Sealing a Linux Virtual Machine for Deployment as a Template

There are two main methods for sealing a Linux virtual machine in preparation for using that virtual machine to create a template: manually, or using the `sys-unconfig` command. Sealing a Linux virtual machine manually requires you to create a file on the virtual machine that acts as a flag for initiating various configuration tasks the next time you start that virtual machine. The `sys-unconfig` command allows you to automate this process. However, both of these methods also require you to manually delete files on the virtual machine that are specific to that virtual machine or might cause conflicts amongst virtual machines created based on the template you will create based on that virtual machine. As such, both are valid methods for sealing a Linux virtual machine and will achieve the same result.

#### Sealing a Linux Virtual Machine Manually for Deployment as a Template

You must generalize (seal) a Linux virtual machine before creating a template based on that virtual machine.

**Sealing a Linux Virtual Machine**

1. Log in to the virtual machine.

2. Flag the system for re-configuration:

        # touch /.unconfigured

3. Remove ssh host keys:

        # rm -rf /etc/ssh/ssh_host_*

4. Set `HOSTNAME=localhost.localdomain` in `/etc/sysconfig/network` for Enterprise Linux 6 or `/etc/hostname` for Enterprise Linux 7.

5. Remove `/etc/udev/rules.d/70-*`:

        # rm -rf /etc/udev/rules.d/70-*

6. Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.

7. Optionally, delete all the logs from `/var/log` and build logs from `/root`.

8. Shut down the virtual machine:

        # poweroff

The virtual machine is sealed and can be made into a template. You can deploy Linux virtual machines from this template without experiencing configuration file conflicts.

The steps provided are the minimum steps required to seal a Enterprise Linux virtual machine for use as a template. Additional host and site-specific custom steps are available.

#### Sealing a Linux Virtual Machine for Deployment as a Template using sys-unconfig

You must generalize (seal) a Linux virtual machine before creating a template based on that virtual machine.

**Sealing a Linux Virtual Machine using sys-unconfig**

1. Log in to the virtual machine.

2. Remove ssh host keys:

        # rm -rf /etc/ssh/ssh_host_*

3. Set `HOSTNAME=localhost.localdomain` in `/etc/sysconfig/network` for Enterprise Linux 6 or `/etc/hostname` for Enterprise Linux 7.

4. Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.

5. Optionally, delete all the logs from `/var/log` and build logs from `/root`.

6. Run the following command:

        # sys-unconfig

The virtual machine shuts down; it is now sealed and can be made into a template. You can deploy Linux virtual machines from this template without experiencing configuration file conflicts.

### Sealing a Windows Virtual Machine for Deployment as a Template

A template created for Windows virtual machines must be generalized (sealed) before being used to deploy virtual machines. This ensures that machine-specific settings are not reproduced in the template.

The Sysprep tool is used to seal Windows templates before use.

**Important:** Do not reboot the virtual machine during this process.

Before starting the Sysprep process, verify that the following settings are configured:

* The Windows Sysprep parameters have been correctly defined.

* If not, click **Edit** and enter the required information in the **Operating System** and **Domain** fields.

* The correct product key has been defined in an override file on the Engine.

    The override file needs to be created under `/etc/ovirt-engine/osinfo.conf.d/`, have a filename that puts it after `/etc/ovirt-engine/osinfo.conf.d/00-defaults.properties`, and end in `.properties`. For example, `/etc/ovirt-engine/osinfo.conf.d/10-productkeys.properties`. The last file will have precedent and override any other previous file.

    If not, copy the default values for your Windows operating system from `/etc/ovirt-engine/osinfo.conf.d/00-defaults.properties` into the override file, and input your values in the `productKey.value` and `sysprepPath.value` fields.

    **Windows 7 Default Configuration Values**

        # Windows7(11, OsType.Windows, false),false
        os.windows_7.id.value = 11
        os.windows_7.name.value = Windows 7
        os.windows_7.derivedFrom.value = windows_xp
        os.windows_7.sysprepPath.value = ${ENGINE_USR}/conf/sysprep/sysprep.w7
        os.windows_7.productKey.value =
        os.windows_7.devices.audio.value = ich6
        os.windows_7.devices.diskInterfaces.value.3.3 = IDE, VirtIO_SCSI, VirtIO
        os.windows_7.devices.diskInterfaces.value.3.4 = IDE, VirtIO_SCSI, VirtIO
        os.windows_7.devices.diskInterfaces.value.3.5 = IDE, VirtIO_SCSI, VirtIO
        os.windows_7.isTimezoneTypeInteger.value = false

#### Sealing a Windows 7, Windows 2008, or Windows 2012 Template

Seal a Windows 7, Windows 2008, or Windows 2012 template before using the template to deploy virtual machines.

**Sealing a Windows 7, Windows 2008, or Windows 2012 Template**

1. Launch *Sysprep* from `C:\Windows\System32\sysprep\sysprep.exe`.

2. Enter the following information into the *Sysprep* tool:

    * Under **System Cleanup Action**, select **Enter System Out-of-Box-Experience (OOBE)**.

    * Select the **Generalize** check box if you need to change the computer's system identification number (SID).

    * Under **Shutdown Options**, select **Shutdown**.

3. Click **OK** to complete the sealing process; the virtual machine shuts down automatically upon completion.

The Windows 7, Windows 2008, or Windows 2012 template is sealed and ready for deploying virtual machines.

## Editing a Template

Once a template has been created, its properties can be edited. Because a template is a copy of a virtual machine, the options available when editing a template are identical to those in the **Edit Virtual Machine** window.

**Editing a Template**

1. Click the **Templates** tab and select a template.

2. Click **Edit**.

3. Change the necessary properties.

4. Click **OK**.

## Deleting a Template

If you have used a template to create a virtual machine using the thin provisioning storage allocation option, the template cannot be deleted as the virtual machine needs it to continue running. However, cloned virtual machines do not depend on the template they were cloned from and the template can be deleted.

**Deleting a Template**

1. Click the **Templates** tab and select a template.

2. Click **Remove**.

3. Click **OK**.

## Exporting Templates

### Migrating Templates to the Export Domain

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the "Importing Existing Storage Domains" section in the [Administration Guide](/documentation/admin-guide/administration-guide/) for information on importing storage domains.

Export templates into the export domain to move them to another data domain, either in the same ovirt environment, or another one. This procedure requires access to the Administration Portal.

**Exporting Individual Templates to the Export Domain**

1. Click the **Templates** tab and select a template.

2. Click **Export**.

3. Select the **Force Override** check box to replace any earlier version of the template on the export domain.

4. Click **OK** to begin exporting the template; this may take up to an hour, depending on the virtual machine disk image size and your storage hardware.

Repeat these steps until the export domain contains all the templates to migrate before you start the import process.

Click the **Storage** tab, select the export domain, and click the **Template Import** tab in the details pane to view all exported templates in the export domain.

### Copying a Template's Virtual Hard Disk

If you are moving a virtual machine that was created from a template with the thin provisioning storage allocation option selected, the template's disks must be copied to the same storage domain as that of the virtual machine disk. This procedure requires access to the Administration Portal.

**Copying a Virtual Hard Disk**

1. Click the **Disks** tab and select the template disk(s) to copy.

2. Click **Copy**.

3. Select the **Target** data domain from the drop-down list(s).

4. Click **OK**.

A copy of the template's virtual hard disk has been created, either on the same, or a different, storage domain. If you were copying a template disk in preparation for moving a virtual hard disk, you can now move the virtual hard disk.

## Importing Templates

### Importing a Template into a Data Center

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the "Importing Existing Storage Domains" section in the [Administration Guide](/documentation/admin-guide/administration-guide/) for information on importing storage domains.

Import templates from a newly attached export domain. This procedure requires access to the Administration Portal.

**Importing a Template into a Data Center**

1. Click the **Storage** tab and select the newly attached export domain.

2. Click the **Template Import** tab in the details pane and select a template.

3. Click **Import**.

4. Select the templates to import.

5. Use the drop-down lists to select the **Destination Cluster** and **Storage** domain. Alter the **Suffix** if applicable.

    Alternatively, clear the **Clone All Templates** check box.

6. Click **OK** to import templates and open a notification window. Click **Close** to close the notification window.

The template is imported into the destination data center. This can take up to an hour, depending on your storage hardware. You can view the import progress in the **Events** tab.

Once the importing process is complete, the templates will be visible in the **Templates** resource tab. The templates can create new virtual machines, or run existing imported virtual machines based on that template.

### Importing a Virtual Disk Image from an OpenStack Image Service as a Template

Virtual disk images managed by an OpenStack Image Service can be imported into the ovirt Engine if that OpenStack Image Service has been added to the Engine as an external provider. This procedure requires access to the Administration Portal.

1. Click the **Storage** tab and select the OpenStack Image Service domain.

2. Click the **Images** tab in the details pane and select the image to import.

3. Click **Import**.

4. Select the **Data Center** into which the virtual disk image will be imported.

5. Select the storage domain in which the virtual disk image will be stored from the **Domain Name** drop-down list.

6. Optionally, select a **Quota** to apply to the virtual disk image.

7. Select the **Import as Template** check box.

8. Select the **Cluster** in which the virtual disk image will be made available as a template.

9. Click **OK**.

The image is imported as a template and is displayed in the **Templates** tab. You can now create virtual machines based on the template.


## Templates and Permissions

### Managing System Permissions for a Template

As the **SuperUser**, the system administrator manages all aspects of the Administration Portal. More specific administrative roles can be assigned to other users. These restricted administrator roles are useful for granting a user administrative privileges that limit them to a specific resource. For example, a **DataCenterAdmin** role has administrator privileges only for the assigned data center with the exception of the storage for that data center, and a **ClusterAdmin** has administrator privileges only for the assigned cluster.

A template administrator is a system administration role for templates in a data center. This role can be applied to specific virtual machines, to a data center, or to the whole virtualized environment; this is useful to allow different users to manage certain virtual resources.

The template administrator role permits the following actions:

* Create, edit, export, and remove associated templates.

* Import and export templates.

**Note:** You can only assign roles and permissions to existing users.

### Template Administrator Roles Explained

The table below describes the administrator roles and privileges applicable to template administration.

**ovirt System Administrator Roles**

| Role | Privileges | Notes |
|-
| TemplateAdmin | Can perform all operations on templates. | Has privileges to create, delete and configure a template's storage domain and network details, and to move templates between domains. |
| NetworkAdmin | Network Administrator | Can configure and manage networks attached to templates. |

### Template User Roles Explained

The table below describes the user roles and privileges applicable to using and administrating templates in the User Portal.

| Role | Privileges | Notes |
|-
| TemplateCreator | Can create, edit, manage and remove virtual machine templates within assigned resources. | The **TemplateCreator** role is not applied to a specific template; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers, clusters, or storage domains. |
| TemplateOwner | Can edit and delete the template, assign and manage user permissions for the template. | The **TemplateOwner** role is automatically assigned to the user who creates a template. Other users who do not have **TemplateOwner** permissions on a template cannot view or use the template. |
| UserTemplateBasedVm | Can use the template to create virtual machines. | Cannot edit template properties. |
| VnicProfileUser | Logical network and network interface user for templates. | If the **Allow all users to use this Network** option was selected when a logical network is created, **VnicProfileUser** permissions are assigned to all users for the logical network. Users can then attach or detach template network interfaces to or from the logical network. |

### Assigning an Administrator or User Role to a Resource

Assign administrator or user roles to resources to allow users to access or manage that resource.

**Assigning a Role to a Resource**

1. Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.

2. Click the **Permissions** tab in the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.

3. Click **Add**.

4. Enter the name or user name of an existing user into the **Search** text box and click **Go**. Select a user from the resulting list of possible matches.

5. Select a role from the **Role to Assign:** drop-down list.

6. Click **OK**.

You have assigned a role to a user; the user now has the inherited permissions of that role enabled for that resource.

### Removing an Administrator or User Role from a Resource

Remove an administrator or user role from a resource; the user loses the inherited permissions associated with the role for that resource.

**Removing a Role from a Resource**

1. Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.

2. Click the **Permissions** tab in the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.

3. Select the user to remove from the resource.

4. Click **Remove**. The **Remove Permission** window opens to confirm permissions removal.

5. Click **OK**.

You have removed the user's role, and the associated permissions, from the resource.

## Using Cloud-Init to Automate the Configuration of Virtual Machines

Cloud-Init is a tool for automating the initial setup of virtual machines such as configuring the host name, network interfaces, and authorized keys. It can be used when provisioning virtual machines that have been deployed based on a template to avoid conflicts on the network.

To use this tool, the `cloud-init` package must first be installed on the virtual machine. Once installed, the Cloud-Init service starts during the boot process to search for instructions on what to configure. You can then use options in the **Run Once** window to provide these instructions one time only, or options in the **New Virtual Machine**, **Edit Virtual Machine** and **Edit Template** windows to provide these instructions every time the virtual machine starts.

### Installing Cloud-Init

This procedure describes how to install Cloud-Init on a virtual machine. Once Cloud-Init is installed, you can create a template based on this virtual machine. Virtual machines created based on this template can leverage Cloud-Init functions, such as configuring the host name, time zone, root password, authorized keys, network interfaces, DNS service, etc on boot.

**Installing Cloud-Init**

1. Log on to the virtual machine.

2. Enable the required repositories.

3. Install the `cloud-init` package and dependencies:

        # yum install cloud-init

### Using Cloud-Init to Prepare a Template

As long as the `cloud-init` package is installed on a Linux virtual machine, you can use the virtual machine to make a cloud-init enabled template. Specify a set of standard settings to be included in a template as described in the following procedure or, alternatively, skip the Cloud-Init settings steps and configure them when creating a virtual machine based on this template.

**Note:** While the following procedure outlines how to use Cloud-Init when preparing a template, the same settings are also available in the **New Virtual Machine**, **Edit Template**, and **Run Once** windows.

**Using Cloud-Init to Prepare a Template**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Initial Run** tab and select the **Use Cloud-Init/Sysprep** check box.

4. Enter a host name in the **VM Hostname** text field.

5. Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down list.

6. Expand the **Authentication** section and select the **Use already configured password** check box to user the existing credentials, or clear that check box and enter a root password in the **Password** and **Verify Password** text fields to specify a new root password.

7. Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.

8. Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.

9. Expand the **Networks** section and enter any DNS servers in the **DNS Servers** text field.

10. Enter any DNS search domains in the **DNS Search Domains** text field.

11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.

12. Expand the **Custom Script** section and enter any custom scripts in the **Custom Script** text area.

13. Click **Ok**.

14. Click **Make Template** and enter the fields as necessary.

15. Click **Ok**.

You can now provision new virtual machines using this template.

### Using Cloud-Init to Initialize a Virtual Machine

Use Cloud-Init to automate the initial configuration of a Linux virtual machine. You can use the Cloud-Init fields to configure a virtual machine's host name, time zone, root password, authorized keys, network interfaces, and DNS service. You can also specify a custom script, a script in YAML format, to run on boot. The custom script allows for additional Cloud-Init configuration that is supported by Cloud-Init but not available in the Cloud-Init fields. For more information on custom script examples, see [Cloud config examples](http://cloudinit.readthedocs.org/en/latest/topics/examples.html).

**Using Cloud-Init to Initialize a Virtual Machine**

This procedure starts a virtual machine with a set of Cloud-Init settings. If the relevant settings are included in the template the virtual machine is based on, review the settings, make changes where appropriate, and click **OK** to start the virtual machine.

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Run Once**.

3. Expand the **Initial Run** section and select the **Cloud-Init** check box.

4. Enter a host name in the **VM Hostname** text field.

5. Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down menu.

6. Select the **Use already configured password** check box to use the existing credentials, or clear that check box and enter a root password in the **Password** and **Verify Password** text fields to specify a new root password.

7. Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.

8. Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.

9. Enter any DNS servers in the **DNS Servers** text field.

10. Enter any DNS search domains in the **DNS Search Domains** text field.

11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.

12. Enter a custom script in the **Custom Script** text area. Make sure the values specified in the script are appropriate. Otherwise, the action will fail.

13. Click **OK**.

**Note:** To check if a virtual machine has Cloud-Init installed, select a virtual machine and click the **Applications** sub-tab. Only shown if the guest agent is installed.

## Creating a Virtual Machine Based on a Template

Create virtual machines based on templates. This allows you to create virtual machines that are pre-configured with an operating system, network interfaces, applications and other resources.

**Note:** Virtual machines created based on a template depend on that template. This means that you cannot remove that template from the Engine if there is a virtual machine that was created based on that template. However, you can clone a virtual machine from a template to remove the dependency on that template.

**Creating a Virtual Machine Based on a Template**

1. Click the **Virtual Machines** tab.

2. Click **New VM**.

3. Select the **Cluster** on which the virtual machine will run.

4. Select a template from the **Based on Template** list.

5. Enter a **Name**, **Description**, and any **Comments**, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.

6. Click the **Resource Allocation** tab.

7. Select the **Thin** radio button in the **Storage Allocation** area.

8. Select the disk provisioning policy from the **Allocation Policy** list. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.

    * Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.

    * Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

9. Use the **Target** list to select the storage domain on which the virtual machine's virtual disk will be stored.

10. Click **OK**.

The virtual machine is displayed in the **Virtual Machines** tab.

## Creating a Cloned Virtual Machine Based on a Template

Cloned virtual machines are similar to virtual machines based on templates. However, while a cloned virtual machine inherits settings in the same way as a virtual machine based on a template, a cloned virtual machine does not depend on the template on which it was based after it has been created.

**Note:** If you clone a virtual machine from a template, the name of the template on which that virtual machine was based is displayed in the **General** tab of the **Edit Virtual Machine** window for that virtual machine. If you change the name of that template, the name of the template in the **General** tab will also be updated. However, if you delete the template from the Engine, the original name of that template will be displayed instead.

**Cloning a Virtual Machine Based on a Template**

1. Click the **Virtual Machines** tab.

2. Click **New VM**.

3. Select the **Cluster** on which the virtual machine will run.

4. Select a template from the **Based on Template** drop-down menu.

5. Enter a **Name**, **Description** and any **Comments**. You can accept the default values inherited from the template in the rest of the fields, or change them if required.

6. Click the **Resource Allocation** tab.

7. Select the **Clone** radio button in the **Storage Allocation** area.

8. Select the disk provisioning policy from the **Allocation Policy** drop-down menu. This policy affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.

    * Selecting **Thin Provision** results in a faster clone operation and provides optimized usage of storage capacity. Disk space is allocated only as it is required. This is the default selection.

    * Selecting **Preallocated** results in a slower clone operation and provides optimized virtual machine read and write operations. All disk space requested in the template is allocated at the time of the clone operation.

9. Use the **Target** drop-down menu to select the storage domain on which the virtual machine's virtual disk will be stored.

10. Click **OK**.

**Note:** Cloning a virtual machine may take some time. A new copy of the template's disk must be created. During this time, the virtual machine's status is first **Image Locked**, then **Down**.

The virtual machine is created and displayed in the **Virtual Machines** tab. You can now assign users to it, and can begin using it when the clone operation is complete.

**Prev:** [Chapter 6: Administrative Tasks](../chap-Administrative_Tasks)<br>
**Next:** [Appendix A: Reference Settings in Administration Portal and User Portal Windows](../appe-Reference_Settings_in_Administration_Portal_and_User_Portal_Windows)
