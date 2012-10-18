---
title: Image Manipulator
authors: smizrahi
wiki_title: Image Manipulator
wiki_revision_count: 9
wiki_last_updated: 2012-10-26
---

# Image Manipulator

The Image Manipulation is layered to allow flexibility and for maximum code reuse. The first layer is the Repository Engine. Repository Engines Abstract the creation, deletion and manipulation of Tags and Volumes. The Image Manipulator uses the Repository Engines operations to compose high level Image centric operations.

## Object Tree

The algorithm uses two major object types: Tags and Volumes. Tag is the only user facing object. They are just metadata. Tags are accesses using a Tag ID, a Tag ID is unique in a repository (But not necessarily across repositories). Volumes are slabs of data and associated metadata. Volumes are accessed using a Volume ID which is unique in a repository.

The following algorithms don't care what is in the Volume or what metadata sits on the Volume or the Tag except for the "pointing" information.

A Tag **must** point to a volume and a volume **can** point to a tag.

All high level operations must use the following low level operations. Using these operations guarantees saftey and recoverability.
