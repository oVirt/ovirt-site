---
title: Specs
category: node
authors: fabiand
wiki_category: Node
wiki_title: Node/Specs
wiki_revision_count: 13
wiki_last_updated: 2015-01-21
---

# Specs

This page tries to grab some of the properties we like about Node and which makes it what it is.

## Flows and Terms

Thsi section actually tries to divide the whole Node concept into distinct sections.

         (Build time)    Packageset -> Rootfs compose -> LiveCD creation
         (Runtime)                                       LiveCD -> Installation -> Runtime layout

*   package set: The package set defines what packages are contained in the the rootfs
*   rootfs compose: The rootfs is composed by some kind of tool (imgfac, yum, rpm, rpm-ostree)
*   LiveCD creation: Another tool creates the LiveCD, currently only livemedia-creator is avaialble, which either takes a package set or rootfs
*   Installation: An installer on the LiveCD can be used to install the rootfs to a host
*   runtime layout: The runtime is the rootfs on the host which hosts VMs

## Delivery

The ISO (kernel+initrd) which is used to deliver the OS to the host.

*   Size: Small
*   Image: ISO Image
*   Media
    -   USB
    -   PXE

## Payload

The actual rootfs which is used at runtime.

*   Size: Small
*   Image: Deployment image (ISO)

### Installation

*   iSCSI, EFI, multipath
*   Partitioning
*   Bootloader
*   Image transfer

### Upgrade + Rollback

*   "Atomic" single image
*   Rollback into previous image (boot into different LV)

### Security

*   SELinux
*   Read-Only rootfs (because of squashfs)

## Implementation

*   Livecd (current)

<!-- -->

*   Possible alternatives
    -   Fedora Atomic - ostree based / image like
    -   Anaconda derived - package based

## Problems

*   Bind mounts are limited
*   Early-boot-process changes are not possible
*   Live plugins are hard
*   Installation is custom

[Category: Node](Category: Node)
