# Storage Domain Configuration

The following table shows the configuration history parameters of the storage domains in the system.

**v3_5_configuration_history_storage_domains**

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
   <td>storage_domain_id</td>
   <td>uuid</td>
   <td>The unique ID of this storage domain in the system.</td>
  </tr>
  <tr>
   <td>storage_domain_name</td>
   <td>varchar(250)</td>
   <td>Storage domain name.</td>
  </tr>
  <tr>
   <td>storage_domain_type</td>
   <td>smallint</td>
   <td>
    <ul>
     <li> 0 - Data (Master)</li>
     <li>1 - Data</li>
     <li>2 - ISO</li>
     <li>3 - Export</li>
    </ul>
   </td>
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

