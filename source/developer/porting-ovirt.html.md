---
title: Porting oVirt
category: developer
authors: alonbl, dneary, zhshzhou
wiki_category: Developer
wiki_title: Porting oVirt
wiki_revision_count: 9
wiki_last_updated: 2013-07-24
---

# Porting oVirt

Because oVirt integrates closely with both the Hypervisor and guest operating systems running on the Hypervisor, there is some porting and integration work required to enable oVirt Engine to manage nodes running on operating systems other than Fedora, CentOS and Red Hat Enterprise Linux. The main work involved is related to porting and integrating , [libvirt](libvirt) and their dependencies to the new distribution for the hypervisor, and ensuring that the [Guest Agent](Guest Agent), [virtio](virtio) and [SPICE server](SPICE server) integrate correctly on guests.

## Ubuntu

Porting the guest agent and VDSM to Ubuntu is a high priority for the project.

*   [ Porting the Guest Agent](Ubuntu/GuestAgent)

[ VDSM](Category:Vdsm) <Category:Developer>
