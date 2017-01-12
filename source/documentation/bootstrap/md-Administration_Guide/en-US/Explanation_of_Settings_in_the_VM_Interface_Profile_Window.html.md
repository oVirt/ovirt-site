# Explanation of Settings in the VM Interface Profile Window

**VM Interface Profile Window**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Network</b></td>
   <td>A drop-down menu of the available networks to apply the vNIC profile.</td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the vNIC profile. This must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores between 1 and 50 characters.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>The description of the vNIC profile. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>QoS</b></td>
   <td>A drop-down menu of the available Network Quality of Service policies to apply to the vNIC profile. QoS policies regulate inbound and outbound network traffic of the vNIC.</td>
  </tr>
  <tr>
   <td><b>Passthrough</b></td>
   <td>
    <p>A check box to toggle the passthrough property. Passthrough allows a vNIC to connect directly to a virtual function of a host NIC. The passthrough property cannot be edited if the vNIC profile is attached to a virtual machine.</p>
    <p>Both QoS and port mirroring are disabled in the vNIC profile if passthrough is enabled.</p>
   </td>
  </tr>
  <tr>
   <td><b>Port Mirroring</b></td>
   <td>A check box to toggle port mirroring. Port mirroring copies layer 3 network traffic on the logical network to a virtual interface on a virtual machine. It it not selected by default. For further details, see <a href="https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/technical-reference/#Port_Mirroring">Port Mirroring</a> in the <i>Technical Reference</i>.</td>
  </tr>
  <tr>
   <td><b>Device Custom Properties</b></td>
   <td>A drop-down menu to select available custom properties to apply to the vNIC profile. Use the <b>+</b> and <b>-</b> buttons to add and remove properties respectively.</td>
  </tr>
  <tr>
   <td><b>Allow all users to use this Profile</b></td>
   <td>A check box to toggle the availability of the profile to all users in the environment. It is selected by default.</td>
  </tr>
 </tbody>
</table>





