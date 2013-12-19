---
title: Even VM Count Distribution
category: feature
authors: doron, jmoskovc
wiki_category: Feature
wiki_title: Features/Even VM Count Distribution
wiki_revision_count: 31
wiki_last_updated: 2014-01-26
---

# Even VM Count Distribution

## Summary

Tho goal of this feature is to provide a cluster policy that evenly distributes VMs based on VM count.

       === Owner ===

Name: [ Jiri Moskovcak](User:jmoskovc) Email: <jmoskovc@redhat.com>

## Current status

       * Last updated: December 19, 2013
       

## Detailed Description

This feature will help distribute the VMs so it will lower the impact of host malfunction and the possibility of loosing too many services if they would be running on the same host.

## Benefit to oVirt

This feature came from customer request, so the benefit is happy customer ;)

## Documentation / External references

### Main components

         Load-balancing logic to check the number of VMs per host. Engine can migrate some machines to different hosts if VM count threashold is reached

         A scheduler scoring (weight) module which is applied when selecting the target host for VM (when it's being started or migrated)

         (optional) create a filter scheduler policy which will filter out hosts with VM count higher then some predefined value

### policy details

          = scoring logic =
          - the less VMs running on the host the better score (actually low score is good- this is a weight system)
              => Fwvm(host) = host.vm_count (or vm_active)
            - hosts with VM_COUNT == overLoadedHostVMCount - 1 are not good migration targets
                => this can be implemented as the filter. Not needed for the weight module.
          = load-balancing logic =

         - if the count of the VM is lower then some threshold (MAX_VM_COUNT) - CONTINUE (we know we don't need to lower the number of running VMs on this host)

         - if the count is higher then some predefined threshold - check the other machines if there is a host where we can migrate some VM

* overUtilizedHost = host.VM_COUNT > MAX_VM_COUNT - underUtilizedHost = host.VM_COUNT < averageVMCountPerHost OR host.VM_COUNT < MAX_VM_COUNT

## Testing

* TBD
