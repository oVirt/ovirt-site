---
title: OVirt 3.3.2 release notes
category: documentation
authors: dougsland, lvernia, sandrobonazzola, ybronhei
wiki_category: Documentation
wiki_title: OVirt 3.3.2 release notes
wiki_revision_count: 16
wiki_last_updated: 2013-12-19
---

# OVirt 3.3.2 release notes

The oVirt Project is preparing oVirt 3.3.2 beta release for testing. This page is still a work in progress.

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization.

To find out more about features which were added in previous oVirt releases, check out the [oVirt 3.3.1 release notes](oVirt 3.3.1 release notes), [oVirt 3.3 release notes](oVirt 3.3 release notes), [oVirt 3.2 release notes](oVirt 3.2 release notes) and [oVirt 3.1 release notes](oVirt 3.1 release notes). For a general overview of oVirt, read [ the oVirt 3.0 feature guide](oVirt 3.0 Feature Guide) and the [about oVirt](about oVirt) page.

## What's New in 3.3.2?

### VM creation "Guide Me" sequence

The ability to add VM network interfaces has been dropped from the New VM "Guide Me" sequence, as they can now be added/removed directly in the New VM dialog. As always, administrators are encouraged to maintain templates which include networking configurations commonly used in their deployments of oVirt; for special cases, networking should now be configured in the New VM dialog instead of the "Guide Me" sequence.

## Known issues

## Bugs fixed

### oVirt Engine

### VDSM

### ovirt-node-plugin-vdsm

<Category:Documentation> <Category:Releases>
