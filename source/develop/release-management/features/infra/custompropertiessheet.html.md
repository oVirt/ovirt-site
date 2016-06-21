---
title: CustomPropertiesSheet
category: feature
authors: ecohen, ekohl, gchaplik
wiki_category: Feature
wiki_title: Features/CustomPropertiesSheet
wiki_revision_count: 8
wiki_last_updated: 2012-06-12
---

# Custom Properties Sheet

## Summary

The Custom Properties for a VM are edited in the GUI via the "Custom Properties" section within the New/Edit VM dialog. Currently this section contains a plain text-box, which should be filled according to a very specific format. In order to improve user experience, we want to beautify the "Custom Properties" section.

This is a pure GUI/UX feature

## Owner

*   Name: [ Gilad Chaplik](User:Gchaplik)
    -   Email: <gchaplik@redhat.com>

## Current Status

*   Status: Merged upstream.
*   Last updated date: May 21, 2012

## Description

Here are the mock-ups for the updated "Custom Properties" section as it should appear in the New/Edit VM dialog:

### Initial State

![](Custompropertiesinitialstate.png "Custompropertiesinitialstate.png")

------------------------------------------------------------------------

### Choosing a Key

![](Custompropertiesfirstkey.png "Custompropertiesfirstkey.png")

------------------------------------------------------------------------

### Adding/Removing a Row

![](Custompropertiesaddrow.png "Custompropertiesaddrow.png")

------------------------------------------------------------------------

### Full Custom Properties Sheet

![](Custompropertiesfull.png "Custompropertiesfull.png")

------------------------------------------------------------------------

## Open Issues

*   Sorting:
    -   Should custom properties be sorted/ordered?
    -   If so, how? Automatic sort (i.e. alphabetical sort according to key name upon dialog load) or letting the user move items up/down?

<Category:Feature>
