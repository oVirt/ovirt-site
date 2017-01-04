# Host Power Management Settings Explained

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
   <td>Prevents the host from fencing while performing a kernel crash dump, so that the crash dump is not interrupted. From Red Hat Enterprise Linux 7.1 onwards, kdump is available by default. If kdump is available on the host, but its configuration is not valid (the kdump service cannot be started), enabling <b>Kdump integration</b> will cause the host (re)installation to fail. If this is the case, see [fence kdump Advanced Configuration](sect-fence_kdump_Advanced_Configuration).</td>
  </tr>
  <tr>
   <td><b>Disable policy control of power management</b></td>
   <td>Power management is controlled by the <b>Scheduling Policy</b> of the host's <b>cluster</b>. If power management is enabled and the defined low utilization value is reached, the Manager will power down the host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. Select this check box to disable policy control.</td>
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
   <td>By default, specifies that the Manager will search for a fencing proxy within the same <b>cluster</b> as the host, and if no fencing proxy is found, the Manager will search in the same <b>dc</b> (data center). Use the up and down buttons to change the sequence in which these resources are used. This field is available under <b>Advanced Parameters</b>.</td>
  </tr>
 </tbody>
</table>

The following table contains the information required in the <b>Edit fence agent</b> window.

**Edit fence agent Settings

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
    <p>For Red Hat Enterprise Linux 7 hosts, if you are using cisco_ucs as the power management device, you also need to append <tt>ssl_insecure=1</tt> to the <b>Options</b> field.</p>
   </td>
  </tr>
  <tr>
   <td><b>Secure</b></td>
   <td>Select this check box to allow the power management device to connect securely to the host. This can be done via ssh, ssl, or other authentication protocols depending on the power management agent.</td>
  </tr>
 </tbody>
</table>
