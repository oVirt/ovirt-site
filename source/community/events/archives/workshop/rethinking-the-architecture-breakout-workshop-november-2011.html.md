---
title: Rethinking the Architecture breakout - oVirt workshop November 2011
category: event/workshop
authors: dannfrazier
---

# Rethinking the Architecture breakout - oVirt workshop November 2011

libvirt is designed to be a hypervisor agnostic layer. For lots of hypervisors this is pretty straightforward as they offer APIs for vm ops (create/destroy/ etc). No such layer exists for kvm, so libvirt has a lot of kvm-specific code to supplement. VDSM sits on top of libvirt to make use of functionality which would normally be in this mid-layer. This is a layering design defect.

Perhaps we could create a "kvmd" layer which manipulates qemu directly. libvirt would then be free to rebase upon this new midlayer, if desired. Alternatively, maybe the "extra" code in libvirt can be extracted to create this midlayer. People like the virtualbox UI - that too could be ported on top of "kvmd".

VDSM maybe well suited to become the "kvmd" components.

What interface would "kvmd" present? What about using the ESXi API vs. reinventing the wheel? RHEV-M team looked at it in the past - the API is very big, they didn't understand all of it, lots of ESX-specific stuff.

Karl suggests that we should concentrate on the API to the host - we can switch out/relayer components internally - but we want an API that people can start using now and maintain. Internals can change organically.

We still want to have a data definition file that is generic; don't want to always require usage of oVirt engine to have a self-contained VM description. An OVF for KVM. Why not use the existing ovirt OVF as a standard?

SuSE studio would like to use such a format; they have comparable formats for other hypervisor types.

If kvm VM creation builds an OVF file (vs. just exporting it) it might help increase the adoption of this as a standard.

Let's not forget there are advantages that libvirt brings to oVirt; hooks rely heavily on libvirt modules for example.

how does ovirt-engine relate to nova? similar; but different goals.

what about subservices of nova? e.g. placement service?

per-user kvmd, don't run as root, a lot of benefits - security, selinux, quotas, SLAs-per-user
