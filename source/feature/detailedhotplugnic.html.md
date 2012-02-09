---
title: DetailedHotPlugNic
category: feature
authors: danken, ecohen, ilvovsky, moti, ovedo, roy
wiki_category: Feature
wiki_title: Features/Design/DetailedHotPlugNic
wiki_revision_count: 19
wiki_last_updated: 2013-03-07
---

# Detailed Hot Plug Nic

## Events

## Engine Flows

##### Add nic

when adding a nic, store its plugged status as disabled, regardless if the VM is running or not. The api will not implicitly plug it to a running VM.

##### Run VM

when running a VM, include only nics which are plugged in the parameters sent to VDSM.

##### Plug nic

plugging a nic when a VM is down updates its plugged flag in vm_device table to 'true'. If the VM is up then the VDSM is also being called to plug it.

##### Unplug nic

unplugging a nic when a VM is down updates its plugged flag in vm_device table to 'false'

##### Host monitoring

during monitoring and gathering vm stats, the nic's address should be saved in vm_device table.

##### Remove nic

when a nic is removed from a VM, remove its address from vm_device
