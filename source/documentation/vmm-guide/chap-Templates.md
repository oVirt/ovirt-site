---
title: Templates
---

# Chapter 7: Templates

A template is a copy of a virtual machine that you can use to simplify the subsequent, repeated creation of similar virtual machines. Templates capture the configuration of software, configuration of hardware, and the software installed on the virtual machine on which the template is based. The virtual machine on which a template is based is known as the source virtual machine.

When you create a template based on a virtual machine, a read-only copy of the virtual machine's disk is created. This read-only disk becomes the base disk image of the new template, and of any virtual machines created based on the template. As such, the template cannot be deleted while any virtual machines created based on the template exist in the environment.

Virtual machines created based on a template use the same NIC type and driver as the original virtual machine, but are assigned separate, unique MAC addresses.

You can create a virtual machine directly from **Compute** &rarr; **Templates**, as well as from **Compute** &rarr; **Virtual Machines**. In **Compute** &rarr; **Templates**, select the required template and click New VM. For more information on selecting the settings and controls for the new virtual machine see [Reference Settings in Administration Portal and User Portal Windows]((appe-Reference_Settings_in_Administration_Portal_and_User_Portal_Windows).

## Sealing Virtual Machines in Preparation for Deployment as Templates

This section describes procedures for sealing Linux virtual machines and Windows virtual machines. Sealing is the process of removing all system-specific details from a virtual machine before creating a template based on that virtual machine. Sealing is necessary to prevent the same details from appearing on multiple virtual machines created based on the same template. It is also necessary to ensure the functionality of other features, such as predictable vNIC order.

### Sealing a Linux Virtual Machine for Deployment as a Template

A Linux virtual machine is sealed during the template creation process, by selecting the **Seal Template** check box in the **New Template** window. See “Creating a Template” for details.

### Sealing a Windows Virtual Machine for Deployment as a Template

A template created for Windows virtual machines must be generalized (sealed) before being used to deploy virtual machines. This ensures that machine-specific settings are not reproduced in the template.

`Sysprep` is used to seal Windows templates before use. Sysprep generates a complete unattended installation answer file. Default values for several Windows operating systems are available in the **/usr/share/ovirt-engine/conf/sysprep/** directory. These files act as templates for `Sysprep`. The fields in these files can be copied, pasted, and altered as required. This definition will override any values entered into the **Initial Run** fields of the **Edit Virtual Machine** window.

The Sysprep file can be edited to affect various aspects of the Windows virtual machines created from the template that the Sysprep file is attached to. These include the provisioning of Windows, setting up the required domain membership, configuring the hostname, and setting the security policy.

Replacement strings can be used to substitute values provided in the default files in the **/usr/share/ovirt-engine/conf/sysprep/** directory. For example, `"<Domain><![CDATA[$JoinDomain$]]></Domain>"` can be used to indicate the domain to join.

####  Prerequisites for Sealing a Windows Virtual Machine

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

**Sealing a Windows 7, Windows 2008, or Windows 2012 Virtual Machine for Deployment as a Template**

1. On the Windows virtual machine, launch *Sysprep* from `C:\Windows\System32\sysprep\sysprep.exe`.

2. Enter the following information into *Sysprep*:

    * Under **System Cleanup Action**, select **Enter System Out-of-Box-Experience (OOBE)**.

    * Select the **Generalize** check box if you need to change the computer's system identification number (SID).

    * Under **Shutdown Options**, select **Shutdown**.

3. Click **OK** to complete the sealing process; the virtual machine shuts down automatically upon completion.

The Windows 7, Windows 2008, or Windows 2012 template is sealed and ready for deploying virtual machines.

## Creating a Template

Create a template from an existing virtual machine to use as a blueprint for creating additional virtual machines.

When you create a template, you specify the format of the disk to be raw or QCOW2:

* QCOW2 disks are thin provisioned.

* Raw disks on file storage are thin provisioned.

* Raw disks on block storage are preallocated.

**Creating a Template**

1. Click **Compute** &rarr; **Virtual Machines** and select the source virtual machine.

2. Ensure the virtual machine is powered down and has a status of `Down`.

3. Click **More Actions** &rarr; **Make Template**. For more details on all fields in the **New Template** window, see  “Explanation of Settings in the New Template Window” in Appendix A.

4. Enter a **Name**, **Description**, and **Comment** for the template.

5. Select the cluster with which to associate the template from the **Cluster** drop-down list. By default, this is the same as that of the source virtual machine.

6. Optionally, select a CPU profile for the template from the **CPU Profile** drop-down list.

7. Optionally, select the **Create as a Template Sub-Version** check box, select a **Root Template**, and enter a **Sub-Version Name** to create the new template as a sub-template of an existing template.

8. In the **Disks Allocation** section, enter an alias for the disk in the **Alias** text field. Select the disk format in the **Format** drop-down, the storage domain on which to store the disk from the **Target** drop-down, and the disk profile in the **Disk Profile** drop-down. By default, these are the same as those of the source virtual machine.

9. Select the **Allow all users to access this Template** check box to make the template public.

10. Select the **Copy VM permissions** check box to copy the permissions of the source virtual machine to the template.

11. Select the **Seal Template** check box (Linux only) to seal the template.

    **Note:** Sealing, which uses the virt-sysprep command, removes system-specific details from a virtual machine before creating a template based on that virtual machine. This prevents the original virtual machine’s details from appearing in subsequent virtual machines that are created using the same template. It also ensures the functionality of other features, such as predictable vNIC order. See Appendix B, virt-sysprep Operations for more information.

12. Click **OK**.

The virtual machine displays a status of Image Locked while the template is being created. The process of creating a template may take up to an hour depending on the size of the virtual disk and the capabilities of your storage hardware. When complete, the template is added to the Templates tab. You can now create new virtual machines based on the template.

    **Note:** When a template is made, the virtual machine is copied so that both the existing virtual machine and its template are usable after template creation.

## Editing a Template

Once a template has been created, its properties can be edited. Because a template is a copy of a virtual machine, the options available when editing a template are identical to those in the **Edit Virtual Machine** window.

**Editing a Template**

1. Click **Compute** &rarr; **Templates** and select a template.

2. Click **Edit**.

3. Change the necessary properties. Click **Show Advanced Options** and edit the template’s settings as required. The settings that appear in the **Edit Template** window are identical to those in the **Edit Virtual Machine** window, but with the relevant fields only.

4. Click **OK**.

## Deleting a Template

If you have used a template to create a virtual machine using the thin provisioning storage allocation option, the template cannot be deleted as the virtual machine needs it to continue running. However, cloned virtual machines do not depend on the template they were cloned from and the template can be deleted.

**Deleting a Template**

1. Click **Compute** &rarr; **Templates** and select a template.

2. Click **Remove**.

3. Click **OK**.

## Exporting Templates

### Migrating Templates to the Export Domain

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the "Importing Existing Storage Domains" section in the [Administration Guide](/documentation/administration_guide/) for information on importing storage domains.

Export templates into the export domain to move them to another data domain, either in the same oVirt environment, or another one. This procedure requires access to the Administration Portal.

**Exporting Individual Templates to the Export Domain**

1.Click **Compute** &rarr; **Templates** and select a template.

2. Click **Export**.

3. Select the **Force Override** check box to replace any earlier version of the template on the export domain.

4. Click **OK** to begin exporting the template; this may take up to an hour, depending on the virtual machine disk image size and your storage hardware.

Repeat these steps until the export domain contains all the templates to migrate before you start the import process.

1. Click **Storage** &rarr; **Domains** and select the export domain.

2. Click the domain name to see the details view.

3. Click the **Template Import** tab to view all exported templates in the export domain.

### Copying a Template's Virtual Hard Disk

If you are moving a virtual machine that was created from a template with the thin provisioning storage allocation option selected, the template's disks must be copied to the same storage domain as that of the virtual machine disk. This procedure requires access to the Administration Portal.

**Copying a Virtual Hard Disk**

1. Click **Storage** &rarr; **Disks**.

2. Select the template disk(s) to copy.

3. Click **Copy**.

4. Select the **Target** data domain from the drop-down list(s).

5. Click **OK**.

A copy of the template's virtual hard disk has been created, either on the same, or a different, storage domain. If you were copying a template disk in preparation for moving a virtual hard disk, you can now move the virtual hard disk.

## Importing Templates

### Importing a Template into a Data Center

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See the "Importing Existing Storage Domains" section in the [Administration Guide](/documentation/administration_guide/) for information on importing storage domains.

Import templates from a newly attached export domain. This procedure requires access to the Administration Portal.

**Importing a Template into a Data Center**

1. Click **Storage** &rarr; **Domains** and select the newly attached export domain.

2. Click the domain name to go to the details view.

3. Click the **Template Import** tab and select a template.

4. Click **Import**.

5. Use the drop-down lists to select the **Target Cluster** and **CPU Profile**.

6. Select the template to view its details, then click the **Disks** tab and select the **Storage Domain** to import the template into.

7. Click **OK**.

8. If the **Import Template Conflict** window appears, enter a **New Name** for the template, or select the **Apply to all** check box and enter a **Suffix to add to the cloned Templates**. Click **OK**.

9. Click **Close**.

The template is imported into the destination data center. This can take up to an hour, depending on your storage hardware. You can view the import progress in the **Events** tab.

Once the importing process is complete, the templates will be visible in **Compute** &rarr; **Templates**. The templates can create new virtual machines, or run existing imported virtual machines based on that template.

### Importing a Virtual Disk Image from an OpenStack Image Service as a Template

Virtual disk images managed by an OpenStack Image Service can be imported into the ovirt Engine if that OpenStack Image Service has been added to the Engine as an external provider. This procedure requires access to the Administration Portal.

1. Click **Storage** &rarr; **Domains** and select the OpenStack Image Service domain.

2. Click the storage domain name to go to the details view.

3. Click the **Images** tab and select the image to import.

4. Click **Import**.

    **Note:** If you are importing an image from a Glance storage domain, you have the option of specifying the template name.

5. Select the **Data Center** into which the virtual disk image will be imported.

6. Select the storage domain in which the virtual disk image will be stored from the **Domain Name** drop-down list.

7. Optionally, select a **Quota** to apply to the virtual disk image.

8. Select the **Import as Template** check box.

9. Select the **Cluster** in which the virtual disk image will be made available as a template.

10. Click **OK**.

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

### Assigning an Administrator or User Role to a Resource

Assign administrator or user roles to resources to allow users to access or manage that resource.

**Assigning a Role to a Resource**

1. Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.

2. Click the resource’s name to go to the details view.

3. Click the **Permissions** tab to list the assigned users, the user's role, and the inherited permissions for the selected resource.

4. Click **Add**.

5. Enter the name or user name of an existing user into the **Search** text box and click **Go**. Select a user from the resulting list of possible matches.

6. Select a role from the **Role to Assign:** drop-down list.

7. Click **OK**.

You have assigned a role to a user; the user now has the inherited permissions of that role enabled for that resource.

### Removing an Administrator or User Role from a Resource

Remove an administrator or user role from a resource; the user loses the inherited permissions associated with the role for that resource.

**Removing a Role from a Resource**

1. Use the resource tabs, tree mode, or the search function to find and select the resource in the results list.

2. Click the resource’s name to go to the details view.

3. Click the **Permissions** tab to list the assigned users, the user's role, and the inherited permissions for the selected resource.

4. Select the user to remove from the resource.

5. Click **Remove**. The **Remove Permission** window opens to confirm permissions removal.

6. Click **OK**.

You have removed the user's role, and the associated permissions, from the resource.

## Using Cloud-Init to Automate the Configuration of Virtual Machines

Cloud-Init is a tool for automating the initial setup of virtual machines such as configuring the host name, network interfaces, and authorized keys. It can be used when provisioning virtual machines that have been deployed based on a template to avoid conflicts on the network.

To use this tool, the `cloud-init` package must first be installed on the virtual machine. Once installed, the Cloud-Init service starts during the boot process to search for instructions on what to configure. You can then use options in the **Run Once** window to provide these instructions one time only, or options in the **New Virtual Machine**, **Edit Virtual Machine** and **Edit Template** windows to provide these instructions every time the virtual machine starts.

    **Note:** Alternatively, you can configure Cloud-Init with Ansible, Python, Java, or Ruby.

### Cloud-Init Use Case Scenarios
Cloud-Init can be used to automate the configuration of virtual machines in a variety of scenarios. Several common scenarios are as follows:

* **Virtual Machines Created Based on Templates**

  You can use the Cloud-Init options in the **Initial Run** section of the **Run Once** window to initialize a virtual machine that was created based on a template. This allows you to customize the virtual machine the first time that virtual machine is started.

* **Virtual Machine Templates**

  You can use the **Use Cloud-Init/Sysprep** options in the **Initial Run** tab of the **Edit Template** window to specify options for customizing virtual machines created based on that template.

* **Virtual Machine Pools**

  You can use the **Use Cloud-Init/Sysprep** options in the **Initial Run** tab of the New Pool window to specify options for customizing virtual machines taken from that virtual machine pool. This allows you to specify a set of standard settings that will be applied every time a virtual machine is taken from that virtual machine pool. You can inherit or override the options specified for the template on which the virtual machine is based, or specify options for the virtual machine pool itself.

### Installing Cloud-Init

This procedure describes how to install Cloud-Init on a virtual machine. Once Cloud-Init is installed, you can create a template based on this virtual machine. Virtual machines created based on this template can leverage Cloud-Init functions, such as configuring the host name, time zone, root password, authorized keys, network interfaces, DNS service, etc. on boot.

**Installing Cloud-Init**

1. Log in to the virtual machine.

2. Enable the required repositories.

3. Install the `cloud-init` package and dependencies:

        # yum install cloud-init

### Using Cloud-Init to Prepare a Template

As long as the `cloud-init` package is installed on a Linux virtual machine, you can use the virtual machine to make a cloud-init enabled template. Specify a set of standard settings to be included in a template as described in the following procedure or, alternatively, skip the Cloud-Init settings steps and configure them when creating a virtual machine based on this template.

    **Note:** While the following procedure outlines how to use Cloud-Init when preparing a template, the same settings are also available in the **New Virtual Machine**, **Edit Template**, and **Run Once** windows.

**Using Cloud-Init to Prepare a Template**

1. Click **Compute** &rarr; **Templates** and select a template.

2. Click **Edit**.

3. Click **Show Advanced Options**.

4. Click the **Initial Run** tab and select the **Use Cloud-Init/Sysprep** check box.

5. Enter a host name in the **VM Hostname** text field.

6. Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down list.

7. Expand the **Authentication** section.

  * Select the **Use already configured password** check box to user the existing credentials, or clear that check box and enter a root password in the **Password** and **Verify Password** text fields to specify a new root password.

  * Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.

  * Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.

8. Expand the **Networks** section.

  * Enter any DNS servers in the **DNS Servers** text field.

  * Enter any DNS search domains in the **DNS Search Domains** text field.

  * Select the **In-guest Network Interface** check box and use the **+ Add new** and **- Remove selected** buttons to add or remove network interfaces to or from the virtual machine.

      **Important:** You must specify the correct network interface name and number (for example, `eth0`, `eno3`, `enp0s`). Otherwise, the virtual machine’s interface connection will be up, but it will not have the **cloud-init** network configuration.

9. Expand the **Custom Script** section and enter any custom scripts in the **Custom Script** text area.

10. Click **OK**.

You can now provision new virtual machines using this template.

### Using Cloud-Init to Initialize a Virtual Machine

Use Cloud-Init to automate the initial configuration of a Linux virtual machine. You can use the Cloud-Init fields to configure a virtual machine's host name, time zone, root password, authorized keys, network interfaces, and DNS service. You can also specify a custom script, a script in YAML format, to run on boot. The custom script allows for additional Cloud-Init configuration that is supported by Cloud-Init but not available in the Cloud-Init fields. For more information on custom script examples, see [Cloud config examples](http://cloudinit.readthedocs.org/en/latest/topics/examples.html).

**Using Cloud-Init to Initialize a Virtual Machine**

This procedure starts a virtual machine with a set of Cloud-Init settings. If the relevant settings are included in the template the virtual machine is based on, review the settings, make changes where appropriate, and click **OK** to start the virtual machine.

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click the **Run** drop-down button and select  **Run Once**.

3. Expand the **Initial Run** section and select the **Cloud-Init** check box.

4. Enter a host name in the **VM Hostname** text field.

5. Select the **Configure Time Zone** check box and select a time zone from the **Time Zone** drop-down menu.

6. Select the **Use already configured password** check box to use the existing credentials, or clear that check box and enter a root password in the **Password** and **Verify Password** text fields to specify a new root password.

7. Enter any SSH keys to be added to the authorized hosts file on the virtual machine in the **SSH Authorized Keys** text area.

8. Select the **Regenerate SSH Keys** check box to regenerate SSH keys for the virtual machine.

9. Enter any DNS servers in the **DNS Servers** text field.

10. Enter any DNS search domains in the **DNS Search Domains** text field.

11. Select the **Network** check box and use the **+** and **-** buttons to add or remove network interfaces to or from the virtual machine.

      **Important:** You must specify the correct network interface name and number (for example, `eth0`, `eno3`, `enp0s`). Otherwise, the virtual machine’s interface connection will be up, but it will not have the **cloud-init** network configuration.

12. Enter a custom script in the **Custom Script** text area. Make sure the values specified in the script are appropriate. Otherwise, the action will fail.

13. Click **OK**.

    **Note:** To check if a virtual machine has Cloud-Init installed, select a virtual machine and click the **Applications** sub-tab. Only shown if the guest agent is installed.

## Using Sysprep to Automate the Configuration of Virtual Machines

`Sysprep` is a tool used to automate the setup of Windows virtual machines, for example, configuring host names, network interfaces, authorized keys, set up users, or to connect to Active Directory. `Sysprep` is installed with every version of Windows.

oVirt enhances `Sysprep` by exploiting virtualization technology to deploy virtual workstations based on a single template. oVirt builds a tailored auto-answer file for each virtual workstation.

Sysprep generates a complete unattended installation answer file. Default values for several Windows operating systems are available in the **/usr/share/ovirt-engine/conf/sysprep/** directory. You can also create a custom `Sysprep` file and reference it from the the **osinfo** file in the **/etc/ovirt-engine/osinfo.conf.d/** directory. These files act as templates for `Sysprep`. The fields in these files can be copied and edited as required. This definition will override any values entered into the **Initial Run** fields of the **Edit Virtual Machine** window.

You can create a custom `sysprep` file when creating a pool of Windows virtual machines, to accommodate various operating systems and domains.

The override file must be created under **/etc/ovirt-engine/osinfo.conf.d/**, have a filename that puts it after **/etc/ovirt-engine/osinfo.conf.d/00-defaults.properties**, and ends in **.properties**. For example, **/etc/ovirt-engine/osinfo.conf.d/10-productkeys.properties**. The last file will have precedence and override any other previous file.

Copy the default values for your Windows operating system from **/etc/ovirt-engine/osinfo.conf.d/00-defaults.properties** into the override file, and input your values in the `productKey.value` and `sysprepPath.value` fields.

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

### Configuring Sysprep on a Template

You can use this procedure to specify a set of standard `Sysprep` settings to include in the template, alternatively you can configure the `Sysprep` settings when creating a virtual machine based on this template.

Replacement strings can be used to substitute values provided in the default files in the **/usr/share/ovirt-engine/conf/sysprep/** directory. For example, `"<Domain><![CDATA[$JoinDomain$]]></Domain>"` can be used to indicate the domain to join.

    **Important:** Do not reboot the virtual machine while Sysprep is running.

**Prerequisites**

* The Windows virtual machine parameters have been correctly defined.

* If not, click **Compute** &rarr; **Virtual Machines**, click **Edit**, and enter the required information in the **Operating System** and **Cluster** fields.

* The correct product key has been defined in an override file on the Engine.

**Using Sysprep to Prepare a Template**

1. Build the Windows virtual machine with the required patches and software.

2. Seal the Windows virtual machine. See “Sealing Virtual Machines in Preparation for Deployment as Templates” above.

3. Create a template based on the Windows virtual machine. See “Creating a Template” above.

4. Update the `Sysprep` file with a text editor if additional changes are required.

You can now provision new virtual machines using this template.

### Using Sysprep to Initialize a Virtual Machine

Use `Sysprep` to automate the initial configuration of a Windows virtual machine. You can use the `Sysprep` fields to configure a virtual machine’s host name, time zone, root password, authorized keys, network interfaces, and DNS service.

**Using Sysprep to Initialize a Virtual Machine**

This procedure starts a virtual machine with a set of `Sysprep` settings. If the relevant settings are included in the template the virtual machine is based on, review the settings and make changes where required.

1. Create a new Windows virtual machine based on a template of the required Windows virtual machine. See “Creating a Virtual Machine Based on a Template”.

2. Click **Compute** &rarr; **Virtual Machines** and select the virtual machine.

3. Click the **Run** drop-down button and select **Run Once**.

4. Expand the **Boot Options** section, select the **Attach Floppy** check box, and select the **[sysprep]** option.

5. Select the **Attach CD** check box and select the required Windows ISO from the drop-down list.

6. Move the **CD-ROM** to the top of the **Boot Sequence** field.

7. Configure any further **Run Once** options as required.

8. Click **OK**.

## Creating a Virtual Machine Based on a Template

Create virtual machines based on templates. This allows you to create virtual machines that are pre-configured with an operating system, network interfaces, applications and other resources.

**Note:** Virtual machines created based on a template depend on that template. This means that you cannot remove that template from the Engine if there is a virtual machine that was created based on that template. However, you can clone a virtual machine from a template to remove the dependency on that template.

**Creating a Virtual Machine Based on a Template**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click **New**.

3. Select the **Cluster** on which the virtual machine will run.

4. Select a template from the **Template** list.

5. Enter a **Name**, **Description**, and any **Comments**, and accept the default values inherited from the template in the rest of the fields. You can change them if needed.

6. Click the **Resource Allocation** tab.

7. Select the **Thin** or **Clone** radio button in the **Storage Allocation** area. If you select **Thin**, the disk format is QCOW2. If you select **Clone**, select either **QCOW2** or **Raw** for disk format.

8. Use the **Target** drop-down list to select the storage domain on which the virtual machine's virtual disk will be stored.

9. Click **OK**.

The virtual machine is displayed in the **Virtual Machines** tab.

## Creating a Cloned Virtual Machine Based on a Template

Cloned virtual machines are similar to virtual machines based on templates. However, while a cloned virtual machine inherits settings in the same way as a virtual machine based on a template, a cloned virtual machine does not depend on the template on which it was based after it has been created.

    **Note:** If you clone a virtual machine from a template, the name of the template on which that virtual machine was based is displayed in the **General** tab of the **Edit Virtual Machine** window for that virtual machine. If you change the name of that template, the name of the template in the **General** tab will also be updated. However, if you delete the template from the Engine, the original name of that template will be displayed instead.

**Cloning a Virtual Machine Based on a Template**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click **New**.

3. Select the **Cluster** on which the virtual machine will run.

4. Select a template from the **Based on Template** drop-down menu.

5. Enter a **Name**, **Description** and any **Comments**. You can accept the default values inherited from the template in the rest of the fields, or change them if required.

6. Click the **Resource Allocation** tab.

7. Select the **Clone** radio button in the **Storage Allocation** area.

8. Select the disk format from the **Format** drop-down list. This affects the speed of the clone operation and the amount of disk space the new virtual machine initially requires.

  * **QCOW2** (Default)

    * Faster clone operation

    * Optimized use of storage capacity

    * Disk space allocated only as required

  * **Raw**

    * Slower clone operation

    * Optimized virtual machine read and write operations

    * All disk space requested in the template is allocated at the time of the clone operation

9. Use the **Target** drop-down list to select the storage domain on which the virtual machine's virtual disk will be stored.

10. Click **OK**.

    **Note:** Cloning a virtual machine may take some time. A new copy of the template's disk must be created. During this time, the virtual machine's status is first **Image Locked**, then **Down**.

The virtual machine is created and displayed in the **Virtual Machines** tab. You can now assign users to it, and can begin using it when the clone operation is complete.

**Prev:** [Chapter 6: Administrative Tasks](chap-Administrative_Tasks)<br>
**Next:** [Appendix A: Reference Settings in Administration Portal and VM Portal Windows](appe-Reference_Settings_in_Administration_Portal_and_User_Portal_Windows)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-templates)
