---
title: Node - oVirt workshop November 2011
category: event/workshop
authors: apevec, mburns, quaid
---

# Node - oVirt workshop November 2011

Edit this page and put session notes and other links on this page

[Slides](http://resources.ovirt.org/old-site-files/wp/ovirt-node.pdf)

oVirt Node is a minimal hypervisor install. Fedora based, will discuss expanding to other distros later.

Two RPMS:

*   ovirt-node: python/newt based TUI for installation; can auto install based on kernel cmdline params.
*   ovirt-node-tools: Used to create image

Image is

*   provided in ISO format
*   installs to any bootable? block device.
*   Can be pxebooted
*   State stored on persistent config partition.
*   Supports in-place upgrade (point it at a new ISO & reboot).
*   Built using livecd-tools (perhaps debian/ubuntu could use live-build, or an installer udeb)
*   supports 'rescue' kernel cmdline parameter

(Slides are pretty self-explanatory)

Node Hypervisor boot menu will take any kernel boot parameter.

Admin user is only user supported by Node. Supported meaning, "as coded" we presume.

Password auth over ssh is disabled by default; relies upon sshkeys. Changeable in the Configuration screen

Logging - supports rsyslog to send logs to external host.

kdump supports ssh, not nfs.

monitoring is via collectd.

What is in config partition?

*   network script
    -   ifcfg ...
*   private key
*   password files
*   anything that is configured via the Configuration utility is persisted

Q: Is a mechanism provided/needed to deal with static config files across upgrades/downgrades?

A: Not needed since the /config filesystem is not touched in an upgrade/downgrade, so this is transparent

Q: What is the overlay mechanism? aufs/symlinks?

A: config files are bind mounted from the /config partition to the location in /etc for example. This is part of the Fedora/RHEL specific 'stateless support' <https://fedoraproject.org/wiki/StatelessLinux> Unfortunately, something unionfs-like is not upstream, so not in Fedora/RHEL.

Q: Where do logs for diagnostic use end up?

A: /var/log/ovirt.log and other /var/log standard logs

Matahari maybe more core than other plugins; a systems management framework built upon QMF (apache project)

Note: There's a dead project called systemconfigurator for abstracting away distro-specific configuration

Q: Do we want to develop different distro based Nodes? or call it a black box? community viewpoint v. product viewpoint Temperature of the room is, make Engine require a working Node but let people make and use their own distro-underneath-the-hood-based Nodes. Make Node dependency

SUSE's kiwi seems to do 80% of what Node does.

*   <http://kiwi.berlios.de/> - seems to be image creator? So more like livecd/appliance-tools equivalent?
*   maybe add that to oVirt as a project, with a script that covers the Node requirements

If you upgrade & it won't reboot, you can boot to TUI and use downgrade - covers 90% of cases.

If that doesn't work, there is a partition called 'RootBackup' - if upgraded image fails to boot, next reboot is from the RootBackup.

Q: What is the roadmap for dealing with upgrades and adding packages?

A: The idea is, it's a black box - individual package installs are not supported. Use the plugins instead.

Ideal: ISO from distro + plugins from ISV/IHV, tool creates a new ISO from that. (These tools are 'livecd-based'.)

*   May need parallel tools to do some of this.

current plug-in proposals for upstream are RPM-based

Not supported means, "Could work, but we haven't really tested it."

Not supported means, "It violates the idea of Node as a black box."

How do we prove that the ISO is really a Node instance? How do we handle plugin auth?

*   Signed?
*   Rely upon the vendor to sign their plugins?
*   Upstream signs the plugins?

Plugin makers need to do dependency resolution stand-alone - it's not part of Node to do that.

The product is very tightly integrated - specific version numbers, etc.. What will the community want to do?

Provide the template of the Node, so other tools can produce a usable Node?

Small image supports PXE boot in many hosts environment, so the network is bogged down by huge boots - the small size keeps from having to stagger PXE boots.

Value of Node:

*   Minimal security footprint - RO filesystem, etc.
*   Once running, don't have to manage any longer; Engine works on top of that

Treat Node like firmware - all the interesting stuff happens in the guests.

[Category:Workshop November 2011](/community/events/archives/workshop/workshop-november-2011/)
