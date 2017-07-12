---
title: Specs
category: node
authors: fabiand
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

| Feature                                                      | Current                                                                                                                                                                                                                   | Container                 | [Atomic](http://www.projectatomic.io/)                                                                                                                                                                                                                             | [LVM based](https://github.com/fabiand/imgbased/)                                                                                                                                                                                                                                                                                     |
|--------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Build time**                                               |
| *Build tool*                                                 | koji / livecd-tools                                                                                                                                                                                                       | docker                    | [ostree-builder](http://www.projectatomic.io/blog/2014/04/build-your-own-atomic-host-on-fedora-20/), koji                                                                                                                                                          | koji / lorax (livemedia-creator) or imgfac                                                                                                                                                                                                                                                                                            |
| *Image specification*                                        | kickstart (recipe)                                                                                                                                                                                                        | Dockerfile                | kickstart (for installation) and `product.json` for tree                                                                                                                                                                                                           | kickstart (for installation) and kickstart (for tree compose)                                                                                                                                                                                                                                                                         |
| **Delivery**                                                 |
| *Installation Media*                                         | CD, USB, CF, PXE                                                                                                                                                                                                          | Container                 | Inheriting from anaconda (at least CD, USB, PXE)                                                                                                                                                                                                                   | Inheriting from anaconda (at least CD, USB, PXE)                                                                                                                                                                                                                                                                                      |
| *Upgrade delivery*                                           | Image on LiveCD in RPM                                                                                                                                                                                                    | Container                 | ostree with "Atomic Manager" or offline-tree                                                                                                                                                                                                                       | (plain) Image or Image on Livecd in RPM, or for packages through update channels                                                                                                                                                                                                                                                      |
| **Installation/Upgrade**                                     |
| *Installer*                                                  | ovirt-node-installer                                                                                                                                                                                                      | N/A                       | anaconda                                                                                                                                                                                                                                                           | anaconda 'Notes: Could be improved ([liveimg support in textmode](https://bugzilla.redhat.com/show_bug.cgi?id=1099222) and ["raw" payload installation](https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&component=anaconda))'                                                                                                |
| *Driver disks*                                               | N/A                                                                                                                                                                                                                       | Maybe                     | Soon                                                                                                                                                                                                                                                               | Yes                                                                                                                                                                                                                                                                                                                                   |
| *Host-Configuration TUI*                                     | ovirt-node-setup                                                                                                                                                                                                          | ovirt-node-setup          | ovirt-node-setup                                                                                                                                                                                                                                                   | ovirt-node-setup                                                                                                                                                                                                                                                                                                                      |
| *Upgrade*                                                    | Partition based, one active, one backup/for upgrades                                                                                                                                                                      | Container                 | Tree based/ Many (os)trees on a rootfs                                                                                                                                                                                                                             | Image or package based / Many images in a VG or for packages with yum update                                                                                                                                                                                                                                                          |
| *Rollback*                                                   | Boot into other partition                                                                                                                                                                                                 | Launch an older container | Boot into specific tree                                                                                                                                                                                                                                            | Boot into specific LV                                                                                                                                                                                                                                                                                                                 |
| **Plugins**                                                  |
| *Plugin format*                                              | rpm                                                                                                                                                                                                                       | N/A                       | rpm                                                                                                                                                                                                                                                                | rpm                                                                                                                                                                                                                                                                                                                                   |
| *Runtime plugin installation*                                | N/A                                                                                                                                                                                                                       | N/A                       | [POC for rpm installation](https://github.com/cgwalters/atomic-pkglayer)                                                                                                                                                                                           | Using a package manager (rpm, yum) or a cfg mgmt system **Limitation: bootloader should be prevented to be upgraded**                                                                                                                                                                                                                 |
| *Offline plugin installation*                                | Using edit-node, deploy new iso                                                                                                                                                                                           | Extending the Dockerfile  | Add package to (os)tree, build on server side, deploy new tree                                                                                                                                                                                                     | Using libguestfs (or wrapper around it) or a different compose process                                                                                                                                                                                                                                                                |
| **Persistence**                                              |
| *Data storage (for big files)*                               | On a separate storage (/data is on another LV)                                                                                                                                                                            | Available                 | On a separate storage (/var is on another LV)                                                                                                                                                                                                                      | On a separate storage (another LV), could also be /                                                                                                                                                                                                                                                                                   |
| *Persistence (for individual/random files) between boots*    | Persisted paths are kept on a separate LV (/config) and are bind-mounted into place at boot by a service **Limitation: I.e. the boot process can not be changed and kernel modules can not be persisted**                 | Like inside any container | Changes can be made to files in /etc **Limitation: I.e. the boot process can not be changed and kernel modules can not be persisted**                                                                                                                              | Like any normal system, as the filesystem is writable                                                                                                                                                                                                                                                                                 |
| *Persistence (for individual/random files) between upgrades* | (same as above) This effectively means that persisted files are "copied" or "kept as is" between upgrades. Additional logic can take place in the upgrade logic. **Limitation: I.e. kernel modules can not be persisted** | Available                 | Effectively a ["rebase" or three-way merge](http://www.projectatomic.io/docs/os-updates/). The changes done to the previous config, are identified and applied to the new configuration **Limitation: I.e. kernel modules can only be persisted in modified tree** | Unclear for now, but several possible: [Keeping, copying, three-way merge, or individual handling](http://dummdida.tumblr.com/post/104188116490/ways-to-persist-a-reminder) (i.e by a service which is responsible to [migrate a config file on upgrade (see ConditionNeedsUpdate)](http://0pointer.net/blog/projects/stateless.html) |
| **Host integration**                                         |
| *General*                                                    | Occupying the OS                                                                                                                                                                                                          | Very difficult            | Possibly                                                                                                                                                                                                                                                           | Native                                                                                                                                                                                                                                                                                                                                |
| *KDump*                                                      | Available                                                                                                                                                                                                                 | Difficult                 | Difficult                                                                                                                                                                                                                                                          | Native                                                                                                                                                                                                                                                                                                                                |
| **\1**                                                      |                                                                                                                                                                                                                           |                           |                                                                                                                                                                                                                                                                    |                                                                                                                                                                                                                                                                                                                                       |

[Category: Node](Category: Node)
