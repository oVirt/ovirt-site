---
title: Orphaned Images
category: feature
authors: dyasny
wiki_category: Feature
wiki_title: Features/Orphaned Images
wiki_revision_count: 2
wiki_last_updated: 2012-05-17
---

# Orphaned Images

## Summary

This feature will provide the answer to VM disk images that for some reason no longer belong to any VM or template, and are not legally detached, detecting such images, reporting and removing them.

## Owner

*   Name: [ Dan Yasny](User:Dyasny)

<!-- -->

*   Email: <dyasny _AT_ redhat _DOT_ com>

## Current status

*   Target Release: N/A
*   Status: Planning
*   Last updated date: N/A

## Detailed Description

During normal disk operations, for various reasons, a disk might be removed from the Engine database, but will nonetheless linger on the actual storage, taking up space and causing confusion when the storage domains' stats are reviewed. This can happen due to a disk remove task failing at some point, snapshot images not removed after having been collapsed etc. Such images, that are no longer known to the oVirt engine because they are not in the database, but are still physically present on the storage are defined as "Orphaned" and should be specifically treated to free up space and maintain order.

## Benefit to oVirt

Stabilize the system functionality addressing the corner cases where disk removal failed to complete successfully.

## User Experience

The user will issue a command specifying the Storage Domain or Data Centre to search for orphaned images on. Then the user will be presented with the list of images detected on the SD, that do not appear in the database, and the image details The user will have the option to clean the specified SD of orphaned images.

The command will be present as a utility in the Engine - engine-clean-orhaned-images

Example usage:

      engine-clean-orhaned-images --storage-domain=MySD
      Found 3 orphaned images:
      Domain:                                         Image:
      MySD (6b53ea3d-3ec6-40f3-86d7-b7fdfea1dda2)     aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa (100Gb)
      MySD (6b53ea3d-3ec6-40f3-86d7-b7fdfea1dda2)     bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb (150Gb)
      MySD (6b53ea3d-3ec6-40f3-86d7-b7fdfea1dda2)     cccccccc-cccc-cccc-cccc-cccccccccccc (80Gb)
      Space cleared after cleanup: 330Gb
      Proceed [N] Yes/No/Interactive: Y
       Cleaning up ...
      Cleared 3 images, 330Gb on Domain MySD (6b53ea3d-3ec6-40f3-86d7-b7fdfea1dda2)

Interactive will ask about every image one by one.

## Installation/Upgrade

No impact, should be part of the engine installation, just like the engine-iso-uploader package is

## Dependencies / Related Features and Projects

A full blown storage garbage collection feature will make this feature obsolete

<Category:Feature> <Category:Orphaned_Images>
