# Virtual Machine Console Settings Explained

The following table details the options available on the **Console** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Console Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Graphics protocol</b></td>
   <td>Defines which display protocol to use. <b>SPICE</b> is the recommended protocol as it supports more features. <b>VNC</b> is an alternative option and requires a VNC client to connect to a virtual machine. Select <b>SPICE + VNC</b> for the most flexible option.</td>
  </tr>
  <tr>
   <td><b>VNC Keyboard Layout</b></td>
   <td>Defines the keyboard layout for the virtual machine. This option is only available when using the VNC protocol.</td>
  </tr>
  <tr>
   <td><b>USB Support</b></td>
   <td>
    <p>Defines whether USB devices can be used on the virtual machine. This option is only available for virtual machines using the SPICE protocol. Select either:</p>
    <ul>
     <li><b>Disabled</b> - Does not allow USB redirection from the client machine to the virtual machine.</li>
     <li><b>Legacy</b> - Enables the SPICE USB redirection policy used in Red Hat Enterprise Virtualization 3.0. This option can only be used on Windows virtual machines, and will not be supported in future versions of Red Hat Virtualization.</li>
     <li><b>Native</b> - Enables native KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual machines do not require any in-guest agents or drivers for native USB.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Monitors</b></td>
   <td>The number of monitors for the virtual machine. This option is only available for virtual desktops using the SPICE display protocol. You can choose <b>1</b>, <b>2</b> or <b>4</b>. Note that multiple monitors are not supported for Windows 8 and Windows Server 2012 virtual machines.</td>
  </tr>
  <tr>
   <td><b>Smartcard Enabled</b></td>
   <td>Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect Red Hat Virtualization virtual machines. Tick or untick the check box to activate and deactivate Smart card authentication for individual virtual machines.</td>
  </tr>
  <tr>
   <td><b>Disable strict user checking</b></td>
   <td>
    <p>Click the <b>Advanced Parameters</b> arrow and select the check box to use this option. With this option selected, the virtual machine does not need to be rebooted when a different user connects to it.</p>
    <p>By default, strict checking is enabled so that only one user can connect to the console of a virtual machine. No other user is able to open a console to the same virtual machine until it has been rebooted. The exception is that a <tt>SuperUser</tt> can connect at any time and replace a existing connection. When a <tt>SuperUser</tt> has connected, no normal user can connect again until the virtual machine is rebooted.</p>
    <p>Disable strict checking with caution, because you can expose the previous user's session to the new user.</p>
   </td>
  </tr>
  <tr>
   <td><b>Soundcard Enabled</b></td>
   <td>A sound card device is not necessary for all virtual machine use cases. If it is for yours, enable a sound card here.</td>
  </tr>
  <tr>
   <td><b>Enable VirtIO serial console</b></td>
   <td>The VirtIO serial console is emulated through VirtIO channels, using SSH and key pairs, and allows you to access a virtual machine's serial console directly from a client machine's command line, instead of opening a console from the Administration Portal or the User Portal. The serial console requires direct access to the Manager, since the Manager acts as a proxy for the connection, provides information about virtual machine placement, and stores the authentication keys. Select the check box to enable the VirtIO console on the virtual machine.</td>
  </tr>
  <tr>
   <td><b>Enable SPICE file transfer</b></td>
   <td>Defines whether a user is able to drag and drop files from an external host into the virtual machine's SPICE console. This option is only available for virtual machines using the SPICE protocol. This check box is selected by default.</td>
  </tr>
  <tr>
   <td><b>Enable SPICE clipboard copy and paste</b></td>
   <td>Defines whether a user is able to copy and paste content from an external host into the virtual machine's SPICE console. This option is only available for virtual machines using the SPICE protocol. This check box is selected by default.</td>
  </tr>
 </tbody>
</table>
