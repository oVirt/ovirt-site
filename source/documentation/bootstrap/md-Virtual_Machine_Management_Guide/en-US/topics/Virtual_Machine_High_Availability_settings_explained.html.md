# Virtual Machine High Availability Settings Explained

The following table details the options available on the **High Availability** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: High Availability Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Highly Available</b></td>
   <td>
    <p>Select this check box if the virtual machine is to be highly available. For example, in cases of host maintenance, all virtual machines are automatically live migrated to another host. If the host crashed and is in a non-responsive state, only virtual machines with high availability are restarted on another host. If the host is manually shut down by the system administrator, the virtual machine is not automatically live migrated to another host.</p>
    <p>Note that this option is unavailable if the <b>Migration Options</b> setting in the <b>Hosts</b> tab is set to either <b>Allow manual migration only</b> or <b>Do not allow migration</b>. For a virtual machine to be highly available, it must be possible for the Manager to migrate the virtual machine to other available hosts as necessary.</p>
   </td>
  </tr>
  <tr>
   <td><b>Priority for Run/Migration queue</b></td>
   <td>Sets the priority level for the virtual machine to be migrated or restarted on another host.</td>
  </tr>
  <tr>
   <td><b>Watchdog</b></td>
   <td>
    <p>Allows users to attach a watchdog card to a virtual machine. A watchdog is a timer that is used to automatically detect and recover from failures. Once set, a watchdog timer continually counts down to zero while the system is in operation, and is periodically restarted by the system to prevent it from reaching zero. If the timer reaches zero, it signifies that the system has been unable to reset the timer and is therefore experiencing a failure. Corrective actions are then taken to address the failure. This functionality is especially useful for servers that demand high availability.</p>
    <p><b>Watchdog Model</b>: The model of watchdog card to assign to the virtual machine. At current, the only supported model is <b>i6300esb</b>.</p>
    <p><b>Watchdog Action</b>: The action to take if the watchdog timer reaches zero. The following actions are available:</p>
    <ul>
     <li><b>none</b> - No action is taken. However, the watchdog event is recorded in the audit log.</li>
     <li><b>reset</b> - The virtual machine is reset and the Manager is notified of the reset action.</li>
     <li><b>poweroff</b> - The virtual machine is immediately shut down.</li>
     <li><b>dump</b> - A dump is performed and the virtual machine is paused.</li>
     <li><b>pause</b> - The virtual machine is paused, and can be resumed by users.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>
