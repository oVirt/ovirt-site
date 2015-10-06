---
title: Self Hosted Engine Hyper Converged Gluster Support
category: feature
authors: sandrobonazzola
wiki_category: Feature|Self Hosted Engine Hyper Converged Gluster Support
wiki_title: Features/Self Hosted Engine Hyper Converged Gluster Support
wiki_revision_count: 7
wiki_last_updated: 2015-03-17
feature_name: Self Hosted Engine Hyper Converged Gluster Support
feature_modules: ovirt-hosted-engine-setup
feature_status: POST
---

# Self Hosted Engine Hyper Converged Gluster Support

### Summary

This feature enable the user to use Hyper Converged Gluster storage for Hosted Engine data domain.

### Owner

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

### Detailed Description

##### UX changes

Using an existing Gluster storage:

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs 
               Do you want to configure this host for providing GlusterFS storage? (Yes, No)[No]:
               Please note that Replica 3 support is required for the shared storage. 
               Please specify the full shared storage connection path to use (example: host:/path): 192.168.1.107:/hosted_engine_glusterfs

Provisioning Gluster storage on the same host for Hyper Converged support:

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs
               Do you want to configure this host for providing GlusterFS storage? (Yes, No)[No]: yes
               Please provide the path to be used for creating the brick (/path): /he
               Further instructions are available on ....

##### Config files changes

According to <http://www.ovirt.org/Features/GlusterFS_Storage_Domain#Important_Pre-requisites> the only required change is to add

       option rpc-auth-allow-insecure on

to ***/etc/glusterfs/glusterd.vol***

By default gluster uses a port that vdsm also wants, so we need to change base-port setting avoiding the clash between the two daemons. We need to add

       option base-port 49217

to ***/etc/glusterfs/glusterd.vol***

and ensure glusterd service is enabled and started before proceeding.

##### Engine Changes

*   The iptables port range to be opened for Gluster must include enough ports starting at base-port for the briks.

##### VDSM commands involved

*   glusterVolumesList
*   glusterVolumeCreate
*   glusterVolumeSet
*   glusterTasksList
*   glusterVolumeStart

The rest is quite similar to GlusterFS storage.

### Benefit to oVirt

Users will be able to use Gluster Hyper Converged storage as data domain for Hosted Engine.

### Dependencies / Related Features

*   [Features/Gluster_Support](Features/Gluster_Support)
*   [Features/GlusterFS Storage Domain](Features/GlusterFS Storage Domain)
*   [Features/Self Hosted Engine Gluster Support](Features/Self Hosted Engine Gluster Support)
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
`Hosted Engine has now added support for `[`Hyper` `Converged` `Gluster` `storage`](Features/Self_Hosted_Engine_Hyper_Converged_Gluster_Support)

### Comments and Discussion

*   Refer to [Talk:Self Hosted Engine Gluster Support](Talk:Self Hosted Engine Gluster Support)

[Self Hosted Engine Hyper Converged Gluster Support](Category:Feature) [Self Hosted Engine Hyper Converged Gluster Support](Category:oVirt 4.0 Proposed Feature) [Self Hosted Engine Hyper Converged Gluster Support](Category:Integration)
