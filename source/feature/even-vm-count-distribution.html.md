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
*   Email: <jmoskovc@redhat.com>

### Current status

*   Last updated: ,

### Detailed Description

* TBD

### Benefit to oVirt

This feature comes from customer request, so benefit to ovirt is a better customer satisfaction ;)

### Dependencies / Related Features

* NONE

### Documentation / External references

pseudo code for the balance() method

getVDSWithHighestVMCount():

       worstVDS = allVDS[0]
       for vds in allVDS:
         if vds.activeVMSCount() > MAX_VMS_COUNT AND vds.activeVMSCount() > worstVDS.activeVMSCount():
           worstVDS = vds

       return  worstVDS if @@TBD
       

    balance():
      worstVDS = getVDSWithHighestVMCount()
      possibleTargets = [ vds for vds in allVDS if worstVDS() - vds.activeVMCount() > 2 ]

      return (possibleTargets, vmToMigrate)

### Testing

* TBD

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
