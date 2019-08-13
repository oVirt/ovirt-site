---
title: Roadmap and schedule - oVirt workshop November 2011
category: event/workshop
authors: quaid
---

# Roadmap and schedule - oVirt workshop November 2011

## What to focus on

*   SUSE - Packaging of Node VDSM guest agent for OpenSUSE
*   Canonical - Packaging of Node VDSM guest agent for Ubuntu
    -   Relationg to having Jonas in next Ubuntu(?) release?
*   NetApp - make sure things work well over NFS
    -   Integrating snapshots
    -   Let's ponder NFSv4 - what features can we expose/use in v4?

## Steps

1.  Big migration from Fedora to other distros
    1.  Schedule near-term release for "works in $distro/$platforms" - Node and agents run across all the platforms.
        -   Feb/Jan 2011 <- 2012?

2.  Time-based schedule
    1.  Once up and running, then think about features

## Release schedule method

Combination of feature and date driven - need a date to make sure we have something to hit.

Carl to start pounding the drum on arch@ in about two weeks.

*   <https://lists.ovirt.org/archives/list/arch>@ovirt.org/

## Release Goal

1.  Page w/ tags/tarballs, links off to distro-specific content
2.  Upstreaming producing tagged tarballs
    -   Specify which platforms the tarball was tested on; may change & evolve over time

Mixing hosts isn't something we'll try to prevent, but is also risky for a user to try.

Should we define a set of version numbers of ovirt-node components (libvirt, qemu-kvm, etc) across distros? Consensus sounds like no, leave that to specific distros.

Upstream ovirt-node project should be a recipe of upstream components, and any node-specific code (boot menu, etc). But no upstream node iso/image will exist - that's left up to the distros.

## Infrastructure

Request that individual resources don't all have to be developers, but also people that can help with infrastructure management, etc.

## Additional workshops/meetups/etc

requests for london, europe, china, US east coast

Would be good to have oVirt workshop organization spread across the community, tagged onto other conferences, etc. Noted that Canonical is pretty good at this \*hint\* \*hint\*

## Scheduling

### Calculating host resources

=

Currently we naively just monitor cpu usage

Would like to monitor memory, networking, storage IOs, latency, etc

[Category:Workshop November 2011](/community/events/archives/workshop/workshop-november-2011/)
