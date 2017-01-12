# Logical Network General Settings Explained

The table below describes the settings for the **General** tab of the **New Logical Network** and **Edit Logical Network** window.

**New Logical Network and Edit Logical Network Settings**

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
   <td>The name of the logical network. This text field has a 15-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>The description of the logical network. This text field has a 40-character limit.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text, human-readable comments regarding the logical network.</td>
  </tr>
  <tr>
   <td><b>Create on external provider</b></td>
   <td>
    <p>Allows you to create the logical network to an OpenStack Networking instance that has been added to the Manager as an external provider.</p>
    <p><b>External Provider</b> - Allows you to select the external provider on which the logical network will be created.</p>
   </td>
  </tr>
  <tr>
   <td><b>Enable VLAN tagging</b></td>
   <td>VLAN tagging is a security feature that gives all network traffic carried on the logical network a special characteristic. VLAN-tagged traffic cannot be read by interfaces that do not also have that characteristic. Use of VLANs on logical networks also allows a single network interface to be associated with multiple, differently VLAN-tagged logical networks. Enter a numeric value in the text entry field if VLAN tagging is enabled.</td>
  </tr>
  <tr>
   <td><b>VM Network</b></td>
   <td>Select this option if only virtual machines use this network. If the network is used for traffic that does not involve virtual machines, such as storage communications, do not select this check box.</td>
  </tr>
  <tr>
   <td><b>MTU</b></td>
   <td>Choose either <b>Default</b>, which sets the maximum transmission unit (MTU) to the value given in the parenthesis (), or <b>Custom</b> to set a custom MTU for the logical network. You can use this to match the MTU supported by your new logical network to the MTU supported by the hardware it interfaces with. Enter a numeric value in the text entry field if <b>Custom</b> is selected.</td>
  </tr>
  <tr>
   <td><b>Network Label</b></td>
   <td>Allows you to specify a new label for the network or select from existing labels already attached to host network interfaces. If you select an existing label, the logical network will be automatically assigned to all host network interfaces with that label.</td>
  </tr>
 </tbody>
</table>
