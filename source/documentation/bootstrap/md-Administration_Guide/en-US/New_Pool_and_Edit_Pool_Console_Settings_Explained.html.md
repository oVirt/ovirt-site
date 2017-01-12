# New Pool and Edit Pool Console Settings Explained

The following table details the information required on the **Console** tab of the **New Pool** or **Edit Pool** window that is specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Console settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Override SPICE proxy</b></td>
   <td>Select this check box to enable overriding the SPICE proxy defined in global configuration. This feature is useful in a case where the user (who is, for example, connecting via the User Portal) is outside of the network where the hosts reside.</td>
  </tr>
  <tr>
   <td><b>Overridden SPICE proxy address</b></td>
   <td>
    <p>The proxy by which the SPICE client will connect to virtual machines. This proxy overrides both the global SPICE proxy defined for the Red Hat Virtualization environment and the SPICE proxy defined for the cluster to which the virtual machine pool belongs, if any. The address must be in the following format:</p>
    <pre>protocol://[host]:[port]</pre>
   </td>
  </tr>
 </tbody>
</table>
