---
title: Self Hosted Engine Gluster Support
category: feature
authors: sandrobonazzola, sabose
feature_name: Self Hosted Engine Gluster Support
feature_modules: ovirt-hosted-engine-setup
feature_status: ON_QA
---

# Self Hosted Engine Gluster Support

## Summary

This feature enable the user to use Gluster storage for Hosted Engine data domain.


## Owner

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

#### UX changes
For GlusterFS storage types, specify the full address, using either the FQDN or IP address, and path name of the shared storage domain

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (glusterfs, iscsi, nfs3, nfs4)[nfs3]: glusterfs 
               Please note that Replica 3 support is required for the shared storage.
               Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/glusterfs

#### Config files changes 
Hosted engine storage domain can use backup-volfile-servers option to mount the gluster volume. 
This can be provided to the hosted-engine deployment via an answer file (using --config-append option), as the UX currently does not prompt for it

```
   [environment:default]
   OVEHOSTED_STORAGE/mntOptions=str:backup-volfile-servers=server2:server3
```

## Benefit to oVirt

Users will be able to use Gluster storage as data domain for Hosted Engine.

## Dependencies / Related Features

*   [Features/Gluster_Support](/develop/release-management/features/gluster/gluster-support/)
*   [Features/GlusterFS Storage Domain](/develop/release-management/features/storage/glusterfs-storage-domain/)
*   A tracker bug has been created for tracking issues:

## Documentation / External references

### Documentation

## Configuring the Self-Hosted Engine

### Configuring Storage
Like any other gluster storage domain, the hosted engine storage domain on glusterfs requires a replica 3 gluster volume. For users that want to avoid the 3 way replica, replica 3 arbiter volume is also supported.

#### Pre-requisites


*   The GlusterFS Volume must be configured for Replica 3
    -   Replica 3 may be verified using gluster command line or using VDSM client / API applying <http://gerrit.ovirt.org/36783>:

`gluster volume info '<volname>' --remote-host='<server-name>'`

`vdsClient -s 0 glusterVolumesList volumeName='<volname>' remoteServer='<server-name>'`

*   The volume must be configured as per [Gluster Volume Options for Virtual Machine Image Store](documentation/admin-guide/chap-Working_with_Gluster_Storage#Options set on Gluster Storage Volumes to Store Virtual Machine Images)

*  Gluster volume has been started 
*  Gluster ports opened on all the gluster hosts


### References

*   [Gluster Storage Domain Reference](/documentation/admin-guide/gluster-storage-domain-reference/)

## Testing

*   [QA:TestCase Hosted Engine External Gluster Support](QA:TestCase Hosted Engine External Gluster Support)

## Release Notes

      ==Self Hosted Engine Gluster Support==
`Hosted Engine has now added support for `[`Gluster` `storage`](Features/Self_Hosted_Engine_Gluster_Support)



[Self Hosted Engine Gluster Support](/develop/release-management/features/) [Self Hosted Engine Gluster Support](Category:oVirt 3.6 Feature) [Self Hosted Engine Gluster Support](/develop/release-management/releases/3.6/proposed-feature/) [Self Hosted Engine Gluster Support](Category:HostedEngine) [Self Hosted Engine Gluster Support](Category:Integration)
