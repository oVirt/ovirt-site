# Templates

A template is a copy of a virtual machine that you can use to simplify the subsequent, repeated creation of similar virtual machines. Templates capture the configuration of software, configuration of hardware, and the software installed on the virtual machine on which the template is based. The virtual machine on which a template is based is known as the source virtual machine.

When you create a template based on a virtual machine, a read-only copy of the virtual machine's disk is created. This read-only disk becomes the base disk image of the new template, and of any virtual machines created based on the template. As such, the template cannot be deleted while any virtual machines created based on the template exist in the environment.

Virtual machines created based on a template use the same NIC type and driver as the original virtual machine, but are assigned separate, unique MAC addresses.

You can create a virtual machine directly from the **Templates** tab, as well as from the **Virtual Machines** tab. In the **Templates** tab, right-click the required template and select **New VM**. For more information on selecting the settings and controls for the new virtual machine see [Virtual Machine General settings explained](Virtual_Machine_General_settings_explained).

## Sealing Virtual Machines in Preparation for Deployment as Templates

This section describes procedures for sealing Linux virtual machines and Windows virtual machines. Sealing is the process of removing all system-specific details from a virtual machine before creating a template based on that virtual machine. Sealing is necessary to prevent the same details from appearing on multiple virtual machines created based on the same template. It is also necessary to ensure the functionality of other features, such as predictable vNIC order.

### Sealing a Linux Virtual Machine for Deployment as a Template

There are two main methods for sealing a Linux virtual machine in preparation for using that virtual machine to create a template: manually, or using the `sys-unconfig` command. Sealing a Linux virtual machine manually requires you to create a file on the virtual machine that acts as a flag for initiating various configuration tasks the next time you start that virtual machine. The `sys-unconfig` command allows you to automate this process. However, both of these methods also require you to manually delete files on the virtual machine that are specific to that virtual machine or might cause conflicts amongst virtual machines created based on the template you will create based on that virtual machine. As such, both are valid methods for sealing a Linux virtual machine and will achieve the same result.

* [Sealing a Linux template](Sealing_a_Linux_template)
* [Sealing a Linux Virtual Machine for Deployment as a Template using sys-unconfig](Sealing_a_Linux_Virtual_Machine_for_Deployment_as_a_Template_using_sys-unconfig)

### Sealing a Windows Virtual Machine for Deployment as a Template

A template created for Windows virtual machines must be generalized (sealed) before being used to deploy virtual machines. This ensures that machine-specific settings are not reproduced in the template.

The Sysprep tool is used to seal Windows templates before use.

**Important:** Do not reboot the virtual machine during this process.

Before starting the Sysprep process, verify that the following settings are configured: 

* The Windows Sysprep parameters have been correctly defined.

* If not, click **Edit** and enter the required information in the **Operating System** and **Domain** fields.

* The correct product key has been defined in an override file on the Manager.

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

* [Sealing a Windows 7 or Windows 2008 template](Sealing_a_Windows_7_or_Windows_2008_template)

<!-- end ### and ## sections -->

* [Editing a Template](Editing_a_Template)
* [Deleting a template](Deleting_a_template)

## Exporting Templates

* [Exporting individual templates to the export domain](Exporting_individual_templates_to_the_export_domain)
* [Copying a Virtual Machine Hard Disk](Copying_a_Virtual_Machine_Hard_Disk)

## Importing Templates

* [Importing a template into a data center](Importing_a_template_into_a_data_center)
* [Importing a Virtual Disk Image from an OpenStack Image Service as a Template](Importing_a_Virtual_Disk_Image_from_an_OpenStack_Image_Service_as_a_Template)

## Templates and Permissions

* [Data center related entities](Data_center_related_entities)
* [Logical network properties](Logical_network_properties)
* [Template User Roles Explained](Template_User_Roles_Explained)
* [To assign a system administrator role to a data center](To_assign_a_system_administrator_role_to_a_data_center)
* [To remove a system administrator role to a data center](To_remove_a_system_administrator_role_to_a_data_center)

## Using Cloud-Init to Automate the Configuration of Virtual Machines

Cloud-Init is a tool for automating the initial setup of virtual machines such as configuring the host name, network interfaces, and authorized keys. It can be used when provisioning virtual machines that have been deployed based on a template to avoid conflicts on the network.

To use this tool, the `cloud-init` package must first be installed on the virtual machine. Once installed, the Cloud-Init service starts during the boot process to search for instructions on what to configure. You can then use options in the **Run Once** window to provide these instructions one time only, or options in the **New Virtual Machine**, **Edit Virtual Machine** and **Edit Template** windows to provide these instructions every time the virtual machine starts.

* [Cloud-Init Use Case Scenarios](Cloud-Init_Use_Case_Scenarios)
* [Installing Cloud-Init](Installing_Cloud-Init)
* [Using Cloud-Init to Prepare a Template](Using_Cloud-Init_to_Prepare_a_Template)
* [Using Cloud-Init](Using_Cloud-Init)

<!-- end section -->

* [Creating a new virtual machine from an existing template](Creating_a_new_virtual_machine_from_an_existing_template)
* [Creating a cloned virtual machine from an existing template](Creating_a_cloned_virtual_machine_from_an_existing_template)


