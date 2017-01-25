# Latest Virtual Machine Disk Configuration View

The following table shows the configuration history parameters of the virtual disks in the system.

**v3_5_configuration_history_vms_disks**



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
   <td>vm_disk_id</td>
   <td>uuid</td>
   <td>The unique ID of this disk in the system.</td>
  </tr>
  <tr>
   <td>vm_disk_description</td>
   <td>varchar(4000)</td>
   <td>As displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>storage_domain_id</td>
   <td>uuid</td>
   <td>The ID of the storage domain this disk image belongs to.</td>
  </tr>
  <tr>
   <td>vm_disk_size_mb</td>
   <td>integer</td>
   <td>The defined size of the disk in megabytes (MB).</td>
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
   </td>
  <tr>
  <tr>
   <td>vm_disk_interface</td>
   <td>integer</td>
   <td>
    <ul>
     <li>0 - IDE</li>
     <li>1 - SCSI (not supported)</li>
     <li>2 - VirtIO</li>
    </ul>
   </td>
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
   <td>is_shared</td>
   <td>Boolean</td>
   <td>Flag that indicates if the virtual machine's disk is shared.</td>
  </tr>
  <tr>
   <td>image_id</td>
   <td>uuid</td>
   <td>The unique ID of the image in the system.</td>
  </tr>
  </tbody>
 </table>


**Prev:** [Virtual Machine Device Configuration](../Virtual_Machine_Device_Configuration) <br>
**Next:** [User Details History](../User_Details_History)
