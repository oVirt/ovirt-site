# Data Center Configuration

The following table shows the configuration history parameters of the data centers in the system.

**v3_5_configuration_history_datacenters**

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
   <td>datacenter_id</td>
   <td>uuid</td>
   <td>The unique ID of the data center in the system.</td>
  </tr>
  <tr>
   <td>datacenter_name</td>
   <td>varchar(40)</td>
   <td>Name of the data center, as displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>datacenter_description</td>
   <td>varchar(4000)</td>
   <td>Description of the data center, as displayed in the edit dialog.</td>
  </tr>
  <tr>
   <td>storage_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>0 -Unknown</li>
     <li>1 - NFS</li>
     <li>2 - FCP</li>
     <li>3 - iSCSI</li>
     <li>4 - Local</li>
     <li>6 - All</li>
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
 </tbody>
</table>

