---
title: IPAM
authors: mkolesni
---

<!-- TODO: Content review -->

# IPAM

## WIP

WIP,. do not take anything in this document as a declaration of intent, it is merely a textual representation of some design ideas..

## Expectation

We expect to have a capability of IP Address Management (IPAM) in oVirt, meaning that:

*   VM networks can have IPAM enabled
*   There can be one or more subnets in each network
*   Each vNIC on an IPAM enabled network can reserve an IP on one of the subnets of that network
*   The vNIC will receive the reserved IP through DHCP

## Enabling IPAM in oVirt

### Related entities

#### Network

The IPAM capability will be available on a per-network basis - For each network you can choose to enable IPAM or not. The network entity will have these new fields:

*   IPAM enabled
*   IPAM servers count (perhaps a general configuration value at first)

#### Subnet

If IPAM is enabled for a network, one ore more subnets can be defined on it. A subnet has the following properties:

*   Subnet IP
*   Netmask (must be valid)
*   Gateway IP
*   Optionally provide DNS, NTP properties

#### VM's vNIC

A vNIC will have an option to belong to a certain subnet on the network.

*   If a vNIC doesn't belong to any subnet, it will not receive IPAM service.
*   If a vNIC belongs to a subnet:
    -   It will get a dynamic IP from the subnet upon start of the vNIC (VM start. Plug, Re-link, etc).
    -   It will release it's IP back to the subnet upon stop of the vNIC (VM stop, Unplug, Re-link, etc).

### General behaviour

IPAM capability can be split to two sections:

*   Managing IP assignments
*   Delivering the IP assignments to the VM guest OS

The focus initially will be on providing both:

*   IP assignment will be managed internally by oVirt.
*   IP delivery to VM will be provided by DHCP (explanation later on).

#### Management Module

There will be an IPAM management module which is responsible on managing the service in an engine-level.

*   Once a network with IPAM enabled has at least one subnet defined, the IPAM management module will pick it up and attempt to provision it by making sure there are IPAM servers running for the network.
    -   The management module will seek out applicable hosts (they must have the network set-up already) and command them to serve IPAM capabilities for the network.
*   If a host that is serving as IPAM server goes down, the manager should attempt to stop it from serving as an IPAM server (best effort). and start another IPAM server on an applicable host.

This leads to the following requirements:

*   We need a way to mark & identify a host as an IPAM server.
*   The IPAM data should be persistent to recover from crash of the engine.
    -   i.e. it would be unhealthy to swap all IPAM servers upon service start, we need a way to keep track of them instead.
*   The DHCP servers should run in a "restricted" mode: They shouldn't allocate IP to a lease request, unless it is known to the server.

#### DHCP IPAM Provider

The DHCP IPAM providers have to support certain functionality:

*   Allow to start/stop a DHCP server for a number of networks on a given host.
*   Allow to reserve/release IPs.

The DHCP provider is responsible for the proliferation of reservations to the DHCP servers it is managing. When a new host is added, the reservations for the networks this host will provide IPAM for should be proliferated by the provider itself (i.e. there is no need to re-reserve the IP via an explicit call).

### Pseudo Code

#### Interface of a IPAM DHCP provider

      /**
       * An IPAM (IP Address Management) DHCP provider can provide IP allocations on a host for one or more networks. The IP
       * distribution is done via DHCP which is configured to provide only the allocations it knows about.
       */
**`interface` `IpamDhcpProvider` `{`**
          /**
           * Provide IPAM on the given host to the given networks.
            * If the networks list is empty then IPAM provisioning on will be turned off on this host.
           *
           * @param host
           *            The host to provide IPAM on.
           * @param networks
           *            The list of networks to provide IPAM for, on this host. Each network should contain the desired
           *            subnets for which the IPs will be provided.
           */
`    `**`void` `provide(Host` `host,` `List`<Network> `networks);`**
          /**
           * Stop providing IPAM on the given host. Same as calling {@link IpamDhcpProvider#provide(Host, List)} with an empty
           * networks list.
           *
           * @param host
           *            The host to stop providing IPAM for.
           */
`    `**`void` `dontProvide(Host` `host);`**
          /**
           * Add a reservation for the given MAC on the subnet. The provider will choose an available IP address.
           *
           * @param subnet
           *            The subnet to reserve on.
           * @param mac
           *            The MAC to reserve for.
           * @return The IP that was reserved.
           */
`    `**`IP` `addReservation(Subnet` `subnet,` `MAC` `mac);`**
          /**
           * Add a reservation of the given IP for the given MAC on the subnet.
           *
           * @param subnet
           *            The subnet to reserve on.
           * @param mac
           *            The MAC to reserve for.
           * @param ip
           *            The IP to reserve.
           */
`    `**`void` `addReservation(Subnet` `subnet,` `MAC` `mac,` `IP` `ip);`**
          /**
           * Remove the given IP reservation from the given subnet.
           *
           * @param subnet
           *            The subnet to remove from.
           * @param ip
           *            The IP reservation to remove.
           */
`    `**`void` `removeReservation(Subnet` `subnet,` `IP` `ip);`**
      }

#### Class that manages the IPAM per network

      public class IpamManager {
          private IpamDhcpProvider provider;
          @OnTimer
          public void manage() {
              for (Network net : getAllNetworks()) {
                  if (net.isIpamEnabled() && !net.getSubnets().isEmpty()) {
                      /*
                       * Balance number of hosts running IPAM for the network:
                       *  * If a host that is tracked as running IPAM is not up, attempt to stop the IPAM on it.
                       *  * Make sure that the amount of hosts providing IPAM for the network is running.
                       */
                  } else {
                      /* Stop IPAM for this network on all hosts that are running it (if there are any). */
                  }
              }
          }
          /**
           * Stop managing IPAM on the given host.
           *
           * @param host
           *            The host to stop managing.
           */
          public void stopManaging(Host host) {
              /* ... */
          }
      }
