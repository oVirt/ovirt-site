---
title: Safelease
category: vdsm
authors: danken
---

# Safelease

## What is safelease

Safelease is the current cluster lock utility used by Vdsm. It will be superseded by [sanlock](/develop/developer-guide/vdsm/sanlock.html).

## What is it used for

It is used for taking cluster wide locks on pools. This helps preventing the hosts managing the pool at once. As long as you have the safelease lock (also known as the SPM lock) you know that you can modify the metadata of all the domains in the pool. The lock is voluntary and there is no enforcement on the storage level. Only VDSM adheres to these locks so be careful when modifying internal data of Vdsm pools on non SPM hosts.

## How does safelease works

Safelease uses an algorithm base on the article ["Light-Weight Leases for Storage-Centric Coordination"](https://dspace.mit.edu/handle/1721.1/30464) by G Chockler and D Malkhi.

It basically uses a sector sized block of data and assumes writes and reads to and from it are atomic. It requires a constant connection to the storage to keep the lease alive.

