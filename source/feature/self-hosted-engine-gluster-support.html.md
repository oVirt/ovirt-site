---
title: Self Hosted Engine Gluster Support
category: feature
authors: sandrobonazzola
wiki_category: Feature|Self Hosted Engine Gluster Support
wiki_title: Features/Self Hosted Engine Gluster Support
wiki_revision_count: 16
wiki_last_updated: 2015-04-03
feature_name: Self Hosted Engine Gluster Support
feature_modules: ovirt-hosted-engine-setup
feature_status: POST
---

# Self Hosted Engine Gluster Support

### Summary

This feature enable the user to use Gluster storage for Hosted Engine data domain.

### Owner

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

### Detailed Description

##### UX changes

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs 
               Please note that Replica 3 support is required for the shared storage.
               Please specify the full shared storage connection path to use (example: host:/path): 192.168.1.107:/hosted_engine_glusterfs

### Benefit to oVirt

Users will be able to use Gluster storage as data domain for Hosted Engine.

### Dependencies / Related Features

*   [Features/Gluster_Support](Features/Gluster_Support)
*   [Features/GlusterFS Storage Domain](Features/GlusterFS Storage Domain)

### Documentation / External references

*   [Gluster Storage Domain Reference](Gluster Storage Domain Reference)

### Testing

Test plan still to be created

### Contingency Plan

Currently all the changes required for this feature are in a single patch. If it won't be ready it won't be merged.

### Release Notes

      ==Self Hosted Engine Gluster Support==
`Hosted Engine has now added support for `[`Gluster` `storage`](Features/Self_Hosted_Engine_Gluster_Support)

### Comments and Discussion

*   Refer to [Talk:Self Hosted Engine Gluster Support](Talk:Self Hosted Engine Gluster Support)

[Self Hosted Engine Gluster Support](Category:Feature) [Self Hosted Engine Gluster Support](Category:oVirt 3.6 Proposed Feature)
