---
title: Installing Windows Virtual Machines
---

# Chapter 3: Installing Windows Virtual Machines

This chapter describes the steps required to install a Windows virtual machine:

1. Create a blank virtual machine on which to install an operating system.

2. Add a virtual disk for storage.

3. Add a network interface to connect the virtual machine to the network.

4. Attach the **virtio-win.vfd** diskette to the virtual machine so that VirtIO-optimized device drivers can be installed during the operating system installation.

5. Install an operating system on the virtual machine. See your operating system's documentation for instructions.

6. Install guest agents and drivers for additional virtual machine functionality.

When all of these steps are complete, the new virtual machine is functional and ready to perform tasks.

## Creating a Windows Virtual Machine

Create a new virtual machine and configure the required settings.

**Procedure**

1. You can change the default virtual machine name length with the `engine-config` tool. Run the following command on the Engine machine:

        # engine-config --set MaxVmNameLength=integer

2. Click **Compute** &rarr; **Virtual Machines**.

3. Click **New** to open the **New Virtual Machine** window.

4. Select an **Operating System** from the drop-down list.

5. Enter a **Name** for the virtual machine.

5. Add storage to the virtual machine. **Attach** or **Create** a virtual disk under **Instance Images**.

    * Click **Attach** and select an existing virtual disk.

    * Click **Create** and enter a **Size(GB)** and **Alias** for a new virtual disk. You can accept the default settings for all other fields, or change them if required.

7. Connect the virtual machine to the network. Add a network interface by selecting a vNIC profile from the **nic1** drop-down list at the bottom of the **General** tab.

8. Specify the virtual machine's **Memory Size** on the **System** tab.

9. Choose the **First Device** that the virtual machine will boot from on the **Boot Options** tab.

10. You can accept the default settings for all other fields, or change them if required.

11. Click **OK**.

The new virtual machine is created and displays in the list of virtual machines with a status of `Down`. Before you can use this virtual machine, you must install an operating system and VirtIO-optimized disk and network drivers.

## Starting the Virtual Machine Using the Run Once Option

### Installing Windows on VirtIO-Optimized Hardware

Install VirtIO-optimized disk and network device drivers during your Windows installation by attaching the `virtio-win.vfd` diskette to your virtual machine. These drivers provide a performance improvement over emulated device drivers.

Use the **Run Once** option to attach the diskette in a one-off boot different from the **Boot Options** defined in the **New Virtual Machine** window. This procedure presumes that you added a `VirtIO` network interface and a disk that uses the `VirtIO` interface to your virtual machine.

    **Note:** The **virtio-win.vfd** diskette is placed automatically on ISO storage domains that are hosted on the Engine server. You can upload it manually to a data storage domain.

**Installing VirtIO Drivers during Windows Installation**

1. Click **Compute** &rarr; **Virtual Machines**.

2. Click **Run** &rarr; **Run Once**.

3. Expand the **Boot Options** menu.

4. Select the **Attach Floppy** check box, and select **virtio-win.vfd** from the drop-down list.

5. Select the **Attach CD** check box, and select the required Windows ISO from the drop-down list.

6. Move **CD-ROM** to the top of the **Boot Sequence** field.

7. Configure the rest of your **Run Once** options as required.

8. Click **OK**.

The **Status** of the virtual machine changes to `Up`, and the operating system installation begins. Open a console to the virtual machine if one does not open automatically.

Windows installations include an option to load additional drivers early in the installation process. Use this option to load drivers from the `virtio-win.vfd` diskette that was attached to your virtual machine as `A:`. For each supported virtual machine architecture and Windows version, there is a folder on the disk containing optimized hardware device drivers.

### Opening a Console to a Virtual Machine

Use Remote Viewer to connect to a virtual machine.

**Connecting to Virtual Machines**

1. Install Remote Viewer if it is not already installed.

2. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

3. Click **Console**.

    * If the connection protocol is set to SPICE, a console window will automatically open for the virtual machine.

    * If the connection protocol is set to VNC, a **console.vv** file will be downloaded. Click on the file and a console window will automatically open for the virtual machine.

    **Note:**  You can configure the system to automatically connect to a virtual machine. See the “Automatically Connecting to a Virtual Machine” section in Chapter 2.

## Installing Guest Agents and Drivers

### Drivers and Guest Agents Included with the Guest Tools ISO

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
    <p>On Enterprise Linux 6 and higher guests, the ovirt-engine-guest-agent-common installs <tt>tuned</tt> on your virtual machine and configures it to use an optimized, virtualized-guest profile.</p>
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
 </tbody>
</table>

## Installing the Guest Agents and Drivers on Windows

The oVirt guest agents and drivers are installed on Windows virtual machines using the `oVirt-tools-setup.iso` ISO file, which is provided by the `oVirt-guest-tools-iso` package installed as a dependency to the oVirt Engine. This ISO file is located in `/usr/share/oVirt-guest-tools-iso/oVirt-tools-setup.iso` on the system on which the oVirt Engine is installed.

  **Note:** The `oVirt-tools-setup.iso` ISO file is automatically copied to the default ISO storage domain, if any, when you run `engine-setup`, or must be manually uploaded to an ISO storage domain.

  **Note:** Updated versions of the `oVirt-tools-setup.iso` ISO file must be manually attached to running Windows virtual machines to install updated versions of the tools and drivers. If the APT service is enabled on virtual machines, the updated ISO files will be automatically attached.

  **Note:** If you install the guest agents and drivers from the command line or as part of a deployment tool such as Windows Deployment Services, you can append the options `ISSILENTMODE` and `ISNOREBOOT` to `oVirt-toolsSetup.exe` to silently install the guest agents and drivers and prevent the machine on which they have been installed from rebooting immediately after installation. The machine can then be rebooted later once the deployment process is complete.

      D:\oVirt-toolsSetup.exe ISSILENTMODE ISNOREBOOT

**Installing the Guest Agents and Drivers on Windows**

1. Log in to the virtual machine.

2. Select the CD Drive containing the `oVirt-tools-setup.iso` file.

3. Double-click `oVirt-toolsSetup`.

4. Click **Next** at the welcome screen.

5. Follow the prompts on the **oVirt-Tools InstallShield Wizard** window. Ensure all check boxes in the list of components are selected.

6. Once installation is complete, select `Yes, I want to restart my computer now` and click **Finish** to apply the changes.

The guest agents and drivers now pass usage information to the oVirt Engine and allow you to access USB devices, single sign-on into virtual machines and other functionality. The oVirt guest agent runs as a service called **oVirt Agent** that you can configure using the **oVirt-agent** configuration file located in **C:\Program Files\Redhat\oVirt\Drivers\Agent**.

## Automating Guest Additions on Windows Guests with oVirt Application Provisioning Tool (APT)

oVirt Application Provisioning Tool (APT) is a Windows service that can be installed on Windows virtual machines and templates. When the APT service is installed and running on a virtual machine, attached ISO files are automatically scanned. When the service recognizes a valid oVirt guest tools ISO, and no other guest tools are installed, the APT service installs the guest tools. If guest tools are already installed, and the ISO image contains newer versions of the tools, the service performs an automatic upgrade. This procedure assumes you have attached the `oVirt-tools-setup.iso` ISO file to the virtual machine.

**Installing the APT Service on Windows**

1. Log in to the virtual machine.

2. Select the CD Drive containing the `oVirt-tools-setup.iso` file.

3. Double-click *oVirt-Application Provisioning Tool*.

4. Click **Yes** in the **User Account Control** window.

5. Once installation is complete, ensure the `Start oVirt-apt Service` check box is selected in the **oVirt-Application Provisioning Tool InstallShield Wizard** window, and click **Finish** to apply the changes.

Once the APT service has successfully installed or upgraded the guest tools on a virtual machine, the virtual machine is automatically rebooted; this happens without confirmation from the user logged in to the machine. The APT Service will also perform these operations when a virtual machine created from a template that has the APT Service already installed is booted for the first time.

    **Note:** The *oVirt-apt* service can be stopped immediately after install by clearing the `Start oVirt-apt Service` check box. You can stop, start, or restart the service at any time using the **Services** window.

**Prev:** [Chapter 2: Installing Linux Virtual Machines](chap-Installing_Linux_Virtual_Machines) <br>
**Next:** [Chapter 4: Additional Configuration](chap-Additional_Configuration)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-installing_windows_virtual_machines)
