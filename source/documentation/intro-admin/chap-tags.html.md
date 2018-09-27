---
title: Tags
---

# Tags

## Using Tags to Customize Interactions with oVirt

After your oVirt platform is set up and configured to your requirements, you can customize the way you work with it using tags. Tags allow system resources to be arranged into groups or categories. This is useful when many objects exist in the virtualization environment and the administrator wants to concentrate on a specific set of them.

This section describes how to create and edit tags, assign them to hosts or virtual machines and search using the tags as criteria. Tags can be arranged in a hierarchy that matches a structure, to fit the needs of the enterprise.

To create, modify, and remove Administration Portal tags, click the **Tags** icon (![Tag](/images/intro-admin/Tag.png)) in the header bar.

## Creating a Tag

Create tags so you can filter search results using tags.

**Creating a Tag**

1. Click the **Tags** icon (![Tag](/images/intro-admin/Tag.png)) in the header bar.

2. Click **Add** to create a new tag, or select a tag and click **New** to create a descendant tag.

3. Enter the **Name** and **Description** of the new tag.

4. Click **OK**.

## Modifying a Tag

You can edit the name and description of a tag.

**Modifying a Tag**

1. Click the **Tags** icon (![Tag](/images/intro-admin/Tag.png)) in the header bar.

2. Select the tag you want to modify and click **Edit**.

3. Change the **Name** and **Description** fields as necessary.

4. Click **OK**.

## Deleting a Tag

When a tag is no longer needed, remove it.

**Modifying a Tag**

1. Click the **Tags** icon (![Tag](/images/intro-admin/Tag.png)) in the header bar.

2. Select the tag you want to delete and click **Remove**. A message warns you that removing the tag will also remove all descendants of the tag.

3. Click **OK**.

You have removed the tag and all its descendants. The tag is also removed from all the objects that it was attached to.

## Adding and Removing Tags to and from objects

You can assign tags to and remove tags from hosts, virtual machines, and users.

**Adding and Removing Tags to and from Objects**

1. Select the object(s) you want to tag or untag.

2. Click **More Actions** &rarr; **Assign Tags**.

3. Select the check box to assign a tag to the object, or clear the check box to detach the tag from the object.

4. Click **OK**.

The specified tag is now added or removed as a custom property of the selected object(s).

## Searching for Objects Using tags

Enter a search query using `tag` as the property and the desired value or set of values as criteria for the search.

The objects tagged with the specified criteria are listed in the results list.

**Prev:** [Chapter 3: Bookmarks](../chap-bookmarks)<br>

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/introduction_to_the_administration_portal/chap-tags)
