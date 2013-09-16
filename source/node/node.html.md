---
title: Node
category: node
authors: dougsland, fabiand, mburns, nkesick, pmyers, quaid, vered
wiki_category: Project
wiki_title: Category:Node
wiki_revision_count: 43
wiki_last_updated: 2013-10-25
---

# Node

This is the main wiki page for [Node](Node) development.

## Overview

The oVirt Node sub-project is geared toward building a small, robust operating system image. It uses minimal resources while providing the ability to control virtual machines running upon it. A managed node can run in both standalone and mananged modes. Limited stateless support is also available, but not support by Engine at this time.

### Presentations

*   March 21 oVirt Workshop, Beijing: ![](ovirt-node.pdf "fig:ovirt-node.pdf")
*   2012-08-28 oVirt Workshop, San Diego: ![](Ovirt-node-2012-08-28.pdf "fig:Ovirt-node-2012-08-28.pdf")
*   2012-11-07 oVirt Workshop, Barcelona, Spain: ![](Ovirt-node-2012-11-07.pdf "fig:Ovirt-node-2012-11-07.pdf")

## Next Release

*   oVirt Node 3.0.2

## Current Release

*   oVirt Node 3.0.1
    -   [Node Release Notes](Node Release Notes)
*   Images
    -   *Note: These are base images, without VDSM, use edit-node to add plugins to add required plugins to an image*
    -   Fedora 19: <http://resources.ovirt.org/releases/node-base/3.0.0/iso/ovirt-node-iso-3.0.1-1.0.2.fc19.iso>
    -   EL6: <http://resources.ovirt.org/releases/node-base/3.0.0/iso/ovirt-node-iso-3.0.1-1.0.2.el6.iso>
*   Source tarball
    -   <http://resources.ovirt.org/releases/node-base/3.0.0/src/ovirt-node-3.0.1.tar.gz>
*   Packages (Fedora 19, Fedora 20 and EL6)
    -   <http://resources.ovirt.org/releases/node-base/3.0.0/rpm/>
    -   Available plugin packages
        -   CIM
        -   SNMP
        -   Igor Slave
        -   Puppet
        -   VDSM

## Technologies Used

*   [libvirt](http://libvirt.org/) for virtual machine and storage management.
*   [collectd](http://collectd.org/) for gathering statistics and monitoring.
*   [Urwid](http://excess.org/urwid/) for the TUI

## Upgrading

There are 2 general methods for upgrading an ovirt-node installation.

**1**. Through oVirt Engine

Require the installation of ovirt-node-iso rpm on oVirt Engine. A node is then placed in maintenance mode, and you trigger the upgrade from the engine interface.

**2**. Through oVirt Node installation media (ISO, CD, USB, PXE)

This approach is done using installation media. Simply boot your host running an old version of node from new media.
Either PXE, CDROM, USB, SD card, ISO, etc. are supported. Once you boot from the media, it will bring you to a TUI screen where you choose upgrade.
That will upgrade and leave existing configuration in place.

There are some other options as well, but they're in a slightly different, but related, category.

### Reinstall

This will wipe out any existing configuration and install from scratch This is done either by choosing the "Reinstall" option in the Boot menus (with CD/USB/SD Card) or adding "reinstall" to the kernel command line (any method).

### Uninstall

This will wipe the ovirt-node-iso installation from the disk entirely and reboot. Again, there is a "Uninstall" option in the boot menu. You can also add "uninstall" to the kernel command line.

<Category:Project>
