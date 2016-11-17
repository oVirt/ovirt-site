# Red Hat Virtualization Manager Firewall Requirements

The Red Hat Virtualization Manager requires that a number of ports be opened to allow network traffic through the system's firewall. The `engine-setup` script can configure the firewall automatically, but this overwrites any pre-existing firewall configuration.

Where an existing firewall configuration exists, you must manually insert the firewall rules required by the Manager instead. The `engine-setup` command saves a list of the `iptables` rules required in the `/usr/share/ovirt-engine/conf/iptables.example` file.

The firewall configuration documented here assumes a default configuration. Where non-default HTTP and HTTPS ports are chosen during installation, adjust the firewall rules to allow network traffic on the ports that were selected - not the default ports (`80` and `443`) listed here.

**Red Hat Virtualization Manager Firewall Requirements**

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
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Red Hat Virtualization Manager</td>
   <td>When registering to the Red Hat Virtualization Manager, virtualization hosts send an ICMP ping request to the Manager to confirm that it is online.</td>
  </tr>
  <tr>
   <td>22</td>
   <td>TCP</td>
   <td>System(s) used for maintenance of the Manager including backend configuration, and software upgrades.</td>
   <td>Red Hat Virtualization Manager</td>
   <td>
    <p>Secure Shell (SSH) access.</p>
    <p>Optional.</p>
   </td>
  </tr>
  <tr>
   <td>2222</td>
   <td>TCP</td>
   <td>Clients accessing virtual machine serial consoles.</td>
   <td>Red Hat Virtualization Manager</td>
   <td>Secure Shell (SSH) access to enable connection to virtual machine serial consoles.</td>
  </tr>
  <tr>
   <td>80, 443</td>
   <td>TCP</td>
   <td>
    <p>Administration Portal clients</p>
    <p>User Portal clients</p>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
    <p>REST API clients</p>
   </td>
   <td>Red Hat Virtualization Manager</td>
   <td>Provides HTTP and HTTPS access to the Manager.</td>
  </tr>
  <tr>
   <td>6100</td>
   <td>TCP</td>
   <td>
    <p>Administration Portal clients</p>
    <p>User Portal clients</p>
   </td>
   <td>Red Hat Virtualization Manager</td>
   <td>Provides websocket proxy access for web-based console clients (`noVNC` and `spice-html5`) when the websocket proxy is running on the Manager. If the websocket proxy is running on a different host, however, this port is not used.</td>
  </tr>
  <tr>
   <td>7410</td>
   <td>UDP</td>
   <td>
    <p>Red Hat Virtualization Host(s)</p>
    <p>Red Hat Enterprise Linux host(s)</p>
   </td>
   <td>Red Hat Virtualization Manager</td>
   <td>Must be open for the Manager to receive Kdump notifications.</td>
  </tr>
 </tbody>
</table>

**Important:** In environments where the Red Hat Virtualization Manager is also required to export NFS storage, such as an ISO Storage Domain, additional ports must be allowed through the firewall. Grant firewall exceptions for the ports applicable to the version of NFS in use:

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
