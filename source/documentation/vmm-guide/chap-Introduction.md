---
title: Introduction
---

# Chapter 1: Introduction

A virtual machine is a software implementation of a computer. The oVirt environment enables you to create virtual desktops and virtual servers.

Virtual machines consolidate computing tasks and workloads. In traditional computing environments, workloads usually run on individually administered and upgraded servers. Virtual machines reduce the amount of hardware and administration required to run the same computing tasks and workloads.

## Audience

Most virtual machine tasks in oVirt can be performed in both the VM Portal and Administration Portal. However, the user interface differs between each portal, and some administrative tasks require access to the Administration Portal. Tasks that can only be performed in the Administration Portal will be described as such in this book. Which portal you use, and which tasks you can perform in each portal, is determined by your level of permissions.

The VM Portal's user interface is described in the [Introduction to the VM Portal](/documentation/intro-vm-portal/).

The Administration Portal's user interface is described in the [Administration Guide](/documentation/administration_guide/).

## Supported Virtual Machine Operating Systems

The operating systems that can be virtualized as guest operating systems in oVirt are as follows:

**Certified Guest Operating Systems**

<table>
<col width="225">
<col width="150">
<col width="65">
<col width="65">
<col width="65">
<col width="100">
<col width="100">
<tr>
<th width="200"><center>Operating System</center></th>
<th><center>Architecture</center></th>
<th colspan="3"><center>oVirt Node Version</center></th>
<th><center>Spice Support</center></th>
</tr>
<tr>
<th></th>
<th></th>
<th><center>7</center></th>
<th><center>6</center></th>
<th><center>5</center></th>
<th></th>
</tr>
<tr>
<td>Red Hat Enterprise Linux 3</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td></td>
</tr>
<tr>
<td>Red Hat Enterprise Linux 4</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td></td>
</tr>
<tr>
<td>Red Hat Enterprise Linux 5</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td></td>
</tr>
<tr>
<td>Red Hat Enterprise Linux 6</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">4</center></td>
</tr>
<tr>
<td>Red Hat Enterprise Linux 7</td>
<td>64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png"></center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">4</center></td>
</tr>
<tr>
<td>Microsoft Windows Server 2008</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">5</center></td>
</tr>
<tr>
<td>Microsoft Windows Server 2008 R2</td>
<td>64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">5</center></td>
</tr>
<tr>
<td>Microsoft Windows Server 2012</td>
<td>64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td></td>
</tr>
<tr>
<td>Microsoft Windows Server 2012 R2</td>
<td>64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td></td>
</tr>
<tr>
<td>Microsoft Windows Server 2016</td>
<td>64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td></td>
<td></td>
<td><center>6</center></td>
</tr>
<tr>
<td>Microsoft Windows 7</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">4</center></td>
</tr>
<tr>
<td>Microsoft Windows 8</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td></td>
</tr>
<tr>
<td>Microsoft Windows 8.1</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td></td>
</tr>
<tr>
<td>Microsoft Windows 10</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">1</center></td>
<td></td>
</tr>
<tr>
<td>SUSE Linux Enterprise Server 10</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td></td>
</tr>
<tr>
<td>SUSE Linux Enterprise Server 11</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center>3</center></td>
</tr>
<tr>
<td>SUSE Linux Enterprise Server 12</td>
<td>32 bit, 64 bit (x86)</td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center><img src="/images/vmm-guide/greencheck.png">2</center></td>
<td><center>3</center></td>
</tr>
</table>
<p><br></p>
<ol>
<li>For best performance, the para-virtualized I/O drivers (virtio-win) are required to be installed in the Windows guests. The drivers are made available as images in the Supplementary channel of the Enterprise Linux host operating system. See the <a href="http://www.windowsservercatalog.com/svvp.aspx?svvppage=svvp.htm">Microsoft SVVP site</a> for certification details. </li>
<li>The oVirt Project tests the latest service pack of the guest operating system. </li>
<li>SPICE drivers (QXL) are not supplied by the oVirt Project. However, the distribution's vendor may provide SPICE drivers as part of their distribution. </li>
<li>SPICE is fully supported on Enterprise Linux 6.7, Enterprise 7.0 and above, and Windows 7.</li>
<li>SPICE is supported when spice-vdagent is running on these guest operating systems, but has not been tested.  </li>
<li>An upstream WDDM DoD driver can be used for SPICE.  See  <a href="https://www.spice-space.org/download/windows/qxl-wddm-dod/">this link</a> to access the driver. (Please note this is driver/resolution is not a Red Hat supported driver/solution.</li>
</ol>

## Virtual Machine Performance Parameters

oVirt virtual machines can support the following parameters:

<p>The following limits apply to oVirt. Red Hat also offers Red Hat Enterprise Linux with KVM virtualization, which offers virtualization for low-density Red Hat Enterprise Linux environments. To see limits for Red Hat Enterprise Linux with KVM virtualization, please see <em><a href="https://access.redhat.com/site/articles/rhel-kvm-limits">"Virtualization limits for Red Hat Enterprise Linux with KVM"</a></em>.</p>
<table>
<tr>
<th>&nbsp;</th>
<th>oVirt 2</th>
<th>oVirt 3</th>
<th>oVirt 4</th>
</tr>
<tr>
<td>Maximum number of concurrently running virtual guests</td>
<td>Unlimited</td>
<td>Unlimited</td>
<td>Unlimited</td>
</tr>
<tr>
<td>Maximum number of virtual CPUs in virtualized guest</td>
<td>16</td>
<td>160</td>
<td>240</td>
</tr>
<tr>
<td>Maximum memory in virtualized guest</td>
<td>512 GB<sup>1</sup></td>
<td>2 TB<sup>1</sup></td>
<td>4 TB<sup>1</sup></td>
</tr>
<tr>
<td>Minimum memory in virtualized guest</td>
<td>512 MB</td>
<td>512 MB</td>
<td>N/A</td>
</tr>
</table>
**Notes:**
<ul>
<li>Supported limits reflect the current state of system testing by the oVirt Project.</li>
<li>Guest Operating systems will have different minimum memory requirements.  Virtual Guest memory can be allocated as small as required.</li>
</ul>
<ol>
<li>Supports the maximum supported memory in the host, all of which may be allocated to the virtualized guest. 32-bit guests with Physical Address Extension (PAE) support will only be able to access 64 GB. This is a virtual hardware limitation.</li>
</ol>

## Installing Supporting Components on Client Machines

### Installing Console Components

A console is a graphical window that allows you to view the start up screen, shut down screen, and desktop of a virtual machine, and to interact with that virtual machine in a similar way to a physical machine. In oVirt, the default application for opening a console to a virtual machine is Remote Viewer, which must be installed on the client machine prior to use.

#### Installing Remote Viewer on Red Hat Enterprise Linux

The Remote Viewer application provides users with a graphical console for connecting to virtual machines. Once installed, it is called automatically when attempting to open a SPICE session with a virtual machine. Alternatively, it can also be used as a standalone application. Remote Viewer is included in the `virt-viewer` package provided by the base Enterprise Linux Workstation and Enterprise Linux Server repositories.

**Installing Remote Viewer on Linux**

1. Install the `virt-viewer` package:

        # yum install virt-viewer

2. Restart your browser for the changes to take effect.

You can now connect to your virtual machines using either the SPICE protocol or the VNC protocol.

#### Installing Remote Viewer on Windows

The Remote Viewer application provides users with a graphical console for connecting to virtual machines. Once installed, it is called automatically when attempting to open a SPICE session with a virtual machine. Alternatively, it can also be used as a standalone application.

**Installing Remote Viewer on Windows**

1. Open a web browser and download one of the following installers according to the architecture of your system.

  * Virt Viewer for 32-bit Windows:

        https://your-manager-fqdn/ovirt-engine/services/files/spice/virt-viewer-x86.msi

  * Virt Viewer for 64-bit Windows:

        https://your-manager-fqdn/ovirt-engine/services/files/spice/virt-viewer-x64.msi

2. Open the folder where the file was saved.

3. Double-click the file.

4. Click **Run** if prompted by a security warning.

5. Click **Yes** if prompted by User Account Control.

Remote Viewer is installed and can be accessed via `Remote Viewer` in the **VirtViewer** folder of **All Programs** in the start menu.

### Installing usbdk on Windows

`usbdk` is a driver that enables `remote-viewer` exclusive access to USB devices on Windows operating systems. Installing `usbdk` requires Administrator privileges. Note that the previously supported `USB Clerk` option has been deprecated and is no longer supported.

**Installing usbdk on Windows**

1. Open a web browser and download one of the following installers according to the architecture of your system.

 * usbdk for 32-bit Windows:

          https://[your manager's address]/ovirt-engine/services/files/spice/usbdk-x86.msi

 * usbdk for 64-bit Windows:

          https://[your manager's address]/ovirt-engine/services/files/spice/usbdk-x64.msi

2. Open the folder where the file was saved.

3. Double-click the file.

4. Click **Run** if prompted by a security warning.

5. Click **Yes** if prompted by User Account Control.

**Next:** [Chapter 2: Installing Linux Virtual Machines](chap-Installing_Linux_Virtual_Machines)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-introduction)
