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

*   MAX_VMS_COUNT - the threshold to specify the minimal
*   BALANCING_WINDOW_WIDTH - the minimum difference in running VMs count on two VDS to migrate VMs between them

The cluster is considered unbalanced if there is VDS with more than MAX_VMS_COUNT VMs running on it AND there is at least one VDS with more then BALANCING_WINDOW_WIDTH less VMs

**Unbalanced cluster**

![|Unbalanced cluster](balancing-before.png "|Unbalanced cluster")

**Cluster after 1 balancing iteration**

![](balancing-after1iter.png "balancing-after1iter.png")

**Cluster after 2 balancing iterations**

![](balancing-after2iter.png "balancing-after2iter.png")

#### 1. iteration

1.  VM1 moved from VDS1 to VDS3 (to make the example simple, there is no special logic involved in selecting the VDS, so even though VDS5 is also a good target we simply take whatever comes first, but the target VDS should and will be selected by the scoring mechanism based on the count of running VMs on the VDS)
2.  The balance window top moved from 12 to 11 and minimum is now 7

#### 2. iteration

1.  VM2 moved to VDS5 (the only possible target, because it's the only one outside of the balancing window)
2.  The balancing window top moved from 11 to 10 and the minimum is now 6 which means the cluster is balanced because every VDS has VM count inside the balancing window

The cluster from this example is balanced after the 2nd iteration the

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
