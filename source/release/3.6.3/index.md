---
title: oVirt 3.6.3 Release Notes
category: documentation
toc: true
authors:
  - didi
  - sandrobonazzola
page_classes: releases
---

# oVirt 3.6.3 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.3 release
as of March 1st, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](/develop/release-management/releases/3.5.6/) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup


### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6/iso/ovirt-live/)

## What's New in 3.6.3?

<b>WebSocketProxy vdcoption requires a restart to become effective</b>

The WebSocketProxy VDC option(and a few others) can now be updated without need to restart the engine.
Here are the steps to reload the configuration on-the-fly:
* set: engine-config -s WebSocketProxy=NEW_VALUE
*   refresh cache via REST API POST call, i.e.:

      curl --silent --insecure --request POST --header "Accept: application/xml" --header "Content-Type: application/xml" --user "admin@internal:PWD" "http://localhost:8080/ovirt-engine/api/reloadconfigurations" --data '<action/>'

*   refresh GUI: Ctrl+R

Please note that support for reloading VDC options on-the-fly will be most probably dropped in oVirt 4.0.

<b>OVIRT-CLI now use remote-viewer instead of spicec for spice based console</b>
 
<b>unassigned host status now reflects more the real status</b>

The new status value of the host when it is being activated will be changed from 'Maintenance' to 'Activating' (used to be 'Unassigned')

<b>Disable cloud-init service after appliance deployment</b>

cloud-init services are now disabled on the engine-appliance after the initial deployment in order to speed up subsequent boots.
Updated windows-guest-tools iso with updated virtio-win drivers 0.1.112-1.

## Bugs fixed

### oVirt Engine

 - [BZ 1188229](https://bugzilla.redhat.com/1188229) - Change supported browser warning in GUI.
 - [BZ 1217405](https://bugzilla.redhat.com/1217405) - [engine-backup] --help point to "untrusted" url (ovirt.org)
 - [BZ 1249895](https://bugzilla.redhat.com/1249895) - [SetupNetworks] - Impossible to drag and attach some networks to Interfaces via SN if i have a multiple networks in the list
 - [BZ 1255405](https://bugzilla.redhat.com/1255405) - User with VmImporterExport on system can't import vm
 - [BZ 1258751](https://bugzilla.redhat.com/1258751) - Balancing not take in account vms that have specific host to run
 - [BZ 1258960](https://bugzilla.redhat.com/1258960) - MigrateToServer can fail with destination host unknown (the underlying issue is deeper though).
 - [BZ 1264733](https://bugzilla.redhat.com/1264733) - Deploy Windows Server 2012 R2 x64 fails to set admin password and join domain
 - [BZ 1265278](https://bugzilla.redhat.com/1265278) - User with all permission cannot create VM from scratch when 2 data centers are configured
 - [BZ 1265953](https://bugzilla.redhat.com/1265953) - It is possible to set a non numa host as preferred host
 - [BZ 1266099](https://bugzilla.redhat.com/1266099) - HA VMs are not restarted if hosted engine VM is on the same host and this host will crash
 - [BZ 1269433](https://bugzilla.redhat.com/1269433) - [ja_JP] Need to translate a string on user->event notifier->manage events pane.
 - [BZ 1272084](https://bugzilla.redhat.com/1272084) - During migration: execution failed: java.lang.Boolean cannot be cast to java.util.Map
 - [BZ 1273965](https://bugzilla.redhat.com/1273965) - libvirt error since managed non pluggable device was removed unexpectedly
 - [BZ 1275539](https://bugzilla.redhat.com/1275539) - Allocate memory for high resolutions/multihead
 - [BZ 1279159](https://bugzilla.redhat.com/1279159) - No auto-completion option for scheduling policy name under cluster object
 - [BZ 1279375](https://bugzilla.redhat.com/1279375) - Reintroduce checks for online CPUs for cpu pinning
 - [BZ 1281428](https://bugzilla.redhat.com/1281428) - Hostdev_passthrough: Template creation should not include attached VM devices.
 - [BZ 1284784](https://bugzilla.redhat.com/1284784) - NUMA node configuration is updated even if you hit cancel
 - [BZ 1289468](https://bugzilla.redhat.com/1289468) - When starting two vms simultaneously,  "Max free Memory for scheduling new VMs" is not updated fast enough
 - [BZ 1289868](https://bugzilla.redhat.com/1289868) - Host cannot be modified because of XML protocol not supported error
 - [BZ 1289961](https://bugzilla.redhat.com/1289961) - [Admin Portal] Error message in UI "Uncaught exception occurred. Please try reloading the page." when creating new pool.
 - [BZ 1289967](https://bugzilla.redhat.com/1289967) - Fade "Numa Pinning" button, in case if VM pinned to host that does not have "NUMA Support"
 - [BZ 1290088](https://bugzilla.redhat.com/1290088) - rename utility doesn't change ENGINE_BASE_URL for vmconsole-proxy-helper
 - [BZ 1290350](https://bugzilla.redhat.com/1290350) - [User portal] No error message while leaving 'username:' and 'password:' fields blank
 - [BZ 1290361](https://bugzilla.redhat.com/1290361) - "VDSM <host name> command failed: Virtual machine does not exist" error appears every time when shutting down a running VM
 - [BZ 1290528](https://bugzilla.redhat.com/1290528) - [upgrade] async_tasks_map is out of sync
 - [BZ 1293152](https://bugzilla.redhat.com/1293152) - New VM dialog offers VM templates from different DCs which are not accessible/usable
 - [BZ 1293269](https://bugzilla.redhat.com/1293269) - Various Frontend exceptions (e.g. switching clusters in VM dialog, edit VM, create VM from Template)
 - [BZ 1293299](https://bugzilla.redhat.com/1293299) - console does not work after reverting to a snapshot created in RHEV 3.5
 - [BZ 1294025](https://bugzilla.redhat.com/1294025) - Spice vm console fails because servlet pki-resource is unavailable
 - [BZ 1294488](https://bugzilla.redhat.com/1294488) - Edit blank template fail on that "Physical Memory Guaranteed" can't be 0 MB.
 - [BZ 1294501](https://bugzilla.redhat.com/1294501) - v2v: Cannot import VM as clone if the VM was already imported (not as clone).
 - [BZ 1294651](https://bugzilla.redhat.com/1294651) - Cannot change name of imported VM from VMware
 - [BZ 1295197](https://bugzilla.redhat.com/1295197) - unassigned host status should reflect more the real status
 - [BZ 1295455](https://bugzilla.redhat.com/1295455) - ca= is missing from the [ovirt] section of the vv.file
 - [BZ 1295659](https://bugzilla.redhat.com/1295659) - The title of remote-viewer window is incorrect when open a vm in RHEVM
 - [BZ 1295728](https://bugzilla.redhat.com/1295728) - Uncaught exception occurred when trying to open console if multiple VMs is selected
 - [BZ 1295778](https://bugzilla.redhat.com/1295778) - [audit_log] VDSM $hostname command failed: Internal JSON-RPC error.
 - [BZ 1296458](https://bugzilla.redhat.com/1296458) - Race condition in basic and power user portal
 - [BZ 1296593](https://bugzilla.redhat.com/1296593) - [RFE] v2v: notify in import dialog that attaching VirtIO drivers to Windows VM is essential.
 - [BZ 1296930](https://bugzilla.redhat.com/1296930) - ovirt-engine fails with "too many open files"
 - [BZ 1297202](https://bugzilla.redhat.com/1297202) - v2v: Source bootable disk value is not copied to target VM.
 - [BZ 1297404](https://bugzilla.redhat.com/1297404) - The vm consoles are not set correctly after the upgrade.
 - [BZ 1297490](https://bugzilla.redhat.com/1297490) - NPE is thrown in host setup networks dialog when trying configuring a host of higher version than the engine one
 - [BZ 1297751](https://bugzilla.redhat.com/1297751) - Graphics protocol of VM sometimes disappears when changed
 - [BZ 1298094](https://bugzilla.redhat.com/1298094) - Pool VMs get  UserVmManager role assigned automatically
 - [BZ 1298487](https://bugzilla.redhat.com/1298487) - Warn user when VMs with memory snapshots would end up in cluster with newer compatibility version
 - [BZ 1298580](https://bugzilla.redhat.com/1298580) - [REST] Attach network with boot protocol none via setupNetworks requires ip configuration details
 - [BZ 1298697](https://bugzilla.redhat.com/1298697) - The engine let the user remove the last regular storage domain
 - [BZ 1299232](https://bugzilla.redhat.com/1299232) - Hosts are stuck in 'installing'
 - [BZ 1299513](https://bugzilla.redhat.com/1299513) - Add warning when creating a snapshot on a VM with no guest tools installed
 - [BZ 1299630](https://bugzilla.redhat.com/1299630) - Edit network interface: General command validation failure
 - [BZ 1300757](https://bugzilla.redhat.com/1300757) - Create a VM from Template and restart the engine while the tasks are running might cause the VM to stay in lock status for ever
 - [BZ 1301340](https://bugzilla.redhat.com/1301340) - Error on removing Cinder disk snapshots
 - [BZ 1301345](https://bugzilla.redhat.com/1301345) - Nested FreeIPA/LDAP groups breaks aaa LDAP and aaa LDAP SSO authentication
 - [BZ 1301871](https://bugzilla.redhat.com/1301871) - Online Logical CPU Cores list - many entries results in corrupted display - host cannot be approved (see comment 5)
 - [BZ 1301902](https://bugzilla.redhat.com/1301902) - [RFE] remove log collector as mandatory dependency
 - [BZ 1301992](https://bugzilla.redhat.com/1301992) - The vm.placement_policy.affinity element isn't populated
 - [BZ 1302035](https://bugzilla.redhat.com/1302035) - [FC23] engine-setup fails with: Command 'semanage' is required but missing
 - [BZ 1302215](https://bugzilla.redhat.com/1302215) - Live merge operation fails noting Failed child command status for step 'DESTROY_IMAGE_CHECK'
 - [BZ 1303163](https://bugzilla.redhat.com/1303163) - Cannot login after upgrade from 3.5 to 3.6
 - [BZ 1303539](https://bugzilla.redhat.com/1303539) - Host in maintenance should  optionally stop glusterd services
 - [BZ 1303840](https://bugzilla.redhat.com/1303840) - A snapshot containing a Cinder disk remains locked when the engine restarts before the snapshot creation is completed
 - [BZ 1303842](https://bugzilla.redhat.com/1303842) - Mixed CPU cluster, migration failing: "libvirtError: unsupported configuration: NUMA node 1 is unavailable"
 - [BZ 1304007](https://bugzilla.redhat.com/1304007) - [Cinder] Creation of a snapshot with cinder disks is reported as failed: "Failed to complete snapshot.."
 - [BZ 1304405](https://bugzilla.redhat.com/1304405) - Copying a disk converts the volume type to SHARED
 - [BZ 1304773](https://bugzilla.redhat.com/1304773) - Unable to edit fence agents
 - [BZ 1304784](https://bugzilla.redhat.com/1304784) - REST API: Unable to delete custom properties from NIC with old SN API
 - [BZ 1304787](https://bugzilla.redhat.com/1304787) - REST API: Custom properties are not reported under Host NIC (broken backward compatibility)
 - [BZ 1305484](https://bugzilla.redhat.com/1305484) - Disable editing of the hosted engine VM and storage (like rename) actions.
 - [BZ 1305809](https://bugzilla.redhat.com/1305809) - [Cinder] - Running a stateless VM leaves a locked snapshot and the VM cannot be started
 - [BZ 1305945](https://bugzilla.redhat.com/1305945) - All fields in edit VM disk dialog are wrongly editable
 - [BZ 1306367](https://bugzilla.redhat.com/1306367) - Live Merge - recovery flow not working properly when DESTROY_IMAGE_CHECK command fails
 - [BZ 1306406](https://bugzilla.redhat.com/1306406) - About to run task 'java.util.concurrent.FutureTask' from: java.lang.Exception
 - [BZ 1308336](https://bugzilla.redhat.com/1308336) - [SetupNetworks old API] update network to have IP cause the network to be out of sync
 - [BZ 1309562](https://bugzilla.redhat.com/1309562) - add a config option for showing UI exception pop-up
 - [BZ 1310541](https://bugzilla.redhat.com/1310541) - SuperUser permit returns 'operation failed'
 - [BZ 1311027](https://bugzilla.redhat.com/1311027) - Prevent upgrade of engine to 3.6 if it's a hosted-engine on el6 hosts
 - [BZ 1312636](https://bugzilla.redhat.com/1312636) - Editing a running VM seems to be broken
 - [BZ 1312649](https://bugzilla.redhat.com/1312649) - [Webadmin] Failed to attach an ISO domain to a DC from the webadmin

### VDSM

 - [BZ 1151863](https://bugzilla.redhat.com/1151863) - Error during successful migration: [Errno 9] Bad file descriptor
 - [BZ 1167322](https://bugzilla.redhat.com/1167322) - disable ksmtuned.service during host installation
 - [BZ 1226911](https://bugzilla.redhat.com/1226911) - vmchannel thread consumes 100% of CPU
 - [BZ 1253043](https://bugzilla.redhat.com/1253043) - Ghost VMs created with prefix "external-" by "null@N/A"
 - [BZ 1269424](https://bugzilla.redhat.com/1269424) - VDSM memory leak
 - [BZ 1271575](https://bugzilla.redhat.com/1271575) - [vdsm] nofiles impact hardly host - OSError: [Errno 24] Too many open files
 - [BZ 1271771](https://bugzilla.redhat.com/1271771) - vdsm reports that the storage domain is active, when in fact it's missing a link to it
 - [BZ 1295428](https://bugzilla.redhat.com/1295428) - VM memory usage is not reported correctly
 - [BZ 1295778](https://bugzilla.redhat.com/1295778) - [audit_log] VDSM $hostname command failed: Internal JSON-RPC error.
 - [BZ 1296936](https://bugzilla.redhat.com/1296936) - Vm.status() causes crash of MoM GuestManager
 - [BZ 1301349](https://bugzilla.redhat.com/1301349) - [SR-IOV] - vdsm should persist and restore the number of enabled VFs on a PF during reboots
 - [BZ 1305338](https://bugzilla.redhat.com/1305338) - Issue with vdsm-hook-vmfex-dev-4.16.33-1 - "InvalidatedWeakRef"
 - [BZ 1306196](https://bugzilla.redhat.com/1306196) - VFIO: device passthrough is not enabled by default on PPC platforms.

### oVirt Log Collector

 - [BZ 1288197](https://bugzilla.redhat.com/1288197) - RHEV engine-log-collector with --local-tmp=PATH option deletes PATH once command is executed

### oVirt Reports

 - [BZ 1257797](https://bugzilla.redhat.com/1257797) - Memory amount in Clusters Capacity report is rounded down
 - [BZ 1300240](https://bugzilla.redhat.com/1300240) - Typo in cluster planning report

### MOM

 - [BZ 1294833](https://bugzilla.redhat.com/1294833) - XMLRPC API of mom breaks on host with 193270 MiB ram

### oVirt Hosted Engine Setup

 - [BZ 1287397](https://bugzilla.redhat.com/1287397) - Warning messages observed while using glusterfs as storage during hosted-engine setup
 - [BZ 1291083](https://bugzilla.redhat.com/1291083) - [hosted-engine] - Adjust management network settings when deployed over VLAN interface/s
 - [BZ 1299200](https://bugzilla.redhat.com/1299200) - Disable cloud-init service after appliance deployment
 - [BZ 1300245](https://bugzilla.redhat.com/1300245) - hosted-engine setup proposes as a default to use all the available RAM for the engine VM also if bigger than the value in the appliance OVF
 - [BZ 1303716](https://bugzilla.redhat.com/1303716) - changing HE storage domain name causes HE storage and VM import failure
 - [BZ 1308333](https://bugzilla.redhat.com/1308333) - Hosted Engine deployment failed

### oVirt Hosted Engine HA

 - [BZ 1295427](https://bugzilla.redhat.com/1295427) - hosted engine doesnt start - fails during storage server upgrade
 - [BZ 1303316](https://bugzilla.redhat.com/1303316) - vm.conf does not get updated if hosted engine is installed on block storage

### windows-guest-tools-iso

Fixed a bug in the included ovirt-guest-agent:
 - [BZ 1117504](https://bugzilla.redhat.com/show_bug.cgi?id=1117504) - Constant, repeating messages "User <x> is connected to vm <y> in Events

