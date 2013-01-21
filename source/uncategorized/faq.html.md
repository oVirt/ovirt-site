---
title: Ovirt faq
authors: humble, sandrobonazzola
wiki_title: Ovirt faq
wiki_revision_count: 2
wiki_last_updated: 2014-05-15
---

# Ovirt faq

**\1**

       54321                                : vdsm
       22                                   : ssh
       5634 - 6166                          : guest console access ports
       49152 - 49216                        : VM migration port range
       32023                                : Spice  usb redirection

**\1**

      Edit  #/etc/vdsm/logger.conf 

**\1**

      The files inside ``"/config/files" `` are persisted by default.

**\1**

      Ovirt-engine will wait for 2 minutes before declaring ovirt-node as "Non responsive".

**\1**

      You may notice "kvm is disabled in BIOS" message in dmesg. Make sure that, you have done "FULL POWER CYCLING" after enabling "Virtualization" in BIOS of the system.

''' 6) What is the difference between `'Non responsive" ` and` "Non opearational"` hypervisor status in Ovirt GUI? '''

*'* Non-operational: *'*

             Means there is something wrong with the configuration of the Ovirt Node.  The ovirt engine can still communicate with the ovirt-node though.

             It can be a failure in the connectivity of ovirt-node to any of the cluster components.  So make sure ovirt-node is capable of working with all the components defined for a cluster.

*'* Non-responsive: *'*

             Means that the ovirt-engine cannot communicate with the ovirt-node via vdsm. In simple terms there is a break in ovrit-engine->vdsm communcation path. It may be due to network split, died vdsm, firewall..etc

**\1**

      Always it is better to assign new LUN from FC/ISCSI and "Edit" storage domain to make use of the new space. It is *NOT*    supported when expanding LUN from SAN as ovirt-engine is not capable of updating itself with the change.

**\1**

      All storage operations, such as create/delete VM/Template/Snapshot, will lock the VM image to perform the same. If the "VM" is continuing in "Image Locked" status for long time ( It depend on the operation) it could be something wrong with it.

**\1**

`
 export LIBGUESTFS_TRACE=1
 export LIBGUESTFS_DEBUG=1
 `

*'* Above 'env' variables can produce hell lot of logs for the virt-v2v process Use it accordingly. *'*

**\1**

       Unassigned = -1,
       Down = 0,
       Up = 1,
       PoweringUp = 2,
       PoweredDown = 3,
       Paused = 4,
       MigratingFrom = 5,
       MigratingTo = 6,
       Unknown = 7,
       NotResponding = 8,
       WaitForLaunch = 9,
       RebootInProgress = 10,
       SavingState = 11,
       RestoringState = 12,
       Suspended = 13,
       ImageIllegal = 14,
       ImageLocked = 15,
       PoweringDown = 16

**\1**

      Unassigned = 0,
      Down = 1,
      Maintenance = 2,
      Up = 3,
      NonResponsive = 4,
      Error=5,
      Installing=6,
      InstallFailed=7,
      Reboot=8,
      PreparingForMaintenance-9,
      NonOperational=10,
      PendingApproval=11,
      Initializing=12,
      Problematic=13

**\1**

           -- Steps to perform:
           -- 1. Check VT/SVM
           -- 2. OS name + version
           -- 3. Kernel version
           -- 4. Check missing RPMs
           --   a. Install or update if needed
           -- 5. Check missing VDS packages
           --   a. Install or update if needed
           -- 6. Check switch configuration
           -- 7. Initiate Certificate Initalization
           --   a. Generate certificate and sign request
           --   b. Submit sign request
           --   c. Wait until signed certificate returns from VDC
           --   d. Install certificate and keys for vdsm use.
           -- 8. Reboot

**\1**

      Static: static entity‟s data
      Dynamic: dynamic data
      Statistics: statistic info for History DB

**\1**

      ` Running `service vdsmd restart` without placing the host on 'maintenance' mode on ovirt GUI, can cause following scenario: `
      vdsmd restart on a host takes time, especially when the host is an SPM (Storage Pool Manager) - it should disconnect the  storage, restart and reconnect.
      Ovirt-engine checks for a host aliveness each "X" * "Y" seconds 

       where X= "ConfigurationTool.Hosts.Timeout_before_reset_Host" seconds & "Y" =  `<ConfigurationTool.Hosts.Attempts_before_reset_Host>`  times.

       If the host is  found not responsive (and it is such during vdsmd restart), ovirt-engine believe there is something wrong with the host and sends it a restart command.

       The restart event is send to the host's fencing device.

**\1**

       1. The LUN should be raw (no filesystem,no LVM, no data)
      2. The LUN should be larger than 10Gb in size
      3. The LUN should be r/w accessible from the SPM host.

**\1**

       KSM will come to action only when it satisfy below threshold:
      (phys - committed) < ksm_thres_coef percent * physical_mem
        or
      (phys - committed) <  ksm_thres_const (in Mb)
      ex:
      ksm_thres_coef=20
      ksm_thres_const=2048

**\1**

      soft,timeo=10,retrans=6

**\1**

       The metadata has been added as volume groups "tags" in Ovirt 3.  Use 'vgs -o +tags' to check the metadata of storage domain.
