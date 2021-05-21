---
title: Self Hosted Engine FC Support
category: feature
authors:
  - sandrobonazzola
  - stirabos
---

# Self Hosted Engine FC Support

## Summary

This feature enable the user to use FC storage for Hosted Engine data domain.

## Owner

*   Name: Simone Tiraboschi (Stirabos)
*   Email: <stirabos@redhat.com>

## Detailed Description

The FC storage HBA should be already configured and connected on the system. Multipath is supported.

#### UX changes

As usual launch hosted-engine --deploy:

Than you can find and additional valid answer to

               Please specify the storage you would like to use (iscsi, fc, nfs3, nfs4)[nfs3]: 

question. Choose fc

It will scan the storage subsystem to find FC HBA letting you select a FC LUN to deploy the engine VM.

[ INFO ] Connecting to the storage server

               The following luns have been found on the requested target:
                 [1] 330000000e5380848   56GiB   XtremIO XtremApp
                     status: used, paths: 4 active
              
                 [2] 33000000022a29f57   100GiB  XtremIO XtremApp
                     status: free, paths: 4 active
              
                 [3] 330000000c399efa0   100GiB  XtremIO XtremApp
                     status: free, paths: 4 active
              
                 [4] 330000000d0c91c54   100GiB  XtremIO XtremApp
                     status: free, paths: 4 active
              
                 [5] 33000000031f26ca3   40GiB   XtremIO XtremApp
                     status: used, paths: 4 active
              
               Please select the destination LUN (1, 2, 3, 4, 5) [1]: 

You can select one and proceed with engine VM setup. That LUN will be used only for the engine VM and would not be available for other usages.

#### VDSM commands involved

getDeviceList 3

## Benefit to oVirt

Users will be able to use FC storage as data domain for Hosted Engine.

## Dependencies / Related Features

*   A tracker bug has been created for tracking issues:

## Documentation / External references

The engine VM image will be preallocated so the LUN should be sized to contain it, at least 5 additional GiB are needed for ancillary structures. The LUN will be used only by the engine VM, no other usage are possible.

## Testing

On a FC capable HW try to deploy the engine VM over FC.

## Contingency Plan

Currently all the changes required for this feature are in a single patch. If it won't be ready it won't be merged.

## Release Notes

      ==Self Hosted Engine FC Support==
`Hosted Engine has now added support for `[`FC` `storage`](/develop/release-management/features/sla/self-hosted-engine-fc-support.html)



[Self Hosted Engine FC Support](/develop/release-management/features/)

