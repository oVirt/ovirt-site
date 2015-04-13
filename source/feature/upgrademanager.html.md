---
title: UpgradeManager
authors: moti, ovedo
wiki_title: Home/Features/UpgradeManager
wiki_revision_count: 41
wiki_last_updated: 2015-06-02
feature_name: Upgrade Manager
feature_modules: engine,infra
feature_status: To be Released
---

# Upgrade Manager

### Summary

The process of upgrading cluster/hosts to a higher version is a manual process. When working with a small cluster of hosts that suffice. However, on large clusters it is very time-consuming to upgrade all the hosts manually. The purpose of this feature is to give administrators a set of tools to know when an upgrade is available for the hosts, upgrade separate hosts, and upgrade cluster as a whole, using rolling upgrade process.

### Owner

*   Name: [Moti Asayag](User:masayag)
*   Email: <masayag@redhat.com>
*   IRC: masayag at #ovirt (irc.oftc.net)

### Benefit to oVirt

Upgrade is a big pain point on large oVirt deployments. The existence of tools to ease the upgrade process will make it easier to adopt oVirt.

### Requirements

The set of tools that are in the scope of this feature are:

1.  Notify the user that an update for the engine is available
    1.  The [ Katello Integration](http://www.ovirt.org/Home/Features/KatelloIntegration) will be used to indicate if an available packages exist for ovirt-engine.

2.  Make it easier to know whether a host has an available update, and what cluster levels this update supports
3.  Allow the user to upgrade a specific host automatically
4.  Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one

### User Experience

#### Make it easier to know whether a host has an available update

Currently, for oVirt-node, it already shows you that there is an upgrade available, by an alert on the bottom of the general sub-tab.
We can add a similar alert also for regular hosts:
\* A notification will be added at the bottom of the 'General' sub-tab of the host, saying 'Upgrade is available'.

*   Once an update is available, the option to "Updade" button will be enabled, both on the menu bar and in the host context menu.

![ 800px](System_host_update.jpg  " 800px")

#### Allow the user to upgrade a specific host automatically

*   If an update is available:
    -   and if the host's status is 'Up' or 'Maintenance':
        -   Enable "Upgrade" button on menu-bar and in the host context menu.

#### Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one

*Not planned for 3.6*:
For a cluster we should add the option to "check for available upgrade". This should go on all the operational hosts, and check whether there is a new version available, and what cluster levels it supports. If there is one, the minimal and maximal supported cluster level will be shown as well. Now, the user can upgrade to a higher cluster level, or to a higher version in the current one.
Two flows here behind the scenes:
1. Same cluster level - host by host is moved to maintenance, upgraded, activated. At the end of the day the cluster itself as a whole was upgraded. There should be an easy way to see the status of this upgrade, and information for all the hosts, whether they were upgraded or not (Task list?).
2. Higher cluster level - same as #1, but upgrading the cluster levels once all hosts were upgraded.

### Implementation

#### Upgrade Host Flow

A new button 'Upgrade' will be added to the UI:

*   Host upgrade will use the existing host re-install flow which updates the required packages (vdsm, vdsm-cli)

The host upgrade sequence is:

*   Move host to 'Maintenance'.
    -   Verify updates are available.
    -   Migrate VMs if there are any running on the host.
*   Run 'Re-install' command
*   Return the host to its origin status (Up or Maintenance).

API:

       /hosts/{host:id}/upgrade|rel=upgrade

### Open Issues/Questions

*   Support a cluster upgrade when cluster contains both RHEL and RHEV-H hosts.
    -   How cluster version should be determined ?
*   Upgrade procedure of RHEV-H (done by selecting a specific image to upgrade)
*   Upgrade path: should hosts be upgraded to the recent packages or to a specific version of them ?
    -   Restrict upgrade to z-stream / security-bugs ?
