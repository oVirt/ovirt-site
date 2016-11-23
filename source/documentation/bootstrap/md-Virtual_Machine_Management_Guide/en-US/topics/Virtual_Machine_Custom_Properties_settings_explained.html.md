# Virtual Machine Custom Properties Settings Explained

The following table details the options available on the **Custom Properties** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Virtual Machine: Custom Properties Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
   <td>Recommendations and Limitations</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>sap_agent</b></td>
   <td>Enables SAP monitoring on the virtual machine. Set to <b>true</b> or <b>false</b>.</td>
   <td>-</td>
  </tr>
  <tr>
   <td><b>sndbuf</b></td>
   <td>Enter the size of the buffer for sending the virtual machine's outgoing data over the socket. Default value is 0.</td>
   <td>-</td>
  </tr>
  <tr>
   <td><b>vhost</b></td>
   <td>
    <p>Disables vhost-net, which is the kernel-based virtio network driver on virtual network interface cards attached to the virtual machine. To disable vhost, the format for this property is:</p>
    <pre>LogicalNetworkName: false</pre>
    <p>This will explicitly start the virtual machine without the vhost-net setting on the virtual NIC attached to `LogicalNetworkName`.</p>
   </td>
   <td>vhost-net provides better performance than virtio-net, and if it is present, it is enabled on all virtual machine NICs by default. Disabling this property makes it easier to isolate and diagnose performance issues, or to debug vhost-net errors; for example, if migration fails for virtual machines on which vhost does not exist.</td>
  </tr>
  <tr>
   <td><b>viodiskcache</b></td>
   <td>Caching mode for the virtio disk. <b>writethrough</b> writes data to the cache and the disk in parallel, <b>writeback</b> does not copy modifications from the cache to the disk, and <b>none</b> disables caching. See <ulink url="https://access.redhat.com/solutions/2361311"/> for more information about the limitations of the <tt>viodiskcache</tt> custom property.</td>
   <td>If viodiskcache is enabled, the virtual machine cannot be live migrated.</td>
  </tr>
 </tbody>
</table>

**Warning:** Increasing the value of the sndbuf custom property results in increased occurrences of communication failure between hosts and unresponsive virtual machines.

