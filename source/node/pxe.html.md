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

To prepare files, you need to do the following :

1. download the iso file :

      $ wget "`[`http://resources.ovirt.org/releases/beta/iso/ovirt-node-iso-2.6.1-20120228.fc18.iso`](http://resources.ovirt.org/releases/beta/iso/ovirt-node-iso-2.6.1-20120228.fc18.iso)`"

Check if you have script "/usr/bin/livecd-iso-to-pxeboot". If so, skip steps 2, 3 and 4.

You can also yum install livecd-tool to get the script.

2. Create a mountpoint :

      $ mkdir iso

3. Mount image on it :

      $ mount -o loop ovirt-node-iso-2.6.1-20120228.fc18.iso

4. Extract needed informations with provided script :

      $ ./iso/LiveOS/livecd-iso-to-pxeboot ovirt-node-iso-2.6.1-20120228.fc18.iso

or

      $ livecd-iso-to-pxeboot ovirt-node-iso-2.6.1-20120228.fc18.iso

You now have a ./tftpboot folder.

5. Put files "vmlinuz0" and "initrd0.img" somewhere publicly available via HTTP.

6. Open file tftpboot/pxelinux.cfg/default and copy all flags in APPEND line, and append it to 'kernel' line in pxe output.

This is an example of what needs to be outputed by ipxe script :

      #!ipxe
      kernel `[`http://path/to/vmlinuz0`](http://path/to/vmlinuz0)` rootflags=loop initrd=initrd0.img root=live:/ovirt-node-iso-2.6.1-20120228.fc18.iso rootfstype=auto ro liveimg nomodeset check rootflags=ro crashkernel=512M-2G:64M,2G-:128M elevator=deadline install quiet rd.lvm=0 rd.luks=0 rd.md=0 rd.dm=0
`initrd `[`http://path/to/initrd0.img`](http://path/to/initrd0.img)
      boot

Boot your server on IPXE : ISO is loaded through the network. Play with boot parameters on line 'kernel' above to pass custom parameters.

<Category:Node>
