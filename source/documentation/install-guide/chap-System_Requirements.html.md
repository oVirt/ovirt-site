---
title: System Requirements
---

# Chapter 2: System Requirements

## oVirt Engine Requirements

### Hardware Requirements

The minimum and recommended hardware requirements outlined here are based on a typical small to medium sized installation. The exact requirements vary between deployments based on sizing and load.

The oVirt Engine runs on Enterprise Linux operating systems like CentOS and Enterprise Linux.

**oVirt Engine Hardware Requirements**

<table>
 <thead>
  <tr>
   <td>Resource</td>
   <td>Minimum</td>
   <td>Recommended</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>CPU</td>
   <td>A dual core CPU.</td>
   <td>A quad core CPU or multiple dual core CPUs.</td>
  </tr>
  <tr>
   <td>Memory</td>
   <td>4 GB of available system RAM if Data Warehouse is not installed and if memory is not being consumed by existing processes.</td>
   <td>16 GB of system RAM.</td>
  </tr>
  <tr>
   <td>Hard Disk</td>
   <td>25 GB of locally accessible, writable, disk space.</td>
   <td>
    <p>50 GB of locally accessible, writable, disk space.</p>
   </td>
  </tr>
  <tr>
   <td>Network Interface</td>
   <td>1 Network Interface Card (NIC) with bandwidth of at least 1 Gbps.</td>
   <td>1 Network Interface Card (NIC) with bandwidth of at least 1 Gbps.</td>
  </tr>
 </tbody>
</table>

### Browser Requirements

The following browser versions and operating systems can be used to access the Administration Portal and the User Portal.

Browser support is divided into tiers:

* Tier 1: Browser and operating system combinations that are fully tested.

* Tier 2: Browser and operating system combinations that are partially tested, and are likely to work.

* Tier 3: Browser and operating system combinations that are not tested, but may work.

**Browser Requirements**

| Support Tier | Operating System Family | Browser | Portal Access |
|-
| Tier 1 | Enterprise Linux | Mozilla Firefox Extended Support Release (ESR) version | Administration Portal and User Portal |
| Tier 2 | Windows | Internet Explorer 10 or later | Administration Portal and User Portal |
|        | Any | Most recent version of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
| Tier 3 | Any | Earlier versions of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
|        | Any | Other browsers | Administration Portal and User Portal |


### Client Requirements

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Enterprise Linux and Windows. To install `virt-viewer`, see [Installing Supported Components](/documentation/vmm-guide/chap-Introduction/#installing-supporting-components) in the *Virtual Machine Management Guide*. Installing `virt-viewer` requires Administrator privileges.

SPICE console access is only available on other operating systems, such as OS X, through the unsupported SPICE HTML5 browser client.

Supported QXL drivers are available on Enterprise Linux, Windows XP, and Windows 7.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which remote-viewer has been fully tested.

* Tier 2: Operating systems on which remote-viewer is partially tested and is likely to work.  

**Client Operating System SPICE Support**

| Support Tier | Operating System | SPICE Support |
|-
| Tier 1 | Enterprise Linux 7 | Fully supported on Enterprise Linux 7.2 and above |
|        | Microsoft Windows 7 | Fully supported on Microsoft Windows 7 |
| Tier 2 | Microsoft Windows 8 | Supported when spice-vdagent is running on these guest operating systems |
|        | Microsoft Windows 10 | Supported when spice-vdagent is running on these guest operating systems |

### Operating System Requirements

The oVirt Engine must be installed on a base installation of Enterprise Linux (CentOS or RHEL) 7. Do not install any additional packages after the base installation because they may cause dependency issues when attempting to install the packages required by the Engine.

## Hypervisor Requirements

### CPU Requirements

All CPUs must have support for the Intel® 64 or AMD64 CPU extensions, and the AMD-V™ or Intel VT® hardware virtualization extensions enabled. Support for the No eXecute flag (NX) is also required.

**Supported Hypervisor CPU Models**

| AMD | Intel | IBM |
|-
| AMD Opteron G1 | Intel Conroe      | IBM POWER8 |
| AMD Opteron G2 | Intel Penryn      | |
| AMD Opteron G3 | Intel Nehalem     | |
| AMD Opteron G4 | Intel Westmere    | |
| AMD Opteron G5 | Intel Sandybridge | |
|                | Intel Haswell     | |

**Checking if a Processor Supports the Required Flags**

You must enable Virtualization in the BIOS. Power off and reboot the host after this change to ensure that the change is applied.

1. At the Enterprise Linux or oVirt Node boot screen, press any key and select the **Boot** or **Boot with serial console** entry from the list.

2. Press **Tab** to edit the kernel parameters for the selected option.

3. Ensure there is a **Space** after the last kernel parameter listed, and append the `rescue` parameter.

4. **Enter** to boot into rescue mode.

5. At the prompt which appears, determine that your processor has the required extensions and that they are enabled by running this command:

        # grep -E 'svm|vmx' /proc/cpuinfo | grep nx

    If any output is shown, then the processor is hardware virtualization capable. If no output is shown, then it is still possible that your processor supports hardware virtualization. In some circumstances manufacturers disable the virtualization extensions in the BIOS. If you believe this to be the case, consult the system's BIOS and the motherboard manual provided by the manufacturer.

### Memory Requirements

The amount of RAM required varies depending on guest operating system requirements, guest application requirements, and memory activity and usage of guests. You also need to take into account that KVM is able to overcommit physical RAM for virtualized guests. This allows for provisioning of guests with RAM requirements greater than what is physically present, on the basis that the guests are not all concurrently at peak load. KVM does this by only allocating RAM for guests as required and shifting underutilized guests into swap.

**Memory Requirements**

| Minimum     | Maximum     |
| 2 GB of RAM | 2 TB of RAM |

### Storage Requirements

Hosts require local storage to store configuration, logs, kernel dumps, and for use as swap space. The minimum storage requirements of oVirt Node are documented in this section. The storage requirements for Enterprise Linux hosts vary based on the amount of disk space used by their existing configuration but are expected to be greater than those of oVirt Node.

**oVirt Node Minimum Storage Requirements**

| /    | /boot | /var  | swap | Minimum Total |
|-
| 6 GB | 1 GB  | 15 GB | 1 GB | 23 GB |

**Important:** If you are also installing the oVirt Engine Virtual Appliance for self-hosted engine installation, the /var partition must be at least 60 GB.

### PCI Device Requirements

Hosts must have at least one network interface with a minimum bandwidth of 1 Gbps. It is recommended that each host have two network interfaces with one dedicated to support network intensive activities such as virtual machine migration. The performance of such operations are limited by the bandwidth available.

### Hardware Considerations For Device Assignment

If you plan to implement device assignment and PCI passthrough so that a virtual machine can use a specific PCIe device from a host, ensure the following requirements are met:

* CPU must support IOMMU (for example, VT-d or AMD-Vi). IBM POWER8 supports IOMMU by default.

* Firmware must support IOMMU.

* CPU root ports used must support ACS or ACS-equivalent capability.

* PCIe device must support ACS or ACS-equivalent capability.

* It is recommended that all PCIe switches and bridges between the PCIe device and the root port should support ACS. For example, if a switch does not support ACS, all devices behind that switch share the same IOMMU group, and can only be assigned to the same virtual machine.

* For GPU support, Enterprise Linux 7 supports PCI device assignment of NVIDIA K-Series Quadro (model 2000 series or higher), GRID, and Tesla as non-VGA graphics devices. Currently up to two GPUs may be attached to a virtual machine in addition to one of the standard, emulated VGA interfaces. The emulated VGA is used for pre-boot and installation and the NVIDIA GPU takes over when the NVIDIA graphics drivers are loaded. Note that the NVIDIA Quadro 2000 is not supported, nor is the Quadro K420 card.

Refer to vendor specification and datasheets to confirm that hardware meets these requirements. After you have installed a host, see [Configuring a Hypervisor Host for PCI Passthrough](../appe-Configuring_a_Hypervisor_Host_for_PCI_Passthrough) for more information on how to enable the host hardware and software for device passthrough.

The `lspci -v` command can be used to print information for PCI devices already installed on a system.

## Firewalls

### oVirt Engine Firewall Requirements

The oVirt Engine requires that a number of ports be opened to allow network traffic through the system's firewall. The `engine-setup` script can configure the firewall automatically, but this overwrites any pre-existing firewall configuration.

Where an existing firewall configuration exists, you must manually insert the firewall rules required by the Engine instead. The `engine-setup` command saves a list of the `iptables` rules required in the `/usr/share/ovirt-engine/conf/iptables.example` file.

The firewall configuration documented here assumes a default configuration. Where non-default HTTP and HTTPS ports are chosen during installation, adjust the firewall rules to allow network traffic on the ports that were selected - not the default ports (`80` and `443`) listed here.

**oVirt Engine Firewall Requirements**

<table>
 <thead>
  <tr>
   <td>Port(s)</td>
   <td>Protocol</td>
   <td>Source</td>
   <td>Destination</td>
   <td>Purpose</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>-</td>
   <td>ICMP</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>oVirt Engine</td>
   <td>When registering to the oVirt Engine, virtualization hosts send an ICMP ping request to the Engine to confirm that it is online.</td>
  </tr>
  <tr>
   <td>22</td>
   <td>TCP</td>
   <td>System(s) used for maintenance of the Engine including backend configuration, and software upgrades.</td>
   <td>oVirt Engine</td>
   <td>
    <p>Secure Shell (SSH) access.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>2222</td>
   <td>TCP</td>
   <td>Clients accessing virtual machine serial consoles.</td>
   <td>oVirt Engine</td>
   <td>Secure Shell (SSH) access to enable connection to virtual machine serial consoles.</td>
  </tr>
  <tr>
   <td>80, 443</td>
   <td>TCP</td>
   <td>
    <p>Administration Portal clients</p>
    <p>User Portal clients</p>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
    <p>REST API clients</p>
   </td>
   <td>oVirt Engine</td>
   <td>Provides HTTP and HTTPS access to the Engine.</td>
  </tr>
  <tr>
   <td>6100</td>
   <td>TCP</td>
   <td>
    <p>Administration Portal clients</p>
    <p>User Portal clients</p>
   </td>
   <td>oVirt Engine</td>
   <td>Provides websocket proxy access for web-based console clients (`noVNC` and `spice-html5`) when the websocket proxy is running on the Engine. If the websocket proxy is running on a different host, however, this port is not used.</td>
  </tr>
  <tr>
   <td>7410</td>
   <td>UDP</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>oVirt Engine</td>
   <td>Must be open for the Engine to receive Kdump notifications.</td>
  </tr>
 </tbody>
</table>

**Important:** In environments where the oVirt Engine is also required to export NFS storage, such as an ISO Storage Domain, additional ports must be allowed through the firewall. Grant firewall exceptions for the ports applicable to the version of NFS in use:

**NFSv4**

* TCP port `2049` for NFS.

**NFSv3**

* TCP and UDP port `2049` for NFS.
* TCP and UDP port `111` (`rpcbind`/`sunrpc`).
* TCP and UDP port specified with `MOUNTD_PORT="port"`
* TCP and UDP port specified with `STATD_PORT="port"`
* TCP port specified with `LOCKD_TCPPORT="port"`
* UDP port specified with `LOCKD_UDPPORT="port"`

The `MOUNTD_PORT`, `STATD_PORT`, `LOCKD_TCPPORT`, and `LOCKD_UDPPORT` ports are configured in the `/etc/sysconfig/nfs` file.

# Hypervisor Firewall Requirements

Enterprise Linux hosts and oVirt Nodes require a number of ports to be opened to allow network traffic through the system's firewall. In the case of the oVirt Node these firewall rules are configured automatically. For Enterprise Linux hosts however it is necessary to manually configure the firewall.

**Virtualization Host Firewall Requirements**

<table>
 <thead>
  <tr>
   <td>Port(s)</td>
   <td>Protocol</td>
   <td>Source</td>
   <td>Destination</td>
   <td>Purpose</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>22</td>
   <td>TCP</td>
   <td>oVirt Engine</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Secure Shell (SSH) access.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>2223</td>
   <td>TCP</td>
   <td>oVirt Engine</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>Secure Shell (SSH) access to enable connection to virtual machine serial consoles.</td>
  </tr>
  <tr>
   <td>161</td>
   <td>UDP</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>oVirt Engine</td>
   <td>
    <p>Simple network management protocol (SNMP). Only required if you want Simple Network Management Protocol traps sent from the host to one or more external SNMP managers.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>5900 - 6923</td>
   <td>TCP</td>
   <td>
    <p>Administration Portal clients</p>
    <p>User Portal clients</p>
   </td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>Remote guest console access via VNC and SPICE. These ports must be open to facilitate client access to virtual machines.</td>
  </tr>
  <tr>
   <td>5989</td>
   <td>TCP, UDP</td>
   <td>Common Information Model Object Manager (CIMOM)</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Used by Common Information Model Object Managers (CIMOM) to monitor virtual machines running on the host. Only required if you want to use a CIMOM to monitor the virtual machines in your virtualization environment.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>9090</td>
   <td>TCP</td>
   <td>
    <p>oVirt Engine</p>
    <p>Client machines</p>
   </td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Cockpit user interface access.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>16514</td>
   <td>TCP</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>Virtual machine migration using <tt>libvirt</tt>.</td>
  </tr>
  <tr>
   <td>49152 - 49216</td>
   <td>TCP</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>Virtual machine migration and fencing using VDSM. These ports must be open facilitate both automated and manually initiated migration of virtual machines.</td>
  </tr>
  <tr>
   <td>54321</td>
   <td>TCP</td>
   <td>
    <p>oVirt Engine</p>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>VDSM communications with the Engine and other virtualization hosts.</td>
  </tr>
 </tbody>
</table>

### Directory Server Firewall Requirements

oVirt requires a directory server to support user authentication. A number of ports must be opened in the directory server's firewall to support GSS-API authentication as used by the oVirt Engine.

**Host Firewall Requirements**

| Port(s)  | Protocol | Source | Destination | Purpose |
|-
| 88, 464  | TCP, UDP | oVirt Engine | Directory server | Kerberos authentication. |
| 389, 636 | TCP      | oVirt Engine | Directory server | Lightweight Directory Access Protocol (LDAP) and LDAP over SSL. |

### Database Server Firewall Requirements

oVirt supports the use of a remote database server. If you plan to use a remote database server with oVirt then you must ensure that the remote database server allows connections from the Engine.

**Host Firewall Requirements**

| Port(s) | Protocol | Source | Destination | Purpose |
|-
| 5432    | TCP, UDP | oVirt Engine | PostgreSQL database server | Default port for PostgreSQL database connections. |

If you plan to use a local database server on the Engine itself, which is the default option provided during installation, then no additional firewall rules are required.

**Prev:** [Chapter 1: Introduction to oVirt](../chap-Introduction_to_oVirt)<br>
**Next:** [Chapter 3: Installing oVirt](../chap-Installing_oVirt)
