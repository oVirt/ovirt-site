# SPICE Logs for Guest Machines

**SPICE Logs for Guest Machines**

<table>
 <thead>
  <tr>
   <td>Log Type</td>
   <td>Log Location</td>
   <td>To Change Log Level:</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>Windows Guest</td>
   <td>
    <p>C:\Windows\Temp\vdagent.log</p>
    <p>C:\Windows\Temp\vdservice.log</p>
   </td>
   <td>Not applicable</td>
  </tr>
  <tr>
   <td>Red Hat Enterprise Linux Guest</td>
   <td>/var/log/spice-vdagent.log</td>
   <td>Create a <tt>/etc/sysconfig/spice-vdagentd</tt> file with this entry: <tt>SPICE_VDAGENTD_EXTRA_ARGS=”-d -d”</tt></td>
  </tr>
 </tbody>
</table>
