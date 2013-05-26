---
title: SLA for storage io bandwidth
category: sla
authors: mei liu
wiki_category: SLA
wiki_title: Features/Design/SLA for storage io bandwidth
wiki_revision_count: 61
wiki_last_updated: 2013-06-28
---

# SLA for storage io bandwidth

## Introduction

This wiki page focuses on the design of storage resources Service Level Agreement(SLA). In VDSM, each storage domain backend only provides limited IO bandwidth capability. If bandwidth become scarce resource, the efficiency of vm IO operations will be affected by other vms. This is not the situation we want, and therefore we need to limit the bandwidth usage to allocate the bandwidth in a better way.

Volumes in backend storage of a storage domain are used by plenty of vms as vDisks, and thus a vm's vDisk bandwidth should be limited by a quota according to the capability of this backend storage. In the following chapters, we will explain how to tune the quota dynamically . The quota adjustment is performed by MOM and VDSM.

## Quota of vDisk bandwidth and automaticly tuning scheme

This chapter gives the way to set initial value. This value is used as start point when quota is adjusted. The quota is then tuned according to IO bandwidth usage and capability of backend storage bandwidth. During this tuning procedure, the quota can not be inflated or deflated arbitrarily, so we constrain it in a dynamic calculated range.

### Initial quota value

The initial quota of vDisks bandwidth can be set to the value when vm is created, dynamically set via VDSM API or bandwidth capability of the related backend storage. The capability is estimated based on physical backend IO bandwidth capability or detected in some other way.

### Quota adjustment

Quota is tuned by a similar mechanism in MOM. MOM collects bandwidth capability information and IO bandwidth usage statistics of backend storages and related volumes. According to this information and related policy, the policy engine decides how to tune the quota of vDisk which uses that backend storage .

If the backend storage bandwidth is heavily used(i.e. The unused bandwidth ratio of that backend is lower than a threshold), the quotas for the vDisks related to that backend are deflated by a certain percent. Otherwise, the quotas for the vDisks bandwidth are inflated by the same percent.

At the same time, the policy make sure that the quota is in a proper range dynamically calculated. The policy calculated the range for different priority level vDisks in diverse ways. The vDisk is either high priority or low priority, and the level may derived from the priority of user/vm. For high priority vDisks, the policy tends to make the lower bound of range not too small. In the opposite, the policy tends to make the upper bound of range not too large for low priority vDisks. The details is described as following:

*   inflate quota

       high priority vDisk: 
         min = used + cap * min_unused_percent (e.g. 0.2)
         max = cap
       low priority vDisk: 
         min = used
         max = used + cap * min_unused_percent(e.g. 0.2)
         used means the used bandwidth of that vDisk. 
         cap is short for capability of backend storage for the storage domain.

*   deflate quota

       high priority vDisk: 
         min =  used + cur * guest_unused_percent 
         guest_unused_percent = backend unused ratio -0.05 ( if bandwidth is quite scarce )
         guest_unused_percent= backend unused ratio * min_unused_percent(e.g. 0.2)/ threshold(e.g. 0.2) (if bandwidth is not quite scarce but below threshold)
         max = cap
       low priority vDisk: 
          min = used
          max = used + cur * guest_unused_percent 
          cur means the current quota value
