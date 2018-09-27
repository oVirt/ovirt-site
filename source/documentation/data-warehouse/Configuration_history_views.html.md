---
title: Configuration History Views
---

## Configuration History Views

To query a configuration view, run SELECT * FROM view_name;. For example:

        # SELECT * FROM v4_0_configuration_history_datacenters;
To list all available views, run:

        # \dv

**Note:** `delete_date` does not appear in latest views because these views provide the latest configuration of living entities, which, by definition, have not been deleted.

### Data Center Configuration

The following table shows the configuration history parameters of the data centers in the system.

**v4_2_configuration_history_datacenters**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `datacenter_configuration_version` in the `v4_2_configuration_history_clusters` view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>datacenter_id</td>
   <td>uuid</td>
   <td>The unique ID of the data center in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>datacenter_name</td>
   <td>character varying(40)</td>
   <td>Name of the data center, as displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>datacenter_description</td>
   <td>charcter varying(4000)</td>
   <td>Description of the data center, as displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>is_local_storage</td>
   <td>boolean</td>
   <td>A flag to indicate whether the data center uses local storage.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Data Center Storage Domain Map

The following table shows the relationships between storage domains and data centers in the system.

**v4_2_map_history_datacenters_storage_domains**

| Name | Type | Description | Indexed |
|-
| history_id | integer | The ID of the configuration version in the history database. This is identical to the value of `datacenter_configuration_version` in the `v4_2_configuration_history_clusters` view and it can be used to join them. | No |
| storage_domain_id | uuid | The unique ID of this storage domain in the system. | Yes |
| datacenter_id | uuid | The unique ID of the data center in the system. | No |
| attach_date | timestamp with time zone | The date the storage domain was attached to the data center. | No |
| detach_date | timestamp with time zone | The date the storage domain was detached from the data center. | No |

### Storage Domain Configuration

The following table shows the configuration history parameters of the storage domains in the system.

**v4_2_configuration_history_storage_domains**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `storage_configuration_version` in the storage domain statistics views and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>storage_domain_id</td>
   <td>uuid</td>
   <td>The unique ID of this storage domain in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>storage_domain_name</td>
   <td>chracter varying(250)</td>
   <td>Storage domain name.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>storage_domain_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - Data (Master)</li>
     <li>1 - Data</li>
     <li>2 - ISO</li>
     <li>3 - Export</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>storage_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - Unknown</li>
     <li>1 - NFS</li>
     <li>2 - FCP</li>
     <li>3 - iSCSI</li>
     <li>4 - Local</li>
     <li>6 - All</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Cluster Configuration

The following table shows the configuration history parameters of the clusters in the system.

**v4_2_configuration_history_clusters**

| Name | Type | Description | Indexed |
|-
| history_id    | integer      | The ID of the configuration version in the history database. This is identical to the value of `cluster_configuration_version` in the `v4_2_configuration_history_hosts` and `v4_2_configuration_history_vms` views and it can be used to join them. | No |
| cluster_id    | uuid         | The unique identifier of the datacenter this cluster resides in. | Yes |
| cluster_name  | character varying(40)  | Name of the cluster, as displayed in the edit dialog. | No |
| cluster_description | character varying(4000) | As defined in the edit dialog. | No |
| datacenter_id | uuid         | The unique identifier of the datacenter this cluster resides in. | Yes |
| cpu_name      | character varying(255) | As displayed in the edit dialog. | No |
| compatibility_version | character varying(40) | As displayed in the edit dialog. | No |
| datacenter_configuration_version | integer | The data center configuration version at the time of creation or update. | No |
| create_date   | timestamp with time zone | The date this entity was added to the system. | No |
| update_date   | timestamp with time zone | The date this entity was changed in the system. | No |
| delete_date   | timestamp with time zone | The date this entity was deleted from the system. | No |

### Host Configuration

The following table shows the configuration history parameters of the hosts in the system.

**v4_2_configuration_history_hosts**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `host_configuration_version` in the host statistics views and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_id</td>
   <td>uuid</td>
   <td>The unique ID of the host in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>host_unique_id</td>
   <td>character varying(128)</td>
   <td>This field is a combination of the host physical UUID and one of its MAC addresses, and is used to detect hosts already registered in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_name</td>
   <td>character varying(255)</td>
   <td>Name of the host (same as in the edit dialog).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cluster_id</td>
   <td>uuid</td>
   <td>The unique ID of the cluster that this host belongs to.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>host_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - RHEL Host</li>
     <li>2 - RHEV Hypervisor Node</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>fqdn_or_ip</td>
   <td>character varying(255)</td>
   <td>The host's DNS name or its IP address for oVirt Engine to communicate with (as displayed in the edit dialog).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>memory_size_mb</td>
   <td>integer</td>
   <td>The host's physical memory capacity, expressed in megabytes (MB).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>swap_size_mb</td>
   <td>integer</td>
   <td>The host swap partition size.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cpu_model</td>
   <td>character varying(255)</td>
   <td>The host's CPU model.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>number_of_cores</td>
   <td>smallint</td>
   <td>Total number of CPU cores in the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>number_of_sockets</td>
   <td>smallint</td>
   <td>Total number of CPU sockets.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cpu_speed_mh</td>
   <td>numeric(18,0)</td>
   <td>The host's CPU speed, expressed in megahertz (MHz).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_os</td>
   <td>character varying(255)</td>
   <td>The host's operating system version.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>kernel_version</td>
   <td>character varying(255)</td>
   <td>The host's kernel version.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>kvm_version</td>
   <td>character varying(255)</td>
   <td>The host's KVM version.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vdsm_version</td>
   <td>character varying(40)</td>
   <td>The host's VDSM version.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vdsm_port</td>
   <td>integer</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>threads_per_core</td>
   <td>smallint</td>
   <td>Total number of threads per core.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>hardware_manufacturer</td>
   <td>character varying(255)</td>
   <td>The host’s hardware manufacturer.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>hardware_product_name</td>
   <td>character varying(255)</td>
   <td>The product name of the host’s hardware.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>hardware_version</td>
   <td>character varying(255)</td>
   <td>The version of the host’s hardware.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>hardware_serial_number</td>
   <td>character varying(255)</td>
   <td>The serial number of the host’s hardware.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cluster_configuration_version</td>
   <td>integer</td>
   <td>The cluster configuration version at the time of creation or update. This is identical to the value of `history_id` in the `v4_2_configuration_history_clusters` view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Host Interface Configuration

The following table shows the configuration history parameters of the host interfaces in the system.

**v4_2_configuration_history_hosts_interfaces**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `host_interface_configuration_version` in the host interface statistics views and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_interface_id</td>
   <td>uuid</td>
   <td>The unique ID of this interface in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>host_interface_name</td>
   <td>character varying(50)</td>
   <td>The interface name as reported by the host.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_id</td>
   <td>uuid</td>
   <td>Unique ID of the host this interface belongs to.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>host_interface_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - rt18139_pv</li>
     <li>1 - rt18139</li>
     <li>2 - e1000</li>
     <li>3 - pv</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_interface_speed_bps</td>
   <td>integer</td>
   <td>The interface speed in bits per second.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>mac_address</td>
   <td>character varying(20)</td>
   <td>The interface MAC address.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>logical_network_name</td>
   <td>character varying(50)</td>
   <td>The logical network associated with the interface.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>ip_address</td>
   <td>character varying(20)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>gateway</td>
   <td>character varying(20)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>bond</td>
   <td>boolean</td>
   <td>A flag to indicate if this interface is a bonded interface.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>bond_name</td>
   <td>character varying(50)</td>
   <td>The name of the bond this interface is part of (if it is part of a bond).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vlan_id</td>
   <td>integer</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>host_configuration_version</td>
   <td>integer</td>
   <td>The host configuration version at the time of creation or update. This is identical to the value of `history_id` in the `v4_2_configuration_history_hosts` view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Configuration

The following table shows the configuration history parameters of the virtual machines in the system.

**v4_2_configuration_history_vms**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `vm_configuration_version` in the virtual machine statistics views and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_id</td>
   <td>uuid</td>
   <td>The unique ID of this VM in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_name</td>
   <td>character varying(255)</td>
   <td>The name of the virtual machine.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_description</td>
   <td>character varying(4000)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - Desktop</li>
     <li>1 - Server</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>cluster_id</td>
   <td>uuid</td>
   <td>The unique ID of the cluster this VM belongs to.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>template_id</td>
   <td>uuid</td>
   <td>The unique ID of the template this VM is derived from. The field is for future use, as the templates are not synchronized to the history database in this version of oVirt.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>template_name</td>
   <td>character varying(40)</td>
   <td>Name of the template from which this virtual machine is derived.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cpu_per_socket</td>
   <td>smallint</td>
   <td>Virtual CPUs per socket.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>number_of_sockets</td>
   <td>smallint</td>
   <td>Total number of virtual CPU sockets.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>memory_size_mb</td>
   <td>integer</td>
   <td>Total memory allocated to the virtual machine, expressed in megabytes (MB).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>operating_system</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 - Other OS</li>
     <li>1 - Windows XP</li>
     <li>3 - Windows 2003</li>
     <li>4 - Windows 2008</li>
     <li>5 - Linux</li>
     <li>7 - Red Hat Enterprise Linux 5.x</li>
     <li>8 - Red Hat Enterprise Linux 4.x</li>
     <li>9 - Red Hat Enterprise Linux 3.x</li>
     <li>10 - Windows 2003 x64</li>
     <li>11 - Windows 7</li>
     <li>12 - Windows 7 x64</li>
     <li>13 - Red Hat Enterprise Linux 5.x x64</li>
     <li>14 - Red Hat Enterprise Linux 4.x x64</li>
     <li>15 - Red Hat Enterprise Linux 3.x x64</li>
     <li>16 - Windows 2008 x64</li>
     <li>17 - Windows 2008 R2 x64</li>
     <li>18 - Red Hat Enterprise Linux 6.x</li>
     <li>19 - Red Hat Enterprise Linux 6.x x64</li>
     <li>20 - Windows 8</li>
     <li>21 - Windows 8 x64</li>
     <li>23 - Windows 2012 x64</li>
     <li>1001 - Other</li>
     <li>1002 - Linux</li>
     <li>1003 - Red Hat Enterprise Linux 6.x</li>
     <li>1004 - SUSE Linux Enterprise Server 11</li>
     <li>1193 - SUSE Linux Enterprise Server 11</li>
     <li>1252 - Ubuntu Precise Pangolin LTS</li>
     <li>1253 - Ubuntu Quantal Quetzal</li>
     <li>1254 - Ubuntu Raring Ringtails</li>
     <li>1255 - Ubuntu Saucy Salamander</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>default_host</td>
   <td>uuid</td>
   <td>As displayed in the edit dialog, the ID of the default host in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>high_availability</td>
   <td>boolean</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>initialized</td>
   <td>boolean</td>
   <td>A flag to indicate if this VM was started at least once for Sysprep initialization purposes.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>stateless</td>
   <td>boolean</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>fail_back</td>
   <td>boolean</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>usb_policy</td>
   <td>smallint</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>time_zone</td>
   <td>character varying(40)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_pool_id</td>
   <td>uuid</td>
   <td>The virtual machine's pool unique ID.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_pool_name</td>
   <td>character varying(255)</td>
   <td>The name of the virtual machine's pool.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>created_by_user_id</td>
   <td>uuid</td>
   <td>The ID of the user that created this virtual machine.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>cluster_configuration_version</td>
   <td>integer</td>
   <td>The cluster configuration version at the time of creation or update. This is identical to the value of `history_id` in the `v4_2_configuration_history_clusters` view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>default_host_configuration_version</td>
   <td>integer</td>
   <td>The host configuration version at the time of creation or update. This is identical to the value of `history_id` in the `v4_2_configuration_history_hosts` view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Interface Configuration

The following table shows the configuration history parameters of the virtual interfaces in the system.

**v4_2_configuration_history_vms_interfaces**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `vm_interface_configuration_version` in the virtual machine interface statistics view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_id</td>
   <td>uuid</td>
   <td>Unique ID of the virtual machine in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_interface_id</td>
   <td>uuid</td>
   <td>The unique ID of this interface in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_interface_name</td>
   <td>character varying(50)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_interface_type</td>
   <td>smallint</td>
   <td>
    <p>The type of the virtual interface.</p>
    <ul>
     <li>0 - rt18139_pv</li>
     <li>1 - rt18139</li>
     <li>2 - e1000</li>
     <li>3 - pv</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_interface_speed_bps</td>
   <td>integer</td>
   <td>The average speed of the interface during the aggregation in bits per second.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>mac_address</td>
   <td>character varying(20)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>logical_network_name</td>
   <td>character varying(50)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_configuration_version</td>
   <td>integer</td>
   <td>The virtual machine configuration version at the time of creation or update. This is identical to the value of `history_id` in the `v4_2_configuration_history_vms` view and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
 </tbody>
</table>

### Virtual Machine Device Configuration

The following table shows the relationships between virtual machines and their associated devices, including disks and virtual interfaces.

**v4_2_configuration_history_vms_devices**

| Name | Type | Description | Indexed |
|-
| history_id  | integer      | The ID of the configuration version in the history database. | No |
| vm_id       | uuid         | The unique ID of the virtual machine in the system. | Yes |
| device_id   | uuid         | The unique ID of the device in the system. | No |
| type        | character varying(30)  | The type of virtual machine device. This can be "disk" or "interface". | Yes |
| address     | character varying(255) | The device's device physical address | No |
| is_managed  | boolean      | Flag that indicates if the device is managed by the Engine | No |
| is_plugged  | boolean      | Flag that indicates if the device is plugged into the virtual machine. | No |
| is_readonly | boolean      | Flag that indicates if the device is read only. | No |
| vm_configuration_version | integer | The virtual machine configuration version at the time the sample was taken. | No |
| device_configuration_version | integer | The device configuration version at the time the sample was taken. If the value of the `type` field is set to `interface`, this field is joined with the `history_id` field in the `v4_2_configuration_history_vms_interfaces` view. If the value of the `type` field is set to d`isk, this field is joined with the `history_id` field in the `v4_2_configuration_history_vms_disks` view. | No |
| create_date | timestamp with time zone | The date this entity was added to the system. |
| update_date timestamp | timestamp with time zone | The date this entity was added to the system. |
| delete_date | timestamp with time zone | The date this entity was added to the system. |

### Virtual Disk Configuration

The following table shows the configuration history parameters of the virtual disks in the system.

**v4_2_configuration_history_vms_disks**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
   <td>Indexed</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database. This is identical to the value of `vm_disk_configuration_version` in the virtual disks statistics views and it can be used to join them.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_disk_id</td>
   <td>uuid</td>
   <td>The unique ID of this disk in the system.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_disk_name</td>
   <td>text</td>
   <td>The name of the virtual disk, as displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_disk_description</td>
   <td>character varying(4000)</td>
   <td>As displayed in the edit dialog.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>image_id</td>
   <td>uuid</td>
   <td>The unique ID of the image in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>storage_domain_id</td>
   <td>uuid</td>
   <td>The ID of the storage domain this disk image belongs to.</td>
   <td>Yes</td>
  </tr>
  <tr>
   <td>vm_disk_size_mb</td>
   <td>integer</td>
   <td>The defined size of the disk in megabytes (MB).</td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_disk_type</td>
   <td>integer</td>
   <td>
    <p>As displayed in the edit dialog. Only System and data are currently used.</p>
    <ul>
     <li>0 - Unassigned</li>
     <li>1 - System</li>
     <li>2 - Data</li>
     <li>3 - Shared</li>
     <li>4 - Swap</li>
     <li>5 - Temp</li>
    </ul>
   </td>
   <td>No</td>
  </tr>
  <tr>
   <td>vm_disk_format</td>
   <td>integer</td>
   <td>
    <p>As displayed in the edit dialog.</p>
    <ul>
     <li>3 - Unassigned</li>
     <li>4 - COW</li>
     <li>5 - RAW</li>
    </ul>
    <td>No</td>
   </td>
  </tr>
  <tr>
   <td>is_shared</td>
   <td>boolean</td>
   <td>Flag that indicates if the virtual machine's disk is shared.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
   <td>No</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
   <td>No</td>
  </tr>
  </tbody>
 </table>

### User Details History

The following table shows the configuration history parameters of the users in the system.

**v4_2_users_details_history**

| Name | Type | Description |
|-
| user_id    | uuid         | The unique ID of the user in the system as generated by Engine. |
| first_name | character varying(255) | The user's first name. |
| last_name  | character varying(255) | The user's last name. |
| domain     | character varying(255) | The name of the authorization extension. |
| username   | character varying(255) | The account name |
| department | character varying(255) | The organizational department the user belongs to. |
| user_role_title | character varying(255) | The title or role of the user within the organization. |
| email      | character varying(255) | The email of the user in the organization. |
| external_id | text        | The unique identifier of the user from the external system. |
| active     | boolean      | If the user is active or not - this is being checked once in an hour, if the user can be found in the authorization extension then it will remain active. A user can be turned to active also on successful login. |
| create_date | timestamp with time zone | The date this entity was added to the system. |
| update_date | timestamp with time zone | The date this entity was changed in the system. |
| delete_date | timestamp with time zone | The date this entity was deleted from the system. |


**Prev:** [Statistics History Views](../Statistics_history_views)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/sect-configuration_history_views)
