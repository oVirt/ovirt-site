# Explanation of Settings in the New Data Center and Edit Data Center Windows

The table below describes the settings of a data center as displayed in the **New Data Center** and **Edit Data Center** windows. Invalid entries are outlined in orange when you click **OK**, prohibiting the changes being accepted. In addition, field prompts indicate the expected values or range of values.

**Data Center Properties**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the data center. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>The description of the data center. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Type</b></td>
   <td>
    <p>The storage type. Choose one of the following:</p>
    <ul>
     <li><b>Shared</b></li>
     <li><b>Local</b></li>
    </ul>
    <p>The type of data domain dictates the type of the data center and cannot be changed after creation without significant disruption. Multiple types of storage domains (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, though local and shared domains cannot be mixed.</p>
   </td>
  </tr>
  <tr>
   <td><b>Compatibility Version</b></td>
   <td>
    <p>The version of Red Hat Virtualization. Choose one of the following:</p>
    <ul>
     <li><b>3.6</b></li>
     <li><b>4.0</b></li>
    </ul>
    <p>After upgrading the Red Hat Virtualization Manager, the hosts, clusters and data centers may still be in the earlier version. Ensure that you have upgraded all the hosts, then the clusters, before you upgrade the Compatibility Level of the data center.</p>
   </td>
  </tr>
  <tr>
   <td><b>Quota Mode</b></td>
   <td>
    <p>Quota is a resource limitation tool provided with Red Hat Virtualization. Choose one of:</p>
    <ul>
     <li><b>Disabled</b>: Select if you do not want to implement Quota</li>
     <li><b>Audit</b>: Select if you want to edit the Quota settings</li>
     <li><b>Enforced</b>: Select to implement Quota</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>MAC Address Pool</b></td>
   <td>The MAC address pool of the data center. If no other MAC address pool is assigned the default MAC address pool is used. For more information on MAC address pools see <a href="sect-MAC_Address_Pools">MAC Address Pools</a></td>
  </tr>
 </tbody>
</table>
