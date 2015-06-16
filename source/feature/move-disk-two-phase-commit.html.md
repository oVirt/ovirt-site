---
title: Move Disk Two Phase Commit
category: feature
authors: mlipchuk
wiki_category: Feature
wiki_title: Features/Move Disk Two Phase Commit
wiki_revision_count: 1
wiki_last_updated: 2013-07-08
---

# Move Disk

### Summary

Adding two phase commit functionality when moving a disk

### Owner

*   Name: [Maor Lipchuk](User:mlipchuk)
*   Email: mlipchuk@redhat.com

### Detailed Description

Images which are not able to be marked as deleted in the storage by VDSM should be marked as Illegal in the engine DB, so user will be able to delete them again. un-succeeded deletion can be on move operation (When the original copy is deleted at the end of the process) The purpose of this feature is to solve an issue when images will be blocked from being removed since other shared volumes still hasn't been removed from the storage (for example a template which has based VM images related to it). To prevent a scenario, which those images are no longer in the DB, we should leave those images in the DB until they are marked as removed in the storage.

Related bug : <https://bugzilla.redhat.com/show_bug.cgi?id=978975>

#### DB

We will need a new table since the temporary disk which will reflect the about to be delete image, must be with a different image id and image group id then the source image that moved.
when we will want to delete it w will need to pass the VDSM the original image id and source storage id to delete from, that is why we link the new generated image id to the source image id and the storage id.

*   Images_To_Be_Deleted - A new table that reflect images which are about to be deleted.

| Column Name           | Column Type | Null? / Default | Definition                                   |
|-----------------------|-------------|-----------------|----------------------------------------------|
| image_id             | UUID        | PK(not null)    | The new image id of the temporary image      |
| src_image_id        | UUID        | not null        | The source image id                          |
| src_image_group_id | UUID        | not null        | The source_image_group_id                 |
| src_storage          | UUID        | not null        | The source storage of the source image       |
| dest_storage         | UUID        | not null        | The destination storage of the source image  |
| _create_date        | Date        | not null        | The creation date of the image to be deleted |

*   [1] new stored procedure to check if the illegal disk has the same storage id as the original disk

Input - image_id:

      SELECT all_disks.image_id
      FROM IMAGES_TO_BE_DELETED WHERE ITBD,all_disks 
      WHERE all_disks.storage_id - src_storage
       AND all_disks.image.id = ITBD.src_image_id
       AND image_id = all_disks.image.id

All stored procedures which use image_id and image_group_id and add to them a query for Image_to_be_deleted

### background info

Today we have two separated operations :

1) copy (CopyImageVDSCommand) - This command is being used to copy and collapse all snapshots of the disk to a new image with a new imageId and ImageGroupId

2) move operation \\ copy without collapse (MoveImageGroupVDSCommand) - This command is being used to copy a volume without collapsing its snapshots, it simply moves the image and all its volumes from one storage to another. changing its ImageId/ImageGroupId.

For move operation we now use, copy the volumes without with the same image id.

### Backend

There will be three phases in the execute process:
\* phase 1:

      new transaction will create a new image as part of moveImageGroup execution
      the disk will be copied from the source disk with the following changes:
      a. Set status in locked (With compensation to Illegal
      b. set new image guid
      c. The alias name will be with suffix of "To_Be_Deleted"
      d. Adding a new row in Images_to_be_deleted

*   phase 2:

      Call VDS command of MoveImageGroupVDSCommand

*   phase 3:

      update all snapshots of source image to be with the destination storage (as part of command transaction)

Ending Actions
End with success - removing the new disk from the DB and from the Image_to_Be_Deleted
End with failure - Check if the image exists in the source storage, if so will change the disk to ILLEGAL

#### engine/VDSM failues handling

*   If we will fail before phase 1 -

       No new images has created and no VDSM operations has been done. - safe

*   If we will fail between phase 1 and phase 2 -

      status:
      A new ILLEGAL disk will be created
      The original disk will still be on the original storage
      No VDSM operations will be done

      result: User will try to remove the illegal disk with [1] and will only remove the illegal disk form the DB.

*   If we fail between phase 2 and phase 3 / after phase 3 before commit

      status:
      A new ILLEGAL disk will be created
      VDSM task of copy will be running
      The original disk will still be on the original storage

      after engine will be started again, compensation will fail the task and will call EndWithFailure
      EndWithFailure will call removeImage from the destination storage (For now we are counting that remove will succeed)

#### UI

undeleted image from the storage should be reflected in the engine with ILLEGAL status

### Comments and Discussion

We should check if the feature is compatible with the Quota.

<Category:Feature>
