# Hypervisor Firewall Requirements

Red Hat Enterprise Linux hosts and Red Hat Virtualization Hosts (RHVH) require a number of ports to be opened to allow network traffic through the system's firewall. In the case of the Red Hat Virtualization Host these firewall rules are configured automatically. For Red Hat Enterprise Linux hosts however it is necessary to manually configure the firewall.

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
   <td>Red Hat Virtualization Manager</td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Secure Shell (SSH) access.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>2223</td>
   <td>TCP</td>
   <td>Red Hat Virtualization Manager</td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Secure Shell (SSH) access to enable connection to virtual machine serial consoles.</td>
  </tr>
  <tr>
   <td>161</td>
   <td>UDP</td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Red Hat Virtualization Manager</td>
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
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Remote guest console access via VNC and SPICE. These ports must be open to facilitate client access to virtual machines.</td>
  </tr>
  <tr>
   <td>5989</td>
   <td>TCP, UDP</td>
   <td>Common Information Model Object Manager (CIMOM)</td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
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
    <p>Red Hat Virtualization Manager</p>
    <p>Client machines</p>
   </td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
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
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Virtual machine migration using <tt>libvirt</tt>.</td>
  </tr>
  <tr>
   <td>49152 - 49216</td>
   <td>TCP</td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Virtual machine migration and fencing using VDSM. These ports must be open facilitate both automated and manually initiated migration of virtual machines.</td>
  </tr>
  <tr>
   <td>54321</td>
   <td>TCP</td>
   <td>
    <p>Red Hat Virtualization Manager</p>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>VDSM communications with the Manager and other virtualization hosts.</td>
  </tr>
 </tbody>
</table>
