---
title: Predictable vNIC Order
category: feature
authors: danken
---

# Predictable vNIC Order

## Summary

Make the in-guest order of NICs predictable, given their visual order.

## Owner

*   Name: Dan Kenigsberg (danken)
*   Email: <danken@redhat.com>
*   IRC: danken at #ovirt (irc.oftc.net)

## Background

The term "vNIC order" may mean multiple things to multiple people. Let us enumerate them first:

| mnemonic | Description                          |
|----------|--------------------------------------|
| name     | oVirt nic names (nic1,nic2..)        |
| mac      | mac addresses                        |
| libvirt  | order in libvirt domxml              |
| pci      | pci addresses                        |
| guest    | guest device names (eth0,p1p2,em1..) |
| boot     | bios boot order of nics              |

## Detailed Description

A virtual machine may have multiple network interface cards (vNICs), each connected to profoundly different networks. Users need to know the mapping between [name] and [guest]. If a VM is connected to two networks, RED and BLUE, it is important to tell within the guest which network device leads to which network. It is also important to maintain the [name]-[guest] mapping when cloning a VM from a template.

However, when adding a vNIC, the end user can select her favorite address, and if she hasn't done so, Engine would draw a random address from a pool of available addresses. In both cases, the [name]-[mac] mapping is random.

oVirt uses the [mac] ordering to pass the devices to [libvirt]. On the first startup of a vNIC in a VM, libvirt assigns it with a [pci] address. [mac] and [pci] are used by the guest operating system to obtain the [guest] name for the vNIC. The latter step depends heavily on the make and version of the the OS. For example, EL5 orders interfaces based on their [mac]; So does EL6 (since biosdevname is disabled in guests); Modern Fedoras and EL7_beta with systemd>=197 use pci addresses; Forgotten ifcfg files and udev.rules affect clones; And a guest admin can always override the name. Bottom line: [mac/pci]-[guest] mapping is a big mess.

Another, somewhat related problem, is the need to control the boot order [boot]. Currently, [boot] matches [mac].

## Benefit to oVirt

Assume that we have two networks. RED is classified, and BLUE is public. We would like to have several intrusion detection VMs, monitoring BLUE and sending reports to RED. We create such a VM, find out that eth0 leads to RED and eth1 leads to BLUE, and configure our application appropriately. We create a template from the VM, and clone another VM from it.

Without predictable vNIC order, the cloned VM may have eth0 leading to BLUE, and our IDS would leak information from the classified network to the public one. That's bad.

## Possible Solutions

### Transactional MAC allocation - Chosen Solution

mac addresses should not be allocated when a vNIC is first added to the VM. Only when a VM is first run, or is cloned from a template, allocate all addresses and make sure that [mac] matches [name]. This leads to a predictable [name]-[mac]-[pci] mapping, which in sane, clean guests, leads to predictable [name]-[guest].

Cons:

*   Does not handle plugging (hot or cold) of vNICs after initial run. Consider a VM created with 3 vNICs (nic1, nic2, nic3). If nic2 is removed, and later added, there is no guarantee that it would receive the original mac or pci addresses. It most likely would not receive its original guest name without admin intervension.

<!-- -->

*   Awkward to implement in Engine

<!-- -->

*   Does not give explicit control on [boot], but nic1 boots first on template and on clones.

Pros:

*   Would soothe the pains of most of users.

Transactional MAC allocation should take place in the following occasions:

*   Create Vm from template
*   Create Vm from snapshot
*   Add Vm dialog
*   Import Vm

On such the addresses should be allocated to NIC entities based on the original order (on the template, snapshot, or exported Vm). If the information is missing, the MAC order should match the NIC name order.

### User control on libvirt order

We can expose [libvirt] to the end users, who could then sort vNICs to their liking. On first boot, the [libvirt] order controls [pci], which translates predictably to [guest] on modern Fedoras.

Cons:

*   Complete solution of boot order must involve disks, cdroms, floppies and usb cards, on top of vNICs.
*   No predictability on EL5 and EL6 guests. A user can move a vNIC to the top, it would receive the lowest PCI address and would be booted from, but it may be named `eth7`.

### oVirt control on guest names

Before starting up a VM (and before hot-plugging a vNIC), we could use libguestfs (and guest-side config) to configure ifcfg and udev.rules according to our requested naming.

Pros:

*   Gives oVirt complete control on [guest]

Cons:

*   Requires intimacy with each guest OS.
*   Guests that already have a predictable naming convention are going to suffer unneeded level of complexity.
*   Not workable for guests based on the blank template, or when the guest host is re-installed.

## User Experience

TBD

## Implementation

### REST

### Engine

### Vdsm

### Guest Agent

## Dependencies / Related Features

## Documentation / External references

The case for iface name predictability in general

*   <http://fedoraproject.org/wiki/Features/ConsistentNetworkDeviceNaming>
*   <http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/>
*   <http://lwn.net/Articles/531850/>


*   On the arch@ovirt.org mailing list.

