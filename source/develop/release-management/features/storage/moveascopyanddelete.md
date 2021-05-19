---
title: MoveAsCopyAndDelete
category: feature
authors: laravot
---

# Move As Copy And Delete

## Move operation as copy and delete

### Summary

A move operation is basically a copy to the destination domain, followed by a deletion from the source domain. Currently, when moving a disk in oVirt, the called vdsm verb is `moveImage` - which performs the entire operation (copy and delete). The fact that one verb is called for executing both of the operations causes to few issues that would be resolved/improved by this change:

1. Increase availability - When moving an image and attempting to delete with wipe - the operation won't wait for the deletion to complete, as it might take a long time although the image in the target domain is already "ready" for use (as the copy operation has been completed).

2. In case of an error, the engine will be able to tell on which part of the "move" operation an error has occurred and react accordingly.

3. Moving towards lowering the SPM involvement in the copy/move process.

4. Move operation on vdsm should be deprecated.

### Owner

*   Name: Liron Aravot (laravot)
*   Email: <laravot@redhat.com>

### Current status

*   Released in oVirt 3.3, see <http://gerrit.ovirt.org/#/c/13042> for details

### Detailed Description

1. Add `MoveImageGroupCommand` - used for moving images, the execution part (a.k.a, the `execute()` method) contains a call to vdsm to copy the image to the target domain, while the end method executes a vdsm call for deletion of the unneeded image (in case of successful copy - the source image, in case of failure during the copy - the target image).

2. `MoveOrCopyImageGroupCommand` has been renamed to `CopyImageGroupCommand` and is being used now for copy only.

3. `moveImage` verb in vdsm is being executed from the engine with copy as its operation only (used for copy without collapsing snapshots).

4. `RemoveImageCommand` has been changed to allow removal of image without performing DB modification (in case of performing move, the called delete on the end method is for storage "cleanup" and shouldn't affect the db.

### Benefit to oVirt

Ability to determine the state of the move operation, have faster operation when performing move with wipe (post zero).

### Known issues

*   The whole operation *might* be slower for moving image groups without wipe, as the delete part is quick (and now we will have two vdsm calls rather then one) - this issue is known and accepted.
