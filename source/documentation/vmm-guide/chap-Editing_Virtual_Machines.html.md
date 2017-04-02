---
title: Editing Virtual Machines
---

# Editing Virtual Machines

## Editing Virtual Machine Properties

Changes to storage, operating system, or networking parameters can adversely affect the virtual machine. Ensure that you have the correct details before attempting to make any changes. Virtual machines can be edited while running, and some changes (listed in the procedure below) will be applied immediately. To apply all other changes, the virtual machine must be shut down and restarted.

**Editing Virtual Machines**

1. Select the virtual machine to be edited.

2. Click **Edit**.

3. Change settings as required.

    Changes to the following settings are applied immediately:

    * **Name**

    * **Description**

    * **Comment**

    * **Optimized for** (Desktop/Server)

    * **Delete Protection**

    * **Network Interfaces**

    * **Memory Size** (Edit this field to hot plug virtual memory. See the Hot Plugging Virtual Memory section.)

    * **Virtual Sockets** (Edit this field to hot plug CPUs. See the CPU hot plug section.)

    * **Use custom migration downtime**

    * **Highly Available**

    * **Priority for Run/Migration queue**

    * **Disable strict user checking**

    * **Icon**

4. Click **OK**.

5. If the **Next Start Configuration** pop-up window appears, click **OK**.

Changes from the list in step 3 are applied immediately. All other changes are applied when you shut down and restart your virtual machine. Until then, an orange icon (![](/images/vmm-guide/7278.png)) appears as a reminder of the pending changes.

## Network Interfaces

### Adding a New Network Interface

You can add multiple network interfaces to virtual machines. Doing so allows you to put your virtual machine on multiple logical networks.

**Adding Network Interfaces to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Network Interfaces** tab in the details pane.

3. Click **New**.

    **New Network Interface window**

    ![](/images/vmm-guide/7320.png)

4. Enter the **Name** of the network interface.

5. Use the drop-down lists to select the **Profile** and the **Type** of the network interface. The **Profile** and **Type** drop-down lists are populated in accordance with the profiles and network types available to the cluster and the network interface cards available to the virtual machine.

6. Select the **Custom MAC address** check box and enter a MAC address for the network interface card as required.

7. Click **OK**.

The new network interface is listed in the **Network Interfaces** tab in the details pane of the virtual machine. The **Link State** is set to **Up** by default when the network interface card is defined on the virtual machine and connected to the network.

### Editing a Network Interface

In order to change any network settings, you must edit the network interface. This procedure can be performed on virtual machines that are running, but some actions can be performed only on virtual machines that are not running.

**Editing Network Interfaces**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Network Interfaces** tab in the details pane and select the network interface to edit.

3. Click **Edit**. The **Edit Network Interface** window contains the same fields as the **New Network Interface** window.

4. Change settings as required.

5. Click **OK**.

### Hot Plugging a Network Interface

You can hot plug network interfaces. Hot plugging means enabling and disabling devices while a virtual machine is running.

**Note:** The guest operating system must support hot plugging network interfaces.

** Hot Plugging Network Interfaces

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Network Interfaces** tab in the details pane and select the network interface to hot plug.

3. Click **Edit**.

4. Set the **Card Status** to **Plugged** to enable the network interface, or set it to **Unplugged** to disable the network interface.

5. Click **OK**.

### Removing a Network Interface

**Removing Network Interfaces**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Network Interfaces** tab in the details pane and select the network interface to remove.

3. Click **Remove**.

4. Click **OK**.

## Virtual Disks

### Adding a New Virtual Disk

You can add multiple virtual disks to a virtual machine.

**Image** is the default type of disk. You can also add a **Direct LUN** disk or a **Cinder** (OpenStack Volume) disk. **Image** disk creation is managed entirely by the Engine. **Direct LUN** disks require externally prepared targets that already exist. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the oVirt environment using the **External Providers** window. Existing disks are either floating disks or shareable disks attached to virtual machines.

**Adding Disks to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane.

3. Click **New**.

    **The New Virtual Disk Window**

    ![](/images/vmm-guide/7319.png)

4. Use the appropriate radio buttons to switch between **Image**, **Direct LUN**, or **Cinder**. Virtual disks added in the User Portal can only be **Image** disks. **Direct LUN** and **Cinder** disks can be added in the Administration Portal.

5. Enter a **Size(GB)**, **Alias**, and **Description** for the new disk.

6. Use the drop-down lists and check boxes to configure the disk.
7. Click **OK**.

The new disk appears in the details pane after a short time.

### Associating an Existing Disk to a Virtual Machine

Floating disks are disks that are not associated with any virtual machine.

Floating disks can minimize the amount of time required to set up virtual machines. Designating a floating disk as storage for a virtual machine makes it unnecessary to wait for disk preallocation at the time of a virtual machine's creation.

Floating disks can be attached to a single virtual machine, or to multiple virtual machines if the disk is shareable.

Once a floating disk is attached to a virtual machine, the virtual machine can access it.

**Attaching Virtual Disks to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane.

3. Click **Attach**.

    **The Attach Virtual Disks Window**

    ![](/images/vmm-guide/7318.png)

4. Select one or more virtual disks from the list of available disks.

5. Click **OK**.

**Note:** No Quota resources are consumed by attaching virtual disks to, or detaching virtual disks from, virtual machines.

### Extending the Available Size of a Virtual Disk

You can extend the available size of a virtual disk while the virtual disk is attached to a virtual machine. Resizing a virtual disk does not resize the underlying partitions or file systems on that virtual disk. Use the `fdisk` utility to resize the partitions and file systems as required.

**Extending the Available Size of Virtual Disks**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane and select the disk to edit.

3. Click **Edit**.

4. Enter a value in the `Extend size by(GB)` field.

5. Click **OK**.

The target disk's status becomes `locked` for a short time, during which the drive is resized. When the resizing of the drive is complete, the status of the drive becomes `OK`.

### Hot Plugging a Virtual Disk

You can hot plug virtual machine disks. Hot plugging means enabling or disabling devices while a virtual machine is running.

**Note:** The guest operating system must support hot plugging virtual disks.

**Hot Plugging Virtual Disks**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane and select the virtual disk to hot plug.

3. Click **Activate** to enable the disk, or click **Deactivate** to disable the disk.

4. Click **OK**.

### Removing a Virtual Disk from a Virtual Machine

**Removing Virtual Disks From Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Disks** tab in the details pane and select the virtual disk to remove.

3. Click **Deactivate**.

4. Click **OK**.

5. Click **Remove**.

6. Optionally, select the **Remove Permanently** check box to completely remove the virtual disk from the environment. If you do not select this option - for example, because the disk is a shared disk - the virtual disk will remain in the **Disks** resource tab.

7. Click **OK**.

If the disk was created as block storage, for example iSCSI, and the **Wipe After Delete** check box was selected when creating the disk, you can view the log file on the host to confirm that the data has been wiped after permanently removing the disk. See "Settings to Wipe Virtual Disks After Deletion" in the [Administration Guide](/documentation/admin-guide/administration-guide/).

### Importing a Disk Image from an Imported Storage Domain

Import floating virtual disks from an imported storage domain using the **Disk Import** tab of the details pane.

This procedure requires access to the Administration Portal

**Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Select a storage domain that has been imported into the data center.

2. In the details pane, click **Disk Import**.

3. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

4. Select the appropriate **Disk Profile** for each disk.

5. Click **OK** to import the selected disks.

### Importing an Unregistered Disk Image from an Imported Storage Domain

Import floating virtual disks from a storage domain using the **Disk Import** tab of the details pane. Floating disks created outside of a oVirt environment are not registered with the Engine. Scan the storage domain to identify unregistered floating disks to be imported.

This procedure requires access to the Administration Portal

**Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Select a storage domain that has been imported into the data center.

2. Right-click the storage domain and select **Scan Disks** so that the Engine can identify unregistered disks.

3. In the details pane, click **Disk Import**.

4. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

5. Select the appropriate **Disk Profile** for each disk.

6. Click **OK** to import the selected disks.

## Hot Plugging Virtual Memory

You can hot plug virtual memory. Hot plugging means enabling or disabling devices while a virtual machine is running. Each time memory is hot plugged, it appears as a new memory device in the **Vm Devices** tab in the details pane, up to a maximum of 16. When the virtual machine is shut down and restarted, these devices are cleared from the **Vm Devices** tab without reducing the virtual machine's memory, allowing you to hot plug more memory devices.

**Important:** Hot unplugging virtual memory is not currently supported in oVirt.

**Hot Plugging Virtual Memory**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click **Edit**.

3. Click the **System** tab.

4. Edit the **Memory Size** as required. Memory can be added in multiples of 256 MB.

5. Click **OK**.

    This action opens the **Next Start Configuration** window, as the **MemSizeMb** value will not change until the virtual machine is restarted. However, the hot plug action is triggered by the change to the **memory** value, which can be applied immediately.

    **Hot Plug Virtual Memory**

    ![](/images/vmm-guide/7327.png)

6. Clear the **Apply later** check box to apply the change immediately.

7. Click **OK**.

The virtual machine's **Defined Memory** is updated in the **General** tab in the details pane. You can see the newly added memory device in the **Vm Devices** tab in the details pane.

# Hot Plugging Virtual CPUs

You can hot plug virtual CPUs. Hot plugging means enabling or disabling devices while a virtual machine is running.

The following prerequisites apply:

* The virtual machine's **Operating System** must be explicitly set in the **New Virtual Machine** window.

* The virtual machine's operating system must support CPU hot plug. See the table below for support details.

* Windows virtual machines must have the guest agents installed. See [Installing the Guest Agents and Drivers on Windows](Installing_the_Guest_Agents_and_Drivers_on_Windows).

**Important:** Hot unplugging virtual CPUs is not currently supported in oVirt.

**Hot Plugging Virtual CPUs**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click **Edit**.

3. Click the **System** tab.

4. Change the value of **Virtual Sockets** as required.

5. Click **OK**.

**Operating System Support Matrix for vCPU Hot Plug**

| Operating System | Version | Architecture | Hot Plug Supported |
|-
| Enterprise Linux 6.3+    |     | x86 | Yes |
| Enterprise Linux 7.0+    |     | x86 | Yes |
| Microsoft Windows Server 2008    | All | x86 | No |
| Microsoft Windows Server 2008    | Standard, Enterprise | x64 | No |
| Microsoft Windows Server 2008    | Datacenter | x64 | Yes |
| Microsoft Windows Server 2008 R2 | All | x86 | No |
| Microsoft Windows Server 2008 R2 | Standard, Enterprise | x64 | No |
| Microsoft Windows Server 2008 R2 | Datacenter | x64 | Yes |
| Microsoft Windows Server 2012    | All | x64 | Yes |
| Microsoft Windows Server 2012 R2 | All | x64 | Yes |
| Microsoft Windows 7              | All | x86 | No |
| Microsoft Windows 7              | Starter, Home, Home Premium, Professional | x64 | No |
| Microsoft Windows 7              | Enterprise, Ultimate | x64 | Yes |
| Microsoft Windows 8.x            | All | x86 | Yes |
| Microsoft Windows 8.x            | All | x64 | Yes |

## Pinning a Virtual Machine to Multiple Hosts

Virtual machines can be pinned to multiple hosts. Multi-host pinning allows a virtual machine to run on a specific subset of hosts within a cluster, instead of one specific host or all hosts in the cluster. The virtual machine cannot run on any other hosts in the cluster even if all of the specified hosts are unavailable. Multi-host pinning can be used to limit virtual machines to hosts with, for example, the same physical hardware configuration.

A virtual machine that is pinned to multiple hosts cannot be live migrated, but in the event of a host failure, any virtual machine configured to be highly available is automatically restarted on one of the other hosts to which the virtual machine is pinned.

**Note:** High availability is not supported for virtual machines that are pinned to a single host.

**Pinning Virtual Machines to Multiple Hosts**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Select the **Specific** radio button under **Start Running On** and select two or more hosts from the list.

5. Select **Do not allow migration** from the **Migration Options** drop-down list.

6. Click the **High Availability** tab.

7. Select the **Highly Available** check box.

8. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.

9. Click **OK**.

# Changing the CD for a Virtual Machine

You can change the CD accessible to a virtual machine while that virtual machine is running.

**Note:** You can only use ISO files that have been added to the ISO domain of the virtual machine's cluster.

**Changing the CD for a Virtual Machine**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click **Change CD**.

3. Select an option from the drop-down list:

    * Select an ISO file from the list to eject the CD currently accessible to the virtual machine and mount that ISO file as a CD.

    * Select **\[Eject]** from the list to eject the CD currently accessible to the virtual machine.

4. Click **OK**.

## Smart Card Authentication

Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect oVirt virtual machines.

**Enabling Smart Cards**

1. Ensure that the smart card hardware is plugged into the client machine and is installed according to manufacturer's directions.

2. Click the **Virtual Machines** tab and select a virtual machine.

3. Click **Edit**.

4. Click the **Console** tab and select the **Smartcard enabled** check box.

5. Click **OK**.

6. Run the virtual machine by clicking the **Console** icon. Smart card authentication is now passed from the client hardware to the virtual machine.

**Important:** If the Smart card hardware is not correctly installed, enabling the Smart card feature will result in the virtual machine failing to load properly.

**Disabling Smart Cards**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Console** tab, and clear the **Smartcard enabled** check box.

4. Click **OK**.

**Configuring Client Systems for Smart Card Sharing**

1. Smart cards may require certain libraries in order to access their certificates. These libraries must be visible to NSS library, which `spice-gtk` uses to provide the smart card to the guest. NSS expects the libraries to provide the PKCS #11 interface.

2. Make sure that the module architecture matches spice-gtk/remote-viewer's architecture. For instance, if you have only the 32b PKCS #11 library available, you must install the 32b build of virt-viewer in order for smart cards to work.

**Configuring EL clients with CoolKey Smart Card Middleware**

1. CoolKey Smart Card middleware is a part of Enterprise Linux. Install the `Smart card support` group. If the Smart Card Support group is installed on a Enterprise Linux system, smart cards are redirected to the guest when Smart Cards are enabled. The following command installs the `Smart card support` group:

        # yum groupinstall "Smart card support"

**Configuring EL clients with Other Smart Card Middleware**

1. Register the library in the system's NSS database. Run the following command as root:

        # modutil -dbdir /etc/pki/nssdb -add "module name" -libfile /path/to/library.so

**Configuring Windows Clients**

1. The oVirt Project does not provide PKCS #11 support to Windows clients. Libraries that provide PKCS #11 support must be obtained from third-parties. When such libraries are obtained, register them by running the following command as a user with elevated privileges:

        modutil -dbdir %PROGRAMDATA%\pki\nssdb -add "module name" -libfile C:\Path\to\module.dll

**Prev:** [Chapter 4: Additional Configuration](../chap-Additional_Configuration) <br>
**Next:** [Chapter 6: Administrative Tasks](../chap-Administrative_Tasks)
