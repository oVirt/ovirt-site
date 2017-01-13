# Datacenter Daily History View

Historical statistics for each data center in the system.

**Historical Statistics for Each Data Center in the System**

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
   <td>bigint</td>
   <td>The unique ID of this row in the table.</td>
  </tr>
  <tr>
   <td>history_datetime</td>
   <td>timestamp with time zone</td>
   <td>The timestamp of this history row (rounded to minute, hour, day as per the aggregation level).</td>
  </tr>
  <tr>
   <td>datacenter_id</td>
   <td>uuid</td>
   <td>The unique ID of the data center.</td>
  </tr>
  <tr>
   <td>datacenter_status</td>
   <td>smallint</td>
   <td>
    <ul>
     <li>-1 - <tt>Unknown Status</tt> (used only to indicate a problem with the ETL -- PLEASE NOTIFY SUPPORT)</li>
     <li>1 - <tt>Up</tt></li>
     <li>2 - <tt>Maintenance</tt></li>
     <li>3 - <tt>Problematic</tt></li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>minutes_in_status</td>
   <td>decimal</td>
   <td>The total number of minutes that the data center was in the status shown in the datacenter_status column for the aggregation period. For example, if a data center was up for 55 minutes and in maintenance mode for 5 minutes during an hour, two rows will show for this hour. One will have a datacenter_status of <tt>Up</tt> and minutes_in_status of 55, the other will have a datacenter_status of <tt>Maintenance</tt> and a minutes_in_status of 5.</td>
  </tr>
  <tr>
   <td>datacenter_configuration_version</td>
   <td>integer</td>
   <td>The data center configuration version at the time of sample.</td>
  </tr>
 </tbody>
</table>

**Prev:** [Statistics History Views](Statistics_history_views) <br>
**Next:** [Storage Domain Daily History View](Storage_domain_daily_history_view)
