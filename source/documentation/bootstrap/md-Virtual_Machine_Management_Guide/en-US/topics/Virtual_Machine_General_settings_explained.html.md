# Virtual Machine General Settings Explained

The following table details the options available on the **General** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: General Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Cluster</b></td>
   <td>The name of the host cluster to which the virtual machine is attached. Virtual machines are hosted on any physical machine in that cluster in accordance with policy rules.</td>
  </tr>
  <tr>
   <td><b>Based on Template</b></td>
   <td>The template on which the virtual machine can be based. This field is set to <tt>Blank</tt> by default, which allows you to create a virtual machine on which an operating system has not yet been installed.</td>
  </tr>
  <tr>
   <td><b>Template Sub Version</b></td>
   <td>The version of the template on which the virtual machine can be based. This field is set to the most recent version for the given template by default. If no versions other than the base template are available, this field is set to <tt>base template</tt> by default. Each version is marked by a number in brackets that indicates the relative order of the versions, with higher numbers indicating more recent versions.</td>
  </tr>
  <tr>
   <td><b>Operating System</b></td>
   <td>The operating system. Valid values include a range of Red Hat Enterprise Linux and Windows variants.</td>
  </tr>
  <tr>
   <td><b>Instance Type</b></td>
   <td>
    <p>The instance type on which the virtual machine's hardware configuration can be based. This field is set to <b>Custom</b> by default, which means the virtual machine is not connected to an instance type. The other options available from this drop down menu are <b>Large</b>, <b>Medium</b>, <b>Small</b>, <b>Tiny</b>, <b>XLarge</b>, and any custom instance types that the Administrator has created.</p>
    <p>Other settings that have a chain link icon next to them are pre-filled by the selected instance type. If one of these values is changed, the virtual machine will be detached from the instance type and the chain icon will appear broken. However, if the changed setting is restored to its original value, the virtual machine will be reattached to the instance type and the links in the chain icon will rejoin.</p>
   </td>
  </tr>
  <tr>
   <td><b>Optimized for</b></td>
   <td>The type of system for which the virtual machine is to be optimized. There are two options: <b>Server</b>, and <b>Desktop</b>; by default, the field is set to <b>Server</b>. Virtual machines optimized to act as servers have no sound card, use a cloned disk image, and are not stateless. In contrast, virtual machines optimized to act as desktop machines do have a sound card, use an image (thin allocation), and are stateless.</td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the virtual machine. The name must be a unique name within the data center and must not contain any spaces, and must contain at least one character from A-Z or 0-9. The maximum length of a virtual machine name is 255 characters. The name can be re-used in different data centers in the environment.</td>
  </tr>
  <tr>
   <td><b>VM Id</b></td>
   <td>The virtual machine ID. The virtual machine's creator can set a custom ID for that virtual machine. If no ID is specified during creation a UUID will be automatically assigned. For both custom and automatically-generated IDs, changes are not possible after virtual machine creation.</td>
  </tr>    
  <tr>
   <td><b>Description</b></td>
   <td>A meaningful description of the new virtual machine.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text human-readable comments regarding the virtual machine.</td>
  </tr>
  <tr>
   <td><b>Stateless</b></td>
   <td>Select this check box to run the virtual machine in stateless mode. This mode is used primarily for desktop virtual machines. Running a stateless desktop or server creates a new COW layer on the VM hard disk image where new and changed data is stored. Shutting down the stateless VM deletes the new COW layer, which returns the VM to its original state. Stateless virtual machines are useful when creating machines that need to be used for a short time, or by temporary staff.</td>
  </tr>
  <tr>
   <td><b>Start in Pause Mode</b></td>
   <td>Select this check box to always start the virtual machine in pause mode. This option is suitable for virtual machines which require a long time to establish a SPICE connection; for example, virtual machines in remote locations.</td>
  </tr>
  <tr>
   <td><b>Delete Protection</b></td>
   <td>Select this check box to make it impossible to delete the virtual machine. It is only possible to delete the virtual machine if this check box is not selected.</td>
  </tr>
  <tr>
   <td><b>Instance Images</b></td>
   <td>
    <p>Click <b>Attach</b> to attach a floating disk to the virtual machine, or click <b>Create</b> to add a new virtual disk. Use the plus and minus buttons to add or remove additional virtual disks.</p>
    <p>Click <b>Edit</b> to reopen the <b>Attach Virtual Disks</b> or <b>New Virtual Disk</b> window. This button appears after a virtual disk has been attached or created.</p>
   </td>
  </tr>
  <tr>
   <td><b>Instantiate VM network interfaces by picking a vNIC profile.</b></td>
   <td>Add a network interface to the virtual machine by selecting a vNIC profile from the <b>nic1</b> drop-down list. Use the plus and minus buttons to add or remove additional network interfaces.</td>
  </tr>
 </tbody>
</table>
