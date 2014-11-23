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

The process of upgrading cluster/hosts to a higher version is a manual process. When working with a small cluster of hosts that suffice. However, on large clusters it is very time-consuming to upgrade all the hosts manually. The purpose of this feature is to give administrators a set of tools to know when an upgrade is available (engine/hosts), upgrade separate hosts, and upgrade cluster as a whole, using rolling upgrade process.

### Owner

*   Name: [Moti Asayag](User:masayag)
*   Email: <masayag@redhat.com>
*   IRC: masayag at #ovirt (irc.oftc.net)

### Benefit to oVirt

Upgrade is a big pain point on large oVirt deployments. The existence of tools to ease the upgrade process will make it easier to adopt oVirt.

### Requirements

The set of tools that are in the scope of this feature are:

1.  Notify the user that an update for the engine is available
2.  Make it ease to know whether a host has an available update, and what cluster levels this update supports
3.  Allow the user to upgrade a specific host automatically
4.  Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one

### User Experience

#### Notify the user that an update for the engine is available

After the administrator logs in to the Administrator Portal, he will get a dialog notifying on a new available update. He can choose whether to "dismiss" this notification or not. If he chooses to dismiss it, the only other way of knowing that an update is available is by going to the "About" dialog, and looking for the information there. If an update is available it will appear there. Whether there is an update or not will be checked periodically every X days. Open question here - do we need to support checking whether an update is available by demand?

#### Make it ease to know whether a host has an available update, and what cluster levels this update supports

Currently, for oVirt-node, it already shows you that there is an upgrade available, by an alert on the bottom of the general sub-tab. We can add a similar alert also for regular hosts, showing more details on the cluster level as well. Once the host is moved to maintenance, the option to "upgrade" will be shown and enabled in the host context menu.

#### Allow the user to upgrade a specific host automatically

#### Allow the user to do a rolling cluster upgrade, either to a higher cluster level, or to a new version that supports the current one

### Implementation

### Open Issues/Questions
