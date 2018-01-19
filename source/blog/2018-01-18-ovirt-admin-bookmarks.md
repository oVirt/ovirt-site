---
title: oVirt 4.2.2 web admin UI browser bookmarks
author: awels,
tags: oVirt
date: 2018-01-19 12:00:00 CET
---

oVirt web admin UI now allows the user to bookmark all entities and searches using their browser.

READMORE

## Synchronizing URL with application state

Whenever you select a detail view in the application, the browser URL is now updated to match the selected entity. For instance if you have a VM named MyVM and you click on the name to see the details, the URL of the browser will go to #vms-general;name=MyVM. If you switch to lets say the network interfaces tab the URL in your browser will switch to #vms-network_interfaces;name=MyVM. Changing entity or changing location will keep the browser URL synchronized. This allows you to use your browsers bookmark functionality to store a link to that VM.

## Direct linking to entities

As a complementary functionality you can pass arguments to places that will execute some functionality based on the type of argument you have passed in. The following types are available:

* SEARCH, is for main views only, this allows you to pre populate the search string used in the search bar.
* NAME, most entities are uniquely named and you can use their name in a detail view to go directly to that named entity.
* DATACENTER, quota and networks are not uniquely named, but are unique combined with their associated data center, to link directly to either you need to specify NAME and DATACENTER.
* NETWORK, VNIC profiles are not uniquely named, but need both DATACENTER and NETWORK to be specified to directly link to it. 

If the user isn't already logged in, they will be redirected to oVirt SSO login page and then back to the desired place in the application. This allows external applications to directly link to entities in web admin UI.

### Examples

* #vms-general;NAME=MyVM will take you to general detail tab for the MyVM virtual machine.
* #hosts-devices;NAME=host will take you to the devices detail tab for the 'host' host.
* #networks;search=name+%255C2+ovirt* will take you to the networks main view and the search will be prefilled with 'name = ovirt*'.
* #vnicProfiles-virtual_machines;name=test;dataCenter=test;network=test will take you directly to the VNIC profile test, in data center test, and network test.
* #networks-clusters;name=test;dataCenter=test will take you directly to the clusters detail tab with the 'test' network for data center test.
