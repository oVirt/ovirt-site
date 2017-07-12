---
title: Opening welcome and introductions - oVirt workshop November 2011
category: event/workshop
authors: quaid
---

# Opening welcome and introductions - oVirt workshop November 2011

Need some more details on the networking subsystem.

## oVirt demo using RHEV

Currently supported hosts are: RHEV-H, oVirt Node, or fat RHEL (fat Linux)

Clusters need to be in the same proc family.

*   Can have compatibility for any Intel platform by filtering out extra bits - dumbing down.

Multiple NICs allow for different network configs or bonding, all from the GUI - no need to go in to Node.

Hook is an extension that allows us to make changes to the VMs configuration.

Two ways to create a VM:

1.  Take a template (image), packaged. Pulls defaults from template.

SPICE is default console. still have legacy VNC support.

*   USB support native in SPICE by end of year?

Picking a host - don't have support currently but want to allow to go beyond picking RAM, VCPU, etc. to actually being able to prioritize VM resource usage.

The features accessed via hooks right now are in KVM and kernel, now need to get it in the UI.

[Category:Workshop November 2011](/community/events/archives/workshop/workshop-november-2011/)
