---
title: oVirt faq
authors: humble, sandrobonazzola
---

<!-- TODO: Content review -->

# oVirt FAQ

**1) Which network ports should be enabled when setting up oVirt environment?**

       54321                                : vdsm
       22                                   : ssh
       5634 - 6166                          : guest console access ports
       49152 - 49216                        : VM migration port range
       32023                                : Spice  usb redirection

**2) How can I change "vdsm" logging format or level?**

Edit  #/etc/vdsm/logger.conf 

**3) Which files are persisted by default with ovirt-node?**

The files inside `"/config/files"` are persisted by default.

**4) What would be the maximum boot time for ovirt node/hypervisor for *not* to be marked as "NON RESPONSIVE" in oVirt GUI?**

oVirt-engine will wait for two minutes before declaring ovirt-node as `"Non responsive"`.

**5) Vdsm/kvm does not detect "Full virtualization" even-though there are flags ( SVM or VMX) appreared in `/proc/cpuinfo` file, What should I do ?**

You may notice `"kvm is disabled in BIOS"` message in dmesg. Make sure that, you have done `"FULL POWER CYCLING"` after enabling `"Virtualization"` in BIOS of the system.

**6) What is the difference between `'Non responsive"` and `"Non operational"` hypervisor status in oVirt GUI?**

*'Non operational:'*

Something is wrong with the configuration of the oVirt Node.  The oVirt engine can still communicate with the ovirt-node, though.

It can be a failure in the connectivity of ovirt-node to any of the cluster components.  So make sure ovirt-node is capable of working with all the components defined for a cluster.

*'Non responsive:'*

The ovirt-engine cannot communicate with the ovirt-node via vdsm. In simple terms, there is a break in ovirt-engine->vdsm communcation path. It may be due to network split, dead vdsm, firewall, etc.

**7) How can I add more space in oVirt storage?**

It is better to assign new LUN from FC/ISCSI and "Edit" storage domain to make use of the new space. It is *not* supported when expanding LUN from SAN as ovirt-engine is not capable of updating itself with the change.

**8) What is meant by `"Image Locked"` status in oVirt GUI?**

All storage operations, such as create/delete VM/Template/Snapshot, will lock the VM image to perform the same. If the `"VM"` is continuing in `"Image Locked"` status for long time (it depends on the operation) it could be something wrong with it.

**9) I am getting errors when doing `"virt-v2v"` process, how to get more logs?**

	export LIBGUESTFS_TRACE=1
	export LIBGUESTFS_DEBUG=1

*The above `'env'` variables can produce hell lot of logs for the virt-v2v process Use it accordingly.*

**10) What are different values listed under `"status"` field of VM in the oVirt DB?**

       Unassigned = -1,
       Down = 0,
       Up = 1,
       PoweringUp = 2,
       PoweredDown = 3,
       Paused = 4,
       MigratingFrom = 5,
       MigratingTo = 6,
       Unknown = 7,
       NotResponding = 8,
       WaitForLaunch = 9,
       RebootInProgress = 10,
       SavingState = 11,
       RestoringState = 12,
       Suspended = 13,
       ImageIllegal = 14,
       ImageLocked = 15,
       PoweringDown = 16

**11) What are different values listed under `"status"` field of VDS (Hypervisor) in the oVirt DB?**

      Unassigned = 0,
      Down = 1,
      Maintenance = 2,
      Up = 3,
      NonResponsive = 4,
      Error=5,
      Installing=6,
      InstallFailed=7,
      Reboot=8,
      PreparingForMaintenance=9,
      NonOperational=10,
      PendingApproval=11,
      Initializing=12,
      Problematic=13

**12) What actions `"vdsbootstrapper"` performs at the time of registration?**

Steps to perform:

1. Check VT/SVM<br>
2. OS name + version<br>
3. Kernel version<br>
4. Check missing RPMs, install or update if needed<br>
5. Check missing VDS packages, install or update if needed<br>
6. Check switch configuration<br>
7. Initiate Certificate Initalization<br>
  a. Generate certificate and sign request<br>
  b. Submit sign request<br>
  c. Wait until signed certificate returns from VDC<br>
  d. Install certificate and keys for vdsm use.<br>
8. Reboot

**13) What are different table types available with oVirt DB?**

Static: static entity's data<br>
Dynamic: dynamic data<br>
Statistics: statistics info for History DB

**14) Will it cause an issue if I am restarting "vdsmd" in my ovirt-node?**

Running `service vdsmd restart` without placing the host on 'maintenance' mode on ovirt GUI, can cause following scenario:<br>
vdsmd restart on a host takes time, especially when the host is an SPM (Storage Pool Manager) - it should disconnect the storage, restart, and reconnect.<br>
ovirt-engine checks for a host aliveness each `"X" * "Y"` seconds 

Where `X= "ConfigurationTool.Hosts.Timeout_before_reset_Host" seconds` and `"Y" =  <ConfigurationTool.Hosts.Attempts_before_reset_Host>` times.

If the host is found not responsive (and it is such during vdsmd restart), ovirt-engine believes there is something wrong with the host and sends it a restart command.

The restart event is send to the host's fencing device.

**15) What are the requirements need to be met for detecting a LUN in oVirt GUI?**

1. The LUN should be raw (no filesystem, no LVM, no data)

2. The LUN should be larger than 10Gb in size

3. The LUN should be r/w accessible from the SPM host.

**16) How would I check whether `"KSM"` is active in my oVirt environment?**

KSM will come to action only when it satisfy below threshold:

	(phys - committed) < ksm_thres_coef percent * physical_mem

or

	(phys - committed) <  ksm_thres_const (in Mb)

Example:

	ksm_thres_coef=20
	ksm_thres_const=2048

**17) What are the default mount options used when oVirt node mounts a NFS storage or when configuring a NFS storage domain?**

      soft,timeo=10,retrans=6

**18) How would I read storage domain metadata in oVirt?**

The metadata has been added as volume groups "tags" in oVirt.  Use `vgs -o +tags` to check the metadata of storage domain.

**19) How may I remove an host in non responsive state from the manager if the host doesn't exist anymore?**
      You need to do "confirm host has been rebooted" since the host is not reachable and the engine can't connect to it and he doesn't know what's the status of the VMs that ran on it before rebooting. After that manual fence for host will start. You'll be able to remove the host once fencing finishes, it may take about five minutes.
