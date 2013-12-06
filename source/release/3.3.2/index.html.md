---
title: OVirt 3.3.2 release notes
category: documentation
authors: dougsland, lvernia, sandrobonazzola, ybronhei
wiki_category: Documentation
wiki_title: OVirt 3.3.2 release notes
wiki_revision_count: 16
wiki_last_updated: 2013-12-19
---

# OVirt 3.3.2 release notes

The oVirt Project is preparing oVirt 3.3.2 beta release for testing. This page is still a work in progress.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3.1 release notes](oVirt 3.3.1 release notes), [oVirt 3.3 release notes](oVirt 3.3 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### BETA RELEASE

oVirt 3.3.2 is still in beta. In order to install it you've to enable oVirt beta repository.

If you're going to test oVirt 3.3.2 beta, please add yourself to [Testing/Ovirt 3.3.2 testing](Testing/Ovirt 3.3.2 testing).

### Fedora / CentOS / RHEL

If you're installing oVirt 3.3.2 on a clean host you should read our [Quick Start Guide](Quick Start Guide)

If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](oVirt 3.2 to 3.3 upgrade)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.1. Please read [oVirt 3.1 to 3.2 upgrade](oVirt 3.1 to 3.2 upgrade) before starting the upgrade.
On CentOS and RHEL: For upgrading to 3.2 you'll need 3.2 stable repository.
So, first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

      [ovirt-32]
      name=Stable builds of the oVirt 3.2 project
`baseurl=`[`http://ovirt.org/releases/3.2/rpm/EL/$releasever/`](http://ovirt.org/releases/3.2/rpm/EL/$releasever/)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

Then

      # yum update ovirt-engine-setup

should install ovirt-engine-setup-3.2.3-1.el6.noarch.rpm
if you have already updated to 3.3.x please use distro-sync or downgrade instead of update.
Then:

      # engine-upgrade

this will upgrade your system to latest 3.2.
Once you've all working on 3.2, enable 3.3/stable repository, then just

      # yum update ovirt-engine-setup
      # engine-setup

will upgrade to latest 3.3.

## What's New in 3.3.2?

### VM creation "Guide Me" sequence

The ability to add VM network interfaces has been dropped from the New VM "Guide Me" sequence, as they can now be added/removed directly in the New VM dialog. As always, administrators are encouraged to maintain templates which include networking configurations commonly used in their deployments of oVirt; for special cases, networking should now be configured in the New VM dialog instead of the "Guide Me" sequence.

### Backup and Restore API for Independent Software Vendors

oVirt now provides an API set for Independent Software Vendors to backup and restore virtual machines.
For backup, a snapshot of a virtual machine's disk is created then attached to a virtual appliance.
For restore, disks are attached to a virtual appliance, the data is restored to the disks, then the disks are attached to a virtual machine.

## Known issues

## Bugs fixed

### oVirt Engine

* [Text] Make clear that Pinning a VM to a host only takes effect on the next power up
 - [TEXT] [rhevm] - Webadmin - Incorrect error message when selecting multiple Hosts from different DCs and openging a report
 - [Admin Portal] Copying a quota drops consumers and permissions
 - PRD33 - [RFE] Backup and Restore API for Independent Software Vendors
 - Missing Quota for VM, proceeding since in Permissive (Audit) mode - VM name missing
 - engine: can't live migrate vm's disk after a failure because image already exists in the target
 - [rhevm] Hosts stuck in status “Unassigned”, “Connecting", "Non Responding” - when restrict connection from host to DC, for 5 minutes
 - [RHEVM-RHS] Should check for gluster capabilities when moving host from virt to gluster cluster
 - [TEXT] restore.sh woes, unable to restore engine DB without using '-u postgres'
 - Unable to put a host into maintenance because VMs previously managed by vdsm are running on the host
 - Missing correlation-Id for adding new host
 - [oVirt] [provider] It's seemingly possible to add a provider with the same name
 - UI issues in volume popup view
 - IP of rhevm bridge should be greyed out when rhevm has static IP configuration
 - [Neutron] Network name/ID is missing from error message when importing existing network ID on DC
 - There is no favicon
 - vnics subtab not updating properly
 - Copy template operation don't properly update storage resources of quota.
 - Failed Remove Storage Domain after restart “ovirt-engine” service
 - User has no information that service ovirt-scheduler-proxy is not running, thus his scheduler is not used.
 - Provide more informative error message and logs when there is no host which vm can run on.
 - backup/restore: support restoring to different database location
 - Make UseSecureConnectionWithServers config option availabe via rhevm-config
 - [rhevm] Webadmin - Events - Search box with value "Events: Templates.os =anything" doesnt filter (Shows all events)
 - Stateless VM with memory state snapshot fails to run due to "VolumeError: Bad volume specification"
 - [RHEVM][webadmin] Inaccurate message when importing a VM to a DC without a matching VNIC profile
 - [Admin Portal] Run-Once|Cloud-Init does not work correctly
 - [REST-API] Update power management agent type via CLI failed
 - Trying to import a template with 2 disks again after a previously failed import attempt fails because rollback doesn't delete the disk
 - Support lowering cluster CPU level.
 - Update VM pool name, description and size fail with NPE
 - Uninformative message when trying to import VM while the MAC address pool is depleted
 - [User Portal] OS type 'Linux' and (just) Windows has 'OS ?' icon (but 'Other Linux' has penguin)
 - [ja_JP][Admin Portal] Cluster tab -> Logical Networks subtab -> Manage Networks window -> horizontal scroll-bar added due to column width that is changing dynamically per locale
 - [AIO] Host does not resolve on NON loopback if ipv6 address is resolved at DNS
 - all-in-one: do not perform all in one installation if there are no cpu capabilities
 - [ALL_LANG][Admin_Portal][User_Portal] Header -> Guide -> Missing Language message unlocalized
 - [Admin Portal] link to documentation is broken + [text] Warning about missing English 'language pack' - should change to 'documentation'
 - Block multicast MAC addresses for VNICs
 - [RHEVM][webadmin] bad looking rectangle on advanced parameters expansion in New Network Interface dialog
 - [RHEVM][webadmin] rephrase error message on adding profile to nonVM network
 - [webadmin] pin left pane to dialog window in New logical network dialog
 - RHEVM Backend: Bad request error doesn't returns enough details (cannot understand from the error what was bad/missing in request)
 - /etc/sysconfig/nfs is deleted on cleanup
 - Number of images listed in glance domains shouldn't be limited by server-side configuration
 - [REST-API] no ssh-publickey support for install host action
 - The automatic install in RHEV-M 3.3 does not have all the values in the config file it uses.v  - "Resources" tab on the Power User Portal unable to display all virtual machine disks
 - [ovirt-engine-backend] cloud-init fake-cdrom is attached even during normal Run action
 - support for configurable attachment of VirtIO-SCSI controller
 - in PM only selecting apc or ipmilan changes the options, choosing other types is static
 - Remove support for IB700 watchdog
 - Scheduling: avoid running external plugins in validations
 - [User Portal] RDP browser plugin shows no error when there's no RDP connection to guest
 - [admin portal] cannot add Windows VM with 512MB memory, or more than 64GB
 - Missing permissions link at /neworks/network-id/vnicprofiles url
 - [rhevm] Backend - Error importing old template (WinXP & RHEL)
 - VmPoolMonitor throws a NullPointerException while starting a guest that in turn remains down with its images locked.
 - ovirt-engine 3rd party dependencies closeup
 - Edit Storage Domain dialog hangs when domain connected to “None” Data Center
 - Update VM NIC of a running VM accepts networks that don't exist on the host
 - log spam when using external load balancing
 - remove quota consumer dialog is stuck
 - CPU pinning option is not available for the VMs running on "Local on Host" type DataCenter.
 - Starting some of VMs to meet prestarted value of a pool fails because of snapshot issue
 - [pt-BR][Admin Portal] please extend New Cluster dialog to accommodate the check-box labels in "optimization" section
 - [restapi] undo snapshot preview through restapi commits snapshot instead of undoing preview
 - Power on VM fails after blocking HSM connectivity to SDs while LSM and powering off the VM
 - Cannot access Host with sshd alternative port after deployment.
 - [RESTAPI] wrong VM link for Template's watchdog
 - disks view under system tab are missing (refresh issue)
 - When adding new domain with -addPermissions param, it add permissions also for all other domains which are already added without -addPermissions param.
 - Quota isn't enforced in run VM
 - problems in engine-backup.sh
 - Expose instructions for configuration drop dir variables
 - Additional vNIC flickering on creating new VM
 - attempt to import Export domain as ISO domain creates an orphaned storage connection that prevents subsequent import of the domain as an Export domain
 - vm import: rhevm doesn't recognize that the template is present in the cluster when importing via webadmin
 - [notifier] SECURITY - notifier.log contains value of MAIL_PASSWORD if not empty
 - [notifier] MAIL_PORT_SSL ignored - javax.mail.MessagingException: Could not connect to SMTP host: smtp.corp.redhat.com, port: 465;
 - [engine-webadmin] [external-provider] no indication of disk export operation to glance
 - [host-deploy] print stderr content as error in audit log
 - Max Memory Over Commitment's units should use percentage and not "MB"
 - server.log is at debug priority after jboss update
 - [engine-webadmin] [text] inappropriate text message on UI when trying to scan alignment an unattached disk
 - Non migratables VM's cannot run without a specific host to run on
 - No manual for rhevm-cleanup command
 - engine-setup should not fail if /etc/sysconfig/nfs does not exist
 - GlusterFS mount succeeded and exists although the create storage domain failed
 - Wrong description of delete vnic profile's permission
 - [engine-backend] [external-provider] importing a snapshot image from glance fails with "Error during CanDoActionFailure.: java.lang.IllegalStateException: Connection manager has been shut down"
 - check database object ownership to engine before upgrade
 - engine-setup should not fail if /etc/ovirt-engine/.pgpass exists
 - [RHEVM] [webadmin] [UI] not enough space for nic10 in New Virtual Machine dialog
 - Incorrect java home detection
 - [RHEVM] [network] Audit log message for unmanaged network
 - Host moves to "UP" although it's already connected to another pool
 - Reconstruct isn't being executed as expected on different master version between engine and vdsm
 - [RHEVM][webadmin] vNIC profile screens are missing features
 - Database downtime causes OutOfConnection problem in ovirt, and even if the database restarts - an ovirt service restart is necessary
 - iptables rules set on U1 nodes does not include 8080 and 38469 for bigbend
 - [RHEVM][vNIC profiles] Block unsupported profiles from vNICs
 - [RHEVM] [webadmin] remove "add new nic" from Create new VM Guide me
 - [engine-backend] [external-provider] [glance] exporting a disk to glance storage domain does not lock the disk for the first few seconds
 - [engine-webadmin] [external-provider] [text] inappropriate text message on UI when trying to export a disk twice to glance storage domain
 - [DWH] ETL process doesn't recover from postgres restart
 - Windows 2008 Server as VM in RHEV-M 3.3 loads the HDA sound card and it needs the AC'97 instead.
 - vNIC profile name is overridden by network name
 - Add Network | QoS list not updated for profiles added with "+" button
 - [engine] Allocated size not calculated correctly for storage domains
 - disk stays in "image locked" status long after action (snapshot preview) failure when all related task are gone from vdsm and engine
 - Add osinfo configuration instruction and warning not to override defaults
 - Removing VM without removing its disks releases quota of the disks wrongfully
 - ovirt-engine is killed by oom-killer in is21
 - Required/non-required networks gone from setup networks dialog
 - inappropriate text message on UI when trying to scan alignment for disk
 - [engine] vm appears in 2 different rhev-h hosts (split brain)
 - Can't detach LUN: casting problem
 - engine-cleanup (and possible engine-setup) does not affect runtime value of shmmax
 - Host/Interface subtab unusable in old clusters
 - engine-cleanup (and possible engine-setup) does not affect runtime value of shmmax
 - Make the UseFqdnForRdpIfAvailable engine-config option available
 - Possibility to edit Network description and comment while attached to VMs
 - add NIC to VM failed on create VM from template
 - rhevm-setup fails do to missing 'file' tool
 - export isn't executed because of space check performed not only for relevant disks
 - memory volumes aren't being exported for diskless vms
 - taskcleaner.sh '-l' option does not produce logfile
 - when exporting vm with memory snapshots, the tasks for export the memory volumes are never cleaned
 - [RHEVM][webadmin] check if network profile exists on DC before creating VM
 - core/GUI: prevent potential serialization exceptions post upgrade to GWT 2.5
 - [engine-backend] cannot detach an unplugged disk from a running VM if the cluster doesn't support hotplug/hotunplug
 - when provisioning db engine-setup output confusing message about using existing credentials
 - /etc/exports is removed on cleanup
 - [engine-backend] Host doesn't move to UP although it connected succesfully to the pool
 - The GWT applications should use /api/ instead of /api to avoid sending credentials to /rhevm-reports
 - RHEL 6 VM gets ac97 soundcard (osinfo overrides broken?)
 - TryBackToAllSnapshotsOfVm threw NullPointerException during snapshot-preview because of random disk attached to VM
 - Unable to run regular yum update due to implicit (undeclared) version lock on rhevm-websocket-proxy
 - Updating info from Host fails when a VM without a balloon is found

### VDSM

### ovirt-node-plugin-vdsm

No bugs reported at moment.

<Category:Documentation> <Category:Releases>
