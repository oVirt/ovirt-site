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

Using an existing Gluster storage:

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs 
               Do you want to configure this host for providing GlusterFS storage (requires 3 bricks)? (Yes, No)[No]: 
               Please specify the full shared storage connection path to use (example: host:/path): 192.168.1.107:/hosted_engine_glusterfs

Provisioning Gluster storage on the same host:

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs
               Do you want to configure this host for providing GlusterFS storage (requires 3 bricks)? (Yes, No)[No]: yes
               Please provide a comma separated list of 3 bricks (host1:/path1,host2:/path2,host3:/path3): 192.168.1.5:/he,192.168.1.6:/he,192.168.1.7:/he

##### Config files changes

According to <http://www.ovirt.org/Features/GlusterFS_Storage_Domain#Important_Pre-requisites> the only required change is to add

       option rpc-auth-allow-insecure on

to ***/etc/glusterfs/glusterd.vol***

and ensure glusterd service is enabled and started before proceeding.

##### VDSM commands involved

*   glusterVolumesList
*   glusterVolumeCreate
*   glusterVolumeSet
*   glusterTasksList
*   glusterVolumeStart

The rest is quite similar to NFS storage.

### Benefit to oVirt

Users will be able to use Gluster storage as data domain for Hosted Engine.

### Dependencies / Related Features

*   [Features/Gluster_Support](Features/Gluster_Support)
*   [Features/GlusterFS Storage Domain](Features/GlusterFS Storage Domain)
*   GlusterFS 3.7 may have impact on this feature: [2015-04-29](http://www.gluster.org/community/documentation/index.php/Planning37)
*   A tracker bug has been created for tracking issues:

### Documentation / External references

*   [Gluster Home Page](http://www.gluster.org/)
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
