---
title: Scoped MacPoolManager
category: api
authors: mkolesni, mmucha, moti, mpavlik
wiki_category: Api
wiki_title: Features/Scoped MacPoolManager
wiki_revision_count: 36
wiki_last_updated: 2015-01-14
---

__TOC__

# Scoped MacPoolRanges

### Summary

Previously there was sole pool of MACs, it's mac ranges for this pool could/can be configured via engine-config.

This holds true, but aside from that, now is possible, not required, to define separate MAC pool for each "scope".

Currently a data center is considered to be a "scope", later maybe finer control will be possible.

### Owner

Name: Martin Mucha

Email: <mmucha@redhat.com>

### Benefit to oVirt

Definition of domains from which MAC addresses will be allocated for each "scope". Potential ability to change *scope*.

### Comments

*   Specifying MAC pool ranges for given "scope" is optional, not required. If not specified, the default, engine-wide pool will be used.
*   When specifying mac ranges for one pool, all potential MAC range overlaps/intersections are removed. But currently NO checks are done to detect duplicates among mac ranges related to different "scopes".
*   All defined "scoped" pools are initialized during startup, just like default MAC pool. When creating new data center/updating/removing "scoped" MAC pool is created/altered/removed in respect to that.
*   When updated mac ranges for given "scope", notice, that MAC addresses currently will not get reassigned. Used MACs assigned from previous range definition will be added as manually specified MACs
*   When specified mac ranges for given "scope", where there wasn't any definition previously, allocated MAC from default pool will not be moved to "scoped" one until next engine restart. Other way, when removing "scoped" mac pool definition, all MACs from this pool will be moved to default one.

### Implementation details

While we're just talking about data center "scopes", it's possible that fine grained "scope" will be requested, or user could decide which "scope" he/she/... wants. To allow that, data center "scope" manipulation is done like this:

Notice that implementation of scopeFor() methods etc. can switch by configuration whether/which "scope" will be used.

#### initialization of scope

command adding new data center will contain following code

      ScopedMacPoolManager.requireScopeFor().storagePool(storagePool)

where storagePool is newly created storage pool.

#### modification of scope

      ScopedMacPoolManager.updateScopeFor().storagePool(storagePool)

#### removal of scope

      ScopedMacPoolManager.updateScopeFor().storagePool(storagePoolID)

#### manipulating with pool

formerly code to remove macs was:

      MacPoolManager.getInstance().freeMacs(macsToRemove);

now we have to specify from \*where\* we want them to be removed:

      ScopedMacPoolManager.scopeFor().storagePool(storagePoolId).freeMacs(macsToRemove);

which will decide which storagePool is appropriate for your request and frees macs from it. When you're super-sure you want to use default storagePool, you can use

      ScopedMacPoolManager.defaultScope().storagePool(storagePoolId).freeMacs(macsToRemove); 

<Category:Api> <Category:Feature>
