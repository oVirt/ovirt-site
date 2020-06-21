---
title: Image Manipulator
authors: smizrahi
---

<!-- TODO: Content review -->

# Image Manipulator

The Image Manipulation is layered to allow flexibility and for maximum code reuse. The first layer is the Repository Engine. Repository Engines Abstract the creation, deletion and manipulation of Tags and Volumes. The Image Manipulator uses the Repository Engines operations to compose high level Image centric operations.

## Terminology

The algorithm uses two major object types: Tags and Volumes. Tag is the only user facing object. They are just metadata. Tags have the following metadata:

*   *Tag ID* - Used to find the object.
*   *Size* - The Logical size of the image pointed to by the tag.
*   *Mutable* - Whether the underlying volume can be modified by an operation. This doesn't mean that the actual bits have to stay the same but rather that no operation can change the resulting disk image.
*   *Strategy* - Help the image manipulator decide how to perform several high level operations.
*   *Options* - Other low lever options that might affect how the image manipulator decides to perform higher level tasks.
*   *Tag Type* - Can either be 'strong' or 'weak'. Only strong tags can be accessed by the user. Weak tags are only accessible internally.
*   *Tag State* - Can be 'optimized', 'degraded', 'broken'. "Optimized" means that the undelying volume is operational and it's in an optimal state according to various factors. "Degraded" means that the volume is fully operational but might not perform optimally. "broken" means that the underlying volume is either incomplete or corrupted.
*   *Volume ID* - The volID this tag is pointing to. This data is not exposed to the user.

Volumes are slabs of data and associated metadata. Volumes are accessed using a Volume ID which is unique in a repository. Volumes are simpler objects and have the following metadata

*   *Parent* - A Tag ID of a tag that I is a logical relative. Even though the volume might not actually need data from the parent. We keep that information for every volume.
*   *Format* - The format with which the data is stored on the slab of data currently only "raw" and "qcow2" are supported.

## Image Repository

Image Repositories need to supply the abilities to handle tags and volumes. The basic interface every repository needs to implement is. All operations must be atomic!

createVolume(size, metadata) - returns an id to an already locked volume with the metadata attached. deleteVolume(volId) - deletes the specified volume.

readVolumeMetadata(volId) - read the volume metadata. writeVolumeMetadata(volId, metadata) - change the volume metadata.

lockVolume(volId) - try and acquire the cluster lock of the volume. unlockVolume(volId) - release the cluster wide lock.

createTag(metadata) - creates a tag with the specified metadata. deleteTag(tagId) - delete the specified tag.

readTag(tagId) - read the metadata stored in the specified tag. changeTag(tagId, metadata) - Change the metadata in the tag. This replaces the entire metadata with the new object.

writeUserData(tagId, data) - attaches user data to the tag. readUserData(tagId) - reads the userdata attached to the tag.

repos might have more specialized operations but this is the bare minimum.

## Low Level Operations and Recovery

All high level operations must be composed out of the following more basic operations. These operations are just basic templates and don't specify the actual content or format of the volume and assume only the most basic of functionality exists. This is a must in order to keep the higher level operations flexible.

All low level operations should be able to fail at any point and return to a consistent state without any information that is not on the domain itself.

### Basic Structure

![](/images/wiki/RepoLegend.png)

These are operations that can be used

### Add New

Adds a new Tag and volume that might depend on another existing Tag and Volume pair. If the new volume has no parent assume the initial state is empty and the volume is not pointing to any tags.

1.  Initial state
2.  Create a volume using (createVolume) that points to the parent tag
3.  Create a weak tag pointing to the new volume
    -   At this point you can start filling the volume with data, putting in the user data and other operations.

4.  .Change the tag from weak to strong. (Seals the deal)

![](/images/wiki/Im_op_add_child.png)

### Switcheroo

Creates a new volume and makes it the one pointed to by the existing tag and creates a new tag to point to the existing volume. This is useful for qcow2 snapshots where the new created file is actually the new head and the old file is the new "snapshot" object.

1.  Initial state
2.  Lock base volume
3.  Create a weak tag pointing to base volume.
4.  Create a new volume pointing to the new tag.
5.  Change the volume ID in the original tag to point to the new volume
6.  Seal the deal
    -   Change the new tag from weak to strong
    -   Alternatively for cross domain operations, you will do an "Add New" on second domain and copy the data from the old volume between stage 3 and 4.

![](/images/wiki/Im_op_switch.png)

### Delete Image

This doesn't really delete the image but rather makes it in accessible from the outside. Whether VDSM will actually delete the bits is a while different story.

1.  Initial State
2.  Lock the volume
3.  Turn the tag to a weak tag

![](/images/wiki/Im_op_delete_image.png)

### Delete Orphan volume

If a volume is not reference by any tag weak of strong it can be safely deleted.

1.  Initial State
2.  Lock volume
3.  Delete volume

![](/images/wiki/Im_op_delete_orphan_volume.png)

### Delete Weak Tip

If a weak tah is not referenced by any volume it can be safely assume that no one will ever use it and it can be removed.

1.  Initial State
2.  Lock volume
3.  Delete tag

Note that you can't just roll to delete orphan without making sure the volume is actually and orphan now!

![](/images/wiki/Im_op_delete_weak_tip.png)

### Delete Single Linked

If a weak tag has only 1 dependent the two volumes can be merged and the tag removed.

1.  Initial State
2.  Lock the volume pointed to by the weak tag
3.  Lock the volume pointing to the tag
4.  Either merge up or down depending on what is best according to the data inside the volumes
5.  Reparent according to merge direction in previous phase

![](/images/wiki/Im_op_delete_single_linked.png)

### Convert \\ Replace

This is used to either convert or replace a volume with new data.

1.  Initial state
2.  Lock original volume
3.  Create new volume
    -   Push new data to the new volume

4.  Change the tag to point to the new volume. (Seals the deal)

![](/images/wiki/Im_op_convert_replace.png)

### Reparent

Sometimes the content of the volume doesn't really depend on it's immediate parent. This means that if the parent is weak we can just reparent to the grand parent so that the weak tag has as little of links as possible. This is preferable because the parent volume will only be deleted if no more then 1 volumes point to it's tag.

1.  Initial state
2.  Lock the volume you wish to reparent
3.  Change it's metadata (Seal the deal)

![](/images/wiki/Im_op_reparent.png)

## Repository Checker

Recovery is a per repository process. A user can run a checkRepo() command and it, in turn will return a list of problems with the current repo and FixInfo object with the data on how to fix them. The checking process doesn't take any locks so the data it return might not be up to date. For instance it might return that a volume is orphan but that was true only because it was in a middle of a low lever operation and technically there is no nothing to fix. The use can choose to use the FixInfo objects with the fixRepo() command to apply the suggested fix.

FixInfo objects contain a field call FixType that hints to the nature of the fix.

*   clean - Cleans data, run those to get more free space.
*   optimize - Does an opration that will help towards moving an image to a better status degraded->optimized.
*   merge - Merges two images together. Doing this sometimes make more images ready optimizing or cleaning. The reason it is different from optimize is that unmerged images are considered optimized.
*   mend - Mends a broken image, you should perform these to eliminate fixable broken images.

This is helpful because if the users priority is freeing up space it could only apply "clean" fixes. If you are having spare resources in a host you can choose to run "optimize" fixes that might hog resources otherwise.

The "operation" and "parameter" fields shouldn't be used modified or created by the user. VDSM will check those for sanity so there isn't a risk of that corrupting the repo but the client does not have enough information at any point in order to conjure up these objects.

When running a fix VDSM will try and perform the fix. No matter if the task failed or succeeded the new sate might change the Fix so the user should recheck the repo and get new FixIno objects before retrying.

There is no "classic" recovery. VDSM will continually aspire to reach and optimized clean state. This means that if you copied an image between domains and the source domain disappeared forever. VDSM will keep reporting a "mend" Fix on the target image. In order to "cancel" the operation you need to remove the broken image. On the other hand, if the source image happens to appear after a decade. VDSM will be able to complete the task.
