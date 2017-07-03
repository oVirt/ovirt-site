---
title: Installing Linux Virtual Machines
---

# Chapter 2: Installing Linux Virtual Machines

This chapter describes the steps required to install a Linux virtual machine:

1. Create a blank virtual machine on which to install an operating system.

2. Add a virtual disk for storage.

3. Add a network interface to connect the virtual machine to the network.

4. Install an operating system on the virtual machine. See your operating system's documentation for instructions.

    * Enterprise Linux 6

    * Enterprise Linux 7

    * CentOS Atomic Host 7

5. Install guest agents and drivers for additional virtual machine functionality.

When all of these steps are complete, the new virtual machine is functional and ready to perform tasks.

## Creating a Linux Virtual Machine

Create a new virtual machine and configure the required settings.

**Creating Linux Virtual Machines**

1. Click the **Virtual Machines** tab.

2. Click the **New VM** button to open the **New Virtual Machine** window.

    **The New Virtual Machine Window**

    ![](/images/vmm-guide/7316.png)

2. Select a Linux variant from the **Operating System** drop-down list.

3. Enter a **Name** for the virtual machine.

4. Add storage to the virtual machine. **Attach** or **Create** a virtual disk under **Instance Images**.

    * Click **Attach** and select an existing virtual disk.

    * Click **Create** and enter a **Size(GB)** and **Alias** for a new virtual disk. You can accept the default settings for all other fields, or change them if required. See [Add Virtual Disk dialogue entries](Add_Virtual_Disk_dialogue_entries) for more details on the fields for all disk types.

5. Connect the virtual machine to the network. Add a network interface by selecting a vNIC profile from the **nic1** drop-down list at the bottom of the **General** tab.

6. Specify the virtual machine's **Memory Size** on the **System** tab.

7. Choose the **First Device** that the virtual machine will boot from on the **Boot Options** tab.

8. You can accept the default settings for all other fields, or change them if required. For more details on all fields in the **New Virtual Machine** window, see [Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows](sect-Explanation_of_Settings_in_the_New_Virtual_Machine_and_Edit_Virtual_Machine_Windows).

9. Click **OK**.

The new virtual machine is created and displays in the list of virtual machines with a status of `Down`.

## Starting the Virtual Machine

### Powering on a Virtual Machine

**Starting Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine with a status of `Down`.

2. Click the run (![](/images/vmm-guide/5033.png)) button.

    Alternatively, right-click the virtual machine and select **Run**.

The **Status** of the virtual machine changes to `Up`, and the operating system installation begins. Open a console to the virtual machine if one does not open automatically.

### Logging In To a Virtual Machine Using SPICE

Use Remote Viewer to connect to a virtual machine.

**Connecting to Virtual Machines**

1. Install Remote Viewer if it is not already installed.

2. Click the **Virtual Machines** tab and select a virtual machine.

3. Click the console button or right-click the virtual machine and select **Console**.

    * If the connection protocol is set to SPICE, a console window will automatically open for the virtual machine.

    * If the connection protocol is set to VNC, a `console.vv` file will be downloaded. Click on the file and a console window will automatically open for the virtual machine.

### Opening a Console to a Virtual Machine

Use Remote Viewer to connect to a virtual machine.

**Connecting to Virtual Machines**

1. Install Remote Viewer if it is not already installed. See [Installing Console Components](sect-Installing_Console_Components).

2. Click the **Virtual Machines** tab and select a virtual machine.

3. Click the console button or right-click the virtual machine and select **Console**.

    * If the connection protocol is set to SPICE, a console window will automatically open for the virtual machine.

    * If the connection protocol is set to VNC, a `console.vv` file will be downloaded. Click on the file and a console window will automatically open for the virtual machine.

## Installing Guest Agents and Drivers

# oVirt Guest Agents and Drivers

The oVirt guest agents and drivers provide additional information and functionality for Enterprise Linux and Windows virtual machines. Key features include the ability to monitor resource usage and gracefully shut down or reboot virtual machines from the User Portal and Administration Portal. Install the oVirt guest agents and drivers on each virtual machine on which this functionality is to be available.

**oVirt Guest Drivers**

<table>
 <thead>
  <tr>
   <td>Driver</td>
   <td>Description</td>
   <td>Works on</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><tt>virtio-net</tt></td>
   <td>Paravirtualized network driver provides enhanced performance over emulated devices like rtl.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-block</tt></td>
   <td>Paravirtualized HDD driver offers increased I/O performance over emulated devices like IDE by optimizing the coordination and communication between the guest and the hypervisor. The driver complements the software implementation of the virtio-device used by the host to play the role of a hardware device.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-scsi</tt></td>
   <td>Paravirtualized iSCSI HDD driver offers similar functionality to the virtio-block device, with some additional enhancements. In particular, this driver supports adding hundreds of devices, and names devices using the standard SCSI device naming scheme.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-serial</tt></td>
   <td>Virtio-serial provides support for multiple serial ports. The improved performance is used for fast communication between the guest and the host that avoids network complications. This fast communication is required for the guest agents and for other features such as clipboard copy-paste between the guest and the host and logging.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-balloon</tt></td>
   <td>Virtio-balloon is used to control the amount of memory a guest actually accesses. It offers improved memory over-commitment. The balloon drivers are installed for future compatibility but not used by default in oVirt.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>qxl</tt></td>
   <td>A paravirtualized display driver reduces CPU usage on the host and provides better performance through reduced network bandwidth on most workloads.</td>
   <td>Server and Desktop.</td>
  </tr>
 </tbody>
</table>

**oVirt Guest Agents and Tools**

<table>
 <thead>
  <tr>
   <td>Guest agent/tool</td>
   <td>Description</td>
   <td>Works on</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><tt>ovirt-engine-guest-agent-common</tt></td>
   <td>
    <p>Allows the oVirt Engine to receive guest internal events and information such as IP address and installed applications. Also allows the Engine to execute specific commands, such as shut down or reboot, on a guest.</p>
    <p>On Enterprise Linux 6 and higher guests, the ovirt-engine-guest-agent-common installs <i>tuned</i> on your virtual machine and configures it to use an optimized, virtualized-guest profile.</p>
   </td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>spice-agent</tt></td>
   <td>The SPICE agent supports multiple monitors and is responsible for client-mouse-mode support to provide a better user experience and improved responsiveness than the QEMU emulation. Cursor capture is not needed in client-mouse-mode. The SPICE agent reduces bandwidth usage when used over a wide area network by reducing the display level, including color depth, disabling wallpaper, font smoothing, and animation. The SPICE agent enables clipboard support allowing cut and paste operations for both text and images between client and guest, and automatic guest display setting according to client-side settings. On Windows guests, the SPICE agent consists of vdservice and vdagent.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>ovirt-sso</tt></td>
   <td>An agent that enables users to automatically log in to their virtual machines based on the credentials used to access the oVirt Engine.</td>
   <td>Desktop.</td>
  </tr>
  <tr>
   <td><tt>ovirt-usb</tt></td>
   <td>A component that contains drivers and services for Legacy USB support (version 3.0 and earlier) on guests. It is needed for accessing a USB device that is plugged into the client machine. <tt>ovirt-USB Client</tt> is needed on the client side.</td>
   <td>Desktop.</td>
  </tr>
 </tbody>
</table>

## Installing the Guest Agents and Drivers on Enterprise Linux

The ovirt guest agents and drivers are installed on Enterprise Linux virtual machines using the `ovirt-engine-guest-agent` package provided by the ovirt Agent repository.

# Installing the Guest Agents and Drivers on Enterprise Linux

1. Log in to the Enterprise Linux virtual machine.

2. Enable the ovirt Agent repository.

3. Install the `ovirt-engine-guest-agent-common` package and dependencies:

        # yum install ovirt-engine-guest-agent-common

4. Start and enable the service:

    * For Enterprise Linux 6

            # service ovirt-guest-agent start
            # chkconfig ovirt-guest-agent on

    * For Enterprise Linux 7

            # systemctl start ovirt-guest-agent.service
            # systemctl enable ovirt-guest-agent.service

5. Start and enable the `qemu-ga` service:

    * For Enterprise Linux 6

            # service qemu-ga start
            # chkconfig qemu-ga on

    * For Enterprise Linux 7

            # systemctl start qemu-guest-agent.service
            # systemctl enable qemu-guest-agent.service

The guest agent now passes usage information to the ovirt Manager. The ovirt agent runs as a service called `ovirt-guest-agent` that you can configure via the `ovirt-guest-agent.conf` configuration file in the `/etc/` directory.

**Prev:** [Chapter 1: Introduction](../chap-Introduction)<br>
**Next:** [Chapter 3: Installing Windows Virtual Machines](../chap-Installing_Windows_Virtual_Machines)
