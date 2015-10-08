---
title: IP-on-role-network
authors: yevgenyz
wiki_title: Feature/IP-on-role-network
wiki_revision_count: 2
wiki_last_updated: 2015-06-02
feature_name: IP address configuration on role bearing NICs
feature_modules: Networking
feature_status: design
---

# IP-on-role-network

## Summary

Currently it is possible to configure a role network (migration/display/gluster) on a NIC without specifying IP address configuration on it.

*   In case of migration with misconfigured migration network the migration would be performed on management network.
*   Misconfigured display network would make impossible connecting to VMs console.

The RFC is about to prevent such situations.

## Motivation

Make network roles actually do what they were designed for.

## Proposed solution

The proposed solution is two-phased:

1.  Preventing any **new** problematic network configuration - to be implemented in v3.6
    1.  Host setup network will block configuring a role bearing network without setting an IP (static/DHCP). That means any network configuration operation on the host will be blocked if a role bearing network on that host is configured improperly.
    2.  Assigning a role to a network will be blocked if one of the cluster hosts that already has the network don't have an IP protocol configured on it.
    3.  Network labels:
        1.  When a network label is assigned to a NIC and that will impose assigning a role network to the NIC the engine will verify that an IP is configured properly on the NIC.
        2.  When a network label is assigned to a role network the engine will verify that all NICs that the network is attached to them have proper IP configuration.

    4.  An event will be added to warn user of networks with non-VM roles that do not have IP. This should be added to event flood protection to make sure audit log is not badly affected.

2.  Enforcing the proper configuration on active hosts - to be implemented in a further version (supposedly 4.0). Failing validation will make a host non-operational and/or prevents it to be such. That will affect all flows that involve getCapabilities being run on a host, e.g.:
    1.  Any time the engine is restarted (e.g. engine upgrade).
    2.  User initiated refresh capabilities.
    3.  Activating a host.

In the second phase we might prevent the upgrade and/or worn user about a situation when active hosts will become non-operational after the upgrade.

## Links

*   ["RFE for phase 1 - v3.6"](https://bugzilla.redhat.com/show_bug.cgi?id=1163365)
*   ["RFE for phase 2 - next version"](https://bugzilla.redhat.com/show_bug.cgi?id=1220795)

<Category:Feature> <Category:Networking> [IP address configuration on role bearing NICs](Category:oVirt 3.6 Feature)
