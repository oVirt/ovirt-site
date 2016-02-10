---
title: OVirt 3.6.3 Release Notes
category: documentation
authors: didi, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.6.3 Release Notes
wiki_revision_count: 19
wiki_last_updated: 2016-02-17
---

# OVirt 3.6.3 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.6.3 second release candidate as of February 10th, 2016.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Red Hat Enterprise Linux 6.7, CentOS Linux 6.7 (or similar) and Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

### CANDIDATE RELEASE

In order to install oVirt 3.6.3 Release Candidate you've to enable oVirt 3.6 release candidate repository.

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.6.repo**

**For CentOS / RHEL:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever`](http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/el$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6)

**For Fedora:**

      [ovirt-3.6-pre]
      name=Latest oVirt 3.6 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever`](http://resources.ovirt.org/pub/ovirt-3.6-pre/rpm/fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1
`gpgkey=`[`file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6`](file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-3.6)

If you are upgrading from a previous version, you may have the ovirt-release35 package already installed on your system. You can then install ovirt-release36.rpm as in a clean install side-by-side.

Once ovirt-release36 package is installed, you will have the ovirt-3.6-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.6.3 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.5.0, you must first upgrade to oVirt 3.5.0 or later. Please see [oVirt 3.5.6 Release Notes](oVirt 3.5.6 Release Notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

### oVirt Live

A new oVirt Live ISO is available at:

[`http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/iso/ovirt-live/)

## What's New in 3.6.3?

<b>WebSocketProxy vdcoption requires a restart to become effective</b>
The WebSocketProxy VDC option(and a few others) can now be updated without need to restart the engine.
Here are the steps to reload the configuration on-the-fly:
\* set: engine-config -s WebSocketProxy=NEW_VALUE

*   refresh cache via REST API POST call, i.e.:

      curl --silent --insecure --request POST --header "Accept: application/xml" --header "Content-Type: application/xml" --user "admin@internal:PWD" "`[`http://localhost:8080/ovirt-engine/api/reloadconfigurations`](http://localhost:8080/ovirt-engine/api/reloadconfigurations)`" --data '`<action/>`'

*   refresh GUI: Ctrl+R

Please note that support for reloading VDC options on-the-fly will be most probably dropped in oVirt 4.0.
 <b>OVIRT-CLI now use remote-viewer instead of spicec for spice based console</b>
 <b>unassigned host status now reflects more the real status</b>
The new status value of the host when it is being activated will be changed from 'Maintenance' to 'Activating' (used to be 'Unassigned')
 <b>Disable cloud-init service after appliance deployment</b>
cloud-init services are now disabled on the engine-appliance after the initial deployment in order to speed up subsequent boots.

## Bugs fixed

### oVirt Engine

* Missing gluster error codes
 - [SetupNetworks] - Impossible to drag and attach some networks to Interfaces via SN if i have a multiple networks in the list
 - User with VmImporterExport on system can't import vm
 - Deploy Windows Server 2012 R2 x64 fails to set admin password and join domain
 - User with all permission cannot create VM from scratch when 2 data centers are configured
 - During migration: execution failed: java.lang.Boolean cannot be cast to java.util.Map
 - libvirt error since managed non pluggable device was removed unexpectedly
 - Allocate memory for high resolutions/multihead
 - Hostdev_passthrough: Template creation should not include attached VM devices.
 - User can't create a VM. No permission for EDIT_ADMIN_VM_PROPERTIES
 - NUMA node configuration is updated even if you hit cancel
 - Host cannot be modified because of XML protocol not supported error
 - [Admin Portal] Error message in UI "Uncaught exception occurred. Please try reloading the page." when creating new pool.
 - Fade "Numa Pinning" button, in case if VM pinned to host that does not have "NUMA Support"
 - rename utility doesn't change ENGINE_BASE_URL for vmconsole-proxy-helper
 - [User portal] No error message while leaving 'username:' and 'password:' fields blank
 - "VDSM <host name> command failed: Virtual machine does not exist" error appears every time when shutting down a running VM
 - [upgrade] async_tasks_map is out of sync
 - New VM dialog offers VM templates from different DCs which are not accessible/usable
 - Various Frontend exceptions (e.g. switching clusters in VM dialog, edit VM, create VM from Template)
 - console does not work after reverting to a snapshot created in RHEV 3.5
 - v2v: Cannot import VM as clone if the VM was already imported (not as clone).
 - Cannot change name of imported VM from VMware
 - unassigned host status should reflect more the real status
 - ca= is missing from the [ovirt] section of the vv.file
 - Uncaught exception occurred when trying to open console if multiple VMs is selected
 - Race condition in basic and power user portal
 - The vm consoles are not set correctly after the upgrade.
 - Graphics protocol of VM sometimes disappears when changed
 - Pool VMs get UserVmManager role assigned automatically
 - [REST] Attach network with boot protocol none via setupNetworks requires ip configuration details
 - Hosts are stuck in 'installing'
 - Add warning when creating a snapshot on a VM with no guest tools installed
 - Edit network interface: General command validation failure
 - Create a VM from Template and restart the enginewhen the tasks are running might cause the VM to stay in lock status for ever
 - The vm.placement_policy.affinity element isn't populated
 - MigrateToServer can fail with destination host unknown (the underlying issue is deeper though).
 - Block restore memory on newer compatibility versions
 - Spice vm console fails because servlet pki-resource is unavailable
 - The title of remote-viewer window is incorrect when open a vm in RHEVM
 - [RFE] v2v: notify in import dialog that attaching VirtIO drivers to Windows VM is essential.
 - [security] disable strict user checking does not work - users can steal already opened console by other user
 - v2v: Source bootable disk value is not copied to target VM.
 - NPE is thrown in host setup networks dialog when trying configuring a host of higher version than the engine one
 - Warn user when VMs with memory snapshots would end up in cluster with newer compatibility version
 - The engine let the user remove the last regular storage domain
 - Error on removing Cinder disk snapshots
 - Online Logical CPU Cores list - many entries results in corrupted display
 - [RFE] remove log collector as mandatory dependency
 - [FC23] engine-setup fails with: Command 'semanage' is required but missing
 - Cannot login after upgrade from 3.5 to 3.6
 - A snapshot containing a Cinder disk remains locked when the engine restarts before the snapshot creation is completed
 - Copying a disk converts the volume type to SHARED
 - Unable to edit fence agents

### VDSM

* Error during successful migration: [Errno 9] Bad file descriptor
 - disable ksmtuned.service during host installation
 - vmchannel thread consumes 100% of CPU
 - Ghost VMs created with prefix "external-" by "null@N/A"
 - VDSM memory leak
 - [vdsm] nofiles impact hardly host - OSError: [Errno 24] Too many open files
 - VM memory usage is not reported correctly
 - Vm.status() causes crash of MoM GuestManager
 - [SR-IOV] - vdsm should persist and restore the number of enabled VFs on a PF during reboots
 - vdsm reports that the storage domain is active, when in fact it's missing a link to it
 - Issue with vdsm-hook-vmfex-dev-4.16.33-1 - "InvalidatedWeakRef"

### oVirt Log Collector

* RHEV engine-log-collector with --local-tmp=PATH option deletes PATH once command is executed

### oVirt Reports

* Memory amount in Clusters Capacity report is rounded down
 - Typo in cluster planning report

### MOM

* XMLRPC API of mom breaks on host with 193270 MiB ram

### oVirt Hosted Engine Setup

* Warning messages observed while using glusterfs as storage during hosted-engine setup
 - [hosted-engine] - Adjust management network settings when deployed over VLAN interface/s
 - Disable cloud-init service after appliance deployment
 - hosted-engine setup proposes as a default to use all the available RAM for the engine VM also if bigger than the value in the appliance OVF
 - changing HE storage domain name causes HE storage and VM import failure

<Category:Documentation> <Category:Releases>
