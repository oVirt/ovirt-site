# Virtual Machine Initial Run Settings Explained

The following table details the options available on the **Initial Run** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows. The settings in this table are only visible if the **Use Cloud-Init/Sysprep** check box is selected, and certain options are only visible when either a Linux-based or Windows-based option has been selected in the **Operating System** list in the **General** tab, as outlined below.

**Virtual Machine: Initial Run Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Operating System</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Use Cloud-Init/Sysprep</b></td>
   <td>Linux, Windows</td>
   <td>This check box toggles whether Cloud-Init or Sysprep will be used to initialize the virtual machine.</td>
  </tr>
  <tr>
   <td><b>VM Hostname</b></td>
   <td>Linux, Windows</td>
   <td>The host name of the virtual machine.</td>
  </tr>
  <tr>
   <td><b>Domain</b></td>
   <td>Windows</td>
   <td>The Active Directory domain to which the virtual machine belongs.</td>
  </tr>
  <tr>
   <td><b>Organization Name</b></td>
   <td>Windows</td>
   <td>The name of the organization to which the virtual machine belongs. This option corresponds to the text field for setting the organization name displayed when a machine running Windows is started for the first time.</td>
  </tr>
  <tr>
   <td><b>Active Directory OU</b></td>
   <td>Windows</td>
   <td>The organizational unit in the Active Directory domain to which the virtual machine belongs.</td>
  </tr>
  <tr>
   <td><b>Configure Time Zone</b></td>
   <td>Linux, Windows</td>
   <td>The time zone for the virtual machine. Select this check box and select a time zone from the <b>Time Zone</b> list.</td>
  </tr>
  <tr>
   <td><b>Admin Password</b></td>
   <td>Windows</td>
   <td>
    <p>The administrative user password for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>Use already configured password</b>: This check box is automatically selected after you specify an initial administrative user password. You must clear this check box to enable the <b>Admin Password</b> and <b>Verify Admin Password</b> fields and specify a new password.</li>
     <li><b>Admin Password</b>: The administrative user password for the virtual machine. Enter the password in this text field and the <b>Verify Admin Password</b> text field to verify the password.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Authentication</b></td>
   <td>Linux</td>
   <td>
    <p>The authentication details for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>Use already configured password</b>: This check box is automatically selected after you specify an initial root password. You must clear this check box to enable the <b>Password</b> and <b>Verify Password</b> fields and specify a new password.</li>
     <li><b>Password</b>: The root password for the virtual machine. Enter the password in this text field and the <b>Verify Password</b> text field to verify the password.</li>
     <li><b>SSH Authorized Keys</b>: SSH keys to be added to the authorized keys file of the virtual machine. You can specify multiple SSH keys by entering each SSH key on a new line.</li>
     <li><b>Regenerate SSH Keys</b>: Regenerates SSH keys for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Custom Locale</b></td>
   <td>Windows</td>
   <td>
    <p>Custom locale options for the virtual machine. Locales must be in a format such as <tt>en-US</tt>. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>Input Locale</b>: The locale for user input.</li>
     <li><b>UI Language</b>: The language used for user interface elements such as buttons and menus.</li>
     <li><b>System Locale</b>: The locale for the overall system.</li>
     <li><b>User Locale</b>: The locale for users.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Networks</b></td>
   <td>Linux</td>
   <td>
    <p>Network-related settings for the virtual machine. Click the disclosure arrow to display the settings for this option.</p>
    <ul>
     <li><b>DNS Servers</b>: The DNS servers to be used by the virtual machine.</li>
     <li><b>DNS Search Domains</b>: The DNS search domains to be used by the virtual machine.</li>
     <li><b>Network</b>: Configures network interfaces for the virtual machine. Select this check box and click <b>+</b> or <b>-</b> to add or remove network interfaces to or from the virtual machine. When you click <b>+</b>, a set of fields becomes visible that can specify whether to use DHCP, and configure an IP address, netmask, and gateway, and specify whether the network interface will start on boot.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Custom Script</b></td>
   <td>Linux</td>
   <td>Custom scripts that will be run on the virtual machine when it starts. The scripts entered in this field are custom YAML sections that are added to those produced by the Manager, and allow you to automate tasks such as creating users and files, configuring <i>yum</i> repositories and running commands. For more information on the format of scripts that can be entered in this field, see the <a href="http://cloudinit.readthedocs.org/en/latest/topics/examples.html#yaml-examples">Custom Script</a> documentation.</td>
  </tr>
  <tr>
   <td><b>Sysprep</b></td>
   <td>Windows</td>
   <td>A custom Sysprep definition. The definition must be in the format of a complete unattended installation answer file. You can copy and paste the default answer files in the <tt>/usr/share/ovirt-engine/conf/sysprep/</tt> directory on the machine on which the Red Hat Virtualization Manager is installed and alter the fields as required.</td>
  </tr>
 </tbody>
</table>

