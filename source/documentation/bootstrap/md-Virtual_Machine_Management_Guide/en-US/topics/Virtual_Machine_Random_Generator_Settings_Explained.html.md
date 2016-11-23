# Virtual Machine Random Generator Settings Explained

The following table details the options available on the **Random Generator** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Random Generator Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Random Generator enabled</b></td>
   <td>Selecting this check box enables a paravirtualized Random Number Generator PCI device (virtio-rng). This device allows entropy to be passed from the host to the virtual machine in order to generate a more sophisticated random number. Note that this check box can only be selected if the RNG device exists on the host and is enabled in the host's cluster.</td>
  </tr>
  <tr>
   <td><b>Period duration (ms)</b></td>
   <td>Specifies the duration of a period in milliseconds. If omitted, the libvirt default of 1000 milliseconds (1 second) is used. If this field is filled, <b>Bytes per period</b> must be filled also.</td>
  </tr>
  <tr>
   <td><b>Bytes per period</b></td>
   <td>Specifies how many bytes are permitted to be consumed per period.</td>
  </tr>
  <tr>
   <td><b>Device source:</b></td>
   <td>
    <p>The source of the random number generator. This is automatically selected depending on the source supported by the host's cluster.</p>
    <ul>
     <li><b>/dev/random source</b> - The Linux-provided random number generator.</li>
     <li><b>/dev/hwrng source</b> - An external hardware generator.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

**Important:** This feature is only supported with a host running Red Hat Enterprise Linux 6.6 and later or Red Hat Enterprise Linux 7.0 and later.
