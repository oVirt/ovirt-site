---
title: oVirt 3.3.4 release notes
category: documentation
toc: true
authors: dougsland, sandrobonazzola
---

# oVirt 3.3.4 release notes

The oVirt Project is pleased to announce the availability of oVirt 3.3.4 release

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3.3 release notes](/develop/release-management/releases/3.3.3/), [oVirt 3.3.2 release notes](/develop/release-management/releases/3.3.2/) , [oVirt 3.3.1 release notes](/develop/release-management/releases/3.3.1/), [oVirt 3.3 release notes](/develop/release-management/releases/3.3/), [oVirt 3.2 release notes](/develop/release-management/releases/3.2/) and [oVirt 3.1 release notes](/develop/release-management/releases/3.1/). For a general overview of oVirt, read [the oVirt 3.0 feature guide](/develop/release-management/releases/3.0/feature-guide.html) and the [about oVirt](/community/about.html) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL


If you're upgrading from oVirt 3.3 you should just execute:

      # yum update ovirt-engine-setup
      # engine-setup

If you're upgrading from oVirt 3.2 you should read [oVirt 3.2 to 3.3 upgrade](/develop/release-management/releases/3.2/to-3.3-upgrade.html)

If you're upgrading from oVirt 3.1 you should upgrade to 3.2 before upgrading to 3.3.4. Please read [oVirt 3.1 to 3.2 upgrade](/develop/release-management/releases/3.1/to-3.2-upgrade.html) before starting the upgrade.
On CentOS and RHEL: For upgrading to 3.2 you'll need 3.2 stable repository.
So, first step is disable 3.3 / stable repository and enable 3.2 in /etc/yum.repos.d/ovirt.repo:

      [ovirt-32]
      name=Stable builds of the oVirt 3.2 project
      baseurl=https://resources.ovirt.org/releases/3.2/rpm/EL/$releasever/
      enabled=1
      skip_if_unavailable=1
      gpgcheck=0

Then

      # yum update ovirt-engine-setup

should install ovirt-engine-setup-3.2.3-1.el6.noarch.rpm
if you have already updated to 3.3.x please use distro-sync or downgrade instead of update.
Then:

      # engine-upgrade

this will upgrade your system to latest 3.2.
Once you've all working on 3.2, enable 3.3/stable repository, then just

      # yum update ovirt-engine-setup
      # engine-setup

will upgrade to latest 3.3.

## What's New in 3.3.4?

## Known issues

*   Host deployment may fail on EL6 system due to a recent tuned regression (, ). Please downgrade tuned to previous version while waiting for a new tuned package solving this issue.

## Bugs fixed

### oVirt Engine

* [engine-setup] Encoding issue in /var/lib/ovirt-engine/setup-history.txt
 - Not possible to power off VM that failed migration.
 - don't spawn pop-up for .vv file download in User Portal (because it can't open multiple consoles at one click anyway)
 - In the event of a full host power outage (including fence devices) a user must wait 19 mins (3 x 3 minute timeouts + 10 minutes for the transaction reaper) until they can manually fence a host to relocate guests.
 - [host-deploy] terminate event is not received by engine although sent by host
 - New VMs use display network ports outside of documented 5634 to 6166 range
 - Fix SPICE plugin behavior/support for IE 11
 - Job and step tables not cleaned after the failure or completion of some tasks.
 - [welcome page] duplicated content on welcome page
 - RHEV 3.2 RHEV-M "Enforcing" typo in host reboot log message
 - deleteImage task, which was started as part of snapshot creation (with save memory) roll-back remains running forever
 - Extend important limits to their hard limit
 - [engine] Editing running vm that has virtio-scsi disabled always fails
 - Can't make persistent CDRom change while VM is running
 - [engine-setup] engine-setup should detect if postgresql's shared_buffers are below active kernel.shmmax
 - [RHEVM-SETUP] - remote db configuration. rhevm-setup asks for different configuartion than the dwh & reports setups
 - RHEVM SETUP REMOTE_DB: postgresProvisioning remains none in answer file
 - broken link in /var/lib/ovirt-engine/deployments cause setup to fail
 - Dialogue for attaching ISOs is not logically ordered
 - [AIO] support RFC2317 reverse DNS lookup
 - Events are being pulled from audit_log in a very inefficient way
 - Templates are being pulled from template view in a very inefficient way
 - useDnsLookup flag is ignored at rhevm-manage-domains - krb5.conf file will always contain realms and "domain_realm" section
 - [notifier] /etc/rc.d/init.d/ovirt-engine-notifier contains copy&paste header
 - Multiple daemons are not "registered" in /etc/rc[0-6].d directory hierarchy (chkconfig)
 - Support dual mode of password escaping within pgpassfile
 - Tracker: oVirt 3.3.4 release
 - Update vnic_profile fails for VM vnic.
 - webadmin: we cannot edit the disk alias while vm is running because the edit button is greyed out
 - Enable sync of LUNs after storage domain activation for FC
 - UPGRADE_YUM_GROUP should be 'RHEV Manager' otherwise engine-setup won't find YUM group
 - wrong memory usage report

### VDSM

* vdsm: pre-defined range for spice/vnc ports
 - Avoid going into 'Paused' status during long lasting migrations
 - vdsmd not starting on first run since vdsm logs are not included in rpm
 - vdsm: fix RTC offset
 - netinfo.speed: avoid log spam
 - vm: discover volume path from xml definition
 - Removing vdsm-python-cpopen rpm creation from vdsm
 - vm iface statistics: never report negative rates
sos: plugin should ignore /var/run/vdsm/storage

### ovirt-node-plugin-vdsm

* UI: AttributeError("'module' object has no attribute 'configure_logging'",)
 - engine_page: use vdsm to detect mgmt interface
 - engine_page: display url/port only on available

### oVirt Log Collector

* rhevm-log-collector garbles the tty when multiple hosts are gathered and ssh is called with the "-t" flag
 - Do not collect .pgpass files from RHEV-M.
 - Collect ovirt-engine runtime configuration files

