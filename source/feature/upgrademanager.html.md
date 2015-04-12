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

#### Notify the user that an update for the engine is available

After the administrator logs in to the Administrator Portal, he will get a dialog notifying on a new available update.
He can choose whether to "dismiss" this notification or not. If he chooses to dismiss it, the only other way of knowing that an update is available is by going to the "About" dialog, and looking for the information there.
If an update is available it will appear there. Whether there is an update or not will be checked periodically every X days.
An event log notifying an engine upgrade is available will be logged. The admin could subscribe and be notified via one of the notification methods for this event.

#### Make it easier to know whether a host has an available update, and what cluster levels this update supports

Currently, for oVirt-node, it already shows you that there is an upgrade available, by an alert on the bottom of the general sub-tab.
We can add a similar alert also for regular hosts, showing more details on the cluster level as well.
Once the host is moved to maintenance, the option to "upgrade" will be shown and enabled in the host context menu.

#### Allow the user to upgrade a specific host automatically

If an update is available, and the host is moved to maintenance, the option to "upgrade" will be shown and enabled in the host context menu.

#### Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one

For a cluster we should add the option to "check for available upgrade". This should go on all the operational hosts, and check whether there is a new version available, and what cluster levels it supports. If there is one, the minimal and maximal supported cluster level will be shown as well. Now, the user can upgrade to a higher cluster level, or to a higher version in the current one.
Two flows here behind the scenes:
1. Same cluster level - host by host is moved to maintenance, upgraded, activated. At the end of the day the cluster itself as a whole was upgraded. There should be an easy way to see the status of this upgrade, and information for all the hosts, whether they were upgraded or not (Task list?).
2. Higher cluster level - same as #1, but upgrading the cluster levels once all hosts were upgraded.

### Implementation

#### Upgrade Host Flow

Two alternatives are examined for this use case: 1. Host upgrade will be done by ssh connection to the host, which will leverage ovirt host deploy only for the purpose of packages installation. 2. Host upgrade will use the existing host re-install flow which updates the required packages (vdsm, vdsm-cli).

### Open Issues/Questions

*   Support a cluster upgrade when cluster contains both RHEL and RHEV-H hosts.
    -   How cluster version should be determined ?
*   Upgrade procedure of RHEV-H (done by selecting a specific image to upgrade)
*   Upgrade path: should hosts be upgraded to the recent packages or to a specific version of them ?
    -   Restrict upgrade to z-stream / security-bugs ?
