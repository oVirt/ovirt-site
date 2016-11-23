# Red Hat Virtualization Guest Agents and Drivers

The Red Hat Virtualization guest agents and drivers provide additional information and functionality for Red Hat Enterprise Linux and Windows virtual machines. Key features include the ability to monitor resource usage and gracefully shut down or reboot virtual machines from the User Portal and Administration Portal. Install the Red Hat Virtualization guest agents and drivers on each virtual machine on which this functionality is to be available.

**Red Hat Virtualization Guest Drivers**

<table>
 <thead>
  <tr>
   <td>Driver</td>
   <td>Description</td>
   <td>Works on</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><tt>virtio-net</tt></td>
   <td>Paravirtualized network driver provides enhanced performance over emulated devices like rtl.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-block</tt></td>
   <td>Paravirtualized HDD driver offers increased I/O performance over emulated devices like IDE by optimizing the coordination and communication between the guest and the hypervisor. The driver complements the software implementation of the virtio-device used by the host to play the role of a hardware device.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-scsi</tt></td>
   <td>Paravirtualized iSCSI HDD driver offers similar functionality to the virtio-block device, with some additional enhancements. In particular, this driver supports adding hundreds of devices, and names devices using the standard SCSI device naming scheme.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-serial</tt></td>
   <td>Virtio-serial provides support for multiple serial ports. The improved performance is used for fast communication between the guest and the host that avoids network complications. This fast communication is required for the guest agents and for other features such as clipboard copy-paste between the guest and the host and logging.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>virtio-balloon</tt></td>
   <td>Virtio-balloon is used to control the amount of memory a guest actually accesses. It offers improved memory over-commitment. The balloon drivers are installed for future compatibility but not used by default in Red Hat Virtualization.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>qxl</tt></td>
   <td>A paravirtualized display driver reduces CPU usage on the host and provides better performance through reduced network bandwidth on most workloads.</td>
   <td>Server and Desktop.</td>
  </tr>
 </tbody>
</table>

**Red Hat Virtualization Guest Agents and Tools**

<table>
 <thead>
  <tr>
   <td>Guest agent/tool</td>
   <td>Description</td>
   <td>Works on</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><tt>rhevm-guest-agent-common</tt></td>
   <td>
    <p>Allows the Red Hat Virtualization Manager to receive guest internal events and information such as IP address and installed applications. Also allows the Manager to execute specific commands, such as shut down or reboot, on a guest.</p>
    <p>On Red Hat Enterprise Linux 6 and higher guests, the rhevm-guest-agent-common installs <tt>tuned</tt> on your virtual machine and configures it to use an optimized, virtualized-guest profile.</p>
   </td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>spice-agent</tt></td>
   <td>The SPICE agent supports multiple monitors and is responsible for client-mouse-mode support to provide a better user experience and improved responsiveness than the QEMU emulation. Cursor capture is not needed in client-mouse-mode. The SPICE agent reduces bandwidth usage when used over a wide area network by reducing the display level, including color depth, disabling wallpaper, font smoothing, and animation. The SPICE agent enables clipboard support allowing cut and paste operations for both text and images between client and guest, and automatic guest display setting according to client-side settings. On Windows guests, the SPICE agent consists of vdservice and vdagent.</td>
   <td>Server and Desktop.</td>
  </tr>
  <tr>
   <td><tt>rhev-sso</tt></td>
   <td>An agent that enables users to automatically log in to their virtual machines based on the credentials used to access the Red Hat Virtualization Manager.</td>
   <td>Desktop.</td>
  </tr>
  <tr>
   <td><tt>rhev-usb</tt></td>
   <td>A component that contains drivers and services for Legacy USB support (version 3.0 and earlier) on guests. It is needed for accessing a USB device that is plugged into the client machine. <tt>RHEV-USB Client</tt> is needed on the client side.</td>
   <td>Desktop.</td>
  </tr>
 </tbody>
</table>

