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

Previously there was sole pool of MACs, it's MAC ranges for this pool could/can be configured via engine-config. Now each data center have some MAC pool associated. Either it's its own or some global one.

## Owner

Name: Martin Mucha

Email: <mmucha@redhat.com>

## Benefit to oVirt

Definition of domains from which MAC addresses will be allocated for each data center.

## Details

*   pools are named, and can be shared between multiple data centers.
*   duplicity allowance is set on pool level, not via global config values.
*   there is always one shared pool available(replacement for former global pool). This will be used when data center do not have its own (or another) pool. During upgrade only this pool is created and all existing data centers will use it. This pool is also created on clean install. After upgrade/clean install ranges and duplicity setting will be same as now: 00:1a:4a:1a:83:00-00:1a:4a:1a:83:ff resp. 100000. When user override those default values, those values will be used instead.
*   all pools are accessible through rest
*   pool definition is mandatory on data center. Either shared pool must be selected or own one defined.
*   when specifying MAC ranges for one pool, all potential MAC range overlaps/intersections are removed. When duplicates turned off(per pool setting), one MAC can be used only once IN THAT POOL. Example: lets have two pools with two same ranges. This is ok. Duplicity allowance setting is per pool, like said above. One allows it, second does not. Thus even if duplicates are turned off in this pool, this MAC can be used multiple times in another pool.
*   you can add comment to each range of MACs.
*   each pools is initialized during start-up. When creating new/updating/removing data center MAC pool is created/altered/removed in respect to that.
*   When one update MAC ranges for given MAC pool, MAC addresses of existing nics currently will not get reassigned. Used MACs assigned from previous range definition will be added as an user specified MACs if they are now out of pool ranges. That means, that MAC is still tracked by that pool, but if pool ranges alteration makes that MAC to be outside of that newly defined ranges, it will be outside of those ranges. There will be no effort in stop using that MAC and assigning new ones.
*   You should try to avoid to allocate MAC which is outside of ranges of configured MAC pool(either global or scoped one). It's perfectly OK, to allocate specific MAC address from inside these ranges, actually is little bit more efficient than letting system pick one for you. But if you use one from outside of those ranges, your allocated MAC end up in less memory efficient storage(approx 100 times less efficient). So if you want to use user-specified MACs, you can, but tell system from which range those MACs will be(via MAC pool configuration).
*   When DataCenter definition changes so that after change different pool is used, all MACs belonging to that data center are removed from old pool and reinserted to new one.
*   you can use same MACs on multiple data centers. Currently no checks are done to find out whether pool definition for multiple data centers overlap or not. So if you define your pools in that way, that MAC ranges overlaps, one MAC address can be used multiple times. I'd observe that as an user error, since it's easier to stick with one global pool with allowed duplicates.

## User Experience

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

### Gui

*   'private' pool are manipulated with from datacenter dialog, where also will be created new tab for pool.
*   shared pools are managed from app config, where will be added new tab for pools. Private pools can be viewed here also, but not changed. Here you can find out, in which places is shared pool used.

Below is three screenshots. 'New/edit MAC pool pane' is shared component used both in new tabs of datacenter dialog and systemconfig, which are remaining two screenshots.

![](newMacPoolPane.png "newMacPoolPane.png")

shared component for editing pool properties

![](existingPools_newSharedPool.png "existingPools_newSharedPool.png")

component for viewing all existing pools and for creating new shared ones.

![](datacenterDialog.png "datacenterDialog.png")

component for specifying datacenter related pool or for linking data center to shared pool

### sample flow

Lets say, that we've got one data center. It's not configured yet to have its own MAC pool. So in system is only one, shared pool, created during install/upgrade. We create few VMs and it's NICs will obtain its MAC from this pool, marking them as used. Next we alter data center definition, so now it uses it's own MAC pool. In system from this point on exists two MAC pools, one shared pool and one related to this data center. As a last step in alteration of data center definition, which triggered new pool creation, all MAC which should be present in newly created pool are moved there from previously used pool. Now we realized, that we actually don't want that data center have its own MAC pool, so we alter it's definition removing MAC pool ranges definition, and selecting shared pool again. Pool related to this data center will be removed, because i'ts not used any more, and again, all MAC will be moved from pool to be removed back to shared one.

### DB details

![](Erd.png "Erd.png")

<Category:Api> <Category:Feature>
