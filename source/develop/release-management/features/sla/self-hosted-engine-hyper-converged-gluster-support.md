---
title: Self Hosted Engine Hyper Converged Gluster Support
category: feature
authors: sandrobonazzola,sabose
---

# Self Hosted Engine Hyper Converged Gluster Support

## Summary

This feature enable the user to use Hyper Converged Gluster storage for Hosted Engine data domain. The gluster volume resides on the same host where the hosted engine will be deployed. Provisioning of the gluster volume is not part of the hosted engine deployment process. This is done either manually or via [gdeploy](http://gdeploy.readthedocs.io)

## Owner

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

Refer [Features/Self Hosted Engine Gluster Support](/develop/release-management/features/sla/self-hosted-engine-gluster-support.html) for pre-requisites and changes

## Benefit to oVirt

Users will be able to use Gluster Hyper Converged storage as data domain for Hosted Engine.

## Pending issues

*   Provide a way to input gluster mount options via UX in hosted engine deployment
*   Gluster ports should be opened while setting up host if hyper-converged host

## Dependencies / Related Features

*   [Features/Gluster_Support](/develop/release-management/features/gluster/gluster-support.html)
*   [Features/GlusterFS Storage Domain](/develop/release-management/features/storage/glusterfs-storage-domain.html)
*   [Features/Self Hosted Engine Gluster Support](/develop/release-management/features/sla/self-hosted-engine-gluster-support.html)
*   A tracker bug has been created for tracking issues:

## Documentation / External references

*   [Gluster Home Page](http://www.gluster.org/)
*   [Gluster Storage Domain Reference](/documentation/administration_guide/index.html#Adding_Red_Hat_Gluster_Storage)

## Testing

Test plan still to be created

## Release Notes

```
# Self Hosted Engine Gluster Support

Hosted Engine has now added support for [Hyper Converged Gluster storage](/develop/release-management/features/sla/self-hosted-engine-hyper-converged-gluster-support.html)


