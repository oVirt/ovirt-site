---
title: Node Release Notes
category: node
authors: fabiand, mburns, nkesick
wiki_category: Node
wiki_title: Node Release Notes
wiki_revision_count: 17
wiki_last_updated: 2013-11-19
---

# oVirt Node Release Notes

# 2.2.1 Release Notes

*   UEFI installation does not work with internal drives, only usb drives [Bug 761540](https://bugzilla.redhat.com/show_bug.cgi?id=761540)
*   Registration directly from ovirt-node will fail [Bug 782663](https://bugzilla.redhat.com/show_bug.cgi?id=782663)
*   Adding oVirt Node through the engine interface will fail [Bug 782660](https://bugzilla.redhat.com/show_bug.cgi?id=782660)
    -   There is a workaround available in this [patch](http://gerrit.ovirt.org/#change,1117)
    -   Needs to be applied on the ovirt-engine server to vds_installer.py in /usr/share/ovirt-engine/scripts/
*   Some hardware seems to fail to boot the Node correctly
    -   Fails to load the TUI when booting the first time
    -   Seen on IBM x3650 Servers
    -   Cannot reproduce on desktop hardware or virtual machines
*   See Current Backlog for other issues [Node_Backlog](Node_Backlog)

# 2.2.0 Release Notes

*   Registration with oVirt Engine is non-functional due to vdsm bugs
    -   [Bug 752464](https://bugzilla.redhat.com/show_bug.cgi?id=752464)
*   This release is intended to be used for testing installation
