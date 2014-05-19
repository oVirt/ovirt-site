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

#### Installation

*   iSCSI, EFI, multipath
*   Partitioning
*   Bootloader
*   Image transfer

#### Upgrade + Rollback

*   "Atomic" single image
*   Rollback into previous image (boot into different LV)

#### Security

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

# Comparison: Possible Implementations

The following table compares how three different technologies could implement the Node specific features.

| Feature                                                      | Current                                                  | Atomic                                                                                              | LVM based                                                                             |
|--------------------------------------------------------------|----------------------------------------------------------|-----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| **Build time**                                               |
| *Build tool*                                                 | koji / livecd-tools                                      | [ostree-builder](http://www.projectatomic.io/blog/2014/04/build-your-own-atomic-host-on-fedora-20/) | koji / lorax (livemedia-creator) or imgfac                                            |
| *Image specification*                                        | kickstart (recipe)                                       | kickstart (for installation) and `product.json` for tree                                            | kickstart (for installation) and kickstart (for tree compose)                         |
| **Delivery**                                                 |
| *Installation Media*                                         | LiveCD                                                   | boot.iso + embedded kickstart (LiveCD+ks)                                                           | LiveCD                                                                                |
| *Upgrade delivery*                                           | LiveCD in RPM                                            | ostree in RPM or with "Atomic Manager"                                                              | LiveCD in RPM or yum                                                                  |
| **Installation and Upgrade**                                 |
| *Installer*                                                  | custom (ovirt-node-installer)                            | anaconda                                                                                            | anaconda                                                                              |
| *Setup TUI*                                                  | custom (ovirt-node-setup)                                | custom (ovirt-node-setup)                                                                           | custom (ovirt-node-setup)                                                             |
| *Upgrade*                                                    | Image based / One main, one fallback LV                  | Tree based/ Many (os)trees on a rootfs                                                              | Image or package based / Many images in a VG or yum update                            |
| *Rollback*                                                   | Boot into other LV                                       | Boot into specific tree                                                                             | Boot into specific LV                                                                 |
| **Plugins**                                                  |
| *Plugin format*                                              | rpm                                                      | rpm                                                                                                 | rpm                                                                                   |
| *Runtime plugin installation*                                | N/A                                                      | N/A (currently)                                                                                     | Using a package manager **Limitation: bootloader should be prevented to be upgraded** |
| *Offline plugin installation*                                | Using edit-node, deploy new iso                          | Add package to (os)tree, build on server side, deploy new tree                                      | Using new libguestfs (or wrapper around it)                                           |
| **Persistence**                                              |
| *Data storage (for big files)*                               | /data is mounted to a Data LV                            | Writeable /var, mounted to another LV                                                               | Basically the whole fs, but /var should also be mounted to a separate LV              |
| *Persistence (for individual/random files) between boots*    | Using writeable Config LV and bind-mounts into target    

                                                                **Limitation: I.e. kernel modules can not be persisted**  | Writeable /etc                                                                                      

                                                                                                                           **Limitation: I.e. kernel modules can not be persisted**                                             | Writeable filesystem and/or Config LV                                                 |
| *Persistence (for individual/random files) between upgrades* | Using writeable Config LV and bind-mounts                

                                                                **Limitation: I.e. kernel modules can not be persisted**  | Copying /etc from N to N+1 and upgrade tree could be modified                                       

                                                                                                                           **Limitation: I.e. kernel modules can only be persisted in modified tree**                           | Copying whitelisted/new/glob/\* / files from N to N+1 (hook based mechanism)          |
| **\1**                                                      |                                                          |                                                                                                     |                                                                                       |

[Category: Node](Category: Node)
