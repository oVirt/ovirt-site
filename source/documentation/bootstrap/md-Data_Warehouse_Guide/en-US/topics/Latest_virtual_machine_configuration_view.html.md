# Virtual Machine Configuration

The following table shows the configuration history parameters of the virtual machines in the system.


**v3_5_configuration_history_vms**

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
   <td>vm_id</td>
   <td>uuid</td>
   <td>The unique ID of this VM in the system.</td>
  </tr>
  <tr>
   <td>vm_name</td>
   <td>varchar(255)</td>
   <td>The name of the VM.</td>
  </tr>
  <tr>
   <td>vm_description</td>
   <td>varchar(4000)</td>
   <td>As displayed in the edit dialog.</td>
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
  </tr>
  <tr>
   <td>cluster_id</td>
   <td>uuid</td>
   <td>The unique ID of the cluster this VM belongs to.</td>
  </tr>
  <tr>
   <td>template_id</td>
   <td>uuid</td>
   <td>The unique ID of the template this VM is derived from. The field is for future use, as the templates are not synchronized to the history database in this version.</td>
  </tr>
  <tr>
   <td>template_name</td>
   <td>varchar(40)</td>
   <td>Name of the template from which this VM is derived.</td>
  </tr>
  <tr>
   <td>cpu_per_socket</td>
   <td>smallint</td>
   <td>Virtual CPUs per socket.</td>
  </tr>
  <tr>
   <td>number_of_sockets</td>
   <td>smallint</td>
   <td>Total number of virtual CPU sockets.</td>
  </tr>
  <tr>
   <td>memory_size_mb</td>
   <td>integer</td>
   <td>Total memory allocated to the VM, expressed in megabytes (MB).</td>
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
  </tr> 
  <tr>
   <td>default_host</td>
   <td>uuid</td>
   <td>As displayed in the edit dialog, the ID of the default host in the system.</td>
  </tr>
  <tr>
   <td>high_availability</td>
   <td>Boolean</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>initialized</td>
   <td>Boolean</td>
   <td>A flag to indicate if this VM was started at least once for Sysprep initialization purposes.</td>
  </tr>
  <tr>
   <td>stateless</td>
   <td>Boolean</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>fail_back</td>
   <td>Boolean</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>usb_policy</td>
   <td>smallint</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>time_zone</td>
   <td>varchar(40)</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>cluster_configuration_version</td>
   <td>integer</td>
   <td>The cluster configuration version at the time of creation or update.</td>
  </tr>
  <tr>
   <td>default_host_configuration_version</td>
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
  <tr>
   <td>vm_pool_id</td>
   <td>uuid</td>
   <td>The virtual machine's pool unique ID.</td>
  </tr>
  <tr>
   <td>vm_pool_name</td>
   <td>varchar(255)</td>
   <td>The name of the virtual machine's pool.</td>
  </tr>
 </tbody>
</table>

