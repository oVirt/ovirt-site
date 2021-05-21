---
title: Scoped MacPoolManager
category: api
authors:
  - mkolesni
  - mmucha
  - moti
  - mpavlik
---

<!-- TODO: Content review -->

# Scoped MacPoolManager

__TOC__

## Summary

Previously there was sole pool of MACs, it's MAC ranges for this pool could be configured via engine-config. After change data center have one MAC pool associated and MAC pools cannot be configured via engine-config. And finally MAC pool assignment was moved from data center to cluster level.

## Owner

Name: Martin Mucha

## Benefit to oVirt

Definition of domains from which MAC addresses will be allocated for each ~~data center~~ cluster.

## Details

*   pools are named, and can be shared between multiple ~~data centers~~ clusters.
*   whether MAC pool can be used for specific ~~DataCenter~~ cluster is determined via user permissions.
*   duplicity allowance is set on pool level, not via global config values.
*   there is always one default pool available(replacement for former global pool). This can be used when ~~data center~~ does not create own one pool. During upgrade only this pool is created and all existing ~~data centers~~ clusters will use it. This pool is also created on clean install. After upgrade/clean install ranges and duplicity setting will be same as now: macRanges: 00:1a:4a:1a:83:00-00:1a:4a:1a:83:ff, allowDuplicates: false. When user overrode those default values, those values will be used instead.
*   all pools are accessible through rest
*   pool definition is mandatory on ~~data center~~ cluster. Each ~~data center~~cluster has one MAC Pool associated.
*   when specifying MAC ranges for one pool, all potential MAC range overlaps/intersections are removed. When duplicates turned off(per pool setting), one MAC can be used only once in that pool. Example: lets have two pools with two same ranges. This is ok. Duplicity allowance setting is per pool, like said above. One allows it, second does not. Thus even if duplicates are turned off in this pool, this MAC can be used multiple times in another pool.
*   each pools is initialized during start-up. When creating new/updating/removing MAC pool is (re)initialized/removed in respect to that.
*   When one update MAC ranges for given MAC pool, MAC addresses of existing nics currently will not get reassigned. Used MACs assigned from previous range definition will be added as an user specified MACs if they are now out of pool ranges. That means, that MAC is still tracked by that pool, but if pool ranges alteration makes that MAC to be outside of that newly defined ranges, it will be outside of those ranges. There will be no effort in stop using that MAC and assigning new ones.
*   You should try to avoid to allocate MAC which is outside of ranges of configured MAC pool(either global or scoped one). It's perfectly OK, to allocate specific MAC address from inside these ranges, actually is little bit more efficient than letting system pick one for you. But if you use one from outside of those ranges, your allocated MAC end up in less memory efficient storage(approx 300 times less efficient). So if you want to use user-specified MACs, you can, but tell system from which range those MACs will be(via MAC pool configuration).
*   When ~~DataCenter~~ cluster definition changes so that after change different pool is used, all MACs belonging to that ~~data center~~ cluster are removed from old pool and reinserted to new one.
*   you can use same MACs on multiple ~~data centers~~ clusters. Currently no checks are done to find out whether pool definition for multiple ~~data centers~~cluster overlap or not. So if you define your pools in that way, that MAC ranges overlaps, one MAC address can be used multiple times. I'd observe that as an user error, since it's easier to stick with one global pool with allowed duplicates.

## User Experience

### GUI

*   pool are assigned to ~~DataCenter~~ cluster in ~~datacenter~~ cluster dialog.
*   pools are managed from app config, where was added new tab for pools. Here you can find out, in which places is pool used.
*   there's plan to creating new dialog, where all clusters are listed and where you can assign different mac pools to many clusters at once.

Below is three screenshots. 'New/edit MAC pool pane' is shared component used both in new tabs of ~~datacenter~~ cluster dialog and systemconfig, which are remaining two screenshots.

![](/images/wiki/NewMacAddressPool.png)

dialog for creating/editing MAC Pool data (name, description, duplicity allowancy) and its MAC address ranges.

![](/images/wiki/ConfigureDialog_addingModifyingRemovingPoolsAndPrivileges.png)

new tab in configure dialog allowing to manipulate with existing MAC pools or creating new ones as well as (de)assigning user privileges to specific MAC pools.

![](/images/wiki/AssigningPoolToClusterFromClusterDialog.png)

new tab in ~~datacenter~~ cluster dialog allowing to assign MAC pool to given ~~DataCenter~~cluster, view (only) MAC pool settings or clicking "New" button to create new MAC Pool.

![](/images/wiki/CreatingNewMacPoolFromClusterDialog.png)

screenshot of gui while creating new MAC Pool from ~~DataCenter~~ cluster dialog after clicking "New" button

### REST API

#### New top level collection

A new macpools top level collection will be added supporting the following operations:

1. GET api/macpools

*   Request: **None**
*   Response:

<mac_pools>
`    `<mac_pool id="AAA">
`        `<name>`Default`</name>
`        `<description>`The default MAC addresses pool`</description>
`        `<allow_duplicates>`false`</allow_duplicates>
`        `<ranges>
`            `<range>
`                `<from>`00:1A:4A:01:00:00`</from>
`                `<to>`00:1A:4A:FF:FF:FF`</to>
`            `</range>
`            `<range>
`                `<from>`02:1A:4A:01:00:00`</from>
`                `<to>`02:1A:4A:FF:FF:FF`</to>
`            `</range>
`        `</ranges>
`    `</mac_pool>
`    `<mac_pool id="BBB">
              ...
`    `</mac_pool>
</mac_pools>

2. POST api/macpools

*   Request:

<mac_pool id="AAA">
`    `<name>`Default`</name>
`    `<description>`The default MAC addresses pool`</description>
`    `<allow_duplicates>`false`</allow_duplicates>
`    `<ranges>
`        `<range>
`            `<from>`00:1A:4A:01:00:00`</from>
`            `<to>`00:1A:4A:FF:FF:FF`</to>
`        `</range>
`        `<range>
`            `<from>`02:1A:4A:01:00:00`</from>
`            `<to>`02:1A:4A:FF:FF:FF`</to>
`        `</range>
`    `</ranges>
</mac_pool>

*   Response: **GUID on the new pool**

3. PUT api/macpools/{macpool:id}

*   Request:

<mac_pool>
`    `<description>`The default MAC addresses pool - allows duplicates`</description>
`    `<allow_duplicates>`true`</allow_duplicates>
</mac_pool>

*   Response:

<mac_pool id="AAA">
`    `<name>`Default`</name>
`    `<description>`The default MAC addresses pool - allows duplicates`</description>
`    `<allow_duplicates>`true`</allow_duplicates>
`    `<ranges>
`        `<range>
`            `<from>`00:1A:4A:01:00:00`</from>
`            `<to>`00:1A:4A:FF:FF:FF`</to>
`        `</range>
`        `<range>
`            `<from>`02:1A:4A:01:00:00`</from>
`            `<to>`02:1A:4A:FF:FF:FF`</to>
`        `</range>
`    `</ranges>
</mac_pool>

#### Changes to existing resources

*   Into Data center resource will be added a link to the MAC pool resource it's using. Mac_pool is reported on this resource only if all clusters of this DataCenter uses same mac pool. If you update MAC pool on DataCenter, all clusters of that DataCenter will be updated.
*   Into Cluster resource will be added a link to the MAC pool resource it's using. You can read or update clusters mac pool using this attribute.
*   POST of data center without specifying the link should \*succeed\*, and will not change setting of mac pool on any cluster

### Permissions

The mac pool entity is a managed entity which its actions requrie permissions. The following action groups will be added:

*   CREATE_MAC_POOL
*   EDIT_MAC_POOL
*   DELETE_MAC_POOL

Those action groups will be part of a new predefined role named **MacPoolAdmin** (includes LOGIN).
**MacPoolAdmin** will use to create, edit and delete mac pools from the system.
The permission should be granted on system level for creating a pool and on a pool level for editing or removing a pool.
 In order to use a mac pool from within the ~~data-center~~cluster, the following ActionGroup is added:

*   CONFIGURE_MAC_POOL

This action group allows the usage of a given mac pool by any resource by ~~data-center only~~ cluster.
Later-on it will be expanded for additional entities as engine supports (i.e. network, cluster, vm pool).
 A new role will be added for usage purposes, named **MacPoolUser**. When granted on a mac pool, it will allow the ~~data-center~~cluster administrators to use the specific mac pool
 By default, the mac pool will be created for 'public use', meaning each Data Center admin will be able to set its ~~data center~~ datacenters cluster to use the specific mac pool. Specifically, it means that for each created mac pool, a **MacPoolUser** role will be granted on that mac pool to 'Everyone'. The 'public use' option could be unchecked (or set to false via api/sdk) in order to restrict the pool usage only to the permitted users.

The permissions for mac pools will be managed on GUI from the 'Configure' --> 'Mac Pools' --> Permissions sub-tab, and on restapi via *api/macpools/{macpool:id}/permissions*.

### sample flow

Lets say, that we've got one cluster. It's not configured yet to have its own MAC pool. So in system is only one pool, created during install/upgrade. We create few VMs and it's NICs will obtain its MAC from this pool, marking them as used. Next we alter cluster definition, so now it uses it's own MAC pool. In system from this point on exists two MAC pools, default one pool and one related to this cluster. As a last step in alteration of cluster definition, which triggered new pool creation, all MAC which should be present in newly created pool are moved there from previously used pool. Now we realized, that we actually don't want that cluster have its own MAC pool, so we alter it's definition removing MAC pool ranges definition, and selecting default pool again. Pool related to this cluster will be removed, because i'ts not used any more, and again, all MAC will be moved from pool to be removed back to shared one.

### DB details

![](/images/wiki/Erd.png)

