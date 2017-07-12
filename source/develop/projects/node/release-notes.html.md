---
title: Node Release Notes
category: node
authors: fabiand, mburns, nkesick
---

# Node Release Notes

## 3.0.2 Release Notes

*   Bug fixes
    -   Fixes to let gluster work oob
    -   Fix link detection with some NICs
    -   Add some module dependencies
    -   Better debugging informations

## 3.0.1 Release Notes

*   Several bug fixes

## **3.0.0 Release Notes**

*   For an detailed overview take a look at the [Node 3.0 release-management](/develop/projects/node/3.0-release-management/) page
*   Universal Image - Remove VDSM specific bits to make the image more general (an VDSM image is still provided)
*   Improved upgrade tool
*   Software iSCSI root
*   Puppet configuration management
*   Bridegeless Networking
*   NIC Bonds
*   New installer TUI
*   IPv6 support in the setup TUI
*   Diagnostics page in the setup TUI
*   Images for Fedora 19 and EL6

## 2.6.1 Release Notes

*   Fix for [CVE-2013-0293](https://bugzilla.redhat.com/show_bug.cgi?id=911699)
*   Updated vdsm and latest Fedora 18 packages

## 2.6.0 Release Notes

*   Move to Fedora 18 base
*   Add new Setup UI (based on python-urwid)
*   glusterfs client support added
*   Full Plugin enablement
*   various other enhancements and bug fixes

## 2.5.5 Release Notes

*   include dns_resolver kmod to fix nfs mounting issues

## 2.5.4 Release Notes

*   Fix selinux booleans related to sanlock

## 2.5.3 Release Notes

*   Include /bin/hostname command

## 2.5.2 Release Notes

*   This build includes the fixed vdsm to allow nfs

based domains to be attached.

## 2.5.1 Release Notes

*   Refactoring for pep8 compliance
*   Various bug fixes for oVirt 3.1 support
*   TECH PREVIEW: Plugin Support

### Known issues for 2.4.0

*   See Current Backlog for other issues [Node_Backlog](/develop/projects/node/backlog/)

## 2.4.0 Release Notes

*   Move to F17 Base
*   Various spec file cleanups
*   fix some issues around networking
*   Various bugs related to F17 transition

### Known issues for 2.4.0

*   See Current Backlog for other issues [Node_Backlog](/develop/projects/node/backlog/)

## 2.3.0 Release Notes

*   Migrate to systemd for fedora based images
*   Add support for detecting and cleaning fakeraid devices
*   Add libvirt-cim/sblim-sfcb support to ovirt-node
*   Various stateless fixes
*   Various Small TUI fixes
*   Add keyboard selection support
*   Add ovirt-node-iso rpm

### Known Issues for 2.3.0

*   See Current Backlog for other issues [Node_Backlog](/develop/projects/node/backlog/)

## 2.2.3 Release Notes

*   Add kickstarts for F18
*   Configuring networking even if autoinstall fails
*   Small build enhancements
*   Added archipel configuration
*   Limited stateless support introduced

### Known Issues for 2.2.3

*   See Current Backlog for other issues [Node_Backlog](/develop/projects/node/backlog/)

## 2.2.2 Release Notes

*   UEFI installation should be fixed [Bug 761540](https://bugzilla.redhat.com/show_bug.cgi?id=761540)
*   Spec file cleanup
*   Build process enhancements
*   Automatically log out sessions that are idle for 15 minutes
*   Validate iscsi iqn name
*   Persist Manually added dns entries when using DHCP
*   Fix display of bootproto when using vlans

### Known Issues for 2.2.2

*   See Current Backlog for other issues [Node_Backlog](/develop/projects/node/backlog/)

## 2.2.1 Release Notes

*   UEFI installation does not work with internal drives, only usb drives [Bug 761540](https://bugzilla.redhat.com/show_bug.cgi?id=761540)
*   Registration directly from ovirt-node will fail [Bug 782663](https://bugzilla.redhat.com/show_bug.cgi?id=782663)
*   Adding oVirt Node through the engine interface will fail [Bug 782660](https://bugzilla.redhat.com/show_bug.cgi?id=782660)
    -   There is a workaround available in this [patch](http://gerrit.ovirt.org/#change,1117)
    -   Needs to be applied on the ovirt-engine server to vds_installer.py in /usr/share/ovirt-engine/scripts/
*   Some hardware seems to fail to boot the Node correctly
    -   Fails to load the TUI when booting the first time
    -   Seen on IBM x3650 Servers
    -   Cannot reproduce on desktop hardware or virtual machines
*   See Current Backlog for other issues [Node_Backlog](/develop/projects/node/backlog/)

## 2.2.0 Release Notes

*   Registration with oVirt Engine is non-functional due to vdsm bugs
    -   [Bug 752464](https://bugzilla.redhat.com/show_bug.cgi?id=752464)
*   This release is intended to be used for testing installation

