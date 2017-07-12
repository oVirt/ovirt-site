---
title: SetupNetworks SyncNetworks
authors: alkaplan, mkolesni
---

<!-- TODO: Content review -->

# SetupNetworks SyncNetworks

## What is "Sync Network"?

Logical Network definition can get out-of-sync with the Host network device for several reasons (stated below). This state will occur naturally even without the enhancement in place. We need to be able to notify the Admin when it happened & grant him control over the situation.

"Sync Network" is a proposed enhancement to "Setup Networks" feature which is targeted to the following cases:

*   When a host is added to the system it will by default receive a "management" network which is a VM network (implemented as bridge) with MTU 1500 and default boot-protocol details (TODO fill).

<!-- -->

*   When a host is moved between data-centers, it's "management" network (and other networks) might get out-of sync.
    -   For example, I have network "red" with MTU 9000 on DC1 where the host it and it's defined on eth1 on the host. When I move the host to DC2 where there is network "red" with MTU 1500, the new network setup will not be applied to the host's eth1 interface.

<!-- -->

*   Setup Networks will send network details only if the configuration changed, but how would it know that the new conigurations needs to be applied or not?

<!-- -->

*   Admin that wants the network to be out of sync (customly defined) can keep it like that.

There can be other solutions for these problems, for starters we can change the bootstrap installation script to set the network correctly, However, that means doubling the setup networks logic to the bootstrap script (also doubles the maintenance). Also this won't solve the other 2 issues. We can also add some code that fixes networks when host moves to different DC, but that also means some duplication and more maintenance.

Also, it is possible that the Admin would want the network definitions to stay custom for a reason, and doesn't want to sync them automatically.

Another option is the "Sync Network" enhancement.

The "Sync Network" enhancement is a way for clients which are calling "Setup Networks" to be able to report networks which are out of sync on a host's interfaces, and issue a request to sync those networks. The enhancement is not a new command, but rather a way to communicate more details when using "Setup Networks" on a host.

## When to Sync Network?

Network will be considered 'out of sync' on the following conditions:

*   VM Network is different.
*   VLAN ID is different.
*   MTU is set on the logical network, and is different.

When network is out of sync, it is considered as an unmanaged network, until synced. This means it cannot be edited or moved if it is out of sync, unless it is set to be synced.

## How to Sync Network?

The needed additions are:

### In Engine

*   We need to add a way to report if a network is out of sync.
    -   This information is already available to us in the DB, and can be calculated when needed.
    -   Today only the host's NICs are reported, and on them only the network name is available.

<!-- -->

*   Also need to provide an audit log when network(s) get automatically out of sync.

<!-- -->

*   Possible way to do this is to add an internal "Network Container" class which will hold for each NIC the network name + is it in sync or not.
    -   This can also be used to indicate other detials: Is network managed or not, etc.

<!-- -->

*   Also need a way to specify which network to sync.

<!-- -->

*   Possible way to do this is add a list of networks to sync to the SetupNetwork parameters.
    -   It can also be added to the network container, but it's best to keep the representation of is network in sync, and the order to sync it separately.

### In REST

*   Add fields to HostNIC entity:
    -   custom_configuration - boolean, status field to specify if the network definition on the NIC is in sync with logical definition or is it a custom definition.
    -   override_configuration - boolean, action field to set the NIC to be synced back to the logical network definition.

### In UI

*   Host in 3.0 and beneath version won't support sync functionality (derived from Setup Networks support).

<!-- -->

*   Setup Networks dialog-
    -   If the network is unsynced-
        1.  A "!" icon will be added to the network panel.
        2.  A "sync" check box will be added to the edit network panel.

## Other Considerations

*   Since management network is an oVirt centric network:
    -   Need to consider to always sync the management network when host is installed.
    -   Same as above, for host migration between DCs.
*   Old network commands are still supported (REST/host < 3.1)
    -   Should we allow to control this behaviour there?
*   Do we want to allow a broader approach, allowing the logical network properties to be specifically edited for a given NIC?
*   Perhaps we would want to expose unsync data in REST for cluster or even root networks context?
