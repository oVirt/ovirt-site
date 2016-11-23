# Importing a Virtual Machine from a VMware Provider

Import virtual machines from a VMware vCenter provider to your Red Hat Virtualization environment. You can import from a VMware provider by entering its details in the **Import Virtual Machine(s)** window during each import operation, or you can add the VMware provider as an external provider, and select the preconfigured provider during import operations. To add an external provider, see [Adding a VMware Instance as a Virtual Machine Provider](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#sect-Adding_External_Providers).

Red Hat Virtualization uses V2V to convert VMware virtual machines to the correct format before they are imported. You must install the `virt-v2v` package on a least one Red Hat Enterprise Linux 7 host before proceeding. This package is available in the base `rhel-7-server-rpms` repository.

**Warning:** The virtual machine must be shut down before being imported. Starting the virtual machine through VMware during the import process can result in data corruption.

**Importing a Virtual Machine from VMware**

1. In the **Virtual Machines** tab, click **Import** to open the **Import Virtual Machine(s)** window.

    **The Import Virtual Machine(s) Window**

    ![](images/7324.png)

2. Select **VMware** from the **Source** list.

3. If you have configured a VMware provider as an external provider, select it from the **External Provider** list. Verify that the provider credentials are correct. If you did not specify a destination data center or proxy host when configuring the external provider, select those options now.

4. If you have not configured a VMware provider, or want to import from a new VMware provider, provide the following details:

    1. Select from the list the **Data Center** in which the virtual machine will be available.

    2. Enter the IP address or fully qualified domain name of the VMware vCenter instance in the **vCenter** field.

    3. Enter the IP address or fully qualified domain name of the host from which the virtual machines will be imported in the **ESXi** field.

    4. Enter the name of the data center and the cluster in which the specified ESXi host resides in the **Data Center** field.

    5. If you have exchanged the SSL certificate between the ESXi host and the Manager, leave **Verify server's SSL certificate** checked to verify the ESXi host's certificate. If not, uncheck the option.

    6. Enter the **Username** and **Password** for the VMware vCenter instance. The user must have access to the VMware data center and ESXi host on which the virtual machines reside.

    7. Select a host in the chosen data center with `virt-v2v` installed to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the VMware vCenter external provider.

5. Click **Load** to generate a list of the virtual machines on the VMware provider.

6. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list. Click **Next**.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **Note:** If a virtual machine's network device uses the driver type e1000 or rtl8139, the virtual machine will use the same driver type after it has been imported to Red Hat Virtualization.

    If required, you can change the driver type to VirtIO manually after the import. To change the driver type after a virtual machine has been imported, see [Editing network interfaces](Editing_network_interfaces1). If the network device uses driver types other than e1000 or rtl8139, the driver type is changed to VirtIO automatically during the import. The **Attach VirtIO-drivers** option allows the VirtIO drivers to be injected to the imported virtual machine files so that when the driver is changed to VirtIO, the device will be properly detected by the operating system.

    **The Import Virtual Machine(s) Window**

    ![](images/7325.png)

7. Select the **Cluster** in which the virtual machines will reside.

8. Select a **CPU Profile** for the virtual machines.

9. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

10. Select the **Clone** check box to change the virtual machine name and MAC addresses, and clone all disks, removing all snapshots. If a virtual machine appears with a warning symbol beside its name or has a tick in the **VM in System** column, you must clone the virtual machine and change its name.

11. Click on each virtual machine to be imported and click on the **Disks** sub-tab. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

    **Note:** The target storage domain must be a filed-based domain. Due to current limitations, specifying a block-based domain causes the V2V operation to fail.

12. If you selected the **Clone** check box, change the name of the virtual machine in the **General** sub-tab.

13. Click **OK** to import the virtual machines.
