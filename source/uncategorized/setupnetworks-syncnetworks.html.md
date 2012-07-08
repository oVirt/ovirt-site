---
title: SetupNetworks SyncNetworks
authors: alkaplan, mkolesni
wiki_title: SetupNetworks SyncNetworks
wiki_revision_count: 13
wiki_last_updated: 2012-09-02
---

# SetupNetworks SyncNetworks

## What is Sync Network?

"Sync Network" is a proposed enhancement to "Setup Networks" feature which is targeted to solve a few issues:

1. When a host is added to the system it will by default receive a "management" network which is a VM network (implemented as bridge) with MTU 1500 and default boot-protocol details (TODO fill).

2. When a host is moved between data-centers, it's "management" network (and other networks) might get out-of sync. For example, I have network "red" with MTU 9000 on DC1 where the host it and it's defined on eth1 on the host. When I move the host to DC2 where there is network "red" with MTU 1500, the new network setup will not be applied to the host's eth1 interface.

3. Setup Networks will send network details only if the configuration changed, but how would it know that the new conigurations needs to be applied or not?

There can be other solutions for these problems, for starters we can change the bootstrap installation script to set the network correctly, However, that means doubling the setup networks logic to the bootstrap script (also doubles the maintenance). Also this won't solve the other 2 issues. We can also add some code that fixes networks when host moves to different DC, but that also means some duplication and more maintenance.

Another option is the "Sync Network" enhancement.

The "Sync Network" enhancement is a way for clients which are calling "Setup Networks" to be able to report networks which are out of sync on a host's interfaces, and issue a request to sync those networks. The enhancement is not a new command, but rather a way to communicate more details when using "Setup Networks" on a host.

## How to Sync Network?

The needed additions are:

### In Engine

*   We need to add a way to report if a network is out of sync.
    -   This information is already available to us in the DB, and can be calculated when needed.
    -   Today only the host's NICs are reported, and on them only the network name is available.

<!-- -->

*   Possible way to do this is to add an internal "Network Container" class which will hold for each NIC the network name + is it in sync or not.
    -   This can also be used to indicate other detials: Is network managed or not, etc.

<!-- -->

*   Also need a way to specify which network to sync.

<!-- -->

*   Possible way to do this is add a list of networks to sync to the SetupNetwork parameters.
    -   It can also be added to the network container, but it's best to keep the representation of is network in sync, and the order to sync it separately.

### In REST

### In UI
