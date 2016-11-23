# Explanation of Settings in the Run Once Window

The **Run Once** window defines one-off boot options for a virtual machine. For persistent boot options, use the **Boot Options** tab in the **New Virtual Machine** window. The **Run Once** window contains multiple sections that can be configured.

The **Boot Options** section defines the virtual machine's boot sequence, running options, and source images for installing the operating system and required drivers.

**Boot Options Section**

| Field Name | Description |
|-
| **Attach Floppy** | Attaches a diskette image to the virtual machine. Use this option to install Windows drivers. The diskette image must reside in the ISO domain. |
| **Attach CD** | Attaches an ISO image to the virtual machine. Use this option to install the virtual machine's operating system and applications. The CD image must reside in the ISO domain. |
| **Boot Sequence** | Determines the order in which the boot devices are used to boot the virtual machine. Select either **Hard Disk**, **CD-ROM** or **Network**, and use **Up** and **Down** to move the option up or down in the list. |
| **Run Stateless** | Deletes all changes to the virtual machine upon shutdown. This option is only available if a virtual disk is attached to the virtual machine. |
| **Start in Pause Mode** | Starts then pauses the virtual machine to enable connection to the console, suitable for virtual machines in remote locations. |

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
| **Authentication > User Name** | Creates a new user account on the virtual machine. If this field is not filled in, the default user is `root`. |
| **Authentication > Use already configured password** | This check box is automatically selected after you specify an initial root password. You must clear this check box to enable the **Password** and **Verify Password** fields and specify a new password. |
| **Authentication > Password** | The root password for the virtual machine. Enter the password in this text field and the **Verify Password** text field to verify the password. |
| **Authentication > SSH Authorized Keys** | SSH keys to be added to the authorized keys file of the virtual machine. |
| **Authentication > Regenerate SSH Keys** | Regenerates SSH keys for the virtual machine. |
| **Networks** | Network-related settings for the virtual machine. Click the disclosure arrow to display the settings for this option. |
| **Networks > DNS Servers** | The DNS servers to be used by the virtual machine. |
| **Networks > DNS Search Domains ** | The DNS search domains to be used by the virtual machine. |
| **Networks > Network** | Configures network interfaces for the virtual machine. Select this check box and click **+** or **-** to add or remove network interfaces to or from the virtual machine. When you click **+**, a set of fields becomes visible that can specify whether to use DHCP, and configure an IP address, netmask, and gateway, and specify whether the network interface will start on boot. |
| **Custom Script** | Custom scripts that will be run on the virtual machine when it starts. The scripts entered in this field are custom YAML sections that are added to those produced by the Manager, and allow you to automate tasks such as creating users and files, configuring `yum` repositories and running commands. For more information on the format of scripts that can be entered in this field, see the [Custom Script](http://www.ovirt.org/Features/vm-init-persistent#Custom_Script) documentation. |
 

**Initial Run Section (Windows-based Virtual Machines)**

| Field Name | Description |
|-
| **VM Hostname** | The host name of the virtual machine. |
| **Domain** | The Active Directory domain to which the virtual machine belongs. |
| **Organization Name** | The name of the organization to which the virtual machine belongs. This option corresponds to the text field for setting the organization name displayed when a machine running Windows is started for the first time. |
| **Active Directory OU** | The organizational unit in the Active Directory domain to which the virtual machine belongs. The distinguished name must be provided. For example `CN=Users,DC=lab,DC=local`  |
| **Configure Time Zone** | The time zone for the virtual machine. Select this check box and select a time zone from the **Time Zone** list. |
| **Admin Password** | The administrative user password for the virtual machine. Click the disclosure arrow to display the settings for this option. |
| **Admin Password > Use already configured password** | This check box is automatically selected after you specify an initial administrative user password. You must clear this check box to enable the **Admin Password** and **Verify Admin Password** fields and specify a new password. |
| **Admin Password > Admin Password** | The administrative user password for the virtual machine. Enter the password in this text field and the **Verify Admin Password** text field to verify the password. |
| **Custom Locale** | Locales must be in a format such as `en-US`. Click the disclosure arrow to display the settings for this option. |
| **Custom Locale > Input Locale** | The locale for user input. |
| **Custom Locale > UI Language** | The language used for user interface elements such as buttons and menus. |
| **Custom Locale > System Locale** | The locale for the overall system. |
| **Custom Locale > User Locale** | The locale for users. |
| **Sysprep** | A custom Sysprep definition. The definition must be in the format of a complete unattended installation answer file. You can copy and paste the default answer files in the `/usr/share/ovirt-engine/conf/sysprep/` directory on the machine on which the Red Hat Virtualization Manager is installed and alter the fields as required. The definition will overwrite any values entered in the `Initial Run` fields. |
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
| **VNC** | Requires a VNC client to connect to a virtual machine using VNC. Optionally, specify **VNC Keyboard Layout** from the drop-down list. |
| **SPICE** | Recommended protocol for Linux and Windows virtual machines. Using SPICE protocol without QXL drivers is supported for Windows 8 and Server 2012 virtual machines; however, support for multiple monitors and graphics acceleration is not available for this configuration. |

The **Custom Properties** section contains additional VDSM options for running virtual machines.

**Custom Properties Section**

| Field Name | Description |
|-
| **sap_agent** | Enables SAP monitoring on the virtual machine. Set to **true** or **false**. |
| **sndbuf** | Enter the size of the buffer for sending the virtual machine's outgoing data over the socket. |
| **vhost** | Enter the name of the virtual host on which this virtual machine should run. The name can contain any combination of letters and numbers. |
| **viodiskcache** | Caching mode for the virtio disk. **writethrough** writes data to the cache and the disk in parallel, **writeback** does not copy modifications from the cache to the disk, and **none** disables caching. See [https://access.redhat.com/solutions/2361311](https://access.redhat.com/solutions/2361311) for more information about the limitations of the `viodiskcache` custom property. |
