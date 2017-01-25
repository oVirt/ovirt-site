# Latest Host Interface Configuration View

The following table shows the configuration history parameters of the host interfaces in the system.

**v3_5_configuration_history_hosts_interfaces**

<table>
 <thead>
  <tr>
   <td>Name</td>
   <td>Type</td>
   <td>Description</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td>history_id</td>
   <td>integer</td>
   <td>The ID of the configuration version in the history database.</td>
  </tr>
  <tr>
   <td>host_interface_id</td>
   <td>uuid</td>
   <td>The unique ID of this interface in the system.</td>
  </tr>
  <tr>
   <td>host_interface_name</td>
   <td>varchar(50)</td>
   <td>The interface name as reported by the host.</td>
  </tr>
  <tr>
   <td>host_id</td>
   <td>uuid</td>
   <td>Unique ID of the host this interface belongs to.</td>
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
  </tr>
  <tr>
   <td>host_interface_speed_bps</td>
   <td>integer</td>
   <td>The interface speed in bits per second.</td>
  </tr>
  <tr>
   <td>mac_address</td>
   <td>varchar(20)</td>
   <td>The interface MAC address.</td>
  </tr>
  <tr>
   <td>logical_network_name</td>
   <td>varchar(50)</td>
   <td>The logical network associated with the interface.</td>
  </tr>
  <tr>
   <td>ip_address</td>
   <td>varchar(50)</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>gateway</td>
   <td>varchar(20)</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>bond</td>
   <td>Boolean</td>
   <td>A flag to indicate if this interface is a bonded interface.</td>
  </tr>
  <tr>
   <td>bond_name</td>
   <td>varchar(50)</td>
   <td>The name of the bond this interface is part of (if it is part of a bond).</td>
  </tr>
  <tr>
   <td>vlan_id</td>
   <td>integer</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>host_configuration_version</td>
   <td>integer</td>
   <td>The host configuration version at the time of creation or update.</td>
  </tr>
  <tr>
   <td>create_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was added to the system.</td>
  </tr>
  <tr>
   <td>update_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was changed in the system.</td>
  </tr>
  <tr>
   <td>delete_date</td>
   <td>timestamp with time zone</td>
   <td>The date this entity was deleted from the system.</td>
  </tr>
 </tbody>
</table>

**Prev:** [Latest Host Configuration View](../Latest_host_configuration_view) <br>
**Next:** [Latest Virtual Machine Configuration View](../Latest_virtual_machine_configuration_view)
