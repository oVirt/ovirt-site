---
title: Infiniband
authors: suppentopf, sven
wiki_title: Infiniband
wiki_revision_count: 20
wiki_last_updated: 2014-01-23
---

# Infiniband

## Introduction

Although targeted at high performance computing Infiniband networks may be a quite cheap alternative to 10 Gigabit Ethernet. Nevertheless it is not an out of the box experience. So you expectations should never be to get close to wire speed but to be happy with every MB/s that you can reach beyond Giagbit Ethernet. This page should give a first impression for the interested reader what problems one might encounter.

## IPoIB

IP over Infiniband (IPoIB) is an encapsulation of TCP packets inside Infiniband packets. That adds a lot of overhead but comined with an NFS server it is the easiest setup that is fully supported within OVirt.

### Hypervisor node setup

On the hypervisor node you have to load the IPoIB required modules. These consist of the driver of your card, the transport and a managing module. For Mellanox ConnectX cards create a /etc/modules-load.d/ib.conf with the following lines

      mlx4_ib
      ib_ipoib
      ib_umad

After loading these modules you should see an Infiniband interface ib0 with ifconfig (additionally ib1 if you have a two port card). Add a new network inside OVirt and assign it with a static IP to the interface.

### Issue: Mellanox TSO bug

The kernel advertises TSO for Mellanox ConnectX cards although it is not supported. Therefore the hardware creates corrupt IP fragments on sender side during large requests and the receiving client cannot use LRO. The result of a lengthy discussion is stated [here](http://www.spinics.net/lists/linux-rdma/msg17787.html). So check if your Mellanox card has revision **a0**. Here an example of a non TSO compatible card:

      lspci | grep Mellanox
      03:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] (rev a0)

If you have such an old card disable TSO and make that setting permanent in some startup script.

      ` isOldCard=`lspci | grep Mellanox | grep a0 | wc -l` `
      if [ $isOldCard -gt 0 ]; then
        ethtool -K ib0 tso off
        ethtool -K ib1 tso off
      fi

### Issue: Old hardware and MTU 2044

If you are running on old switch hardware than your maximum IPoIB MTU will be limited to 2044 bytes. That is no problem at all - at least on switch level. On your NFS server and hypervisor nodes this can result in unneccessary CPU cycles and reduced throughput. Once again a reference to a [discussion thread](http://www.spinics.net/lists/linux-rdma/msg15133.html).

If you are not afraid of compiling kernels yourself and you know what you are doing than you can benefit from a dirty hack that limits the IPoIB MTU inside the kernel to 3072 bytes. With that receive operations will be served within a single 4K page and unneccessary copy operations can be avoided. Add the following modification to ipoib_add_port() in drivers/infiniband/ulp/ipoib/ipoib_main.c:

        ...
        if (!ib_query_port(hca, port, &attr))
          /* Limit max MTU to 3KB                                 */
          /* priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu); */
          priv->max_ib_mtu = 3072;
        else {
        ...
