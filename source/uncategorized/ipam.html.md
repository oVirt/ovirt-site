---
title: IPAM
authors: mkolesni
wiki_title: IPAM
wiki_revision_count: 3
wiki_last_updated: 2012-12-05
---

# IPAM

## WIP

WIP,. do not take anything in this document as a declaration of intent, it is merely a textual representation of some design ideas..

## Expectation

We expect to have a capability of IP Address Management (IPAM) in oVirt, meaning that:

*   VM networks can have IPAM enabled
*   There can be one or more subnets in each network
*   Each vNIC on an IPAM enabled network can reserve an IP on one of the subnets of that network
*   The vNIC will receive the reserved IP through DHCP

## General behaviour

The IPAM capability will be available on a per-network basis - For each network you can choose to enable IPAM or not. The network entity will have these new fields:

*   IPAM enabled
*   IPAM servers count (perhaps a general value at first)

If IPAM is enabled for a network, one ore more subnets can be defined on it bearing the following properties:

*   Network IP
*   Netmask (must be valid)
*   Gateway IP
*   Optionally provide DNS properties

Once a network with IPAM and at least one subnet is defined, the IPAM management module will pick it up and attempt to provision it by making sure there are IPAM servers running for the network. The management module will seek out applicable hosts (they must have the network set-up already) and enable them to serve IPAM capabilities for the network. Every time a network/subnet is modified the manager will pick up the changes and apply them in an asynchronous manner (in respect to the modification). If a host that is serving as IPAM server goes down, the manager should attempt to stop it from serving as IPAM server.

This leads to the following requirements:

*   We need a way to mark & identify a host as IPAM server.
*   The IPAM data should be persistent to recover from crash of the engine.
    -   It would be unhealthy to swap all IPAM servers upon service start, we need a way to keep track instead.
*   The IPAM capability will be provided by dedicated DHCP servers which run in a "restricted" mode: They can't allocate IP to a lease request, unless it is known to the server.

The DHCP IPAM providers have to support certain functionality:

*   Allow to start/stop a DHCP server for a number of networks on a given host.
*   Allow to reserve/release IPs.

### Pseudo Code

Interface of a IPAM DHCP provider:

      /**
       * An IPAM (IP Address Management) DHCP provider can provide IP allocations on a host for one or more networks. The IP
       * distribution is done via DHCP which is configured to provide only the allocations it knows about.
       */
**`interface` `IpamDhcpProvider` `{`**
          /**
           * Provide IPAM on the given host to the given networks.
            * If the networks list is empty then IPAM provisioning on will be turned off on this host.
           *
           * @param host
           *            The host to provide IPAM on.
           * @param networks
           *            The list of networks to provide IPAM for, on this host. Each network should contain the desired
           *            subnets for which the IPs will be provided.
           */
`    `**`void` `provide(Host` `host,` `List`<Network> `networks);`**
          /**
           * Stop providing IPAM on the given host. Same as calling {@link IpamDhcpProvider#provide(Host, List)} with an empty
           * networks list.
           *
           * @param host
           *            The host to stop providing IPAM for.
           */
`    `**`void` `dontProvide(Host` `host);`**
          /**
           * Add a reservation of the given IP for the given MAC on the subnet.
           *
           * @param subnet
           *            The subnet to reserve on.
           * @param mac
           *            The MAC to reserve for.
           * @param ip
           *            The IP to reserve.
           */
`    `**`void` `addReservation(Subnet` `subnet,` `MAC` `mac,` `IP` `ip);`**
          /**
           * Remove the given IP reservation from the given subnet.
           *
           * @param subnet
           *            The subnet to remove from.
           * @param ip
           *            The IP reservation to remove.
           */
`    `**`void` `removeReservation(Subnet` `subnet,` `IP` `ip);`**
      }

Class that manages the IPAM per network:

      public class IpamManager {
          private IpamDhcpProvider provider;
          @OnTimer
          public void manage() {
              for (Network net : getAllNetworks()) {
                  if (net.isIpamEnabled() && !net.getSubnets().isEmpty()) {
                      /*
                       * Balance number of hosts running IPAM for the network:
                       *  * If a host that is tracked as running IPAM is not up, attempt to stop the IPAM on it.
                       *  * Make sure that the amount of hosts providing IPAM for the network is running.
                       */
                  } else {
                      /* Stop IPAM for this network on all hosts that are running it (if there are any). */
                  }
              }
          }
          /**
           * Stop managing IPAM on the given host.
           *
           * @param host
           *            The host to stop managing.
           */
          public void stopManaging(Host host) {
              /* ... */
          }
      }
