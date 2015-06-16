---
title: Safelease
category: vdsm
authors: danken
wiki_category: Vdsm
wiki_title: Safelease
wiki_revision_count: 1
wiki_last_updated: 2011-10-29
---

# Safelease

## What is safelease

Safelease is the current cluster lock utility used by Vdsm. It will be superseded by [sanlock](sanlock).

## What is it used for

It is used for taking cluster wide locks on pools. This help preventing to hosts managing the pool at once. As log as you have the safelease lock (also known as the SPM lock) you are know that you can modify the metadata of all the domains in the pool. The locks a voluntary and there is no enforcement in the storage level. Only VDSM adheres to these locks so be careful when modifying internal data of Vdsm pools on non SPM hosts.

## How does safelease works

Safelease uses an algorithm base on the article ["Light-Weight Leases for Storage-Centric Coordination"](http://www.springerlink.com/index/x1155p2744917647.pdf) by G Chockler and D Malkhi.

It basically uses a sector sized block of data and assumes writes and reads to and from it are atomic. It requires a constant connection to the storage to keep the lease alive.

<Category:Vdsm>
