---
title: Reference Settings in Administration Portal and User Portal Windows
---

# Appendix A: Reference Settings in Administration Portal and User Portal Windows

## Explanation of Settings in the New Virtual Machine and Edit Virtual Machine Windows

### Virtual Machine General Settings Explained

The following table details the options available on the **General** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: General Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Cluster</b></td>
   <td>The name of the host cluster to which the virtual machine is attached. Virtual machines are hosted on any physical machine in that cluster in accordance with policy rules.</td>
  </tr>
  <tr>
   <td><b>Template</b></td>
   <td>
   <p>The template on which the virtual machine is based. This field is set to `Blank` by default, which allows you to create a virtual machine on which an operating system has not yet been installed. Templates are displayed as **Name | Sub-version name (Sub-version number)**. Each new version is displayed with a number in brackets that indicates the relative order of the version, with a higher number indicating a more recent version.</p>
   <p>The version name is displayed as `base version` if it is the root template of the template version chain.</p>
   <p>When the virtual machine is stateless, there is an option to select the `latest` version of the template. This option means that anytime a new version of this template is created, the virtual machine is automatically recreated on restart based on the latest template.</p>
   </td>
  </tr>
  <tr>
   <td><b>Operating System</b></td>
   <td>The operating system. Valid values include a range of Enterprise Linux and Windows variants.</td>
  </tr>
  <tr>
   <td><b>Instance Type</b></td>
   <td>
    <p>The instance type on which the virtual machine's hardware configuration can be based. This field is set to <b>Custom</b> by default, which means the virtual machine is not connected to an instance type. The other options available from this drop down menu are <b>Large</b>, <b>Medium</b>, <b>Small</b>, <b>Tiny</b>, <b>XLarge</b>, and any custom instance types that the Administrator has created.</p>
    <p>Other settings that have a chain link icon next to them are pre-filled by the selected instance type. If one of these values is changed, the virtual machine will be detached from the instance type and the chain icon will appear broken. However, if the changed setting is restored to its original value, the virtual machine will be reattached to the instance type and the links in the chain icon will rejoin.</p>
   </td>
  </tr>
  <tr>
   <td><b>Optimized for</b></td>
   <td>The type of system for which the virtual machine is to be optimized. There are two options: <b>Server</b>, and <b>Desktop</b>; by default, the field is set to <b>Server</b>. Virtual machines optimized to act as servers have no sound card, use a cloned disk image, and are not stateless. In contrast, virtual machines optimized to act as desktop machines do have a sound card, use an image (thin allocation), and are stateless.</td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the virtual machine. The name must be a unique name within the data center and must not contain any spaces, and must contain at least one character from A-Z or 0-9. The maximum length of a virtual machine name is 255 characters. The name can be re-used in different data centers in the environment.</td>
  </tr>
  <tr>
   <td><b>VM ID</b></td>
   <td>The virtual machine ID. The virtual machine's creator can set a custom ID for that virtual machine. If no ID is specified during creation a UUID will be automatically assigned. For both custom and automatically-generated IDs, changes are not possible after virtual machine creation.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A meaningful description of the new virtual machine.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text human-readable comments regarding the virtual machine.</td>
  </tr>
  <tr>
   <td><b>Affinity Labels</b></td>
   <td>Add or remove a selected **Affinity Label**.</td>
  </tr>
  <tr>
   <td><b>Stateless</b></td>
   <td>Select this check box to run the virtual machine in stateless mode. This mode is used primarily for desktop virtual machines. Running a stateless desktop or server creates a new COW layer on the VM hard disk image where new and changed data is stored. Shutting down the stateless VM deletes the new COW layer, which returns the VM to its original state. Stateless virtual machines are useful when creating machines that need to be used for a short time, or by temporary staff.</td>
  </tr>
  <tr>
   <td><b>Start in Pause Mode</b></td>
   <td>Select this check box to always start the virtual machine in pause mode. This option is suitable for virtual machines which require a long time to establish a SPICE connection; for example, virtual machines in remote locations.</td>
  </tr>
  <tr>
   <td><b>Delete Protection</b></td>
   <td>Select this check box to make it impossible to delete the virtual machine. It is only possible to delete the virtual machine if this check box is not selected.</td>
  </tr>
  <tr>
   <td><b>Instance Images</b></td>
   <td>
    <p>Click <b>Attach</b> to attach a floating disk to the virtual machine, or click <b>Create</b> to add a new virtual disk. Use the plus and minus buttons to add or remove additional virtual disks.</p>
    <p>Click <b>Edit</b> to reopen the <b>Attach Virtual Disks</b> or <b>New Virtual Disk</b> window. This button appears after a virtual disk has been attached or created.</p>
   </td>
  </tr>
  <tr>
   <td><b>Instantiate VM network interfaces by picking a vNIC profile.</b></td>
   <td>Add a network interface to the virtual machine by selecting a vNIC profile from the <b>nic1</b> drop-down list. Use the plus and minus buttons to add or remove additional network interfaces.</td>
  </tr>
 </tbody>
</table>

### Virtual Machine System Settings Explained

The following table details the options available on the **System** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: System Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Memory Size</b></td>
   <td>The amount of memory assigned to the virtual machine. When allocating memory, consider the processing and storage needs of the applications that are intended to run on the virtual machine.</td>
  </tr>
  <tr>
   <td><b>Maximum Memory</b></td>
   <td>The maximum amount of memory that can be assigned to the virtual machine. Maximum guest memory is also constrained by the selected guest architecture and the cluster compatibility level.</td>
  </tr>
  <tr>
   <td><b>Total Virtual CPUs</b></td>
   <td>The processing power allocated to the virtual machine as CPU Cores. Do not assign more cores to a virtual machine than are present on the physical host.</td>
  </tr>
  <tr>
   <td><b>Virtual Sockets</b></td>
   <td>The number of CPU sockets for the virtual machine. Do not assign more sockets to a virtual machine than are present on the physical host.</td>
  </tr>
  <tr>
   <td><b>Cores per Virtual Socket</b></td>
   <td>The number of cores assigned to each virtual socket.</td>
  </tr>
  <tr>
   <td><b>Threads per Core</b></td>
   <td>The number of threads assigned to each core. Increasing the value enables simultaneous multi-threading (SMT). IBM POWER8 supports up to 8 threads per core. For x86 (Intel and AMD) CPU types, the recommended value is 1. </td>
  </tr>
  <tr>
   <td><b>Custom Emulated Machine</b></td>
   <td>This option allows you to specify the machine type. If changed, the virtual machine will only run on hosts that support this machine type. Defaults to the cluster's default machine type.</td>
  </tr>
  <tr>
   <td><b>Custom CPU Type</b></td>
   <td>This option allows you to specify a CPU type. If changed, the virtual machine will only run on hosts that support this CPU type. Defaults to the cluster's default CPU type.</td>
  </tr>
  <tr>
   <td><b>Custom Compatibility Version</b></td>
   <td>The compatibility version determines which features are supported by the cluster, as well as, the values of some properties and the emulated machine type. By default, the virtual machine is configured to run in the same compatibility mode as the cluster as the default is inherited from the cluster. In some situations the default compatibility mode needs to be changed. An example of this is if the cluster has been updated to a later compatibility version but the virtual machines have not been restarted. These virtual machines can be set to use a custom compatibility mode that is older than that of the cluster</td>
  </tr>
  <tr>
   <td><b>Hardware Clock Time Offset</b></td>
   <td>This option sets the time zone offset of the guest hardware clock. For Windows, this should correspond to the time zone set in the guest. Most default Linux installations expect the hardware clock to be GMT+00:00.</td>
  </tr>
  <tr>
   <td><b>Provide custom serial number policy</b></td>
   <td>
    <p>This check box allows you to specify a serial number for the virtual machine. Select either:</p>
    <ul>
     <li><b>Host ID</b>: Sets the host's UUID as the virtual machine's serial number.</li>
     <li><b>Vm ID</b>: Sets the virtual machine's UUID as its serial number.</li>
     <li><b>Custom serial number</b>: Allows you to specify a custom serial number.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

### Virtual Machine Initial Run Settings Explained

The following table details the options available on the **Initial Run** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows. The settings in this table are only visible if the **Use Cloud-Init/Sysprep** check box is selected, and certain options are only visible when either a Linux-based or Windows-based option has been selected in the **Operating System** list in the **General** tab, as outlined below.

**Virtual Machine: Initial Run Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Operating System</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Use Cloud-Init/Sysprep</b></td>
   <td>Linux, Windows</td>
   <td>This check box toggles whether Cloud-Init or Sysprep will be used to initialize the virtual machine.</td>
  </tr>
  <tr>
   <td><b>VM Hostname</b></td>
   <td>Linux, Windows</td>
   <td>The host name of the virtual machine.</td>
  </tr>
  <tr>
   <td><b>Domain</b></td>
   <td>Windows</td>
   <td>The Active Directory domain to which the virtual machine belongs.</td>
  </tr>
  <tr>
   <td><b>Organization Name</b></td>
   <td>Windows</td>
   <td>The name of the organization to which the virtual machine belongs. This option corresponds to the text field for setting the organization name displayed when a machine running Windows is started for the first time.</td>
  </tr>
  <tr>
   <td><b>Active Directory OU</b></td>
   <td>Windows</td>
   <td>The organizational unit in the Active Directory domain to which the virtual machine belongs.</td>
  </tr>
  <tr>
   <td><b>Configure Time Zone</b></td>
   <td>Linux, Windows</td>
   <td>The time zone for the virtual machine. Select this check box and select a time zone from the <b>Time Zone</b> list.</td>
  </tr>
  <tr>
   <td><b>Admin Password</b></td>
   <td>Windows</td>
   <td>
    <p>The administrative user password for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>Use already configured password</b>: This check box is automatically selected after you specify an initial administrative user password. You must clear this check box to enable the <b>Admin Password</b> and <b>Verify Admin Password</b> fields and specify a new password.</li>
     <li><b>Admin Password</b>: The administrative user password for the virtual machine. Enter the password in this text field and the <b>Verify Admin Password</b> text field to verify the password.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Authentication</b></td>
   <td>Linux</td>
   <td>
    <p>The authentication details for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>Use already configured password</b>: This check box is automatically selected after you specify an initial root password. You must clear this check box to enable the <b>Password</b> and <b>Verify Password</b> fields and specify a new password.</li>
     <li><b>Password</b>: The root password for the virtual machine. Enter the password in this text field and the <b>Verify Password</b> text field to verify the password.</li>
     <li><b>SSH Authorized Keys</b>: SSH keys to be added to the authorized keys file of the virtual machine. You can specify multiple SSH keys by entering each SSH key on a new line.</li>
     <li><b>Regenerate SSH Keys</b>: Regenerates SSH keys for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Custom Locale</b></td>
   <td>Windows</td>
   <td>
    <p>Custom locale options for the virtual machine. Locales must be in a format such as <tt>en-US</tt>. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>Input Locale</b>: The locale for user input.</li>
     <li><b>UI Language</b>: The language used for user interface elements such as buttons and menus.</li>
     <li><b>System Locale</b>: The locale for the overall system.</li>
     <li><b>User Locale</b>: The locale for users.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Networks</b></td>
   <td>Linux</td>
   <td>
    <p>Network-related settings for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>DNS Servers</b>: The DNS servers to be used by the virtual machine.</li>
     <li><b>DNS Search Domains</b>: The DNS search domains to be used by the virtual machine.</li>
     <li><b>Network</b>: Configures network interfaces for the virtual machine. Select this check box and click <b>+</b> or <b>-</b> to add or remove network interfaces to or from the virtual machine. When you click <b>+</b>, a set of fields becomes visible that can specify whether to use DHCP, and configure an IP address, netmask, and gateway, and specify whether the network interface will start on boot.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Custom Script</b></td>
   <td>Linux</td>
   <td>Custom scripts that will be run on the virtual machine when it starts. The scripts entered in this field are custom YAML sections that are added to those produced by the Engine, and allow you to automate tasks such as creating users and files, configuring <i>yum</i> repositories and running commands. For more information on the format of scripts that can be entered in this field, see the <a href="http://cloudinit.readthedocs.org/en/latest/topics/examples.html#yaml-examples">Custom Script</a> documentation.</td>
  </tr>
  <tr>
   <td><b>Sysprep</b></td>
   <td>Windows</td>
   <td>A custom Sysprep definition. The definition must be in the format of a complete unattended installation answer file. You can copy and paste the default answer files in the <tt>/usr/share/ovirt-engine/conf/sysprep/</tt> directory on the machine on which the oVirt Engine is installed and alter the fields as required.</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Console Settings Explained

The following table details the options available on the **Console** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Console Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
 <tr>
  <td><b>Graphical Console Section</b></td>
  <td> </td>
 </tr>
 <tr>
  <td><b>Headless Mode</b></td>
  <td>
  <p>Select this check box if you do not a require a graphical console for the virtual machine.</p>
  <p>When selected, all other fields in the Graphical Console section are disabled. In the VM Portal, the Console icon in the virtual machine’s details view is also disabled.</p>
  <p><b>Important:</b> See “Configuring Headless Virtual Machines” in Chapter 4 for more details and prerequisites for using headless mode.</p>
  </td>
 </tr>
 <tr>
  <td><b>Video Type</b></td>
  <td>Defines the graphics device. **QXL** is the default and supports both graphic protocols. **VGA** and **CIRRUS** support only the VNC protocol.</td>
 </tr>
  <tr>
   <td><b>Graphics protocol</b></td>
   <td>Defines which display protocol to use. <b>SPICE</b> is the recommended protocol as it supports more features. <b>VNC</b> is an alternative option and requires a VNC client to connect to a virtual machine. Select <b>SPICE + VNC</b> for the most flexible option.</td>
  </tr>
  <tr>
   <td><b>VNC Keyboard Layout</b></td>
   <td>Defines the keyboard layout for the virtual machine. This option is only available when using the VNC protocol.</td>
  </tr>
  <tr>
   <td><b>USB Support</b></td>
   <td>
    <p>Defines whether USB devices can be used on the virtual machine. This option is only available for virtual machines using the SPICE protocol. Select either:</p>
    <ul>
     <li><b>Disabled</b> - Does not allow USB redirection from the client machine to the virtual machine.</li>
     <li><b>Legacy</b> - Enables the SPICE USB redirection policy used in oVirt 3.0. This option can only be used on Windows virtual machines, and will not be supported in future versions of oVirt.</li>
     <li><b>Native</b> - Enables native KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual machines do not require any in-guest agents or drivers for native USB.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Console Disconnect Action</b></td>
   <td>
    <p>Defines what happens when the console is disconnected. This is only relevant with SPICE and VNC console connections. This setting can be changed while the virtual machine is running but will not take effect until a new console connection is established. Select either:</p>
    <ul>
     <li><b>No action</b> - No action is taken.</li>
     <li><b>Lock screen</b> - This is the default option. For all Linux machines and for Windows desktops this locks the currently active user session. For Windows servers, this locks the desktop and the currently active user.</li>
     <li><b>Logout user</b> - For all Linux machines and Windows desktops, this logs out the currently active user session. For Windows servers, the desktop and the currently active user are logged out.</li>
     <li><b>Shutdown virtual machine</b> - Initiates a graceful virtual machine shutdown.</li>
     <li><b>Reboot virtual machine</b> - Initiates a graceful virtual machine reboot.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Monitors</b></td>
   <td>The number of monitors for the virtual machine. This option is only available for virtual desktops using the SPICE display protocol. You can choose <b>1</b>, <b>2</b> or <b>4</b>. Note that multiple monitors are not supported for Windows 8 and Windows Server 2012 virtual machines.</td>
  </tr>
  <tr>
   <td><b>Smartcard Enabled</b></td>
   <td>Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect oVirt virtual machines. Tick or untick the check box to activate and deactivate Smart card authentication for individual virtual machines.</td>
  </tr>
  <tr>
   <td><b>Disable strict user checking</b></td>
   <td>
    <p>Click the <b>Advanced Parameters</b> arrow and select the check box to use this option. With this option selected, the virtual machine does not need to be rebooted when a different user connects to it.</p>
    <p>By default, strict checking is enabled so that only one user can connect to the console of a virtual machine. No other user is able to open a console to the same virtual machine until it has been rebooted. The exception is that a <tt>SuperUser</tt> can connect at any time and replace a existing connection. When a <tt>SuperUser</tt> has connected, no normal user can connect again until the virtual machine is rebooted.</p>
    <p>Disable strict checking with caution, because you can expose the previous user's session to the new user.</p>
   </td>
  </tr>
  <tr>
   <td><b>Soundcard Enabled</b></td>
   <td>A sound card device is not necessary for all virtual machine use cases. If it is for yours, enable a sound card here.</td>
  </tr>
  <tr>
   <td><b>Enable SPICE file transfer</b></td>
   <td>Defines whether a user is able to drag and drop files from an external host into the virtual machine’s SPICE console. This option is only available for virtual machines using the SPICE protocol. This check box is selected by default.</td>
  </tr>
  <tr>
   <td><b>Enable SPICE clipboard copy and paste</b></td>
   <td>Defines whether a user is able to copy and paste content from an external host into the virtual machine’s SPICE console. This option is only available for virtual machines using the SPICE protocol. This check box is selected by default.</td>
  </tr>
  <tr>
   <td><b>Serial Console Section</b></td>
   <td> </td>
  </tr>
  <tr>
   <td><b>Enable VirtIO serial console</b></td>
   <td>The VirtIO serial console is emulated through VirtIO channels, using SSH and key pairs, and allows you to access a virtual machine's serial console directly from a client machine's command line, instead of opening a console from the Administration Portal or the User Portal. The serial console requires direct access to the Engine, since the Engine acts as a proxy for the connection, provides information about virtual machine placement, and stores the authentication keys. Select the check box to enable the VirtIO console on the virtual machine.</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Host Settings Explained

The following table details the options available on the **Host** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Host Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Sub-element</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Start Running On</b></td>
   <td> </td>
   <td>
    <p>Defines the preferred host on which the virtual machine is to run. Select either:</p>
    <ul>
     <li><b>Any Host in Cluster</b> - The virtual machine can start and run on any available host in the cluster.</li>
     <li><b>Specific</b> - The virtual machine will start running on a particular host in the cluster. However, the Engine or an administrator can migrate the virtual machine to a different host in the cluster depending on the migration and high-availability settings of the virtual machine. Select the specific host or group of hosts from the list of available hosts.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Migration Options</b></td>
   <td><b>Migration mode</b></td>
   <td>
    <p>Defines options to run and migrate the virtual machine. If the options here are not used, the virtual machine will run or migrate according to its cluster's policy.</p>
    <ul>
     <li><b>Allow manual and automatic migration</b> - The virtual machine can be automatically migrated from one host to another in accordance with the status of the environment, or manually by an administrator.</li>
     <li><b>Allow manual migration only</b> - The virtual machine can only be migrated from one host to another manually by an administrator.</li>
     <li><b>Do not allow migration</b> - The virtual machine cannot be migrated, either automatically or manually.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Use custom migration policy</b></td>
   <td>
    <p>Defines the migration convergence policy. If the check box is left unselected, the host determines the policy.</p>
    <ul>
     <li><b>Legacy</b> - Legacy behavior of 3.6 version. Overrides in <tt>vdsm.conf</tt> are still applied. The guest agent hook mechanism is disabled.</li>
     <li><b>Minimal downtime</b> - Allows the virtual machine to migrate in typical situations. Virtual machines should not experience any significant downtime. The migration will be aborted if virtual machine migration does not converge after a long time (dependent on QEMU iterations, with a maximum of 500 milliseconds). The guest agent hook mechanism is enabled.</li>
     <li><b>Suspend workload if needed</b> - Allows the virtual machine to migrate in most situations, including when the virtual machine is running a heavy workload. Virtual machines may experience a more significant downtime. The migration may still be aborted for extreme workloads. The guest agent hook mechanism is enabled.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Use custom migration downtime</b></td>
   <td>This check box allows you to specify the maximum number of milliseconds the virtual machine can be down during live migration. Configure different maximum downtimes for each virtual machine according to its workload and SLA requirements. Enter <tt>0</tt> to use the VDSM default value.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Auto Converge migrations</b></td>
   <td>
    <p>Only activated with the <b>Legacy</b> migration policy. Allows you to set whether auto-convergence is used during live migration of the virtual machine. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine. Auto-convergence is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from cluster setting</b> to use the auto-convergence setting that is set at the cluster level. This option is selected by default.</li>
     <li>Select <b>Auto Converge</b> to override the cluster setting or global setting and allow auto-convergence for the virtual machine.</li>
     <li>Select <b>Don't Auto Converge</b> to override the cluster setting or global setting and prevent auto-convergence for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Enable migration compression</b></td>
   <td>
    <p>Only activated with the <b>Legacy</b> migration policy. The option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern. Migration compression is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from cluster setting</b> to use the compression setting that is set at the cluster level. This option is selected by default.</li>
     <li>Select <b>Compress</b> to override the cluster setting or global setting and allow compression for the virtual machine.</li>
     <li>Select <b>Don't compress</b> to override the cluster setting or global setting and prevent compression for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Pass-Through Host CPU</b></td>
   <td>This check box allows virtual machines to take advantage of the features of the physical CPU of the host on which they are situated. This option can only be enabled when <b>Do not allow migration</b> is selected.</td>
  </tr>
  <tr>
   <td><b>Configure NUMA</b></td>
   <td><b>NUMA Node Count</b></td>
   <td>The number of virtual NUMA nodes to assign to the virtual machine. If the <b>Tune Mode</b> is <b>Preferred</b>, this value must be set to <tt>1</tt>.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Tune Mode</b></td>
   <td>
    <p>The method used to allocate memory.</p>
    <ul>
     <li><b>Strict</b>: Memory allocation will fail if the memory cannot be allocated on the target node.</li>
     <li><b>Preferred</b>: Memory is allocated from a single preferred node. If sufficient memory is not available, memory can be allocated from other nodes.</li>
     <li><b>Interleave</b>: Memory is allocated across nodes in a round-robin algorithm.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>NUMA Pinning</b></td>
   <td>Opens the <b>NUMA Topology</b> window. This window shows the host's total CPUs, memory, and NUMA nodes, and the virtual machine's virtual NUMA nodes. Pin virtual NUMA nodes to host NUMA nodes by clicking and dragging each vNUMA from the box on the right to a NUMA node on the left. </td>
  </tr>
 </tbody>
</table>

### Virtual Machine High Availability Settings Explained

The following table details the options available on the **High Availability** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: High Availability Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Highly Available</b></td>
   <td>
    <p>Select this check box if the virtual machine is to be highly available. For example, in cases of host maintenance, all virtual machines are automatically live migrated to another host. If the host crashed and is in a non-responsive state, only virtual machines with high availability are restarted on another host. If the host is manually shut down by the system administrator, the virtual machine is not automatically live migrated to another host.</p>
    <p>Note that this option is unavailable if the <b>Migration Options</b> setting in the <b>Hosts</b> tab is set to either <b>Allow manual migration only</b> or <b>Do not allow migration</b>. For a virtual machine to be highly available, it must be possible for the Engine to migrate the virtual machine to other available hosts as necessary.</p>
   </td>
  </tr>
  <tr>
   <td><b>Target Storage Domain for VM Lease</b></td>
   <td>
    <p>Select the storage domain to hold a virtual machine lease, or select **No VM Lease** to disable the functionality. When a storage domain is selected, it will hold a virtual machine lease on a special volume that allows the virtual machine to be started on another host if the original host loses power or becomes unresponsive.</p>
    <p>This functionality is only available on storage domain V4 or later.</p>
    <p>**Note:** If you define a lease, the only Resume Behavior available is KILL.</p>
   </td>
  </tr>
  <tr>
   <td><b>Resume Behavior</b></td>
   <td>
    <p>Defines the desired behavior of a virtual machine that is paused due to storage I/O errors, once a connection with the storage is reestablished. You can define the desired resume behavior even if the virtual machine is not highly available.</p>
    <p>The following options are available:</p>
    <ul>
    <li>**AUTO_RESUME** - The virtual machine is automatically resumed, without requiring user intervention. This is recommended for virtual machines that are not highly available and that do not require user intervention after being in the paused state.</li>
    <li>**LEAVE_PAUSED** - The virtual machine remains in pause mode until it is manually resumed or restarted.</li>
    <li>**KILL** - The virtual machine is automatically resumed if the I/O error is remedied within 80 seconds. However, if more than 80 seconds pass, the virtual machine is ungracefully shut down. This is recommended for highly available virtual machines, to allow the Manager to restart them on another host that is not experiencing the storage I/O error.<br/>
    **KILL** is the only option available when using virtual machine leases.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Priority for Run/Migration queue</b></td>
   <td>Sets the priority level for the virtual machine to be migrated or restarted on another host.</td>
  </tr>
  <tr>
   <td><b>Watchdog</b></td>
   <td>
    <p>Allows users to attach a watchdog card to a virtual machine. A watchdog is a timer that is used to automatically detect and recover from failures. Once set, a watchdog timer continually counts down to zero while the system is in operation, and is periodically restarted by the system to prevent it from reaching zero. If the timer reaches zero, it signifies that the system has been unable to reset the timer and is therefore experiencing a failure. Corrective actions are then taken to address the failure. This functionality is especially useful for servers that demand high availability.</p>
    <p><b>Watchdog Model</b>: The model of watchdog card to assign to the virtual machine. At current, the only supported model is <b>i6300esb</b>.</p>
    <p><b>Watchdog Action</b>: The action to take if the watchdog timer reaches zero. The following actions are available:</p>
    <ul>
     <li><b>none</b> - No action is taken. However, the watchdog event is recorded in the audit log.</li>
     <li><b>reset</b> - The virtual machine is reset and the Engine is notified of the reset action.</li>
     <li><b>poweroff</b> - The virtual machine is immediately shut down.</li>
     <li><b>dump</b> - A dump is performed and the virtual machine is paused.</li>
     <li><b>pause</b> - The virtual machine is paused, and can be resumed by users.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

### Virtual Machine Resource Allocation Settings Explained

The following table details the options available on the **Resource Allocation** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Resource Allocation Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Sub-element</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>CPU Allocation</b></td>
   <td><b>CPU Profile</b></td>
   <td>The CPU profile assigned to the virtual machine. CPU profiles define the maximum amount of processing capability a virtual machine can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. CPU profiles are defined on the cluster level based on quality of service entries created for data centers.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>CPU Shares</b></td>
   <td>
    <p>Allows users to set the level of CPU resources a virtual machine can demand relative to other virtual machines.</p>
    <ul>
     <li><b>Low</b> - 512</li>
     <li><b>Medium</b> - 1024</li>
     <li><b>High</b> - 2048</li>
     <li><b>Custom</b> - A custom level of CPU shares defined by the user.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>CPU Pinning topology</b></td>
   <td>
    <p>Enables the virtual machine's virtual CPU (vCPU) to run on a specific physical CPU (pCPU) in a specific host. The syntax of CPU pinning is <tt>v#p[_ v#p]</tt>, for example:</p>
    <ul>
     <li><tt>0#0</tt> - Pins vCPU 0 to pCPU 0.</li>
     <li><tt>0#0_1#3</tt> - Pins vCPU 0 to pCPU 0, and pins vCPU 1 to pCPU 3.</li>
     <li><tt>1#1-4,^2</tt> - Pins vCPU 1 to one of the pCPUs in the range of 1 to 4, excluding pCPU 2.</li>
    </ul>
    <p>In order to pin a virtual machine to a host, you must also select the following on the <b>Host</b> tab:</p>
    <ul>
     <li><b>Start Running On:</b> <b>Specific</b></li>
     <li><b>Migration Options:</b> <b>Do not allow migration</b></li>
     <li><b>Pass-Through Host CPU</b></li>
    </ul>
    <p>If CPU pinning is set and you change **Start Running On: Specific** or **Migration Options: Do not allow migration**, a **CPU pinning topology will be lost** window appears when you click **OK**.</p>
   </td>
  </tr>
  <tr>
   <td><b>Memory Allocation</b></td>
   <td><b>Physical Memory Guaranteed</b></td>
   <td>The amount of physical memory guaranteed for this virtual machine. Should be any number between 0 and the defined memory for this virtual machine.</td>
  </tr>
  <tr>
   <td><b> </b></td>
   <td><b>Memory Balloon Device Enabled</b></td>
   <td>Enables the memory balloon device for this virtual machine. Enable this setting to allow memory overcommitment in a cluster. Enable this setting for applications that allocate large amounts of memory suddenly but set the guaranteed memory to the same value as the defined memory.Use ballooning for applications and loads that slowly consume memory, occasionally release memory, or stay dormant for long periods of time, such as virtual desktops.</td>
  </tr>
  <tr>
   <td><b>IO Threads</b></td>
   <td><b>IO Threads Enabled</b></td>
   <td>Enables virtio-blk data plane. Select this check box to improve the speed of disks that have a VirtIO interface by pinning them to a thread separate from the virtual machine's other functions. Improved disk performance increases a virtual machine's overall performance. Disks with VirtIO interfaces are pinned to an IO thread using a round-robin algorithm.</td>
  </tr>
  <tr>
   <td><b>Queues</b></td>
   <td><b>Multi Queues Enabled</b></td>
   <td>
   <p>Enables multiple queues. This check box is selected by default. It creates up to four queues per vNIC, depending on how many vCPUs are available.</p>
   <p>It is possible to define a different number of queues per vNIC by creating a custom property as follows:</p>
   <pre>engine-config -s "CustomDeviceProperties={type=interface;prop={other-nic-properties;queues=[1-9][0-9]\*}}"</pre>
   <p>where other-nic-properties is a semicolon-separated list of pre-existing NIC custom properties.</p>
   </td>
  </tr>
  <tr>
   <td><b>Storage Allocation</b></td>
   <td> </td>
   <td>The **Storage Allocation** option is only available when the virtual machine is created from a template.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Thin</b></td>
   <td>Provides optimized usage of storage capacity. Disk space is allocated only as it is required.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Clone</b></td>
   <td>Optimized for the speed of guest read and write operations. All disk space requested in the template is allocated at the time of the clone operation.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>VirtIO-SCSI Enabled</b></td>
   <td>Allows users to enable or disable the use of VirtIO-SCSI on the virtual machines.</td>
  </tr>
  <tr>
   <td><b>Disk Allocation</b></td>
   <td> </td>
   <td>The **Disk Allocation** option is only available when you are creating a virtual machine from a template.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Alias</b></td>
   <td>An alias for the virtual disk. By default, the alias is set to the same value as that of the template.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Virtual Size</b></td>
   <td>The total amount of disk space that the virtual machine based on the template can use. This value cannot be edited, and is provided for reference only.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Format</b></td>
   <td>The format of the virtual disk. The available options are **QCOW2** and **Raw**. When **Storage Allocation** is **Thin**, the disk format is **QCOW2**. When Storage Allocation is **Clone**, select **QCOW2** or **Raw**.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Target</b></td>
   <td>The storage domain on which the virtual disk is stored. By default, the storage domain is set to the same value as that of the template.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Disk Profile</b></td>
   <td>The disk profile to assign to the virtual disk. Disk profiles are created based on storage profiles defined in the data centers.</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Boot Options Settings Explained

The following table details the options available on the **Boot Options** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows

**Virtual Machine: Boot Options Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>First Device</b></td>
   <td>
    <p>After installing a new virtual machine, the new virtual machine must go into Boot mode before powering up. Select the first device that the virtual machine must try to boot:</p>
    <ul>
     <li><b>Hard Disk</b></li>
     <li><b>CD-ROM</b></li>
     <li><b>Network (PXE)</b></li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Second Device</b></td>
   <td>Select the second device for the virtual machine to use to boot if the first device is not available. The first device selected in the previous option does not appear in the options.</td>
  </tr>
  <tr>
   <td><b>Attach CD</b></td>
   <td>If you have selected <b>CD-ROM</b> as a boot device, tick this check box and select a CD-ROM image from the drop-down menu. The images must be available in the ISO domain.</td>
  </tr>
  <tr>
   <td><b>Enable menu to select boot device</b></td>
   <td>
Enables a menu to select the boot device. After the virtual machine starts and connects to the console, but before the virtual machine starts booting, a menu displays that allows you to select the boot device. This option should be enabled before the initial boot to allow you to select the required installation media.</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Random Generator Settings Explained

The following table details the options available on the **Random Generator** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Random Generator Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Random Generator enabled</b></td>
   <td>Selecting this check box enables a paravirtualized Random Number Generator PCI device (virtio-rng). This device allows entropy to be passed from the host to the virtual machine in order to generate a more sophisticated random number. Note that this check box can only be selected if the RNG device exists on the host and is enabled in the host's cluster.</td>
  </tr>
  <tr>
   <td><b>Period duration (ms)</b></td>
   <td>Specifies the duration of a period in milliseconds. If omitted, the libvirt default of 1000 milliseconds (1 second) is used. If this field is filled, <b>Bytes per period</b> must be filled also.</td>
  </tr>
  <tr>
   <td><b>Bytes per period</b></td>
   <td>Specifies how many bytes are permitted to be consumed per period.</td>
  </tr>
  <tr>
   <td><b>Device source:</b></td>
   <td>
    <p>The source of the random number generator. This is automatically selected depending on the source supported by the host's cluster.</p>
    <ul>
     <li><b>/dev/random source</b> - The Linux-provided random number generator.</li>
     <li><b>/dev/hwrng source</b> - An external hardware generator.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

### Virtual Machine Custom Properties Settings Explained

The following table details the options available on the **Custom Properties** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Custom Properties Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
   <td>Recommendations and Limitations</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>sap_agent</b></td>
   <td>Enables SAP monitoring on the virtual machine. Set to <b>true</b> or <b>false</b>.</td>
   <td>-</td>
  </tr>
  <tr>
   <td><b>sndbuf</b></td>
   <td>Enter the size of the buffer for sending the virtual machine's outgoing data over the socket. Default value is 0.</td>
   <td>-</td>
  </tr>
  <tr>
   <td><b>vhost</b></td>
   <td>
    <p>Disables vhost-net, which is the kernel-based virtio network driver on virtual network interface cards attached to the virtual machine. To disable vhost, the format for this property is:</p>
    <pre>LogicalNetworkName: false</pre>
    <p>This will explicitly start the virtual machine without the vhost-net setting on the virtual NIC attached to `LogicalNetworkName`.</p>
   </td>
   <td>vhost-net provides better performance than virtio-net, and if it is present, it is enabled on all virtual machine NICs by default. Disabling this property makes it easier to isolate and diagnose performance issues, or to debug vhost-net errors; for example, if migration fails for virtual machines on which vhost does not exist.</td>
  </tr>
  <tr>
   <td><b>viodiskcache</b></td>
   <td>Caching mode for the virtio disk. <b>writethrough</b> writes data to the cache and the disk in parallel, <b>writeback</b> does not copy modifications from the cache to the disk, and <b>none</b> disables caching.</td>
   <td>If viodiskcache is enabled, the virtual machine cannot be live migrated.</td>
  </tr>
 </tbody>
</table>

**Warning:** Increasing the value of the sndbuf custom property results in increased occurrences of communication failure between hosts and unresponsive virtual machines.

### Virtual Machine Icon Settings Explained

You can add custom icons to virtual machines and templates. Custom icons can help to differentiate virtual machines in the User Portal. The following table details the options available on the **Icon** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Icon Settings**

<table>
 <thead>
  <tr>
   <td>Button Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Upload</b></td>
   <td>
    <p>Click this button to select a custom image to use as the virtual machine's icon. The following limitations apply:</p>
    <ul>
     <li>Supported formats: jpg, png, gif</li>
     <li>Maximum size: 24 KB</li>
     <li>Maximum dimensions: 150px width, 120px height</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Use default</b></td>
   <td>Click this button to set the operating system's default image as the virtual machine's icon.</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Foreman/Satellite Settings Explained

The following table details the options available on the **Foreman/Satellite** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows

**Virtual Machine:Foreman/Satellite Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Provider</b></td>
   <td>If the virtual machine is running Enterprise Linux and the system is configured to work with a Foreman server, select the name of the Foreman from the list. This enables you to use Foreman's content management feature to display the relevant Errata for this virtual machine.</td>
  </tr>
 </tbody>
</table>

## Explanation of Settings in the Run Once Window

The **Run Once** window defines one-off boot options for a virtual machine. For persistent boot options, use the **Boot Options** tab in the **New Virtual Machine** window. The **Run Once** window contains multiple sections that can be configured.

The standalone **Rollback this configuration during reboots** check box specifies whether reboots (initiated by the Engine, or from within the guest) will be warm (soft) or cold (hard). Select this check box to configure a cold reboot that restarts the virtual machine with regular (non-**Run Once**) configuration. Clear this check box to configure a warm reboot that retains the virtual machine’s **Run Once** configuration.

The **Boot Options** section defines the virtual machine's boot sequence, running options, and source images for installing the operating system and required drivers.

**Boot Options Section**

| Field Name | Description |
|-
| **Attach Floppy** | Attaches a diskette image to the virtual machine. Use this option to install Windows drivers. The diskette image must reside in the ISO domain. |
| **Attach CD** | Attaches an ISO image to the virtual machine. Use this option to install the virtual machine's operating system and applications. The CD image must reside in the ISO domain. |
| **Enable menu to select boot device** | Enables a menu to select the boot device. After the virtual machine starts and connects to the console, but before the virtual machine starts booting, a menu displays that allows you to select the boot device. This option should be enabled before the initial boot to allow you to select the required installation media. |
| **Start in Pause Mode** | Starts then pauses the virtual machine to enable connection to the console, suitable for virtual machines in remote locations. |
| **Predefined Boot Sequence** | Determines the order in which the boot devices are used to boot the virtual machine. Select **Hard Disk**, **CD-ROM**, or **Network (PXE)**, and use **Up** and **Down** to move the option up or down in the list. |
| **Run Stateless** | Deletes all changes to the virtual machine upon shutdown. This option is only available if a virtual disk is attached to the virtual machine. |

The **Linux Boot Options** section contains fields to boot a Linux kernel directly instead of through the BIOS bootloader.

**Linux Boot Options Section**

| Field Name | Description |
|-
| **kernel path** | A fully qualified path to a kernel image to boot the virtual machine. The kernel image must be stored on either the ISO domain (path name in the format of `iso://path-to-image`) or on the host's local storage domain (path name in the format of `/data/images`). |
| **initrd path** | A fully qualified path to a ramdisk image to be used with the previously specified kernel. The ramdisk image must be stored on the ISO domain (path name in the format of `iso://path-to-image`) or on the host's local storage domain (path name in the format of `/data/images`). |
| **kernel parameters** | Kernel command line parameter strings to be used with the defined kernel on boot. |

The **Initial Run** section is used to specify whether to use Cloud-Init or Sysprep to initialize the virtual machine. For Linux-based virtual machines, you must select the **Use Cloud-Init** check box in the **Initial Run** tab to view the available options. For Windows-based virtual machines, you must attach the `[sysprep]` floppy by selecting the **Attach Floppy** check box in the **Boot Options** tab and selecting the floppy from the list.

The options that are available in the **Initial Run** section differ depending on the operating system that the virtual machine is based on.

**Initial Run Section (Linux-based Virtual Machines)**

| Field Name | Description |
|-
| **VM Hostname** | The host name of the virtual machine. |
| **Configure Time Zone** | The time zone for the virtual machine. Select this check box and select a time zone from the **Time Zone** list. |
| **Authentication** | The authentication details for the virtual machine. Click the disclosure arrow to display the settings for this option. |
| **Authentication &rarr; User Name** | Creates a new user account on the virtual machine. If this field is not filled in, the default user is `root`. |
| **Authentication &rarr; Use already configured password** | This check box is automatically selected after you specify an initial root password. You must clear this check box to enable the **Password** and **Verify Password** fields and specify a new password. |
| **Authentication &rarr; Password** | The root password for the virtual machine. Enter the password in this text field and the **Verify Password** text field to verify the password. |
| **Authentication &rarr; SSH Authorized Keys** | SSH keys to be added to the authorized keys file of the virtual machine. |
| **Authentication &rarr; Regenerate SSH Keys** | Regenerates SSH keys for the virtual machine. |
| **Networks** | Network-related settings for the virtual machine. Click the disclosure arrow to display the settings for this option. |
| **Networks &rarr; DNS Servers** | The DNS servers to be used by the virtual machine. |
| **Networks &rarr; DNS Search Domains ** | The DNS search domains to be used by the virtual machine. |
| **Networks &rarr; Network** | Configures network interfaces for the virtual machine. Select this check box and click **+** or **-** to add or remove network interfaces to or from the virtual machine. When you click **+**, a set of fields becomes visible that can specify whether to use DHCP, and configure an IP address, netmask, and gateway, and specify whether the network interface will start on boot. |
| **Custom Script** | Custom scripts that will be run on the virtual machine when it starts. The scripts entered in this field are custom YAML sections that are added to those produced by the Engine, and allow you to automate tasks such as creating users and files, configuring `yum` repositories and running commands. For more information on the format of scripts that can be entered in this field, see the [Custom Script](/Features/vm-init-persistent#Custom_Script) documentation. |


**Initial Run Section (Windows-based Virtual Machines)**

| Field Name | Description |
|-
| **VM Hostname** | The host name of the virtual machine. |
| **Domain** | The Active Directory domain to which the virtual machine belongs. |
| **Organization Name** | The name of the organization to which the virtual machine belongs. This option corresponds to the text field for setting the organization name displayed when a machine running Windows is started for the first time. |
| **Active Directory OU** | The organizational unit in the Active Directory domain to which the virtual machine belongs. The distinguished name must be provided. For example `CN=Users,DC=lab,DC=local`  |
| **Configure Time Zone** | The time zone for the virtual machine. Select this check box and select a time zone from the **Time Zone** list. |
| **Admin Password** | The administrative user password for the virtual machine. Click the disclosure arrow to display the settings for this option. |
| **Admin Password &rarr; Use already configured password** | This check box is automatically selected after you specify an initial administrative user password. You must clear this check box to enable the **Admin Password** and **Verify Admin Password** fields and specify a new password. |
| **Admin Password &rarr; Admin Password** | The administrative user password for the virtual machine. Enter the password in this text field and the **Verify Admin Password** text field to verify the password. |
| **Custom Locale** | Locales must be in a format such as `en-US`. Click the disclosure arrow to display the settings for this option. |
| **Custom Locale &rarr; Input Locale** | The locale for user input. |
| **Custom Locale &rarr; UI Language** | The language used for user interface elements such as buttons and menus. |
| **Custom Locale &rarr; System Locale** | The locale for the overall system. |
| **Custom Locale &rarr; User Locale** | The locale for users. |
| **Sysprep** | A custom Sysprep definition. The definition must be in the format of a complete unattended installation answer file. You can copy and paste the default answer files in the `/usr/share/ovirt-engine/conf/sysprep/` directory on the machine on which the oVirt Engine is installed and alter the fields as required. The definition will overwrite any values entered in the `Initial Run` fields. |
| **Domain** | The Active Directory domain to which the virtual machine belongs. If left blank, the value of the previous `Domain` field is used. |
| **Alternate Credentials** | Selecting this check box allows you to set a **User Name** and **Password** as alternative credentials. |

The **System** section enables you to define the supported machine type or CPU type.

**System Section**

| Field Name | Description |
|-
| **Custom Emulated Machine** | This option allows you to specify the machine type. If changed, the virtual machine will only run on hosts that support this machine type. Defaults to the cluster's default machine type. |
| **Custom CPU Type** | This option allows you to specify a CPU type. If changed, the virtual machine will only run on hosts that support this CPU type. Defaults to the cluster's default CPU type. |

The **Host** section is used to define the virtual machine's host.

**Host Section**

| Field Name | Description |
|-
| **Any host in cluster** | Allocates the virtual machine to any available host. |
| **Specific** | Specifies a user-defined host for the virtual machine. |

The **Console** section defines the protocol to connect to virtual machines.

**Console Section**

| Field Name | Description |
|-
| **Headless Mode** | Select this option if you do not require a graphical console when running the machine for the first time. |
| **VNC** | Requires a VNC client to connect to a virtual machine using VNC. Optionally, specify **VNC Keyboard Layout** from the drop-down list. |
| **SPICE** | Recommended protocol for Linux and Windows virtual machines. Using SPICE protocol without QXL drivers is supported for Windows 8 and Server 2012 virtual machines; however, support for multiple monitors and graphics acceleration is not available for this configuration. |
| **Enable SPICE file transfer** | Determines whether you can drag and drop files from an external host into the virtual machine’s SPICE console. This option is only available for virtual machines using the SPICE protocol. This check box is selected by default. |
| **Enable SPICE clipboard copy and paste** | Defines whether you can copy and paste content from an external host into the virtual machine’s SPICE console. This option is only available for virtual machines using the SPICE protocol. This check box is selected by default. |

The **Custom Properties** section contains additional VDSM options for running virtual machines.

**Custom Properties Section**

| Field Name | Description |
|-
| **sndbuf** | Enter the size of the buffer for sending the virtual machine's outgoing data over the socket. |
| **vhost** | Enter the name of the virtual host on which this virtual machine should run. The name can contain any combination of letters and numbers. |
| **viodiskcache** | Caching mode for the virtio disk. **writethrough** writes data to the cache and the disk in parallel, **writeback** does not copy modifications from the cache to the disk, and **none** disables caching. |
| **sap_agent** | Enables SAP monitoring on the virtual machine. Set to **true** or **false**. |

## Explanation of Settings in the New Network Interface and Edit Network Interface windows

These settings apply when you are adding or editing a virtual machine network interface. If you have more than one network interface attached to a virtual machine, you can put the virtual machine on more than one logical network.

**Network Interface Settings**

<table>
<thead>
  <tr>
    <th>Field Name</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><b>Name</b></td>
    <td>The name of the network interface. This text field has a 21-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
    <td><b>Profile</b></td>
    <td>The vNIC profile and logical network that the network interface is placed on. By default, all network interfaces are put on the <b>ovirtmgmt</b> management network.</td>
  </tr>
  <tr>
    <td><b>Type</b></td>
    <td>
      <p>The virtual interface the network interface presents to virtual machines.</p>
      <ul>
        <li><b>rtl8139</b> and <b>e1000</b> device drivers are included in most operating systems.</li>
        <li><b>VirtIO</b> is faster but requires VirtIO drivers. Enterprise Linux 5 and later include VirtIO drivers. Windows does not include VirtIO drivers, but they can be installed from the guest tools ISO or virtual floppy disk.</li>
        <li><b>PCI Passthrough</b> enables the vNIC to be directly connected to a virtual function (VF) of an SR-IOV-enabled NIC. The vNIC will then bypass the software network virtualization and connect directly to the VF for direct device assignment. The selected vNIC profile must also have <b>Passthrough</b> enabled.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td><b>Custom MAC address</b></td>
    <td>Choose this option to set a custom MAC address. The oVirt Engine automatically generates a MAC address that is unique to the environment to identify the network interface. Having two devices with the same MAC address online in the same network causes networking conflicts.</td>
  </tr>
  <tr>
    <td><b>Link State</b></td>
    <td>
      <p>Whether or not the network interface is connected to the logical network.</p>
      <ul>
        <li>
          <p><b>Up</b>: The network interface is located on its slot.</p>
          <ul>
            <li>When the <b>Card Status</b> is <b>Plugged</b>, it means the network interface is connected to a network cable, and is active.</li>
            <li>When the <b>Card Status</b> is <b>Unplugged</b>, the network interface will automatically be connected to the network and become active once plugged.</li>
          </ul>
        </li>
        <li><b>Down:</b> The network interface is located on its slot, but it is not connected to any network. Virtual machines will not be able to run in this state.</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td><b>Card Status</b></td>
    <td>
      <p>Whether or not the network interface is defined on the virtual machine.</p>
      <ul>
        <li>
          <p><tt>Plugged</tt>: The network interface has been defined on the virtual machine.</p>
          <ul>
            <li>If its <b>Link State</b> is <tt>Up</tt>, it means the network interface is connected to a network cable, and is active.</li>
            <li>If its <b>Link State</b> is <tt>Down</tt>, the network interface is not connected to a network cable.</li>
          </ul>
        </li>
        <li>
          <p><tt>Unplugged</tt>: The network interface is only defined on the Manager, and is not associated with a virtual machine.</p>
          <ul>
            <li>If its <b>Link State</b> is <tt>Up</tt>, when the network interface is plugged it will automatically be connected to a network and become active.</li>
            <li>If its <b>Link State</b> is <tt>Down</tt>, the network interface is not connected to any network until it is defined on a virtual machine.</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</tbody>
</table>


## Explanation of Settings in the New Virtual Disk and Edit Virtual Disk windows

**New Virtual Disk and Edit Virtual Disk Settings: Image**

<table class="lt-4-cols lt-7-rows">
<thead>
<tr>
  <th scope="col">Field Name</th>
  <th scope="col">Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td><b>Size(GB)</b></td>
  <td>The size of the new virtual disk in GB.</td>
</tr>
<tr>
  <td><b>Alias</b></td>
  <td>The name of the virtual disk, limited to 40 characters.</td>
</tr>
<tr>
  <td><b>Description</b></td>
  <td>A description of the virtual disk. This field is recommended but not mandatory.</td>
</tr>
<tr>
  <td><b>Interface</b></td>
  <td>
    <p>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Red Hat Enterprise Linux 5 and later include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</p>
    <p>The interface type can be updated after stopping all virtual machines that the disk is attached to.</p>
  </td>
</tr>
<tr>
  <td><b>Data Center</b></td>
  <td>The data center in which the virtual disk will be available.</td>
</tr>
<tr>
  <td><b>Storage Domain</b></td>
  <td>The storage domain in which the virtual disk will be stored. The drop-down list shows all storage domains available in the given data center, and also shows the total space and currently available space in the storage domain.</td>
</tr>
<tr>
  <td><b>Allocation Policy</b></td>
  <td>
    <p>The provisioning policy for the new virtual disk.</p>
    <ul>
      <li><b>Preallocated</b> allocates the entire size of the disk on the storage domain at the time the virtual disk is created. The virtual size and the actual size of a preallocated disk are the same. Preallocated virtual disks take more time to create than thin provisioned virtual disks, but have better read and write performance. Preallocated virtual disks are recommended for servers and other I/O intensive virtual machines. If a virtual machine is able to write more than 1 GB every four seconds, use preallocated disks where possible.</li>
      <li><b>Thin Provision</b> allocates 1 GB at the time the virtual disk is created and sets a maximum limit on the size to which the disk can grow. The virtual size of the disk is the maximum limit; the actual size of the disk is the space that has been allocated so far. Thin provisioned disks are faster to create than preallocated disks and allow for storage over-commitment. Thin provisioned virtual disks are recommended for desktops.</li>
    </ul>
  </td>
</tr>
<tr>
  <td><b>Disk Profile</b></td>
  <td>The disk profile assigned to the virtual disk. Disk profiles define the maximum amount of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Disk profiles are defined on the storage domain level based on storage quality of service entries created for data centers.</td>
</tr>
<tr>
  <td><b>Activate Disk(s)</b></td>
  <td>Activate the virtual disk immediately after creation. This option is not available when creating a floating disk.</td>
</tr>
<tr>
  <td><b>Wipe After Delete</b></td>
  <td>Allows you to enable enhanced security for deletion of sensitive material when the virtual disk is deleted.</td>
</tr>
<tr>
  <td><b>Bootable</b></td>
  <td>Allows you to enable the bootable flag on the virtual disk.</td>
</tr>
<tr>
  <td><b>Shareable</b></td>
  <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
</tr>
<tr>
  <td><b>Read Only</b></td>
  <td>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another. This option is not available when creating a floating disk.</td>
</tr>
<tr>
  <td><b>Enable Discard</b></td>
  <td>Allows you to shrink a thin provisioned disk while the virtual machine is up. For block storage, the underlying storage device must support discard calls, and the option cannot be used with <b>Wipe After Delete</b> unless the underlying storage supports the discard_zeroes_data property. For file storage, the underlying file system and the block device must support discard calls. If all requirements are met, SCSI UNMAP commands issued from guest virtual machines is passed on by QEMU to the underlying storage to free up the unused space.</td>
</tr>
</tbody>
</table>

The **Direct LUN** settings can be displayed in either **Targets > LUNs** or **LUNs > Targets**. **Targets > LUNs** sorts available LUNs according to the host on which they are discovered, whereas **LUNs > Targets** displays a single list of LUNs.

**New Virtual Disk and Edit Virtual Disk Settings: Direct LUN**

<table class="lt-4-cols lt-7-rows">
<thead>
<tr>
  <th scope="col">Field Name</th>
  <th scope="col">Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td><b>Alias</b></td>
  <td>The name of the virtual disk, limited to 40 characters.</td>
</tr>
<tr>
  <td><b>Description</b></td>
  <td>
    <p>A description of the virtual disk. This field is recommended but not mandatory. By default the last 4 characters of the LUN ID is inserted into the field.</p>
    <p>The default behavior can be configured by setting the <code class="literal">PopulateDirectLUNDiskDescriptionWithLUNId</code> configuration key to the appropriate value using the <code class="literal">engine-config</code> command. The configuration key can be set to <code class="literal">-1</code> for the full LUN ID to be used, or <code class="literal">0</code> for this feature to be ignored. A positive integer populates the description with the corresponding number of characters of the LUN ID.</p>
  </td>
</tr>
<tr>
  <td><b>Interface</b></td>
  <td>
    <p>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Red Hat Enterprise Linux 5 and later include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</p>
    <p>The interface type can be updated after stopping all virtual machines that the disk is attached to.</p>
  </td>
</tr>
<tr>
  <td><b>Data Center</b></td>
  <td>The data center in which the virtual disk will be available.</td>
</tr>
<tr>
  <td><b>Use Host</b></td>
  <td>The host on which the LUN will be mounted. You can select any host in the data center.</td>
</tr>
<tr>
  <td><b>Storage Type</b></td>
  <td>The type of external LUN to add. You can select from either <b>iSCSI</b> or <b>Fibre Channel</b>.</td>
</tr>
<tr>
  <td><b>Discover Targets</b></td>
  <td>
    <p>This section can be expanded when you are using iSCSI external LUNs and <b>Targets &gt; LUNs</b> is selected.</p>
    <p><b>Address</b> - The host name or IP address of the target server.</p>
    <p><b>Port</b> - The port by which to attempt a connection to the target server. The default port is 3260.</p>
    <p><b>User Authentication</b> - The iSCSI server requires User Authentication. The <b>User Authentication</b> field is visible when you are using iSCSI external LUNs.</p>
    <p><b>CHAP user name</b> - The user name of a user with permission to log in to LUNs. This field is accessible when the <b>User Authentication</b> check box is selected.</p>
    <p><b>CHAP password</b> - The password of a user with permission to log in to LUNs. This field is accessible when the <b>User Authentication</b> check box is selected.</p>
  </td>
</tr>
<tr>
  <td><b>Activate Disk(s)</b></td>
  <td>Activate the virtual disk immediately after creation. This option is not available when creating a floating disk.</td>
</tr>
<tr>
  <td><b>Bootable</b></td>
  <td>Allows you to enable the bootable flag on the virtual disk.</td>
</tr>
<tr>
  <td><b>Shareable</b></td>
  <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
</tr>
<tr>
  <td><b>Read Only</b></td>
  <td>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another. This option is not available when creating a floating disk.</td>
</tr>
<tr>
  <td><b>Enable Discard</b></td>
  <td>Allows you to shrink a thin provisioned disk while the virtual machine is up. With this option enabled, SCSI UNMAP commands issued from guest virtual machines is passed on by QEMU to the underlying storage to free up the unused space.</td>
</tr>
<tr>
  <td><b>Enable SCSI Pass-Through</b></td>
  <td>
    <p>Available when the <b>Interface</b> is set to <b>VirtIO-SCSI</b>. Selecting this check box enables passthrough of a physical SCSI device to the virtual disk. A VirtIO-SCSI interface with SCSI passthrough enabled automatically includes SCSI discard support. <b>Read Only</b> is not supported when this check box is selected.</p>
    <p>When this check box is not selected, the virtual disk uses an emulated SCSI device. <b>Read Only</b> is supported on emulated VirtIO-SCSI disks.</p>
  </td>
</tr>
<tr>
  <td><b>Allow Privileged SCSI I/O</b></td>
  <td>Available when the <b>Enable SCSI Pass-Through</b> check box is selected. Selecting this check box enables unfiltered SCSI Generic I/O (SG_IO) access, allowing privileged SG_IO commands on the disk. This is required for persistent reservations.</td>
</tr>
<tr>
  <td><b>Using SCSI Reservation</b></td>
  <td>Available when the <b>Enable SCSI Pass-Through</b> and <b>Allow Privileged SCSI I/O</b> check boxes are selected. Selecting this check box disables migration for any virtual machine using this disk, to prevent virtual machines that are using SCSI reservation from losing access to the disk.</td>
</tr>
</tbody>
</table>

Fill in the fields in the **Discover Targets** section and click **Discover** to discover the target server. You can then click the **Login All** button to list the available LUNs on the target server and, using the radio buttons next to each LUN, select the LUN to add.

Using LUNs directly as virtual machine hard disk images removes a layer of abstraction between your virtual machines and their data.

The following considerations must be made when using a direct LUN as a virtual machine hard disk image:

* Live storage migration of direct LUN hard disk images is not supported.

* Direct LUN disks are not included in virtual machine exports.

* Direct LUN disks are not included in virtual machine snapshots.

The **Cinder** settings form will be disabled if there are no available OpenStack Volume storage domains on which you have permissions to create a disk in the relevant Data Center. **Cinder** disks require access to an instance of OpenStack Volume that has been added to the oVirt environment using the **External Providers** window.

**New Virtual Disk and Edit Virtual Disk Settings: Cinder**

<table class="lt-4-cols lt-7-rows">
<thead>
<tr>
  <th scope="col">Field Name</th>
  <th scope="col">Description</th>
</tr>
</thead>
<tbody>
<tr>
  <td><b>Size(GB)</b></td>
  <td>The size of the new virtual disk in GB.</td>
</tr>
<tr>
  <td><b>Alias</b></td>
  <td>The name of the virtual disk, limited to 40 characters.</td>
</tr>
<tr>
  <td><b>Description</b></td>
  <td>A description of the virtual disk. This field is recommended but not mandatory.</td>
</tr>
<tr>
  <td><b>Interface</b></td>
  <td>
    <p>The virtual interface the disk presents to virtual machines. <b>VirtIO</b> is faster, but requires drivers. Red Hat Enterprise Linux 5 and later include these drivers. Windows does not include these drivers, but they can be installed from the guest tools ISO or virtual floppy disk. <b>IDE</b> devices do not require special drivers.</p>
    <p>The interface type can be updated after stopping all virtual machines that the disk is attached to.</p>
  </td>
</tr>
<tr>
  <td><b>Data Center</b></td>
  <td>The data center in which the virtual disk will be available.</td>
</tr>
<tr>
  <td><b>Storage Domain</b></td>
  <td>The storage domain in which the virtual disk will be stored. The drop-down list shows all storage domains available in the given data center, and also shows the total space and currently available space in the storage domain.</td>
</tr>
<tr>
  <td><b>Volume Type</b></td>
  <td>The volume type of the virtual disk. The drop-down list shows all available volume types. The volume type will be managed and configured on OpenStack Cinder.</td>
</tr>
<tr>
  <td><b>Activate Disk(s)</b></td>
  <td>Activate the virtual disk immediately after creation. This option is not available when creating a floating disk.</td>
</tr>
<tr>
  <td><b>Bootable</b></td>
  <td>Allows you to enable the bootable flag on the virtual disk.</td>
</tr>
<tr>
  <td><b>Shareable</b></td>
  <td>Allows you to attach the virtual disk to more than one virtual machine at a time.</td>
</tr>
<tr>
  <td><b>Read Only</b></td>
  <td>Allows you to set the disk as read-only. The same disk can be attached as read-only to one virtual machine, and as rewritable to another. This option is not available when creating a floating disk.</td>
</tr>
</tbody>
</table>

**Important:** Mounting a journaled file system requires read-write access. Using the **Read Only** option is not appropriate for virtual disks that contain such file systems (e.g. **EXT3**, **EXT4**, or **XFS**).


## Explanation of Settings in the New Template Windows

The following table details the settings for the **New Template** window.

**New Template Settings**

<table class="lt-4-cols lt-7-rows">
<thead>
<tr>
  <th>Field</th>
  <th>Description/Action</th>
</tr>
</thead>
<tbody>
<tr>
  <td><b>Name</b></td>
  <td>The name of the template. This is the name by which the template is listed in the <b>Templates</b> tab in the Administration Portal and is accessed via the REST API. This text field has a 40-character limit and must be a unique name within the data center with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores. The name can be reused in different data centers in the environment.</td>
</tr>
<tr>
  <td><b>Description</b></td>
  <td>A description of the template. This field is recommended but not mandatory.</td>
</tr>
<tr>
  <td><b>Comment</b></td>
  <td>A field for adding plain text, human-readable comments regarding the template.</td>
</tr>
<tr>
  <td><b>Cluster</b></td>
  <td>The cluster with which the template is associated. This is the same as the original virtual machines by default. You can select any cluster in the data center.</td>
</tr>
<tr>
  <td><b>CPU Profile</b></td>
  <td>The CPU profile assigned to the template. CPU profiles define the maximum amount of processing capability a virtual machine can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. CPU profiles are defined on the cluster level based on quality of service entries created for data centers.</td>
</tr>
<tr>
  <td><b>Create as a Template Sub-Version</b></td>
  <td>
    <p>Specifies whether the template is created as a new version of an existing template. Select this check box to access the settings for configuring this option.</p>
    <ul>
      <li><b>Root Template</b>: The template under which the sub-template is added.</li>
      <li><b>Sub-Version Name</b>: The name of the template. This is the name by which the template is accessed when creating a new virtual machine based on the template. If the virtual machine is stateless, the list of sub-versions will contain a <b>latest</b> option rather than the name of the latest sub-version. This option automatically applies the latest template sub-version to the virtual machine upon reboot. Sub-versions are particularly useful when working with pools of stateless virtual machines.</li>
    </ul>
  </td>
</tr>
<tr>
  <td><b>Disks Allocation</b></td>
  <td>
    <p><b>Alias</b> - An alias for the virtual disk used by the template. By default, the alias is set to the same value as that of the source virtual machine.</p>
    <p><b>Virtual Size</b> - The total amount of disk space that a virtual machine based on the template can use. This value cannot be edited, and is provided for reference only. This value corresponds with the size, in GB, that was specified when the disk was created or edited.</p>
    <p><b>Format</b> - The format of the virtual disk used by the template. The available options are QCOW2 and Raw. By default, the format is set to Raw.</p>
    <p><b>Target</b> - The storage domain on which the virtual disk used by the template is stored. By default, the storage domain is set to the same value as that of the source virtual machine. You can select any storage domain in the cluster.</p>
    <p><b>Disk Profile</b> - The disk profile to assign to the virtual disk used by the template. Disk profiles are created based on storage profiles defined in the data centers.</p>
  </td>
</tr>
<tr>
  <td><b>Allow all users to access this Template</b></td>
  <td>Specifies whether a template is public or private. A public template can be accessed by all users, whereas a private template can only be accessed by users with the <b>TemplateAdmin</b> or <b>SuperUser</b> roles.</td>
</tr>
<tr>
  <td><b>Copy VM permissions</b></td>
  <td>Copies explicit permissions that have been set on the source virtual machine to the template.</td>
</tr>
<tr>
  <td><b>Seal Template</b> (Linux only)</td>
  <td>Specifies whether a template is sealed. 'Sealing' is an operation that erases all machine-specific configurations from a filesystem, including SSH keys, UDEV rules, MAC addresses, system ID, and hostname. This setting prevents a virtual machine based on this template from inheriting the configuration of the source virtual machine.</td>
</tr>
</tbody>
</table>

**Prev:** [Chapter 7: Templates](chap-Templates)
**Next:** [Appendix B: virt-sysprep Operations](appe-virt-sysprep_Operations)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/appe-reference_settings_in_administration_portal_and_user_portal_windows)
