# Bonding Logic in Red Hat Virtualization

The Red Hat Virtualization Manager Administration Portal allows you to create bond devices using a graphical interface. There are several distinct bond creation scenarios, each with its own logic.

Two factors that affect bonding logic are:

* Are either of the devices already carrying logical networks?

* Are the devices carrying compatible logical networks?

**Bonding Scenarios and Their Results**

<table>
 <thead>
  <tr>
   <td>Bonding Scenario</td>
   <td>Result</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>NIC + NIC</td>
   <td>
    <p>The <b>Create New Bond</b> window is displayed, and you can configure a new bond device.</p>
    <p>If the network interfaces carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p>
   </td>
  </tr>
  <tr>
   <td>NIC + Bond</td>
   <td>
    <p>The NIC is added to the bond device. Logical networks carried by the NIC and the bond are all added to the resultant bond device if they are compatible.</p>
    <p>If the bond devices carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p>
   </td>
  </tr>
  <tr>
   <td>Bond + Bond</td>
   <td>
    <p>If the bond devices are not attached to logical networks, or are attached to compatible logical networks, a new bond device is created. It contains all of the network interfaces, and carries all logical networks, of the component bond devices. The <b>Create New Bond</b> window is displayed, allowing you to configure your new bond.</p>
    <p>If the bond devices carry incompatible logical networks, the bonding operation fails until you detach incompatible logical networks from the devices forming your new bond.</p>
   </td>
  </tr>
 </tbody>
</table>
