---
title: Editing Virtual Machines
---

# Editing Virtual Machines

## Editing Virtual Machine Properties

Changes to storage, operating system, or networking parameters can adversely affect the virtual machine. Ensure that you have the correct details before attempting to make any changes. Virtual machines can be edited while running, and some changes (listed in the procedure below) will be applied immediately. To apply all other changes, the virtual machine must be shut down and restarted.

**Editing Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Select the virtual machine to be edited.

3. Click **Edit**.

3. Change settings as required.

   Changes to the following settings are applied immediately:

    * **Name**

    * **Description**

    * **Comment**

    * **Optimized for** (Desktop/Server/High Performance)

    * **Delete Protection**

    * **Network Interfaces**

    * **Memory Size** (Edit this field to hot plug virtual memory.)

    * **Virtual Sockets** (Edit this field to hot plug CPUs.)

    * **Use custom migration downtime**

    * **Highly Available**

    * **Priority for Run/Migration queue**

    * **Disable strict user checking**

    * **Icon**

5. Click **OK**.

6. If the **Next Start Configuration** pop-up window appears, click **OK**.

Some changes are applied immediately. All other changes are applied when you shut down and restart your virtual machine.  Until then, an orange icon (![](/images/vmm-guide/7278.png)) appears as a reminder of the pending changes.

## Network Interfaces

### Adding a New Network Interface

You can add multiple network interfaces to virtual machines. Doing so allows you to put your virtual machine on multiple logical networks.

    **Note:** You can create an overlay network for your virtual machines, isolated from the hosts, by defining a logical network that is not attached to the physical interfaces of the host. For example, you can create a DMZ environment, in which the virtual machines communicate among themselves over the bridge created in the host.

    The overlay network uses OVN, which must be installed as an external network provider.

**Adding Network Interfaces to Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Network Interfaces** tab .

4. Click **New**.

5. Enter the **Name** of the network interface.

6. Select the **Profile** and the **Type** of the network interface from the drop-down lists. The **Profile** and **Type** drop-down lists are populated in accordance with the profiles and network types available to the cluster and the network interface cards available to the virtual machine.

7. Select the **Custom MAC address** check box and enter a MAC address for the network interface card as required.

8. Click **OK**.

The new network interface is listed in the **Network Interfaces** tab in the details pane of the virtual machine. The **Link State** is set to **Up** by default when the network interface card is defined on the virtual machine and connected to the network.

### Editing a Network Interface

In order to change any network settings, you must edit the network interface. This procedure can be performed on virtual machines that are running, but some actions can be performed only on virtual machines that are not running.

**Editing Network Interfaces**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Network Interfaces** tab and select the network interface to edit.

4. Click **Edit**.

5. Change settings as required. You can specify the **Name**, **Profile**, **Type**, and **Custom MAC address**.

6. Click **OK**.

### Hot Plugging a Network Interface

You can hot plug network interfaces. Hot plugging means enabling and disabling devices while a virtual machine is running.

    **Note:** The guest operating system must support hot plugging network interfaces.

**Hot Plugging Network Interfaces**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Network Interfaces** tab and select the network interface to hot plug.

4. Click **Edit**.

5. Set the **Card Status** to **Plugged** to enable the network interface, or set it to **Unplugged** to disable the network interface.

6. Click **OK**.

### Removing a Network Interface

**Removing Network Interfaces**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Network Interfaces** tab and select the network interface to remove.

4. Click **Remove**.

5. Click **OK**.

###  Blacklisting Network Interfaces

You can configure the ovirt-guest-agent on a virtual machine to ignore certain NICs. This prevents IP addresses associated with network interfaces created by certain software from appearing in reports. You must specify the name and number of the network interface you want to blacklist (for example, eth0, docker0).

    **Important:** You must blacklist NICs on the virtual machine before the guest agent is started for the first time.

**Blacklisting Network Interfaces**

1. In the `/etc/ovirt-guest-agent.conf` configuration file on the virtual machine, insert the following line, with the NICs to be ignored separated by spaces:

        ignored_nics = first_NIC_to_ignore second_NIC_to_ignore

2. Start the agent:

        # systemctl start ovirt-guest-agent

    **Note:** Some virtual machine operating systems automatically start the guest agent during installation.

    If your virtual machine’s operating system automatically starts the guest agent or if you need to configure the blacklist on many virtual machines, use the configured virtual machine as a template for creating additional virtual machines.

## Virtual Disks

### Adding a New Virtual Disk

You can add multiple virtual disks to a virtual machine.

**Image** is the default type of disk. You can also add a **Direct LUN** disk or a **Cinder** (OpenStack Volume) disk. **Image** disk creation is managed entirely by the Engine. **Direct LUN** disks require externally prepared targets that already exist. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the oVirt environment using the **External Providers** window. Existing disks are either floating disks or shareable disks attached to virtual machines.

**Adding Disks to Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Disks** tab.

4. Click **New**.

5. Use the appropriate radio buttons to switch between **Image**, **Direct LUN**, or **Cinder**.

6. Enter a **Size(GB)**, **Alias**, and **Description** for the new disk.

7. Use the drop-down lists and check boxes to configure the disk.

8. Click **OK**.

The new disk appears in the details pane after a short time.

### Attaching an Existing Disk to a Virtual Machine

Floating disks are disks that are not associated with any virtual machine.

Floating disks can minimize the amount of time required to set up virtual machines. Designating a floating disk as storage for a virtual machine makes it unnecessary to wait for disk preallocation at the time of a virtual machine's creation.

Floating disks can be attached to a single virtual machine, or to multiple virtual machines if the disk is shareable.

Once a floating disk is attached to a virtual machine, the virtual machine can access it.

**Attaching Virtual Disks to Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Disks** tab.

4. Click **Attach**.

5. Select one or more virtual disks from the list of available disks and select the required interface from the **Interface** drop-down list.

6. Click **OK**.

    **Note:** No Quota resources are consumed by attaching virtual disks to, or detaching virtual disks from, virtual machines.

### Extending the Available Size of a Virtual Disk

You can extend the available size of a virtual disk while the virtual disk is attached to a virtual machine. Resizing a virtual disk does not resize the underlying partitions or file systems on that virtual disk. Use the `fdisk` utility to resize the partitions and file systems as required.

**Extending the Available Size of Virtual Disks**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Disks** tab and select the disk to edit.

4. Click **Edit**.

5. Enter a value in the `Extend size by(GB)` field.

6. Click **OK**.

The target disk's status becomes `locked` for a short time, during which the drive is resized. When the resizing of the drive is complete, the status of the drive becomes `OK`.

### Hot Plugging a Virtual Disk

You can hot plug virtual machine disks. Hot plugging means enabling or disabling devices while a virtual machine is running.

    **Note:** The guest operating system must support hot plugging virtual disks.

**Hot Plugging Virtual Disks**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Disks** tab and select the virtual disk to hot plug.

4. Click **More Actions** &rarr; **Activate** to enable the disk, or click **More Actions** &rarr; **Deactivate** to disable the disk.

5. Click **OK**.

### Removing a Virtual Disk from a Virtual Machine

**Removing Virtual Disks From Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click a virtual machine name to go to the details view.

3. Click the **Disks** tab and select the virtual disk to remove.

4. Click **More Actions** &rarr; **Deactivate**.

5. Click **OK**.

6. Click **Remove**.

7. Optionally, select the **Remove Permanently** check box to completely remove the virtual disk from the environment. If you do not select this option - for example, because the disk is a shared disk - the virtual disk will remain in **Storage** &rarr; **Disks**.

8. Click **OK**.

If the disk was created as block storage, for example iSCSI, and the **Wipe After Delete** check box was selected when creating the disk, you can view the log file on the host to confirm that the data has been wiped after permanently removing the disk. See "Settings to Wipe Virtual Disks After Deletion" in the [Administration Guide](/documentation/administration_guide/).

If the disk was created as block storage, for example iSCSI, and the **Discard After Delete** check box was selected on the storage domain before the disk was removed, a `blkdiscard` command is called on the logical volume when it is removed and the underlying storage is notified that the blocks are free. A `blkdiscard` is also called on the logical volume when a virtual disk is removed if the virtual disk is attached to at least one virtual machine with the **Enable Discard** check box selected.

### Importing a Disk Image from an Imported Storage Domain

Import floating virtual disks from an imported storage domain using the **Disk Import** tab of the details pane.

This procedure requires access to the Administration Portal.

    **Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Click **Storage** &rarr; **Domains**.

2. Click an imported storage domain to go to the details view.

3. Click **Disk Import**.

4. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

5. Select the appropriate **Disk Profile** for each disk.

6. Click **OK** to import the selected disks.

### Importing an Unregistered Disk Image from an Imported Storage Domain

Import floating virtual disks from a storage domain using the **Disk Import** tab of the details pane. Floating disks created outside of a oVirt environment are not registered with the Engine. Scan the storage domain to identify unregistered floating disks to be imported.

This procedure requires access to the Administration Portal.

    **Note:** Only QEMU-compatible disks can be imported into the Engine.

**Importing a Disk Image**

1. Click **Storage** &rarr; **Domains**.

2. Click **More Actions** → **Scan Disks** so that the Engine can identify unregistered disks..

3. Select an unregistered disk name and click **Disk Import**.

4. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

5. Select the appropriate **Disk Profile** for each disk.

6. Click **OK** to import the selected disks.

## Virtual Memory

### Hot Plugging Virtual Memory

You can hot plug virtual memory. Hot plugging means enabling or disabling devices while a virtual machine is running. Each time memory is hot plugged, it appears as a new memory device in the **Vm Devices** tab in the details pane, up to a maximum of 16. When the virtual machine is shut down and restarted, these devices are cleared from the **Vm Devices** tab without reducing the virtual machine's memory, allowing you to hot plug more memory devices.

    **Important:** This feature is currently not supported for the self-hosted engine Engine virtual machine.

**Hot Plugging Virtual Memory**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Edit**.

3. Click the **System** tab.

4. Edit the **Memory Size** by entering the total amount required. Memory can be added in multiples of 256 MB. By default, the maximum memory allowed for the virtual machine is set to 4x the memory size specified. Though the value is changed in the user interface, the maximum value is not hot plugged, and you will see the pending changes icon. To avoid that, you can change the maximum memory back to the original value.

5. Click **OK**.

    This action opens the **Next Start Configuration** window, as the **MemSizeMb** value will not change until the virtual machine is restarted. However, the hot plug action is triggered by the change to the **Memory Size** value, which can be applied immediately.

6. Click **OK**.

The virtual machine's **Defined Memory** is updated in the **General** tab in the details pane. You can see the newly added memory device in the **Vm Devices** tab in the details pane.

### Hot Unplugging Virtual Memory

You can hot unplug virtual memory. Hot unplugging means disabling devices while a virtual machine is running.

    **Important:**

    * Only memory added with hot plugging can be hot unplugged.

    * The virtual machine operating system must support memory hot unplugging.

    * The virtual machines must not have a memory balloon device enabled. This feature is disabled by default.

    * All blocks of the hot-plugged memory must be set to **online_movable** in the virtual machine’s device management rules. In virtual machines running up-to-date versions of Enterprise Linux or CoreOS, this rule is set by default. For information on device management rules, consult the documentation for the virtual machine’s operating system.

    If any of these conditions are not met, the memory hot unplug action may fail or cause unexpected behavior.

**Hot Unplugging Virtual Memory**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click the **Vm Devices** tab.

3. In the **Hot Unplug** column, click **Hot Unplug** beside the memory device to be removed.

4. Click **OK** in the **Memory Hot Unplug** window.

The **Physical Memory Guaranteed** value for the virtual machine is decremented automatically if necessary.

## Hot Plugging vCPUs

You can hot plug vCPUs. Hot plugging means enabling or disabling devices while a virtual machine is running.

    **Important:** Hot unplugging a vCPU is only supported if the vCPU was previously hot plugged. A virtual machine’s vCPUs cannot be hot unplugged to less vCPUs than it was originally created with.

The following prerequisites apply:

* The virtual machine’s **Operating System** must be explicitly set in the **New Virtual Machine** or **Edit Virtual Machine** window.

* The virtual machine’s operating system must support CPU hot plug. See the table below for support details.

* Windows virtual machines must have the guest agents installed.

**Hot Plugging vCPUs**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Edit**.

3. Click the **System** tab.

4. Change the value of **Virtual Sockets** as required.

5. Click **OK**.

**Operating System Support Matrix for vCPU Hot Plug**

| Operating System | Version | Architecture | Hot Plug Supported | Hot Unplug Supported |
|-
| Enterprise Linux Atomic Host 7    |     | x86 | Yes | Yes |
| Enterprise Linux 6.3+    |     | x86 | Yes | Yes |
| Enterprise Linux 7.0+    |     | x86 | Yes | Yes |
| Enterprise Linux 7.3+    |     | PPC64 | Yes | Yes |
| Microsoft Windows Server 2008    | All | x86 | No | No |
| Microsoft Windows Server 2008    | Standard, Enterprise | x64 | No | No |
| Microsoft Windows Server 2008    | Datacenter | x64 | Yes | No |
| Microsoft Windows Server 2008 R2 | All | x86 | No | No |
| Microsoft Windows Server 2008 R2 | Standard, Enterprise | x64 | No | No |
| Microsoft Windows Server 2008 R2 | Datacenter | x64 | Yes | No |
| Microsoft Windows Server 2012    | All | x64 | Yes | No |
| Microsoft Windows Server 2012 R2 | All | x64 | Yes | No |
| Microsoft Windows Server 2016    | Standard, Datacenter | x64 | Yes | No |
| Microsoft Windows 7              | All | x86 | No | No |
| Microsoft Windows 7              | Starter, Home, Home Premium, Professional | x64 | No | No |
| Microsoft Windows 7              | Enterprise, Ultimate | x64 | Yes | No |
| Microsoft Windows 8.x            | All | x86 | Yes | No |
| Microsoft Windows 8.x            | All | x64 | Yes | No |
| Microsoft Windows 10            | All | x86 | Yes | No |
| Microsoft Windows 10            | All | x64 | Yes | No |

## Pinning a Virtual Machine to Multiple Hosts

Virtual machines can be pinned to multiple hosts. Multi-host pinning allows a virtual machine to run on a specific subset of hosts within a cluster, instead of one specific host or all hosts in the cluster. The virtual machine cannot run on any other hosts in the cluster even if all of the specified hosts are unavailable. Multi-host pinning can be used to limit virtual machines to hosts with, for example, the same physical hardware configuration.

A virtual machine that is pinned to multiple hosts cannot be live migrated, but in the event of a host failure, any virtual machine configured to be highly available is automatically restarted on one of the other hosts to which the virtual machine is pinned.

    **Note:** High availability is not supported for virtual machines that are pinned to a single host.

**Pinning Virtual Machines to Multiple Hosts**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Select the **Specific Host(s)** radio button under **Start Running On** and select two or more hosts from the list.

5. Select **Do not allow migration** from the **Migration Options** drop-down list.

6. Click the **High Availability** tab.

7. Select the **Highly Available** check box.

8. Select **Low**, **Medium**, or **High** from the **Priority** drop-down list. When migration is triggered, a queue is created in which the high priority virtual machines are migrated first. If a cluster is running low on resources, only the high priority virtual machines are migrated.

9. Click **OK**.

## Viewing Virtual Machines Pinned to a Host

You can use the **Virtual Machines** tab of a host to view virtual machines pinned to that host, even while the virtual machines are offline.

Virtual machines that are pinned to only one host will shut down rather than migrate when that host becomes inactive. You can use the **Pinned to Host** list to see which virtual machines will be affected, and which virtual machines will require a manual restart after the host becomes active again.

**Viewing Virtual Machines Pinned to a Host**

1. Click **Compute** &rarr; **Hosts**.

2. Click a host name to go to the details view.

3. Click the **Virtual Machines** tab.

4. Click **Pinned to Host**.

## Changing the CD for a Virtual Machine

You can change the CD accessible to a virtual machine while that virtual machine is running, using ISO images that have been uploaded to the data domain of the virtual machine’s cluster.

**Changing the CD for a Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **More Actions** &rarr; **Change CD**.

3. Select an option from the drop-down list:

    * Select an ISO file from the list to eject the CD currently accessible to the virtual machine and mount that ISO file as a CD.

    * Select **[Eject]** from the list to eject the CD currently accessible to the virtual machine.

4. Click **OK**.

## Smart Card Authentication

Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect oVirt virtual machines.

**Enabling Smart Cards**

1. Ensure that the smart card hardware is plugged into the client machine and is installed according to manufacturer's directions.

2. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

3. Click **Edit**.

4. Click the **Console** tab and select the **Smartcard enabled** check box.

5. Click **OK**.

6. Run the virtual machine by clicking the **Console** icon. Smart card authentication is now passed from the client hardware to the virtual machine.

    **Important:** If the Smart card hardware is not correctly installed, enabling the Smart card feature will result in the virtual machine failing to load properly.

**Disabling Smart Cards**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **Console** tab, and clear the **Smartcard enabled** check box.

4. Click **OK**.

**Configuring Client Systems for Smart Card Sharing**

1. Smart cards may require certain libraries in order to access their certificates. These libraries must be visible to NSS library, which `spice-gtk` uses to provide the smart card to the guest. NSS expects the libraries to provide the PKCS #11 interface.

2. Make sure that the module architecture matches spice-gtk/remote-viewer's architecture. For instance, if you have only the 32b PKCS #11 library available, you must install the 32b build of virt-viewer in order for smart cards to work.

**Configuring EL clients with CoolKey Smart Card Middleware**

CoolKey Smart Card middleware is a part of Enterprise Linux. Install the `Smart card support` group. If the Smart Card Support group is installed on a Enterprise Linux system, smart cards are redirected to the guest when Smart Cards are enabled. The following command installs the `Smart card support` group:

        # yum groupinstall "Smart card support"

**Configuring EL clients with Other Smart Card Middleware**

Register the library in the system's NSS database. Run the following command as root:

        # modutil -dbdir /etc/pki/nssdb -add "module name" -libfile /path/to/library.so

**Configuring Windows Clients**

The oVirt Project does not provide PKCS #11 support to Windows clients. Libraries that provide PKCS #11 support must be obtained from third-parties. When such libraries are obtained, register them by running the following command as a user with elevated privileges:

        modutil -dbdir %PROGRAMDATA%\pki\nssdb -add "module name" -libfile C:\Path\to\module.dll

**Prev:** [Chapter 4: Additional Configuration](chap-Additional_Configuration) <br>
**Next:** [Chapter 6: Administrative Tasks](chap-Administrative_Tasks)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-editing_virtual_machines)
