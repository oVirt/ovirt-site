---
title: oVirt 4.4.6 Release Notes
category: documentation
authors:
  - lveyde
  - sandrobonazzola
toc: true
page_classes: releases
---


# oVirt 4.4.6 Release Notes

The oVirt Project is pleased to announce the availability of the 4.4.6 release as of May 4th, 2021.

oVirt is a free open-source distributed virtualization solution,
designed to manage your entire enterprise infrastructure.
oVirt uses the trusted KVM hypervisor and is built upon several other community
projects, including libvirt, Gluster, PatternFly, and Ansible.

This release is available now for Red Hat Enterprise Linux 8.3 and
CentOS Linux 8.3 (or similar) and CentOS Stream.

> **NOTE**
>
> Starting from oVirt 4.4.6 both oVirt Node and oVirt Engine Appliance are
> based on CentOS Stream.

{:.alert.alert-warning}
Please note that if you are upgrading oVirt Node from previous version you should remove CentOS Linux related yum configuration.
See Bug [1955617 - CentOS Repositories should be removed from yum.repo.d when upgrading to CentOS Stream](https://bugzilla.redhat.com/show_bug.cgi?id=1955617)
For more details.


To find out how to interact with oVirt developers and users and ask questions,
visit our [community page](/community/).
All issues or bugs should be reported via
[Red Hat Bugzilla](https://bugzilla.redhat.com/enter_bug.cgi?classification=oVirt).


If you'd like to try oVirt as quickly as possible, follow the instructions on
the [Download](/download/) page.

For complete installation, administration, and usage instructions, see
the [oVirt Documentation](/documentation/).

For a general overview of oVirt, read the [About oVirt](/community/about.html)
page.

To learn about features introduced before 4.4.6, see the
[release notes for previous versions](/documentation/#previous-release-notes).

## Known issues

### How to prevent hosts entering emergency mode after upgrade from oVirt 4.4.1

Due to **[[Bug 1837864]](https://bugzilla.redhat.com/show_bug.cgi?id=1837864) - Host enter emergency mode after upgrading to latest build**,

If you have your root file system on a multipath device on your hosts you should be aware that after upgrading from 4.4.1 to 4.4.6 you may get your host entering emergency mode.

In order to prevent this be sure to upgrade oVirt Engine first, then on your hosts:
1. Remove the current lvm filter while still on 4.4.1, or in emergency mode (if rebooted).
2. Reboot.
3. Upgrade to 4.4.6 (redeploy in case of already being on 4.4.6).
4. Run vdsm-tool config-lvm-filter to confirm there is a new filter in place.
5. Only if not using oVirt Node:
   - run "dracut --force --add multipath” to rebuild initramfs with the correct filter configuration
6. Reboot.


## What's New in 4.4.6?

### Release Note

#### oVirt Engine Data Warehouse

 - [BZ 1917874](https://bugzilla.redhat.com/show_bug.cgi?id=1917874) **[RFE] Add Resource size to Hosts/Virtual Machine Uptime panels**

   Add Resource size to Hosts/Virtual Machine Uptime panels:

Hosts Uptime (BR8) panel:

1. CPU Cores

2. Memory Size



Virtual Machine Uptime (BR46) panel:

1. CPU Cores

2. Memory Size

3. Disks Size


#### oVirt Engine

 - [BZ 1933672](https://bugzilla.redhat.com/show_bug.cgi?id=1933672) **Ansible security advisory RHSA-2021:0663 not included in RHV**

   RHV 4.4.6 now requires Ansible Engine 2.9.18

 - [BZ 1947403](https://bugzilla.redhat.com/show_bug.cgi?id=1947403) **Increase reboot timeout to 10 min.**

   By default we are waiting a certain amount of time defined by engine-config option ServerRebootTimeout before we consider that a hypervisor finished rebooting. Before oVirt 4.4.6 this timeout has been set to 5 minutes, but from 4.4.6 we are increasing the default to 10 minute. If this is not enough and hypervisors in your setup requires more time to finish rebooting, then please use below commant:



  engine-config -s ServerRebootTimeout=NNN



where NNN is number of seconds which engine waits until it tries to connect to the hypervisor after a reboot. ovirt-engine service needs to be restarted after above change to take effect.

 - [BZ 1926819](https://bugzilla.redhat.com/show_bug.cgi?id=1926819) **python-sdk iscsidiscover return iscsi_targets instead of iscsi_details**

   Host 'iscsi_discover' action has been deprecated.

Host 'discover_iscsi' action has been added to replace it.



The actions do the same thing but have different return values.



'discover_iscsi' returns the information in a 'iscsi_details' element.



'iscsi_discover' returns the information in a 'iscsi_targets' element.



In summary, the action which should be used from now on is 'discover_iscsi'.

 - [BZ 1933974](https://bugzilla.redhat.com/show_bug.cgi?id=1933974) **[RFE] Introduce Datacenter and cluster level 4.6**

   DataCenter and Cluster compatibility level 4.6 is introduced in oVirt Engine 4.4.6. Only hosts running on CentOS/RHEL 8.4 with Advanced Virtualization 8.4 (libvirt &gt;= 7.0.0) can join cluster level 4.6.



New features available in compatibility 4.6 are tracked as separate bugs depending on this bug.


#### VDSM

 - [BZ 1933974](https://bugzilla.redhat.com/show_bug.cgi?id=1933974) **[RFE] Introduce Datacenter and cluster level 4.6**

   DataCenter and Cluster compatibility level 4.6 is introduced in oVirt Engine 4.4.6. Only hosts running on CentOS/RHEL 8.4 with Advanced Virtualization 8.4 (libvirt &gt;= 7.0.0) can join cluster level 4.6.



New features available in compatibility 4.6 are tracked as separate bugs depending on this bug.


### Enhancements

#### oVirt Engine

 - [BZ 1113630](https://bugzilla.redhat.com/show_bug.cgi?id=1113630) **[RFE] indicate vNICs that are out-of-sync from their configuration on engine**



 - [BZ 1944723](https://bugzilla.redhat.com/show_bug.cgi?id=1944723) **[RFE] Support virtual machines with 16TB memory**

   In this version, we support running virtual machines with up to 16TB of RAM on x86_64.

 - [BZ 1669178](https://bugzilla.redhat.com/show_bug.cgi?id=1669178) **[RFE] Q35 SecureBoot - Add ability to preserve variable store certificates.**

   Secure Boot process relies on keys that are normally stored in NVRAM of the VM. However, NVRAM was not stored in previous versions of oVirt and was newly initialized on every start of a VM. This prevented the use of any custom drivers (e.g. for Nvidia devices or for PLDP drivers in SUSE) on VMs with Secure Boot enabled. To be able to use SecureBoot VMs effectively oVirt now persists the content of NVRAM for UEFI VMs.

 - [BZ 1936897](https://bugzilla.redhat.com/show_bug.cgi?id=1936897) **[Engine JDK 11] More verbose and configurable GC logging.**

   Feature:

More verbose and configurable GC logging. This includes:

1. GC verbose logging disabled by default with INFO verbosity level.



2. Ability to setup desired GC log level via config the property:

ENGINE_VERBOSE_GC_LOG_LEVEL=info

Available options are: off, error, warning, info, debug, trace



3. Ability to setup desired GC log file rotation via:

ENGINE_VERBOSE_GC_LOG_FILE_SIZE=2M  #single log file size

ENGINE_VERBOSE_GC_LOG_FILES_NUMBER=50 #number of files in rotation



Reason:

oVirt Engine tends to allocate large chunks of memory (depending on overall setup) that might contribute to potential various slow downs caused by Java Garbage Collector operations. 



Result:

The ability to monitor and discover memory related issues much earlier (before the issue is actually negatively impacting an environment)





In order to customize or disable the above default settings it is recommended to put these properties in one of the engine's etc config ie. /etc/ovirt-engine/engine.conf.d/99-setup-gc-logging.conf


#### oVirt Host Dependencies

 - [BZ 1933245](https://bugzilla.redhat.com/show_bug.cgi?id=1933245) **[RFE] Include smartmontools in RHVH Node image**

   


#### oVirt Hosted Engine HA

 - [BZ 1909888](https://bugzilla.redhat.com/show_bug.cgi?id=1909888) **[RFE] Support multiple IQN in hosted-engine.conf for Active-Active DR setup**

   With this release, ovirt-hosted-engine-ha supports multiple, comma-separated, values, for all iSCSI configuration items.


### Rebase: Bug Fixeses and Enhancementss

#### oVirt Engine Appliance

 - [BZ 1907831](https://bugzilla.redhat.com/show_bug.cgi?id=1907831) **Rebase ovirt-appliance on top of CentOS Stream 8**

   


#### oVirt Node NG Image

 - [BZ 1907833](https://bugzilla.redhat.com/show_bug.cgi?id=1907833) **Rebase oVirt Node on CentOS Stream 8**

   


### Bug Fixes

#### oVirt Engine

 - [BZ 1946502](https://bugzilla.redhat.com/show_bug.cgi?id=1946502) **engine-setup on a separate {dwh, websocket-proxy, grafana) machine fails**

 - [BZ 1932284](https://bugzilla.redhat.com/show_bug.cgi?id=1932284) **Engine handled FS freeze is not fast enough for Windows systems**


#### VDSM

 - [BZ 1902127](https://bugzilla.redhat.com/show_bug.cgi?id=1902127) **Sanlock exception during Lease.delete leaves lease UPDATING_FLAG in updating state, failing the next Lease.create and engine updates VM lease incorrectly.**

 - [BZ 1945675](https://bugzilla.redhat.com/show_bug.cgi?id=1945675) **delete-snapshot stress with extreme load- Vdsm aborts live merge job without aborting the libvirt block job**

 - [BZ 1940484](https://bugzilla.redhat.com/show_bug.cgi?id=1940484) **Consume  Bug 1931331 - libvirtd crashes in virEventThreadWorker**


#### imgbased

 - [BZ 1936972](https://bugzilla.redhat.com/show_bug.cgi?id=1936972) **[RHVH] Failed to reinstall persisted RPMs**


### Other

#### oVirt Engine Data Warehouse

 - [BZ 1861685](https://bugzilla.redhat.com/show_bug.cgi?id=1861685) **[RFE] Add filter to Inventory Dashboards**

   

 - [BZ 1935000](https://bugzilla.redhat.com/show_bug.cgi?id=1935000) **Add a minimal Grafana version as dependent**

   

 - [BZ 1853254](https://bugzilla.redhat.com/show_bug.cgi?id=1853254) **[RFE] Create links between reports**

   


#### oVirt Engine

 - [BZ 1958869](https://bugzilla.redhat.com/show_bug.cgi?id=1958869) **Import VM from export domain fails - the imported VM remains in 'image locked' state**

   

 - [BZ 1957253](https://bugzilla.redhat.com/show_bug.cgi?id=1957253) **[cinderlib] Enable using Managed Block Storage on 4.6 cluster by default**

   

 - [BZ 1956677](https://bugzilla.redhat.com/show_bug.cgi?id=1956677) **Snapshot merge fails with null pointer exception.**

   

 - [BZ 1957595](https://bugzilla.redhat.com/show_bug.cgi?id=1957595) **Failed to import VM from KVM**

   

 - [BZ 1950209](https://bugzilla.redhat.com/show_bug.cgi?id=1950209) **Leaf images used by the VM is deleted by the engine during snapshot merge**

   

 - [BZ 1906074](https://bugzilla.redhat.com/show_bug.cgi?id=1906074) **[RFE] Support disks copy between regular and managed block storage domains**

   

 - [BZ 1899453](https://bugzilla.redhat.com/show_bug.cgi?id=1899453) **Remove old Cinder integration from the UI**

   

 - [BZ 1954401](https://bugzilla.redhat.com/show_bug.cgi?id=1954401) **HP VMs pinning is wiped after edit-&gt;ok and pinned to first physical CPUs.**

   

 - [BZ 1950467](https://bugzilla.redhat.com/show_bug.cgi?id=1950467) **[CBT] VM backup failed after upgrade to 4.4.5. Invalid parameter: 'DiskType=SCRD'**

   

 - [BZ 1953558](https://bugzilla.redhat.com/show_bug.cgi?id=1953558) **[CBT] Unable to GET storage domain disks through API during a backup (when scratch disks created on the same SD)**

   

 - [BZ 1928158](https://bugzilla.redhat.com/show_bug.cgi?id=1928158) **Rename 'CA Certificate' link in welcome page to 'Engine CA certificate'**

   

 - [BZ 1950323](https://bugzilla.redhat.com/show_bug.cgi?id=1950323) **Missing title in the SSH public key management tooltip**

   

 - [BZ 1952075](https://bugzilla.redhat.com/show_bug.cgi?id=1952075) **Failed to migrate vm when migration encryption is enabled - upgrade-flow**

   

 - [BZ 1859921](https://bugzilla.redhat.com/show_bug.cgi?id=1859921) **GenericApiGWTService causing additional load on engine**

   

 - [BZ 1949798](https://bugzilla.redhat.com/show_bug.cgi?id=1949798) **Remove the replace-host options available with reinstall host workflow from administration portal**

   

 - [BZ 1952787](https://bugzilla.redhat.com/show_bug.cgi?id=1952787) **Chipset/firmware type setting doesn't work when creating vm pool**

   

 - [BZ 1900992](https://bugzilla.redhat.com/show_bug.cgi?id=1900992) **If there is no enough free space on the target domain while LSM is being performed, Live Merge (as part of LSM) fails but the event on the UI is not informative**

   

 - [BZ 1673059](https://bugzilla.redhat.com/show_bug.cgi?id=1673059) **[RFE] [UX] provide an indication that ISO domains are deprecated and Data Domains can/should now store ISOs**

   

 - [BZ 1952834](https://bugzilla.redhat.com/show_bug.cgi?id=1952834) **Failure during SSH stop/restart on FIPS enabled host**

   

 - [BZ 1952098](https://bugzilla.redhat.com/show_bug.cgi?id=1952098) **VM created from a template (the same to pools) doesn't inherit 'VirtIO-SCSI Multi Queues Enabled' setting**

   

 - [BZ 1930895](https://bugzilla.redhat.com/show_bug.cgi?id=1930895) **RHEL 8 virtual machine with qemu-guest-agent installed displays Guest OS Memory Free/Cached/Buffered: Not Configured**

   

 - [BZ 1948376](https://bugzilla.redhat.com/show_bug.cgi?id=1948376) **Failed to migrate vm when migration encryption is enabled - new deployments**

   

 - [BZ 1891851](https://bugzilla.redhat.com/show_bug.cgi?id=1891851) **Clarify the error-message in case of incorrect cpu-type set to a cluster**

   

 - [BZ 1951506](https://bugzilla.redhat.com/show_bug.cgi?id=1951506) **VM update fails on bios type check on PPC arch.**

   

 - [BZ 1950752](https://bugzilla.redhat.com/show_bug.cgi?id=1950752) **[RFE][CBT] redefine only the checkpoint that the backup is taken from and not the entire chain**

   

 - [BZ 1805808](https://bugzilla.redhat.com/show_bug.cgi?id=1805808) **[de_DE] Compute - Virtual Machines - New - Custom Properties: text truncated and overlapped with &gt;**

   

 - [BZ 1805796](https://bugzilla.redhat.com/show_bug.cgi?id=1805796) **[fr_FR] Compute - Virtual Machines - New - Random Generator: text truncated and overlapped with &gt;**

   

 - [BZ 1917718](https://bugzilla.redhat.com/show_bug.cgi?id=1917718) **[RFE] Collect memory usage from guests without ovirt-guest-agent and memory ballooning**

   

 - [BZ 1926018](https://bugzilla.redhat.com/show_bug.cgi?id=1926018) **Failed to run VM after FIPS mode is enabled**

   

 - [BZ 1821199](https://bugzilla.redhat.com/show_bug.cgi?id=1821199) **HP VM fails to migrate between identical hosts (the same cpu flags) not supporting TSC.**

   

 - [BZ 1948484](https://bugzilla.redhat.com/show_bug.cgi?id=1948484) **Failed to change CD in vm**

   

 - [BZ 1948500](https://bugzilla.redhat.com/show_bug.cgi?id=1948500) **Tpm model should be tpm-crb for x86_64 and tpm-spapr for ppc(RHV)**

   

 - [BZ 1910858](https://bugzilla.redhat.com/show_bug.cgi?id=1910858) **vm_ovf_generations is not cleared while detaching the storage domain causing VM import with old stale configuration**

   

 - [BZ 1927243](https://bugzilla.redhat.com/show_bug.cgi?id=1927243) **Cannot hotplug disk reports libvirtError: Requested operation is not valid: Domain already contains a disk with that address**

   

 - [BZ 1717411](https://bugzilla.redhat.com/show_bug.cgi?id=1717411) **improve engine logging when migration fail**

   

 - [BZ 1676708](https://bugzilla.redhat.com/show_bug.cgi?id=1676708) **[UI] hint after updating mtu on networks connected to running VMs and indicate vNICs out of sync**

   

 - [BZ 1621421](https://bugzilla.redhat.com/show_bug.cgi?id=1621421) **[RFE] indicate vNIC is out of sync on network QoS modification on engine**

   

 - [BZ 1917956](https://bugzilla.redhat.com/show_bug.cgi?id=1917956) **After restore, vm has warning Pending virtual machine changes : cluster cpu type**

   

 - [BZ 1936164](https://bugzilla.redhat.com/show_bug.cgi?id=1936164) **Enable KVM Software TPM by default**

   

 - [BZ 1932485](https://bugzilla.redhat.com/show_bug.cgi?id=1932485) **[RFE] Disks-only snapshots for VMs with TPM/NVRAM data**

   

 - [BZ 1892525](https://bugzilla.redhat.com/show_bug.cgi?id=1892525) **Cannot clone VM from Admin Portal if it has Direct LUN**

   

 - [BZ 1879032](https://bugzilla.redhat.com/show_bug.cgi?id=1879032) **If there is no master storage domain, the engine should elect one**

   

 - [BZ 1940764](https://bugzilla.redhat.com/show_bug.cgi?id=1940764) **Parsing of absurd variables seen from classes using jackson dependency to ansible-playbook while create-brick**

   

 - [BZ 1941518](https://bugzilla.redhat.com/show_bug.cgi?id=1941518) **[CBT] Scratch disk size should be equal to VM disk size for now**

   

 - [BZ 1942722](https://bugzilla.redhat.com/show_bug.cgi?id=1942722) **VM backup failed with RPC call Host.add_image_ticket failed (error 482)**

   

 - [BZ 1943267](https://bugzilla.redhat.com/show_bug.cgi?id=1943267) **Snapshot creation is failing for VM having vGPU.**

   

 - [BZ 1775145](https://bugzilla.redhat.com/show_bug.cgi?id=1775145) **Incorrect message from hot-plugging memory**

   

 - [BZ 1912691](https://bugzilla.redhat.com/show_bug.cgi?id=1912691) **[RFE] ticket classes should use SHA-256**

   

 - [BZ 1937310](https://bugzilla.redhat.com/show_bug.cgi?id=1937310) **[REST] live update of the network filter parameter does not update the libvirt XML on the host**

   

 - [BZ 1834250](https://bugzilla.redhat.com/show_bug.cgi?id=1834250) **CPU hotplug on UEFI VM causes VM reboot**

   

 - [BZ 1927718](https://bugzilla.redhat.com/show_bug.cgi?id=1927718) **[RFE] Provide Reset option for VMs**

   

 - [BZ 1937827](https://bugzilla.redhat.com/show_bug.cgi?id=1937827) **TPM device cannot be marked to be added to VM while it is running**

   

 - [BZ 1930282](https://bugzilla.redhat.com/show_bug.cgi?id=1930282) **vcpu pinning string for HP VM must be shown in UI(even if it must be disabled for editing)**

   

 - [BZ 1936163](https://bugzilla.redhat.com/show_bug.cgi?id=1936163) **Enable bochs-display for UEFI guests by default**

   

 - [BZ 1589763](https://bugzilla.redhat.com/show_bug.cgi?id=1589763) **[downstream clone] Error changing CD for a running VM when ISO image is on a block domain**

   

 - [BZ 1936185](https://bugzilla.redhat.com/show_bug.cgi?id=1936185) **[CBT] Scratch disk not removed if a VM goes to 'paused' state during the backup process**

   

 - [BZ 1934129](https://bugzilla.redhat.com/show_bug.cgi?id=1934129) **[Gluster] Unable to import existing gluster configuration into newly created cluster**

   

 - [BZ 1897049](https://bugzilla.redhat.com/show_bug.cgi?id=1897049) **[CBT][incremental backup] Multiple NullPointerExceptions during VM removal after backing up the VM and removing the backup checkpoints**

   


#### oVirt Release Package

 - [BZ 1954571](https://bugzilla.redhat.com/show_bug.cgi?id=1954571) **Ansible does not correctly detect distribution_version on oVirt Node based on CentOS Stream 8**

   


#### VDSM

 - [BZ 1950209](https://bugzilla.redhat.com/show_bug.cgi?id=1950209) **Leaf images used by the VM is deleted by the engine during snapshot merge**

   

 - [BZ 1589763](https://bugzilla.redhat.com/show_bug.cgi?id=1589763) **[downstream clone] Error changing CD for a running VM when ISO image is on a block domain**

   

 - [BZ 1868643](https://bugzilla.redhat.com/show_bug.cgi?id=1868643) **Volume not deactivated after ejecting CDROM**

   

 - [BZ 1906074](https://bugzilla.redhat.com/show_bug.cgi?id=1906074) **[RFE] Support disks copy between regular and managed block storage domains**

   

 - [BZ 1717411](https://bugzilla.redhat.com/show_bug.cgi?id=1717411) **improve engine logging when migration fail**

   

 - [BZ 1950752](https://bugzilla.redhat.com/show_bug.cgi?id=1950752) **[RFE][CBT] redefine only the checkpoint that the backup is taken from and not the entire chain**

   

 - [BZ 1933669](https://bugzilla.redhat.com/show_bug.cgi?id=1933669) **Improve live snapshot logs in case of aborting**

   

 - [BZ 1948532](https://bugzilla.redhat.com/show_bug.cgi?id=1948532) **Resize disk when vm is up fails, vm cannot be stopped**

   

 - [BZ 1940118](https://bugzilla.redhat.com/show_bug.cgi?id=1940118) **abrt-hook-ccpp[57365]: Process * (qemu-kvm) of user 107 killed by SIGABRT in live storage migration process**

   

 - [BZ 1946204](https://bugzilla.redhat.com/show_bug.cgi?id=1946204) **Hosted-engine fail to add first host**

   

 - [BZ 1821199](https://bugzilla.redhat.com/show_bug.cgi?id=1821199) **HP VM fails to migrate between identical hosts (the same cpu flags) not supporting TSC.**

   

 - [BZ 1946199](https://bugzilla.redhat.com/show_bug.cgi?id=1946199) **Cannot create Logical Volume ... Failed to wipe signatures**

   

 - [BZ 1943141](https://bugzilla.redhat.com/show_bug.cgi?id=1943141) **vGPU with SecureBoot and Nvidia enrolled key: NVRAM file got truncated after host crash.**

   

 - [BZ 1917718](https://bugzilla.redhat.com/show_bug.cgi?id=1917718) **[RFE] Collect memory usage from guests without ovirt-guest-agent and memory ballooning**

   

 - [BZ 1927718](https://bugzilla.redhat.com/show_bug.cgi?id=1927718) **[RFE] Provide Reset option for VMs**

   


#### oVirt Hosted Engine Setup

 - [BZ 1933191](https://bugzilla.redhat.com/show_bug.cgi?id=1933191) **ovirt-hosted-engine-cleanup should also cleanup ip -6 rules**

   

 - [BZ 1900591](https://bugzilla.redhat.com/show_bug.cgi?id=1900591) **hosted-engine deploy fails on AMD EPYC nested virtualization**

   

 - [BZ 1900551](https://bugzilla.redhat.com/show_bug.cgi?id=1900551) **[RFE] validate Engine VM domain if --restore-from-file**

   


#### oVirt Engine Appliance

 - [BZ 1918291](https://bugzilla.redhat.com/show_bug.cgi?id=1918291) **Remove unneeded packages from RHV-M appliance**

   


#### oVirt Engine database query tool

 - [BZ 1949543](https://bugzilla.redhat.com/show_bug.cgi?id=1949543) **rhv-log-collector-analyzer fails to run MAC Pools rule**

   


#### oVirt Ansible collection

 - [BZ 1924590](https://bugzilla.redhat.com/show_bug.cgi?id=1924590) **"FIPS mode is not enabled as required" error occur in "Enforce FIPS mode" task when deploying hosted engine**

   

 - [BZ 1948274](https://bugzilla.redhat.com/show_bug.cgi?id=1948274) **HE deployment checks host instead of appliance distribution when applying openscap profile**

   


#### MOM

 - [BZ 1945132](https://bugzilla.redhat.com/show_bug.cgi?id=1945132) **VDSM always reports ksmState as True, regardless of the cluster ksm configuration**

   


#### cockpit-ovirt

 - [BZ 1946095](https://bugzilla.redhat.com/show_bug.cgi?id=1946095) **"No valid network interface has been found" when starting HE deployment via cockpit**

   


#### oVirt Web Site

 - [BZ 1948429](https://bugzilla.redhat.com/show_bug.cgi?id=1948429) **Dependance issues occur when installing ovirt-hosted-engine-setup with RHEL8.4-host.**

   

 - [BZ 1906394](https://bugzilla.redhat.com/show_bug.cgi?id=1906394) **websocket proxy service - [Errno 13] Permission denied**

   


### No Doc Update

#### oVirt Engine Data Warehouse

 - [BZ 1928188](https://bugzilla.redhat.com/show_bug.cgi?id=1928188) **Failed to parse 'writeOps' value 'XXXX' to integer: For input string: "XXXX"**

   

 - [BZ 1870055](https://bugzilla.redhat.com/show_bug.cgi?id=1870055) **OVESETUP_GRAFANA_CONFIG/grafanaUser might be undefined**

   

 - [BZ 1919984](https://bugzilla.redhat.com/show_bug.cgi?id=1919984) **engine-setup failse to deploy the grafana service in an external DWH server**

   


#### oVirt Engine

 - [BZ 1953159](https://bugzilla.redhat.com/show_bug.cgi?id=1953159) **VM with next run configuration can't get IP after it's restarted becasue the VM's vNIC profile is set to &lt;Empty&gt;**

   

 - [BZ 1952369](https://bugzilla.redhat.com/show_bug.cgi?id=1952369) **[SR-IOV] [Failover] Can't unplug VM's vNIC if the failover vNIC profile has been changed**

   

 - [BZ 1935073](https://bugzilla.redhat.com/show_bug.cgi?id=1935073) **Ansible ovirt_disk module can create disks with conflicting IDs that cannot be removed**

   

 - [BZ 1952057](https://bugzilla.redhat.com/show_bug.cgi?id=1952057) **Indicate vNIC is out of sync on network VLAN modification on engine**

   

 - [BZ 1952353](https://bugzilla.redhat.com/show_bug.cgi?id=1952353) **Do not indicate vNIC is out of sync on network Host Qos modification on engine**

   

 - [BZ 1915207](https://bugzilla.redhat.com/show_bug.cgi?id=1915207) **[UI] user can create more than 1 network with the same name when checking the external provider check box**

   

 - [BZ 1950466](https://bugzilla.redhat.com/show_bug.cgi?id=1950466) **Host installation failed**

   

 - [BZ 1875363](https://bugzilla.redhat.com/show_bug.cgi?id=1875363) **engine-setup failing on FIPS enable rhel8 machine**

   

 - [BZ 1948491](https://bugzilla.redhat.com/show_bug.cgi?id=1948491) **When installing RHEL8.2 host in CL 4.4 installation fails on missing module virt:av**

   

 - [BZ 1928188](https://bugzilla.redhat.com/show_bug.cgi?id=1928188) **Failed to parse 'writeOps' value 'XXXX' to integer: For input string: "XXXX"**

   

 - [BZ 1930565](https://bugzilla.redhat.com/show_bug.cgi?id=1930565) **Host upgrade failed in imgbased but RHVM shows upgrade successful**

   

 - [BZ 1930522](https://bugzilla.redhat.com/show_bug.cgi?id=1930522) **[RHV-4.4.5.5] Failed to deploy RHEL AV 8.4.0 host to RHV with error "missing groups or modules: virt:8.4"**

   

 - [BZ 1919248](https://bugzilla.redhat.com/show_bug.cgi?id=1919248) **[CBT] Race condition in deleting checkpoints causes inconsistency and failed backups**

   


#### VDSM

 - [BZ 1955571](https://bugzilla.redhat.com/show_bug.cgi?id=1955571) **Verify if we still need to omit ifcfg and clevis dracut modules for properly working bridged network**

   

 - [BZ 1959945](https://bugzilla.redhat.com/show_bug.cgi?id=1959945) **[NBDE] RHVH 4.4.6 host fails to startup, without prompting for passphrase**

   

 - [BZ 1949995](https://bugzilla.redhat.com/show_bug.cgi?id=1949995) **Removing a network gateway causes the sync host networks to fail**

   

 - [BZ 1949048](https://bugzilla.redhat.com/show_bug.cgi?id=1949048) **unable to unplug vNIC based port-mirroring from running VM**

   

 - [BZ 1940569](https://bugzilla.redhat.com/show_bug.cgi?id=1940569) **Restart lldpad and fcoe services only if needed**

   


#### ovirt-engine-extension-aaa-ldap

 - [BZ 1896779](https://bugzilla.redhat.com/show_bug.cgi?id=1896779) **Unable to access LDAP server using IPv6 when both engine and LDAP are configured with IPv6 interfaces only, but DNS records for LDAP contains also IPv4 address**

   

 - [BZ 1940138](https://bugzilla.redhat.com/show_bug.cgi?id=1940138) **AAA - IPV6 detection needs to be disabled for LDAP hosts to be recognized**

   

 - [BZ 1941541](https://bugzilla.redhat.com/show_bug.cgi?id=1941541) **ldap setup fails to login with connection error when use dns is specified**

   


#### Contributors

57 people contributed to this release:

	Adam Feldman (Contributed to: mom)
	Ahmad Khiet (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Ales Musil (Contributed to: ovirt-engine, ovirt-site, vdsm)
	Andrej Krejcir (Contributed to: mom)
	Arik Hadas (Contributed to: ovirt-engine)
	Artur Socha (Contributed to: ovirt-engine)
	Asaf Rachmani (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup)
	Aviv Litman (Contributed to: ovirt-dwh)
	Aviv Turgeman (Contributed to: cockpit-ovirt)
	Bella Khizgiyaev (Contributed to: ovirt-engine)
	Ben Amsalem (Contributed to: ovirt-web-ui)
	Bence Santha (Contributed to: ovirt-site)
	Benny Zlotnik (Contributed to: ovirt-engine, ovirt-engine-sdk-go, ovirt-site, vdsm)
	Dan Kenigsberg (Contributed to: vdsm)
	Dana Elfassy (Contributed to: ovirt-engine)
	Douglas Schilling Landgraf (Contributed to: engine-db-query, ovirt-engine-sdk-go)
	Eitan Raviv (Contributed to: ovirt-engine)
	Eli Marcus (Contributed to: documentation)
	Eli Mesika (Contributed to: ovirt-engine, ovirt-engine-sdk-go)
	Evgeny Slutsky (Contributed to: ovirt-engine-sdk-go)
	Eyal Shenitzky (Contributed to: ovirt-engine, ovirt-engine-sdk, vdsm)
	Hilda Stastna (Contributed to: ovirt-engine)
	Huihui Fu (Contributed to: ovirt-engine-sdk-go)
	Jean-Louis Dupond (Contributed to: ovirt-dwh, ovirt-engine, vdsm)
	Joey Ma (Contributed to: ovirt-engine-sdk-go)
	Lev Veyde (Contributed to: imgbased, ovirt-appliance, ovirt-engine, ovirt-hosted-engine-ha, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Liran Rotenberg (Contributed to: ovirt-engine, vdsm)
	Lucia Jelinkova (Contributed to: ovirt-engine)
	Marc Dequènes (Duck) (Contributed to: ovirt-site)
	Marcin Sobczyk (Contributed to: vdsm)
	Martin Nečas (Contributed to: ovirt-ansible-collection)
	Martin Perina (Contributed to: ovirt-ansible-collection, ovirt-engine, ovirt-engine-extension-aaa-ldap, ovirt-site, vdsm)
	Michal Skrivanek (Contributed to: ovirt-engine, vdsm)
	Milan Zamazal (Contributed to: ovirt-engine, vdsm)
	Moti Asayag (Contributed to: ovirt-engine-sdk-go)
	Nick Bouwhuis (Contributed to: ovirt-engine)
	Nir Soffer (Contributed to: ovirt-engine-sdk, vdsm)
	Ori Liel (Contributed to: ovirt-engine, ovirt-engine-sdk, ovirt-engine-sdk-ruby)
	Pavel Bar (Contributed to: ovirt-engine)
	Prajith Kesava Prasad (Contributed to: ovirt-engine)
	Radoslaw Szwajkowski (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-web-ui)
	Ritesh Chikatwar (Contributed to: vdsm)
	Roberto Ciatti (Contributed to: ovirt-engine-sdk-go, ovirt-engine-sdk-ruby)
	Roman Bednar (Contributed to: vdsm)
	Roy Golan (Contributed to: ovirt-engine-sdk-go)
	Ryan Barry (Contributed to: mom)
	S.Mohammad Emami Razavi (Contributed to: ovirt-engine)
	Sandro Bonazzola (Contributed to: cockpit-ovirt, engine-db-query, ovirt-appliance, ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-sdk-go, ovirt-host, ovirt-hosted-engine-setup, ovirt-node-ng-image, ovirt-release, ovirt-site)
	Scott J Dickerson (Contributed to: cockpit-ovirt, ovirt-engine, ovirt-engine-nodejs-modules, ovirt-web-ui)
	Shani Leviim (Contributed to: ovirt-engine, ovirt-engine-sdk)
	Sharon Gratch (Contributed to: ovirt-engine, ovirt-engine-nodejs-modules, ovirt-engine-ui-extensions, ovirt-web-ui)
	Shmuel Melamud (Contributed to: ovirt-engine, vdsm)
	Steve Goodman (Contributed to: ovirt-site, documentation)
	Steven Rosenberg (Contributed to: ovirt-engine)
	Tomáš Golembiovský (Contributed to: mom, vdsm)
	Vojtech Juranek (Contributed to: ovirt-engine, vdsm)
	Yedidyah Bar David (Contributed to: ovirt-dwh, ovirt-engine, ovirt-hosted-engine-ha, ovirt-hosted-engine-setup)
