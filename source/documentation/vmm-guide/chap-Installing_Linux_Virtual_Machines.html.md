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

1. Click **Compute** &raar; **Virtual Machines**.

2. Click **New** button to open the **New Virtual Machine** window.

3. Select an **Operating System** from the drop-down list.

4. Enter a **Name** for the virtual machine.

5. Add storage to the virtual machine. **Attach** or **Create** a virtual disk under **Instance Images**.

    * Click **Attach** and select an existing virtual disk.

    * Click **Create** and enter a **Size(GB)** and **Alias** for a new virtual disk. You can accept the default settings for all other fields, or change them if required. See [Add Virtual Disk dialogue entries](Add_Virtual_Disk_dialogue_entries) for more details on the fields for all disk types.

6. Connect the virtual machine to the network. Add a network interface by selecting a vNIC profile from the **nic1** drop-down list at the bottom of the **General** tab.

7. Specify the virtual machine's **Memory Size** on the **System** tab.

8. Choose the **First Device** that the virtual machine will boot from on the **Boot Options** tab.

9. You can accept the default settings for all other fields, or change them if required. For more details on all fields in the **New Virtual Machine** window, see [Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows](sect-Explanation_of_Settings_in_the_New_Virtual_Machine_and_Edit_Virtual_Machine_Windows).

10. Click **OK**.

The new virtual machine is created and displays in the list of virtual machines with a status of `Down`.

## Starting the Virtual Machine

### Starting a Virtual Machine

**Starting Virtual Machines**

1. Click **Compute** &raar; **Virtual Machines** and select a virtual machine with a status of `Down`.

2. Click **Run**.

The **Status** of the virtual machine changes to `Up`, and the operating system installation begins. Open a console to the virtual machine if one does not open automatically.

    **Note:** A virtual machine will not start on a host that the CPU is overloaded on. By default, a host’s CPU is considered overloaded if it has a load of more than 80% for 5 minutes but these values can be changed using scheduling policies.

### Opening a Console to a Virtual Machine

Use Remote Viewer to connect to a virtual machine.

**Connecting to Virtual Machines**

1. Install Remote Viewer if it is not already installed. See [Installing Console Components](sect-Installing_Console_Components).

2. Click **Compute** &raar; **Virtual Machines** and select a virtual machine.

3. Click **Console**. A **console.vv** file will be downloaded.

4. Click on the file and a console window will automatically open for the virtual machine.

    **Note:** You can configure the system to automatically connect to a virtual machine. See the “Automatically Connecting to a Virtual Machine” below.

### Opening a Serial Console to a Virtual Machine

You can access a virtual machine’s serial console from the command line instead of opening a console from the Administration Portal or the VM Portal. The serial console is emulated through VirtIO channels, using SSH and key pairs. The Engine acts as a proxy for the connection, provides information about virtual machine placement, and stores the authentication keys. You can add public keys for each user from either the Administration Portal or the VM Portal. You can access serial consoles for only those virtual machines for which you have appropriate permissions.

    **Important:** To access the serial console of a virtual machine, the user must have **UserVmManager**, **SuperUser**, or **UserInstanceManager** permission on that virtual machine. These permissions must be explicitly defined for each user. It is not enough to assign these permissions to **Everyone**.

The serial console is accessed through TCP port 2222 on the Engine. This port is opened during engine-setup on new installations. To change the port, see **ovirt-vmconsole/README**.

The serial console relies on the `ovirt-vmconsole` package and the `ovirt-vmconsole-proxy` on the Engine, and the `ovirt-vmconsole` package and the `ovirt-vmconsole-host` package on the virtualization hosts. These packages are installed by default on new installations. To install the packages on existing installations, reinstall the host.

**Enabling a Virtual Machine’s Serial Console**

1. On the virtual machine whose serial console you are accessing, add the following lines to /etc/default/grub:

        GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"
        GRUB_TERMINAL="console serial"
        GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"

    **Note:** `GRUB_CMDLINE_LINUX_DEFAULT` applies this configuration only to the default menu entry. Use `GRUB_CMDLINE_LINUX` to apply the configuration to all the menu entries.

    If these lines already exist in **/etc/default/grub**, update them. Do not duplicate them.

2. Rebuild **/boot/grub2/grub.cfg**:

  * BIOS-based machines:

          # grub2-mkconfig -o /boot/grub2/grub.cfg

  * UEFI-based machines:

          # grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

3. On the client machine from which you are accessing the virtual machine serial console, generate an SSH key pair. The Engine supports standard SSH key types, for example, an RSA key:

        # ssh-keygen -t rsa -b 2048 -C "user@domain" -f .ssh/serialconsolekey

   This command generates a public key and a private key.

4. In the Administration Portal or the VM Portal, click the name of the signed-in user on the header bar and click **Options** to open the **Edit Options** window.

5. In the **User’s Public Key** text field, paste the public key of the client machine that will be used to access the serial console.

6. Click **Compute** → **Virtual Machines** and select a virtual machine.

7. Click **Edit**.

8. In the **Console** tab of the **Edit Virtual Machine** window, select the **Enable VirtIO serial console** check box.

**Connecting to a Virtual Machine’s Serial Console**

On the client machine, connect to the virtual machine’s serial console:

  * If a single virtual machine is available, this command connects the user to that virtual machine:

          # ssh -t -p 2222 ovirt-vmconsole@Manager_FQDN -i .ssh/serialconsolekey
          Red Hat Enterprise Linux Server release 6.7 (Santiago)
          Kernel 2.6.32-573.3.1.el6.x86_64 on an x86_64
          USER login:

  * If more than one virtual machine is available, this command lists the available virtual machines and their IDs:

          # ssh -t -p 2222 ovirt-vmconsole@Manager_FQDN -i .ssh/serialconsolekey list
          1. vm1 [vmid1]
          2. vm2 [vmid2]
          3. vm3 [vmid3]
          \> 2
          Red Hat Enterprise Linux Server release 6.7 (Santiago)
          Kernel 2.6.32-573.3.1.el6.x86_64 on an x86_64
          USER login:

    Enter the number of the machine to which you want to connect, and press `Enter`.

  * Alternatively, connect directly to a virtual machine using its unique identifier or its name:

          # ssh -t -p 2222 ovirt-vmconsole@Manager_FQDN connect --vm-id vmid1
          # ssh -t -p 2222 ovirt-vmconsole@Manager_FQDN connect --vm-name vm1

**Disconnecting from a Virtual Machine’s Serial Console**

Press any key followed by `~` . to close a serial console session.

If the serial console session is disconnected abnormally, a TCP timeout occurs. You will be unable to reconnect to the virtual machine’s serial console until the timeout period expires.

### Automatically Connecting to a Virtual Machine

Once you have logged in, you can automatically connect to a single running virtual machine. This can be configured in the VM Portal.

**Automatically Connecting to a Virtual Machine**

1. In the Virtual Machines page, click the name of the virtual machine to go to the details view.

2. Click the pencil icon beside **Console** and set **Connect automatically to ON**.

The next time you log into the VM Portal, if you have only one running virtual machine, you will automatically connect to that machine.

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

### Installing the Guest Agents and Drivers on Enterprise Linux

The ovirt guest agents and drivers are installed on Enterprise Linux virtual machines using the `ovirt-engine-guest-agent` package provided by the ovirt Agent repository.

**Installing the Guest Agents and Drivers on Enterprise Linux**

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

5. Start and enable the **qemu-ga** service:

    * For Enterprise Linux 6

            # service qemu-ga start
            # chkconfig qemu-ga on

    * For Enterprise Linux 7

            # systemctl start qemu-guest-agent.service
            # systemctl enable qemu-guest-agent.service

The guest agent now passes usage information to the ovirt Engine. The ovirt agent runs as a service called **ovirt-guest-agent** that you can configure via the **ovirt-guest-agent.conf** configuration file in the **/etc/** directory.

### Installing the Guest Agent on an Atomic Host

The ovirt guest agent should be installed as a [system container on Atomic hosts](https://github.com/projectatomic/atomic-system-containers/blob/master/USAGE.md)

**Installing the Guest Agent on an Atomic Host**

   The commands for a Centos7 Atomic host are essentially:

         # atomic pull --storage=ostree quay.io/nyoxi/ovirt-guest-agent
         # atomic install --system --system-package=no --name=ovirt-guest-agent quay.io/nyoxi/ovirt-guest-agent
         # systemctl status ovirt-guest-agent
         # systemctl start ovirt-guest-agent

   Note: there is [official documentation and separate image registry](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/running_system_containers#using_the_ovirt_guest_agent_system_container_image_for_red_hat_virtualization) for those with a RHV subscription.


**Prev:** [Chapter 1: Introduction](chap-Introduction)<br>
**Next:** [Chapter 3: Installing Windows Virtual Machines](chap-Installing_Windows_Virtual_Machines)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-installing_linux_virtual_machines)
