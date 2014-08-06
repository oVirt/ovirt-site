---
title: IsolatedNetworks
category: feature
authors: moti, sandrobonazzola
wiki_category: Feature
wiki_title: Features/IsolatedNetworks
wiki_revision_count: 11
wiki_last_updated: 2014-12-08
feature_name: Nicless Network
feature_modules: Networking
feature_status: Design
---

# Isolated Networks

### Owner

*   Name: [ Moti Asayag](User:masayag)
*   Email: masayag@redhat.com

## Summary

The current host networking api (up to ovirt-engine-3.6) requires a network to be configured on top of a network interface.
In order to configure a local network on the host the user had to create a dummy interface to which the network was attached.
The Nicless Network feature aimed to configure a local host on the network which isn't connected to any network interface and allows vms which are connected to it to communicate with each other.
Nicless Networks will be limited to VM networks only.

## Benefit to oVirt

Local networks are desired for enabling a secured connectivity among vms in an isolated matter.

### Detailed Description

Based on [Host Networking API design](Features/HostNetworkingApi), removing the constraint of having a network interface configured for each network connection will allow the user to create a network connection which isn't bounded to any network interface.
Nicless networks will be represented on host level to reflect not being tied to any network interface:
\* When network connection entity on host level is associated with an interface - it will be referred to as nic network.

*   When network connection entity on host level is *not* associated with any interface - it will be refereed to as a nicless network.

### REST

#### Network connections sub-collection

*   A collection of network connections which represent how the network is provisioned on the host

       /api/hosts/{host:id}/networkconnections

*   Supported actions:
    \*# **GET** returns a list of networks configured on the host

    \*# **POST** provision a network on the host

Where the networkconnection element will omit the host_nic element from the request.

#### Network connecton resource

       /api/hosts/{host:id}/networkconnections/{networkconnection:id}

*   Supported actions:
    \*# **GET** returns a specific network configured on the host

    \*# **PUT** update a network configured on the host

    \*# **DELETE** removes a network from the host

#### Network connecton statistics sub-collection

       /api/hosts/{host:id}/networkconnections/{networkconnection:id}/statistics

*   Supported actions:
    \*# **GET** returns a specific statistics for a network (if reported) which is attached to the host

#### Host Network Label resource

A collection designed to specify network labels on host level which aren't bounded to a specific nic.
Using this resource, nic-less networks could be configured on host.

       /api/hosts/{host:id}/networklabels/

*   **GET** - list host network labels
*   **POST** - add a label to the host

       /api/hosts/{host:id}/networklabels/{networklabel:id}

*   **GET** - returns a specific host network label
*   **DELETE** - removes a specific host network label

**pros**: Using host level network labels we can support nic-less networks auto-provision
**cons**: The management of labels becomes more complex, cannot use same label for nics

*   Due to the nature of nicless network, they will not be allowed to be managed via the setupnics action.

<Category:Feature> <Category:Networking>
