---
title: Unrestricted Network Names
category: feature
authors: danken
wiki_category: Feature
wiki_title: Features/Unrestricted Network Names
wiki_revision_count: 18
wiki_last_updated: 2014-07-22
---

# Unrestricted Network Names

#### Summary

Let users give any name to their network

### Owner

*   Name: [ Dan Kenigsberg](User:Danken)

<!-- -->

*   Email: <danken@redhat.com>

### Current status

*   Not yet scheduled to a specific release
*   Last updated: ,

### Detailed Description

Currently, oVirt limits the names of its networks to 15 alphanumeric characters. This limitation dates back to the ages where all networks were VM network, all were implemented by a Linux bridge, and the same name was used to identify the network and the Linux bridge implementing it on each host.

That has to change. 15 characters are not enough for humans; spaces, and other special characters are visually useful, and non-English speaking users would love to use their native alphabet in network names.

### Benefit to oVirt

*   The limitations on network names seem arbitrary and annoy users.
*   It's plain wrong to expose Linux's IFNAMSIZ all the way up to the GUI.

### Dependencies / Related Features

Currently, the Engine/Vdsm API hinges on the network name, and assumes that (for VM networks) the created bridge would be named just like network. Any solution must allow migration of VMs from existing hosts to hosts with this new feature enabled.

### Possible Solutions

#### Cryptographic Hash

We can lift the limitation on network names with no further change to the Engine/Vdsm API. When Vdsm receives a long name (or a name with funny chars) it would hash it to produce a name for the underlying bridge. Vdsm already reports the bridge underlying each network; the only change is that the name is computed by Vdsm and not copied. When participating in an older clusterLevel, Vdsm must use the (short) network name as it is, with no hashing involved.

Since the network name is controlled by the users ("chosen plaintext"), it's safer to use a cryptographic hash in order to avoid collisions (two different networks mapped to the same bridge).

Pros:

*   No change to the current API. There's almost no change on Engine side. Implementation is expected to be short.

Cons:

*   On-host bridge names are no longer human-readable. Given the hashed name, it's much harder for QE and support to map back to the complete network name.

#### Added Argument

The current Engine/Vdsm API keys networks based on their names, and that name is used for the created Linux bridge. We can add an explicit `bridgeName` argument per network, which would be passed to hosts in new clusterLevel. If exists, that name would be used for the bridge name. `bridgeName` would be taken as a prefix of the network's UUID.

Pros:

*   Very simple to implement on Vdsm. No need for complex hashing on Vdsm. Work is pretty limited on Engine side either.

Cons:

*   Exposes an implementation detail (the name of the Linux bridge) into the API

#### Use UUID for net names

Instead of passing the user-defined network name to Vdsm, Engine would use the network UUID (or a slice thereof).

Pros:

*   If a IFNAMSIZ-long slice is used, there's almost no change at all on Vdsm side. (The only one is that Vdsm cannot assume the management role of a network based on its `ovirtmgmt` name)
*   That what OpenStack Neutron does; that's an important argument when it provides networks to oVirt.
*   The "name" of a network becomes a user-editable string, that can be changed with no effect on the distributed hosts.

Cons:

*   When debugging a host, the user-chosen name would not be available. This condition already exists with disk names, and is [not loved by users](http://lists.ovirt.org/pipermail/users/2013-December/019079.html). To avoid that, we can add a "description" field per network, where Engine would pass the human-readable name/description of the network, to be stored in the ifcfg file or as a comment in the libvirt definition of the network.

CAVEAT: upgrade A cluster of level 3.4 has to use short network names, for backward compatibility. But even if all of its hosts have been upgraded to 3.5, it would need to keep using the short names - since running VMs keep referring to them, and hosts have them configured. On an upgraded cluster, existing networks should keep their short names. New networks, can have unrestricted names, and have their UUID used in the API.

#### Documentation / External references

*   TBD

#### Comments and Discussion

*   Refer to [Talk:Unrestricted Network Names](Talk:Unrestricted Network Names)

<Category:Feature> <Category:Networking>
