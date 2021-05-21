---
title: Infiniband
authors:
  - suppentopf
  - sven
---

# Infiniband

## Introduction

Although targeted at high performance computing Infiniband networks may be a quite cheap alternative to 10 Gigabit Ethernet. Nevertheless it is not an out of the box experience. So your expectations should never be to get close to wire speed but to be happy with every MB/s that you can reach beyond Giagbit Ethernet. This page should give a first impression for the interested reader what problems one might encounter.

## IPoIB

IP over Infiniband (IPoIB) is an encapsulation of TCP packets inside Infiniband packets. That adds a lot of overhead but combined with an NFS server it is the easiest setup that is fully supported within OVirt.

### Hypervisor node setup

On the hypervisor node you have to load the IPoIB required modules. These consist of the driver of your card, the transport and a managing module. For Mellanox ConnectX cards create a /etc/modules-load.d/ib.conf with the following lines

      mlx4_ib
      ib_ipoib
      ib_umad

After loading these modules you should see an Infiniband interface ib0 inside Ovirt (additionally ib1 if you have a two port card). Add a new network as usual and assign it with a static IP to the interface.

### Issue: Mellanox TSO bug

The kernel advertises TSO for Mellanox ConnectX cards although it is not supported. Therefore the hardware creates corrupt IP fragments on sender side during large requests and the receiving client cannot use LRO. The result of a lengthy discussion is stated [here](http://www.spinics.net/lists/linux-rdma/msg17787.html). So check if your Mellanox card has revision **a0**. Here an example of a non TSO compatible card:

      lspci | grep Mellanox
      03:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] (rev a0)

If you have such an old card disable TSO and make that setting permanent in some startup script.

      ` isOldCard=`lspci | grep Mellanox | grep a0 | wc -l` `
      if [ $isOldCard -gt 0 ]; then
        ethtool -K ib0 tso off
        ethtool -K ib1 tso off
      fi

### Issue: Old hardware and MTU 2044

If you are running on old switch hardware than your maximum IPoIB MTU will be limited to 2044 bytes. That is no problem at all - at least on switch level. On your NFS server and hypervisor nodes this can result in unneccessary CPU cycles and reduced throughput. Once again a reference to a [discussion thread](http://www.spinics.net/lists/linux-rdma/msg15133.html).

If you are not afraid of compiling kernels yourself and you know what you are doing than you can benefit from a dirty hack that limits the IPoIB MTU inside the kernel to 3072 bytes. With that receive operations will be served within a single 4K page and unneccessary copy operations can be avoided. Add the following modification to ipoib_add_port() in drivers/infiniband/ulp/ipoib/ipoib_main.c:

        ...
        if (!ib_query_port(hca, port, &attr))
          /* Limit max MTU to 3KB                                 */
          /* priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu); */
          priv->max_ib_mtu = 3072;
        else {
        ...

## NFS over RDMA

In this setup NFS sunrpc layer driectly accesses the basic infiniband mechanisms to exchange data between NFS server and client. The configuration is explained [here](https://www.kernel.org/doc/Documentation/filesystems/nfs/nfs-rdma.txt) and might have some bugs:

*   [Cannot read more than 812 bytes from NFS server file](https://bugzilla.redhat.com/show_bug.cgi?id=1046011): The bug can occur between kernels 3.7 and 3.13. It should be fixed with [this commit](http://article.gmane.org/gmane.linux.nfs/60953)
*   [NFS crashes](http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg14145.html): Not yet tested/observed.

At the moment OVirt does not allow to mount NFS shares over RDMA. So the only option is to modify the mount operation in /usr/share/vdsm/storage/storageServer.py yourself.

      ...
      class NFSConnection(object):
        DEFAULT_OPTIONS = ["soft", "nosharecache", "rdma", "port=20049"]
      ...

A reqeust for enhancement of OVirt has been created as Redhat Bug [1057043](https://bugzilla.redhat.com/show_bug.cgi?id=1057043)

## SRP

SCSI Remote Protocol can be compared to iSCSI and comes close to wire speed. It is not yet implemented in OVirt.
