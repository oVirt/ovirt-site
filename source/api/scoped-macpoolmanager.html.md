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

Previously there was sole pool of MACs, it's mac ranges for this pool could/can be configured via engine-config.

This holds true, but aside from that, now is possible, not required, to define separate MAC pool for each "scope".

Currently a data center is considered to be a "scope", later maybe finer control will be possible.

## Owner

Name: Martin Mucha

Email: <mmucha@redhat.com>

## Benefit to oVirt

Definition of domains from which MAC addresses will be allocated for each "scope". Potential ability to change *scope*.

## General comments

*   Specifying MAC pool ranges for given "scope" is optional, not required. If not specified, the default, engine-wide pool will be used.
*   When specifying mac ranges for one pool, all potential MAC range overlaps/intersections are removed. But currently NO checks are done to detect duplicates among mac ranges related to different "scopes".
*   All defined "scoped" pools are initialized during start-up, just like default MAC pool. When creating new data center/updating/removing "scoped" MAC pool is created/altered/removed in respect to that.
*   When updated mac ranges for given "scope", notice, that MAC addresses of existing nics currently will not get reassigned. Used MACs assigned from previous range definition will be added as manually specified MACs if they are out of pool ranges. **That means, that mac is still tracked by that pool, but if pool ranges alteration makes that mac to be outside of that newly defined ranges, it will be outside of those ranges. There will be no effort in stop using that macs and assigning new ones.**
*   While ranges definition may differ per "scope", other variables -- 'MaxMacsCountInPool' and 'AllowDuplicateMacAddresses' are still system wide.
*   **Notice, that there is one *problem* in deciding which scope/pool to use. There are places in code, which requires pool related to given data center, identified by guid. For that request, only data center scope or something broader like global scope can be returned. So even if one want to use one pool per logical network, requests identified by data center id still can return only data center scope or broader, and there are no chance returning pool related to logical network (except for situation, where there is sole logical network in that data center).**
*   **You should try to avoid to allocate MAC which is outside of ranges of configured mac pool(either global or scoped one). It's perfectly OK, to allocate specific MAC address from inside these ranges, actually is little bit more efficient than letting system pick one for you. But if you use one from outside of those ranges, your allocated MAC end up in less memory efficient storage(approx 100 times less efficient). So if you want to use user-specified MACs, you can, but tell system from which range those MACs will be(via mac pool configuration).**

## Implementation details

![](scopedMacPoolManager_UML.png "scopedMacPoolManager_UML.png")

Click for more detailed diagram

<Media:scopedMacPoolManager_UML-details.png>

## Code Examples

While we're just talking about data center "scopes", it's possible that fine grained "scope" will be requested, or user could decide which "scope" he/she/... wants. To allow that, data center "scope" manipulation is done like this. Call *ScopedMacPoolManager.scopeFor()* returns implementation of *Scope* given on system settings, depending what scope you're interrested in, you call related method on this instance and this implementation of Scope will process you request accordingly. Lets say, you want to use MAC pool for given virtual machine so you call *ScopedMacPoolManager.scopeFor().vm(...). ...*, but system is configured to use global MAC pools ONLY, so regardless of your request, you end up with global pool anyway.

#### initialization of scope

command adding new data center will contain following code

      ScopedMacPoolManager.scopeFor().storagePool(storagePool).createPool(storagePool.getMacPoolRanges());

where storagePool is newly created storage pool.

#### modification of scope

let's say, that storage pool already exist, but without specified mac pool ranges, so after db is updated, new pool has to be created for it.

      ScopedMacPoolManager.scopeFor().storagePool(storagePool).modifyPool(storagePool.getMacPoolRanges());

#### removal of scope

      ScopedMacPoolManager.scopeFor().storagePool(storagePoolID).removePool()

#### manipulating with pool

formerly code to remove macs was:

      MacPoolManager.getInstance().freeMacs(macsToRemove);

now we have to specify from \*where\* we want them to be removed:

      ScopedMacPoolManager.scopeFor().storagePool(storagePoolId).getPool().freeMacs(macsToRemove);

which will decide which storagePool is appropriate for your request and frees macs from it. When you're super-sure you want to use default storagePool, you can use

      ScopedMacPoolManager.defaultScope().freeMacs(macsToRemove); 

#### notes

*   simple obtaining pool is rather verbose. This will be improved allowing to call

      ScopedMacPoolManager.pollFor().vm(...);

*   from statement "ScopedMacPoolManager.scopeFor().storagePool(storagePool).createPool(storagePool.getMacPoolRanges());" can be removed part "storagePool.getMacPoolRanges()", this should be also done in following commits.

## Implementation details of DataCenterScope

### DataCenterScope comments

*   ~~When specified mac ranges for given "scope", where there wasn't any definition previously, allocated MAC from default pool will not be moved to "scoped" one until next engine restart. Other way, when removing "scoped" mac pool definition, all MACs from this pool will be moved to default one.~~ Allocated MACs now moves between data center related pools and global one back and forth as data center pool gets created/removed. When given scoped pool is removed its content is moved to global pool. And vice versa. When scoped pool is created, then all MACs which should be present in this newly created pool is moved to it from global pool.
*   **whatever you do with pool you get anyhow, happens on this pool only. You do not have code-control on what pool you get, like if system is configured to use single pool only, then request for datacenter-related pool still return that sole one, but once you have that pool, everything happen on this pool, and, unless datacenter configuration is altered, same request in future for pool should return same pool.**

### Gui

Style of entering mac pool ranges is hardly ideal, but it should suffice at first.

![](MacPoolRangesOnDataCenter.png "MacPoolRangesOnDataCenter.png")

### sample flow

**Lets say, that we've got one data center. It's not configured yet to have its own mac pool. So in system is only one, global pool. We create few VMs and it's NICs will obtain its MAC from this global pool, marking them as used. Next we alter data center definition, so now it uses it's own mac pool. In system from this point on exists two mac pools, one global and one related to this data center~~, but those allocated MACs are still allocated in global pool, since new data center creation does not (yet) contain logic to get all assigned MACs related to this data center and reassign them in new pool. However, after app restart all VmNics are read from db and placed to appropriate pools. Lets assume, that we've performed such restart.~~ As a last step in alteration of data center definition, which triggered new pool creation, all mac which should be present in newly created pool are moved there from global pool. Now we realized, that we actually don't want that data center have its own mac pool, so we alter it's definition removing mac pool ranges definition. Pool related to this data center will be removed and it's content will be moved to a scope above this data center -- into global scope pool. We know, that everything what's allocated in pool to be removed is still used, but we need to track it elsewhere in global pool. What happens when we allocated mac in data-center related pool, then remove it, and now we want to put that mac back? As said, on pool removal its content is moved elsewhere. Next, when MAC is about to be returned to the pool, the request goes like: "give me pool for this virtual machine, and whatever pool it is, I'm returning this MAC to it.". And since pool for this datacenter(related to given virtual machine) is no more, the global pool is returned instead, and that's the pool where mac move to from recently deceased scope pool, so mac to be release awaits here and will be properly released. Clients of ScopedMacPoolManager do not know which pool exactly they're talking to. Decision, which pool is right for them, is done behind the scenes upon their identification (I want pool for this logical network).**

### DB details

In DB was added column 'mac_pool_ranges' into table 'storage_pool'.

<Category:Api> <Category:Feature>
