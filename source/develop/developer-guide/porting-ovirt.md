---
title: Porting oVirt
category: developer
authors:
  - alonbl
  - dneary
  - zhshzhou
  - sandrobonazzola
---

# GNU/Linux distributions and oVirt

oVirt is a complete virtualization management platform which provides
a centralized enterprise-grade datacenter virtualization management system.

To ensure enterprise-grade level oVirt is developed and tested to be compatible
with latest [Red Hat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)
release and its derivatives like [CentOS Linux](https://www.centos.org/) and
[Scientific Linux](https://www.scientificlinux.org/).

The oVirt project composes nightly builds and official releases packaged as RPMs
for these distributions and commits to support them.
In addition, the oVirt project also provides RPM packages for [Fedora](https://getfedora.org/),
Fedora being the upstream project for the main supported distributions.
Virt support for Fedora is provided as tech preview / best effort so it's not
recommended for production deployment.

Some of the oVirt developers also use different distributions and are happy
to help packagers and developers willing to package and help supporting their
preferred distributions.

## Porting oVirt

Because oVirt integrates closely with both the Hypervisor and guest operating systems running on the Hypervisor,
there is some porting and integration work required to enable oVirt Engine to manage nodes running on operating
systems other than Fedora, CentOS and Red Hat Enterprise Linux.
The main work involved is related to porting and integrating [VDSM](/develop/developer-guide/vdsm/vdsm.html),
[libvirt](http://libvirt.org/) and their dependencies to the new distribution for the hypervisor, and ensuring
that the [Guest Agent](/develop/developer-guide/vdsm/guest-agent.html), [virtio](http://www.linux-kvm.org/page/Virtio)
and [SPICE](http://spice-space.org/) integrate correctly on guests.

## Gentoo

*   [Overlay](https://github.com/alonbl/ovirt-overlay)
*   [Wiki](http://wiki.gentoo.org/wiki/OVirt)

## Ubuntu / Debian

Porting the guest agent and VDSM to Ubuntu is a high priority for the project.

*   [Porting the Guest Agent](/develop/release-management/features/virt/guestagentubuntu.html)
*   [VDSM on Ubuntu](/develop/developer-guide/vdsm/on-ubuntu.html)
*   [oVirt on Ubuntu](/develop/developer-guide/ubuntu.html)

## Arch Linux

* [oVirt on Arch Linux](/develop/developer-guide/arch-linux.html)

