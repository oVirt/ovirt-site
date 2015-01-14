---
title: Scoped MacPoolManager
category: api
authors: mkolesni, mmucha, moti, mpavlik
wiki_category: Api
wiki_title: Features/Scoped MacPoolManager
wiki_revision_count: 36
wiki_last_updated: 2015-01-14
---

# Scoped MacPoolManager

__TOC__

## Summary

Previously there was sole pool of MACs, it's MAC ranges for this pool could be configured via engine-config. Now each data center have some MAC pool associated and MAC pools cannot be configured via engine-config.

## Owner

Name: Martin Mucha

Email: <mmucha@redhat.com>

## Benefit to oVirt

Definition of domains from which MAC addresses will be allocated for each data center.

## Details

*   pools are named, and can be shared between multiple data centers.
*   whether MAC pool can be used for specific DataCenter is determined via user permissions.
*   duplicity allowance is set on pool level, not via global config values.
*   there is always one default pool available(replacement for former global pool). This can be used when data center does not create own one pool. During upgrade only this pool is created and all existing data centers will use it. This pool is also created on clean install. After upgrade/clean install ranges and duplicity setting will be same as now: macRanges: 00:1a:4a:1a:83:00-00:1a:4a:1a:83:ff, allowDuplicates: false. When user overrode those default values, those values will be used instead.
*   all pools are accessible through rest
*   pool definition is mandatory on data center. Each data center has one MAC Pool associated.
*   when specifying MAC ranges for one pool, all potential MAC range overlaps/intersections are removed. When duplicates turned off(per pool setting), one MAC can be used only once in that pool. Example: lets have two pools with two same ranges. This is ok. Duplicity allowance setting is per pool, like said above. One allows it, second does not. Thus even if duplicates are turned off in this pool, this MAC can be used multiple times in another pool.
*   each pools is initialized during start-up. When creating new/updating/removing MAC pool is (re)initialized/removed in respect to that.
*   When one update MAC ranges for given MAC pool, MAC addresses of existing nics currently will not get reassigned. Used MACs assigned from previous range definition will be added as an user specified MACs if they are now out of pool ranges. That means, that MAC is still tracked by that pool, but if pool ranges alteration makes that MAC to be outside of that newly defined ranges, it will be outside of those ranges. There will be no effort in stop using that MAC and assigning new ones.
*   You should try to avoid to allocate MAC which is outside of ranges of configured MAC pool(either global or scoped one). It's perfectly OK, to allocate specific MAC address from inside these ranges, actually is little bit more efficient than letting system pick one for you. But if you use one from outside of those ranges, your allocated MAC end up in less memory efficient storage(approx 300 times less efficient). So if you want to use user-specified MACs, you can, but tell system from which range those MACs will be(via MAC pool configuration).
*   When DataCenter definition changes so that after change different pool is used, all MACs belonging to that data center are removed from old pool and reinserted to new one.
*   you can use same MACs on multiple data centers. Currently no checks are done to find out whether pool definition for multiple data centers overlap or not. So if you define your pools in that way, that MAC ranges overlaps, one MAC address can be used multiple times. I'd observe that as an user error, since it's easier to stick with one global pool with allowed duplicates.

## User Experience

### GUI

*   pool are assigned to DataCenter in datacenter dialog.
*   pools are managed from app config, where was added new tab for pools. Here you can find out, in which places is pool used.

Below is three screenshots. 'New/edit MAC pool pane' is shared component used both in new tabs of datacenter dialog and systemconfig, which are remaining two screenshots.

![](newMacAddressPool.png "newMacAddressPool.png")

dialog for creating/editing MAC Pool data (name, description, duplicity allowancy) and its MAC address ranges.

![](configureDialog_addingModifyingRemovingPoolsAndPrivileges.png "configureDialog_addingModifyingRemovingPoolsAndPrivileges.png")

new tab in configure dialog allowing to manipulate with existing MAC pools or creating new ones as well as (de)assigning user privileges to specific MAC pools.

![](assigningPoolToDataCenterFromDataCenterDialog.png "assigningPoolToDataCenterFromDataCenterDialog.png")

new tab in datacenter dialog allowing to assign MAC pool to given DataCenter, view (only) MAC pool settings or clicking "New" button to create new MAC Pool.

![](creatingNewMacPoolFromDataCenterDialog.png "creatingNewMacPoolFromDataCenterDialog.png")

screenshot of gui while creating new MAC Pool from DataCenter dialog after clicking "New" button

### REST API

#### New top level collection

A new macpools top level collection will be added supporting the following operations:

1. GET api/macpools

*   Request: **None**
*   Response:

<mac_pools>
`    `<mac_pool id="AAA">
`        `<name>`Default`</name>
`        `<description>`The default MAC addresses pool`</description>
`        `<allow_duplicates>`false`</allow_duplicates>
`        `<ranges>
`            `<range>
`                `<from>`00:1A:4A:01:00:00`</from>
`                `<to>`00:1A:4A:FF:FF:FF`</to>
`            `</range>
`            `<range>
`                `<from>`02:1A:4A:01:00:00`</from>
`                `<to>`02:1A:4A:FF:FF:FF`</to>
`            `</range>
`        `</ranges>
`    `</mac_pool>
`    `<mac_pool id="BBB">
              ...
`    `</mac_pool>
</mac_pools>

2. POST api/macpools

*   Request:

<mac_pool id="AAA">
`    `<name>`Default`</name>
`    `<description>`The default MAC addresses pool`</description>
`    `<allow_duplicates>`false`</allow_duplicates>
`    `<ranges>
`        `<range>
`            `<from>`00:1A:4A:01:00:00`</from>
`            `<to>`00:1A:4A:FF:FF:FF`</to>
`        `</range>
`        `<range>
`            `<from>`02:1A:4A:01:00:00`</from>
`            `<to>`02:1A:4A:FF:FF:FF`</to>
`        `</range>
`    `</ranges>
</mac_pool>

*   Response: **GUID on the new pool**

3. PUT api/macpools/{macpool:id}

*   Request:

<mac_pool>
`    `<description>`The default MAC addresses pool - allows duplicates`</description>
`    `<allow_duplicates>`true`</allow_duplicates>
</mac_pool>

*   Response:

<mac_pool id="AAA">
`    `<name>`Default`</name>
`    `<description>`The default MAC addresses pool - allows duplicates`</description>
`    `<allow_duplicates>`true`</allow_duplicates>
`    `<ranges>
`        `<range>
`            `<from>`00:1A:4A:01:00:00`</from>
`            `<to>`00:1A:4A:FF:FF:FF`</to>
`        `</range>
`        `<range>
`            `<from>`02:1A:4A:01:00:00`</from>
`            `<to>`02:1A:4A:FF:FF:FF`</to>
`        `</range>
`    `</ranges>
</mac_pool>

#### Changes to existing resources

*   Data center resource will be added a link to the MAC pool resource it's using.
*   POST of data center without specifying the link should \*succeed\*, using the default pool of the system.

### Permissions

The mac pool entity is a managed entity which its actions requrie permissions. The following action groups will be added:

*   CREATE_MAC_POOL
*   EDIT_MAC_POOL
*   DELETE_MAC_POOL

Those action groups will be part of a new predefined role named **MacPoolAdmin** (includes LOGIN).
**MacPoolAdmin** will use to create, edit and delete mac pools from the system.
The permission should be granted on system level for creating a pool and on a pool level for editing or removing a pool.
 In order to use a mac pool from within the data-center, the following ActionGroup is added:

*   CONFIGURE_MAC_POOL

This action group allows the usage of a given mac pool by any resource at first by data-center only.
Later-on it will be expanded for additional entities as engine supports (i.e. network, cluster, vm pool).
 A new role will be added for usage purposes, named **MacPoolUser**. When granted on a mac pool, it will allow the data-center administrators to use the specific mac pool
 By default, the mac pool will be created for 'public use', meaning each Data Center admin will be able to set its data center to use the specific mac pool. Specifically, it means that for each created mac pool, a **MacPoolUser** role will be granted on that mac pool to 'Everyone'. The 'public use' option could be unchecked (or set to false via api/sdk) in order to restrict the pool usage only to the permitted users.

The permissions for mac pools will be managed on GUI from the 'Configure' --> 'Mac Pools' --> Permissions sub-tab, and on restapi via *api/macpools/{macpool:id}/permissions*.

## Code Examples

#### creation of new DataCenter specific pool

      MacPoolPerDC.getInstance().createPool(macPool);

where business entity macPool holds all data required for pool creation.

#### modification of scope

let's say, that storage pool already exist, but without specified mac pool ranges, so after db is updated, new pool has to be created for it.

      MacPoolPerDC.getInstance().modifyPool(macPool);

#### removal of scope

      MacPoolPerDC.getInstance().removePool(id)

#### manipulating with pool

there are few methods for getting dc related pool based on various data you have. Below is example how to return MAC back to pool, which we can identify with data center id.

      MacPoolPerDC.getInstance().poolForDataCenter(id).freeMacs(macsToRemove);

## Implementation details of DataCenterScope

### DataCenterScope comments

### sample flow

Lets say, that we've got one data center. It's not configured yet to have its own MAC pool. So in system is only one pool, created during install/upgrade. We create few VMs and it's NICs will obtain its MAC from this pool, marking them as used. Next we alter data center definition, so now it uses it's own MAC pool. In system from this point on exists two MAC pools, default one pool and one related to this data center. As a last step in alteration of data center definition, which triggered new pool creation, all MAC which should be present in newly created pool are moved there from previously used pool. Now we realized, that we actually don't want that data center have its own MAC pool, so we alter it's definition removing MAC pool ranges definition, and selecting default pool again. Pool related to this data center will be removed, because i'ts not used any more, and again, all MAC will be moved from pool to be removed back to shared one.

### DB details

![](Erd.png "Erd.png")

<Category:Api> <Category:Feature>
