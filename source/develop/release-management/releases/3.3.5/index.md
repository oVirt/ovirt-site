---
title: oVirt 3.3.5 release notes
category: documentation
toc: true
authors: sandrobonazzola
---

# oVirt 3.3.5 release notes

The oVirt Project is pleased to announce the availability of oVirt 3.3.5 release

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3.4 release notes](/develop/release-management/releases/3.3.4/), [oVirt 3.3.3 release notes](/develop/release-management/releases/3.3.3/), [oVirt 3.3.2 release notes](/develop/release-management/releases/3.3.2/) , [oVirt 3.3.1 release notes](/develop/release-management/releases/3.3.1/), [oVirt 3.3 release notes](/develop/release-management/releases/3.3/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide/) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

oVirt 3.3.5 release is available. In order to install it you've to enable oVirt 3.3 stable repository.

      # yum 
`# yum localinstall `[`http://resources.ovirt.org/releases/3.3.5/package-pool/ovirt-release-11.2.0-1.noarch.rpm`](http://resources.ovirt.org/releases/3.3.5/package-pool/ovirt-release-11.2.0-1.noarch.rpm)
      # yum-config-manager --enable ovirt-3.3-stable

Since oVirt 3.4.0 has been released, in order to install 3.3.5 instead of 3.4.0 you need to disable latest stable and latest 3.4 repositories:

      # yum-config-manager --disable ovirt-stable
      # yum-config-manager --disable ovirt-3.4-stable

### Fedora / CentOS / RHEL

If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](/develop/release-management/releases/3.2/to-3.3-upgrade/)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.5. Please read [oVirt 3.1 to 3.2 upgrade](/develop/release-management/releases/3.1/to-3.2-upgrade/) before starting the upgrade.
On CentOS and RHEL: For upgrading to 3.2 you'll need 3.2 stable repository.
So, first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

      [ovirt-32]
      name=Stable builds of the oVirt 3.2 project
`baseurl=`[`http://ovirt.org/releases/3.2/rpm/EL/$releasever/`](/releases/3.2/rpm/EL/$releasever/)
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

## What's New in 3.3.5?

## Known issues

*   Host deployment may fail on EL6 system due to a recent tuned regression (, ). Please downgrade tuned to previous version while waiting for a new tuned package solving this issue.

## Bugs fixed

### oVirt Engine

* [race] Host stays in "Preparing for maintenance" forever if requested while incoming live migrations
 - Force removal of DataCenter fails to remove vm_pool from DB
 - engine: DeactivateStorageDomainCommand fails with vdsm error: 'Operation not allowed while SPM is active' because we do not actually send SpmStop while there are unknown tasks
 - Listing templates takes noticeable amount of time, while listing many more VMs is prompt
 - Pool VMs are being pulled from template view in a very inefficient way
 - Allow manual fence in connecting state
 - 'engine-backup --mode=restore' fails after engine-cleanup on postgres 8
 - Typo in Cluster Policy Tool Tip
 - Cloud-init DNS settings should go inside the "iface" section
 - engine: host stuck on Unassigned when moving from status Maintenance when storage is not availble from the host
 - 'engine-backup --mode=restore' fails after engine-cleanup on postgres 8
 - Force removal of DataCenter fails to remove vm_pool from DB
 - [restore.sh] restore.sh is doing restore.sh.log in /usr directory
 - GuideMe AddHost does not pass OverrideFirewall
 - VMs do not appear in virtual machine tab if host is selected in side pane (data-center > cluster > host > )
 - Listing templates takes noticeable amount of time, while listing many more VMs is prompt
 - RHEV-M fails to detect 'AMD Opteron G5' as CPU_Type for hypervisors.
 - VM is not locked on run once
 - VM split brain caused by network outage
 - Failure to add domain via engine-manage-domains if the kerberos realm is not an uppercase of the domain
 - CpuOverCommitDurationMinutes limited to a single digit value by regular expression in database scripts
 - After a power outage two VMs marked as HA failed to start automatically, they were required to be started manually.
 - Missing option create engine-setup answer-file template
 - On DB upgrade, readonly user and client custom users losses permissions to db views
 - Tasks are cleared while they are still running
 - The RSDL documentation of the cloud-init hostname property should be host.address
 - [legacy upgrade 3.2->3.3] misleading information
 - Tracker: oVirt 3.3.5 release
 - [legacy upgrade 3.2->3.3] misleading information
 - RHEV 3.3 - Live Migration fails with ERROR: insert or update on table "step" violates foreign key constraint "fk_step_job"
 - Editing VM clears the VNIC profiles
 - setupNetworks: nic with dhcp cannot be bonded
 - Typo in encryptionvalidator.sh in RHEV > 3.2 prevents script from running
 - SSH injection via cloud-init UI goes to root instead of creating cloud-user
 - [TEXT] taskcleaner.sh has dangerously misleading help text

### VDSM

### ovirt-node-plugin-vdsm

