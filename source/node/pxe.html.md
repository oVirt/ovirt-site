---
title: Node PXE
category: node
authors: fabiand, mburns, mpavlik, netbulae, odoucet, rbarry, vered
wiki_category: Node
wiki_title: Node PXE
wiki_revision_count: 8
wiki_last_updated: 2014-07-14
---

# Node PXE

You can boot an ovirt-node ISO image directly via PXE.

To prepare files the files necessary to PXE boot, you need to do the following :

*   Download the ISO file:

<!-- -->

    wget http://resources.ovirt.org/releases/3.2/iso/ovirt-node-iso-2.6.1-20120228.fc18.iso

Check whether or not you have:

    /usr/bin/livecd-iso-to-pxeboot

If so, skip steps 2 and 3.

If not, you can try to install it with

    yum install livecd-tools

Manually:

*   Create a mountpoint :

<!-- -->

    mkdir iso

*   Mount the image :

<!-- -->

    mount -o loop ovirt-node-iso-2.6.1-20120228.fc18.iso iso

*   Extract needed informations with provided script :

<!-- -->

    /iso/LiveOS/livecd-iso-to-pxeboot ovirt-node-iso-2.6.1-20120228.fc18.iso

    livecd-iso-to-pxeboot ovirt-node-iso-2.6.1-20120228.fc18.iso

You now have a ./tftpboot folder.

*   Put files "vmlinuz0" and "initrd0.img" somewhere publicly available via HTTP or TFTP, depending on whether you're using iPXE or not.

<!-- -->

*   Open tftpboot/pxelinux.cfg/default and add the arguments to your pxelinux.cfg if you're using pxelinux. If you're using iPXE:

This is an example of what needs to be returned by your iPXE :

     kernel http://path/to/vmlinuz0 rootflags=loop initrd=initrd0.img root=live:/ovirt-node-iso-2.6.1-20120228.fc18.iso rootfstype=auto ro liveimg nomodeset check rootflags=ro crashkernel=512M-2G:64M,2G-:128M elevator=deadline install quiet rd.lvm=0 rd.luks=0 rd.md=0 rd.dm=0
     initrd http://path/to/initrd0.img
     boot

Play with boot parameters on line 'kernel' above to pass custom parameters.

<Category:Node>
