---
title: Hosts
---

# Chapter 7: Hosts

## Introduction to Hosts

Hosts, also known as hypervisors, are the physical servers on which virtual machines run. Full virtualization is provided by using a loadable Linux kernel module called Kernel-based Virtual Machine (KVM).

KVM can concurrently host multiple virtual machines running either Windows or Linux operating systems. Virtual machines run as individual Linux processes and threads on the host machine and are managed remotely by the oVirt Engine. An oVirt environment has one or more hosts attached to it.

oVirt supports two methods of installing hosts. You can use the oVirt Node installation media, or install hypervisor packages on a standard Enterprise Linux installation.

    **Note:** You can identify the host type of an individual host in the oVirt Engine by selecting the host’s name to open the details view, and checking the **OS Description** under **Software**.

Hosts use `tuned` profiles, which provide virtualization optimizations.

The oVirt Node has security features enabled. Security Enhanced Linux (SELinux) and the iptables firewall are fully configured and on by default. The status of SELinux on a selected host is reported under **SELinux mode** in the **General** tab of the details pane. The Engine can open required ports on Enterprise Linux hosts when it adds them to the environment.

A host is a physical 64-bit server with the Intel VT or AMD-V extensions running Enterprise Linux 7 AMD64/Intel 64 version.

A physical host on the oVirt platform:

* Must belong to only one cluster in the system.

* Must have CPUs that support the AMD-V or Intel VT hardware virtualization extensions.

* Must have CPUs that support all functionality exposed by the virtual CPU type selected upon cluster creation.

* Has a minimum of 2 GB RAM.

* Can have an assigned system administrator with system permissions.

Administrators can receive the latest security advisories from the oVirt watch list. Subscribe to the oVirt watch list to receive new security advisories for oVirt products by email. Subscribe by completing this form:

[http://www.redhat.com/mailman/listinfo/rhev-watch-list/](http://www.redhat.com/mailman/listinfo/rhev-watch-list/)

## oVirt Node

oVirt Node is installed using a special build of Enterprise Linux with only the packages required to host virtual machines. It uses an `Anaconda` installation interface based on the one used by Enterprise Linux hosts, and can be updated through the oVirt Engine or via `yum`. Using the `yum` command is the only way to install additional packages and have them persist after an upgrade.

oVirt Node features a Cockpit user interface for monitoring the host's resources and performing administrative tasks. Direct access to oVirt Node via SSH or console is not supported, so the Cockpit user interface provides a graphical user interface for tasks that are performed before the host is added to the oVirt Engine, such as configuring networking and deploying a self-hosted engine, and can also be used to run terminal commands via the **Terminal** sub-tab.

Access the Cockpit user interface at https://*HostFQDNorIP*:9090 in your web browser. Cockpit for oVirt Node includes a custom **Virtualization** dashboard that displays the host's health status, SSH Host Key, self-hosted engine status, virtual machines, and virtual machine statistics.

oVirt Node uses the Automatic Bug Reporting Tool (ABRT) to collect meaningful debug information about application crashes. For more information, see the link:https://wiki.centos.org/TipsAndTricks/ABRT.

**Note:** Custom boot kernel arguments can be added to oVirt Node using the `grubby` tool. The `grubby` tool makes persistent changes to the `grub.cfg` file. Navigate to the **Terminal** sub-tab in the host's Cockpit user interface to use `grubby` commands.

**Warning:** The oVirt Project strongly recommends not creating untrusted users on oVirt Node, as this can lead to exploitation of local security vulnerabilities.

## Enterprise Linux Hosts

You can use a Enterprise Linux 7 installation on capable hardware as a host. oVirt supports hosts running Enterprise Linux 7 Server AMD64/Intel 64 version with Intel VT or AMD-V extensions.

Adding a host can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge, and a reboot of the host. Use the details pane to monitor the process as the host and management system establish a connection.

Optionally, you can install a Cockpit user interface for monitoring the host’s resources and performing administrative tasks. The Cockpit user interface provides a graphical user interface for tasks that are performed before the host is added to the oVirt Engine, such as configuring networking and deploying a self-hosted engine, and can also be used to run terminal commands via the **Terminal** sub-tab.

**Important:** Third-party watchdogs should not be installed on Enterprise Linux hosts, as they can interfere with the watchdog daemon provided by VDSM.

## Foreman Host Provider Hosts

Hosts provided by a Foreman host provider can also be used as virtualization hosts by the oVirt Engine. After a Foreman host provider has been added to the Engine as an external provider, any hosts that it provides can be added to and used in oVirt in the same way as oVirt Nodes and Enterprise Linux hosts.

## Host Tasks

### Adding a Host to the oVirt Engine

Adding a host to your oVirt environment can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge, and a reboot of the host. Use the details pane to monitor the process as the host and the Engine establish a connection.

**Adding a Host to the oVirt Engine**

1. Click **Compute** &rarr; **Hosts**.

2. Click **New**.

3. Use the drop-down list to select the **Data Center** and **Host Cluster** for the new host.

4. Enter the **Name** and the **Hostname** of the new host. The standard SSH port, port 22, is auto-filled in the **SSH Port** field.

5. Select an authentication method to use for the Engine to access the host.

    * Enter the root user's password to use password authentication.

    * Alternatively, copy the key displayed in the **SSH PublicKey** field to **/root/.ssh/authorized_keys** on the host to use public key authentication.

6. Click the **Advanced Parameters** button to expand the advanced host settings.

    i. Optionally disable automatic firewall configuration.

    ii. Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

7. Optionally configure **Power Management**, **SPM**, **Console**, **Network Provider**, and **Kernel**. See [Explanation of Settings and Controls in the New Host and Edit Host Windows](sect-Explanation_of_Settings_and_Controls_in_the_New_Host_and_Edit_Host_Windows) for more information. **Hosted Engine** is used when deploying or undeploying a host for a self-hosted engine deployment.

8. Click **OK**.

The new host displays in the list of hosts with a status of `Installing`, and you can view the progress of the installation in the details pane. After a brief delay the host status changes to **Up**.

### Adding a Foreman Host Provider Host

The process for adding a Foreman host provider host is almost identical to that of adding a Enterprise Linux host except for the method by which the host is identified in the Engine. The following procedure outlines how to add a host provided by a Foreman host provider.

**Adding a Foreman Host Provider Host**

1. Click **Compute** &rarr; **Hosts**.

2. Click **New**.

3. Use the drop-down list to select the **Host Cluster** for the new host.

4. Select the **Foreman/Satellite** check box to display the options for adding a Foreman host provider host and select the provider from which the host is to be added.

5. Select either **Discovered Hosts** or **Provisioned Hosts**.

    * **Discovered Hosts** (default option): Select the host, host group, and compute resources from the drop-down lists.

    * **Provisioned Hosts**: Select a host from the **Providers Hosts** drop-down list.

    Any details regarding the host that can be retrieved from the external provider are automatically set, and can be edited as desired.

6. Enter the **Name**, **Address**, and **SSH Port** (Provisioned Hosts only) of the new host.

7. Select an authentication method to use with the host.

    * Enter the root user's password to use password authentication.

    * Copy the key displayed in the **SSH PublicKey** field to **/root/.ssh/authorized_hosts** on the host to use public key authentication (Provisioned Hosts only).

8. You have now completed the mandatory steps to add a Enterprise Linux host. Click the **Advanced Parameters** drop-down button to show the advanced host settings.

    i. Optionally disable automatic firewall configuration.

    ii. Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

9. You can configure the **Power Management**, **SPM**, **Console**, and **Network Provider** using the applicable tabs now; however, as these are not fundamental to adding a Enterprise Linux host, they are not covered in this procedure.

10. Click **OK** to add the host and close the window.

The new host displays in the list of hosts with a status of `Installing`, and you can view the progress of the installation in the details pane. After installation is complete, the status will update to `Reboot`. The host must be activated for the status to change to `Up`.

### Configuring Foreman Errata Management for a Host

oVirt can be configured to view errata from Foreman. This enables the host administrator to receive updates about available errata, and their importance, in the same dashboard used to manage host configuration.

oVirt 4.2 supports errata management with Foreman 6.1.

**Important:** Hosts are identified in the Foreman server by their FQDN. Hosts added using an IP address will not be able to report errata. This ensures that an external content host ID does not need to be maintained in oVirt.

The Foreman account used to manage the host must have Administrator permissions and a default organization set.

**Configuring Foreman Errata Management for a Host**

1. Add the Foreman server as an external provider.

2. Associate the required host with the Foreman server.

    **Note:** The host must be registered to the Foreman server and have the katello-agent package installed.

    i. Click **Compute** &rarr; **Hosts**.

    ii. Click **Edit**.

    iii. Select the **Use Foreman/Foreman** check box.

    iv. Select the required Foreman server from the drop-down list.

    v. Click **OK**.

The host is now configured to show the available errata, and their importance, in the same dashboard used to manage host configuration.

### Host General Settings Explained

These settings apply when editing the details of a host or adding new Enterprise Linux hosts and Foreman host provider hosts.

The **General** settings table contains the information required on the **General** tab of the **New Host** or **Edit Host** window.

**General settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Host Cluster</b></td>
   <td>The cluster to which the host belongs.</td>
  </tr>
  <tr>
   <td><b>Use Foreman/Satellite</b></td>
   <td>
    <p>Select or clear this check box to view or hide options for adding hosts provided by Foreman host providers. The following options are also available:</p>
    <p><b>Discovered Hosts</b></p>
    <ul>
     <li><b>Discovered Hosts</b> - A drop-down list that is populated with the name of Foreman hosts discovered by the engine.</li>
     <li><b>Host Groups</b> -A drop-down list of host groups available.</li>
     <li><b>Compute Resources</b> - A drop-down list of hypervisors to provide compute resources.</li>
    </ul>
    <p><b>Provisioned Hosts</b></p>
    <ul>
     <li><b>Providers Hosts</b> - A drop-down list that is populated with the name of hosts provided by the selected external provider. The entries in this list are filtered in accordance with any search queries that have been input in the <b>Provider search filter</b>.</li>
     <li><b>Provider search filter</b> - A text field that allows you to search for hosts provided by the selected external provider. This option is provider-specific; see provider documentation for details on forming search queries for specific providers. Leave this field blank to view all available hosts.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the cluster. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text, human-readable comments regarding the host.</td>
  </tr>
  <tr>
   <td><b>Address</b></td>
   <td>The IP address, or resolvable hostname of the host.</td>
  </tr>
  <tr>
   <td><b>Password</b></td>
   <td>The password of the host's root user. This can only be given when you add the host; it cannot be edited afterwards.</td>
  </tr>
  <tr>
   <td><b>SSH PublicKey</b></td>
   <td>Copy the contents in the text box to the <tt>/root/.known_hosts</tt> file on the host to use the Engine's ssh key instead of using a password to authenticate with the host.</td>
  </tr>
  <tr>
   <td><b>Automatically configure host firewall</b></td>
   <td>When adding a new host, the Engine can open the required ports on the host's firewall. This is enabled by default. This is an <b>Advanced Parameter</b>.</td>
  </tr>
  <tr>
   <td><b>SSH Fingerprint</b></td>
   <td>You can <b>fetch</b> the host's SSH fingerprint, and compare it with the fingerprint you expect the host to return, ensuring that they match. This is an <b>Advanced Parameter</b>.</td>
  </tr>
 </tbody>
</table>

### Host Power Management Settings Explained

The **Power Management** settings table contains the information required on the **Power Management** tab of the **New Host** or **Edit Host** windows. You can configure power management if the host has a supported power management card.

**Power Management Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Enable Power Management</b></td>
   <td>Enables power management on the host. Select this check box to enable the rest of the fields in the <b>Power Management</b> tab.</td>
  </tr>
  <tr>
   <td><b>Kdump integration</b></td>
   <td>Prevents the host from fencing while performing a kernel crash dump, so that the crash dump is not interrupted. From Enterprise Linux 7.1 onwards, kdump is available by default. If kdump is available on the host, but its configuration is not valid (the kdump service cannot be started), enabling <b>Kdump integration</b> will cause the host (re)installation to fail. If this is the case, see [fence kdump Advanced Configuration](sect-fence_kdump_Advanced_Configuration).</td>
  </tr>
  <tr>
   <td><b>Disable policy control of power management</b></td>
   <td>Power management is controlled by the <b>Scheduling Policy</b> of the host's <b>cluster</b>. If power management is enabled and the defined low utilization value is reached, the Engine will power down the host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. Select this check box to disable policy control.</td>
  </tr>
  <tr>
   <td><b>Agents by Sequential Order</b></td>
   <td>
    <p>Lists the host's fence agents. Fence agents can be sequential, concurrent, or a mix of both.</p>
    <ul>
     <li>If fence agents are used sequentially, the primary agent is used first to stop or start a host, and if it fails, the secondary agent is used.</li>
     <li>If fence agents are used concurrently, both fence agents have to respond to the Stop command for the host to be stopped; if one agent responds to the Start command, the host will go up.</li>
    </ul>
    <p>Fence agents are sequential by default. Use the up and down buttons to change the sequence in which the fence agents are used.</p>
    <p>To make two fence agents concurrent, select one fence agent from the <b>Concurrent with</b> drop-down list next to the other fence agent. Additional fence agents can be added to the group of concurrent fence agents by selecting the group from the <b>Concurrent with</b> drop-down list next to the additional fence agent.</p>
   </td>
  </tr>
  <tr>
   <td><b>Add Fence Agent</b></td>
   <td>Click the plus (<b>+</b>) button to add a new fence agent. The <b>Edit fence agent</b> window opens. See the table below for more information on the fields in this window.</td>
  </tr>
  <tr>
   <td><b>Power Management Proxy Preference</b></td>
   <td>By default, specifies that the Engine will search for a fencing proxy within the same <b>cluster</b> as the host, and if no fencing proxy is found, the Engine will search in the same <b>dc</b> (data center). Use the up and down buttons to change the sequence in which these resources are used. This field is available under <b>Advanced Parameters</b>.</td>
  </tr>
 </tbody>
</table>

The following table contains the information required in the **Edit fence agent** window.

**Edit fence agent Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Address</b></td>
   <td>The address to access your host's power management device. Either a resolvable hostname or an IP address.</td>
  </tr>
  <tr>
   <td><b>User Name</b></td>
   <td>User account with which to access the power management device. You can set up a user on the device, or use the default user.</td>
  </tr>
  <tr>
   <td><b>Password</b></td>
   <td>Password for the user accessing the power management device.</td>
  </tr>
  <tr>
   <td><b>Type</b></td>
   <td>
    <p>The type of power management device in your host.</p>
    <p>Choose one of the following:</p>
    <ul>
     <li><b>apc</b> - APC MasterSwitch network power switch. Not for use with APC 5.x power switch devices.</li>
     <li><b>apc_snmp</b> - Use with APC 5.x power switch devices.</li>
     <li><b>bladecenter</b> - IBM Bladecenter Remote Supervisor Adapter.</li>
     <li><b>cisco_ucs</b> - Cisco Unified Computing System.</li>
     <li><b>drac5</b> - Dell Remote Access Controller for Dell computers.</li>
     <li><b>drac7</b> - Dell Remote Access Controller for Dell computers.</li>
     <li><b>eps</b> - ePowerSwitch 8M+ network power switch.</li>
     <li><b>hpblade</b> - HP BladeSystem.</li>
     <li><b>ilo</b>, <b>ilo2</b>, <b>ilo3</b>, <b>ilo4</b> - HP Integrated Lights-Out.</li>
     <li><b>ipmilan</b> - Intelligent Platform Management Interface and Sun Integrated Lights Out Management devices.</li>
     <li><b>rsa</b> - IBM Remote Supervisor Adapter.</li>
     <li><b>rsb</b> - Fujitsu-Siemens RSB management interface.</li>
     <li><b>wti</b> - WTI Network Power Switch.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Port</b></td>
   <td>The port number used by the power management device to communicate with the host.</td>
  </tr>
  <tr>
   <td><b>Slot</b></td>
   <td>The number used to identify the blade of the power management device.</td>
  </tr>
  <tr>
   <td><b>Service Profile</b></td>
   <td>The service profile name used to identify the blade of the power management device. This field appears instead of <b>Slot</b> when the device type is <tt>cisco_ucs</tt>.</td>
  </tr>
  <tr>
   <td><b>Options</b></td>
   <td>
    <p>Power management device specific options. Enter these as 'key=value'. See the documentation of your host's power management device for the options available.</p>
    <p>For Enterprise Linux 7 hosts, if you are using cisco_ucs as the power management device, you also need to append <tt>ssl_insecure=1</tt> to the <b>Options</b> field.</p>
   </td>
  </tr>
  <tr>
   <td><b>Secure</b></td>
   <td>Select this check box to allow the power management device to connect securely to the host. This can be done via ssh, ssl, or other authentication protocols depending on the power management agent.</td>
  </tr>
 </tbody>
</table>

### SPM Priority Settings Explained

The **SPM** settings table details the information required on the **SPM** tab of the **New Host** or **Edit Host** window.

**SPM settings**

| Field Name | Description |
|-
| **SPM Priority** | Defines the likelihood that the host will be given the role of Storage Pool Manager (SPM). The options are **Low**, **Normal**, and **High** priority. Low priority means that there is a reduced likelihood of the host being assigned the role of SPM, and High priority means there is an increased likelihood. The default setting is Normal. |

### Host Console Settings Explained

The **Console** settings table details the information required on the **Console** tab of the **New Host** or **Edit Host** window.

**Console settings**

| Field Name | Description |
|-
| **Override display address** | Select this check box to override the display addresses of the host. This feature is useful in a case where the hosts are defined by internal IP and are behind a NAT firewall. When a user connects to a virtual machine from outside of the internal network, instead of returning the private address of the host on which the virtual machine is running, the machine returns a public IP or FQDN (which is resolved in the external network to the public IP). |
| **Display address** | The display address specified here will be used for all virtual machines running on this host. The address must be in the format of a fully qualified domain name or IP. |

### Network Provider Settings Explained

The **Network Provider** settings table details the information required on the **Network Provider** tab of the **New Host** or **Edit Host** window.

**Network Provider settings**

| Field Name | Description |
|-
| **External Network Provider** | If you have added an external network provider and want the host's network to be provisioned by the external network provider, select one from the list. |

### Kernel Settings Explained

The **Kernel** settings table details the information required on the **Kernel** tab of the **New Host** or **Edit Host** window. Common kernel boot parameter options are listed as check boxes so you can easily select them. For more complex changes, use the free text entry field next to **Kernel command line** to add in any additional parameters required.</para>

**Important:** If the host is attached to the Engine already, ensure you place the host into maintenance mode before applying any changes. You will need to reinstall the host by clicking **Reinstall**, and then reboot the host after the reinstallation is complete for the changes to take effect.

**Kernel Settings**

| Field Name | Description |
|-
| **Hostdev Passthrough &amp; SR-IOV** | Enables the IOMMU flag in the kernel to allow a host device to be used by a virtual machine as if the device is a device attached directly to the virtual machine itself. The host hardware and firmware must also support IOMMU. The virtualization extension and IOMMU extension must be enabled on the hardware. See "Configuring a Host for PCI Passthrough" in the [Installation Guide](/documentation/install-guide/Installation_Guide/). IBM POWER8 has IOMMU enabled by default. |
| **Nested Virtualization** | Enables the vmx or svm flag to allow you to run virtual machines within virtual machines. This option is only intended for evaluation purposes and not supported for production purposes. The `vdsm-hook-nestedvt` hook must be installed on the host. |
| **Unsafe Interrupts**  | If IOMMU is enabled but the passthrough fails because the hardware does not support interrupt remapping, you can consider enabling this option. Note that you should only enable this option if the virtual machines on the host are trusted; having the option enabled potentially exposes the host to MSI attacks from the virtual machines. This option is only intended to be used as a workaround when using uncertified hardware for evaluation purposes. |
| **PCI Reallocation** | If your SR-IOV NIC is unable to allocate virtual functions because of memory issues, consider enabling this option. The host hardware and firmware must also support PCI reallocation. This option is only intended to be used as a workaround when using uncertified hardware for evaluation purposes. |
| **Kernel command line** | This field allows you to append more kernel parameters to the default parameters. |

    **Note:** If the kernel boot parameters are grayed out, click the **reset** button and the options will be available.

### Hosted Engine Settings Explained

The **Hosted Engine** settings table details the information required on the **Hosted Engine** tab of the **New Host** or **Edit Host** window.

**Hosted Engine Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Choose hosted engine deployment action</b></td>
   <td>
    <p>Three options are available:</p>
    <ul>
     <li><b>None</b> - No actions required.</li>
     <li><b>Deploy</b> - Select this option to deploy the host as a self-hosted engine host.</li>
     <li><b>Undeploy</b> - For a self-hosted engine host, you can select this option to undeploy the host and remove self-hosted engine related configurations.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

### Configuring Host Power Management Settings

Configure your host power management device settings to perform host life-cycle operations (stop, start, restart) from the Administration Portal.

You must configure host power management in order to utilize host high availability and virtual machine high availability.

**Configuring Power Management Settings**

1. Click **Compute** &rarr; **Hosts** and select a host.

2. Click **Management** &rarr; **Maintenance**, and click **OK** to confirm.

3. When the host is in maintenance mode, click **Edit**.

4. Click the **Power Management** tab.

5. Select the **Enable Power Management** check box to enable the fields.

6. Select the **Kdump integration** check box to prevent the host from fencing while performing a kernel crash dump.

    **Important:** When you enable **Kdump integration** on an existing host, the host must be reinstalled for kdump to be configured. See [Reinstalling Virtualization Hosts](Reinstalling_Virtualization_Hosts).

7. Optionally, select the **Disable policy control of power management** check box if you do not want your host's power management to be controlled by the **Scheduling Policy** of the host's **cluster**.

8. Click the plus (**+**) button to add a new power management device. The **Edit fence agent** window opens.

9. Enter the **User Name** and **Password** of the power management device into the appropriate fields.

10. Select the power management device **Type** from the drop-down list.

11. Enter the IP address in the **Address** field.

12. Enter the **SSH Port** number used by the power management device to communicate with the host.

13. Enter the **Slot** number used to identify the blade of the power management device.

14. Enter the **Options** for the power management device. Use a comma-separated list of `'key=value'` entries.

  * If both IPv4 and IPv6 IP addresses can be used (default), leave the **Options** field blank.

  * If only IPv4 IP addresses can be used, enter `inet4_only=1`.

  * If only IPv6 IP addresses can be used, enter `inet6_only=1`.

15. Select the **Secure** check box to enable the power management device to connect securely to the host.

16. Click **Test** to ensure the settings are correct. **Test Succeeded, Host Status is: on** will display upon successful verification.

17. Click **OK** to close the **Edit fence agent** window.

18. In the **Power Management** tab, optionally expand the **Advanced Parameters** and use the up and down buttons to specify the order in which the Engine will search the host's **cluster** and **dc** (datacenter) for a fencing proxy.

19. Click **OK**.

The **Management** &rarr; **Power Management** drop-down menu is now enabled in the Administration Portal.

### Configuring Host Storage Pool Manager Settings

The Storage Pool Manager (SPM) is a management role given to one of the hosts in a data center to maintain access control over the storage domains. The SPM must always be available, and the SPM role will be assigned to another host if the SPM host becomes unavailable. As the SPM role uses some of the host's available resources, it is important to prioritize hosts that can afford the resources.

The Storage Pool Manager (SPM) priority setting of a host alters the likelihood of the host being assigned the SPM role: a host with high SPM priority will be assigned the SPM role before a host with low SPM priority.

**Configuring SPM settings**

1. Click **Compute** &rarr; **Hosts**.

2. Click **Edit**.

3. Click the **SPM** tab.

4. Use the radio buttons to select the appropriate SPM priority for the host.

5. Click **OK**.

You have configured the SPM priority of the host.

### Moving a Host to Maintenance Mode

Many common maintenance tasks, including network configuration and deployment of software updates, require that hosts be placed into maintenance mode. Hosts should be placed into maintenance mode before any event that might cause VDSM to stop working properly, such as a reboot, or issues with networking or storage.

When a host is placed into maintenance mode the oVirt Engine attempts to migrate all running virtual machines to alternative hosts. The standard prerequisites for live migration apply, in particular there must be at least one active host in the cluster with capacity to run the migrated virtual machines.

    **Note:** Virtual machines that are pinned to the host and cannot be migrated are shut down. You can check which virtual machines are pinned to the host by clicking Pinned to Host in the **Virtual Machines** tab of the host’s details view.

**Placing a Host into Maintenance Mode**

1. Click **Compute** &rarr; **Hosts** and select the desired host.

2. Click **Management** &rarr; **Maintenance** to open the **Maintenance Host(s)** confirmation window.

3. Optionally, enter a **Reason** for moving the host into maintenance mode, which will appear in the logs and when the host is activated again.

    **Note:** The host maintenance **Reason** field will only appear if it has been enabled in the cluster settings. See [Cluster properties](Cluster_properties) for more information.

4. Optionally, select the required options for hosts that support Gluster.

   Select the **Ignore Gluster Quorum** and **Self-Heal Validations** option to avoid the default checks. By default, the Manager checks that the Gluster quorum is not lost when the host is moved to maintenance mode. The Manager also checks that there is no self-heal activity that will be affected by moving the host to maintenance mode. If the Gluster quorum will be lost or if there is self-heal activity that will be affected, the Manager prevents the host from being placed into maintenance mode. Only use this option if there is no other way to place the host in maintenance mode.

   Select the **Stop Gluster Service** option to stop all Gluster services while moving the host to maintenance mode.

    **Note:** These fields will only appear in the host maintenance window when the selected host supports Gluster.

5. Click **OK** to initiate maintenance mode.

All running virtual machines are migrated to alternative hosts. If the host is the Storage Pool Manager (SPM), the SPM role is migrated to another host. The **Status** field of the host changes to `Preparing for Maintenance`, and finally `Maintenance` when the operation completes successfully. VDSM does not stop while the host is in maintenance mode.

**Note:** If migration fails on any virtual machine, click **Management** &rarr; **Activate** on the host to stop the operation placing it into maintenance mode, then click **Cancel Migration** on the virtual machine to stop the migration.

### Activating a Host from Maintenance Mode

A host that has been placed into maintenance mode, or recently added to the environment, must be activated before it can be used. Activation may fail if the host is not ready; ensure that all tasks are complete before attempting to activate the host.

**Activating a Host from Maintenance Mode**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Management** &rarr; **Activate**.

The host status changes to `Unassigned`, and finally `Up` when the operation is complete. Virtual machines can now run on the host. Virtual machines that were migrated off the host when it was placed into maintenance mode are not automatically migrated back to the host when it is activated, but can be migrated manually. If the host was the Storage Pool Manager (SPM) before being placed into maintenance mode, the SPM role does not return automatically when the host is activated.

### Configuring Host Firewall Rules

You can configure the host firewall rules so that they are persistent, using Ansible. The cluster must be configured to use `firewalld`, not `iptables`.

**Configuring Firewall Rules for Hosts**

1. On the Engine machine, edit **ovirt-host-deploy-post-tasks.yml.example** to add a custom firewall port:

    # vi /etc/ovirt-engine/ansible/ovirt-host-deploy-post-tasks.yml.example
    ---
    #
    # Any additional tasks required to be executing during host deploy process can
    # be added below
    #
    - name: Enable additional port on firewalld
    firewalld:
      port: "12345/tcp"
      permanent: yes
      immediate: yes
      state: enabled

2. Save the file to another location as **ovirt-host-deploy-post-tasks.yml**.

New or reinstalled hosts are configured with the updated firewall rules.

Existing hosts must be reinstalled by clicking **Installation** &rarr; **Reinstall** and selecting Automatically configure host firewall.

### Removing a Host

Remove a host from your virtualized environment.

**Removing a host**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Management** &rarr; **Maintenance**.

3. When the host is in maintenance mode, click **Remove** to open the **Remove Host(s)** confirmation window.

4. Select the **Force Remove** check box if the host is part of a Gluster Storage cluster and has volume bricks on it, or if the host is non-responsive.

5. Click **OK**.

Your host has been removed from the environment and is no longer visible in the **Hosts** tab.

### Updating a Host Between Minor Releases

See the "Updates Between Minor Releases" chapter in the [Upgrade Guide](/documentation/upgrade_guide/) for instructions on keeping your host current between minor releases.

### Reinstalling Hosts

Reinstall oVirt Nodes and Enterprise Linux hosts from the Administration Portal. Use this procedure to reinstall oVirt Node from the same version of the oVirt Node ISO image from which it is currently installed; the procedure reinstalls VDSM on Enterprise Linux hosts. This includes stopping and restarting the host. If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host reinstalls are performed at a time when the host's usage is relatively low.

The cluster to which the host belongs must have sufficient memory reserve in order for its hosts to perform maintenance. Moving a host with live virtual machines to maintenance in a cluster that lacks sufficient memory causes the virtual machine migration operation to hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before moving the host to maintenance.

    **Important:** Ensure that the cluster contains more than one host before performing a reinstall. Do not attempt to reinstall all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

**Reinstalling oVirt Node or Enterprise Linux hosts**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Management** &rarr; **Maintenance**. If migration is enabled at cluster level, any virtual machines running on the host are migrated to other hosts. If the host is the SPM, this function is moved to another host. The status of the host changes as it enters maintenance mode.

3. Click **Installation** &rarr; **Reinstall** to open the **Install Host** window.

4. Click **OK** to reinstall the host.

Once successfully reinstalled, the host displays a status of **Up**. Any virtual machines that were migrated off the host, are at this point able to be migrated back to it.

**Important:** After an oVirt Node is successfully registered to the oVirt Engine and then reinstalled, it may erroneously appear in the Administration Portal with the status of **Install Failed**. Click **Management** &rarr; **Activate**, and the Host will change to an **Up** status and be ready for use.

### Customizing Hosts with Tags

You can use tags to store information about your hosts. You can then search for hosts based on tags.

**Customizing hosts with tags**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **More Actions** &rarr; **Assign Tags**.

3. Select the check boxes of applicable tags.

4. Click **OK**.

You have added extra, searchable information about your host as tags.

### Viewing Host Errata

Errata for each host can be viewed after the host has been configured to receive errata information from the Foreman server. For more information on configuring a host to receive errata information see [Configuring Satellite Errata Management for a Host](Configuring_Satellite_Errata_Management_for_a_Host)

**Viewing Host Errata**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Errata** tab.

### Viewing the Health Status of a Host

Hosts have an external health status in addition to their regular **Status**. The external health status is reported by plug-ins or external systems, or set by an administrator, and appears to the left of the host's **Name** as one of the following icons:

* **OK**: No icon

* **Info**: ![](/images/admin-guide/Info.png)

* **Warning**: ![](/images/admin-guide/Warning.png)

* **Error**: ![](/images/admin-guide/Error.png)

* **Failure**: ![](/images/admin-guide/Failure.png)

To view further details about the host's health status, select the host and click the **Events** tab.

The host's health status can also be viewed using the REST API. A `GET` request on a host will include the `external_status` element, which contains the health status.

You can set a host's health status in the REST API via the `events` collection.

### Viewing Host Devices

You can view the host devices for each host in the details pane. If the host has been configured for direct device assignment, these devices can be directly attached to virtual machines for improved performance.

For more information on configuring the host for direct device assignment, see "Configuring a Host for PCI Passthrough" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

For more information on attaching host devices to virtual machines, see "Host Devices" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

**Viewing Host Devices**

1. Click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **Host Devices** tab.

This tab lists the details of the host devices, including whether the device is attached to a virtual machine, and currently in use by that virtual machine.

### Preparing Host and Guest Systems for GPU Passthrough

The Graphics Processing Unit (GPU) device from a host can be directly assigned to a virtual machine. Before this can be achieved, both the host and the virtual machine require amendments to their **grub** configuration files. You can edit the host **grub** configuration file using the **Kernel command line** free text entry field in the Administration Portal. Both the host machine and the virtual machine require reboot for the changes to take effect.

This procedure is relevant for hosts with either x86_64 or ppc64le architecture.

For more information on the hardware requirements for direct device assignment, see "PCI Device Requirements" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

    **Important:** If the host is attached to the Engine already, ensure you place the host into maintenance mode before applying any changes.

**Preparing a Host for GPU Passthrough**

1. From the Administration Portal, click **Compute** &rarr; **Hosts**.

2. Click the host’s name to open the details view.

3. Click the **General** tab, and click **Hardware**. Locate the GPU device `vendor ID:product ID`. In this example, the IDs are `10de:13ba` and `10de:0fbc`.

4. Right-click the host and select **Edit**. Click the **Kernel** tab.

5. In the **Kernel command line** free text entry field, enter the IDs located in the previous steps.

        pci-stub.ids=10de:13ba,10de:0fbc

6. Blacklist the corresponding drivers on the host. For example, to blacklist nVidia's nouveau driver, next to `pci-stub.ids=xxxx:xxxx`, enter **rdblacklist=nouveau**.

        pci-stub.ids=10de:13ba,10de:0fbc rdblacklist=nouveau

7. Click **OK**.

8. Click **Installation** &rarr; **Reinstall** to commit the changes to the host.

9. Reboot the host after the reinstallation is complete.

    **Note:** To confirm the device is bound to the `pci-stub` driver, run the `lspci` command:

        # lspci -nnk
        ...
        01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM107GL [Quadro K2200] [10de:13ba] (rev a2)
                Subsystem: NVIDIA Corporation Device [10de:1097]
                Kernel driver in use: pci-stub
        01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:0fbc] (rev a1)
                Subsystem: NVIDIA Corporation Device [10de:1097]
                Kernel driver in use: pci-stub
        ...

Proceed to the next procedure to configure GPU passthrough on the guest system side.

**Preparing a Guest Virtual Machine for GPU Passthrough**

**For Linux**

    1. Only proprietary GPU drivers are supported. Black list the corresponding open source driver in the **grub** configuration file. For example:

            $ vi /etc/default/grub
            ...
            GRUB_CMDLINE_LINUX="nofb splash=quiet console=tty0 ... rdblacklist=nouveau"
            ...

    2. Locate the GPU BusID. In this example, is BusID is `00:09.0`.

            # lspci | grep VGA
            00:09.0 VGA compatible controller: NVIDIA Corporation GK106GL [Quadro K4000] (rev a1)

    3. Edit the **/etc/X11/xorg.conf** file and append the following content:

            Section "Device"
            Identifier "Device0"
            Driver "nvidia"
            VendorName "NVIDIA Corporation"
            BusID "PCI:0:9:0"
            EndSection

    4. Restart the virtual machine.

**For Windows**

    1. Download and install the corresponding drivers for the device. For example, for Nvidia drivers, go to [NVIDIA Driver Downloads](http://www.nvidia.com/Download/index.aspx?lang=en-us).

    2. Restart the virtual machine.

The host GPU can now be directly assigned to the prepared virtual machine. For more information on assigning host devices to virtual machines, see "Host Devices" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

### Accessing Cockpit from the Administration Portal

Cockpit is available by default on oVirt Nodes and Enterprise Linux hosts. You can access the Cockpit user interface by typing the address into a browser, or through the Administration Portal.

**Accessing Cockpit from the Administration Portal**

1. In the Administration Portal, click **Compute** &rarr; **Hosts** and select a host.

2. Click **Host Console**.

        # systemctl restart ovirt-engine.service

The Cockpit login page opens in a new browser window.

## Host Resilience

### Host High Availability

The oVirt Engine uses fencing to keep the hosts in a cluster responsive. A **Non Responsive** host is different from a **Non Operational** host. **Non Operational** hosts can be communicated with by the Engine, but have an incorrect configuration, for example a missing logical network. **Non Responsive** hosts cannot be communicated with by the Engine.

Fencing allows a cluster to react to unexpected host failures as well as enforce power saving, load balancing, and virtual machine availability policies. You should configure the fencing parameters for your host's power management device and test their correctness from time to time. In a fencing operation, a non-responsive host is rebooted, and if the host does not return to an active status within a prescribed time, it remains non-responsive pending manual intervention and troubleshooting.

    **Note:** To automatically check the fencing parameters, you can configure the `PMHealthCheckEnabled` (false by default) and `PMHealthCheckIntervalInSec` (3600 sec by default) engine-config options.

    When set to true, `PMHealthCheckEnabled` will check all host agents at the interval specified by `PMHealthCheckIntervalInSec`, and raise warnings if it detects issues.

Power management operations can be performed by oVirt Engine after it reboots, by a proxy host, or manually in the Administration Portal. All the virtual machines running on the non-responsive host are stopped, and highly available virtual machines are started on a different host. At least two hosts are required for power management operations.

After the Engine starts up, it automatically attempts to fence non-responsive hosts that have power management enabled after the quiet time (5 minutes by default) has elapsed. The quiet time can be configured by updating the `DisableFenceAtStartupInSec` engine-config option.

    **Important:** If a host runs virtual machines that are highly available, power management must be enabled and configured.

### Power Management by Proxy in oVirt

The oVirt Engine does not communicate directly with fence agents. Instead, the Engine uses a proxy to send power management commands to a host power management device. The Engine uses VDSM to execute power management device actions, so another host in the environment is used as a fencing proxy.

You can select between:

* Any host in the same cluster as the host requiring fencing.

* Any host in the same data center as the host requiring fencing.

A viable fencing proxy host has a status of either **UP** or **Maintenance**.

### Setting Fencing Parameters on a Host

The parameters for host fencing are set using the **Power Management** fields on the **New Host** or **Edit Host** windows. Power management enables the system to fence a troublesome host using an additional interface such as a Remote Access Card (RAC).

All power management operations are done using a proxy host, as opposed to directly by the oVirt Engine. At least two hosts are required for power management operations.

**Setting fencing parameters on a host**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Edit**.

3. Click the **Power Management** tab.

4. Select the **Enable Power Management** check box to enable the fields.

5. Select the **Kdump integration** check box to prevent the host from fencing while performing a kernel crash dump.

    **Important:** When you enable **Kdump integration** on an existing host, the host must be reinstalled for kdump to be configured. See [Reinstalling Virtualization Hosts](Reinstalling_Virtualization_Hosts").

6. Optionally, select the **Disable policy control of power management** check box if you do not want your host's power management to be controlled by the **Scheduling Policy** of the host's cluster.

7. Click the plus (**+**) button to add a new power management device. The **Edit fence agent** window opens.

8. Enter the **Address**, **User Name**, and **Password** of the power management device.

9. Select the power management device **Type** from the drop-down list.

10. Enter the **SSH Port** number used by the power management device to communicate with the host.

11. Enter the **Slot** number used to identify the blade of the power management device.

12. Enter the **Options** for the power management device. Use a comma-separated list of `'key=value'` entries.

13. Select the **Secure** check box to enable the power management device to connect securely to the host.

14. Click the **Test** button to ensure the settings are correct. **Test Succeeded, Host Status is: on** will display upon successful verification.

    **Warning:** Power management parameters (userid, password, options, etc) are tested by oVirt Engine only during setup and manually after that. If you choose to ignore alerts about incorrect parameters, or if the parameters are changed on the power management hardware without the corresponding change in oVirt Engine, fencing is likely to fail when most needed.

15. Click **OK** to close the **Edit fence agent** window.

16. In the **Power Management** tab, optionally expand the **Advanced Parameters** and use the up and down buttons to specify the order in which the Engine will search the host's **cluster** and **dc** (datacenter) for a fencing proxy.

17. Click **OK**.

You are returned to the list of hosts. Note that the exclamation mark next to the host's name has now disappeared, signifying that power management has been successfully configured.

### fence_kdump Advanced Configuration

**kdump**

Select a host to view the status of the kdump service in the **General** tab of the details pane:

* **Enabled**: kdump is configured properly and the kdump service is running.

* **Disabled**: the kdump service is not running (in this case kdump integration will not work properly).

* **Unknown**: happens only for hosts with an older VDSM version that does not report kdump status.

**fence_kdump**

Enabling**Kdump integration** in the**Power Management** tab of the**New Host** or**Edit Host** window configures a standard fence_kdump setup. If the environment's network configuration is simple and the Engine's FQDN is resolvable on all hosts, the default fence_kdump settings are sufficient for use.

However, there are some cases where advanced configuration of fence_kdump is necessary. Environments with more complex networking may require manual changes to the configuration of the Engine, fence_kdump listener, or both. For example, if the Engine's FQDN is not resolvable on all hosts with**Kdump integration** enabled, you can set a proper host name or IP address using `engine-config`:

    engine-config -s FenceKdumpDestinationAddress=A.B.C.D

The following example cases may also require configuration changes:

* The Engine has two NICs, where one of these is public-facing, and the second is the preferred destination for fence_kdump messages.

* You need to execute the fence_kdump listener on a different IP or port.

* You need to set a custom interval for fence_kdump notification messages, to prevent possible packet loss.

Customized fence_kdump detection settings are recommended for advanced users only, as changes to the default configuration are only necessary in more complex networking setups. For configuration options for the fence_kdump listener see the "fence_kdump listener Configuration" section. For configuration of kdump on the Engine see the "Configuring fence_kdump on the Engine" section.

#### fence_kdump listener Configuration

Edit the configuration of the fence_kdump listener. This is only necessary in cases where the default configuration is not sufficient.

**Manually Configuring the fence_kdump Listener**

1. Create a new file (for example, **my-fence-kdump.conf**) in **/etc/ovirt-engine/ovirt-fence-kdump-listener.conf.d/**

2. Enter your customization with the syntax `OPTION=value` and save the file.

    **Important:** The edited values must also be changed in `engine-config` as outlined in the fence_kdump Listener Configuration Options table in the "Configuring fence kdump on the Engine" section.

3. Restart the fence_kdump listener:

        # systemctl restart ovirt-fence-kdump-listener.service

The following options can be customized if required:

**fence_kdump Listener Configuration Options**

| Variable | Description | Default | Note |
|-
| LISTENER_ADDRESS | Defines the IP address to receive fence_kdump messages on. | 0.0.0.0 | If the value of this parameter is changed, it must match the value of `FenceKdumpDestinationAddress` in `engine-config`. |
| LISTENER_PORT | Defines the port to receive fence_kdump messages on. | 7410 | If the value of this parameter is changed, it must match the value of `FenceKdumpDestinationPort` in `engine-config`. |
| HEARTBEAT_INTERVAL | Defines the interval in seconds of the listener's heartbeat updates. | 30 | If the value of this parameter is changed, it must be half the size or smaller than the value of `FenceKdumpListenerTimeout` in `engine-config`. |
| SESSION_SYNC_INTERVAL | Defines the interval in seconds to synchronize the listener's host kdumping sessions in memory to the database. | 5 | If the value of this parameter is changed, it must be half the size or smaller than the value of `KdumpStartedTimeout` in `engine-config`. |
| REOPEN_DB_CONNECTION_INTERVAL | Defines the interval in seconds to reopen the database connection which was previously unavailable. | 30 | - |
| KDUMP_FINISHED_TIMEOUT | Defines the maximum timeout in seconds after the last received message from kdumping hosts after which the host kdump flow is marked as FINISHED. | 60 | If the value of this parameter is changed, it must be double the size or higher than the value of `FenceKdumpMessageInterval` in `engine-config`. |

#### Configuring fence_kdump on the Engine

Edit the Engine's kdump configuration. This is only necessary in cases where the default configuration is not sufficient. The current configuration values can be found using:

    # engine-config -g OPTION

**Manually Configuring Kdump with engine-config**

1. Edit kdump's configuration using the `engine-config` command:

        # engine-config -s OPTION=value

    **Important:** The edited values must also be changed in the fence_kdump listener configuration file as outlined in the `Kdump Configuration Options` table. See [fence kdump listener Configuration](fence_kdump_listener_Configuration).

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine.service

3. Reinstall all hosts with **Kdump integration** enabled, if required (see the table below).

The following options can be configured using `engine-config`:

**Kdump Configuration Options**

| Variable | Description | Default | Note |
|-
| FenceKdumpDestinationAddress | Defines the hostname(s) or IP address(es) to send fence_kdump messages to. If empty, the Engine's FQDN is used. | Empty string (Engine FQDN is used) | If the value of this parameter is changed, it must match the value of `LISTENER_ADDRESS` in the fence_kdump listener configuration file, and all hosts with **Kdump integration** enabled must be reinstalled. |
| FenceKdumpDestinationPort | Defines the port to send fence_kdump messages to. | 7410 | If the value of this parameter is changed, it must match the value of `LISTENER_PORT` in the fence_kdump listener configuration file, and all hosts with **Kdump integration** enabled must be reinstalled. |
| FenceKdumpMessageInterval | Defines the interval in seconds between messages sent by fence_kdump. | 5 | If the value of this parameter is changed, it must be half the size or smaller than the value of `KDUMP_FINISHED_TIMEOUT` in the fence_kdump listener configuration file, and all hosts with **Kdump integration** enabled must be reinstalled. |
| FenceKdumpListenerTimeout | Defines the maximum timeout in seconds since the last heartbeat to consider the fence_kdump listener alive. | 90 | If the value of this parameter is changed, it must be double the size or higher than the value of `HEARTBEAT_INTERVAL` in the fence_kdump listener configuration file. |
| KdumpStartedTimeout | Defines the maximum timeout in seconds to wait until the first message from the kdumping host is received (to detect that host kdump flow has started). | 30 | If the value of this parameter is changed, it must be double the size or higher than the value of `SESSION_SYNC_INTERVAL` in the fence_kdump listener configuration file, and `FenceKdumpMessageInterval`. |

### Soft-Fencing Hosts

Hosts can sometimes become non-responsive due to an unexpected problem, and though VDSM is unable to respond to requests, the virtual machines that depend upon VDSM remain alive and accessible. In these situations, restarting VDSM returns VDSM to a responsive state and resolves this issue.

"SSH Soft Fencing" is a process where the Engine attempts to restart VDSM via SSH on non-responsive hosts. If the Engine fails to restart VDSM via SSH, the responsibility for fencing falls to the external fencing agent if an external fencing agent has been configured.

Soft-fencing over SSH works as follows. Fencing must be configured and enabled on the host, and a valid proxy host (a second host, in an UP state, in the data center) must exist. When the connection between the Engine and the host times out, the following happens:

1. On the first network failure, the status of the host changes to "connecting".

2. The Engine then makes three attempts to ask VDSM for its status, or it waits for an interval determined by the load on the host. The formula for determining the length of the interval is configured by the configuration values TimeoutToResetVdsInSeconds (the default is 60 seconds) + [DelayResetPerVmInSeconds (the default is 0.5 seconds)]*(the count of running virtual machines on host) + [DelayResetForSpmInSeconds (the default is 20 seconds)]* 1 (if host runs as SPM) or 0 (if the host does not run as SPM). To give VDSM the maximum amount of time to respond, the Engine chooses the longer of the two options mentioned above (three attempts to retrieve the status of VDSM or the interval determined by the above formula).

3. If the host does not respond when that interval has elapsed, `vdsm restart` is executed via SSH.

4. If `vdsm restart` does not succeed in re-establishing the connection between the host and the Engine, the status of the host changes to `Non Responsive` and, if power management is configured, fencing is handed off to the external fencing agent.

**Note:** Soft-fencing over SSH can be executed on hosts that have no power management configured. This is distinct from "fencing": fencing can be executed only on hosts that have power management configured.

### Using Host Power Management Functions

When power management has been configured for a host, you can access a number of options from the Administration Portal interface. While each power management device has its own customizable options, they all support the basic options to start, stop, and restart a host.

**Using Host Power Management Functions**

1. Click **Compute** &rarr; **Hosts** and select the host.

2. Click **Management** &rarr; **Power Management** and select one of the following options:

    * **Restart**: This option stops the host and waits until the host's status changes to `Down`. When the agent has verified that the host is down, the highly available virtual machines are restarted on another host in the cluster. The agent then restarts this host. When the host is ready for use its status displays as `Up`.

    * **Start**: This option starts the host and lets it join a cluster. When it is ready for use its status displays as `Up`.

    * **Stop**: This option powers off the host. Before using this option, ensure that the virtual machines running on the host have been migrated to other hosts in the cluster. Otherwise the virtual machines will crash and only the highly available virtual machines will be restarted on another host. When the host has been stopped its status displays as `Non-Operational`.

      **Note:** If Power Management is not enabled, you can restart or stop the host by selecting it, clicking the **Management** drop-down menu, and selecting **SSH Management Restart** or **Stop**.

      **Important:** When two fencing agents are defined on a host, they can be used concurrently or sequentially. For concurrent agents, both agents have to respond to the Stop command for the host to be stopped; and when one agent responds to the Start command, the host will go up. For sequential agents, to start or stop a host, the primary agent is used first; if it fails, the secondary agent is used.

4. Click **OK**.

### Manually Fencing or Isolating a Non Responsive Host

**Summary**

If a host unpredictably goes into a non-responsive state, for example, due to a hardware failure; it can significantly affect the performance of the environment. If you do not have a power management device, or it is incorrectly configured, you can reboot the host manually.

    **Warning:** Do not use the **Confirm host has been rebooted** option unless you have manually rebooted the host. Using this option while the host is still running can lead to a virtual machine image corruption.

**Manually fencing or isolating a non-responsive host**

1. In the Administration Portal, click **Compute** &rarr; **Hosts** and confirm the host’s status is `Non Responsive`.

2. Manually reboot the host. This could mean physically entering the lab and rebooting the host.

3. In the Administration Portal, right-click the host entry and clicking **More Actions** &rarr; **Confirm Host has been rebooted**.

4. Select the **Approve Operation** check box and click **OK**.

5. If your hosts take an unusually long time to boot, you can set `ServerRebootTimeout` to specify how many seconds to wait before determining that the host is `Non Responsive`:

    # engine-config --set ServerRebootTimeout=integer

**Prev:** [Chapter 6: Logical Networks](chap-Logical_Networks)<br>
**Next:** [Chapter 8: Storage](chap-Storage)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-hosts)
