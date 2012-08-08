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

March 21 oVirt Workshop, Beijing: ![](ovirt-node.pdf "fig:ovirt-node.pdf")

## Next Release

oVirt Node 2.6.0

*   Target date: TBD
*   List of issues targeted: [Node_Backlog](Node_Backlog)

## Current Release

oVirt Node 2.5.1-1.0

*   [Node_Release_Notes](Node_Release_Notes)
*   [ISO image](http://ovirt.org/releases/stable/tools/ovirt-node-iso-2.5.1-1.0.fc17.iso)
*   [Source Tarball](http://ovirt.org/releases/stable/src/ovirt-node-2.5.1.tar.gz)
*   [RPM Package](http://ovirt.org/releases/stable/rpm/Fedora/17/noarch/ovirt-node-2.5.1-1.fc17.noarch.rpm)
*   [Tools Package](http://ovirt.org/releases/stable/rpm/Fedora/17/noarch/ovirt-node-tools-2.5.1-1.fc17.noarch.rpm)
*   [ISO RPM Package](http://ovirt.org/releases/stable/rpm/Fedora/17/noarch/ovirt-node-iso-2.5.1-1.0.fc17.noarch.rpm)

## Technologies Used

*   [libvirt](http://libvirt.org/) for virtual machine and storage management.
*   [collectd](http://collectd.org/) for gathering statistics and monitoring.
*   [Matahari](http://matahari.fedorahosted.org) for host and guest system management.

<Category:Project>
