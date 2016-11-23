# Virtual Machine System Settings Explained

The following table details the options available on the **System** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: System Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Memory Size</b></td>
   <td>
    <p>The amount of memory assigned to the virtual machine. When allocating memory, consider the processing and storage needs of the applications that are intended to run on the virtual machine.</p>
    <p>Maximum guest memory is constrained by the selected guest architecture and the cluster compatibility level.</p>
   </td>
  </tr>
  <tr>
   <td><b>Total Virtual CPUs</b></td>
   <td>The processing power allocated to the virtual machine as CPU Cores. Do not assign more cores to a virtual machine than are present on the physical host.</td>
  </tr>
  <tr>
   <td><b>Virtual Sockets</b></td>
   <td>The number of CPU sockets for the virtual machine. Do not assign more sockets to a virtual machine than are present on the physical host.</td>
  </tr>
  <tr>
   <td><b>Cores per Virtual Socket</b></td>
   <td>The number of cores assigned to each virtual socket.</td>
  </tr>
  <tr>
   <td><b>Threads per Core</b></td>
   <td>The number of threads assigned to each core. Increasing the value enables simultaneous multi-threading (SMT). IBM POWER8 supports up to 8 threads per core. For x86 (Intel and AMD) CPU types, the recommended value is 1. </td>
  </tr>
  <tr>
   <td><b>Custom Emulated Machine</b></td>
   <td>This option allows you to specify the machine type. If changed, the virtual machine will only run on hosts that support this machine type. Defaults to the cluster's default machine type.</td>
  </tr>
  <tr>
   <td><b>Custom CPU Type</b></td>
   <td>This option allows you to specify a CPU type. If changed, the virtual machine will only run on hosts that support this CPU type. Defaults to the cluster's default CPU type.</td>
  </tr>
  <tr>
   <td><b>Time Zone</b></td>
   <td>This option sets the time zone offset of the guest hardware clock. For Windows, this should correspond to the time zone set in the guest. Most default Linux installations expect the hardware clock to be GMT+00:00.</td>
  </tr>
  <tr>
   <td><b>Provide custom serial number policy</b></td>
   <td>
    <p>This check box allows you to specify a serial number for the virtual machine. Select either:</p>
    <ul>
     <li><b>Host ID</b>: Sets the host's UUID as the virtual machine's serial number.</li>
     <li><b>Vm ID</b>: Sets the virtual machine's UUID as its serial number.</li>
     <li><b>Custom serial number</b>: Allows you to specify a custom serial number.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>
