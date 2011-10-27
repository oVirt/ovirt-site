---
title: Vdsm Network
category: vdsm
authors: danken, rmiddle
wiki_category: Vdsm
wiki_title: Vdsm Network
wiki_revision_count: 4
wiki_last_updated: 2012-05-28
---

# Vdsm Network

## Host Network Configuration

Vdsm defines a concept of "host network". These networks are configured by the following Vdsm verbs:

1.  addNetwork
     Add the required Linux networking devices for a new network, as well as the configuration files required to re-create these devices on next boot.
2.  delNetwork
     Delete a previously-added network.
3.  editNetwork
     Replace an existing network definition by a new one.
4.  setSafeNetConfig
     Declare network configuration as "safe", so it persists after host reboot.
5.  setupNetworks

Currently, host networks are implemented by Linux bridge devices, optionally connected to a vlan devices optionally connected to a bonding device, an optionally goes out of the host via a network interface card.

### Supported network topologies

bridge over interface card:

      blue bridge --------------------- nic

bridge over vlan over nic (br and br2 represent two different networks):

      bridge  --- v  ------------- nic
                                 /
      bridge2 --- v2 ------------

bridge over bond over several nics:

      bridge ----------- bond --- nic1
                              \
                               -- nic2

(several) bridges over vlans over bond over nics:

      bridge  --- v  --- bond --- nic1
                       /      \
      bridge2 --- v2 --        -- nic2

<Category:Vdsm>
