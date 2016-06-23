---
title: Self Hosted Engine Gluster Support
category: feature
authors: sandrobonazzola
wiki_category: Feature|Self Hosted Engine Gluster Support
wiki_title: Features/Self Hosted Engine Gluster Support
wiki_revision_count: 17
wiki_last_updated: 2015-10-06
feature_name: Self Hosted Engine Gluster Support
feature_modules: ovirt-hosted-engine-setup
feature_status: ON_QA
---

# Self Hosted Engine Gluster Support

## Summary

This feature enable the user to use Gluster storage for Hosted Engine data domain.

## Owner

*   Name: [ Sandro Bonazzola](User:SandroBonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

#### UX changes

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs 
               Please note that Replica 3 support is required for the shared storage.
               Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/glusterfs

## Benefit to oVirt

Users will be able to use Gluster storage as data domain for Hosted Engine.

## Dependencies / Related Features

*   [Features/Gluster_Support](Features/Gluster_Support)
*   [Features/GlusterFS Storage Domain](Features/GlusterFS Storage Domain)
*   A tracker bug has been created for tracking issues:

## Documentation / External references

### Documentation

## Configuring the Self-Hosted Engine

### Configuring Storage

#### GlusterFS

For GlusterFS storage types, specify the full address, using either the FQDN or IP address, and path name of the shared storage domain.

         Please note that Replica 3 support is required for the shared storage.
         Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine_glusterfs

Requirements:

*   The GlusterFS Volume must be configured for Replica 3
    -   Replica 3 may be verified using gluster command line or using VDSM client / API applying <http://gerrit.ovirt.org/36783>:

`gluster volume info `<volname>` --remote-host=`<server-name>
`vdsClient -s 0 glusterVolumesList volumeName=`<volname>` remoteServer=`<server-name>

*   According to <http://www.ovirt.org/Features/GlusterFS_Storage_Domain#Important_Pre-requisites> the only required change is to add to /etc/glusterfs/glusterd.vol

         option rpc-auth-allow-insecure on

*   The volume must be configured as following:

        gluster volume set `<volume>` cluster.quorum-type auto
        gluster volume set `<volume>` network.ping-timeout 10
        gluster volume set `<volume>` auth.allow \*
        gluster volume set `<volume>` group virt
        gluster volume set `<volume>` storage.owner-uid 36
        gluster volume set `<volume>` storage.owner-gid 36
        gluster volume set `<volume>` server.allow-insecure on

### References

*   [Gluster Storage Domain Reference](Gluster Storage Domain Reference)

## Testing

*   [QA:TestCase Hosted Engine External Gluster Support](QA:TestCase Hosted Engine External Gluster Support)

## Contingency Plan

Currently all the changes required for this feature are in a single patch: <http://gerrit.ovirt.org/36264>. If it won't be ready it won't be merged.

## Release Notes

      ==Self Hosted Engine Gluster Support==
`Hosted Engine has now added support for `[`Gluster` `storage`](Features/Self_Hosted_Engine_Gluster_Support)

## Comments and Discussion

*   Refer to [Talk:Self Hosted Engine Gluster Support](Talk:Self Hosted Engine Gluster Support)

[Self Hosted Engine Gluster Support](Category:Feature) [Self Hosted Engine Gluster Support](Category:oVirt 3.6 Feature) [Self Hosted Engine Gluster Support](Category:oVirt 3.6 Proposed Feature) [Self Hosted Engine Gluster Support](Category:HostedEngine) [Self Hosted Engine Gluster Support](Category:Integration)
