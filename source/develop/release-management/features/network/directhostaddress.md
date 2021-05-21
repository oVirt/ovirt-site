---
title: DirectHostAddress
category: feature
authors:
 - danken
 - moti
 - msalem
---

# Direct Host Address

------------------------------------------------------------------------

## Summary

The Direct Host Address feature will allow the admin to define a "direct" IP address on a host, for SSH purposes, without necessarily managing this network interface through ovirt.

## Owner

    * Feature owner: [ Muli Salem](User:msalem)

    * Backend Component owner: [ Muli Salem](User:msalem)

    * GUI Component owner: [ ?](User:?)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

## Current status

*   Status: Design

## Detailed Description

When adding a host, admin sets the host address. The engine uses this address to manage the host in two ways. The first is via SSH for host installation, and the second is via xml-rpc for any other action. Current behaviour assumes the network interface with the specified address is configured properly in the engine although this may not be the case initially.

The direct address allows the engine to connect to the host, without knowing the exact configuration of the network interface that has the address.

The direct IP address will be optional, and when not specified by the admin, the regular host address will be used. Also, certificate exchanging between the host and the engine will be left unchanged, namely the engine will keep a certificate for the regular host address.

## Motivation

To allow another route to the host to a network interface other than the one used for the management network, since that network interface may need to be configured in the engine first.

## Design

#### Engine

In AddVdsCommand and UpdateVdsCommand, the InstallVdsCommand is called with InstallVdsParameters. We will add the direct address as a parameter, so that this address will be used in case it is given. Otherwise, behaviour remains the same - the Vds address is the one used for host installation.The direct address is transient and won't be stored on engine as part of the host configuration.

#### API Changes

The tag <direct_address> will be added to the host resource /api/hosts/{host:id}:

`   `<host id="56d6d62f-6af0-4c02-8500-4be041180031">
             ...
             

<address>
10.35.1.160

</address>
`       `<direct_address>`10.35.1.162`</direct_address>
             ...
`   `</host>

#### UI Changes

When admin clicks add host, the Advanced Parameters option will be added, and when opened will allow entering a direct address:

Advanced Parameters closed:

![](/images/wiki/AddHostClosed.png)

Advanced Parameters opened:

![](/images/wiki/AddHostOpened.png)

When admin clicks reinstall for a host, the Advanced Parameters option will be added, and when opened will allow entering a direct address:

Advanced Parameters opened:

![](/images/wiki/Installhostopened.png)

## Open Issues

## Dependencies / Related Features

Affected projects:

*   engine
*   Rest API
*   Webadmin

## Documentation / External references


------------------------------------------------------------------------

