---
title: Self Hosted Engine Hyper Converged Gluster Support
category: feature
authors: sandrobonazzola,sabose
wiki_category: Feature|Self Hosted Engine Hyper Converged Gluster Support
wiki_title: Features/Self Hosted Engine Hyper Converged Gluster Support
wiki_revision_count: 8
wiki_last_updated: 2015-10-06
feature_name: Self Hosted Engine Hyper Converged Gluster Support
feature_modules: ovirt-hosted-engine-setup
feature_status: POST
---

# Self Hosted Engine Hyper Converged Gluster Support

## Summary

This feature enable the user to use Hyper Converged Gluster storage for Hosted Engine data domain. The gluster volume resides on the same host where the hosted engine will be deployed. Provisioning of the gluster volume is not part of the hosted engine deployment process. This is done either manually or via [gdeploy](http://gdeploy.readthedocs.io)

## Owner

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

Refer [Features/Self Hosted Engine Gluster Support](Features/Self Hosted Engine Gluster Support) for pre-requisites and changes

## Benefit to oVirt

Users will be able to use Gluster Hyper Converged storage as data domain for Hosted Engine.

## Pending issues

*   Provide a way to input gluster mount options via UX in hosted engine deployment
*   Gluster ports should be opened while setting up host if hyper-converged host

## Dependencies / Related Features

*   [Features/Gluster_Support](Features/Gluster_Support)
*   [Features/GlusterFS Storage Domain](Features/GlusterFS Storage Domain)
*   [Features/Self Hosted Engine Gluster Support](Features/Self Hosted Engine Gluster Support)
*   A tracker bug has been created for tracking issues:

## Documentation / External references

*   [Gluster Home Page](http://www.gluster.org/)
*   [Gluster Storage Domain Reference](Gluster Storage Domain Reference)

## Testing

Test plan still to be created

## Release Notes

      ==Self Hosted Engine Gluster Support==
`Hosted Engine has now added support for `[`Hyper` `Converged` `Gluster` `storage`](Features/Self_Hosted_Engine_Hyper_Converged_Gluster_Support)

## Comments and Discussion


[Self Hosted Engine Hyper Converged Gluster Support](Category:Feature) [Self Hosted Engine Hyper Converged Gluster Support](Category:oVirt 4.0 Proposed Feature) [Self Hosted Engine Hyper Converged Gluster Support](Category:Integration)
