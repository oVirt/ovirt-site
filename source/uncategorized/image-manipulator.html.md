---
title: Image Manipulator
authors: smizrahi
wiki_title: Image Manipulator
wiki_revision_count: 9
wiki_last_updated: 2012-10-26
---

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

## Low Lever Operations and Recovery

All high level operations must be composed out of the following more basic operations. These operations are just basic templates and don't specify the actual content or format of the volume and assume only the most basic of functionality exists. This is a must in order to keep the higher level operations flexible.

All low level operations should be able to fail at any point and return to a consistent state without any information that is not on the domain itself.
