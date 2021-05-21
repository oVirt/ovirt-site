---
title: UpgradeManager
authors:
  - moti
  - ovedo
category: features
---

# Upgrade Manager

## Summary

The process of upgrading cluster/hosts to a higher version is a manual process. When working with a small cluster of hosts that suffice. However, on large clusters it is very time-consuming to upgrade all the hosts manually. The purpose of this feature is to give administrators a set of tools to know when an upgrade is available for the hosts, upgrade separate hosts, and upgrade cluster as a whole, using rolling upgrade process.
See demo [here](https://youtu.be/fDzBNKu5pyQ).

## Owner

*   Name: [Moti Asayag](User:masayag)
*   Email: <masayag@redhat.com>
*   IRC: masayag at #ovirt (irc.oftc.net)

## Benefit to oVirt

Upgrade is a big pain point on large oVirt deployments. The existence of tools to ease the upgrade process will make it easier to adopt oVirt.

## Requirements

The set of tools that are in the scope of this feature are:

1.  Notify the user that an update for the engine is available
2.  Make it easier to know whether a host has available updates
3.  Allow the user to upgrade a specific host automatically
4.  Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one (out-of-scope of ovirt-engine-3.6)

## User Experience

### Make it easier to know whether a host has an available update

Currently, for oVirt-node, it already shows you that there is an upgrade available, by an alert on the bottom of the general sub-tab.
We can add a similar alert also for regular hosts:
\* A notification will be added at the bottom of the 'General' sub-tab of the host, saying 'Upgrade is available. _Upgrade_'. where _Upgrade_ is a link to the action, based on the host type (plan host or ovirt-node).

*   Once an update is available, the "Upgrade" button will be enabled, both on the menu bar and in the host context menu.
*   For consistency, a support will be added for updates available property for **oVirt-node**
*   Upgrading host in 'Up' status will trigger the following flow:
    -   Host is set to maintenance mode, triggering the migration of the vms to other hosts in the cluster.
    -   New updates are being installed on the host using ovirt-host-deploy.
    -   Host is brought up once installation is completed.

![ 800px](/images/wiki/Update_available_mockups.png  " 800px")

**API:** 

```xml
GET /hosts/{host:id}/
<host>
    ...
    <updates_available>`true`</updates_available>
</host>
```

#### Which packages are checked for updates?

There is a system configuration value named 'PackageNamesForCheckUpdate' which contains the system required packages for upgrade (specifically 'vdsm').
A user may provide additional packages he wishes to monitor for updates by using 'UserPackageNamesForCheckUpdate' config value, which is a merge-able and supports wildcards.
Assuming the config value contains the value 'libvirt, mom', the use can use:

```bash
$ engine-config -m UserPackageNamesForCheckUpdate=qemu-kvm-rhev
```

which will result in:

```bash
$ engine-config -g UserPackageNamesForCheckUpdate
UserPackageNamesForUpdate: libvirt,mom,qemu-kvm-rhev version: general
```

The same behavior is applied during the upgrade sequence: All packages listed in 'PackageNamesForCheckUpdate' and 'UserPackageNamesForCheckUpdate' will be upgraded.

#### When packages are checked for updates?

The interval for updates checking is determined by the configuration value 'HostPackagesUpdateTimeInHours', which is specified in hours.

### Allow the user to upgrade a specific host automatically

*   If an update is available:
    -   and if the host's status is 'Up' or 'Maintenance':
        -   Enable "Upgrade" button on menu-bar and in the host context menu.

![ 800px](/images/wiki/Upgrade_host_button.png  " 800px")

*   For consistency, a support will be added for **oVirt-node** upgrade in UP status.

**API:** 

    POST /hosts/{host:id}/upgrade|rel=upgrade

### Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one

*Not planned for 3.6*:
For a cluster we should add the option to "check for available upgrade". This should go on all the operational hosts, and check whether there is a new version available, and what cluster levels it supports. If there is one, the minimal and maximal supported cluster level will be shown as well. Now, the user can upgrade to a higher cluster level, or to a higher version in the current one.
Two flows here behind the scenes:
1. Same cluster level - host by host is moved to maintenance, upgraded, activated. At the end of the day the cluster itself as a whole was upgraded. There should be an easy way to see the status of this upgrade, and information for all the hosts, whether they were upgraded or not (Task list?).
2. Higher cluster level - same as #1, but upgrading the cluster levels once all hosts were upgraded.

## Implementation

### Upgrade Host Flow

The upgrade process will reuse the existing re-install flow which updates the required packages (vdsm, vdsm-cli).
The host upgrade sequence is:

*   If VMs are running on the host - popup a warning confirmation dialog: "There are running VMs on the host. Would you like to continue?"
*   If there are updates available for the host
    -   Move host to 'Maintenance'.
        -   Migrate VMs if there are any running on the host.
    -   Run 'Re-install' command
    -   Return the host to its origin status (Up or Maintenance).
    -   Clear updates notifications for the host
*   Upgrade failure will move the host to "Install Failed" status. From "Install Failed" the user should be able to "Upgrade" the host again.

**The ovirt-engine** will schedule a daily quartz job for querying vdsm for any available updates for the host.
 The packages availability check/upgrade action will be performed using the ovirt-host-deploy component.
 **Install/Reinstall Host Flow changes:**

*   When host installation/re-installation fails, the available updates notification will be disabled.

## Open Issues/Questions

*   Support a cluster upgrade when cluster contains both RHEL and RHEV-H hosts.
    -   How cluster version should be determined?
*   Upgrade procedure of RHEV-H (done by selecting a specific image to upgrade)
