---
title: ppc64le support
category: ovirt-3.6-proposed-feature
authors: mpolednik
wiki_category: oVirt 3.6 Proposed Feature
wiki_title: Features/ppc64le support
wiki_revision_count: 4
wiki_last_updated: 2015-10-21
wiki_warnings: references
---

# ppc64le Support

### Summary

This feature adds full support for ppc64le platform. Most of the requirements are already implemented[1].

### Owner

*   name: [ Martin Polednik](User:Martin Polednik)
*   email: <mpolednik@redhat.com>

### Current Status

*   testing
*   last updated date: Mon Oct 12 2015

### Requirements

*   ppc64le machine - currently supported is POWER8
*   RHEL 7.2 (ppc64le)

### Differences Between ppc64le and x86_64

Most of the differences are already solved by lower components of the stack. That said, there are several details that are not abstracted at all. In order to overcome these issues, VDSM must take care of gathering the information from sources relevant for the platform and Engine must use them adequately.

#### Hardware Info

##### Device Tree

First difference is hardware information. On x86_64, we use dmidecode to read the low level system information. POWER8 lacks DMI table at all, but another structure - device tree - is used. There are several keys in our info structure, such as `system-id`, `model-name` and `vendor`. Using device-tree to obtain them is possibly via procfs:

    # cat /proc/device-tree/system-id
    <value>
    # cat /proc/device-tree/model-name
    IBM Power System S822L
    # cat /proc/device-tree/vendor
    IBM

Similar information found in dmidecode:

    Handle 0x0001, DMI type 1, 27 bytes
    System Information
            Manufacturer: HP
            Product Name: ProLiant DL160 G6
            Version:
            Serial Number: <value>
            UUID: <value>
            Wake-up Type: Power Switch
            SKU Number: <value>
            Family:

##### Different cpuinfo Format

The fields in cpuinfo have different values. Following table displays how x86_64 fields map to ppc64le fields.

    'flags'      -> __not there __
    'cpu MHz'    -> 'clock'
    'model name' -> 'cpu'

##### Cpu Flags

Libvirt uses notion of baseline CPUs for x86_64, meaning that the model of CPU is mapped by it's flags to a closest baseline subset of these flags. This does not apply for ppc64le where no flags are reported. Since there are data passed in the flags field other then flags (supported baseline CPUs), we use an arbitrary flag `powernv`. The machine type is then read from libvirt's capabilities XML in a same way as on x86_64.

#### Machine Type Differences

##### Graphics

Various constraints must be considered when launching ppc64le VM. Most notably the SPICE is not supported, therefore VNC (with virtio-vga video) must be used.

##### CPU

The libvirt CPU format for ppc64le is quite different from ppc64le. Relevant information is that POWER8 is a magic constant in qemu, meaning 'select the most appropriate CPU for the host'. This is achieved by following XML. Also note that this mode currently allows migration between POWER8 hosts in the same cluster.

    <cpu>
        <model>POWER8</model>
    </cpu>

Using host-model is reserved for POWER compatibility modes. These are not used within VDSM.

    <cpu mode="host-model">
        <model>POWER7</model>
    </cpu>

##### Input

ppc64le uses USB instead of PS2 for mouse. Since the preferred way of interacting with VM is using absolute pointing device (tablet) that is USB on both platforms, this is mostly a fallback.

##### SMBIOS

Not relevant for ppc64le at all.

### FakeKVM / faqemu

There are few issues with FakeKVM. Faqemu should work fine. TBD: fakearch to fix these.

### Final Goal

Allow user to use POWER8 in oVirt with only minimal differences to x86_64.

### References

<references/>
[Category:oVirt 3.6 Proposed Feature](Category:oVirt 3.6 Proposed Feature) [Category:oVirt 3.6 Feature](Category:oVirt 3.6 Feature)

[1] <http://www.ovirt.org/Features/Vdsm_for_PPC64>
