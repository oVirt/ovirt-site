---
title: System Requirements
---

# Chapter 2: System Requirements

## oVirt Engine Requirements

### Hardware Requirements

The minimum and recommended hardware requirements outlined here are based on a typical small to medium sized installation. The exact requirements vary between deployments based on sizing and load.

The oVirt Engine runs on Enterprise Linux operating systems like [CentOS Linux](https://www.centos.org/), [Scientific Linux](https://www.scientificlinux.org/), and [Red Hat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux).

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

oVirt follows the [Red Hat Customer Portal Browser Support Policy](https://access.redhat.com/help/browsers/).

We recommend to use one of the recent versions of the following "evergreen" browsers:

-   Mozilla Firefox
-   Google Chrome
-   Apple Safari
-   Microsoft Internet Explorer 11
-   Microsoft Edge

These are known as "evergreen" browsers because they automatically update themselves to the most recent available version.

### Client Requirements

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Enterprise Linux and Windows. To install `virt-viewer`, see [Installing Supported Components](/documentation/vmm-guide/chap-Introduction/#installing-supporting-components) in the *Virtual Machine Management Guide*. Installing `virt-viewer` requires Administrator privileges.

Virtual machine consoles are accessed through the SPICE protocol. The QXL graphical driver can be installed in the guest operating system for improved/enhanced SPICE functionalities. SPICE currently supports a maximum resolution of 2560x1600 pixels.

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

The oVirt Engine must be installed on a base installation of Enterprise Linux (CentOS or RHEL) 7 that has been updated to the latest minor release.

Do not install any additional packages after the base installation because they may cause dependency issues when attempting to install the packages required by the Engine.

## Hypervisor Requirements

### CPU Requirements

All CPUs must have support for the Intel® 64 or AMD64 CPU extensions, and the AMD-V™ or Intel VT® hardware virtualization extensions enabled. Support for the No eXecute flag (NX) is also required.

The following CPU models are supported:

* AMD
  * Opteron G4
  * Opteron G5
  * EPYC

* Intel
  * Nehalem
  * Westmere
  * Sandybridge
  * Haswell
  * Haswell-noTSX
  * Broadwell
  * Broadwell-noTSX
  * Skylake (client)
  * Skylake (server)

* IBM 
  * POWER8
  * POWER9
  * z114,z196
  * zBC12,zEC12
  * z13s, z13

**Checking if a Processor Supports the Required Flags**

You must enable virtualization in the BIOS. Power off and reboot the host after this change to ensure that the change is applied.

1. At the Enterprise Linux or oVirt Node boot screen, press any key and select the **Boot** or **Boot with serial console** entry from the list.

2. Press **Tab** to edit the kernel parameters for the selected option.

3. Ensure there is a space after the last kernel parameter listed, and append the parameter **rescue**.

4. Press **Enter** to boot into rescue mode.

5. At the prompt, determine that your processor has the required extensions and that they are enabled by running this command:

        # grep -E 'svm|vmx' /proc/cpuinfo | grep nx

If any output is shown, then the processor is hardware virtualization capable. If no output is shown, your processor may still support hardware virtualization; in some circumstances manufacturers disable the virtualization extensions in the BIOS. If you believe this to be the case, consult the system's BIOS and the motherboard manual provided by the manufacturer.

### Memory Requirements

The minimum required RAM is 2 GB. The maximum supported RAM is 2 TB.

However, the amount of RAM required varies depending on guest operating system requirements, guest application requirements, and guest memory activity and usage. KVM can also overcommit physical RAM for virtualized guests, allowing you to provision guests with RAM requirements greater than what is physically present, on the assumption that the guests are not all working concurrently at peak load. KVM does this by only allocating RAM for guests as required and shifting underutilized guests into swap.

### Storage Requirements

Hosts require local storage to store configuration, logs, kernel dumps, and for use as swap space. The minimum storage requirements of oVirt Node are documented in this section. The storage requirements for Enterprise Linux hosts vary based on the amount of disk space used by their existing configuration but are expected to be greater than those of oVirt Node.

These are the minimum storage requirements for host installation. We recommend using the default allocations, which use more storage space.

* / (root) - 6 GB

* /home - 1 GB

* /tmp - 1 GB

* /boot - 1 GB

* /var - 15 GB

* /var/log - 8 GB

* /var/log/audit - 2 GB

* swap - 1 GB

* Anaconda reserves 20% of the thin pool size within the volume group for future metadata expansion. This is to prevent an out-of-the-box configuration from running out of space under normal usage conditions. Overprovisioning of thin pools during installation is also not supported.

* **Minimum Total - 45 GB**

If you are also installing the oVirt Node Appliance for self-hosted engine installation, /var/tmp must be at least 5 GB.

### PCI Device Requirements

Hosts must have at least one network interface with a minimum bandwidth of 1 Gbps. It is recommended that each host have two network interfaces with one dedicated to support network intensive activities such as virtual machine migration. The performance of such operations are limited by the bandwidth available.

### Device Assignment Requirements

If you plan to implement device assignment and PCI passthrough so that a virtual machine can use a specific PCIe device from a host, ensure the following requirements are met:

* CPU must support IOMMU (for example, VT-d or AMD-Vi). IBM POWER8 supports IOMMU by default.

* Firmware must support IOMMU.

* CPU root ports used must support ACS or ACS-equivalent capability.

* PCIe devices must support ACS or ACS-equivalent capability.

* It is recommended that all PCIe switches and bridges between the PCIe device and the root port support ACS. For example, if a switch does not support ACS, all devices behind that switch share the same IOMMU group, and can only be assigned to the same virtual machine.

* For GPU support, Enterprise Linux 7 supports PCI device assignment of PCIe-based NVIDIA K-Series Quadro (model 2000 series or higher), GRID, and Tesla as non-VGA graphics devices. Currently up to two GPUs may be attached to a virtual machine in addition to one of the standard, emulated VGA interfaces. The emulated VGA is used for pre-boot and installation and the NVIDIA GPU takes over when the NVIDIA graphics drivers are loaded. Note that the NVIDIA Quadro 2000 is not supported, nor is the Quadro K420 card.

Check vendor specification and datasheets to confirm that your hardware meets these requirements. The `lspci -v` command can be used to print information for PCI devices already installed on a system.

### vGPU requirements

If you plan to configure a host to allow virtual machines on that host to install a vGPU, the following requirements must be met:

* vGPU-compatible GPU

* GPU-enabled host kernel

* Installed GPU with correct drivers

* Predefined **mdev_type** set to correspond with one of the mdev types supported by the device

* vGPU-capable drivers installed on each host in the cluster

* vGPU-supported virtual machine operating system with vGPU drivers installed

## Networking requirements

### DNS Requirements

The Engine and all hosts must have a fully qualified domain name and full, perfectly aligned forward and reverse name resolution. Red Hat strongly recommends using DNS; using the `/etc/hosts` file for name resolution typically requires more work and has a greater chance for errors.

Due to the extensive use of DNS in an oVirt environment, running the environment’s DNS service as a virtual machine hosted in the environment is not supported. All DNS services that the oVirt environment uses for name resolution must be hosted outside of the environment.

### oVirt Engine Firewall Requirements

The oVirt Engine requires that a number of ports be opened to allow network traffic through the system’s firewall.

The `engine-setup` script can configure the firewall automatically, but this overwrites any pre-existing firewall configuration if you are using **iptables**. If you want to keep the existing firewall configuration, you must manually insert the firewall rules required by the Engine. The `engine-setup` command saves a list of the **iptables** rules required in the **/etc/ovirt-engine/iptables.example** file. If you are using **firewalld**, `engine-setup` does not overwrite the existing configuration.

The firewall configuration documented here assumes a default configuration.

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
   <td>
   <p>Optional.</p>
   <p>May help in diagnosis.</p>
   </td>
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
    <p>VM Portal clients</p>
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
    <p>VM Portal clients</p>
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
   <td>Must be open for the Engine to receive Kdump notifications, if Kdump is enabled.</td>
  </tr>
  <tr>
   <td>54323</td>
   <td>TCP</td>
   <td>Administration Portal clients</td>
   <td>oVirt Engine (ImageIO Proxy server)</td>
   <td>Required for communication with the ImageIO Proxy (**ovirt-imageio-proxy**).</td>
  </tr>
 </tbody>
</table>

### Hypervisor Firewall Requirements

Enterprise Linux hosts and oVirt Nodes require a number of ports to be opened to allow network traffic through the system’s firewall. The firewall rules are automatically configured by default when adding a new host to the Engine, overwriting any pre-existing firewall configuration.

To disable automatic firewall configuration when adding a new host, clear the **Automatically configure host firewall** check box under **Advanced Parameters**.

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
   <td>111</td>
   <td>TCP</td>
   <td>NFS storage server</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>NFS connections.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>5900 - 6923</td>
   <td>TCP</td>
   <td>
    <p>Administration Portal clients</p>
    <p>VM Portal clients</p>
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
   <td>Required to access the Cockpit user interface, if installed.</td>
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
   <td>Virtual machine migration using **libvirt**.</td>
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
   <td>Virtual machine migration and fencing using VDSM. These ports must be open to facilitate both automated and manual migration of virtual machines.</td>
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
  <tr>
   <td>54322</td>
   <td>TCP</td>
   <td>oVirt Engine (ImageIO Proxy server)</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>Required for communication with the ImageIO daemon (**ovirt-imageio-daemon**).</td>
  </tr>
  <tr>
   <td>6081</td>
   <td>UDP</td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>oVirt Node(s)</p>
    <p>Enterprise Linux host(s)</p>
   </td>
   <td>Required, when Open Virtual Network (OVN) is used as a network provider, to allow OVN to create tunnels between hosts.</td>
  </tr>
 </tbody>
</table>

### Database Server Firewall Requirements

oVirt supports the use of a remote database server for the Engine database (`engine`) and the Data Warehouse database (`ovirt-engine-history`). If you plan to use a remote database server, it must allow connections from the Engine and the Data Warehouse service (which can be separate from the Engine).

Similarly, if you plan to access a local or remote Data Warehouse database from an external system, such as ManageIQ, the database must allow connections from that system. Accessing the Engine database from external systems is not supported.

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
   <td>5432</td>
   <td>TCP, UDP</td>
   <td>
    <p>oVirt Engine</p>
    <p>Data Warehouse Service</p>
    <p>External systems</p>
   </td>
   <td>
    <p>Engine (`engine`) database server</p>
    <p>Data Warehouse (`ovirt-engine-history`) database server</p>
   </td>
   <td>Default port for PostgreSQL database connections.</td>
  </tr>
 </tbody>
</table>

**Prev:** [Chapter 1: Introduction to oVirt](chap-Introduction_to_oVirt)<br>
**Next:** [Chapter 3: Installing oVirt](chap-Installing_oVirt)

[Adapted from RHV 4.3 beta documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3-beta/html/installation_guide/rhv_requirements)
