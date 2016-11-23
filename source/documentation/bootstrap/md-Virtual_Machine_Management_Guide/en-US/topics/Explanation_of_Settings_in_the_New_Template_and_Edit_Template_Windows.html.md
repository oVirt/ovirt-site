# Explanation of Settings in the New Template and Edit Template Windows

The following table details the settings for the **New Template** and **Edit Template** windows.

**New Template and Edit Template Settings**

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
   <td>The name of the template. This is the name by which the template is listed in the <b>Templates</b> tab in the Administration Portal and is accessed via the REST API. This text field has a 40-character limit and must be a unique name within the data center with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores. The name can be re-used in different data centers in the environment.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A description of the template. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text, human-readable comments regarding the template.</td>
  </tr>
  <tr>
   <td><b>Cluster</b></td>
   <td>The cluster with which the template is associated. This is the same as the original virtual machines by default. You can select any cluster in the data center.</td>
  </tr>
  <tr>
   <td><b>CPU Profile</b></td>
   <td>The CPU profile assigned to the template. CPU profiles define the maximum amount of processing capability a virtual machine can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. CPU profiles are defined on the cluster level based on quality of service entries created for data centers.</td>
  </tr>
  <tr>
   <td><b>Create as a Sub Template version</b></td>
   <td>
    <p>Specifies whether the template is created as a new version of an existing template. Select this check box to access the settings for configuring this option.</p>
    <ul>
     <li><b>Root Template</b>: The template under which the sub template is added.</li>
     <li><b>Sub Version Name</b>: The name of the template. This is the name by which the template is accessed when creating a new virtual machine based on the template.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Disks Allocation</b></td>
   <td>
    <p><b>Alias</b> - An alias for the virtual machine disk used by the template. By default, the alias is set to the same value as that of the source virtual machine.</p>
    <p><b>Virtual Size</b> - The total amount of disk space that a virtual machine based on the template can use. This value cannot be edited, and is provided for reference only. This value corresponds with the size, in GB, that was specified when the disk was created or edited.</p>
    <p><b>Target</b> - The storage domain on which the virtual disk used by the template is stored. By default, the storage domain is set to the same value as that of the source virtual machine. You can select any storage domain in the cluster.</p>
   </td>
  </tr>
  <tr>
   <td><b>Allow all users to access this Template</b></td>
   <td>Specifies whether a template is public or private. A public template can be accessed by all users, whereas a private template can only be accessed by users with the <b>TemplateAdmin</b> or <b>SuperUser</b> roles.</td>
  </tr>
  <tr>
   <td><b>Copy VM permissions</b></td>
   <td>Copies explicit permissions that have been set on the source virtual machine to the template.</td>
  </tr>
 </tbody>
</table>
