# Cluster Console Settings Explained

The table below describes the settings for the **Console** tab in the **New Cluster** and **Edit Cluster** windows.

**Console Settings**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Define SPICE Proxy for Cluster</b></td>
   <td>Select this check box to enable overriding the SPICE proxy defined in global configuration. This feature is useful in a case where the user (who is, for example, connecting via the User Portal) is outside of the network where the hypervisors reside.</td>
  </tr>
  <tr>
   <td><b>Overridden SPICE proxy address</b></td>
   <td>
    <p>The proxy by which the SPICE client will connect to virtual machines. The address must be in the following format:</p>
    <pre>protocol://[host]:[port]</pre>
   </td>
  </tr>
 </tbody>
</table>
