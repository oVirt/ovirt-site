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

## Comments

*   Specifying MAC pool ranges for given "scope" is optional, not required. If not specified, the default, engine-wide pool will be used.
*   When specifying mac ranges for one pool, all potential MAC range overlaps/intersections are removed. But currently NO checks are done to detect duplicates among mac ranges related to different "scopes".
*   All defined "scoped" pools are initialized during startup, just like default MAC pool. When creating new data center/updating/removing "scoped" MAC pool is created/altered/removed in respect to that.
*   When updated mac ranges for given "scope", notice, that MAC addresses currently will not get reassigned. Used MACs assigned from previous range definition will be added as manually specified MACs
*   When specified mac ranges for given "scope", where there wasn't any definition previously, allocated MAC from default pool will not be moved to "scoped" one until next engine restart. Other way, when removing "scoped" mac pool definition, all MACs from this pool will be moved to default one.
*   While ranges definition may differ per "scope", other variables -- 'MaxMacsCountInPool' and 'AllowDuplicateMacAddresses' are still system wide.

## Gui

Style of entering mac pool ranges is hardly ideal, but it should suffice at first.

![](MacPoolRangesOnDataCenter.png "MacPoolRangesOnDataCenter.png")

## Implementation details

![](scopedMacPoolManager_UML.png "scopedMacPoolManager_UML.png")

In DB was added column 'mac_pool_ranges' into table 'storage_pool'.

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

<Category:Api> <Category:Feature>
