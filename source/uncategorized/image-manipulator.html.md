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

Image Repositories need to supply the abilities to handle tags and volumes. The basic interface every repository needs to implement is.

createVolume

The following algorithms don't care what is in the Volume or what metadata sits on the Volume or the Tag except for the "pointing" information.

A Tag **must** point to a volume and a volume **can** point to a tag.

All high level operations must use the following low level operations. Using these operations guarantees saftey and recoverability.
