---
title: LowerResolutionSupport
category: feature
authors: awels, ecohen
wiki_category: Feature
wiki_title: Features/Design/LowerResolutionSupport
wiki_revision_count: 8
wiki_last_updated: 2014-04-30
---

# Lower resolution support

### Summary

The web admin interface and to some degree also the user portal interface are not displayed properly in lower resolutions such as 1024x768. When resolutions are lower, the tab bar and action menu wrap overlapping other UI elements. This feature solves this issue by adding a scrollable tab bar for the tabs and a cascading menu bar for the action menu.

### Owner

*   Name: [Alexander Wels](User:awels)
*   Email: <awels@redhat.com>

### Current status

*   **Complete**: Identify existing issues
*   **Complete**: Design solution based on the existing issues
*   In Progress: Implement proposed solution.

# Existing problems

### Tab bar wraps when the resolution is low

Currently in the web admin when the resolution is too low to hold all the tabs, the tabs wrap onto the next line and overlap the action bar. This is illustrated here: ![](overlap_tab_highlight.png "fig:overlap_tab_highlight.png")

In addition to this the action button bar does the same thing, as illustrated here: ![](overlap_action_highlight.png "fig:overlap_action_highlight.png")

<Category:Feature>
