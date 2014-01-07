---
title: Even VM Count Distribution
category: feature
authors: doron, jmoskovc
wiki_category: Feature
wiki_title: Features/Even VM Count Distribution
wiki_revision_count: 31
wiki_last_updated: 2014-01-26
---

# Even VM distribution based on VM count per host

### Summary

The goal of this feature is to provide a cluster policy that evenly distributes VMs based on VM count.

### Owner

*   Name: [ Jiri Moskovcak](User:jmoskovc)
*   Email: jmoskovc@redhat.com

### Current status

*   Last updated: ,

### Detailed Description

**Unbalanced cluster**

![|Unbalanced cluster](balancing-before.png "|Unbalanced cluster")

**Cluster after 1 balancing iteration**

![](balancing-after1iter.png "balancing-after1iter.png")

**Cluster after 2 balancing iterations**

![](balancing-after2iter.png "balancing-after2iter.png")

#### 2. iteration:

1.  VM2 moved to VDS5 (the only possible target, because it's the only one outside of the balancing window)
2.  The balancing window top moved from 11 to 10 and the minimum is now 6 which means the cluster is balanced because every VDS has VM count inside the balancing window

### Benefit to oVirt

This feature comes from customer request, so benefit to ovirt is a better customer satisfaction ;)

### Dependencies / Related Features

* NONE

### Documentation / External references

pseudo code for the balance() method

    getOverloadedVDS():
      worstVDS = None
      for vds in allVDS:
        if vds.activeVMSCount() > MAX_VMS_COUNT AND (worstVDS == None OR vds.activeVMSCount() > worstVDS.activeVMSCount()):
          worstVDS = vds

      return  worstVDS  # returns None (null) if no VDS has above MAX_VMS_COUNT running vms

    balance():
      worstVDS = getOverloadedVDS()
      if worstVDS == None:  # nothing to balance
         return None

      possibleTargets = [ vds for vds in allVDS if worstVDS() - vds.activeVMCount() > BALANCE_WINDOW_WIDTH ]

      return (possibleTargets, vmToMigrate)

### Testing

* TBD

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
