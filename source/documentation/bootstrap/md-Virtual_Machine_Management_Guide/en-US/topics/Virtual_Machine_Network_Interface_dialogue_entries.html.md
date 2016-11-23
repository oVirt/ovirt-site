# Explanation of Settings in the New Network Interface and Edit Network Interface Windows

These settings apply when you are adding or editing a virtual machine network interface. If you have more than one network interface attached to a virtual machine, you can put the virtual machine on more than one logical network.

**Network Interface Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the network interface. This text field has a 21-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Profile</b></td>
   <td>Logical network that the network interface is placed on. By default, all network interfaces are put on the <b>ovirtmgmt</b> management network.</td>
  </tr>
  <tr>
   <td><b>Type</b></td>
   <td>The virtual interface the network interface presents to virtual machines. VirtIO is faster but requires VirtIO drivers. Red Hat Enterprise Linux 5 and higher includes VirtIO drivers. Windows does not include VirtIO drivers, but they can be installed from the guest tools ISO or virtual floppy disk. rtl8139 and e1000 device drivers are included in most operating systems.</td>
  </tr>
  <tr>
   <td><b>Custom MAC address</b></td>
   <td>Choose this option to set a custom MAC address. The Red Hat Virtualization Manager automatically generates a MAC address that is unique to the environment to identify the network interface. Having two devices with the same MAC address online in the same network causes networking conflicts.</td>
  </tr>
  <tr>
   <td><b>Link State</b></td>
   <td>
    <p>Whether or not the network interface is connected to the logical network.</p>
    <ul>
     <li>
      <p><b>Up</b>: The network interface is located on its slot.</p>
      <ul>
       <li>When the <b>Card Status</b> is <b>Plugged</b>, it means the network interface is connected to a network cable, and is active.</li>
       <li>When the <b>Card Status</b> is <b>Unplugged</b>, the network interface will be automatically connected to the network and become active.</li>
      </ul>
     </li>
     <li><b>Down</b>: The network interface is located on its slot, but it is not connected to any network. Virtual machines will not be able to run in this state.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Card Status</b></td>
   <td>
    <p>Whether or not the network interface is defined on the virtual machine.</p>
    <ul>
     <li>
      <p><tt>Plugged</tt>: The network interface has been defined on the virtual machine.</p>
      <ul>
       <li>If its <b>Link State</b> is <tt>Up</tt>, it means the network interface is connected to a network cable, and is active.</li>
       <li>If its <b>Link State</b> is <tt>Down</tt>, the network interface is not connected to a network cable.</li>
      </ul>
     </li>
     <li>
      <p><tt>Unplugged</tt>: The network interface is only defined on the Manager, and is not associated with a virtual machine.</p>
      <ul>
       <li>If its <b>Link State</b> is <tt>Up</tt>, when the network interface is plugged it will automatically be connected to a network and become active.</li>
       <li>If its <b>Link State</b> is <tt>Down</tt>, the network interface is not connected to any network until it is defined on a virtual machine.</li>
      </ul>
     </li>
    </ul>
   </td>
  </tr> 
 </tbody>
</table>

