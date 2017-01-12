# Cluster Administrator Roles Explained

**Cluster Permission Roles**

The table below describes the administrator roles and privileges applicable to cluster administration.

**Red Hat Virtualization System Administrator Roles**

<table>
 <thead>
  <tr>
   <td>Role</td>
   <td>Privileges</td>
   <td>Notes</td>
  </tr>
 </thead>
 <tbody> 
  <tr>
   <td>ClusterAdmin</td>
   <td>Cluster Administrator</td>
   <td>
    <p>Can use, create, delete, manage all physical and virtual resources in a specific cluster, including hosts, templates and virtual machines. Can configure network properties within the cluster such as designating display networks, or marking a network as required or non-required.</p>
    <p>However, a <b>ClusterAdmin</b> does not have permissions to attach or detach networks from a cluster, to do so <b>NetworkAdmin</b> permissions are required.</p>
   </td>
  </tr>
  <tr>
   <td>NetworkAdmin</td>
   <td>Network Administrator</td>
   <td>Can configure and manage the network of a particular cluster. A network administrator of a cluster inherits network permissions for virtual machines within the cluster as well.</td>
  </tr>
 </tbody>
</table>
