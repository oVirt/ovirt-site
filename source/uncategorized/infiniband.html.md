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

### Issues
